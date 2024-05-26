const std = @import("std");

pub fn build(b: *std.Build) void {
    const executable = b.addExecutable(.{
        .name = "main",
        .root_source_file = b.path("main.zig"),
        .target = b.host,
    });
    b.installArtifact(executable);
}
