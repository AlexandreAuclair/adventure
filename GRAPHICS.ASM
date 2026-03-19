; GRAPHIC MODULE - FILE GRAPHICS.ASM
;
;---------------------------------data area begins------------------+
dseg   segment para public 'DATA'                  ; data segment starts here
;
sprite  DW 0000h, 0F0FFh, 0F5FFh, 0500h, 0000h, 0FF0Fh, 0FFEFh, 00E0h
        DW 0000h, 80FFh, 0ABFFh, 2B00h, 0000h, 0FF01h, 0FFFDh, 00FCh
        DW 0000h, 00FFh, 55FFh, 5500h, 0000h, 0FF00h, 0FFFEh, 00FEh
        DW 0000h, 00FFh, 55FFh, 5500h, 0000h, 0FF00h, 0FF7Eh, 007Eh
        DW 0200h, 07FFh, 57FFh, 5700h, 0000h, 0FF00h, 0FF5Eh, 005Eh
        DW 0800h, 19FFh, 59FFh, 5900h, 0080h, 0FF90h, 0FF96h, 0096h
        DW 4800h, 19FCh, 19FDh, 5901h, 808Ah, 3F9Ah, 0BF9Ah, 809Ah
        DW 6200h, 27F0h, 07F5h, 6705h, 40A6h, 1FE6h, 0DFE6h, 0C0E6h
        DW 3801h, 18E0h, 02EBh, 3A0Bh, 601Ch, 0F1Ch, 0EFDDh, 0E0DDh
        DW 0F01h, 07E0h, 20EBh, 2F0Bh, 40F0h, 0EFF0h, 0EFF4h, 0E0F4h
        DW 0301h, 81F3h, 90F7h, 9307h, 00C0h, 5FC3h, 5FDBh, 40D8h
        DW 2401h, 24FBh, 01FBh, 2503h, 0024h, 0FF25h, 0FF25h, 0024h
        DW 4300h, 43FFh, 08FFh, 4B00h, 00C2h, 0FFC2h, 0FFDAh, 00DAh
        DW 3D00h, 8DFFh, 80FFh, 3D00h, 0080h, 0FF81h, 0FFB9h, 00B8h
        DW 3C00h, 04E8h, 00E8h, 3C00h, 0078h, 5F18h, 5F00h, 0078h
        DW 0000h, 00FAh, 00FAh, 0000h, 0078h, 0FF0Ah, 0FF02h, 0078h

        DW 0000h, 0F0FFh, 0F5FFh, 0500h, 0000h, 0FF0Fh, 0FFEFh, 00E0h
        DW 0000h, 80FFh, 0ABFFh, 2B00h, 0000h, 0FF01h, 0FFFDh, 00FCh
        DW 0000h, 00FFh, 55FFh, 5500h, 0000h, 0FF00h, 0FFFEh, 00FEh
        DW 0000h, 00FFh, 55FFh, 5500h, 0000h, 0FF00h, 0FF7Eh, 007Eh
        DW 0200h, 07FFh, 57FFh, 5700h, 0000h, 0FF00h, 0FF5Eh, 005Eh
        DW 0800h, 19FFh, 59FFh, 5900h, 0080h, 0FF90h, 0FF96h, 0096h
        DW 4800h, 19FCh, 19FDh, 5901h, 808Ah, 3F9Ah, 0BF9Ah, 809Ah
        DW 6200h, 27F8h, 07FBh, 6703h, 40A6h, 1FE6h, 0DFE6h, 0C0E6h
        DW 3800h, 18F0h, 02F5h, 3A05h, 401Ch, 1F1Ch, 0DFDDh, 0C0DDh
        DW 0F02h, 07F7h, 20F7h, 2F07h, 20F0h, 0FF0h, 0EFF4h, 0E0F4h
        DW 0302h, 0C1F6h, 0D0F6h, 1306h, 0A0C0h, 0CFC1h, 0EFD9h, 0E0D9h
        DW 2400h, 0A4FFh, 81FFh, 2500h, 4024h, 0DF24h, 0DF24h, 0C024h
        DW 4300h, 43FFh, 10FFh, 5300h, 00C2h, 0FFC2h, 0FFDAh, 00DAh
        DW 0100h, 0C1FFh, 0D8FFh, 1900h, 00BCh, 0FF8Dh, 0FF81h, 00BCh
        DW 1E00h, 06E8h, 00E8h, 1E00h, 003Ch, 5F04h, 5F00h, 003Ch
        DW 1E00h, 02FAh, 00FAh, 1E00h, 0000h, 0FF02h, 0FF02h, 0000h

