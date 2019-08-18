use core::fmt;
use lazy_static::lazy_static;
use spin::Mutex;
use volatile::Volatile;

lazy_static! {
    pub static ref WRITER: Mutex<Writer> = Mutex::new(Writer{x: 0,y: 0,
                                       color_code: ColorCode::new(Color::White, Color::Black),
                                       buffer: unsafe { &mut *(VGA_BUF_ADR as *mut VGABuf) }
    });
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
#[repr(u8)]
pub enum Color {
    Black = 0,
    Blue = 1,
    Green = 2,
    Cyan = 3,
    Red = 4,
    Magenta = 5,
    Brown = 6,
    LightGray = 7,
    DarkGray = 8,
    LightBlue = 9,
    LightGreen = 10,
    LightCyan = 11,
    LightRed = 12,
    Pink = 13,
    Yellow = 14,
    White = 15,
}

const BUFFER_HEIGHT: usize = 25;
const BUFFER_WIDTH: usize = 80;
const VGA_BUF_ADR: *mut u8 = 0xb8000 as *mut u8;

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
struct ColorCode(u8);

impl ColorCode {
    fn new(foreground: Color, background: Color) -> ColorCode {
        ColorCode((foreground as u8) << 4 | background as u8)
    }
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
#[repr(C)]
struct ScreenChar {
    character: u8,
    color_code: ColorCode,
}

impl ScreenChar {
    fn new(color: ColorCode, character: u8) -> ScreenChar {
        ScreenChar{color_code: color, character: character}
    }
}

#[repr(transparent)]
struct VGABuf {
    chars: [[Volatile<ScreenChar>; BUFFER_WIDTH]; BUFFER_HEIGHT],
}

pub struct Writer {
    x: usize,
    y: usize,
    color_code: ColorCode,
    buffer: &'static mut VGABuf,
}

impl Writer {
    pub fn new() -> Writer {
        Writer{x: 0,y: 0,
               color_code: ColorCode::new(Color::White, Color::Black),
               buffer: unsafe { &mut *(VGA_BUF_ADR as *mut VGABuf) }}
    }

    pub fn new_line(&mut self) {
        self.y += 1;
    }

    pub fn write_byte(&mut self, byte: u8) {
        if self.x >= BUFFER_WIDTH {
            self.new_line();
            self.x = 0;
        }
        self.buffer.chars[self.y][self.x].write(ScreenChar{
            color_code: self.color_code,
            character: byte,
        });
        self.x += 1;
    }
    pub fn write_char(&mut self, character: char) {
        self.write_byte(character as u8);
    }

    pub fn write_string(&mut self, s: &str) {
        for byte in s.bytes() {
            match byte {
                // printable ASCII byte or newline
                0x20..=0x7e | b'\n' => self.write_byte(byte),
                // not part of printable ASCII range
                _ => self.write_byte(0xfe),
            }
        }
    }

    // fn scroll(&mut self) {
    //     for i in BUFFER_HEIGHT {
    //         for j in BUFFER_WIDTH {
    //             // Each line is srolled on line up

    //         }
    //     }
    // }
}

impl fmt::Write for Writer {
    fn write_str(&mut self, s: &str) -> fmt::Result {
        self.write_string(s);
        Ok(())
    }
}

#[macro_export]
macro_rules! print {
    ($($arg:tt)*) => ($crate::vga::_print(format_args!($($arg)*)));
}

#[macro_export]
macro_rules! println {
    () => ($crate::print!("\n"));
    ($($arg:tt)*) => ($crate::print!("{}\n", format_args!($($arg)*)));
}

#[doc(hidden)]
pub fn _print(args: fmt::Arguments) {
    use core::fmt::Write;
    WRITER.lock().write_fmt(args).unwrap();
}

#[cfg(test)]
mod tests {
    #[test]
    fn testVGABuffer() {
        assert_eq!(2+2, 4);
    }
}
