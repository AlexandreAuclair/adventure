; SOUND MODULE - FILE SOUND.ASM
;

;---------------------------------data area begins------------------+
dseg   segment para public 'DATA'          ; data segment starts here
;
op_table        db      0,1,2,8,9,10,16,17,18

note_table      dw      157h,16Bh,181h,198h,1B0h,1CAh,1E5h,202h,220h
                dw      241h,263h,287h

octave          db      0

music           db      093h,044h,094h,005h,092h,000h,000h,000h,000h ;00
                db      000h,000h,000h,000h,000h,000h,000h,000h,000h ;01
                db      000h,000h,000h,000h,000h,000h,000h,000h,000h ;02
                db      000h,000h,000h,000h,000h,000h,000h,000h,000h ;03
                db      000h,000h,000h,000h,000h,000h,000h,000h,000h ;04
                db      000h,000h,000h,000h,000h,000h,000h,000h,000h ;05
                db      000h,000h,000h,000h,000h,000h,000h,000h,000h ;06
                db      000h,000h,000h,000h,000h,000h,000h,000h,000h ;07
                db      000h,000h,000h,000h,000h,000h,000h,000h,000h ;08
                db      000h,000h,000h,000h,000h,000h,000h,000h,000h ;09
                db      000h,000h,000h,000h,000h,000h,000h,000h,000h ;0A
                db      000h,000h,000h,000h,000h,000h,000h,000h,000h ;0B
                db      000h,000h,000h,000h,000h,000h,000h,000h,000h ;0C
                db      000h,000h,000h,000h,000h,000h,000h,000h,000h ;0D
                db      000h,000h,000h,000h,000h,000h,000h,000h,000h ;0E
                db      000h,000h,000h,000h,000h,000h,000h,000h,000h ;0F
                db      043h,044h,074h,0B4h,042h,000h,000h,000h,000h ;10
                db      000h,000h,000h,000h,000h,000h,000h,000h,000h ;11
                db      000h,000h,000h,000h,000h,000h,000h,000h,000h ;12
                db      000h,000h,000h,000h,000h,000h,000h,000h,000h ;13
                db      000h,000h,000h,000h,000h,000h,000h,000h,000h ;14
                db      000h,000h,000h,000h,000h,000h,000h,000h,000h ;15
                db      000h,000h,000h,000h,000h,000h,000h,000h,000h ;16
                db      000h,000h,000h,000h,000h,000h,000h,000h,000h ;17
                db      000h,000h,000h,000h,000h,000h,000h,000h,000h ;18
                db      000h,000h,000h,000h,000h,000h,000h,000h,000h ;19
                db      000h,000h,000h,000h,000h,000h,000h,000h,000h ;1A
                db      000h,000h,000h,000h,000h,000h,000h,000h,000h ;1B
                db      000h,000h,000h,000h,000h,000h,000h,000h,000h ;1C
                db      000h,000h,000h,000h,000h,000h,000h,000h,000h ;1D
                db      000h,000h,000h,000h,000h,000h,000h,000h,000h ;1E
                db      000h,000h,000h,000h,000h,000h,000h,000h,000h ;1F
                db      023h,024h,064h,094h,022h,000h,000h,000h,000h ;20
                db      000h,000h,000h,000h,000h,000h,000h,000h,000h ;21
                db      000h,000h,000h,000h,000h,000h,000h,000h,000h ;22
                db      000h,000h,000h,000h,000h,000h,000h,000h,000h ;23
                db      000h,000h,000h,0B4h,000h,000h,000h,000h,000h ;24
                db      000h,000h,000h,000h,000h,000h,000h,000h,000h ;25
                db      000h,000h,000h,000h,000h,000h,000h,000h,000h ;26
                db      000h,000h,000h,000h,000h,000h,000h,000h,000h ;27
                db      000h,000h,000h,074h,000h,000h,000h,000h,000h ;28
                db      000h,000h,000h,000h,000h,000h,000h,000h,000h ;29
                db      000h,000h,000h,000h,000h,000h,000h,000h,000h ;2A
                db      000h,000h,000h,000h,000h,000h,000h,000h,000h ;2B
                db      000h,000h,000h,000h,000h,000h,000h,000h,000h ;2C
                db      000h,000h,000h,000h,000h,000h,000h,000h,000h ;2D
                db      000h,000h,000h,064h,000h,000h,000h,000h,000h ;2E
                db      000h,000h,000h,000h,000h,000h,000h,000h,000h ;2F
                db      003h,073h,004h,044h,002h,000h,000h,000h,000h ;30
                db      000h,000h,000h,000h,000h,000h,000h,000h,000h ;31
                db      000h,000h,000h,000h,000h,000h,000h,000h,000h ;32
                db      000h,000h,000h,000h,000h,000h,000h,000h,000h ;33
                db      000h,000h,000h,000h,000h,000h,000h,000h,000h ;34
                db      000h,000h,000h,000h,000h,000h,000h,000h,000h ;35
                db      000h,000h,000h,000h,000h,000h,000h,000h,000h ;36
                db      000h,000h,000h,000h,000h,000h,000h,000h,000h ;37
                db      000h,000h,000h,000h,000h,000h,000h,000h,000h ;38
                db      000h,000h,000h,000h,000h,000h,000h,000h,000h ;39
                db      000h,000h,000h,000h,000h,000h,000h,000h,000h ;3A
                db      000h,000h,000h,000h,000h,000h,000h,000h,000h ;3B
                db      000h,000h,000h,000h,000h,000h,000h,000h,000h ;3C
                db      000h,000h,000h,000h,000h,000h,000h,000h,000h ;3D
                db      000h,000h,000h,000h,000h,000h,000h,000h,000h ;3E
                db      000h,000h,000h,000h,000h,000h,000h,000h,000h ;3F

