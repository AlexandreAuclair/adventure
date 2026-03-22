; SOUND MODULE - FILE SOUND.ASM
;
;---------------------------------data area begins------------------+
dseg   segment para public 'DATA'          ; data segment starts here
;
op_table        db      0,1,2,8,9,10,16,17,18

note_table      dw      157h,16Bh,181h,198h,1B0h,1CAh,1E5h,202h,220h
                dw      241h,263h,287h

octave          db      0

music           db      04h,14h,24h,34h,44h,54h,64h,74h,84h,94h,0A4h
                db      0B4h

old_int8        dw      2 dup(0)
music_index     dw      0
;
dseg   ends                            ; data segment ends here
;----------------------------------data area ends-------------------+
;
;----------------------- code area starts --------------------------+
codes   segment 
;
;+++++++++++++++++++++++ public declarations start ++++++++++++++++++
        public  InstallIRQ0, SetPIT, RestoreIRQ0
;+++++++++++++++++++++++ public declarations end ++++++++++++++++++++
;
;++++++++++++++++++++++++++++++++ externals begin +++++++++++++++++++
        extrn  
;+++++++++++++++++++++++++++++++++ externals end ++++++++++++++++++++
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
;
AudioTick       proc    far

        mov     di,music_index
        call    ToneSet
        mov     al,music[di]
        and     al,0fh
        mov     octave,al
        mov     al,music[di]
        shr     al,1
        shr     al,1
        shr     al,1
        mov     si,ax
        call    TonePlay
        inc     di
        cmp     di,12
        jl      increment
        mov     music_index,0
        jmp     exit
increment:
        mov     music_index,di
exit:
        ret

AudioTick       endp
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
        mov     dx,0388H        ;Adlib port
        out     dx,al           ; 388 = address
        mov     al,ah
        inc     dx              ; 389 = data
        out     dx,al
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
        mov     ah,00000111b
        call    setAdLibRegPair

        mov     al,op_table[bx]
        add     al,040h
        ; KKTTTTTT K=KeyScaleLevel T=Total Level of attenuation
        mov     ah,00000000b    ; Total Level / Key Scale Level
        call    setAdLibRegPair

        mov     al,op_table[bx]
        add     al,060h
        ; AAAADDDD A=Attack D=Decay
        mov     ah,11100010b    ; Decay Rate / Attack Rate
        call    setAdLibRegPair

        mov     al,op_table[bx]
        add     al,080h
        ; SSSSRRRR S=Sustain R=Release
        mov     ah,11110100b    ; Release Rate / Sustain Level
        call    setAdLibRegPair

        mov     al,op_table[bx]
        add     al,0E0h
        ; ------WW W=Wave Select
        mov     ah,00000000b    ; Wave Select
        call    setAdLibReg

        ;Set up channel
        mov     al,0C0h
        add     al,bl
        ; ----FFFC F=Feedback C=Connection (op combination mode)
        mov     ah,00000000b ; FeedBack factor/ Connect sine/fm
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
        mov     dx,note_table[si]    ; F number
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

        ; --KBBBFF F=Fnumber H B=Block K=K-on - Channel OFF
        and     ah,0001111b    ; Block / K-OFF
        call    setAdLibReg

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
DrumTest        proc    near
        mov     al,030H         ; Multi /Key Scale Rate /EG-Type Tone
                                ; Vibrato / AM modulation
        ; AVEKMMMM A=AM V=VIB E=EG-Type K=KSR M=Mulitple
        mov     ah,00000001b
        call    setAdLibRegPair

        mov     al,050h
        ; KKTTTTTT K=KeyScaleLevel T=Total Level of attenuation
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
        mov     ah,11111111b
        call    setAdLibRegPair

        mov     al,055h
        ; KKTTTTTT K=KeyScaleLevel T=Total Level of attenuation
        mov     ah,00000000b    ; Total Level / Key Scale Level
        call    setAdLibRegPair

        mov     al,075h
        ; AAAADDDD A=Attack D=Decay
        mov     ah,11110000b    ; Decay Rate / Attack Rate
        call    setAdLibRegPair

        mov     al,095h
        ; SSSSRRRR S=Sustain R=Release
        mov     ah,0000011b    ; Release Rate / Sustain Level
        call    setAdLibRegPair

        mov     al,0F5h
        ; ------WW W=Wave Select
        mov     ah,00000000b    ; Wave Select
        call    setAdLibReg

        ;Set up channel
        mov     al,0C8h
        ; ----FFFC F=Feedback C=Connection (op combination mode)
        mov     ah,00001110b    ; FeedBack factor/ Connect sine/fm
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

codes   ends
;----------------------- code area ends ----------------------------+
        end
