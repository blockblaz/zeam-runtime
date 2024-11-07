const std = @import("std");

extern const __global_pointer: u32;
extern const __powdr_stack_start: u32;

const syscall_halt: u32 = 9;

export fn _start() callconv(.Naked) void {
    // export fn _start() linksection(".text._start") callconv(.Naked) void {
    // set stack + global pointer up
    asm volatile (
        \\.option push
        \\.option norelax
        \\tail main
        :
        : [global_pointer] "{gp}" (__global_pointer),
          [powdr_stack_start] "{sp}" (__powdr_stack_start),
        : "memory"
    );
}

pub fn halt() noreturn {
    asm volatile ("ecall"
        :
        : [scallnum] "{t0}" (syscall_halt),
    );
    while (true) {}
}
