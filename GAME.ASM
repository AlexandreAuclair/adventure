; GAME MODULE - FILE GAME.ASM
;
include KEYBOARD.INC
include OBJECT.INC
;---------------------------------data area begins------------------+
dseg   segment para public 'DATA'  ; data segment starts here
;
isRunning       db      0
current_screen  db      0

player          Object  <>
enemies         Object  200 DUP(<>)
Boss            Object  <>

background      db 73h,0Dh,3Dh,0Dh,3Dh,0Dh,59h,10h,11h,11h,11h,12h,59h,0Dh,3Dh,0Dh,3Dh,0Dh,3Dh,73h
                db 73h,3Dh,0Dh,3Dh,0Dh,3Dh,0Dh,1Ch,4Fh,11h,4Eh,1Eh,0Dh,3Dh,0Dh,3Dh,0Dh,3Dh,0Dh,73h
                db 73h,0Dh,3Dh,0Dh,3Dh,0Dh,3Dh,59h,10h,11h,12h,59h,3Dh,0Dh,3Dh,0Dh,3Dh,0Dh,3Dh,73h
                db 73h,3Dh,08h,09h,0Ah,3Dh,0Dh,3Dh,10h,11h,12h,3Dh,0Dh,3Dh,0Dh,08h,09h,0Ah,0Dh,73h
                db 73h,0Dh,14h,15h,16h,0Dh,3Dh,59h,10h,11h,12h,59h,3Dh,0Dh,3Dh,14h,15h,16h,3Dh,73h
                db 73h,3Dh,20h,21h,22h,3Dh,0Dh,3Dh,10h,11h,12h,3Dh,0Dh,3Dh,0Dh,20h,21h,22h,0Dh,73h
                db 73h,0Dh,3Dh,0Dh,3Dh,0Dh,3Dh,59h,10h,11h,12h,59h,3Dh,0Dh,3Dh,3Dh,3Dh,0Dh,3Dh,73h
                db 73h,3Dh,59h,3Dh,59h,3Dh,59h,3Dh,10h,11h,12h,3Dh,0Dh,3Dh,0Dh,3Dh,0Dh,3Dh,0Dh,73h
                db 73h,59h,04h,05h,05h,05h,29h,29h,1Dh,1Dh,1Eh,0Dh,3Dh,0Dh,3Dh,0Dh,3Dh,0Dh,3Dh,73h
                db 73h,04h,11h,11h,11h,12h,0Dh,59h,3Dh,59h,3Dh,59h,0Dh,3Dh,0Dh,3Dh,0Dh,3Dh,0Dh,73h
                db 7Fh,1Ch,1Dh,1Dh,1Dh,1Eh,3Dh,0Dh,3Dh,0Dh,3Dh,0Dh,3Dh,0Dh,3Dh,0Dh,3Dh,0Dh,3Dh,7Fh
                db 7Bh,3Dh,59h,3Dh,59h,3Dh,59h,3Dh,0Dh,3Dh,0Dh,3Dh,0Dh,3Dh,0Dh,3Dh,0Dh,3Dh,0Dh,7Bh

                db 38h,39h,38h,39h,38h,39h,38h,87h,38h,39h,38h,39h,38h,39h,38h,39h,38h,39h,38h,39h
                db 44h,45h,44h,45h,44h,45h,44h,6Fh,44h,45h,44h,45h,44h,45h,44h,87h,44h,45h,44h,45h
                db 15h,15h,15h,15h,15h,15h,15h,6Fh,15h,85h,85h,85h,15h,15h,15h,6Fh,15h,15h,15h,15h
                db 21h,21h,21h,21h,87h,21h,21h,6Fh,21h,85h,2Fh,85h,21h,21h,21h,6Fh,21h,21h,21h,21h
                db 79h,79h,79h,79h,6Fh,79h,79h,6Fh,79h,84h,0ABh,86h,79h,79h,79h,6Fh,79h,79h,79h,79h
                db 6Ah,6Ah,6Ah,6Ah,6Fh,6Ah,6Ah,6Fh,6Ah,6Fh,0ABh,6Fh,0A5h,0A5h,6Ah,6Fh,75h,75h,75h,75h
                db 6Ah,6Ah,6Ah,6Ah,6Fh,6Ah,6Ah,6Fh,6Ah,6Fh,0ABh,6Fh,0A5h,0A5h,6Ah,6Fh,75h,75h,75h,75h
                db 6Ah,6Ah,6Ah,6Ah,6Fh,6Ah,6Ah,7Bh,6Ah,6Fh,0ABh,6Fh,0A5h,0A5h,6Ah,6Fh,75h,75h,75h,75h
                db 6Ah,6Ah,6Ah,6Ah,6Fh,6Ah,6Ah,6Ah,6Ah,6Fh,0ABh,6Fh,0A5h,0A5h,6Ah,6Fh,75h,75h,75h,75h
                db 6Ah,6Ah,6Ah,6Ah,6Fh,6Ah,6Ah,6Ah,6Ah,6Fh,0ABh,6Fh,0A5h,0A5h,6Ah,6Fh,75h,75h,75h,75h
                db 6Ah,6Ah,6Ah,6Ah,6Fh,6Ah,6Ah,6Ah,6Ah,6Fh,0ABh,6Fh,6Ah,6Ah,6Ah,7Bh,75h,75h,75h,75h
                db 6Ah,6Ah,6Ah,6Ah,6Fh,6Ah,6Ah,6Ah,6Ah,90h,0ABh,92h,6Ah,6Ah,6Ah,6Ah,75h,75h,75h,75h