old_int8        dw      2 dup(0)
current_order   db      0
current_row     db      0
speed           db      4      ; ticks per row
tick_counter    db      0

curr_key        db      9 dup(0)
curr_note       db      9 dup(0)

;
dseg   ends                            ; data segment ends here
;----------------------------------data area ends-------------------+
;
;----------------------- stack segment begin -----------------------+
stacks  segment      stack
        db          20 dup('stack   ')
stacks  ends
;----------------------- stack segment end -------------------------+
;----------------------- code area starts --------------------------+
codes   segment 
;
;+++++++++++++++++++++++ public declarations start ++++++++++++++++++
        public  SetAdlib, UnsetAdlib
;+++++++++++++++++++++++ public declarations end ++++++++++++++++++++
;
;++++++++++++++++++++++++++++++++ externals begin +++++++++++++++++++
        extrn
;+++++++++++++++++++++++++++++++++ externals end ++++++++++++++++++++
        assume  cs:codes, ds:dseg

main            proc    far
        push    ds
        sub     ax,ax
        push    ax

        mov     ax,dseg
        mov     ds,ax

        call    SetAdlib

        mov     cx,9
set_instrument_for_the_9_channels:
        mov     bx,cx
        sub     bx,1
        call    ToneSet
        loop    set_instrument_for_the_9_channels
        mov     tick_counter,0
while:
        cmp     tick_counter,0
        jne     while
        inc     tick_counter
        mov     cx,9
set_note_for_the_9_channels:
        mov     bx,9
        mov     ah,0
        mov     al,current_row
        mul     bx
        lea     si,music
        add     si,ax           ;adding the current row index
        mov     bx,cx
        sub     bx,1
        mov     al,ds:[si+bx]
        cmp     al,curr_note[bx]
        je      sameNote
        mov     curr_note[bx],al
        call    ToneOff
sameNote:
        cmp     al,0
        je      nextNote
        and     al,0fh
        mov     octave,al
        mov     al,ds:[si+bx]
        shr     al,1
        shr     al,1
        shr     al,1            ; hi nibble is now low nibble
        xor     ah,ah
        mov     di,ax
        call    TonePlay
nextNote:
        loop    set_note_for_the_9_channels
        inc     current_row
        cmp     current_row,3Fh
        jle     while
        mov     current_row,0
        jmp     while
exit:
        call    UnsetAdlib
        ret
main            endp
;----------------------- routines begins ---------------------------+
;FUNCTION: None
;INPUT:  None
;OUTPUT: None
;REGISTERS USED: None
;SEGMENTS REFERENCED: None
;ROUTINES CALLED: None
;SPECIAL NOTES: None
;--------------------------------------------------------------------
;
SetAdlib        proc    near

        push    ds              ; enregistrer le segment data
        push    es
        push    ax
        push    dx
        push    bx

        mov     ah,35h          ; code lecture d'un vecteur d'interuption
        mov     al,08h          
        int     21h             ; requete a DOS
        mov     old_int8,bx      ; l'addresse nous est donné en ES:BX
        mov     bx,es
        mov     old_int8+2,bx

        mov     ax, seg Adlib_Handler
        mov     ds,ax
        mov     dx, offset Adlib_Handler
        mov     ax,2508h        ; set new interrupt vector with
        int     21h             ; address in DS:DX to index in AL

        pop     bx
        pop     dx
        pop     ax
        pop     es
        pop     ds
        ret

