extern const __global_pointer: u32;
extern const __powdr_stack_start: u32;

const syscalls = enum {
    reserved_0,
    input,
    output,
    poseidon_gl,
    affine_256,
    ec_add,
    ec_double,
    keccakf,
    mod_256,
    halt,
    poseidon2_gl,
    native_hash,
    commit_public,
};

export fn _start() callconv(.Naked) void {
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
        : [scallnum] "{t0}" (@intFromEnum(syscalls.halt)),
    );
    while (true) {}
}

pub fn print_str(str: []const u8) void {
    for (str) |c| {
        asm volatile ("ecall"
            :
            : [scallnum] "{t0}" (@intFromEnum(syscalls.output)),
              [subcommand] "{a0}" (1), // fd = 1 == stdout
              [arg1] "{a1}" (c),
            : "memory"
        );
    }
}
