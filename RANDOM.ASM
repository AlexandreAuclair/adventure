; RANDOM NUMBER GENERATOR MODULE - FILE RANDOM.ASM
;
;---------------------------------data area begins------------------+
dseg   segment para public 'DATA'  ; data segment starts here
;
seed    dw  0B77Bh
;
dseg   ends                            ; data segment ends here
;----------------------------------data area ends-------------------+
;
;----------------------- code area starts --------------------------+
codes   segment 
;
;+++++++++++++++++++++++ public declarations start ++++++++++++++++++
        public  pseudorandom
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
pseudorandom    proc    far
        ;00110100 00000000
        mov     ax,seed
        shr     ax,1
        jnc     done
        xor     ax,0B400h
done:
        mov     seed,ax
        RET
pseudorandom    endp
;----------------------- routine ends ------------------------------+
;
codes   ends
;----------------------- code area ends ----------------------------+
        end
