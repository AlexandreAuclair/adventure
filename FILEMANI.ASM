; FILE MANIPULATION - FILE FILEMANI.ASM
;
;----------------------- equates begin -----------------------------+
cr    equ    0dh                        ; carriage return
lf    equ    0ah                        ; line feed
;----------------------- equates end -------------------------------+
;+++++++++++++++++++++++ public declarations start ++++++++++++++++++
        public  emessout,getspec,createfile,closefile,writefile,dta
        public  readfile,initcbuff,putcbuff,incbuff,flushit,outcbuff
        public  lbuff,emess8
;+++++++++++++++++++++++ public declarations end ++++++++++++++++++++
;++++++++++++++++++++++++++++++++ externals begin +++++++++++++++++++
        extrn  stdmessout:far,comoff:far,comon:far,cominck:far
;+++++++++++++++++++++++++++++++++ externals end ++++++++++++++++++++
;----------------------- data area begins --------------------------+
dseg   segment para public 'DATA'          ; data segment starts here
;
emess   dw      emess1
        dw      emess2
        dw      emess3
        dw      emess4
        dw      emess5
        dw      emess6
        dw      emess7
        dw      emess8
        dw      emess9
        dw      emess10
        dw      emess11
        dw      emess12
        dw      emess13
        dw      emess14
        dw      emess15
        dw      emess16
        dw      emess17
        dw      emess18
;
emess1  db      cr,lf,'Invalid function number',cr,lf,0
emess2  db      cr,lf,'File not found',cr,lf,0
emess3  db      cr,lf,'Path not found',cr,lf,0
emess4  db      cr,lf,'Too many open files',cr,lf,0
emess5  db      cr,lf,'Access denied',cr,lf,0
emess6  db      cr,lf,'Invalid handle',cr,lf,0
emess7  db      cr,lf,'Memory control blocks destroyed',cr,lf,0
emess8  db      cr,lf,'Insufficient memory',cr,lf,0
emess9  db      cr,lf,'Invalid memory block address',cr,lf,0
emess10 db      cr,lf,'Invalid environment',cr,lf,0
emess11 db      cr,lf,'Invalid format',cr,lf,0
emess12 db      cr,lf,'Invalid access code',cr,lf,0
emess13 db      cr,lf,'Invalid data',cr,lf,0
emess14 db      cr,lf,'Message not in use',cr,lf,0
emess15 db      cr,lf,'Invalid drive was specified',cr,lf,0
emess16 db      cr,lf,'Attempted to remove the current directory',cr,lf,0
emess17 db      cr,lf,'Not same device',cr,lf,0
emess18 db      cr,lf,'No more files',cr,lf,0
;
lbuff   db      256 dup(0)
cbuff   db      256 dup(0)
gauge   dw      0
lastbyte db     0
dta     dd      0
;
dseg   ends                            ; data segment ends here
;----------------------- data area ends ----------------------------+
;----------------------- equates begin -----------------------------+
blksize   equ     512
cbuffsize equ     256
controlz  equ     1Ah
nearfull  equ     cbuffsize - 8

;----------------------- equates end -------------------------------+
;
;----------------------- code area starts --------------------------+
codes   segment

        assume  cs:codes
;----------------------- routines begins ---------------------------+
;FUNCTION: This routine sends a specified exception message out
; through the standard output device.
;INPUT:  Upon entry AX contains the exception message number as
; listed in the the table below. This table is an extension of the
; Error Return Table in the DOS 2 Disk Operating System manual.
;OUTPUT: The output is sent to the standard output device.
;REGISTERS USED: AX is used for input.
;SEGMENTS REFERENCED: Upon entry the data segment must contain the
; text of the exception messages as in the following table:
;emess  dw      emess1
;       dw      emess2
;       dw      emess3
;       dw      emess4
;       dw      emess5
;       dw      emess6
;       dw      emess7
;       dw      emess8
;       dw      emess9
;       dw      emess10
;       dw      emess11
;       dw      emess12
;       dw      emess13
;       dw      emess14
;       dw      emess15
;       dw      emess16
;       dw      emess17
;       dw      emess18
;
;
;emess1  db      cr,lf,'Invalid function number',cr,lf,0
;emess2  db      cr,lf,'File not found',cr,lf,0
;emess3  db      cr,lf,'Path not found',cr,lf,0
;emess4  db      cr,lf,'Too many open files',cr,lf,0
;emess5  db      cr,lf,'Access denied',cr,lf,0
;emess6  db      cr,lf,'Invalid handle',cr,lf,0
;emess7  db      cr,lf,'Memory control blocks destroyed',cr,lf,0
;emess8  db      cr,lf,'Insufficient memory',cr,lf,0
;emess9  db      cr,lf,'Invalid memory block address',cr,lf,0
;emess10 db      cr,lf,'Invalid environment',cr,lf,0
;emess11 db      cr,lf,'Invalid format',cr,lf,0
;emess12 db      cr,lf,'Invalid access code',cr,lf,0
;emess13 db      cr,lf,'Invalid data',cr,lf,0
;emess14 db      cr,lf,'Message not in use',cr,lf,0
;emess15 db      cr,lf,'Invalid drive was specified',cr,lf,0
;emess16 db      cr,lf,'Attempted to remove the current directory',cr,lf,0
;emess17 db      cr,lf,'Not same device',cr,lf,0
;emess18 db      cr,lf,'No more files',cr,lf,0
;
; The first part of the table consists of addresses of the messages
; and the second part consists of the actual messages as ASCIIZ
; strings.
;ROUTINES CALLED: MESSOUT
;SPECIAL NOTES: None
;--------------------------------------------------------------------
; ROUTINE TO SEND OUT EXCEPTION MESSAGES
;
emessout        proc    far
;
        push    si              ; save registers
        push    ds
        push    ax
