const std = @import("std");
const expect = std.testing.expect;
const print = std.debug.print;
const fmt = std.fmt;
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

    std.log.info("Day 3 (Part 1): {}", .{try day3A(allocator, &Input.input)});
    //std.log.info("Day 3 (Part 2): {}", .{try day3B(allocator, &Input.input, 12)});
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
    const results = try day3A(std.testing.allocator, &Input.test_input);
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
    const results = try day3B(std.testing.allocator, &Input.test_input);
    print("\n\n{}\n", .{results});
    try expect(results == 23);

    //try expect(results == 230);
}
