[![Build Status](https://travis-ci.org/stackbuilders/passenger-check.svg?branch=master)](https://travis-ci.org/stackbuilders/passenger-check)

# Passenger Check

Passenger has a maximum queue size that determines how many incoming
requests can be serviced. This can fill up, leading to requests being
denied. This plugin checks the maximum queue size and all active
queues and returns an alert if the queue is getting too close to
capacity.

The output format is suitable for Nagios and compatible monitoring
frameworks.

## Installation

This program can be compiled and installed using Haskell and
Cabal. Generally, this means that you should install a version of
haskell-platform for your operating system.

Clone or download this repository, and build using the following
command:

```bash
cabal sandbox init && cabal install --only-dependencies
--enable-tests && cabal test && cabal install
```

If you get an error above on the `cabal sandbox` command, you should
probably update your version of cabal using `cabal install cabal
cabal-install `.

Otherwise, on success this process will produce a binary named
`passenger-check`.

This program depends on `passenger-status` being in, or symlinked to
`/usr/local/bin/passenger-status`.
