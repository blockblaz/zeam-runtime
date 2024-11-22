const std = @import("std");
const powdr = @import("./powdr/start.zig");

export fn main() noreturn {
    powdr.print_str("running dummy EVM contract\n");

    const evm_bytecode = [_]u8{0};
    // simplistic evm
    for (evm_bytecode) |opcode| {
        switch (opcode) {
            0 => break,
            else => @panic("invalid instruction"),
        }
    }

    powdr.print_str("run completed\n");

    powdr.halt();
}

pub fn panic(msg: []const u8, _: ?*std.builtin.StackTrace, _: ?usize) noreturn {
    powdr.print_str("PANIC: ");
    powdr.print_str(msg);
    powdr.print_str("\n");
    powdr.halt();
    while (true) {}
}
