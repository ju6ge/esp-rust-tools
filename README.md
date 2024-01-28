Rust-Esp-Tools
==============

This folder contains a podman/docker container with the esp-rust toolchain installed. The goal is to make it easy to build esp rust projects without installing much into your system.

My main use case is to have working lsp in the `esp-hal` project which host many different esp crates.

## Building

Run:

``` sh
podman build --tag esp-rust:test -f container/rust-esp.Containerfile .
```

## Usage

The easiest way to use the resulting container is to add the bin directory to your PATH

``` sh
export PATH=$PATH_TO_TOOLS_REPO/bin:$PATH
```


## Roadmap

Add more scripts to bin:
- [x] rust-analyzer
- [ ] cargo
- [ ] espflash

