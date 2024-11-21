# zeam-poc

This is the PoC to demonstrate that it's possible to build a zig beam chain client.

Only powdr support has been worked so far, with other zkVM in progress.

### powdr

#### Build

```
> zig build
```

This will produce a file in `zig-out/bin`.

#### Running

From the powdr interface:

```
> mkdir output
> cargo run --bin powdr-rs riscv-elf ../zeam-poc/zig-out/bin/zeam-poc -o output
> cargo run -r --bin powdr-rs execute output/zeam-poc.asm
```

The PIL asm file will be found in `output/main.asm`, which can be used in powdr.
