; BINARY CONVERSION MODULE - FILE BINCONV.ASM
;
;---------------------------------data area begins----------------------------+
dseg   segment public                  ; data segment starts here
;
tbuff   db 10 DUP(0)
;
dseg   ends                            ; data segment ends here
;----------------------------------data area ends-----------------------------+
;
;----------------------- code area starts --------------------------+
codes   segment
;
;+++++++++++++++++++++++ public declarations start ++++++++++++++++++
        public  bin16in,bin8out,bin16out,oct16in,oct8out,oct16out
        public  hex16in,hex8out,hex16out,dec16in,dec8out,dec16out
;+++++++++++++++++++++++ public declarations end ++++++++++++++++++++
;
;++++++++++++++++++++++++++++++++ externals begin +++++++++++++++++++
        extrn  stdin:far,stdout:far
;+++++++++++++++++++++++++++++++++ externals end ++++++++++++++++++++
        assume  cs:codes
;----------------------- routines begins ---------------------------+
;FUNCTION: This routine accepts a binary number from the standard
; input device and converts it to internal 16-bit binary form.
;INPUT:  This individual digits of the binary number are received in
; ASCII through a call to a standard I/O routine. The valid digits
; are 0 and 1. An ASCII code other than for a valid digit will
; terminate the routine.
;OUTPUT: A 16-bit binary number is returned in the DX register.
;REGISTERS USED: Only DX is modified. It returns the result.
;SEGMENTS REFERENCED: None
;ROUTINES CALLED: STDIN
;SPECIAL NOTES: None
;--------------------------------------------------------------------
; ROUTINE TO CONVERT FROM ASCII BINARY TO INTERNAL 16-BIT BINARY
;
bin16in proc    far
;
        push    ax                ; save registers
;
        mov     dx,0              ; initialize DX as 0
;
bin16in1:
        call    stdin             ; digit comes in through AL
        sub     al,30h            ; subtract 30h
        jl      bin16in2          ; check if too low
        cmp     al,1
        jg      bin16in2          ; check if too high
        cbw                       ; convert to word
;
        sal     dx,1              ; shift DX left once
        add     dx,ax             ; add in digit
        jmp     bin16in1          
;
bin16in2:
        pop     ax                ; restore registers
        ret                       ; return
;
bin16in endp
;----------------------- routine ends ------------------------------+
;
;----------------------- routine begins ----------------------------+
;FUNCTION: This routine accepts an 8-bit binary number in the DL 
; register and converts it to ASCII binary form which is sent to the
; standard output device.
;INPUT:  Upon entry an 8-bit binary number is in the DL register.
;OUTPUT: A string of ASCII digits representing a binary number is
; sent out through the standard output device.
;REGISTERS USED: No registers are modified. DL is used for input.
;SEGMENTS REFERENCED: None
;ROUTINES CALLED: STDOUT
;SPECIAL NOTES: None
;--------------------------------------------------------------------
;ROUTINE TO CONVERT FROM INTERNAL 8-BIT BINARY TO ASCII BINARY
;
bin8out proc    far
;
        push    cx                ; save registers
        push    ax

        mov     cx,8              ; loop for a count of 8
bin8out1:
        rol     dl,1              ; rotate DL left once
        mov     al,dl             ; move into AL
        and     al,1              ; just keep digit
        add     al,30h            ; add 30h to AL
        call    stdout            ; send it out
        loop    bin8out1        
;
        pop     ax                ; restore registers
        pop     cx                
        ret                       ; return
;
bin8out endp
;----------------------- routine ends ------------------------------+
;FUNCTION: This routine accepts an 16-bit binary number in the DX 
; register and converts it to ASCII binary form which is sent to the
; standard output device.
;INPUT:  Upon entry an 16-bit binary number is in the DX register.
;OUTPUT: A string of ASCII digits representing a binary number is
; sent out through the standard output device.
;REGISTERS USED: No registers are modified. DX is used for input.
;SEGMENTS REFERENCED: None
;ROUTINES CALLED: STDOUT
;SPECIAL NOTES: None
;--------------------------------------------------------------------
; ROUTINE TO CONVERT FROM INTERNAL 16-BIT BINARY TO ASCII BINARY
;
bin16out        proc    far
;
; a binary is in DX
;
        push    cx                ; save registers
        push    ax
