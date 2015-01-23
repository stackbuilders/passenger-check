module System.PassengerCheck.Types (PassengerStatus(..)) where

data PassengerStatus =
  PassengerStatus { maxPoolSize             :: Integer
                  , processes               :: Integer
                  , requestsInTopLevelQueue :: Integer
                  } deriving (Show, Eq)