act1            db      "Epstein's Island",10,"The new adventure begin!",0
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
        extrn  draw_sprite:far,draw_background:far
        extrn  sendBufferToVRAM:far,dec16out:far,pseudorandom:far
        extrn  dist:far,checkdist16:far,print_text:far,flag:byte
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

        mov     ds:isRunning,1
        call    set_keyboard

        mov     player.x,280
        mov     player.y,80
        mov     player.radius,100h      ; radius^2

        mov     cx,max_enemies
        xor     si,si

init_enemies:
        mov word ptr enemies[si].x,280
        mov word ptr enemies[si].y,100
        mov word ptr enemies[si].radius,100h
        add     si,objectsize
        loop    init_enemies

init_boss:
        mov     boss.x,152
        mov     boss.y,92

        

        MOV     AH, 0      ; 0=SET VIDEO MODE (AL=MODE)
        MOV     AL, 13     ; MODE 14 (EGA 320x200 16 colors)
        INT     10H        ; BIOS INT

        pop     ax
        pop     ds
        RET
setup      endp
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
; check for player input
input      proc    far
        push    ax
        push    si

        mov     si,KEY_KEYPAD_8
        cmp     ds:Keys[si],0
        je      no_up
        sub     player.y,2
no_up:
        mov     si,KEY_KEYPAD_2
        cmp     ds:Keys[si],0
        je      no_down
        add     player.y,2
no_down:
        mov     si,KEY_KEYPAD_4
        cmp     ds:Keys[si],0
        je      no_left
        sub     player.x,4
no_left:
        mov     si,KEY_KEYPAD_6
        cmp     ds:Keys[si],0
        je      no_right
        add     player.x,4
no_right:


        mov     si,KEY_ESC
        mov     al, ds:Keys[si]
        cmp     al,0
        je      exit
        
        mov     ds:isRunning,0
exit:
        pop     si
        pop     ax
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

        mov     cx,max_enemies
        xor     si,si
moveEnemies:
        cmp byte ptr enemies[si].tick_walk,0
        je      change_direction

        inc byte ptr enemies[si].tick_walk
        cmp byte ptr enemies[si].tick_walk,20
        jne     .continue

        mov byte ptr enemies[si].tick_walk,0
        jmp     .continue