;
        mov     ax,dseg
        mov     ds,ax
        pop     ax
        push    ax
;
        add     ax,ax           ; double to index through table
        mov     si,ax           ; SI points into table
        mov     si,ds:emess[si] ; look up address of message
        call    stdmessout      ; send the message
;
        pop     ax              ; restore registers
        pop     ds
        pop     si
        ret
;
emessout        endp
;----------------------- routine ends ------------------------------+
;
;----------------------- routines begins ---------------------------+
;FUNCTION: This routine gets a file specifier from the unformatted
; parameter area at 80h of the Program Segment Prefix and transfers
; it to an ASCIIZ buffer. When you enter a trasnsient command, the
; DOS automatically fills the unformatted parameter area with the
; tail of the command line.
;INPUT:  Upon entry, the unformatted parameter area must contain a
; file specifier and DS:DX must point to a buffer in memory.
;OUTPUT: The buffer is filled with the file specification as an 
; ASCIIZ string.
;REGISTERS USED: No registers are modified. DX is used for input.
;SEGMENTS REFERENCED: Upon entry the extra segment must contain the
; ASCIIZ string buffer.
;ROUTINES CALLED: None
;SPECIAL NOTES: The double word variable DTA must point to the 
; default DTA in the Program Segment Prefix. In particular, the
; second word of this variable should be loaded with the Program
; Segment Prefix when the user first grains control. This segment
; value is initially contained in DS.
;--------------------------------------------------------------------
; ROUTINE TO GET A FILE SPECIFIER
;
getspec proc    far
;
        push    ds              ; save registers
        push    es
        push    si
        push    di
        push    cx
        push    ax

        mov     ax,dseg
        mov     ds,ax
;
; set up pointer to dta to get parameters
        lds     si,ds:dta       ; point to dta for parameters
        mov     cl,[si]         ; get length of string
        mov     ch,0            ; make 16-bit
        inc     si              ; skip the length byte
; scan past the spaces
        mov     al,' '          ; skip spaces
getspec1:
        cmp     [si],al         ; check for space
        jne     getspec2        ; exit the loop if nonspace
        inc     si              ; otherwise point to next byte
        loop    getspec1        ; loop back for more
        jcxz    getspec3        ; no file specifier?
;
; move the rest into place
getspec2:
        mov     di,dx           ; index points to destination
        cld                     ; forward direction
        rep     movsb           ; make the transfer
        clc                     ; no error so no carry
        jmp     getspecexit     ; and return
;
getspec3:
        mov     ax,20           ; no file specified
        stc                     ; set carry for error
        jmp     getspecexit     ; and exit
;
getspecexit:
        pop     ax              ; save registers
        pop     cx              
        pop     di
        pop     si
        pop     es
        pop     ds
        ret
;
getspec endp
;----------------------- routine ends ------------------------------+
;
;----------------------- routines begins ---------------------------+
;FUNCTION: This routine creates a file for read/write. If a file
; already exists, then its length is truncated to zero, ready to be
; written to.
;INPUT:  Upon entry DS:DX points to an ASCIIZ string with the drive,
; path, and filename.
;OUTPUT: If the file can be opened, the carry is clear and its handle
; is returned in AX. If it cannot be opened, the carry is set and an
; error code is returned in AX.
;REGISTERS USED: Only AX is modified. DX is used for input and AX is
; used for output.
;SEGMENTS REFERENCED: Upon entry the data segment must contain the
; ASCIIZ string.
;ROUTINES CALLED: DOS call number 3Ch (CREAT) is used.
;SPECIAL NOTES: None
;--------------------------------------------------------------------
; ROUTINE TO CREATE A FILE
;
createfile      proc    far
;
        push    cx              ; save registers
