assume cs:code
a segment
        db 1,2,3,4,5,6,7,8
a ends

b segment
        db 1,2,3,4,5,6,7,8
b ends

c segment
        db 0,0,0,0,0,0,0,0
c ends

code segment
start: mov bx,0
       mov cx,4
       mov ax,c
       mov ds,ax

       mov ax,a
       mov es,ax

       mov ax,b
       mov ss,ax
       mov sp,0

    s: mov dx,0
       pop dx
       add dx,es:[bx]
       mov ds:[bx],dx
       add bx,2
       loop s
       mov ax,4c00h
       int 21h
code ends

end start
