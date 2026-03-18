; I/O MODULE - FILE IO.ASM
;
;----------------------- code area starts --------------------------+
codes   segment
;
;+++++++++++++++++++++++ public declarations start ++++++++++++++++++
        public  stdin,stdinne,stdinck,stdout,stdoutdr,stdcrlf
        public  stdspace,stdmessout,cominit,cominck,comout,comon,comoff
;+++++++++++++++++++++++ public declarations end ++++++++++++++++++++
;
        assume  cs:codes
;----------------------- routines begins ---------------------------+
;FUNCTION: This routine accepts input fromt the standard I/O device.
;INPUT:  This routine waits for one character code from the standard
; input device.
;OUTPUT: ASCII codes are returned in the AL register. Each character
; is echoed out the standard output device as it is input through the
; standard input device.
;REGISTERS USED: AH is modified. AL is used for output.
;SEGMENTS REFERENCED: None
;ROUTINES CALLED: DOS call number 1 (Keyboard input) is used.
;SPECIAL NOTES: None
;--------------------------------------------------------------------
; ROUTINE FOR STANDARD INPUT WITH ECHO
;
stdin   proc    far
        mov     ah,1                    ; standard input
        int     21h                     ; DOS call
        ret                             ; return
stdin   endp
;----------------------- routine ends ------------------------------+
;
;----------------------- routine begins ----------------------------+
;FUNCTION: This routine accepts input fromt the standard I/O device.
; No echo is generated.
;INPUT:  This routine waits for one character code from the standard
; input device.
;OUTPUT: ASCII codes are returned in the AL register. Each character
; is echoed out the standard output device as it is input through the
; standard input device.
;REGISTERS USED: AH is modified. AL is used for output.
;SEGMENTS REFERENCED: None
;ROUTINES CALLED: DOS call number 8 (Console input without echos) is
; used.
;SPECIAL NOTES: None
;--------------------------------------------------------------------
; ROUTINE FOR STANDARD INPUT WITHOUT ECHO
;
stdinne proc    far
        mov     ah,8                    ; standard input without echo
        int     21h                     ; DOS call
        ret                             ; return
stdinne endp
;----------------------- routine ends ------------------------------+
;
;----------------------- routine begins ----------------------------+
;FUNCTION: This routine checks, but does not wait for input from the
; standard I/O device.
;INPUT:  Input is from the standard I/O device. No check is made for
; Ctrl Break.
;OUTPUT: If a character is available, the routine returns with the
; flag condition NZ and the character in AL, but if no character is 
; available, the routine returns with the flag condition Z, and AL is
; meaningless. No echo generated for the input characters.
;REGISTERS USED: AH is modified. AL is used for output.
;SEGMENTS REFERENCED: None
;ROUTINES CALLED: DOS call number 06h (Direct console I/O) is used.
;SPECIAL NOTES: None
;--------------------------------------------------------------------
; ROUTINE TO CHECK FOR STANDARD INPUT 
;
stdinck proc    far
        push    dx                      ; save registers
;
        mov     dl,0FFh                 ; direct console input
        mov     ah,06h                  ; check standard direct input status
        int     21h                     ; DOS call

        pop     dx                      ; restore registers
        ret                             ; return
stdinck endp
;----------------------- routine ends ------------------------------+
;
;----------------------- routine begins ----------------------------+
;FUNCTION: This routine sends individual characters out the standard 
; output device.
;INPUT:  Upon entry an ASCII code is in AL.
;OUTPUT: A single character is output through the standard output 
; device.
;REGISTERS USED: AH is modified. AL is used for input.
;SEGMENTS REFERENCED: None
;ROUTINES CALLED: DOS call number 2 (Display output) is used.
;SPECIAL NOTES: None
;--------------------------------------------------------------------
; ROUTINE FOR STANDARD OUTPUT
;
stdout  proc    far
        push    dx                      ; save registers

        mov     dl,al                   ; in DL for DOS call
        mov     ah,2                    ; standard output
        int     21h                     ; DOS call

        pop     dx                      ; restore registers
        ret                             ; return
stdout  endp
;----------------------- routine ends ------------------------------+
;
;----------------------- routine begins ----------------------------+
;FUNCTION: This routine sends individual characters out the standard
; output device using output.
;INPUT:  Upon entry an ASCII code is in AL.
;OUTPUT: A single character is output through the direct standard 
; output call.
;REGISTERS USED: AH is modified. AL is used for input.
;SEGMENTS REFERENCED: None
;ROUTINES CALLED: DOS call number 6 (Direct console I/O) is used.
;SPECIAL NOTES: None
;--------------------------------------------------------------------
; ROUTINE FOR DIRECT CONSOLE OUTPUT
;
stdoutdr        proc    far
        push    dx                      ; save registers

        cmp     al,0FFh                 ; check for the one case of input
        je      stdoutdrexit
        mov     dl,al                   ; in DL for DOS call
        mov     ah,6                    ; direct console output
        int     21h                     ; DOS call
