## OpenWayback (Stanford Libraries)

[![Build Status](https://travis-ci.com/sul-dlss/openwayback.svg?branch=master)](https://travis-ci.com/sul-dlss/openwayback)
[![Coverage Status](https://coveralls.io/repos/github/sul-dlss/openwayback/badge.svg)](https://coveralls.io/github/sul-dlss/openwayback)

Java application to query and access archived web material. This is the code for the Stanford Web Archiving Portal (SWAP).

Stanford University Libraries fork of [iipc/openwayback](https://github.com/iipc/openwayback).  There are a small number of local modifications to the upstream code:

- earliest year set to 1991
- date format changed to allow for GUI goodness
- GUI goodness
- configuration changes
- ...

For more documentation on this code, see [the OpenWayback wiki][1].

[1]: https://github.com/iipc/openwayback/wiki

## Deployment

Deployment is via deployment artifacts created via [sul-ci-prod (Jenkins)](https://sul-ci-prod.stanford.edu/job/SUL-DLSS/job/openwayback/).  These artifacts are deployed to:
- to wayback-xxx VMs by puppet
- was-robot VMs as part of capistrano [deployment tasks in `was_robot_suite`](https://github.com/sul-dlss/was_robot_suite/blob/master/config/deploy.rb#L47-L54). The deployed `was_robot_suite` houses the deployed files in the `jar/openwayback` directory.

## Build
```
mvn install
```

## Run Tests
```
mvn test -B
```
