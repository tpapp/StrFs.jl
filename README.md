# StrFs

![Lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)<!--
![Lifecycle](https://img.shields.io/badge/lifecycle-maturing-blue.svg)
![Lifecycle](https://img.shields.io/badge/lifecycle-stable-green.svg)
![Lifecycle](https://img.shields.io/badge/lifecycle-retired-orange.svg)
![Lifecycle](https://img.shields.io/badge/lifecycle-archived-red.svg)
![Lifecycle](https://img.shields.io/badge/lifecycle-dormant-blue.svg) -->
[![Build Status](https://travis-ci.org/tpapp/StrFs.jl.svg?branch=master)](https://travis-ci.org/tpapp/StrFs.jl)
[![codecov.io](http://codecov.io/github/tpapp/StrFs.jl/coverage.svg?branch=master)](http://codecov.io/github/tpapp/StrFs.jl?branch=master)

Julia packages for strings with fixed maximum number of bytes.

`StrF{S} <: AbstractString` can be used for strings up to `S` bytes in [UTF-8](https://en.wikipedia.org/wiki/UTF-8) encoding. When the string has less than that many bytes, it is terminated with a `0x00`.

This mirrors the way Stata DTA files encode fixed length strings (`str#`), but other applications may also find this useful. `StrF{S}` strings are implemented by wrapping an `SVector{S,UInt8}`, with the potential efficiency gains that entails.
