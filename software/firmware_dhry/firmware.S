#include "system.h"

.section .init
.global main

/* set stack pointer */
lui sp, %hi(1<<16)
addi sp, sp, %lo(1<<16)

/* call main */
jal ra, main

/* break */
ebreak
