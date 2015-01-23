{-# LANGUAGE OverloadedStrings #-}

module System.PassengerCheck.HealthSpec (spec) where

import Test.Hspec

import System.PassengerCheck.Types
import System.PassengerCheck.Health

import System.Nagios.Plugin (CheckStatus(..))

spec :: Spec
spec = do
  describe "queuedRequests" $
    it "returns the number of queued requests" $
      queuedRequests (PassengerStatus 15 2 3 [4, 5]) `shouldBe` 12

  describe "status" $ do
    it "returns Critical when the queue is >= 90% full" $
      status (PassengerStatus 10 2 7 [1, 1]) `shouldBe`
        (Critical, "Queue is at or above 90% full")

    it "returns Warning when the queue is >= 50% full" $
      status (PassengerStatus 10 2 3 [1, 1]) `shouldBe`
        (Warning, "Queue is at or above 50% full")

    it "returns OK when the queue is < 50% full" $
      status (PassengerStatus 10 2 1 [0, 0]) `shouldBe`
        (OK, "Queue is less than 50% full")
