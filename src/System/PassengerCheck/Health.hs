{-# LANGUAGE OverloadedStrings #-}

module System.PassengerCheck.Health (queuedRequests, status) where

import System.PassengerCheck.Types
import System.Nagios.Plugin (CheckStatus(..))

import Data.Text (Text)

queuedRequests :: PassengerStatus -> Integer
queuedRequests stat =
  requestsInTopLevelQueue stat + sum (requestsInLocalQueues stat)

status :: PassengerStatus -> (CheckStatus, Text)
status stat
  | percentFull >= (0.9 :: Double) =
    (Critical, "Queue is at or above 90% full")

  | percentFull >= (0.5 :: Double) =
      (Warning,  "Queue is at or above 50% full")

  | otherwise          = (OK, "Queue is less than 50% full")

  where percentFull
          = fromIntegral (queuedRequests stat) /
            fromIntegral (maxPoolSize stat)
