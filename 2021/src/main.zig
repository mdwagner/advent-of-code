const std = @import("std");
const expect = std.testing.expect;

pub fn main() !void {
    std.log.info("TODO", .{});
}

fn day1() !void {}

test "Day 1" {
    const items = [_]u32{ 199, 200, 208, 210, 200, 207, 240, 269, 260, 263 };
    _ = try day1();
    try expect(false);
}
