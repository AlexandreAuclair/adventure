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
        push    bx

        sub     cx,dx       ; y2 - y1
        shl     cx,1
        mov     ax,cx       
        imul    cx          ; dy^2

        mov     bx,ax

        sub     si,di       ; x2 - x1
        mov     ax,si       
        imul    si          ; dx^2

        add     ax,bx       ; dx + dy

        pop     bx
        
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
        jns     .ok
        neg     si
.ok:
        cmp     si,50
        jb      checkY
        mov     ah,1
        jmp     .end
checkY:
        sub     cx,dx
        jns     .ok2
        neg     cx
.ok2:
        cmp     cx,50
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