{-# LANGUAGE OverloadedStrings #-}

module Main where

import qualified System.PassengerCheck.Health as H

import System.PassengerCheck.Types
import System.PassengerCheck.Parse

import Text.Parsec (parse)
import Text.Parsec.Error (ParseError)

import System.Nagios.Plugin

import System.Process (readProcess)


getStatus :: Either ParseError PassengerStatus -> NagiosPlugin ()
getStatus (Left parseError) =
  addResult Unknown "Unable to parse passenger-status output"

getStatus (Right stat) = let (check, message) = H.status stat in
  addResult check message

main :: IO ()
main = do
  res <- readProcess "/usr/local/bin/passenger-status" [] []
  let parsed = parse statusOutputParser "(passenger-status)" res

  runNagiosPlugin (getStatus parsed)
