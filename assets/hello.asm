; file: hello.asm
section .data
    message db "Hello, world!", 10 ; 10 is newline (\n)
    len equ $ - message   ; location-counter $ - address of message

section .text
    global _start

_start:
    mov     rax, 1      ; syscall: write
    mov     rdi, 1      ; file descriptor: stdout
    mov     rsi, message ; pointer to message
    mov     rdx, len     ; message length
    syscall

    ; exit(0)
    mov     rax, 60     ; syscall: exit
    xor     rdi, rdi    ; xor rdi with itself to produce a 0 
    syscall