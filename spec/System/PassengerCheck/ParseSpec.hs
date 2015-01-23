{-# LANGUAGE OverloadedStrings #-}

module System.PassengerCheck.ParseSpec (spec) where

import Test.Hspec

import Text.Parsec

import System.PassengerCheck.Types
import System.PassengerCheck.Parse

import Text.ParserCombinators.Parsec.Error(ParseError, Message,
                                           errorMessages, messageEq)

instance Eq ParseError where
  a == b = errorMessages a == errorMessages b

parseOutput :: String -> Either ParseError PassengerStatus
parseOutput = parse statusOutputParser "(unknown)"

spec :: Spec
spec =
  describe "parse" $
    it "parses the MaxPoolSize" $ do
      f <- readFile "spec/fixtures/passstats"
      parseOutput f `shouldBe` Right (PassengerStatus 6 2 3 [1, 2])
