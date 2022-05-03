assume cs:code
data segment
    db "welcome to masm! ",0
data ends
code segment
start:              mov ax,cs
                    mov ds,ax
                    mov si,offset show_str
                    mov ax,0
                    mov es,ax
                    mov di,200h
                    ; 串传送指令，执行es:di = ds:si cx次
                    mov cx,offset show_str_end-offset show_str
                    cld
                    rep movsb
                    mov ax,0
                    mov es,ax
                    mov word ptr es:[7ch*4],200h
                    mov word ptr es:[7ch*4+2],0
                    ; 以上为中断程序安装
                    mov dh,10
                    mov dl,10
                    mov cl,2
                    mov ax,data
                    mov ds,ax
                    mov si,0
                    int 7ch
                    mov ax,4c00h
                    int 21h

        show_str:   push dx
                    push si
                    push cx
                    push bx
                    push es
                    push ax
                    push di

                    mov ax,0b800h 
                    mov es,ax ;es指向显存

                    mov al,dl
                    mov ah,0
                    mov di,ax
                    add di,di ;di储存列号

                    mov ax,0a0h
                    mov bl,dh
                    mov bh,0
                    mul bx
                    mov bx,ax ;bx储存行号

                    mov al,cl
                    mov ah,0  ;ax储存颜色

            output: mov cl,[si]
                    mov ch,0
                    jcxz str_ok
                    mov ah,[si]
                    mov es:[bx+di],ah
                    inc di
                    mov es:[bx+di],al
                    inc di
                    inc si
                    jmp output

            str_ok: pop di
                    pop ax
                    pop es
                    pop bx
                    pop cx
                    pop si
                    pop dx
                    iret
show_str_end:       nop
code ends
end start