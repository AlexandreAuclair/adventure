; SOUND MODULE - FILE SOUND.ASM
;
;---------------------------------data area begins------------------+
dseg   segment para public 'DATA'                 ; data segment starts here
;
;
dseg   ends                            ; data segment ends here
;----------------------------------data area ends-------------------+
;
;----------------------- code area starts --------------------------+
codes   segment 
;
;+++++++++++++++++++++++ public declarations start ++++++++++++++++++
        public  
;+++++++++++++++++++++++ public declarations end ++++++++++++++++++++
;
;++++++++++++++++++++++++++++++++ externals begin +++++++++++++++++++
        extrn  
;+++++++++++++++++++++++++++++++++ externals end ++++++++++++++++++++
        assume  cs:codes, ds:dseg

main    proc    far

        push    ds
        sub     ax,ax
        push    ax

        mov     ax,dseg
        mov     ds,ax

        mov     bh,0
        mov     bl,0

        xor     ax,ax
AdlibReset:
        call    setAdLibReg
        dec     al
        jnz     AdlibReset

        call    DoPauseL
        call    ToneTest
        call    DoPauseL
        call    DrumTest
        call    DoPauseL
        call    ToneTest
        call    DoPauseL
        call    DrumTest
        call    DoPauseL
        call    CymbTest

        ret
main    endp
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
        push    ax
        call    setAdLibReg     ;Set OP1
        pop     ax
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
        mov     dx,0388H        ;Adlib port
        out     dx,al           ; 388 = address
        mov     al,ah
        inc     dx              ; 389 = data
        out     dx,al
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
ToneTest        proc    near
        mov     al,020H         ; Multi /Key Scale Rate /EG-Type Tone
                                ; Vibrato / AM modulation
        ; AVEKMMMM A=AM V=VIB E=EG-Type K=KSR M=Mulitple
        mov     ah,00000001b
        call    setAdLibRegPair

        mov     al,040h
        ; KKTTTTTT K=KeyScaleLevel T=Total Level
        mov     ah,00000000b    ; Total Level / Key Scale Level
        call    setAdLibRegPair

        mov     al,060h
        ; AAAADDDD A=Attack D=Decay
        mov     ah,11110000b    ; Decay Rate / Attack Rate
        call    setAdLibRegPair

        mov     al,080h
        ; SSSSRRRR S=Sustain R=Release
        mov     ah,11110100b    ; Release Rate / Sustain Level
        call    setAdLibRegPair

        mov     al,0E0h
        ; ------WW W=Wave Select
        mov     ah,00000000b    ; Wave Select
        call    setAdLibReg

        ;Set up channel
        mov     al,0C0h
        ; ----FFFC F=Feedback C=Connection (op combination mode)
        mov     ah,00100000b    ; FeedBack factor/ Connect sine/fm
        call    setAdLibReg

        mov     al,0A0h
        ; FFFFFFFF F=Fnumber L
        mov     ah,11111111b    ; F number
        call    setAdLibReg

        mov     al,0B0h
        ; --KBBBFF F=Fnumber H B=Block K=K-on - Channel ON
        mov     ah,00101000b    ; Block / K-ON
        call    setAdLibReg

        call    DoPause

        mov     al,0B0h
        ; --KBBBFF F=Fnumber H B=Block K=K-on - Channel OFF
        mov     ah,00001000b    ; Block / K-OFF
        call    setAdLibReg

        ret
