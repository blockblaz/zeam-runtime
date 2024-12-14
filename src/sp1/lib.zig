pub const io = @import("./io.zig");
pub const syscalls = @import("./syscalls.zig");
extern fn main() noreturn;

export fn __start() noreturn {
    // PUBLIC_VALUES_HASHER = Some(Sha256::new());
    // #[cfg(feature = "verify")]
    // {
    //     DEFERRED_PROOFS_DIGEST = Some([BabyBear::zero(); 8]);
    // }

    main();
}

pub fn halt() noreturn {
    while (true) {}
}