;
stdoutdrexit:
        pop     dx                      ; restore registers
        ret                             ; return
stdoutdr        endp
;----------------------- routine ends ------------------------------+
;
;----------------------- routine begins ----------------------------+
;FUNCTION: This routine sends a carriage return and then a linefeed 
; out through the standard output device.
;INPUT:  None
;OUTPUT: ASCII codes 13 for carriage return and the ASCII code 10 for
; linefeed are to the standard output device.
;REGISTERS USED: No registers are modified.
;SEGMENTS REFERENCED: None
;ROUTINES CALLED: STDOUT
;SPECIAL NOTES: None
;--------------------------------------------------------------------
; ROUTINE TO SEND CR LF TO STANDARD OUTPUT
;
stdcrlf proc    far
        push    ax                      ; save registers

        mov     al,13                   ; ASCII carriage return
        call    stdout                  ; send it out
        mov     al,10                   ; ASCII line feed
        call    stdout                  ; send it out
;
        pop     ax                      ; restore registers
        ret                             ; return
stdcrlf endp
;----------------------- routine ends ------------------------------+
;
;----------------------- routine begins ----------------------------+
;FUNCTION: This routine sends a space through the standard output 
; device.
;INPUT:  None
;OUTPUT: ASCII code 32 for space is sent to the standard output 
; device.
;REGISTERS USED: No registers are modified.
;SEGMENTS REFERENCED: None
;ROUTINES CALLED: STDOUT
;SPECIAL NOTES: None
;--------------------------------------------------------------------
; ROUTINE TO SEND SPACE TO STANDARD OUTPUT
;
; A space is sent to the standard output device
;
stdspace        proc    far
        push    ax                      ; save registers

        mov     al,32                   ; ASCII space
        call    stdout                  ; send it out

        pop     ax                      ; restore registers
        ret                             ; return
stdspace        endp
;----------------------- routine ends ------------------------------+
;
;----------------------- routine begins ----------------------------+
;FUNCTION: This routine sends a message to the standard output 
; device.
;INPUT: Upon input DS:SI points to the message. The message 
; terminates with an ASCII zero.
;OUTPUT: The individual characters of the message are output through
; the standard output device.
;REGISTERS USED: No registers are modified. SI is used to point to 
; the input.
;SEGMENTS REFERENCED: The data segment must container the message.
;ROUTINES CALLED: STDOUT
;SPECIAL NOTES: None
;--------------------------------------------------------------------
; ROUTINE TO SEND MESSAGE TO STANDARD OUTPUT
;
stdmessout      proc    far
        push    si                      ; save registers
        push    ax
;
stdmessout1:
        mov     al, [si]                ; get byte
        inc     si                      ; point to next byte
        cmp     al, 0                   ; done?
        je      stdmessoutexit          ; if so exit
        call    stdout                  ; send it out
        jmp     stdmessout1             ; loop for more
;
stdmessoutexit:
        pop     ax                      ; restore registers
        pop     si
        ret                             ; return
stdmessout      endp
;----------------------- routine ends ------------------------------+
;
;----------------------- routine begins ----------------------------+
;FUNCTION: This routine initializes one of the two communications 
; lines.
;INPUT:  Upon entry AL contains the initialization byte as follows:
;      7    6    5    4    3        2            1    0
;    --baud rate-- --parity-- --stop bits-- --word length--
;    000 =  110    00 = none  0 = 1         10 = 7 bits
;    001 =  150    01 = odd   1 = 2         11 = 8 bits
;    010 =  300    10 = even
;    011 =  600    11 = mark
;    100 = 1200
;    101 = 2400
;    110 = 4800
;    111 = 9600
; DX contains the unit number (0 from com1: and 1 from com2:).
;OUTPUT: Output is sent to the hardware controlling the specified
; communications line.
;REGISTERS USED: No registers are modified.
;SEGMENTS REFERENCED: None
;ROUTINES CALLED: BIOS call number 14h (RS-232 I/O) is used.
;SPECIAL NOTES: None
;--------------------------------------------------------------------
; ROUTINE TO INITIALIZE THE COMMUNICATIONS PORT
;
cominit proc    far
        push    ax                      ; save registers

        mov     ah,0                    ; initialize
        int     14h                     ; RS232 BIOS call
        ret                             ; return
