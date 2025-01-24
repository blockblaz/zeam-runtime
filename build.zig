const std = @import("std");

const zkvm_types = enum {
    ceno,
    powdr,
    sp1,
};

pub fn build(b: *std.Build) void {
    const target_query = .{ .cpu_arch = .riscv32, .os_tag = .freestanding, .abi = .none, .cpu_model = .{ .explicit = &std.Target.riscv.cpu.generic_rv32 } };
    const target = b.resolveTargetQuery(target_query);
    const optimize = b.standardOptimizeOption(.{});

    // Declare the -Dzkvm option, which is a choice between all supported zkvms
    const zkvm = b.option(zkvm_types, "zkvm", "zkvm target") orelse .powdr;

    const zkvm_module = b.addModule("zkvm", .{
        .optimize = optimize,
        .target = target,
        .root_source_file = b.path(switch (zkvm) {
            .ceno => "src/ceno/lib.zig",
            .powdr => "src/powdr/lib.zig",
            .sp1 => "src/sp1/lib.zig",
        }),
    });

    const exe = b.addExecutable(.{
        .name = "zeam-runtime",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });
    exe.root_module.addImport("zkvm", zkvm_module);

    switch (zkvm) {
        .ceno => {
            exe.addAssemblyFile(b.path("src/ceno/start.s"));
            exe.setLinkerScript(b.path("src/ceno/ceno.ld"));
        },
        .powdr => {
            exe.addAssemblyFile(b.path("src/powdr/start.s"));
            exe.setLinkerScript(b.path("src/powdr/powdr.x"));
        },
        .sp1 => {
            exe.addAssemblyFile(b.path("src/sp1/start.s"));
            exe.setLinkerScript(b.path("src/sp1/sp1.ld"));
        },
    }
    exe.pie = true;

    b.installArtifact(exe);
}
