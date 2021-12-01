const std = @import("std");
const expect = std.testing.expect;

pub fn main() !void {
    std.log.info("TODO", .{});
}

fn day1(depths: []const u32) !u32 {
    var count: u32 = 0;
    for (depths) |depth, index| {
        if (index == 0) {
            continue;
        }
        if (depth > depths[index - 1]) {
            count += 1;
        }
    }
    return count;
}

test "Day 1" {
    const measurements = [_]u32{ 199, 200, 208, 210, 200, 207, 240, 269, 260, 263 };
    const num_of_measurements = try day1(measurements[0..]);
    try expect(num_of_measurements == 7);
}
