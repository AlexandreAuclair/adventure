; COLLISION MODULE - FILE COLLI.ASM
;
;---------------------------------data area begins------------------+
dseg   segment para public 'DATA'  ; data segment starts here
;
flag    db      0
;
dseg   ends                            ; data segment ends here
;----------------------------------data area ends-------------------+
;
;----------------------- code area starts --------------------------+
codes   segment 
;
;+++++++++++++++++++++++ public declarations start ++++++++++++++++++
        public  dist, checkdist16,flag
;+++++++++++++++++++++++ public declarations end ++++++++++++++++++++
;
;++++++++++++++++++++++++++++++++ externals begin +++++++++++++++++++
        extrn  
;+++++++++++++++++++++++++++++++++ externals end ++++++++++++++++++++
        assume  cs:codes, ds:dseg
;----------------------- routines begins ---------------------------+
;FUNCTION: None
;INPUT: DI & DX are x1 & y1 and AX & BX are x2 & y2
;OUTPUT: the distance squared is return in AX
;REGISTERS USED: None
;SEGMENTS REFERENCED: None
;ROUTINES CALLED: None
;SPECIAL NOTES: None
;--------------------------------------------------------------------
; calculate the distance between 2 points
dist        proc    far
        push    cx
        push    si
        push    dx
        push    di

        sub     bx,dx       ; y2 - y1
        mov     si,ax     
        mov     ax,bx  
        imul    bx          ; dy^2

        mov     cx,ax

        sub     si,di       ; x2 - x1
        mov     ax,si       
        imul    si          ; dx^2

        add     ax,cx       ; dx^2 + dy^2

        pop     di
        pop     dx
        pop     si
        pop     cx
        
        ret

dist        endp
;----------------------- routine ends ------------------------------+
;
;----------------------- routines begins ---------------------------+
;FUNCTION: None
;INPUT: DI & DX are x1 & y1 and AX & BX are x2 & y2
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
        push    ax
        push    bx

        mov     ds:flag,0

        sub     ax,di
        jns     .ok
        neg     ax
.ok:
        cmp     ax,16
        jb      checkY
        mov     ds:flag,1
        jmp     .end
checkY:
        sub     bx,dx
        jns     .ok2
        neg     bx
.ok2:
        cmp     bx,16
        jb      .end
        mov     ds:flag,1
.end:
        pop     bx
        pop     ax
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