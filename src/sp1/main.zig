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
