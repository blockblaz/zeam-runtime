.global _start
.type _start, @function

_start:
    .option push
    .option norelax
    lla gp, __global_pointer$
    lla sp, __powdr_stack_start
    .option pop
    tail main
