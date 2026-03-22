; GAME MODULE - FILE GAME.ASM
;
include KEYBOARD.INC
include OBJECT.INC
;---------------------------------data area begins------------------+
dseg   segment para public 'DATA'                 ; data segment starts here
;
isRunning       db      0

player          Object  <>

background      DB      0Ch,20h,39h,15h,15h,38h,22h,3Dh,3Dh,3Dh
                DB      3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh
                DB      3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh
                DB      3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,0Eh

                DB      0Ch,3Dh,20h,39h,38h,22h,0Dh,0Dh,3Dh,0Dh
                DB      0Dh,0Dh,0Dh,0Dh,3Dh,3Dh,0Dh,0Dh,3Dh,0Dh
                DB      0Dh,0Dh,3Dh,0Dh,59h,0Dh,0Dh,0Dh,0Dh,0Dh
                DB      0Dh,3Dh,0Dh,0Dh,0Dh,3Dh,0Dh,59h,0Dh,0Eh
                
                DB      0Ch,0Dh,3Dh,14h,16h,0Dh,0Dh,59h,3Dh,3Dh
                DB      0Dh,59h,59h,0Dh,04h,05h,05h,05h,05h,05h
                DB      05h,05h,05h,06h,0Dh,0Dh,3Dh,0Dh,0Dh,3Dh
                DB      3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,0Dh,0Dh,0Dh,0Eh

                DB      0Ch,0Dh,3Dh,14h,16h,3Dh,3Dh,3Dh,3Dh,3Dh
                DB      3Dh,3Dh,0Dh,0Dh,10h,11h,11h,71h,11h,40h
                DB      71h,40h,11h,5Ah,05h,06h,3Dh,3Dh,3Dh,3Dh
                DB      0Dh,0Dh,3Dh,3Dh,3Dh,0Dh,0Dh,0Dh,0Dh,0Eh

                DB      0Ch,0Dh,3Dh,14h,16h,3Dh,0Dh,0Dh,04h,05h
                DB      05h,05h,05h,05h,5Bh,11h,11h,11h,71h,11h
                DB      40h,40h,11h,11h,11h,5Ah,05h,06h,3Dh,3Dh
                DB      3Dh,3Dh,3Dh,3Dh,2Fh,3Dh,3Dh,0Dh,0Dh,0Eh

                DB      0Ch,3Dh,3Dh,14h,16h,3Dh,3Dh,04h,5Bh,11h
                DB      11h,11h,11h,11h,11h,11h,11h,11h,11h,40h
                DB      11h,11h,40h,11h,11h,11h,11h,5Bh,05h,05h
                DB      06h,3Dh,3Dh,3Dh,0Dh,0Dh,0Dh,0Dh,3Dh,0Eh

                DB      29h,29h,29h,0ABh,0ABh,29h,29h,0AAh,11h,11h
                DB      11h,11h,40h,71h,11h,11h,11h,11h,11h,27h
                DB      40h,11h,11h,40h,71h,40h,71h,40h,11h,11h
                DB      5Ah,06h,0Dh,3Dh,3Dh,3Dh,3Dh,3Dh,0Dh,0Eh

                DB      0Ch,0Dh,0Dh,14h,16h,0Dh,3Dh,1Ch,1Dh,4Fh
                DB      11h,40h,71h,40h,11h,11h,11h,40h,71h,40h
                DB      71h,11h,11h,11h,11h,11h,11h,11h,11h,11h
                DB      11h,12h,0Dh,3Dh,3Dh,3Dh,3Dh,3Dh,0Dh,0Eh

                DB      0Ch,0Dh,3Dh,14h,16h,0Dh,3Dh,3Dh,3Dh,1Ch
                DB      4Fh,11h,11h,40h,40h,11h,11h,71h,40h,71h
                DB      11h,11h,4Eh,1Dh,1Dh,1Dh,1Dh,4Fh,11h,11h
                DB      4Eh,1Eh,3Dh,0Dh,0Dh,3Dh,3Dh,3Dh,0Dh,0Eh

                DB      0Ch,0Dh,3Dh,14h,16h,0Dh,0Dh,0Dh,0Dh,3Dh
                DB      1Ch,1Dh,1Dh,1Dh,1Dh,1Dh,1Dh,1Dh,1Dh,1Dh
                DB      1Dh,1Dh,1Eh,3Dh,3Dh,3Dh,0Dh,1Ch,1Dh,1Dh
                DB      1Eh,0Dh,0Dh,0Dh,0Dh,3Dh,3Dh,3Dh,3Dh,0Eh

                DB      0Ch,0Dh,0Dh,14h,16h,0Dh,0Dh,59h,0Dh,0Dh
                DB      0Dh,59h,59h,0Dh,0Dh,3Dh,3Dh,0Dh,0Dh,59h
                DB      0Dh,0Dh,59h,0Dh,0Dh,3Dh,0Dh,0Dh,0Dh,0Dh
                DB      0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Eh

                DB      18h,19h,19h,14h,16h,19h,19h,19h,19h,19h
                DB      19h,19h,19h,19h,19h,19h,19h,19h,19h,19h
                DB      19h,19h,19h,19h,19h,19h,19h,19h,19h,19h
                DB      19h,19h,19h,19h,19h,19h,19h,19h,19h,1Ah

;
dseg   ends                            ; data segment ends here
;----------------------------------data area ends-------------------+
;
;----------------------- code area starts --------------------------+
codes   segment 
;
;+++++++++++++++++++++++ public declarations start ++++++++++++++++++
        public  setup,input,update,render,running,clean
