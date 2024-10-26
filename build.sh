#!/bin/sh

# Make sure that the target definition is installed
rustup target add riscv32imac-unknown-none-elf

# Build the library using some random CPU that has the features we want
zig build-lib -target riscv32-freestanding-none -mcpu sifive_e76 mylib.zig

# Build the lib
rustc --target riscv32imac-unknown-none-elf -L . -lmylib main.rs

