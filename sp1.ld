ENTRY(_start)
 
SECTIONS {
    . = 1M;
 
    .text : ALIGN(4K) {
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
