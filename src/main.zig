const std = @import("std");
const zkvm = @import("zkvm");

var fixed_mem = [_]u8{0} ** (256 * 1024 * 1024);

export fn main() noreturn {
    zkvm.io.print_str("running dummy EVM contract\n");

    const evm_bytecode = [_]u8{0};
    // simplistic evm
    for (evm_bytecode) |opcode| {
        switch (opcode) {
            0 => break,
            else => @panic("invalid instruction"),
        }
    }

    zkvm.io.print_str("run completed\n");

    var fixed_allocator = std.heap.FixedBufferAllocator.init(fixed_mem[0..]);
    var allocator = fixed_allocator.allocator();

    // Test the allocator by writing one word
    var buf = allocator.alloc(u8, 32) catch @panic("error allocating fixed buffer");
    defer allocator.free(buf);
    buf[0] = 1;

    // Test reading inputs
    const proposed_sum = zkvm.io.read_u32(0);
    const len: usize = @intCast(zkvm.io.read_u32(1));
    var computed_sum: u32 = 0;
    for (0..len) |i| {
        computed_sum += zkvm.io.read_u32(2 + i);
    }
    if (computed_sum != proposed_sum) {
        const panicStr = std.fmt.allocPrint(allocator, "sums don't match: {} != {}", .{ computed_sum, proposed_sum }) catch @panic("could not allocate print memory");
        @panic(panicStr);
    }

    zkvm.halt();
}

pub fn panic(msg: []const u8, _: ?*std.builtin.StackTrace, _: ?usize) noreturn {
    zkvm.io.print_str("PANIC: ");
    zkvm.io.print_str(msg);
    zkvm.io.print_str("\n");
    zkvm.halt();
    while (true) {}
}
