data segment       ;the data segment
data ends

code segment      ;the code segment
assume cs:code, ds:data

main:                    ;the begining of the program
    mov ax, data
    mov ds, ax        ;register ds assignment

    mov ax, 0B800h
    mov es, ax         ;register es assignment, pointing to the video memory

    mov dl, 11         ;the counter to column
    mov dh, 25        ;the counter to row
    mov bx, 0          ;the number of element before the current location
    mov di, 0           ;the number of element above the current location
    
    mov ah,15
    int 10h
    mov ah,0
    int 10h               ;clear the screen

    mov al, 0            ;the counter to character

column:
    mov dh, 25         ;initialize the counter to row
    mov di, 0            ;initialize the number of element above the current location

row:
    mov byte ptr es:[bx+di], al
    mov byte ptr es:[bx+di+1], 0Ch      ;display the character
    

    mov ah, al  
    mov cl, 4  
    rol ah,cl              ;rotate left
    and ah, 00001111B        ;get the higher four bits
   
    cmp ah, 9
    ja letter2        ;if the number is bigger than 9, express it in letters
    add ah, '0'

output2:
    mov byte ptr es:[bx+di+2], ah
    mov byte ptr es:[bx+di+3], 0Ah    
    ;display the higher four bits of the ascii number


    mov ah, al    
    and ah, 00001111B     ;get the lower four bits
    cmp ah, 9
    ja letter3       ;if the number is bigger than 9, express it in letters
    add ah, '0'

output3:
    mov byte ptr es:[bx+di+4], ah
    mov byte ptr es:[bx+di+5], 0Ah 
    ;display the higher four bits of the ascii number


    add al, 1         ;change the counter to the character
    jz over            ;if the character is all displayed, end the program
    add di, 160     ;change the number of element above the current location
    sub dh, 1        ;change the counter to the row
    jnz row           ;continue to cycle


    add bx, 14      ;change the number of element before the current location
    sub dl, 1         ;change the counter to the column
    jnz column     ;continue to cycle

over:
    mov ah, 4Ch
    int 21h           ;end the program

letter2:               ;if the number is bigger than 9, use letter
    sub ah, 10
    add ah, 'A'
jmp output2

letter3:               ;if the number is bigger than 9, use letter
    sub ah, 10
    add ah, 'A'
jmp output3

code ends


end main