tileset DW 0000h, 31FCh, 31FCh, 0CE03h, 0000h, 0CEE3h, 00E0h, 351Dh
        DW 0000h, 0CECBh, 00C0h, 0FF37h, 0000h, 0FFAFh, 0080h, 0FF5Fh
        DW 0000h, 0FF3Fh, 0000h, 0FFFFh, 0000h, 0FF7Fh, 0000h, 0FFBFh
        DW 0000h, 0FFFFh, 0080h, 0FF7Fh, 0000h, 0FF7Fh, 0000h, 0FFBFh
        DW 0000h, 0FF3Fh, 0000h, 0FFDFh, 0000h, 0FFBFh, 0080h, 0FF7Fh
        DW 0000h, 0FF1Fh, 0000h, 0FFFFh, 0000h, 0FF3Fh, 0000h, 0FFDFh
        DW 0000h, 0FF7Fh, 0000h, 0FFBFh, 0000h, 0FFFFh, 0080h, 0FF7Fh
        DW 0000h, 0FFBFh, 0080h, 0FF7Fh, 0000h, 0FF1Fh, 0000h, 0FFFFh

        DW 0000h, 318Ch, 318Ch, 0CE73h, 0000h, 0CE73h, 0000h, 0B5ADh
        DW 0000h, 0CE73h, 0000h, 0FFFFh, 0000h, 0FFFFh, 0000h, 0FFFFh
        DW 0000h, 0FFFFh, 0000h, 0FFFFh, 0000h, 0FFFFh, 0000h, 0FFFFh
        DW 0000h, 0FFFFh, 0000h, 0FFFFh, 0000h, 0FFFFh, 0000h, 0FFFFh
        DW 0000h, 0FFFFh, 0000h, 0FFFFh, 0000h, 0FFFFh, 0000h, 0FFFFh
        DW 0000h, 0FFFFh, 0000h, 0FFFFh, 0000h, 0FFFFh, 0000h, 0FFFFh
        DW 0000h, 0FFFFh, 0000h, 0FFFFh, 0000h, 0FFFFh, 0000h, 0FFFFh
        DW 0000h, 0FFFFh, 0000h, 0FFFFh, 0000h, 0FFFFh, 0000h, 0FFFFh

        DW 0000h, 3F8Ch, 3F8Ch, 0C073h, 0000h, 0C773h, 0700h, 0B8ACh
        DW 0000h, 0D373h, 0300h, 0ECFFh, 0000h, 0F5FFh, 0100h, 0FAFFh
        DW 0000h, 0FCFFh, 0000h, 0FFFFh, 0000h, 0FEFFh, 0000h, 0FDFFh
        DW 0000h, 0FFFFh, 0100h, 0FEFFh, 0000h, 0FEFFh, 0000h, 0FDFFh
        DW 0000h, 0FCFFh, 0000h, 0FBFFh, 0000h, 0FDFFh, 0100h, 0FEFFh
        DW 0000h, 0F8FFh, 0000h, 0FFFFh, 0000h, 0FCFFh, 0000h, 0FBFFh
        DW 0000h, 0FEFFh, 0000h, 0FDFFh, 0000h, 0FFFFh, 0100h, 0FEFFh
        DW 0000h, 0FDFFh, 0100h, 0FEFFh, 0000h, 0F8FFh, 0000h, 0FFFFh



anim    db      0
;
dseg   ends                            ; data segment ends here
;----------------------------------data area ends-------------------+
;
;----------------------- code area starts --------------------------+
codes   segment
;
;+++++++++++++++++++++++ public declarations start ++++++++++++++++++
        public  draw_sprite, draw_background
;+++++++++++++++++++++++ public declarations end ++++++++++++++++++++
;
        assume  cs:codes, ds:dseg
