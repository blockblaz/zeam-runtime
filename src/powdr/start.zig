const std = @import("std");

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
        // symbols are hardcoded, as passing them
        // via the assembler constraints produce
        // weird behaviors. To be tried again when
        // the assembler interface stabilizes.
        \\la gp, __global_pointer
        \\la sp, __powdr_stack_start
        \\tail main
    );
}

pub fn native_hash(data: *[12]u64) [4]u64 {
    asm volatile ("ecall"
        :
        : [scallnum] "{t0}" (@intFromEnum(syscalls.output)),
          [subcommand] "{a0}" (data),
        : "memory"
    );
    var ret: [4]u64 = undefined;
    std.mem.copyForwards(u64, ret[0..], data.*[0..4]);
    return ret;
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

pub fn read_u32(idx: u32) u32 {
    var ret: u32 = undefined;
    asm volatile ("ecall"
        : [ret] "{a0}" (ret),
        : [scallnum] "{t0}" (@intFromEnum(syscalls.input)),
          [fd] "{a0}" (0), // fd = 0 == stdin
          [idx] "{a1}" (idx + 1),
        : "memory"
    );
    return ret;
}

pub fn read_data_len(fd: u32) usize {
    var ret: u32 = undefined;
    asm volatile ("ecall"
        : [ret] "{a0}" (ret),
        : [scallnum] "{t0}" (@intFromEnum(syscalls.input)),
          [subcommand] "{a0}" (fd),
          [idx] "{a1}" (0),
        : "memory"
    );
    return ret;
}

pub fn read_slice(fd: u32, data: []u32) void {
    for (data, 0..) |*d, idx| {
        var item: u32 = undefined;
        asm volatile ("ecall"
            : [ret] "{a0}" (item),
            : [scallnum] "{t0}" (@intFromEnum(syscalls.input)),
              [subcommand] "{a0}" (fd),
              [idx] "{a1}" (idx + 1),
            : "memory"
        );
        d.* = item;
    }
}

pub fn write_u8(fd: u32, byte: u8) void {
    asm volatile ("ecall"
        :
        : [scallnum] "{t0}" (@intFromEnum(syscalls.output)),
          [fd] "{a0}" (fd),
          [arg1] "{a1}" (byte),
        : "memory"
    );
}

pub fn write_slice(fd: u32, data: []const u8) void {
    for (data) |c| {
        write_u8(fd, c);
    }
}
