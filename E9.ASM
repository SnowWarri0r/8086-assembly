assume cs:codesg,ds:datasg

datasg segment
  db 'welcome to masm!'
datasg ends

codesg segment
  start:mov ax,datasg
        mov ds,ax    ;指向数据段
        mov si,0     ;指向数据偏移地址
        mov ax,0b800h
        mov es,ax ;屏幕输出段

        mov bx,6e0h ;屏幕第12行
        mov di,42h  ;屏幕第34列
        mov cx,16
  write1:mov al,[si]
        mov es:[bx][di],al
        inc di
        mov byte ptr es:[bx][di],2 ;绿色字体
        inc si
        inc di
        loop write1

        mov si,0
        mov di,42h
        add bx,0a0h
        mov cx,16
  write2:mov al,[si]
        mov es:[bx][di],al
        inc di
        mov byte ptr es:[bx][di],24h ;绿底红字
        inc si
        inc di
        loop write2

        mov si,0
        mov di,42h
        add bx,0a0h
        mov cx,16
  write3:mov al,[si]
        mov es:[bx][di],al
        inc di
        mov byte ptr es:[bx][di],71h ;绿底红字
        inc si
        inc di
        loop write3

        mov ax,4c00h
        int 21h
codesg ends
end start