ToneTest        endp
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
DrumTest        proc    near
        mov     al,030H         ; Multi /Key Scale Rate /EG-Type Tone
                                ; Vibrato / AM modulation
        ; AVEKMMMM A=AM V=VIB E=EG-Type K=KSR M=Mulitple
        mov     ah,00000001b
        call    setAdLibRegPair

        mov     al,050h
        ; KKTTTTTT K=KeyScaleLevel T=Total Level
        mov     ah,00000000b    ; Total Level / Key Scale Level
        call    setAdLibRegPair

        mov     al,070h
        ; AAAADDDD A=Attack D=Decay
        mov     ah,11110000b    ; Decay Rate / Attack Rate
        call    setAdLibRegPair

        mov     al,090h
        ; SSSSRRRR S=Sustain R=Release
        mov     ah,00000100b    ; Release Rate / Sustain Level
        call    setAdLibRegPair

        mov     al,0F0h
        ; ------WW W=Wave Select
        mov     ah,00000000b    ; Wave Select
        call    setAdLibReg

        ;Set up channel
        mov     al,0C6h
        ; ----FFFC F=Feedback C=Connection (op combination mode)
        mov     ah,00100110b    ; FeedBack factor/ Connect sine/fm
        call    setAdLibReg

        mov     al,0A6h
        ; FFFFFFFF F=Fnumber L
        mov     ah,01111111b    ; F number
        call    setAdLibReg

        mov     al,0BDh
        ; DDRBSTCH D=Depth (AM/VIB) R=Rythm B=Bass(13,16)
        ; S=Snare(17) T=Tom(15) C=Cymbal(18) H=Hihat(14)
        mov     ah,00110000b    ; Rythem mode (Chn 7-9)/Vibrato Depth
        call    setAdLibReg     ; AM Depth

        call    DoPause

        mov     al,0BDh
        ; DDRBSTCH D=Depth (AM/VIB) R=Rythm B=Bass(13,16)
        ; S=Snare(17) T=Tom(15) C=Cymbal(18) H=Hihat(14)
        mov     ah,00100000b    ; Rythem mode (Chn 7-9)/Vibrato Depth
        call    setAdLibReg     ; AM Depth

        ret
DrumTest        endp
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
CymbTest        proc    near
        mov     al,035H         ; Multi /Key Scale Rate /EG-Type Tone
                                ; Vibrato / AM modulation
        ; AVEKMMMM A=AM V=VIB E=EG-Type K=KSR M=Mulitple
        mov     ah,00001000b
        call    setAdLibRegPair

        mov     al,055h
        ; KKTTTTTT K=KeyScaleLevel T=Total Level
        mov     ah,00000000b    ; Total Level / Key Scale Level
        call    setAdLibRegPair

        mov     al,075h
        ; AAAADDDD A=Attack D=Decay
        mov     ah,11110000b    ; Decay Rate / Attack Rate
        call    setAdLibRegPair

        mov     al,095h
        ; SSSSRRRR S=Sustain R=Release
        mov     ah,00000100b    ; Release Rate / Sustain Level
        call    setAdLibRegPair

        mov     al,0F0h
        ; ------WW W=Wave Select
        mov     ah,00000000b    ; Wave Select
        call    setAdLibReg

        ;Set up channel
        mov     al,0C8h
        ; ----FFFC F=Feedback C=Connection (op combination mode)
        mov     ah,00101110b    ; FeedBack factor/ Connect sine/fm
        call    setAdLibReg

        mov     al,0A8h
        ; FFFFFFFF F=Fnumber L
        mov     ah,11111111b    ; F number
        call    setAdLibReg

        mov     al,0BDh
        ; DDRBSTCH D=Depth (AM/VIB) R=Rythm B=Bass(13,16)
        ; S=Snare(17) T=Tom(15) C=Cymbal(18) H=Hihat(14)
        mov     ah,00100010b    ; Rythem mode (Chn 7-9)/Vibrato Depth
        call    setAdLibReg     ; AM Depth

        call    DoPause

        mov     al,0BDh
        ; DDRBSTCH D=Depth (AM/VIB) R=Rythm B=Bass(13,16)
        ; S=Snare(17) T=Tom(15) C=Cymbal(18) H=Hihat(14)
        mov     ah,00100000b    ; Rythem mode (Chn 7-9)/Vibrato Depth
        call    setAdLibReg     ; AM Depth

        ret
CymbTest        endp
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
DoPauseL    proc    near
        mov     cx,0FFFFh
DelayL:
        mov     bx,25
DelayL2:
        dec     bx
        jne     DelayL2

        loop    DelayL
        ret
DoPauseL    endp
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
DoPause     proc    near
        mov     cx,1000h
Delay3:
        loop    Delay3
        ret
DoPause     endp
;----------------------- routine ends ------------------------------+
codes   ends
;----------------------- code area ends ----------------------------+
        end
