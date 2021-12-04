const std = @import("std");
const expect = std.testing.expect;
const assert = std.debug.assert;
const mem = std.mem;
const fmt = std.fmt;
const Allocator = mem.Allocator;
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

    var day2InputList = ArrayList([]const u8).init(allocator);
    defer day2InputList.deinit();
    try day2InputList.appendSlice(&Input.input);
    std.log.info("Day 2 (Part 1): {}", .{try day2(allocator, day2InputList, false)});
    std.log.info("Day 2 (Part 2): {}", .{try day2(allocator, day2InputList, true)});
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
    try input.appendSlice(&Input.test_input);
    const results = try day2(allocator, input, false);
    try expect(results == 150);
}

test "Day 2b" {
    const allocator = std.testing.allocator;
    var input = ArrayList([]const u8).init(allocator);
    defer input.deinit();
    try input.appendSlice(&Input.test_input);
    const results = try day2(allocator, input, true);
    try expect(results == 900);
}
