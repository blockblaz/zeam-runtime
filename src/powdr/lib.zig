const std = @import("std");
const syscalls = @import("./syscalls.zig").syscalls;

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

var publics: committed_publics = committed_publics.new();

const committed_publics = struct {
    state: [12]u64,
    buffer_size: u8,

    const Self = @This();

    pub fn new() Self {
        return .{
            .state = [_]u64{0} ** 12,
            .buffer_size = 0,
        };
    }

    pub fn commit(self: *Self, n: u32) void {
        self.state[self.buffer_size + 4] = @intCast(n);
        self.buffer_size += 1;
        if (self.buffer_size == 4) {
            self.buffer_size = 0;
            self.update_state();
        }
    }

    pub fn update_state(self: *Self) void {
        _ = native_hash(&self.state);
    }

    pub fn finalize(self: *Self) [4]u64 {
        // prevent hash of empty
        self.commit(1);

        if (self.buffer_size != 0) {
            for (self.state[self.buffer_size + 4 .. 8]) |*n| {
                n.* = 0;
            }
        }

        var h: [4]u64 = undefined;
        std.mem.copyForwards(u64, h[0..], self.state[0..4]);
        self.* = Self.new();

        return h;
    }
};

fn finalize() void {
    const commits = publics.finalize();
    for (commits, 0..) |limb, i| {
        const low: u32 = @truncate(limb);
        const high: u32 = @truncate(limb >> 32);

        asm volatile ("ecall"
            :
            : [scallnum] "{t0}" (@intFromEnum(syscalls.commit_public)),
              [fd] "{a0}" (i * 2),
              [idx] "{a1}" (low),
            : "memory"
        );
        asm volatile ("ecall"
            :
            : [scallnum] "{t0}" (@intFromEnum(syscalls.commit_public)),
              [fd] "{a0}" (i * 2 + 1),
              [idx] "{a1}" (high),
            : "memory"
        );
    }
}

pub fn halt() noreturn {
    finalize();
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
