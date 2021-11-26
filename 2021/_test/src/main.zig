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
