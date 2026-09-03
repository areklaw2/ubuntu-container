.section .data
data_pointer:
.long 0x00000001
.space 0x4000 - 4
target:
.long 0

.section .text
.global _start
_start:
nop
adr x5, data_pointer
add x5, x5, #0x4000
ldr w0, [x5]
add w0, w0, #2
str w0, [x5]