SetAdlib        endp
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
;
UnsetAdlib   proc    near

        push    ds
        push    ax
        push    dx

        mov     ax,old_int8
        mov     dx,ax
        mov     ax,old_int8+2
        mov     ds,ax
        mov     ax,2508h	; set new interrupt vector with
        int     21h             ; address in DS:DX to index in AL

        pop     dx
        pop     ax
        pop     ds

        ret

UnsetAdlib   endp
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
;
Adlib_Handler   proc    far

        push    ax
        push    ds
        mov     ax, dseg    ; Charge ton segment de données
        mov     ds, ax

        cli
        inc     tick_counter
        mov     al,speed
        cmp     tick_counter,al
        jne     Adlib_HandlerEnd
        mov     tick_counter,0
        sti

Adlib_HandlerEnd:
        pop     ds
        pop     ax
        jmp dword ptr cs:old_int8

Adlib_Handler   endp
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
;
setAdLibRegPair proc    near
        call    setAdLibReg     ;Set OP1
        add     al,3            ;Set OP2
setAdLibRegPair endp
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
;
setAdLibReg    proc    near
        push    ax
        push    dx
        cli
        mov     dx,0388H        ;Adlib port
        out     dx,al           ; 388 = address
        mov     al,ah
        inc     dx              ; 389 = data
        out     dx,al
        sti
        pop     dx
        pop     ax
        ret
setAdLibReg    endp
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
; Set up operations (addr and addr+3)
ToneSet        proc    near
        push    ax

        mov     al,op_table[bx]
        add     al,020h ; Multi /Key Scale Rate /EG-Type Tone
                        ; Vibrato / AM modulation
        ; AVEKMMMM A=AM V=VIB E=EG-Type K=KSR M=Mulitple
        mov     ah,11000010b
        call    setAdLibReg
        add     al,3
        mov     ah,11000010b
        call    setAdLibReg

        mov     al,op_table[bx]
        add     al,040h
        ; KKTTTTTT K=KeyScaleLevel T=Total Level of attenuation
        mov     ah,00010110b    ; Total Level / Key Scale Level
        call    setAdLibReg
        add     al,3
        mov     ah,00000000b
        call    setAdLibReg

        mov     al,op_table[bx]
        add     al,060h
        ; AAAADDDD A=Attack D=Decay
        mov     ah,10100000b    ; Decay Rate / Attack Rate
        call    setAdLibReg
        add     al,3
        mov     ah,01000000b
        call    setAdLibReg

        mov     al,op_table[bx]
        add     al,080h
        ; SSSSRRRR S=Sustain R=Release
        mov     ah,11110011b    ; Release Rate / Sustain Level
        call    setAdLibReg
        add     al,3
        mov     ah,11110011b
        call    setAdLibReg

        mov     al,op_table[bx]
        add     al,0E0h
        ; ------WW W=Wave Select
        mov     ah,00000001b    ; Wave Select
        call    setAdLibReg
        add     al,3
        mov     ah,00000010b
        call    setAdLibReg

        ;Set up channel
        mov     al,0C0h
        add     al,bl
        ; ----FFFC F=Feedback C=Connection (op combination mode)
        mov     ah,00000100b ; FeedBack factor/ Connect sine/fm
        call    setAdLibReg

        mov     al,0BDh
        ; DDRBSTCH D=Depth (AM/VIB) R=Rythm B=Bass(13,16)
        ; S=Snare(17) T=Tom(15) C=Cymbal(18) H=Hihat(14)
        mov     ah,00000000b    ; Rythem mode (Chn 7-9)/Vibrato Depth
        call    setAdLibReg     ; AM Depth

        pop     ax

        ret
ToneSet        endp
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
; Set up operations (addr and addr+3)
TonePlay        proc    near
        push    ax

        mov     al,0A0h
        add     al,bl
        ; FFFFFFFF F=Fnumber L
        mov     dx,note_table[di]    ; F number
        mov     ah,dl
        call    setAdLibReg

        mov     al,0B0h
        add     al,bl
        ; --KBBBFF F=Fnumber H B=Block K=K-on - Channel ON
        mov     ah,octave    ; Block / K-ON
        shl     ah,1
        shl     ah,1
        or      ah,20h
        add     ah,dh
        call    setAdLibReg

        mov     curr_key[bx],ah

        pop     ax

        ret
TonePlay        endp
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
; Set up operations (addr and addr+3)
ToneOff        proc    near
        push    ax
       
        mov     al,0B0h
        add     al,bl
        mov     ah,curr_key[bx]
        and     ah,1fh
        call    setAdLibReg

        pop     ax

        ret
ToneOff        endp
;----------------------- routine ends ------------------------------+

codes   ends
;----------------------- code area ends ----------------------------+
        end
