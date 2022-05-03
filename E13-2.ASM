assume cs:code
code segment
start:              mov ax,cs
                    mov ds,ax
                    mov si,offset lp
                    mov ax,0
                    mov es,ax
                    mov di,200h
                    ; 串传送指令，执行es:di = ds:si cx次
                    mov cx,offset lpend-offset lp
                    cld
                    rep movsb
                    mov ax,0
                    mov es,ax
                    mov word ptr es:[7ch*4],200h
                    mov word ptr es:[7ch*4+2],0
                    ; 装载中断例程
                    mov ax,0b800h
                    mov es,ax
                    mov di,160*12
                    mov bx,offset s-offset se
                    mov cx,80
s:                  mov byte ptr es:[di],'!'
                    add di,2
                    int 7ch
se:                 nop
                    mov ax,4c00h
                    int 21h
lp:                 push bp
                    mov bp,sp
                    dec cx
                    jcxz ok
                    add [bp+2],bx
ok:                 pop bp
                    iret
lpend:              nop
code ends
end start