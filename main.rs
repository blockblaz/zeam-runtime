#![no_std]
#![no_main]

use core::panic::PanicInfo;
use core::ptr;

extern "C" {
    fn zig_add(a: i32, b: i32) -> i32;
}

#[no_mangle]
pub extern "C" fn start() -> ! {
    let result = unsafe { zig_add(1, 2) };
    unsafe {
	ptr::read_volatile(&result);
    }
    // println!("1 + 2 = {}", result);
    loop {}
}

#[panic_handler]
fn ohno(_ : &PanicInfo) -> ! {
	loop {}
}
