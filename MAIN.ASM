; MAIN PROGRAM - FILE TEST.ASM
;
;
;+++++++++++++++++++++++ public declarations start ++++++++++++++++++
;+++++++++++++++++++++++ public declarations end ++++++++++++++++++++
;+++++++++++++++++++++++ externals begin ++++++++++++++++++++++++++++
        extrn  setup:far,input:far,update:far,render:far,running:far
        extrn  clean:far
;+++++++++++++++++++++++ externals end ++++++++++++++++++++++++++++++
;----------------------- stack segment begin -----------------------+
stacks  segment      stack
        db          20 dup('stack   ')
stacks  ends
;----------------------- stack segment end -------------------------+
;----------------------- data area begins --------------------------+
dseg    segment public                  ; data segment starts here
;
MSG             DB      "HELLO GAMERZ!"
;
dseg    ends                            ; data segment ends here
;----------------------- data area ends ----------------------------+
;----------------------- code area starts --------------------------+
codes   segment

        assume  cs:codes, ds:dseg, ss:stacks
MAIN    proc    far

        push    ds
        sub     ax,ax
        push    ax

        mov     ax,dseg
        mov     ds,ax

        mov     ax,0A000h
        mov     es,ax

        call    setup

main_loop:
        call    input
        call    update
        call    render

continue_loop:
        call    running
        cmp     al,1
        je      main_loop

        call    clean
        ret
MAIN    endp

codes   ends
;----------------------- code area ends ----------------------------+
        end
