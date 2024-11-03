const std = @import("std");

const STACK_TOP_ADDR = 0x0200_0400;

export fn _start() linksection(".text._start") callconv(.Naked) void {
    // set stack + global pointer up
    asm volatile (
        \\lw sp, 0(%[stack_top_addr])
        \\call main
        :
        : [stack_top_addr] "{sp}" (STACK_TOP_ADDR),
        : "memory"
    );
}

export fn main() noreturn {
    const evm_bytecode = [_]u8{0};
    // simplistic evm
    for (evm_bytecode) |opcode| {
        switch (opcode) {
            0 => break,
            else => @panic("invalid instruction"),
        }
    }

    // call syscall_halt
    const SYSCALL_HALT = 0;
    const exitcode = 0;
    asm volatile (
        \\ecall
        :
        : [sycallnumber] "{t0}" (SYSCALL_HALT),
          [exitcode] "{a0}" (exitcode),
    );

    // The ecall should not return
    unreachable;
}