;----------------------- routines begins ---------------------------+
;FUNCTION: This routine send word to the video memory 4 planes
;INPUT:  CX and AX are given the x and y respectively
;OUTPUT: None
;REGISTERS USED: None
;SEGMENTS REFERENCED: None
;ROUTINES CALLED: None
;SPECIAL NOTES: None
;--------------------------------------------------------------------
; setup the keyboard for the game
draw_sprite      proc    far
        push    ds
        push    si
        push    di
        push    ax
        push    dx
        push    cx
        push    bx

        ; position = (y*80) + (x/8)
        mov     bx, 80
        mul     bx
        shr     cx, 1
        shr     cx, 1
        shr     cx, 1
        add     ax,cx
        mov     di,ax           ; Video memory offset
        mov     bx,ax
        add     bx,500h

        ;draw bitmap
        mov     si, offset sprite
        mov     al,ds:anim
        cmp     al,0
        je      draw_sprite1
        add     si,256
draw_sprite1:
        ; Set Write Plane Mask to Plane 0
        mov     dx, 03C4h
        mov     al, 02h

draw_sprite_y:
        mov     cx,2
draw_sprite_x:
        ; Set Write Plane Mask to Plane 0
        mov     ah,01h
        out     dx, ax
        movsw               ; Copy to video memory


        ; Set Write Plane Mask to Plane 1 
        mov     ah,02h
        out     dx,ax

        sub     di,2
        movsw               ; Copy to video memory

        ; Set Write Plane Mask to Plane 2
        mov     ah,04h
        out     dx,ax

        sub     di,2
        movsw               ; Copy to video memory

        ; Set Write Plane Mask to Plane 3
        mov     ah, 08h
        out     dx, ax

        sub     di,2
        movsw               ; Copy to video memory

        loop    draw_sprite_x
        sub     di,4
        add     di,50h
        cmp     di,bx
        jl      draw_sprite_y

        mov     al,ds:anim
        cmp     al,0
        jne     draw_sprite_anim
        mov     ds:anim,1
        jmp     draw_sprite_end
draw_sprite_anim:
        mov     ds:anim,0
draw_sprite_end:
        pop     bx
        pop     cx
        pop     dx
        pop     ax
        pop     di
        pop     si
        pop     ds
        ret
draw_sprite      endp
;----------------------- routine ends ------------------------------+
;
;----------------------- routines begins ---------------------------+
;FUNCTION: This routine send word to the video memory 4 planes to 
; writes a background at the specified location
;INPUT:  CX and BX are given the x and y respectively and AL is given
; the index of the bg sprite
;OUTPUT: None
;REGISTERS USED: None
;SEGMENTS REFERENCED: None
;ROUTINES CALLED: None
;SPECIAL NOTES: None
;--------------------------------------------------------------------
; setup the keyboard for the game
draw_background      proc    far
        push    ds
        push    si
        push    di
        push    ax
        push    dx
        push    cx
        push    bx

        mov     si, offset tileset      ; get the address
        mov     bx,128                  ; multiply the sprite index
        mul     bx                      ; by 128 to get the proper
        add     si,bx                   ; address

        pop     bx                      ; get the y coordinate back
        push    bx
        xchg    ax,bx                   ; put the y coord in AX

        ; position = (y*80) + (x/8)
        mov     bx, 80
        mul     bx
        shr     cx, 1
        shr     cx, 1
        shr     cx, 1
        add     ax,cx
        mov     di,ax           ; Video memory offset
        mov     bx,ax
        add     bx,500h 

        ; Set Write Plane Mask to Plane 0
        mov     dx, 03C4h
        mov     al, 02h

draw_background_y:
        ; Set Write Plane Mask to Plane 0
        mov     ah,01h
        out     dx, ax
        movsw               ; Copy to video memory


        ; Set Write Plane Mask to Plane 1 
        mov     ah,02h
        out     dx,ax

        sub     di,2
        movsw               ; Copy to video memory

        ; Set Write Plane Mask to Plane 2
        mov     ah,04h
        out     dx,ax

        sub     di,2
        movsw               ; Copy to video memory

        ; Set Write Plane Mask to Plane 3
        mov     ah, 08h
        out     dx, ax

        sub     di,2
        movsw               ; Copy to video memory

        sub     di,2
        add     di,50h
        cmp     di,bx
        jl      draw_background_y

        pop     bx
        pop     cx
        pop     dx
        pop     ax
        pop     di
        pop     si
        pop     ds
        ret
draw_background      endp
;----------------------- routine ends ------------------------------+


codes   ends
;----------------------- code area ends ----------------------------+
        end
