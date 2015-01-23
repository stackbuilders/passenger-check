{-# LANGUAGE OverloadedStrings #-}

module System.PassengerCheck.Parse (statusOutputParser) where

import Data.Text

import System.PassengerCheck.Types

import Text.Parsec
import Text.Parsec.String

import Text.ParserCombinators.Parsec.Char (string, space, newline)
import Text.ParserCombinators.Parsec.Token (integer)
import Control.Applicative ((<*>), (*>), (<$>), (<*))

colonSeparatedLine :: String -> Parser Integer
colonSeparatedLine lhsString =
  rd <$> (string lhsString *>
          many1 space *>
          char ':' *>
          space *>
          many1 digit <* newline)

  where rd = read :: String -> Integer

maxPoolSizeLine :: Parser Integer
maxPoolSizeLine = colonSeparatedLine "Max pool size"

processesLine :: Parser Integer
processesLine = colonSeparatedLine "Processes"

requestsLine :: Parser Integer
requestsLine = colonSeparatedLine "Requests in top-level queue"

statusOutputParser :: Parser PassengerStatus
statusOutputParser = do
  _ <- manyTill anyChar (lookAhead (try maxPoolSizeLine))

  PassengerStatus <$> maxPoolSizeLine <*> processesLine <*>
    requestsLine
