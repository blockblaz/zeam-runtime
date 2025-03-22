# zeam-runtime

**The content of this repository has been moved to the [zeam monorepo](https://github.com/blockblaz/zeam). This repository is no longer maintained.**

This package is the runtime libraries required for zeam to run in zkVMs.

Only powdr is having full support so far, with other zkVM in progress.

## Building and running

Choose the build instructions for your zkvm of choice. The default is [powdr](#powdr).

 - [powdr](#powdr)
 - [ceno](#ceno) WIP
 - sp1 WIP, no code published

### powdr

#### Build

```
> zig build
```

**Important note** this will build in debug mode, which powdr can use if need be. If you are not interested in using debug information, compile with `-Doptimize=ReleaseSafe` or `-Doptimize=ReleaseFast`.

This will produce a file in `zig-out/bin`.

#### Running

From the powdr interface:

```
> mkdir output
> cargo run --bin powdr-rs riscv-elf ../zeam-poc/zig-out/bin/zeam-poc -o output
```

The powdr asm file will be found in `output/main.asm`, which can be used:

```
> cargo run -r --bin powdr-rs execute output/zeam-poc.asm
```

### ceno

#### Build

```
> zig build -Doptimize=ReleaseSafe -Dzkvm=ceno
```

**Important note** in the current state of the ceno runtime, debug builds will not work as they go over the limit of memory that is supported by the default parameters of the proving system.

This will produce a file in `zig-out/bin`.

#### Running

```
> cargo build +nightly -p ceno_zkvm --bin e2e --release -- <zeam_dir>/zig-out/bin/zeam-runtime
```
