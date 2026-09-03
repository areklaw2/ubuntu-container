.section .text
.global main
main:
nop
mov w0, #1
mov w1, #2
add w2, w0, w1 //Do 1 + 2.
mov w0, #0
ret
