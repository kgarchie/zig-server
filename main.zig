const std = @import("std");

const console = struct {
    var errors = std.ArrayList(anyerror).init(std.heap.page_allocator);

    pub fn log(text: []const u8) void {
        const _writer = std.io.getStdOut().writer();
        _writer.writeAll(text) catch |err| {
            std.debug.print("Unable to write to stdout: {any}\n", .{err});
            errors.append(err) catch |_err| {
                console.error_(_err);
            };
        };
    }

    fn writer() type {
        return struct {
            var value = std.ArrayList(u8).init(std.heap.page_allocator);

            pub fn getValue() ?[]const u8 {
                // value memory is cleared here, thereby making deinit unnecessary.
                return value.toOwnedSlice() catch |err| {
                    errors.append(err) catch |_err| {
                        console.error_(_err);
                    };
                    return undefined;
                };
            }

            pub fn writeByte(byte: u8) anyerror!void {
                value.append(byte) catch |_err| {
                    errors.append(_err) catch |__err| {
                        console.error_(__err);
                    };
                    console.error_(_err);
                };
            }
        };
    }

    pub fn readByte() std.posix.ReadError!?u8 {
        const reader = std.io.getStdIn();
        var result: [1]u8 = undefined;
        const amt_read: usize = try reader.read(result[0..]);
        if (amt_read < 1) return undefined;
        return result[0];
    }

    pub fn readLine() []const u8 {
        const delimiter: u8 = '\n';
        return read(delimiter);
    }

    pub fn read(end: u8) []const u8 {
        const delimiter = end;
        const _writer = console.writer();

        while (true) {
            const byte = console.readByte() catch |err| {
                errors.append(err) catch |_err| {
                    console.error_(_err);
                };
                console.error_(err);
                return undefined;
            } orelse delimiter;

            if (byte == delimiter) break;

            _writer.writeByte(byte) catch |err| {
                errors.append(err) catch |_err| {
                    console.error_(_err);
                };
                console.error_(err);
            };
        }

        return _writer.getValue() orelse {
            return "";
        };
    }

    pub fn error_(err: anyerror) void {
        const _writer = std.io.getStdErr().writer();

        _writer.print("{any}", .{err}) catch |_err| {
            std.debug.print("Encountered error at console.error_ {any}", .{_err});
        };
    }
};

pub fn main() !void {
    console.log("Enter your name: ");
    const name = console.readLine();

    console.log("Hello, ");
    console.log(name);
    console.log("\n");
}
