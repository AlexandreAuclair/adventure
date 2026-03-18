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
;
dseg   ends                            ; data segment ends here
;----------------------------------data area ends-------------------+
;
;----------------------- code area starts --------------------------+
codes   segment
;
;+++++++++++++++++++++++ public declarations start ++++++++++++++++++
        public  draw_sprite
;+++++++++++++++++++++++ public declarations end ++++++++++++++++++++
;
        assume  cs:codes, ds:dseg
;----------------------- routines begins ---------------------------+
;FUNCTION: None
;INPUT:  None
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

        mov     ax, dseg
        mov     ds, ax

        ;draw bitmap
        mov     si, offset sprite
        ; Set Write Plane Mask to Plane 0
        mov     dx, 03C4h
        mov     al, 02h



        mov     di,0                ; Video memory offset

y_loop:
        mov     cx,2
x_loop:
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

        loop    x_loop
        sub     di,4
        add     di,50h
        cmp     di,0500h
        jl      y_loop


        pop     cx
        pop     dx
        pop     ax
        pop     di
        pop     si
        pop     ds
        ret
draw_sprite      endp
;----------------------- routine ends ------------------------------+


codes   ends
;----------------------- code area ends ----------------------------+
        end
