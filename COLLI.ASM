; COLLISION MODULE - FILE COLLI.ASM
;
;---------------------------------data area begins------------------+
dseg   segment para public 'DATA'  ; data segment starts here
;
;
dseg   ends                            ; data segment ends here
;----------------------------------data area ends-------------------+
;
;----------------------- code area starts --------------------------+
codes   segment 
;
;+++++++++++++++++++++++ public declarations start ++++++++++++++++++
        public  dist, checkdist16
;+++++++++++++++++++++++ public declarations end ++++++++++++++++++++
;
;++++++++++++++++++++++++++++++++ externals begin +++++++++++++++++++
        extrn  
;+++++++++++++++++++++++++++++++++ externals end ++++++++++++++++++++
        assume  cs:codes, ds:dseg
;----------------------- routines begins ---------------------------+
;FUNCTION: None
;INPUT: DI & DX are x1 & y1 and SI & CX are x2 & y2
;OUTPUT: the distance squared is return in AX
;REGISTERS USED: None
;SEGMENTS REFERENCED: None
;ROUTINES CALLED: None
;SPECIAL NOTES: None
;--------------------------------------------------------------------
; calculate the distance between 2 points
dist        proc    far

        sub     cx,dx       ; y2 - y1
        mov     ax,cx       
        mov     bx,cx
        mul     bx          ; dy^2

        mov     cx,ax

        sub     si,di       ; x2 - x1
        mov     ax,si       
        mov     bx,si
        mul     bx          ; dx^2

        add     ax,cx       ; dx + dy
        
        ret

dist        endp
;----------------------- routine ends ------------------------------+
;
;----------------------- routines begins ---------------------------+
;FUNCTION: None
;INPUT: DI & DX are x1 & y1 and SI & CX are x2 & y2
;OUTPUT: return boolean in ax
;REGISTERS USED: None
;SEGMENTS REFERENCED: None
;ROUTINES CALLED: None
;SPECIAL NOTES: None
;--------------------------------------------------------------------
; calculate if the distances is close enough
checkdist16     proc    far

        push    di
        push    dx
        push    si
        push    cx

        sub     si,di
        cmp     si,255
        jb      checkY
        mov     ah,1
        jmp     .end
checkY:
        sub     cx,dx
        cmp     cx,255
        jb      .end
        mov     al,1
.end:
        pop     cx
        pop     si
        pop     dx
        pop     di
        
        ret

checkdist16     endp
;----------------------- routine ends ------------------------------+
;
codes   ends
;----------------------- code area ends ----------------------------+
        end
