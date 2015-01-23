[![Build Status](https://travis-ci.org/stackbuilders/passenger-check.svg?branch=master)](https://travis-ci.org/stackbuilders/passenger-check)

# Passenger Check

This program checks the status of the Passenger queue for monitoring
tools like Nagios.

## Installation

* Clone this repository
* cabal build && cabal install

This program depends on `passenger-status` being in, or symlinked to
`/usr/local/bin/passenger-status`.
