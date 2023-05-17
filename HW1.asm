data segment
s db 100 dup(0)        ;define an array s
t db 100 dup(0)        ;define an array t
data ends

code segment
assume cs:code, ds:data
main:
    mov ax, data         
    mov ds, ax         ;data segment address assignment
    mov si, 0            ;index initialize
    mov di, 0           ;index initialize
input:
    mov ah, 1          
    int 21h               ;input a char
    cmp al, 0Dh       ;compare with '\r'
    je inputend        ;if equal, end the input
    mov s[si], al       ;store the char into s
    add si, 1            ;change the index
    jmp input          ;continue to cycle
inputend:
    mov s[si], '$'      ;termination identifier
    mov si, 0            ;index innitialize
    mov ah, 2          
    mov dl, 0Dh
    int 21h               ;output the '\r'
    mov ah, 2 
    mov dl, 0Ah      ;output the '\n'
    int 21h
change:
    mov al, s[si]      
    cmp al, '$'         ;compare character with the termination identifier
    je changeend    ;if equal, end the change
    cmp al, 32         ;compare character with the blank
    je skip               ;if the character is blank, just skip it
    cmp al, 'a'         ;check if the character is a small letter
    jb copy
    cmp al, 'z'         ;check if the character is a small letter
    ja copy
    sub al, 32          ;change the small letter to a big letter
    jmp copy
copy:                  
    mov t[di], al      ;copy the character into t
    add di, 1           ;change the index
    add si, 1            ;change the index
    jmp change      ;continue to the cycle
skip:
    add si, 1           ;change the index         
    jmp change
changeend:
    mov t[di], '$'     ;termination identifier
    mov si, 0           ;index initialize
    mov di, 0          ;index initialize
output:
    cmp t[di], '$'     ;compare character with the termination identifier
    je outputend     ;if equal, end the output
    mov ah, 2
    mov dl, t[di]
    int 21h              ;output the character
    add di, 1
    jmp output       ;continue to cycle
outputend:
    mov ah, 2 
    mov dl, 0Dh   
    int 21h            ;output the '\r'
    mov ah, 2 
    mov dl, 0Ah
    int 21h            ;output the '\n'
    mov ah, 4Ch 
    int 21h            ;end the program
code ends

end main