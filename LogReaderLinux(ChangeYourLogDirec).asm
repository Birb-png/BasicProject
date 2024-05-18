section .data
    filename db '/var/log/syslog', 0
    buffer   db 1024 dup(0)

section .bss
    fd resb 4
    bytes_read resb 4

section .text
    global _start

_start:
    mov eax, 5
    mov ebx, filename
    mov ecx, 0
    mov edx, 0
    int 0x80
    mov [fd], eax

read_loop:
    mov eax, 3
    mov ebx, [fd]
    mov ecx, buffer
    mov edx, 1024
    int 0x80
    cmp eax, 0
    jle close_file
    mov [bytes_read], eax

    mov eax, 4
    mov ebx, 1
    mov ecx, buffer
    mov edx, [bytes_read]
    int 0x80

    jmp read_loop

close_file:
    mov eax, 6
    mov ebx, [fd]
    int 0x80

    mov eax, 1
    xor ebx, ebx
    int 0x80
