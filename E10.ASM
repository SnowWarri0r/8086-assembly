assume cs:code

data segment
  dw 8 dup(0)
  db 'Hello, World!',0
data ends

stack segment
  dw 16 dup(0)
stack ends

code segment


  start:    mov ax,stack
            mov ss,ax
            mov sp,32
            mov ax,data
            mov ds,ax

            mov ax,12666
            mov si,0
            call dtoc

            mov dh,8
            mov dl,3
            mov cl,2
            call show_str


            ; 除法函数测试代码
            ; mov ax,4240h
            ; mov dx,000fh
            ; mov cx,0ah
            ; call divdw
            ; 字符串显示函数测试代码
            ; mov si,0
            ; mov cl,71h
            ; mov dh,12
            ; mov dl,32
            ; call show_str

            mov ax,4c00h
            int 21h
  ;功能：将word型数据转变为表示十进制数的字符串，字符串以0为结尾符
  ;参数：ax=word型数据，ds:si指向字符串的首地址
  ;返回：无
  dtoc:     push ax
            push si
            push cx
            push dx
            push di
            push bx

            mov di,si ;保存si到di
            mov bx,10

          s:mov dx,0
            div bx
            mov cx,ax ;把商存入cx
            add dx,30h
            mov [si],dl ;把余数+30h存入[si]
            inc si
            jcxz ok
            jmp s


        ok: mov byte ptr [si],0
            mov ax,si ;ax是字符串长度
            sub ax,di
            mov bx,2
            div bl ;除以2得到的商是需要反转的字符长度
            mov cl,al ;将商存入cl
            mov ch,0
            jcxz over

            mov bx,di ;bx指向开头
            dec si ;si指向结尾

        re: mov al,[si] ;用al缓存字符
            mov dl,[bx]
            mov [si],dl
            mov [bx],al
            inc bx
            dec si
            loop re
            
    over:   pop bx
            pop di
            pop dx
            pop cx
            pop si
            pop ax
            ret


  ;功能：进行不会产生溢出的除法运算，被除数为dword型，除数为word型，结果为dword型
  ;参数：ax=dword型数据的低16位，dx=dword型数据的高16位，cx=除数
  ;返回：dx=结果的高16位，ax=结果的低16位，cx=余数
  divdw:    push di
            push bx

            mov bx,ax ;低16位保存到bx
            mov ax,dx ;高16位保存到ax
            mov dx,0 ;高16位清0
            div cx ;用高位除以除数，即H/N
            mov di,ax ;保存高位商到di

            mov ax,bx ;恢复低16位
            div cx ;用低位和高位除以除数得到的余数除以除数，即[rem(H/N)*65536+L]/N
            mov cx,dx ;保存余数到cx
            mov dx,di ;恢复高位商到dx

            pop bx
            pop di
            ret



  ;功能：在指定的位置，用指定的颜色，显示一个用0结束的字符串
  ;参数：dh=行号（0-24），dl=列号（0-79）， cl=颜色，ds:si指向字符串的首地址
  ;返回值：无
  show_str: push ds
            push dx
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
            pop ds
            ret
code ends
end start

