ENTRY(_start)
 
SECTIONS {
    . = 0x200800;
 
    .text : ALIGN(1K) {
        KEEP(*(.text._start))
        *(.text)
    }
 
    .rodata : ALIGN(4K) {
        *(.rodata)
    }
 
    .data : ALIGN(4K) {
        *(.data)
    }
}
