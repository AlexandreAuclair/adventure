; GAME MODULE - FILE GAME.ASM
;
include KEYBOARD.INC
;---------------------------------data area begins------------------+
dseg   segment para public 'DATA'                 ; data segment starts here
;
isRunning       db      0
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
        mov     ax,dseg
        mov     ds,ax

        mov     al,1
        mov     isRunning,al
        call    set_keyboard

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
        push    ds
        push    ax
        push    si

        mov     ax,dseg
        mov     ds,ax

        mov     si,KEY_ESC
        mov     al, Keys[si]
        cmp     al,0
        je      exit
        
        mov     al,0
        mov     isRunning,al
exit:
        pop     si
        pop     ax
        pop     ds
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

        mov     ax,dseg
        mov     ds,ax

        mov     al,isRunning

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