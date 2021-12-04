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
const Day3Input = @import("inputs/day3.zig");

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

    //var day3InputList = ArrayList([]const u8).init(allocator);
    //defer day3InputList.deinit();
    //try day3InputList.appendSlice(&Day3Input.input);
    std.log.info("Day 3 (Part 1): {}", .{try day3A(allocator, &Day3Input.input)});
    //std.log.info("Day 3 (Part 2): {}", .{try day3B(allocator, &Day3Input.input, 12)});
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

const Day3Mode = enum {
    min,
    max,
    pub fn isMin(self: Day3Mode) bool {
        return self == Day3Mode.min;
    }
    pub fn isMax(self: Day3Mode) bool {
        return self == Day3Mode.max;
    }
};

fn day3A(allocator: *Allocator, input: []const []const u8) !u32 {
    var numbers = ArrayList([]const u8).init(allocator);
    defer numbers.deinit();
    try numbers.appendSlice(input);
    const max_len = input[0].len;

    var gamma_list = ArrayList(u8).init(allocator);
    defer gamma_list.deinit();
    var epsilon_list = ArrayList(u8).init(allocator);
    defer epsilon_list.deinit();

    var zero_list = ArrayList([]const u8).init(allocator);
    defer zero_list.deinit();
    var one_list = ArrayList([]const u8).init(allocator);
    defer one_list.deinit();

    var index: u32 = 0;
    while (index < max_len) : (index += 1) {
        defer zero_list.clearAndFree();
        defer one_list.clearAndFree();
        for (numbers.items) |str, _| {
            const number = str[index];
            if (number == '0') try zero_list.append(str);
            if (number == '1') try one_list.append(str);
        }
        try gamma_list.append(if (zero_list.items.len > one_list.items.len) '0' else '1');
    }
    for (gamma_list.items) |num, _| {
        if (num == '0') try epsilon_list.append('1');
        if (num == '1') try epsilon_list.append('0');
    }
    var gamma = try fmt.parseInt(u32, gamma_list.items, 2);
    var epsilon = try fmt.parseInt(u32, epsilon_list.items, 2);
    return gamma * epsilon;
}

test "Day 3a" {
    const results = try day3A(std.testing.allocator, &Day3Input.test_input);
    try expect(results == 198);
}

fn day3Helper1(allocator: *Allocator, list_ptr: *ArrayList([]const u8), index: u32, mode: Day3Mode) !void {
    var zero_list = ArrayList([]const u8).init(allocator);
    defer zero_list.deinit();
    var one_list = ArrayList([]const u8).init(allocator);
    defer one_list.deinit();

    var list = list_ptr.*;

    print("list:", .{});
    for (list.items) |str, _| {
        const number = str[index];
        if (number == '0') try zero_list.append(str);
        if (number == '1') try one_list.append(str);
        print("{s},", .{str});
    }
    print("\n", .{});

    print("index:{}->\n", .{index});
    for (zero_list.items) |item, _| {
        print("{s},", .{item});
    }
    print("\n\n", .{});
    for (one_list.items) |item, _| {
        print("{s},", .{item});
    }
    print("\n\n\n", .{});

    if (mode.isMax()) {
        if (zero_list.items.len > one_list.items.len) {
            var x = zero_list.toOwnedSlice();
            list.clearAndFree();
            try list.appendSlice(x);
            //try list.replaceRange(0, list.items.len, zero_list.items);
            //try list.resize(zero_list.items.len);
        } else {
            //try list.replaceRange(0, list.items.len, one_list.items);
            //try list.resize(one_list.items.len);
            var x = one_list.toOwnedSlice();
            list.clearAndFree();
            try list.appendSlice(x);
        }
    }
    if (mode.isMin()) {
        if (one_list.items.len < zero_list.items.len) {
            //try list.replaceRange(0, list.items.len, one_list.items);
            //try list.resize(one_list.items.len);
            var x = one_list.toOwnedSlice();
            list.clearAndFree();
            try list.appendSlice(x);
        } else {
            //try list.replaceRange(0, list.items.len, zero_list.items);
            //try list.resize(zero_list.items.len);
            var x = zero_list.toOwnedSlice();
            list.clearAndFree();
            try list.appendSlice(x);
        }
    }
}

fn day3B(allocator: *Allocator, input: []const []const u8) !u32 {
    const max_len = input[0].len;

    var oxygen_gen = ArrayList([]const u8).init(allocator);
    var co2_scrubber = ArrayList([]const u8).init(allocator);
    defer oxygen_gen.deinit();
    defer co2_scrubber.deinit();
    try oxygen_gen.appendSlice(input);
    try co2_scrubber.appendSlice(input);

    var index: u32 = 0;

    // TODO
    try day3Helper1(allocator, &oxygen_gen, index, .max);
    index += 1;
    try day3Helper1(allocator, &oxygen_gen, index, .max);

    // calculate oxygen generator rating
    //while (index < max_len) : (index += 1) {
        //if (oxygen_gen.items.len == 1) break;
        //try day3Helper1(allocator, &oxygen_gen, index, .max);
        //for (oxygen_gen.items) |item, _| {
            //print("{s},", .{item});
        //}
        //print("\n", .{});
    //}

    //index = 0;

    // calculate co2 scrubber rating
    //while (index < max_len) : (index += 1) {
    //if (co2_scrubber.len == 1) break;
    //co2_scrubber = try day3Helper1(allocator, co2_scrubber, index, .min);
    //}

    var x = try fmt.parseInt(u32, oxygen_gen.items[0], 2);
    //var y = try fmt.parseInt(u32, co2_scrubber[0], 2);
    return x;

    //return x * y;
}

// TODO: tests are crashing, but not sure why...
test "Day 3b" {
    const results = try day3B(std.testing.allocator, &Day3Input.test_input);
    print("\n\n{}\n", .{results});
    try expect(results == 23);

    //try expect(results == 230);
}