;+++++++++++++++++++++++ public declarations end ++++++++++++++++++++
;
;++++++++++++++++++++++++++++++++ externals begin +++++++++++++++++++
        extrn  set_keyboard:far,unset_keyboard:far,Keys:BYTE
        extrn  draw_sprite:far,draw_background:far
        extrn  sendBufferToVRAM:far,dec8out:far
        extrn  SetPIT:far,InstallIRQ0:far,RestoreIRQ0:far
;+++++++++++++++++++++++++++++++++ externals end ++++++++++++++++++++
        assume  cs:codes, ds:dseg
;----------------------- routines begins ---------------------------+
;FUNCTION: This routine setup the game
;INPUT:  None
;OUTPUT: None
;REGISTERS USED: No register is modified. AX is used to set ISRUNNING
;SEGMENTS REFERENCED: DSEG is a data segment which contains ISRUNNING
;ROUTINES CALLED: None
;SPECIAL NOTES: None
;--------------------------------------------------------------------
; setup the game rules and variables
setup      proc    far
        push    ds
        push    ax

        sti

        mov     ds:isRunning,1
        call    set_keyboard

        mov     player.x,60
        mov     player.y,20

        MOV     AH, 0      ; 0=SET VIDEO MODE (AL=MODE)
        MOV     AL, 14     ; MODE 14 (EGA 320x200 16 colors)
        INT     10H        ; BIOS INT

        pop     ax
        pop     ds
        RET
setup      endp
;----------------------- routine ends ------------------------------+
;----------------------- routines begins ---------------------------+
;FUNCTION: None
;INPUT:  None
;OUTPUT: None
;REGISTERS USED: None
;SEGMENTS REFERENCED: None
;ROUTINES CALLED: None
;SPECIAL NOTES: None
;--------------------------------------------------------------------
; check for player input
input      proc    far
        push    ax
        push    si

        mov     si,KEY_KEYPAD_8
        cmp     ds:Keys[si],0
        je      no_up
        sub     player.y,4
no_up:
        mov     si,KEY_KEYPAD_2
        cmp     ds:Keys[si],0
        je      no_down
        add     player.y,4
no_down:
        mov     si,KEY_KEYPAD_4
        cmp     ds:Keys[si],0
        je      no_left
        sub     player.x,8
no_left:
        mov     si,KEY_KEYPAD_6
        cmp     ds:Keys[si],0
        je      no_right
        add     player.x,8
no_right:


        mov     si,KEY_ESC
        mov     al, ds:Keys[si]
        cmp     al,0
        je      exit
        
        mov     ds:isRunning,0
exit:
        pop     si
        pop     ax
        RET
input      endp
;----------------------- routine ends ------------------------------+
;
;----------------------- routines begins ---------------------------+
;FUNCTION: None
;INPUT:  None
;OUTPUT: None
;REGISTERS USED: None
;SEGMENTS REFERENCED: None
;ROUTINES CALLED: None
;SPECIAL NOTES: None
;--------------------------------------------------------------------
; update any object position or logic of the game
update      proc    far
        
        RET
update      endp
;----------------------- routine ends ------------------------------+
;
;----------------------- routines begins ---------------------------+
;FUNCTION: None
;INPUT:  None
;OUTPUT: None
;REGISTERS USED: None
;SEGMENTS REFERENCED: None
;ROUTINES CALLED: None
;SPECIAL NOTES: None
;--------------------------------------------------------------------
; render all the game object and background
render      proc    far
        mov     si, 0           ; index map
        mov     bx, 0           ; y
        mov     ax, 0
y_loop:
        mov     cx, 0          ; x

x_loop:
        mov     al,ds:background[si]
        call    draw_background
        inc     si
        add     cx,16
        cmp     cx,640
        jl      x_loop
        add     bx,16
        cmp     bx,184
        jl      y_loop


        mov     cx,player.x
        mov     ax,player.y
        call    draw_sprite

        call    sendBufferToVRAM
        RET
render      endp
;----------------------- routine ends ------------------------------+
;
;----------------------- routines begins ---------------------------+
;FUNCTION: This routine return the variable running
;INPUT:  None
;OUTPUT: return running is 1 in AL
;REGISTERS USED: AL is use for ouput.
;SEGMENTS REFERENCED: DSEG is a data segment which contains RUNNING.
;ROUTINES CALLED: None
;SPECIAL NOTES: None
;--------------------------------------------------------------------
; check if the game is running
running      proc    far
        push    ds

        mov     al,ds:isRunning

        pop     ds
        ret
running      endp
;----------------------- routine ends ------------------------------+
;
;----------------------- routines begins ---------------------------+
;FUNCTION: This routine clean the game of the thing we did.
;INPUT:  None
;OUTPUT: None
;REGISTERS USED: None
;SEGMENTS REFERENCED: None
;ROUTINES CALLED: None
;SPECIAL NOTES: None
;--------------------------------------------------------------------
; clean the computer memory
clean      proc    far
        call    unset_keyboard

        MOV     AH, 0      ; 0=SET VIDEO MODE (AL=MODE)
        MOV     AL, 2      ; MODE 2 (CGA 80x25 txt 16 colors)
        INT     10H        ; BIOS INT
        cli

        ret
clean      endp
;----------------------- routine ends ------------------------------+
codes   ends
;----------------------- code area ends ----------------------------+
        end
