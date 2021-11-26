const std = @import("std");
const expect = std.testing.expect;
const assert = std.debug.assert;

pub fn main() !void {
    // comptime
    const a = 6;
    std.log.info("type is {}, {}", .{ @TypeOf(a), a });

    // explicit
    const b: i32 = 7;
    std.log.info("type is {}, {}", .{ @TypeOf(b), b });

    // inferred
    const c = @as(i32, 8);
    std.log.info("type is {}, {}", .{ @TypeOf(c), c });

    // arr length
    const arr = [_]u8{ 'h', 'e', 'l', 'l', 'o' };
    std.log.info("length is {}", .{arr.len});

    // if statement
    const d = true;
    var e: u8 = 0;
    std.log.info("e (before) is {}", .{e});
    //if (d) {
    //e += 1;
    //} else {
    //e += 2;
    //}
    e += if (d) 1 else 2;
    std.log.info("e (after) is {}", .{e});

    // functions
    const arg = 5;
    std.log.info("addFive({}) is {}", .{ arg, addFive(arg) });

    // defers are executed in reverse order
    {
        var f: i16 = 5;
        defer std.log.info("f is {}", .{f});
        defer f += 2;
        std.log.info("f was {}", .{f});
    }

    // errors
    const FileOpenError = error{
        AccessDenied,
        OutOfMemory,
        FileNotFound,
    };
    const AllocationError = error{OutOfMemory};
    const err: FileOpenError = AllocationError.OutOfMemory;
    std.log.info("coerce error from a subset to a superset: {}", .{err == FileOpenError.OutOfMemory});
}

fn addFive(x: u32) u32 {
    return x + 5;
}

fn failingFunction() error{Oops}!void {
    return error.Oops;
}

fn failFn() error{Oops}!u32 {
    try failingFunction();
    return 12;
}

var problems: u32 = 98;

fn failFnCounter() error{Oops}!void {
    errdefer problems += 1;
    try failingFunction();
}

fn createFile() !void {
    return error.AccessDenied;
}

test "inferred error set" {
    const x: error{AccessDenied}!void = createFile();
    _ = x catch {};
}

test "errdefer" {
    failFnCounter() catch |err| {
        try expect(err == error.Oops);
        try expect(problems == 99);
        return;
    };
}

test "try" {
    //var v = failFn() catch |err| {
    //try expect(err == error.Oops);
    //return;
    //};
    //try expect(@TypeOf(v) == u32);
    //try expect(v == 12); // is never reached...
    //assert(v == 11);
    var v: u32 = failFn() catch 12;
    //assert(v == 12);
    try expect(v == 12);
}

test "switch statement" {
    var x: i8 = 10;
    switch (x) {
        -1...1 => {
            x = -x;
        },
        10, 100 => {
            x = @divExact(x, 10);
        },
        else => {},
    }
    try expect(x == 1);
}

test "switch expression" {
    var x: i8 = 10;
    x = switch (x) {
        -1...1 => -x,
        10, 100 => @divExact(x, 10),
        else => x,
    };
    try expect(x == 1);
}

test "out of bounds" {
    const a = [3]u8{ 1, 2, 3 };
    var index: u8 = 5;
    // out of bounds error
    //const b = a[index];
    //_ = b;
}

test "out of bounds, no safety" {
    @setRuntimeSafety(false);
    const a = [3]u8{ 1, 2, 3 };
    var index: u8 = 5;
    const b = a[index];
    _ = b;
}

//test "unreachable" {
//const x: i32 = 1;
//const y: u32 = if (x == 2) 5 else unreachable;
//}

fn asciiToUpper(x: u8) u8 {
    return switch (x) {
        'a'...'z' => x + 'A' - 'a',
        'A'...'Z' => x,
        else => unreachable,
    };
}

test "unreachable switch" {
    try expect(asciiToUpper('a') == 'A');
    try expect(asciiToUpper('A') == 'A');
}

// pointer to `num`
fn increment(num: *u8) void {
    // dereference `num` to modify value
    num.* += 1;
}

test "pointers" {
    var x: u8 = 1;
    increment(&x);
    try expect(x == 2);
}

//test "naughty pointer" {
//var x: u16 = 0;
//var y: *u8 = @intToPtr(*u8, x);
//}

//test "const pointers" {
//const x: u8 = 1;
//var y = &x;
//y.* += 1; // type: `*const u8`
//}

test "usize" {
    try expect(@sizeOf(usize) == @sizeOf(*u8));
    try expect(@sizeOf(isize) == @sizeOf(*u8));
}

fn secondValueIs100(comptime T: type, arr: [*]T) void {
    arr[1] = 100;
}

test "many item pointers" {
    var arr = [_]u32{ 1, 5, 10 };
    try expect(arr[1] == 5);
    secondValueIs100(u32, &arr);
    try expect(arr[1] == 100);
}

fn total(values: []const u8) usize {
    var sum: usize = 0;
    for (values) |v| sum += v;
    return sum;
}

test "slices" {
    const array = [_]u8{ 1, 2, 3, 4, 5 };
    const slice = array[0..3];
    try expect(total(slice) == 6);
}

test "slices 2" {
    const array = [_]u8{ 1, 2, 3, 4, 5 };
    const slice = array[0..3];
    try expect(@TypeOf(slice) == *const [3]u8);
}

test "slices 3" {
    var array = [_]u8{ 1, 2, 3, 4, 5 };
    var slice = array[0..];
    _ = slice;
}
