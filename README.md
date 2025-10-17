# twirpc

:warning: This repository is now a public archive. I have stopped developping the project and will not be maintaining it forward.

This exploratory work has been an enjoyable educational experience for me. I am thankful to the authors and maintainers of the open-source upstream libraries I have been able to build upon here and learn from. Thank you!

---

[![CI Status](https://github.com/mbarbin/twirpc/workflows/ci/badge.svg)](https://github.com/mbarbin/twirpc/actions/workflows/ci.yml)
[![Coverage Status](https://coveralls.io/repos/github/mbarbin/twirpc/badge.svg?branch=main)](https://coveralls.io/github/mbarbin/twirpc?branch=main)

*twirpc* is a collection of opinionated wrappers to build RPC clients and servers with `ocaml-twirp`.

## Goals and status

This is mostly an exploratory work to gain experience with the dependencies.

## Relationship to eio-rpc and others

I have another repo where I have conducted similar exploratory work. See:

- [eio-rpc](https://github.com/mbarbin/eio-rpc) (MIT)

I have in fact copied large portions of the code used in this repository from my earlier work in `eio-rpc`. I don't intend to maintain it all overtime, so this is just some convenient workflow for me at the moment, so I can easily diff the repos and appreciate the differences between the setups. TBD.

## Build

This repo depends most likely on unreleased packages that are published to a custom [opam-repository](https://github.com/mbarbin/opam-repository.git), which must be added to the opam switch used to build the project.

For example, if you use a local opam switch, this would look like this:

```sh
git clone https://github.com/mbarbin/twirpc.git
cd twirpc
opam switch create . 5.3.0 --no-install
eval $(opam env)
opam repo add mbarbin https://github.com/mbarbin/opam-repository.git
opam install . --deps-only --with-test --with-doc
```

Once this is setup, you can build with dune:

```sh
dune build @all @runtest
```
