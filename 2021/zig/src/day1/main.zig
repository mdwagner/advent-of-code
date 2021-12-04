const std = @import("std");
const expect = std.testing.expect;
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;
const GeneralPurposeAllocator = std.heap.GeneralPurposeAllocator;
const Input = @import("input.zig");

pub fn main() !void {
    var gpa = GeneralPurposeAllocator(.{}){};
    defer {
        const leaked = gpa.deinit();
        if (leaked) expect(false) catch @panic("TEST FAIL");
    }
    const allocator = &gpa.allocator;
    std.log.info("Day 1 (Part 1): {}", .{day1A(&Input.input)});
    std.log.info("Day 1 (Part 2): {}", .{try day1B(allocator, &Input.input)});
}

fn day1A(depths: []const u32) u32 {
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

fn day1B(allocator: *Allocator, items: []const u32) !u32 {
    var list = ArrayList(u32).init(allocator);
    defer list.deinit();

    for (items) |item, index| {
        switch (index) {
            0, 1 => continue,
            else => {
                const sum = items[index - 2] + items[index - 1] + item;
                try list.append(sum);
            },
        }
    }

    return day1A(list.allocatedSlice());
}

test "Day 1a" {
    const results = day1A(&Input.test_input);
    try expect(results == 7);
}

test "Day 1b" {
    const results = try day1B(std.testing.allocator, &Input.test_input);
    try expect(results == 5);
}
