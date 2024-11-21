const std = @import("std");
const powdr = @import("./powdr/start.zig");

export fn main() noreturn {
    powdr.print_str("running dummy EVM contract");

    const evm_bytecode = [_]u8{0};
    // simplistic evm
    for (evm_bytecode) |opcode| {
        switch (opcode) {
            0 => break,
            else => @panic("invalid instruction"),
        }
    }

    powdr.print_str("run completed");

    powdr.halt();
}