;
        mov     cx,16             ; loop for a count of 16
bin16out1:
        rol     dx,1              ; rotate DX left once
        mov     al,dl             ; move into AL
        and     al,1              ; just keep digit
        add     al,30h            ; add 30h to AL
        call    stdout            ; send it out
        loop    bin16out1
;
        pop     ax                ; restore registers
        pop     cx                
        ret                       ; return
;
bin16out        endp
;----------------------- routine ends ------------------------------+
;
;----------------------- routine begins ----------------------------+
;FUNCTION: This routine accepts an octal number from the standard
; input device and converts it to internal 16-bit binary form.
;INPUT:  The individual digits of the octal number are received in
; ASCII through a call to a standard I/O routine. The valid digits
; are 0 through 7. An ASCII code other than for a valid digit will
; terminate the routine.
;OUTPUT: A 16-bit binary number is returned in the DX register.
;REGISTERS USED: Only DX is modified. It returns the result.
;SEGMENTS REFERENCED: None
;ROUTINES CALLED: STDOUT
;SPECIAL NOTES: None
;--------------------------------------------------------------------
; ROUTINE TO CONVERT FROM ASCII OCTAL TO INTERNAL 16-BIT BINARY
;
oct16in proc    far
;
        push    cx                ; save registers
        push    ax
;
        mov     dx,0              ; initialize DX as 0
oct16in1:
        call    stdin             ; a digit comes in AL
        sub     al,30h            ; subtract 30h
        jl      oct16in2          ; check if too low
        cmp     al,7
        jg      oct16in2          ; check if too high
        cbw                       ; convert to word
;
        mov     cl,3
        sal     dx,cl             ; shift DX left once
        add     dx,ax             ; add in digit
        jmp     oct16in1
;
oct16in2:
        pop     ax                ; restore registers
        pop     cx                
        ret                       ; return
;
oct16in endp
;----------------------- routine ends ------------------------------+
;
;----------------------- routine begins ----------------------------+
;FUNCTION: This routine accepts an 8-bit binary number in the DL 
; register and converts it to ASCII octal form which is sent to the
; standard output device.
;INPUT:  Upon entry an 8-bit binary number is in the DL register.
;OUTPUT: A string of ASCII digits representing a octal number is
; sent out through the standard output device.
;REGISTERS USED: No registers are modified. DL is used for input.
;SEGMENTS REFERENCED: None
;ROUTINES CALLED: STDOUT
;SPECIAL NOTES: None
;--------------------------------------------------------------------
; ROUTINE TO CONVERT FROM INTERNAL 8-BIT BINARY TO ASCII OCTAL
;
oct8out proc    far
;
; a binary number is in DL
;
        push    cx                ; save registers
        push    ax
;
; first octal digit has only 2 bits
;
        mov     cl,2              ; for a count of 2
        rol     dl,cl             ; rotate DL left 
;
        mov     al,dl             ; move into AL
        and     al,3              ; just keep digit
        add     al,30h            ; add 30h to AL
        call    stdout            ; send it out
;
; second and third octal digits have 3 bits each
        mov     cx,2              ; loop for a count of 2
oct8out1:
        push    cx                ; save the count
        mov     cl,3              ; for a count of 3
        rol     dl,cl             ; rotate DL left
;
        mov     al,dl             ; move into AL
        and     al,7              ; just keep digit
        add     al,30h            ; add 30h to AL
        call    stdout            ; send it out
        pop     cx                ; restore the count
        loop    oct8out1
;
        pop     ax                ; restore registers
        pop     cx                
        ret                       ; return
