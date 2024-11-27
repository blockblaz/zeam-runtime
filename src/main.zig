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

    // Test reading inputs by checking a sum - uncomment this code if you want to test it.
    // It's the same as the `sum` test in the powdr runtime: it expects a final sum, a number
    // N, and then another N integers, and it checks that the proposed sum equals to the
    // sum of all other N integers.
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

    // Test the sra instruction - uncomment this code if you want to test it.
    const res = asm volatile (
        \\li t0, -42
        \\sra %[ret], t0, %[shift]
        : [ret] "=r" (-> i32),
        : [shift] "r" (2),
        : "{t0}"
    );

    const resultstr = std.fmt.allocPrint(allocator, "result: {}\n", .{res}) catch @panic("could not allocate print memory");
    zkvm.io.print_str(resultstr);
    if (res != -11) {
        @panic("sra didn't work");
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
