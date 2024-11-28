.global _start
.type _start, @function

_start:
    .option push
    .option relax

    la gp, __global_pointer
    la gp, __global_pointer$
    la sp, __powdr_stack_start
    tail main