cominit endp
;----------------------- routine ends ------------------------------+
;
;----------------------- routine begins ----------------------------+
;FUNCTION: This routine checks, but does not wait for input from one
; of the two serial communications lines.
;INPUT:  Upon entry DX contains the unit number (0 from com1: and 1 
; for com2:). During the routine, input is from the specified 
; communications line.
;OUTPUT: If a byte is available, the routine returns with the flag
; condition NZ and the byte in AL, but if no byte is available then
; the routine returns with the flag condition Z, and AL is 
; meaningless.
;REGISTERS USED: AH is modified. DX is used for input and AL is used
; for output.
;SEGMENTS REFERENCED: During the routine the system data segment is
; referenced.
;ROUTINES CALLED: None
;SPECIAL NOTES: None
;--------------------------------------------------------------------
; ROUTINE TO CHECK FOR INPUT FROM A COMMUNICATIONS LINE
;
cominck proc    far
        push    ds                      ; save registers
        push    dx
        push    si

        mov     si,dx                   ; look up address of com line
        add     si,si                   ; double to index into table
        mov     dx,40h                  ; segment of table
        mov     ds,dx                   ; set data segment to this table
        mov     dx,[si]                 ; now get it
        add     dx,5                    ; line status
        in      al,dx                   ; get it
        test    al,1                    ; receive buffer full?
        jz      cominckexit
;
        mov     dx,[si]                 ; data register
        in      al,dx                   ; get it
cominckexit:
;
        pop     si                      ; restore registers
        pop     dx                      
        pop     ds
        ret                             ; return
;
cominck endp
;----------------------- routine ends ------------------------------+
;
;----------------------- routine begins ----------------------------+
;FUNCTION: This routine sends a byte out one of the two 
; communications lines.
;INPUT:  Upon entry AL contains the byte to be sent out and DX
; contains the unit number (0 from com1: and 1 from com2:).
;OUTPUT: Output is sent to the specified communications line.
;REGISTERS USED: No registers are modified.
;SEGMENTS REFERENCED: None
;ROUTINES CALLED: DOS call number 14h (RS-232 I/O) is used.
;SPECIAL NOTES: None
;--------------------------------------------------------------------
; ROUTINE TO SEND OUTPUT TO A COMMUNICATIONS LINE
;
comout  proc    far
;
        mov     ah,1                    ; send it out
        int     14h                     ; RS232 BIOS call
        ret                             ; return
comout  endp
;----------------------- routine ends ------------------------------+
;
;----------------------- routine begins ----------------------------+
;FUNCTION: This routine turns on the handshaking signals DTR (line 
; 20) and RTS (line 4) on the specified communications line.
;INPUT:  Upon entry DX contains the unit number (0 from com1: and 1
; for com2:).
;OUTPUT: Just to the communications line.
;REGISTERS USED: No registers are modified. DX is used for input.
;SEGMENTS REFERENCED: During the routine the system data segment is
; referenced.
;ROUTINES CALLED: None
;SPECIAL NOTES: None
;--------------------------------------------------------------------
; ROUTINE TO TURN ON INPUT FROM A COMMUNICATIONS LINE
;
comon   proc    far
;
        push    ds                      ; save registers
        push    dx
        push    si

        mov     si,dx                   ; look up address of com line
        add     si,si                   ; double to index into table
        mov     dx,40h                  ; segment of system I/O table
        mov     ds,dx                   ; set data segment to this table
        mov     dx,[si]                 ; now get it
        add     dx,4                    ; modem control register
        mov     al,3                    ; set DTR and RTS
        out     dx,al                   ; send out control byte

        pop     si                      ; restore registers
        pop     dx
        pop     ds
        ret                             ; return
comon   endp
;----------------------- routine ends ------------------------------+
;
;----------------------- routine begins ----------------------------+
;FUNCTION: This routine turns off the handshaking signals DTR (line 
; 20) on the specified communications line. RTS (line 4) is kept as 
; it was.
;INPUT:  Upon entry DX contains the unit number (0 from com1: and 1
; for com2:).
;OUTPUT: Just to the communications line.
;REGISTERS USED: No registers are modified. DX is used for input.
;SEGMENTS REFERENCED: During the routine the system data segment is
; referenced.
;ROUTINES CALLED: None
;SPECIAL NOTES: None
;--------------------------------------------------------------------
; ROUTINE TO TURN OFF INPUT FROM A COMMUNICATIONS LINE
;
comoff  proc    far
;
        push    ds                      ; save registers
        push    dx
        push    si
;
        mov     si,dx                   ; look up address of com line
        add     si,si                   ; double to index into table
        mov     dx,40h                  ; segment of system I/O table
        mov     ds,dx                   ; set data segment to this table
        mov     dx,[si]                 ; now get it
        mov     dx,4                    ; modem control register
        mov     al,2                    ; clear DTR (line 20)
        out     dx,al                   ; send out control byte

        pop     si                      ; restore registers
        pop     dx
        pop     ds
        ret                             ; return
comoff  endp
;----------------------- routine ends ------------------------------+

codes   ends
;----------------------- code area ends ----------------------------+
        end
