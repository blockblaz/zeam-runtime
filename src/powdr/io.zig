const syscalls = @import("./syscalls.zig").syscalls;

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
        : [ret] "={a0}" (ret),
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
