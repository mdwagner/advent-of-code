const std = @import("std");
const expect = std.testing.expect;
const assert = std.debug.assert;
const print = std.debug.print;
const mem = std.mem;
const fmt = std.fmt;
const Allocator = mem.Allocator;
const ArrayList = std.ArrayList;
const GeneralPurposeAllocator = std.heap.GeneralPurposeAllocator;

const Day1Input = @import("inputs/day1.zig");
const Day2Input = @import("inputs/day2.zig");

pub fn main() !void {
    var gpa = GeneralPurposeAllocator(.{}){};
    defer {
        const leaked = gpa.deinit();
        if (leaked) expect(false) catch @panic("TEST FAIL");
    }
    const allocator = &gpa.allocator;

    const day1InputSlice = Day1Input.input[0..];
    std.log.info("Day 1 (Part 1): {}", .{day1A(day1InputSlice)});
    std.log.info("Day 1 (Part 2): {}", .{try day1B(allocator, day1InputSlice)});

    var day2InputList = ArrayList([]const u8).init(allocator);
    defer day2InputList.deinit();
    try day2InputList.appendSlice(&Day2Input.input);
    std.log.info("Day 2 (Part 1): {}", .{try day2(allocator, day2InputList, false)});
    std.log.info("Day 2 (Part 2): {}", .{try day2(allocator, day2InputList, true)});
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
    const results = day1A(Day1Input.test_input[0..]);
    try expect(results == 7);
}

test "Day 1b" {
    const results = try day1B(std.testing.allocator, Day1Input.test_input[0..]);
    try expect(results == 5);
}

fn day2(allocator: *Allocator, commands: ArrayList([]const u8), calculate_aim: bool) !u32 {
    var horizontal: u32 = 0;
    var depth: u32 = 0;
    var aim: u32 = 0;
    var pairs = ArrayList([]const u8).init(allocator);
    defer pairs.deinit();
    for (commands.items) |line, _| {
        defer pairs.clearAndFree();
        var line_iter = mem.split(line, " ");
        var index: u32 = 0;
        while (line_iter.next()) |token| : (index += 1) {
            try pairs.append(token);
        }
        assert(pairs.items.len == 2);
        const command = pairs.items[0];
        const number: u32 = fmt.parseInt(u32, pairs.items[1], 10) catch 0;
        if (mem.eql(u8, command, "forward")) {
            horizontal += number;
            if (calculate_aim) depth += (aim * number);
        }
        if (mem.eql(u8, command, "down")) {
            if (calculate_aim) {
                aim += number;
            } else {
                depth += number;
            }
        }
        if (mem.eql(u8, command, "up")) {
            if (calculate_aim) {
                aim -= number;
            } else {
                depth -= number;
            }
        }
    }
    return horizontal * depth;
}

test "Day 2a" {
    const allocator = std.testing.allocator;
    var input = ArrayList([]const u8).init(allocator);
    defer input.deinit();
    try input.appendSlice(&Day2Input.test_input);
    const results = try day2(allocator, input, false);
    try expect(results == 150);
}

test "Day 2b" {
    const allocator = std.testing.allocator;
    var input = ArrayList([]const u8).init(allocator);
    defer input.deinit();
    try input.appendSlice(&Day2Input.test_input);
    const results = try day2(allocator, input, true);
    try expect(results == 900);
}