;
        mov     cx,0            ; attribute 0
        mov     ah,3Ch          ; create file
        int     21h             ; DOS call
;
        pop     cx              ; restore registers
        ret
;
createfile      endp
;----------------------- routine ends ------------------------------+
;
;----------------------- routines begins ---------------------------+
;FUNCTION: This routine closes a file.
;INPUT:  Upon entry BX contains the filehandle of the file that is to
; be closed.
;OUTPUT: If the file can be closed, the carry is clear. If it cannot
; be closed, the carry is set and an error code is returned in AX.
;REGISTERS USED: Only AX is modified. BX is used for input and AX is
; used for output.
;SEGMENTS REFERENCED: None
;ROUTINES CALLED: DOS call number 3Eh (close file) is used.
;SPECIAL NOTES: None
;--------------------------------------------------------------------
; ROUTINE TO CLOSE A FILE
closefile       proc    far
;
        mov     ah,3Eh          ; close a file
        int     21h             ; DOS call
        ret
;
closefile       endp
;----------------------- routine ends ------------------------------+
;
;----------------------- routines begins ---------------------------+
;FUNCTION: This routine writes bytes to a file.
;INPUT:  Upon entry BX contains the file's handle, DS:DX points to a 
; linear buffer containing the bytes, and CX contains the byte count.
;OUTPUT: If the bytes are successfully written to the file, the carry
; is clear, and if it is not, the carry is set and the error code is
; in AX.
;REGISTERS USED: No registers are modified. AX and BX are used for
; input and AX is used for output.
;SEGMENTS REFERENCED: The data segment must contain the linear byte
; buffer LBUFF.
;ROUTINES CALLED: None
;SPECIAL NOTES: None
;--------------------------------------------------------------------
; ROUTINE TO WRITE A BYTE TO A FILE
;
writefile       proc    far
;
        mov     ah,40h          ; write to file
        int     21h             ; DOS call
        cmp     ax,cx           ; was it all written?
        je      writefile1      ; skip if ok
        mov     ax,21           ; not all bytes were transferred
        stc                     ; set carry if error
;
writefile1:
        ret
;
writefile       endp
;----------------------- routine ends ------------------------------+
;
;----------------------- routines begins ---------------------------+
;FUNCTION: This routine reads bytes from a file.
;INPUT:  Upon entry BX contains the file's handle, CX contains the
; count, and DS:DX points to a linear buffer where the bytes are to
; appear.
;OUTPUT: if the bytes are successfully read from the file, the carry
; is clear, and if it is not, the carry is set and the error code is
; returned in AL.
;REGISTERS USED: No registers are modified. CX,DX, and BX are used
; for input.
;SEGMENTS REFERENCED: The data segment must contain the linear byte
; buffer LBUFF.
;ROUTINES CALLED: DOS call number 3Fh (read from a file) is used.
;SPECIAL NOTES: None
;--------------------------------------------------------------------
; ROUTINE TO READ BYTES FROM A FILE
;
readfile        proc    far
;
        mov     ah,3Fh          ; read from a file
        int     21h             ; DOS call
;
        cmp     ax,cx           ; everything back?
        je      readfileexit    ; skip if ok
        stc                     ; set carry for error
;
readfileexit:
        ret
;
readfile        endp
;----------------------- routine ends ------------------------------+
;
;----------------------- routines begins ---------------------------+
;FUNCTION: This routine initializes the pointers and control
; variables for a circular buffer.
;INPUT:  None
;OUTPUT: The registers SI and DI and the variable GAUGE are all set
; to zero. The variable LASTBYTE is also set equal to zero.
;REGISTERS USED: DI and SI are set to zero. All other registers are
; left alone.
;SEGMENTS REFERENCED: Upon entry the data segment must contain the
; circular buffer and its variables, CBUFF and GAUGE, and the
; variable LASTBYTE.
;ROUTINES CALLED: None
;SPECIAL NOTES: None
;--------------------------------------------------------------------
; ROUTINE TO HANDLE INPUT FOR CIRCULAR BUFFER
;
initcbuff       proc    far
;
        push    ds
        push    ax