;
oct8out endp
;----------------------- routine ends ------------------------------+
;
;----------------------- routine begins ----------------------------+
;FUNCTION: This routine accepts an 16-bit binary number in the DX 
; register and converts it to ASCII octal form which is sent to the
; standard output device.
;INPUT:  Upon entry an 16-bit binary number is in the DX register.
;OUTPUT: A string of ASCII digits representing a octal number is
; sent out through the standard output device.
;REGISTERS USED: No registers are modified. DX is used for input.
;SEGMENTS REFERENCED: None
;ROUTINES CALLED: STDOUT
;SPECIAL NOTES: None
;--------------------------------------------------------------------
; ROUTINE TO CONVERT FROM INTERNAL 16-BIT BINARY TO ASCII OCTAL
;
oct16out        proc    far
;
; a binary number is in DX
;
        push    cx                ; save registers
        push    ax
;
; first octal digit has only one bit
        rol     dx,1              ; rotate DX left once
;
        mov     al,dl             ; move into AL
        and     al,1              ; just keep digit
        add     al,30h            ; add 30h to AL
        call    stdout            ; send it out
;
; last five octal digits have 3 bits each
        mov     cx,5              ; loop for a count of 5
oct16out1:
        push    cx                ; save the count
        mov     cl,3              ; for a count of 3
        rol     dx,cl             ; rotate DX left
;
        mov     al,dl             ; move into AL
        and     al,7              ; just keep digit
        add     al,30h            ; add 30h to AL
        call    stdout            ; send it out
        pop     cx                ; restore the count
        loop    oct16out1
;
        pop     ax                ; restore registers
        pop     cx                
        ret                       ; return
;
oct16out        endp
;----------------------- routine ends ------------------------------+
;
;----------------------- routine begins ----------------------------+
;FUNCTION: This routine accepts a hexadecimal number from the 
; standard input device and converts it to internal 16-bit binary
; form.
;INPUT:  The individual digits of the hexadecimal number are received
; in ASCII through a call to a standard I/O routine. The valid digits
; are 0 through 9 and A through F. An ASCII code other than for a
; valid digit will terminate the routine.
;OUTPUT: A 16-bit binary number is returned in the DX register.
;REGISTERS USED: Only DX is modified. It returns the result.
;SEGMENTS REFERENCED: None
;ROUTINES CALLED: STDIN
;SPECIAL NOTES: None
;--------------------------------------------------------------------
; ROUTINE TO CONVERT FROM ASCII HEXADECIMAL TO INTERNAL 16-BIT BINARY
;
hex16in proc    far
;
        push    cx                ; save registers
        push    ax
;
        mov     dx,0              ; initialize DX as 0
;
hex16in1:
        call    stdin             ; a digit comes in AL
        sub     al,30h            ; subtract 30h
        jl      hex16in3          ; check if too low
        cmp     al,9
        jle     hex16in2          ; go if ok
        and     al,5Fh            ; for lower case too
        sub     al,7              ; adjust for A-F
        jl      hex16in3          ; too low for A-F
        cmp     al,15             ; check if too high
        jg      hex16in3
;
hex16in2:
        cbw
        mov     cl,4              ; for a count of 4
        sal     dx,cl             ; shift DX left
        add     dx,ax             ; add in digit
        jmp     hex16in1
;
hex16in3:
        pop     ax                ; restore registers
        pop     cx                
        ret                       ; return
;
hex16in endp
;----------------------- routine ends ------------------------------+
;
;----------------------- routine begins ----------------------------+
;FUNCTION: This routine accepts an 8-bit binary number in the DL 
; register and converts it to ASCII hexadecimal form which is sent to
; the standard output device.
;INPUT:  Upon entry an 8-bit binary number is in the DL register.
;OUTPUT: A string of ASCII digits representing a hexadecimal number 
; is sent out through the standard output device.
;REGISTERS USED: No registers are modified. DL is used for input.
;SEGMENTS REFERENCED: None
;ROUTINES CALLED: STDOUT
;SPECIAL NOTES: None
;--------------------------------------------------------------------
; ROUTINE TO CONVERT FROM INTERNAL 8-BIT BINARY TO ASCII HEXADECIMAL
;
hex8out proc    far
;
; a binary number is in DL
;
        push    cx                ; save registers
        push    ax
