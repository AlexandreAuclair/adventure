; KEYBOARD MODULE - FILE KEYBOARD.ASM
;
;---------------------------------data area begins------------------+
dseg   segment para public 'DATA'                  ; data segment starts here
;
old_isr         dw      2 dup(0)
Keys            db      256 dup(0)      ;array to store key states (0 = released, 1 = pressed)
;
dseg   ends                            ; data segment ends here
;----------------------------------data area ends-------------------+
;
;----------------------- code area starts --------------------------+
codes   segment
;
;+++++++++++++++++++++++ public declarations start ++++++++++++++++++
        public  set_keyboard,unset_keyboard,Keys
;+++++++++++++++++++++++ public declarations end ++++++++++++++++++++
;
        assume  cs:codes, ds:dseg
;----------------------- routines begins ---------------------------+
;FUNCTION: This routine save the old interrupt subroutine into 
; OLD_ISR, then set the new isr as the KEYBOARD_HANDLER routine
;INPUT:  None
;OUTPUT: None
;REGISTERS USED: No register is used. AX, BX, DX, DS and ES are use
; for transfering the address.
;SEGMENTS REFERENCED: Segment DSEG is use to store the old isr.
;ROUTINES CALLED: None
;SPECIAL NOTES: If you don't call UNSET_KEYBOARD at the end of the 
; program, you won't be able to type.
;--------------------------------------------------------------------
; setup the keyboard for the game
set_keyboard      proc    far
        push    ds              ; enregistrer le segment data
        push    es
        push    ax
        push    dx
        push    bx

        mov     ah,35h          ; code lecture d'un vecteur d'interuption
        mov     al,09h          ; index de la table de vecteur qui coresspond au clavier
        int     21h             ; requete a DOS
        mov     old_isr,bx      ; l'addresse nous est donné en ES:BX
        mov     bx,es
        mov     old_isr+2,bx

        mov     ax, seg keyboard_handler
        mov     ds,ax
        mov     dx, offset keyboard_handler
        mov     ax,2509h        ; set new interrupt vector with
        int     21h             ; address in DS:DX to index in AL

        pop     bx
        pop     dx
        pop     ax
        pop     es
        pop     ds
        ret
set_keyboard      endp
;----------------------- routine ends ------------------------------+
;
;----------------------- routines begins ---------------------------+
;FUNCTION: This routine take the old interrupt subroutine of the 
; keyboard from the OLD_ISR variable and put it back into the
; interrupt vector.
;INPUT:  None
;OUTPUT: None
;REGISTERS USED: No register is used. AX, DX and DS are used to 
; transfer the address into the interrupt vector
;SEGMENTS REFERENCED: Segment DSEG is use to store the old isr.
;ROUTINES CALLED: None
;SPECIAL NOTES: None
;--------------------------------------------------------------------
; unset the keyboard to the normal keyboard interrupts
unset_keyboard      proc    far
        push    ds
        push    ax
        push    dx

        mov     ax,old_isr
        mov     dx,ax
        mov     ax,old_isr+2
        mov     ds,ax
        mov     ax,2509h	; set new interrupt vector with
        int     21h             ; address in DS:DX to index in AL

        pop     dx
        pop     ax
        pop     ds

        ret
unset_keyboard      endp
;----------------------- routine ends ------------------------------+
;
;----------------------- routines begins ---------------------------+
;FUNCTION: This routine handles how the computer respond to keyboard 
; pressed.
;INPUT:  None
;OUTPUT: None
;REGISTERS USED: No register are used. AX,DX are use to old integers.
; DS is used to access the KEYS array. SI is use to count the index.
;SEGMENTS REFERENCED: DSEG is use to store the KEYS array
;ROUTINES CALLED: None
;SPECIAL NOTES: None
;--------------------------------------------------------------------
; new interrupt keyboard handler
keyboard_handler    proc    far

        push    ax
        push    dx
        push    ds
        push    si

        mov     ah,0
        in      al,60h          ;Read scan code from keyboard
        mov     dl,al           ;store in DL

        test    al,80h          ;check if break code (key released)
        jz      key_pressed

        and     al,7fh          ;convert break code to make code
        mov     dh,0            ;dh = 0 (key released)
        jmp     store_key

key_pressed:
        mov     dh,1            ;dh = 1 (key pressed)

store_key:
        mov     si,ax           ;SI = scan code
        mov     [Keys + SI],dh  ;Store key state in array

;Acknowledge the keyboard controller
        in      al,61h          ;check kbd status port
        or      al,80h          ;Disable the keyboard
        out     61h,al
        and     al,7fh          ;re-enable the keyboard
        out     61h,al
;Send End-of-Interrupt (EOI) signal to the PIC
        mov     al,20h
        out     20h,al

        pop     si
        pop     ds
        pop     dx
        pop     ax
        iret

keyboard_handler        endp
;----------------------- routine ends ------------------------------+

codes   ends
;----------------------- code area ends ----------------------------+
        end
