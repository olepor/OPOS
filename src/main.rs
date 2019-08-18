#![no_std]	//< Kernels can't use std
#![no_main] //< Need to setup our own environment before a main (entry) is called.
#![feature(lang_items)]
#![crate_name="OPOS"]

extern crate lazy_static;

mod vga;

use core::panic::PanicInfo;

#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    println!("{}", _info);
    loop {}
}

#[no_mangle]
pub extern "C" fn _start() -> ! {
    use core::fmt::Write;
    println!("Hello World{}", "!");
    loop {}
}
