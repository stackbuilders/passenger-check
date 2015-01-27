{-# LANGUAGE OverloadedStrings #-}

module Main where


import qualified System.PassengerCheck.Health as H

import System.Console.GetOpt

import System.Environment (getArgs, getProgName)
import System.Exit (ExitCode(..), exitWith, exitSuccess)
import System.IO.Error (ioError)

import Paths_passenger_check (version)
import Data.Maybe (fromMaybe)

import Data.Version (showVersion)


import System.PassengerCheck.Types
import System.PassengerCheck.Parse

import Text.Parsec (parse)
import Text.Parsec.Error (ParseError)

import System.Nagios.Plugin

import System.Process (readProcess)

data Options = Options
    { optShowVersion :: Bool
    , optShowHelp    :: Bool
    } deriving Show

defaultOptions = Options
    { optShowVersion = False
    , optShowHelp    = False
    }

options :: [OptDescr (Options -> Options)]
options =
  [ Option ['V'] ["version"] (NoArg (\opts -> opts { optShowVersion = True }))
    "show version number"

  , Option ['h'] ["help"]    (NoArg (\opts -> opts { optShowHelp = True }))
    "show help"
  ]

showHelp = do
  prg <- getProgName
  putStrLn (usageInfo prg options)
  exitSuccess


headerMessage :: String -> String
headerMessage progName = "Usage: " ++ progName ++ " [OPTION...]"

getStatus :: Either ParseError PassengerStatus -> NagiosPlugin ()
getStatus (Left parseError) =
  addResult Unknown "Unable to parse passenger-status output"

getStatus (Right stat) = let (check, message) = H.status stat in
  addResult check message

runCheck :: IO ()
runCheck = do
  res <- readProcess "/usr/local/bin/passenger-status" [] []
  let parsed = parse statusOutputParser "(passenger-status)" res

  runNagiosPlugin (getStatus parsed)

checkOpts :: [String] -> IO (Options, [String])
checkOpts argv = do
  name <- getProgName

  case getOpt Permute options argv of
    (o, n, []  ) -> return (foldl (flip id) defaultOptions o, n)
    (_, _, errs) ->
      ioError (userError (concat errs ++ usageInfo (headerMessage name) options))


main :: IO ()
main = do
  opts <- getArgs >>= checkOpts

  name <- getProgName

  if optShowHelp $ fst opts
  then
    putStrLn $ usageInfo (headerMessage name) options
  else
    if optShowVersion $ fst opts then
      putStrLn $ name ++ " " ++ showVersion version ++
      " (C) 2015 Stack Builders Inc."
    else
      runCheck