;
        mov     cx,2              ; loop for a count of 2
hex8out1:
        push    cx                ; save the count
        mov     cl,4              ; for a count of 4
        rol     dl,cl             ; rotate DL left
;
        mov     al,dl             ; move into AL
        and     al,0Fh            ; just digit
        daa                       ; add 6 if A-F
        add     al,0F0h           ; bump a carry if A-F
        adc     al,40h            ; here is the ASCII
        call    stdout            ; send it out
;
        pop     cx                ; restore the count
        loop    hex8out1
;
        pop     ax                ; restore registers
        pop     cx                
        ret                       ; return
;
hex8out endp
;----------------------- routine ends ------------------------------+
;
;----------------------- routine begins ----------------------------+
;FUNCTION: This routine accepts an 16-bit binary number in the DL 
; register and converts it to ASCII hexadecimal form which is sent to
; the standard output device.
;INPUT:  Upon entry an 16-bit binary number is in the DL register.
;OUTPUT: A string of ASCII digits representing a hexadecimal number 
; is sent out through the standard output device.
;REGISTERS USED: No registers are modified. DL is used for input.
;SEGMENTS REFERENCED: None
;ROUTINES CALLED: STDOUT
;SPECIAL NOTES: None
;--------------------------------------------------------------------
; ROUTINE TO CONVERT FROM INTERNAL 16-BIT BINARY TO ASCII HEXADECIMAL
;
hex16out        proc    far
;
; a binary number is in DX
;
        push    cx                ; save registers
        push    ax
;
        mov     cx,4              ; loop for a count of 4
hex16out1:
        push    cx                ; save the count
        mov     cl,4              ; for a count of 4
        rol     dx,cl             ; rotate DX left
;
        mov     al,dl             ; move into AL
        and     al,0Fh            ; just the digit
        daa                       ; add 6 if A-F
        add     al,0F0h           ; bump a carry if A-F
        adc     al,40h            ; here is the ASCII
        call    stdout            ; send it out
;
        pop     cx                ; restore the count
        loop    hex16out1
;
        pop     ax                ; restore registers
        pop     cx                
        ret                       ; return
;
hex16out        endp
;----------------------- routine ends ------------------------------+
;
;----------------------- routine begins ----------------------------+
;FUNCTION: This routine accepts an decimal number from the standard
; input device and converts it to internal 16-bit binary form.
;INPUT:  The individual digits of the decimal number are received in
; ASCII through a call to a standard I/O routine. The valid digits
; are 0 through 9. An ASCII code other than for a valid digit will
; terminate the routine.
;OUTPUT: A 16-bit binary number is returned in the DX register.
;REGISTERS USED: Only DX is modified. It returns the result.
;SEGMENTS REFERENCED: None
;ROUTINES CALLED: STDIN
;SPECIAL NOTES: None
;--------------------------------------------------------------------
; ROUTINE TO CONVERT FROM ASCII DECIMAL TO INTERNAL 16-BIT BINARY
;
dec16in proc    far
;
        push    cx                ; save registers
        push    ax
;
        mov     dx,0              ; initialize DX as 0
;
dec16in1:
        call    stdin             ; a digit comes in AL
        sub     al,30h            ; subtract 30h
        jl      dec16in2          ; check if too low
        cmp     al,9
        jg      dec16in2          ; check if too high
        cbw                       ; convert to word
;
        push    ax                ; save digit
        mov     ax,dx
        mov     cx,10             ; multiplier of 10
        mul     cx                ; multiply
        mov     dx,ax             ; result in DX
        pop     ax                ; restore digit
        add     dx,ax             ; add in digit
        jmp     dec16in1
;
dec16in2:
        pop     ax                ; restore registers
        pop     cx                
        ret                       ; return
