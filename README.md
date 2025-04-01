<!---
{
  "depends_on": ["https://github.com/STEMgraph/99787eda-617a-4a68-b9a4-d60ec5c5c303"],
  "author": "Stephan Bökelmann",
  "first_used": "2025-04-01",
  "keywords": ["assembly", "NASM", "syscall", "write", "stdout", "Linux"]
}
--->

# Writing to the Terminal with NASM

## 1) Introduction

After learning how to exit a program via direct syscall ([link](https://github.com/STEMgraph/99787eda-617a-4a68-b9a4-d60ec5c5c303)), the next step is to **write data to the terminal**.

In high-level programming languages, printing to the terminal is usually done with all kinds of different functions involving the verb _print_. These usually call the `printf()` function – a function from the C standard library (`libc`), which is available on most every operating system today. But deep below, this call ultimately ends up invoking the Linux syscall `write` (or equivalent on other platforms).

We can skip all libraries and **call `write` directly** from assembly by using the appropriate syscall number (`1`) and passing arguments in the correct registers.

### The syscall interface for `write` on Linux x86_64:

| Register | Purpose             |
|----------|---------------------|
| `rax`    | Syscall number (`1`)|
| `rdi`    | File descriptor (`1` for stdout) |
| `rsi`    | Pointer to the string buffer     |
| `rdx`    | Length of the string             |

Here's a minimal NASM program that prints `Hello, world!` to the terminal:

```nasm
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
```

Assemble and run it.
This will print:

```
Hello, world!
```

Without using a high-level programming-language.

## 2) Tasks

1. **Change the Message**: Modify the string to print your name instead of `"Hello, world!"`.
2. **Add Two Lines**: Print two lines by using a second `write` syscall or by adding `10` (newline) at the right place in your data.
3. **Omit Newline**: Remove the newline and see how the output appears.
4. **Write to stderr**: Use file descriptor `2` instead of `1`. Observe the behavior.

## 3) Questions

1. What does the value `10` at the end of the message represent?
2. Why must the length of the message be provided manually in `rdx`?
3. What happens if the length is incorrect (too short, too long)?
4. Is it possible to write non-ASCII binary data using `write`?

<details>
  <summary>Syscall Reference</summary>

  Full Linux syscall list with register conventions:  
  https://blog.rchapman.org/posts/Linux_System_Call_Table_for_x86_64/
</details>

## 4) Advice

Working without the C runtime helps build a concrete understanding of how programs interact with the operating system. By writing directly to stdout using the `write` syscall, you're learning how higher-level abstractions like `printf` are built. Always remember: You control the bytes — and the CPU just obeys.