;
        mov     ax,dseg 
        mov     ds,ax
;
        mov     si,0            ; initialize SI
        mov     di,0            ; initialize DI
        mov     ds:gauge,0      ; and number of bytes in buffer
        mov     ds:lastbyte,0   ; also last byte buffer
;
        pop     ax
        pop     ds
;
        ret
;
initcbuff       endp
;----------------------- routine ends ------------------------------+
;
;----------------------- routines begins ---------------------------+
;FUNCTION: This routine puts one byte into a circular buffer.
;INPUT:  Upon entry a byte is in AL.
;OUTPUT: The byte goes into the circular buffer. The pointers and
; gauge variables are properly adjusted. If the buffer gets nearly
; full then a routine is called to send a signal to the
; communications device to stop sending any more bytes of output.
;REGISTERS USED: DI is the buffer pointer and is updated if there is
; a character.
;SEGMENTS REFERENCED: Upon entry the data segment must contain the
; circular buffer and its variables, CBUFF and GAUGE, and the
; variable LASTBYTE.
;ROUTINES CALLED: COMOFF
;SPECIAL NOTES: None
;--------------------------------------------------------------------
; ROUTINE TO PUT ONE BYTE INTO A CIRCULAR BUFFER
;
putcbuff        proc    far
;
        push    ds
        push    ax
;
        mov     ax,dseg
        mov     ds,ax   
        pop     ax
;
; put the byte into the buffer
        mov     ds:cbuff[di],al ; byte goes into buffer
;
; adjust pointer
        inc     di              ; point to next character
        cmp     di,cbuffsize    ; wrap it around?
        jne     putcbuff1       ; skip if no wrap
        mov     di,0            ; wraps back to zero
;
; count it
putcbuff1:
        inc     ds:gauge        ; count the character
        cmp     ds:gauge,nearfull; too many characters?
        jne     putcbuff2       ; skip if not
        call    comoff          ; request to stop flow
putcbuff2:
;
putcbuffret:
        pop     ds
        ret
;
putcbuff        endp
;----------------------- routine ends ------------------------------+
;
;----------------------- routines begins ---------------------------+
;FUNCTION: This routine handles input to circular buffer. It checks
; to see if there is any input from a serial communications line. If
; there is  input then it is sent to circular buffer. If a control Z
; is received then carry is set and an exception code is returned. If
; there is no input then it returns with the carry clear and without
; further action.
;INPUT:  Upon entry DX specifies the communications line (0=com1: and
; 1=com2:). During the routine input is from COMINCK routine.
;OUTPUT: The input characters go to the circular buffer. If the
; buffer gets nearly full then a routine is called to send a signal
; to the communications device to stop sending any more bytes of
; output. If a control Z is detected from communications line the
; carry is set and an exception code is returned.
;REGISTERS USED: DI is the buffer pointer and is updated if there is
; a character.
;SEGMENTS REFERENCED: Upon entry the data segment must contain the
; circular buffer and its variables, CBUFF and GAUGE, and the
; variable LASTBYTE.
;ROUTINES CALLED: COMON,COMOFF,COMINCK,PUTCBUFF
;SPECIAL NOTES: None
;--------------------------------------------------------------------
; ROUTINE HANDLE INPUT FOR CIRCULAR BUFFER
;
incbuff proc    far
;
        push    ds
        push    ax
;
        mov     ax,dseg
        mov     ds,ax
        pop     ax
;
; check for a character
        call    cominck         ; check for character
        jz      incbuffexit     ; good exit if none
;
; strip off parity bit
        and     al,7Fh          ; just 7 bits
;
; check for linefeed
        cmp     al,10           ; ASCII 10 is linefeed
        jne     incbuff1        ; skip if not linefeed
        cmp     ds:lastbyte,13  ; was last byte a carriage return?
        je      incbuff2        ; skip if cr/lf
;
incbuff1:
        call    putcbuff        ; put byte into buffer
        mov     ds:lastbyte,al  ; update last byte
;
; check for carriage return and
incbuff2:
        cmp     al,13           ; ASCII 13 is carriage return
        jne     incbuff3        ; skip if not
;
; also put a linefeed if character was a carriage return
        push    ax              ; save current character
        mov     al,10           ; put a linefeed
        call    putcbuff        ; into buffer
        pop     ax              ; restore current character
;
; check for end of file
incbuff3:
        cmp     al,controlz     ; end of file?
        je      incbuff5        ; is an exception
