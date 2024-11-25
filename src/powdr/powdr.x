# Powdr linker script.
#
# This linker script provides usable definitions to these
# symbols, with a 256 MB stack.

SECTIONS
{
  # Data starts here, before is the stack.
  . = 0x10000100;
  .data : {
    *(.data)
    PROVIDE( __global_pointer = . + 0x800 );
  }
  .bss : { *(.bss) }

  # Text addresses are fake in powdr, we use a different address space.
  .text : { *(.text) }

  __powdr_stack_start = 0x10000000;
}

ASSERT(DEFINED(_start), "Error: _start is not defined.")
ENTRY(_start)
