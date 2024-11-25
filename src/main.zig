const std = @import("std");
const powdr = @import("./powdr/start.zig");

var fixed_mem = [_]u8{0} ** (256 * 1024 * 1024);

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

    var fixed_allocator = std.heap.FixedBufferAllocator.init(fixed_mem[0..]);
    var allocator = fixed_allocator.allocator();

    // Test the allocator by writing one word
    var buf = allocator.alloc(u8, 32) catch @panic("error allocating fixed buffer");
    defer allocator.free(buf);
    buf[0] = 1;

    powdr.halt();
}

pub fn panic(msg: []const u8, _: ?*std.builtin.StackTrace, _: ?usize) noreturn {
    powdr.print_str("PANIC: ");
    powdr.print_str(msg);
    powdr.print_str("\n");
    powdr.halt();
    while (true) {}
}
