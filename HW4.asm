.386p
data segment use16
num1 db 6,0,6 dup(0)
num2 db 6,0,6 dup(0)
s db 10 dup(' '),0Dh,0Ah,'$'
data ends

code segment use16
assume cs:code, ds:data

tochar:         ;把数字转化成十六进制输出的字符
    cmp bl,10
    jb digit
char:        ;大于等于10
    sub bl,10
    add bl,'A'
    ret
digit:       ;小于10
    add bl,'0'
    ret

main:
    mov ax,data
    mov ds,ax    ;ds赋值

input_num1:    ;输入第一个大数
    mov dx,offset num1
    mov ah,0Ah
    int 21h

    ;输出回车换行
    mov ah, 2          
    mov dl, 0Dh
    int 21h              
    mov ah, 2 
    mov dl, 0Ah     
    int 21h

    ;补上字符串结束符
    mov ax,0
    mov al,num1[1]
    mov di,ax
    add di,2
    mov num1[di],'$'  

strtodig1:      ;把字符串转化为大数
    mov ax,0
    sub di,1
    mov bp,2

loop1:
    mov cl,num1[bp]
    sub cl,'0'
    mov bx,10
    mul bx
    add ax,cx
    inc bp
    cmp bp,di
    jbe loop1

    ;将转化后的数字1压入堆栈
    push ax

input_num2:        ;输入第二个大数
    mov dx,offset num2
    mov ah,0Ah
    int 21h

    ;输出回车换行
    mov ah, 2          
    mov dl, 0Dh
    int 21h            
    mov ah, 2 
    mov dl, 0Ah    
    int 21h

    ;补上字符串结束符
    mov ax,0
    mov al,num2[1]
    mov di,ax
    add di,2
    mov num2[di],'$'  

strtodig2:     ;把字符串转化为大数
    sub di,1
    mov ax,0
    mov bp,2

loop2:
    mov cl,num2[bp]
    sub cl,'0'
    mov bx,10
    mul bx
    add ax,cx
    inc bp
    cmp bp,di
    jbe loop2

    push ax
    
multi:    ;两个大数相乘
    mov eax,0
    pop ax
    mov bx,ax
    pop ax
    mul bx
    mov cl,16
    shl edx,cl
    add eax,edx
    push eax

output_num:    ;输出两个大数相乘的算式
    mov dx,offset num1
    add dx,2
    mov ah,09h
    int 21h

    mov ah, 2          
    mov dl, '*'
    int 21h

    mov dx,offset num2
    add dx,2
    mov ah,09h
    int 21h

    mov ah, 2 
    mov dl, '='   
    int 21h

    mov ah, 2          
    mov dl, 0Dh
    int 21h               ;output the '\r'
    mov ah, 2 
    mov dl, 0Ah      ;output the '\n'
    int 21h

    pop ebx
output_res10:    ;以10进制输出
    push ebx
    push edx

    mov bp,0    ;s数组下标
    mov cx,0    ;记录十进制数字的个数
    mov eax,ebx

divide10:
    mov edx,0
    mov ebx,10
    div ebx    ;除以10
    add dl,'0'
    push dx    ;把余数转化为字符压入堆栈
    inc cx
    cmp eax,0
    jne divide10    ;继续除10

save10:    ;从堆栈中pop出每位数字并记录在s数组中
    pop dx
    mov s[bp],dl
    inc bp
    dec cx
    jnz save10

    mov ah,9
    mov dx,offset s
    int 21h        ;输出s

    pop edx
    pop ebx

output_res16:    ;16进制输出
    push ebx
    mov dh,8
    mov cl,0

loop16:
    pop ebx
    push ebx
    add cl,4
    rol ebx,cl        ;循环左移
    and bx,000Fh    ;做与运算，取最低的四位

out16:        ;把数字转化成字符并输出
    call tochar   
    mov dl, bl
    mov ah,2
    int 21h

    sub dh,1
    jne loop16

    mov ah, 2          
    mov dl, 'h'
    int 21h        ;输出字符'h'

    ;输出回车换行
    mov ah,2
    mov dl,0Dh
    int 21h        

    mov ah,2
    mov dl,0Ah
    int 21h        

    pop ebx

output_res2:    ;二进制输出
    mov dh,32
    mov si,4    ;是否输出每四位之间的空格的控制变量

loop3:
    shl ebx,1;       ;输出每一个二进制位
    mov dl, '1'
    jc out2
    sub dl,1

out2:   
    mov ah,2
    int 21h            

    sub si,1
    jnz next_out2 

again:        ;重置si，并输出每四位之间的空格
    cmp dh,1
    je next_out2 
    mov si,4
    mov ah, 2          
    mov dl, ' '
    int 21h

next_out2:
    sub dh,1
    jne loop3;

    mov ah, 2          ;输出字符'B'
    mov dl, 'B'
    int 21h

over:
    mov ah, 4Ch 
    int 21h            ;程序结束
code ends

end main
