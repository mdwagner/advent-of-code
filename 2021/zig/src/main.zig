const Day1 = @import("day1/main.zig");
const Day2 = @import("day2/main.zig");
const Day3 = @import("day3/main.zig");

pub fn main() !void {
    try Day1.main();
    try Day2.main();
    try Day3.main();
}