;
dec16in endp
;----------------------- routine ends ------------------------------+
;
;----------------------- routine begins ----------------------------+
;FUNCTION: This routine accepts an 8-bit binary number in the DL
; register and converts it to ASCII decimal form which is sent to the
; standard output device.
;INPUT:  Upon entry an 8-bit binary number is in the DL register.
;OUTPUT: A string of ASCII digits representing a decimal number is
; stored in a buffer called TBUFF and then sent out through the
; standard output device.
;REGISTERS USED: No registers are modified. DL is used for input.
;SEGMENTS REFERENCED: DSEG is a data segment which contains TBUFF.
;ROUTINES CALLED: STDOUT
;SPECIAL NOTES: None
;--------------------------------------------------------------------
; ROUTINE TO CONVERT FROM INTERNAL 8-BIT BINARY TO ASCII DECIMAL
;
dec8out proc    far
;
        push    ds                ; save registers
        push    di
        push    dx
        push    cx
        push    ax
;
        mov     ax,dseg           ; point to the data segment
        mov     ds,ax
;
; a binary number is in DL
;
; put the digits in a buffer
;
        mov     cx,0              ; initialize a counter
        lea     di,ds:tbuff       ; point to buffer
dec8out1:
        push    cx                ; save CX
        mov     al,dl             ; AX has numerator
        mov     ah,0              ; clear upper half
        mov     cl,10             ; divisor of 10
        div     cl                ; divide
        mov     dl,al             ; get quotient
        mov     al,ah             ; get remainder
;
        add     al,30h            ; add 30h
        mov     [di],al           ; put in buffer
        inc     di                ; point to next byte
;
        pop     cx                ; restore CX
        inc     cx                ; count the digit
        cmp     dl,0              ; done?
        jnz     dec8out1         
;
; dump the buffer out
;
dec8out2:
        dec     di                ; back up through the buffer
        mov     al,[di]           ; get the byte from the buffer
        call    stdout            ; send it out
        loop    dec8out2
;
        pop     ax                ; restore registers
        pop     cx                
        pop     dx
        pop     di
        pop     ds
        ret                       ; return
;
dec8out endp
;----------------------- routine ends ------------------------------+
;
;----------------------- routine begins ----------------------------+
;FUNCTION: This routine accepts an 16-bit binary number in the DX
; register and converts it to ASCII decimal form which is sent to the
; standard output device.
;INPUT:  Upon entry an 16-bit binary number is in the DX register.
;OUTPUT: A string of ASCII digits representing a decimal number is
; stored in a buffer called TBUFF and then sent out through the
; standard output device.
;REGISTERS USED: No registers are modified. DL is used for input.
;SEGMENTS REFERENCED: DSEG is a data segment which contains TBUFF.
;ROUTINES CALLED: STDOUT
;SPECIAL NOTES: None
;--------------------------------------------------------------------
; ROUTINE TO CONVERT FROM INTERNAL 16-BIT BINARY TO ASCII DECIMAL
;
dec16out        proc    far
;
        push    ds                ; save registers
        push    di
        push    dx
        push    cx
        push    ax
;
        mov     ax,dseg           ; point to the data segment
        mov     ds,ax
;
; number is in DX
;
; put the digits in a buffer
;
        mov     cx,0              ; initialize the counter
        lea     di,ds:tbuff       ; point to the buffer
dec16out1:
        push    cx                ; save CX
        mov     ax,dx             ; numerator
        mov     dx,0              ; clear upper half
        mov     cx,10             ; divisor of 10
        div     cx                ; divide
        xchg    ax,dx             ; get quotient
;
        add     al,30h            ; add 30h
        mov     [di],al           ; put in buffer
        inc     di                ; next byte
;
        pop     cx                ; restore CX for the count
        inc     cx                ; count the digit
        cmp     dx,0              ; done?
        jnz     dec16out1
;
; dump the buffer out
;
dec16out2:
        dec     di                ; back up through the buffer
        mov     al,[di]           ; get byte from buffer
        call    stdout            ; send it out
        loop    dec16out2
;
        pop     ax                ; restore registers
        pop     cx                
        pop     dx
        pop     di
        pop     ds
        ret                       ; return
;
dec16out        endp
;----------------------- routine ends ------------------------------+

codes   ends
;----------------------- code area ends ----------------------------+
        end