change_direction:
        inc byte ptr enemies[si].tick_walk

        call    pseudorandom

        and     al,3            ; ax = 0-3

        mov byte ptr enemies[si].direction,al
.continue:
        call    move_enemy

        add     si,objectsize
        loop    moveEnemies


        cmp     player.hit,0
        je      checkForCol
        dec     player.hit
        jmp     checkForScreenLimitCol
checkForCol:  
        mov     di,player.x     ; take the x point
        add     di,8            ; put it at the middle
        mov     dx,player.y     ; take the y point
        add     dx,8            ; put it at the middle

        xor     si,si
        mov     cx,max_enemies
everyCol:
        mov     ax,word ptr enemies[si].x
        add     ax,8
        mov     bx,word ptr enemies[si].y
        add     bx,8
        mov     ds:flag,0
        call    checkdist16
        cmp     ds:flag,1
        je      noCollision
        call    dist            ; now AX has dist^2
        cmp     ax,word ptr enemies[si].radius
        ja      noCollision
        mov     player.hit,25
        jmp     checkForScreenLimitCol  ; we can skip the loop if we collided
noCollision:
        add     si,objectsize
        loop    everyCol
        
checkForScreenLimitCol:
        cmp     player.y,0
        jl      goNorth
        cmp     player.x,0
        jl      goEast
        cmp     player.y,176
        jg      goSouth
        cmp     player.x,304
        jg      goWest
        jmp     .done
goNorth:
        cmp     ds:current_screen,0
        jne     cannotGoNorth
        inc     ds:current_screen
        mov     player.y,174
        jmp     .done
cannotGoNorth:
        add     player.y,2
        jmp     .done
goEast:
goSouth:
        cmp     ds:current_screen,1
        jne     cannotGoSouth
        dec     ds:current_screen
        mov     player.y,2
        jmp     .done
cannotGoSouth:
        sub     player.y,2
        jmp     .done
goWest:
.done:

        
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
        xor     ax,ax
        mov     al,ds:current_screen
        mov     bx,240
        mul     bx
        mov     si, ax          ; index map
        mov     bx, 0           ; y
        mov     ax, 0
y_loop:
        mov     cx, 0          ; x

x_loop:
        mov     al,ds:background[si]
        call    draw_background
        inc     si
        add     cx,16
        cmp     cx,320
        jl      x_loop
        add     bx,16
        cmp     bx,184
        jl      y_loop

        mov     al,player.hit
        and     al,1
        cmp     al,0
        jne     renderEnemy
renderPlayer:
        mov     si,0
        mov     dx,player.x
        mov     ax,player.y
        call    draw_sprite

renderEnemy:
        mov     cx,max_enemies
        mov     bx,offset enemies
renderEnemies:
        mov     si,128
        mov     dx,[bx].x
        mov     ax,[bx].y
        call    draw_sprite
        add     bx,objectsize
        loop    renderEnemies

        

        call    sendBufferToVRAM
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

        mov     al,ds:isRunning

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
; clean the computer memory
move_enemy      proc    near
        cmp byte ptr enemies[si].direction,0
        je      moveNorth
        cmp byte ptr enemies[si].direction,1
        je      moveEast
        cmp byte ptr enemies[si].direction,2
        je      moveSouth
        cmp byte ptr enemies[si].direction,3
        je      moveWest
moveNorth:
        cmp word ptr enemies[si].y,0
        jle     .end
        dec word ptr enemies[si].y
        jmp     .end
moveEast:
        cmp word ptr enemies[si].x,608
        jge     .end
        inc word ptr enemies[si].x
        jmp     .end
moveSouth:
        cmp word ptr enemies[si].y,184
        jge     .end
        inc word ptr enemies[si].y
        jmp     .end
moveWest:
        cmp word ptr enemies[si].x,0
        jle     .end
        dec word ptr enemies[si].x
.end:
        ret
move_enemy      endp
;----------------------- routine ends ------------------------------+
codes   ends
;----------------------- code area ends ----------------------------+
        end
