const std = @import("std");
const powdr = @import("./powdr/start.zig");

export fn main() noreturn {
    const evm_bytecode = [_]u8{0};
    // simplistic evm
    for (evm_bytecode) |opcode| {
        switch (opcode) {
            0 => break,
            else => @panic("invalid instruction"),
        }
    }

    powdr.halt();
}
