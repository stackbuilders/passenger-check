module System.PassengerCheck.Types (PassengerStatus(..)) where

data PassengerStatus =
  PassengerStatus { maxPoolSize             :: Integer
                  , processes               :: Integer
                  , requestsInTopLevelQueue :: Integer
                  , requestsInLocalQueues   :: [Integer]
                  } deriving (Show, Eq)
