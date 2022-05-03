assume cs:codesg

datasg segment
           db "Beginner's All-purpose Symbolic Instruction Code.", 0
datasg ends

codesg segment
    begin:  mov  ax, datasg
            mov  ds, ax
            mov  si, 0
            call letterc

    endc:   mov  ax, 4c00h
            int  21h

    letterc:mov  al, [si]
            cmp  al, 0
            je   endc
            cmp  al, 97
            jb   next
            cmp  al, 122
            ja   next
            and  al, 11011111b
            mov  ds:[si], al
    next:   inc  si
            call letterc
codesg ends
end begin
