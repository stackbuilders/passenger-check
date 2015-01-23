[![Build Status](https://travis-ci.org/stackbuilders/passenger-check.svg?branch=master)](https://travis-ci.org/stackbuilders/passenger-check)

# Passenger Check

This program checks the status of the Passenger queue for monitoring
tools like Nagios.

## Installation

First, you will need Haskell on your target platform. On Ubuntu, an
easy way to accomplish this is by doing `sudo apt-get install
haskell-platform`.

* Clone this repository
* Change directory to the location where you cloned the repo.

On Ubuntu, you should update the version of cabal:

cabal install cabal-install

The following command will get a fresh package list from Cabal (the
Haskell package manager), build passenger-check and run the test suite:

```
cabal update && cabal install --only-dependencies --enable-tests && cabal configure && cabal build && cabal test
```

This program depends on `passenger-status` being in, or symlinked to
`/usr/local/bin/passenger-status`.
