{-# LANGUAGE OverloadedStrings #-}

module System.PassengerCheck.Parse (statusOutputParser) where

import System.PassengerCheck.Types

import Text.Parsec
import Text.Parsec.String

import Text.ParserCombinators.Parsec.Char (string, space, tab, newline)
import Text.ParserCombinators.Parsec.Token (integer)
import Control.Applicative ((<*>), (*>), (<$>), (<*))

statusOutputParser :: Parser PassengerStatus
statusOutputParser = do
  _ <- manyTill anyChar (lookAhead (try maxPoolSizeLine))

  PassengerStatus <$> maxPoolSizeLine <*> processesLine <*>
    topLevelRequestLine <*> localQueueRequestLines

colonSeparatedLine :: String -> Parser Integer
colonSeparatedLine lhsString =
  rd <$> ( many space       *>

           string lhsString *>

           many space       *>
           char ':'         *>
           many space       *>

           many1 digit
         )

  where rd = read :: String -> Integer

maxPoolSizeLine :: Parser Integer
maxPoolSizeLine = colonSeparatedLine "Max pool size"

processesLine :: Parser Integer
processesLine = colonSeparatedLine "Processes"

topLevelRequestLine :: Parser Integer
topLevelRequestLine = colonSeparatedLine "Requests in top-level queue"

localQueueRequestLines :: Parser [Integer]
localQueueRequestLines =
  many (try (prefixParser *> lineParser))

  where prefixParser = manyTill anyChar (lookAhead (try lineParser))
        lineParser   = colonSeparatedLine "Requests in queue"