;
; check for overflow
        cmp     ds:gauge,nearfull; too many characters?
        jl      incbuff4        ; skip if not
        call    comoff          ; request to stop flow
        jmp     incbuffexit     ; good exit
;
; if not overflow make sure flow is on
incbuff4:
        call    comon           ; make sure flow is on
        jmp     incbuffexit     ; good exit
;
; handle end of file exception
incbuff5:
        mov     ax,19           ; end of file code
        stc                     ; set carry for error
        jmp     incbuffret      ; return with error
;
incbuffexit:
        clc                     ; clear carry - no error
;
incbuffret:
        pop     ds
        ret
;
incbuff endp
;----------------------- routine ends ------------------------------+
;
;----------------------- routines begins ---------------------------+
;FUNCTION: This routine flushes all bytes from a circular buffer,
; sending them to a specified file.
;INPUT:  Upon entry BX contains the file handle is in BX.
;REGISTERS USED: Only AX and SI are modified. AX contains the
; exception code. SI is the buffer pointer and is updated to reflect
; the characters taken. BX is the file handle for the output file.
;SEGMENTS REFERENCED: Upon entry the data segment must contain the
; LASTBYTE, and the linear buffer LBUFF.
;ROUTINES CALLED: WRITEFILE
;SPECIAL NOTES: None
;--------------------------------------------------------------------
; ROUTINE TO FLUSH A CIRCULAR BUFFER
;
flushit proc    far
;
        push    di              ; save registers
        push    dx
        push    ds
        push    cx
;
        mov     ax,dseg
        mov     ds,ax
;
; get the bytes from the buffer
        mov     cx,ds:gauge     ; get the count
        jcxz    flushitexit     ; check for empty
        mov     di,0            ; initialize destination
;
; loop to get all the bytes
flushit1:
        mov     al,ds:cbuff[si] ; get the character
        inc     si              ; increment the pointer
        cmp     si,cbuffsize    ; wrap it?
        jne     flushit2        ; skip if no wrap
        mov     si,0            ; wrap the buffer pointer
flushit2:
        mov     ds:lbuff[di],al ; put the byte inlinear buffer
        inc     di
        loop    flushit1        ; loop until all bytes in lbuff
;
; send the linear buffer to the disk
        mov     cx,ds:gauge     ; this is the number of bytes
        lea     dx,ds:lbuff     ; this is where they are
        call    writefile       ; send them out
        mov     ds:gauge,0      ; set circular buffer empty
;
flushitexit:
        pop     cx              ; restore registers
        pop     ds
        pop     dx
        pop     di
        ret
;
flushit endp
;----------------------- routine ends ------------------------------+
;
;----------------------- routines begins ---------------------------+
;FUNCTION: This routine handles output from a circular buffer.
; It checks to see if there are enough bytes in the buffer to send to
; disk. If there are not enough then it returns without further
; action. If there are enough then it sends a block of bytes to an
; opened file through the WRITEFILE routine.
;INPUT:  Upon entry BX contains the file handle of output file.
; Input is from the circular buffer.
;OUTPUT: Output to a file. If the buffer gets nearly empty then a
; control Q is sent to the standard output device. If the write was
; unsuccessful the carry is set and the error code is returned. If a
; control Z is detected from the circular buffer the carry is set and
; error code 19(end of file) is returned.
;REGISTERS USED: Only AX and SI are modified. AX contains the 
; exception code, SI is the buffer pointer and is updated according
; to the characters taken. BX is the file handle for the ouput file.
;SEGMENTS REFERENCED: Upon entry the data segment must contain the
; circular buffer and its variables, CBUFF and GAUGE, and the
; variable LASTBYTE.
;ROUTINES CALLED: COMOFF,FLUSHIT
;SPECIAL NOTES: None
;--------------------------------------------------------------------
; ROUTINE TO HANDLE OUTPUT FROM A CIRCULAR BUFFER
;
outcbuff        proc    far
;
        push    ds
        push    ax
;
        mov     ax,dseg 
        mov     ds,ax
        pop     ax
;
; check for enough characters in the buffer
        cmp     ds:gauge,blksize; any characters?
        jl      outcbuffexit    ; exit if no characters
;
; empty the buffer
        call    comoff          ; hold the com line
        call    flushit         ; flush the buffer
        je      outcbuffret     ; error?
;
outcbuffexit:
        clc                     ; clear carry - no exception
outcbuffret:
        pop     ds
        ret
;
outcbuff        endp
;----------------------- routine ends ------------------------------+

codes   ends
;----------------------- code area ends ----------------------------+
        end
