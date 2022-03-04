assume cs:codesg,ss:stacksg

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

table segment
  db 21 dup ('year summ ne ?? ')
table ends

stacksg segment
  db 16 dup(0)
stacksg ends

codesg segment
start:  mov ax,data
        mov ds,ax ;将data段的地址赋值给ds

        mov ax,stacksg
        mov ss,ax ;将stacksg段的地址赋值给ss
        mov sp,10h ;将栈顶地址设置为16

        mov cx,21

        mov ax,table
        mov es,ax ;es:table段的地址
        mov si,0 ;si指向data段的第一个字节
        mov bx,0 ;bx指向table段的第一个字节

year:   mov di,0 ;di指向table段的第一个字节
        push cx
        mov cx,4

writeY: mov al,ds:[si]
        mov es:[bx+di],al
        inc si
        inc di
        loop writeY
        
        pop cx
        add bx,10h
        loop year

        mov cx,21
        mov bx,0

summ:   mov di,5 ;di指向table段的第5个字节

        push cx
        mov cx,2

writeS: mov ax,ds:[si]                
        mov es:[bx+di],ax
        add si,2
        add di,2
        loop writeS

        pop cx
        add bx,10h
        loop summ

        mov cx,21
        mov bx,0

worker: mov di,0ah ;di指向table段的第10个字节
        mov word ptr ax,ds:[si]
        mov word ptr es:[bx+di],ax
        add si,2
        add bx,10h
        loop worker

        mov cx,21
        mov bx,0
salary: mov di,5
        mov si,0ah
        mov ax,es:[bx+di]
        add di,2
        mov dx,es:[bx+di]

        div word ptr es:[bx+si]
        mov es:[bx+0dh],ax
        add bx,10h
        loop salary

        mov ax,4c00h
        int 21h

codesg ends
end start