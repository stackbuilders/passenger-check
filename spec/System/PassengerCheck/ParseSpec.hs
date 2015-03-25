{-# LANGUAGE OverloadedStrings #-}

module System.PassengerCheck.ParseSpec (spec) where

import Test.Hspec

import Text.Parsec

import System.PassengerCheck.Types
import System.PassengerCheck.Parse

import Text.ParseErrorEq ()

parseOutput :: String -> Either ParseError PassengerStatus
parseOutput = parse statusOutputParser "(unknown)"

spec :: Spec
spec =
  describe "parse" $
    it "parses the MaxPoolSize" $ do
      f <- readFile "spec/fixtures/passstats.txt"
      parseOutput f `shouldBe` Right (PassengerStatus 6 2 3 [1, 2])
