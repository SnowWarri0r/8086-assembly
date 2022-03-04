assume es:data,cs:code,ss:stack
data segment
  db '1975','1976','1977','1978','1979','1980','1981','1982','1983'
  db '1984','1985','1986','1987','1988','1989','1990','1991','1992'
  db '1993','1994','1995'
  ;以上是表示21年的21个字符串

  dd 16,22,382,1356,2390,8000,16000,24486,50065,97479,140417,197514
  dd 345980,590827,803530,1183000,1843000,2759000,3753000,4649000,5937000
  ;以上是表示21年公司总收入的21个dword型数据

  dw 3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4037,5635,8226
  dw 11542,14430,15257,17800
  ;以上是表示21年公司雇员人数的21个word型数据
data ends

stack segment
  dw 16 dup(0)
stack ends

table segment
  db 21 dup ('????',0,'   ???????    ?????    ??? ')
table ends

code segment

  start:    mov ax,data
            mov es,ax
            mov ax,stack
            mov ss,ax
            mov sp,32
            mov ax,table
            mov ds,ax
            ; 初始化程序

            mov cx,21
            mov di,0 ;di指向data段的数据

      year: push cx
            mov cx,2
            mov si,0 ;di作为二维偏移量

    writeY: mov dx,es:[di]
            mov [si],dx
            add si,2
            add di,2
            loop writeY

            pop cx
            mov ax,ds
            add ax,2
            mov ds,ax
            loop year

            mov ax,table
            mov ds,ax
            mov cx,21
            mov si,8
            
      summ: mov ax,es:[di]
            mov dx,es:[di+2]
            add di,4
            call dtoc
            mov ax,ds
            add ax,2
            mov ds,ax
            loop summ

            mov ax,table
            mov ds,ax
            mov cx,21
            mov si,19
            mov dx,0

    worker: mov ax,es:[di]
            add di,2
            call dtoc
            mov ax,ds
            add ax,2
            mov ds,ax
            loop worker

            mov ax,table
            mov ds,ax

            ;两个指针
            mov bx,84
            mov di,168

            mov si,28
            mov cx,21

      cal:  mov ax,es:[bx]
            mov dx,es:[bx+2]
            add bx,4
            div word ptr es:[di]
            add di,2
            mov dx,0
            call dtoc
            mov ax,ds
            add ax,2
            mov ds,ax
            loop cal

            mov ax,table
            mov ds,ax
            mov cx,21
            mov dh,4

    display:push cx
            mov dl,6
            mov cl,7
            mov si,0
            call show_str
            add dl,8
            add si,8
            call show_str
            add dl,11
            add si,11
            call show_str
            add dl,9
            add si,9
            call show_str
            mov ax,ds
            add ax,2
            mov ds,ax
            inc dh
            pop cx
            loop display
            mov ax,4c00h
            int 21h

  ;功能：将dword型数据转变为表示十进制数的字符串，字符串以0为结尾符
  ;参数：ax=dword型数据的低16位，dx=dword型数据的高16位，ds:si指向字符串的首地址
  ;返回：无
  dtoc:     push ax
            push si
            push cx
            push dx
            push di
            push bx

            mov di,si ;保存si到di

        s:  mov cx,10
            call divdw
            add cx,30h
            mov [si],cl ;把余数+30h存入[si]
            inc si
            mov cx,ax ;把低位商存入cx
            jcxz detect_hi ;如果cx为0，则说明低位商为0，然后检测高位商
            jmp s

  detect_hi:mov cx,dx ;把高位商存入cx
            jcxz ok ;如果cx为0，则说明高位商为0，那么数字被除尽了
            jmp s   ;如果cx不为0，则继续循环

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
            
      over: pop bx
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