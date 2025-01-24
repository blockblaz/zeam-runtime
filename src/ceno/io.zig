const std = @import("std");

pub var info_out: []u8 = undefined;

var cursor: usize = 0;

fn alloc(msg_len: usize) []u8 {
    // This isn't thread-safe, but it doesn't matter right now
    // as there are no threads in this environment.
    const old_cursor = cursor;
    cursor += (msg_len + 3) & 0xFFFFFFFC; // word-align
    return info_out[old_cursor .. old_cursor + msg_len];
}

pub fn print_str(str: []const u8) void {
    var buf = alloc(str.len);
    @memcpy(buf[0..], str[0..]);
}
