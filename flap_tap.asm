[org 0x0100]

jmp start

old_timer dd 0

buffer times 11352 db 99

background_Starting dw 37

pipe_Distance dw 12

pipe1_Coordinates dw 132
pipe2_Coordinates dw 0
array dw 15,24,8,22,5,21,4,10,2,5
current_Location dw 0

pipe1_Row dw 10
pipe2_Row dw 10
draw_Pipe_2 db 0  ;0 means no draw 1 mean draw the pipe 2

oldisr: dd 0
is_Pause: db 1  ;0 is pause and 1 is resume
is_Over: db 1
is_restart: db 0
Terminator: db 0 
is_question: db 0
bird_Row dw 10
bird_Direction db 'd'
wing_direction db 'u'
counter db 0
start_Menu db 1
wing_delay db 3
bird_speed db 1
flap_Count dw 0
music_bool db 1

score_Check db 0 ;0 means no check 
score dw 0,0
line0: db '+--------------------------------------------+',0
line1: db '|   ______ _               _______           |',0
line2: db '|  |  ____| |             |__   __|          |',0
line3: db '|  | |__  | | __ _ _ __      | | __ _ _ __   |',0
line4: db '|  |  __| | |/ _` |  _ \     | |/ _` |  _ \  |',0
line5: db '|  | |    | | (_| | |_) |    | | (_| | |_) | |',0
line6: db '|  |_|    |_|\__,_| .__/     |_|\__,_| .__/  |',0
line7: db '|                 | |                | |     |',0
line8: db '|                 |_|                |_|     |',0
line9: db '                Press Any Key to Start ',0
line10: db ' Press Any Key to Start ',0

 
Overline0: db '+---------------------------------------------------------+',0
Overline1: db '|    _____                         ____                   |',0
Overline2: db '|   / ____|                       / __ \                  |',0
Overline3: db '|  | |  __  __ _ _ __ ___   ___  | |  | |_   _____ _ __   |',0
Overline4: db '|  | | |_ |/ _  |  _   _ \ / _ \ | |  | \ \ / / _ \  __|  |',0
Overline5: db '|  | |__| | (_| | | | | | |  __/ | |__| |\ V /  __/ |     |',0
Overline6: db '|   \_____|\__,_|_| |_| |_|\___|  \____/  \_/ \___|_|     |',0
Overline7: db'+---------------------------------------------------------+',0
Overline8: db'Your Score is: ',0
Overline9: db'Press "Enter" to restart.',0
Overline10: db'Press "E" to exit.',0


Questionline0: db '  ______      _ _    ',0
Questionline1: db ' |  ____|    (_) |   ',0
Questionline2: db ' | |__  __  ___| |_  ',0
Questionline3: db ' |  __| \ \/ / | __| ',0
Questionline4: db ' | |____ >  <| | |_  ',0
Questionline5: db ' |______/_/\_\_|\__| ',0    
Questionline6: db '                     ',0              
Questionline7: db'Your Score is: ',0
Questionline8: db' Press "P" to continue playing. ',0
Questionline9: db' Press "E" to exit. ',0


message1 db ' Hamza Naveed   23L-0618 ',0
message2 db ' Huzaifa Shabbir 23L-0647 ',0
message3 db ' Fall 2023      BCS-3J   ',0

instruction1 db '1. Press Esc to exit. ',0
instruction2 db '2. Press Space to move bird up. ',0
instruction3 db '3. Press P to Pause/Resume game. ',0
instruction4 db '4. Press M to Mute/Play music. ',0

thanks0 db ' .----------------.  .----------------.  .----------------.  ',0
thanks1 db '| .--------------. || .--------------. || .--------------. | ',0
thanks2 db '| |   ______     | || |  ____  ____  | || |  _________   | | ',0
thanks3 db '| |  |_   _ \    | || | |_  _||_  _| | || | |_   ___  |  | | ',0
thanks4 db '| |    | |_) |   | || |   \ \  / /   | || |   | |_  \_|  | | ',0
thanks5 db '| |    |  __ .   | || |    \ \/ /    | || |   |  _|  _   | | ',0
thanks6 db '| |   _| |__) |  | || |    _|  |_    | || |  _| |___/ |  | | ',0
thanks7 db '| |  |_______/   | || |   |______|   | || | |_________|  | | ',0
thanks8 db '| |              | || |              | || |              | | ',0
thanks9 db '| .--------------. || .--------------. || .--------------. | ',0
thanks10 db ' .----------------.  .----------------.  .----------------. ',0



; PCB layout:
; ax,bx,cx,dx,si,di,bp,sp,ip,cs,ds,ss,es,flags,next,dummy
; 0, 2, 4, 6, 8,10,12,14,16,18,20,22,24, 26 , 28 , 30
pcb: times 2*16 dw 0 ; space for 32 PCBs
stack: times 2*256 dw 0 ; space for 32 512 byte stacks
nextpcb: dw 1 ; index of next free pcb
current: dw 0 ; index of current pcb



print_triangle:
push bp
mov bp,sp
    pusha
    mov ax, 0xB800              ; Set ES to VGA video memory segment (0xB800)
    mov es, ax

    mov cx, [bp+8]     ; CX controls the number of rows in the triangle
    mov bx, [bp+6]     ; BX is the starting row (top of triangle)

next_row:
    ; Calculate starting offset for this row
    mov dx, bx                  ; DX = current row number
    mov ax, dx
    mov di, 132                 ; 80 columns per row
    mul di                      ; Multiply row number by 80 for row offset
    add ax, [bp+4]                 ; Center the triangle horizontally (40th column)
    sub ax, cx                  ; Center the triangle based on current row width
    shl ax, 1                   ; Each character takes 2 bytes in memory (char + attribute)
    mov di, ax                  ; DI points to calculated position in video memory

    ; Print spaces with yellow color for this row of the triangle
    mov ax, [bp+10]              ; Yellow foreground (0x0E) with space character (' ')
    mov si, cx                  ; SI holds the number of spaces to print
row_loop:
    stosw    
	push word 0x4fff
    call delay	; Write ' ' with yellow attribute
    dec si
    jnz row_loop                ; Loop until SI reaches 0

    inc bx                      ; Move to the next row
    dec cx                      ; Decrease width for the next row of the triangle
    cmp cx, 0
	push word 0x4fff
	call delay
    jg next_row                 ; Continue until the triangle is complete

    popa
	pop bp
    ret 8


clear:
			
    pusha
    push es
	
	mov ax, 0xb800
			mov es, ax					; point es to video base
			mov di, 0					; point di to top left column

nextloc:	mov word [es:di], 0x3720	; clear next char on screen
			add di, 2					; move to next screen location
			cmp di, 9240				; has the whole screen cleared
			jne nextloc		
 nextloc1:	mov word [es:di], 0x62b2	; clear next char on screen
			 add di, 2					; move to next screen location
			 cmp di, 11352				; has the whole screen cleared
			 jne nextloc1				; if no clear next position

	
    mov ax, 0xb800        ; Set ES to point to VGA text memory segment (0xB800)
    mov es, ax
    xor di, di            ; Initialize DI to the beginning of video memory


    ; Draw top border
    mov di, 0
    mov word [es:di], 0x60c9  ; Top-left corner (╔)
    add di, 2
    mov cx, 130
    mov ax, 0x60cd 
	
	;cf
push word 0x4fff
call delay	               ; Horizontal line (═) with attribute 0x4F
    
upper_Loop1:
	 stosw
	 push word 0x4fff
	 call delay
	 loop upper_Loop1
    mov word [es:di], 0x60bb ; Top-right corner (╗)
    add di, 264              ; Move to the start of the second row

    ; Draw left and right vertical borders
    mov cx, 41
    mov ax, 0x60ba           ; Vertical line (║) with attribute 0x4F
right_loop1:
    mov [es:di], ax          ; Left border
    add di, 264   
push word 0x4fff
call delay	; Move to next row, two bytes from the left border
    ;stosw                    ; Write on the right border
    ;add di, 2                ; Move past the right border for the next loop
    loop right_loop1

    ; Draw bottom border
    ;sub di, 160               ; Move DI back to start of the last row
    mov word [es:di], 0x60bc ; Bottom-right corner (╝)
    mov cx, 130
	mov al,205
loopp3:
push word 0x4fff
call delay
    sub di, 2             ; Move to the left side of the last row
    mov word [es:di], ax  ; Bottom-left corner (╚)
loop loopp3
mov al,200
sub di,2
mov [es:di],ax
sub di,264

push word 0x4fff
call delay

mov cx,41
mov al,186
loopp4:
mov [es:di],ax
sub di,264
loop loopp4

;start here
    mov di, 266
    mov word [es:di], 0x60c9  ; Top-left corner (╔)
    add di, 2
    mov cx, 128
    mov ax, 0x60cd 
	
	;cf
	push word 0x4fff
call delay	               ; Horizontal line (═) with attribute 0x4F
    
upper_Loop2:
	 stosw
	 	push word 0x4fff
	 call delay
	 loop upper_Loop2
    mov word [es:di], 0x60bb ; Top-right corner (╗)
    add di, 264              ; Move to the start of the second row

    ; Draw left and right vertical borders
    mov cx, 39
    mov ax, 0x60ba           ; Vertical line (║) with attribute 0x4F
right_Loop2:
    mov [es:di], ax          ; Left border
    add di, 264  
push word 0x4fff	
call delay	; Move to next row, two bytes from the left border
    ;stosw                    ; Write on the right border
    ;add di, 2                ; Move past the right border for the next loop
    loop right_Loop2

    ; Draw bottom border
    ;sub di, 160               ; Move DI back to start of the last row
    mov word [es:di], 0x60bc ; Bottom-right corner (╝)
    mov cx, 128
	mov al,205
loop13:
push word 0x4fff
call delay
    sub di, 2             ; Move to the left side of the last row
    mov word [es:di], ax  ; Bottom-left corner (╚)
loop loop13
mov al,200
sub di,2
mov [es:di],ax
sub di,264

push word 0x4fff
call delay

mov cx,39
mov al,186
loop14:
mov [es:di],ax
sub di,264
loop loop14

;end here

mov di, 532
    mov word [es:di], 0x60c9  ; Top-left corner (╔)
    add di, 2
    mov cx, 126
    mov ax, 0x60cd 
	
	;cf
	push word 0x4fff
call delay	               ; Horizontal line (═) with attribute 0x4F
    
upper_Loop3:
	 stosw
	 push word 0x4fff
	 call delay
	 loop upper_Loop3
    mov word [es:di], 0x60bb ; Top-right corner (╗)
    add di, 264              ; Move to the start of the second row

    ; Draw left and right vertical borders
    mov cx, 37
    mov ax, 0x60ba           ; Vertical line (║) with attribute 0x4F
loop22:
    mov [es:di], ax          ; Left border
    add di, 264   
push word 0x4fff
call delay	; Move to next row, two bytes from the left border
    ;stosw                    ; Write on the right border
    ;add di, 2                ; Move past the right border for the next loop
    loop loop22

    ; Draw bottom border
    ;sub di, 160               ; Move DI back to start of the last row
    mov word [es:di], 0x60bc ; Bottom-right corner (╝)
    mov cx, 126
	mov al,205
looop23:
push word 0x4fff
call delay
    sub di, 2             ; Move to the left side of the last row
    mov word [es:di], ax  ; Bottom-left corner (╚)
loop looop23
mov al,200
sub di,2
mov [es:di],ax
sub di,264

push word 0x4fff
call delay

mov cx,37
mov al,186
looop24:
mov [es:di],ax
sub di,264
loop looop24

;end here



push 0x47
push 0B29h
push line0
call printstr
push 0x47
push 0C29h
push line1
call printstr
push 0x47
push 0D29h
push line2
call printstr
push 0x47
push 0E29h
push line3
call printstr
push 0x47
push 0F29h
push line4
call printstr
push 0x47
push 1029h
push line5
call printstr
push 0x47
push 1129h
push line6
call printstr
push 0x47
push 1229h
push line7
call printstr
push 0x47
push 1329h
push line8
call printstr
push 0x47
push 1429h
push line0
call printstr
push 0xB0
push 1627h
push line9
call printstr



push 0x30
push 0465h
push message2
call printstr
push 0x30
push 0565h
push message1
call printstr
push 0x30
push 0665h
push message3
call printstr



mov ah,0
int 0x16


			mov ax, 0xb800
			mov es, ax					; point es to video base
			mov di, 0					; point di to top left column

nextloc6:	mov word [es:di], 0x3720	; clear next char on screen
			add di, 2					; move to next screen location
			cmp di, 9240				; has the whole screen cleared
			jne nextloc6		
nextloc7:	mov word [es:di], 0x62b2	; clear next char on screen
			add di, 2					; move to next screen location
			cmp di, 11352				; has the whole screen cleared
			jne nextloc7				; if no clear next position

push 0xb800
pop es
mov di,0
add di,1916
mov ax,0x4020
mov bx,15
loop_to_print_box1:
mov cx,60
rep stosw
add di,144
dec bx
cmp bx,0
jne loop_to_print_box1



push 0x47
push 0A25h
push instruction1
call printstr
push 0x47
push 0C25h
push instruction2
call printstr
push 0x47
push 0E25h
push instruction3
call printstr
push 0x47
push 1025h
push instruction4
call printstr
push 0xB0
push 1827h
push line9
call printstr

end:
    pop es
    popa
    ret


WRITE_FRAME: 

    push es
	push ds
    push si
	push cx 
	push di
	push dx
	push ax
	

    mov si, buffer            ;ds:si -> frame buffer (source)                  

    mov cx, 0xb800
     mov es, cx
     xor di, di             ;es:di -> video memory (destination)

    mov cx,5676     	;writing 32,000 words of pixels

                           ;If vert. retrace bit is set, wait for it to clear
    mov dx, 3dah           ;dx <- VGA status register
VRET_SET:
    in al, dx              ;al <- status byte
    and al, 8              ;is bit 3 (vertical retrace bit) set
    jnz VRET_SET           ;If so, wait for it to clear

VRET_CLR:                  ;When it's cleared, wait for it to be set
    in al, dx
    and al, 8
    jz VRET_CLR            ;loop back till vert. retrace bit is newly set
	
    rep movsw              ;write the frame
	
    pop ax
	pop dx
	pop di
	pop cx 
	pop si 
	pop ds
	pop es
    ret


delay:
push bp
mov bp,sp
pusha

mov cx,[bp+4]
waste:
loop waste

popa
pop bp
ret 2



; Random Number Generator: Returns a random number in the range [1-17]
; Input: Address to store the random number (passed on the stack)
; Output: Random number stored at the given address
random_Number_Generator:

add word[cs:current_Location],2
cmp word[cs:current_Location],20
jne next222
mov word[cs:current_Location],0


next222:

mov si,[cs:current_Location]
mov ax,[cs:array+si]

ret
next_P:
    push bp
    mov bp, sp       ; Setup stack frame

    pusha            ; Save all registers
    mov ah, 0        ; BIOS function to get system timer tick count
    int 1Ah          ; Get timer count in CX:DX
    mov ax, dx       ; Use DX as the random seed
    
    mov bx, 17       ; Set the divisor (17)
    xor dx, dx       ; Clear DX for division
    div bx           ; Divide AX by 17, remainder in DX

    inc dx           ; Shift range from [0–16] to [1–17]
    mov si, [bp+4]   ; Get the address to store the result
    mov [si], dx     ; Store the result at the given address
    mov [bp+4],dx
    popa             ; Restore registers
    pop bp
					; Restore base pointer
    ret             ; Return and clean up parameter from stack



Game_over_screen:
push bp
mov bp, sp
pusha
push es
cmp byte[cs:is_Over],0
jne end_of_check_printing
; initialize video segment for text mode
push ds
pop es
mov di,buffer
mov ax,0x3020
mov cx,4884
rep stosw
push 0x47
push 0622h
push Overline0
call printstr
push 0x47
push 0722h
push Overline1
call printstr
push 0x47
push 0822h
push Overline2
call printstr
push 0x47
push 0922h
push Overline3
call printstr
push 0x47
push 0A22h
push Overline4
call printstr
push 0x47
push 0B22h
push Overline5
call printstr
push 0x47
push 0C22h
push Overline6
call printstr
push 0x47
push 0D22h
push Overline7
call printstr
push 0xB0
push 1037h
push Overline8
call printstr
push 0xB0
push 4366
push word [cs:score]
call print_Score
push 0x30
push 7956
push Overline9
call printstr
push 0x30
push 8468
push Overline10
call printstr

end_of_check_printing:

cmp byte[cs:is_restart],1
jne end_of_over_printing

Restart_command:
push 0xffff
call delay
push 0xffff
call delay

mov word[cs:pipe1_Coordinates], 132
mov word[cs:pipe2_Coordinates], -9
mov word[cs:pipe1_Row ], 10
mov word[cs:pipe2_Row] , 10
mov word[cs:score],0
mov word[cs:bird_Row],10
call print_Background
mov byte[cs:is_restart],0

end_of_over_printing:
pop es
popa
pop bp
ret


printstr:
    push bp
	mov bp, sp
	push es
	push ax
	push cx
	push si
	push di	
	push ds
	pop es ; load ds in es
	mov di, [bp+4] ; point di to string
	mov cx, 0xffff
	xor al, al ; load a zero in al
	repne scasb ; find zero in the string
	mov ax, 0xffff
	sub ax, cx ; find change in cx
	dec ax ; exclude null from length
	mov cx,ax
		mov ah, 0x13		; service 13 - print string
		
		mov al, 1			; subservice 01 – update cursor 

		mov bh, 0			; output on page 0
		mov bl, [bp+8]	; normal attrib
		mov dx, [bp+6]		; row 10 column 3
		
		;es:bp = ds:message
		push ds
		pop es				; es=ds segment of string
		mov bp, [bp+4]		; bp = offset of string
		
		INT 0x10			; call BIOS video service
exit:	
	pop di
	pop si
	pop cx
	pop ax
	pop es
	pop bp
	ret 6


print_Background:
       
push bp
mov bp,sp	                     ;pushing all the registers to maintain the state
pusha
push es

push ds
pop es

mov ax,[background_Starting]
mov bx,132
mul bx
mov cx,ax
mov si,5676
sub si,cx
mov di,buffer
mov ax,0x3200

cld  
rep stosw

mov cx,si
mov ax,0x62b2
rep stosw

mov ax,[background_Starting]
inc ax
mov cx,132
mul cx
shl ax,1
mov di,ax
mov cx,66
mov ax,0x62f7
sub di,3
cld 
loop1:
stosw
add di,2
loop loop1 
  
print_End:	
pop es
popa
pop bp

ret                           ;return

move_Screen:

push bp
mov bp,sp
pusha
push ds
push es

cmp byte[cs:is_Over],0
je move_Screen_End

normal:
cmp byte[cs:is_Pause],0
je move_Screen_End

	cmp byte[bird_speed],2
	jne move_Bird
	mov byte[bird_speed],0
    cmp byte [bird_Direction], 'd'
    jne move_Up

    cmp byte [bird_Row], 33     ; Lower bound check
    jge move_Bird
    inc byte [bird_Row]         ; Move down if in bounds
    jmp move_Bird

move_Up:
    cmp byte [bird_Row], 0      ; Upper bound check
    jle move_Bird 
    dec byte [bird_Row]         ; Move up if in bounds

move_Bird:
	add byte[bird_speed],1
   push word [bird_Row]
   call Print_Bird             ; Display bird at new position

skip_Bird_Movement:

push ds
pop es
mov bx,buffer
add bx,9768
mov di,bx
add bx,2
mov si,bx

mov cx,130

loop2:
movsw
push word 0xf
call delay
loop loop2

mov ax,[es:di]
cmp ax,0x62f7
jne pattern

mov word[es:si],ax
mov word[es:di],0x62b2
jmp move_Screen_End

pattern:
mov word[es:si],0x62b2
mov word[es:di],0x62f7

move_Screen_End:
pop es
pop ds
popa
pop bp

ret 

generate_Pipe:
pusha

cmp byte[cs:is_Pause],0
je generate_Pipe_End

call clear_Pipe
dec word[cs:pipe1_Coordinates]

cmp byte[cs:draw_Pipe_2],0
je not_Draw_2
dec word[cs:pipe2_Coordinates]
not_Draw_2:

cmp word[cs:pipe1_Coordinates],55
jne next_Comparison
mov byte[cs:draw_Pipe_2],1
mov word[cs:pipe2_Coordinates],132
mov ax,37
sub ax,[pipe_Distance]
call random_Number_Generator
mov [pipe2_Row],ax

next_Comparison:
cmp word[cs:pipe1_Coordinates],-12
jne print_Screen

mov word[cs:pipe1_Coordinates],132
mov ax,37
sub ax,[pipe_Distance]
call random_Number_Generator
mov [pipe1_Row],ax

print_Screen:
mov cx,0
loop3:

cmp cx,[pipe1_Row]
jl print_1

mov ax,[pipe1_Row]
add ax,[pipe_Distance]
cmp cx,ax
jnl print_1
jmp next_2

print_1:
push word[cs:pipe1_Coordinates]
push cx
call draw_Segment

next_2:
cmp byte[cs:draw_Pipe_2],0
je next_

cmp cx,[pipe2_Row]
jl print_2

mov ax,[pipe2_Row]
add ax,[pipe_Distance]
cmp cx,ax
jnl print_2
jmp next_

print_2:
push word[cs:pipe2_Coordinates]
push cx
call draw_Segment

next_:
inc cx

cmp cx,37
jne loop3

generate_Pipe_End:
popa
ret

clear_Pipe:
push bp
pusha
push es
push ds
pop es


mov di,buffer
mov ax,0

mov ax,0x3200
mov bx,37

outer:
mov cx,132
cld 
rep stosw 

dec bx
cmp bx,0
jne outer

pop es
popa
pop bp
ret 



draw_Segment:

push bp
mov bp,sp
pusha
push es
push ds
pop es

mov ax,132
mul word[bp+4]
mov bx,ax
shl bx,1

mov dx,bx
add dx,buffer

add bx,262
add bx,buffer
add ax,[bp+6]
shl ax,1


mov di,ax
add di,buffer
mov cx,10
mov ax,0x1700

cld

loop4:

cmp di,bx
jg skip_Pipe_Print

cmp di,dx
jl skip_Pipe_Print

stosw
jmp next3
skip_Pipe_Print:
add di,2

next3:
loop loop4

pop es
popa
pop bp
ret 4

Question_screen:
push bp
mov bp, sp
pusha
push es
cmp byte[cs:is_question],1
jne end_of_question_printing
cmp byte[cs:is_Over],1
jne end_of_question_printing
; initialize video segment for text mode
push ds
pop es
mov di,buffer
add di,1916
mov ax,0x7020
mov bx,15
loop_to_print_box:
mov cx,60
rep stosw
add di,144
dec bx
cmp bx,0
jne loop_to_print_box
push 0x47
push 0836h
push Questionline0
call printstr
push 0x47
push 0936h
push Questionline1
call printstr
push 0x47
push 0A36h
push Questionline2
call printstr
push 0x47
push 0B36h
push Questionline3
call printstr
push 0x47
push 0C36h
push Questionline4
call printstr
push 0x47
push 0D36h
push Questionline5
call printstr
push 0x47
push 0E36h
push Questionline6
call printstr
push 0xf0
push 1038h
push Questionline7
call printstr
push 0xf0
push 4366
push word [cs:score]
call print_Score
push 0x70
push 1232h
push Questionline8
call printstr
push 0x70
push 1432h
push Questionline9
call printstr

cmp byte[cs:is_Pause],1
jne end_of_question_printing
call print_Background 

end_of_question_printing:

pop es
popa
pop bp
ret


Print_Bird:
    ; push registers to save current state
    push bp
    mov bp, sp
    pusha
    push es
    
    ; initialize video segment for text mode
    push ds
	pop es
	
	mov ax,132
	mul word[bp+4]
	add ax,30
	shl ax,1
	mov di,buffer
	add di,ax
	
	push di
	mov ax,0x4f20
	mov bx,2
	printer1:
	mov cx,4
	rep stosw
	add di,256
	dec bx
	cmp bx,0
	jnz printer1
	sub di,12
	push di
	mov bx,2
	printer2:
	mov cx,8
	rep stosw
	add di,248
	dec bx
	cmp bx,0
	jnz printer2
	pop di
	add di,8
	mov word [es:di],0x0000
	cmp byte[wing_delay],3
	jne incrementer
delayer:	
	cmp byte[wing_direction],'d'
	jne down_wings
	
up_wings:
	sub di,264
	std
	mov ax,0x0e5c
    mov cx,6
	rep stosw
	mov byte[wing_direction],'u'
	mov byte[wing_delay],0
	jmp out_wings
	
down_wings:
	add di,264
	std
	mov ax,0x0e5c
    mov cx,6
	mov byte[wing_direction],'d'
	rep stosw 	
	mov byte[wing_delay],0

incrementer:
	inc byte[wing_delay]

	out_wings:
	pop di
	add di,6
	mov word[es:di],0x0f6f
	add di,266
	mov word[es:di],0x303e
	cld
	
    pop es
    popa
    pop bp
    ret 2

	
kbisr:
pusha

in al,0x60

cmp al,0x19
jne No_P_Press
cmp byte [cs:is_Over],0
je No_P_Press
cmp byte[cs:is_Pause],0
je game_Resume

mov byte[cs:is_Pause],0
jmp No_P_Press

game_Resume:
mov byte[cs:is_Pause],1
cmp byte[cs:is_question],1
jne No_P_Press
mov byte[cs:is_question],0
No_P_Press:

cmp al,0x1c
jne No_enter_Press

cmp byte[cs:is_Over],0
jne No_enter_Press

cmp byte[cs:is_restart],0
jne No_enter_Press
mov byte[cs:is_restart],1
mov byte[cs:is_Pause],1
mov byte[cs:is_Over],1

No_enter_Press:
cmp al,0x01
jne No_Ecs_pressed

cmp byte [cs:is_Over],0
je No_Ecs_pressed

cmp byte[cs:is_question],0
jne No_Ecs_pressed

mov byte[cs:is_question],1
mov byte[cs:is_Pause],0

No_Ecs_pressed:

cmp al,0x12
jne No_E_Pressed

cmp byte[cs:is_question],1
jne check2
mov byte[cs:Terminator],1
jmp No_E_Pressed

check2:
cmp byte[cs:is_Over],0
jne No_E_Pressed
mov byte[cs:Terminator],1

No_E_Pressed:
cmp al,0x32
jne No_M_Pressed
cmp byte[cs:music_bool],1
je option2
mov byte[cs:music_bool],1
jmp No_M_Pressed
option2:
mov byte[cs:music_bool],0

No_M_Pressed:
cmp al,0x39
jne kbisr_End
mov byte[cs:bird_Direction],'u'
jmp kbisr_End


kbisr_End:

mov al, 0x20
out 0x20, al 
popa
			
iret

Print_Bird_on_screen:
; push registers to save current state
    push bp
    mov bp, sp
    pusha
    push es
    
    ; initialize video segment for text mode
mov ax,0xB800
mov es,ax	

	mov ax,132
	mul word[bp+4]
	add ax,30
	shl ax,1
	mov di,0
	add di,ax
	
	push di
	mov ax,0x4f20
	mov bx,2
	printer6:
	mov cx,4
	rep stosw
	add di,256
	dec bx
	cmp bx,0
	jnz printer6
	sub di,12
	push di
	mov bx,2
	printer7:
	mov cx,8
	rep stosw
	add di,248
	dec bx
	cmp bx,0
	jnz printer7
	pop di
	add di,8
	mov word [es:di],0x0000
	
down_wings_2:
	add di,264
	std
	mov ax,0x0e5c
    mov cx,6
	mov byte[wing_direction],'d'
	rep stosw 	

	out_wings_2:
	pop di
	add di,6
	mov word[es:di],0x0f78
	add di,266
	mov word[es:di],0x303e
	cld
	
    pop es
    popa
    pop bp
    ret 2			
			
dropper:
push word[cs:bird_Row]
call Clear_Bird

loop_inshallah_last:
call WRITE_FRAME
push word[cs:bird_Row]
call Print_Bird_on_screen
push 0xffff
call delay
push 0xffff
call delay
cmp word[cs:bird_Row],33
je break
inc word[cs:bird_Row]
jmp loop_inshallah_last
break:
mov word[cs:bird_Row],10
ret 

collision:
pusha
push es

cmp byte[cs:is_Over],0
je collision_End

mov ax,132
mul word[bird_Row]
add ax,30
shl ax,1

mov di,ax
mov ax,0xb800
mov es,ax

sub di,260   ;5 columns ahead
cmp word[es:di],0x1700
jne next_Collision12

mov byte[cs:is_Over],0
mov byte[cs:is_Pause],0
jmp over_delay

next_Collision12:
add di,4
cmp word[es:di],0x1700
jne next_Collision11
mov byte [cs:is_Over],0
mov byte[cs:is_Pause],0
jmp over_delay

next_Collision11:
add di,264
cmp word[es:di],0x1700
jne next_Collision1
mov byte [cs:is_Over],0
mov byte[cs:is_Pause],0

jmp over_delay
	

next_Collision1:
add di,266
cmp word[es:di],0x1700
jne next_Collision2
mov byte [cs:is_Over],0
mov byte[cs:is_Pause],0
jmp over_delay

next_Collision2:
add di,788
cmp word[es:di],0x1700
jne next_Collision3
mov byte [cs:is_Over],0
mov byte[cs:is_Pause],0
jmp over_delay

next_Collision3:
sub di,16
cmp word[es:di],0x1700
jne next_Collision4
mov byte [cs:is_Over],0
mov byte[cs:is_Pause],0
jmp over_delay

next_Collision4:
sub di,530
cmp word[es:di],0x1700
jne next_Collision5
mov byte [cs:is_Over],0
mov byte[cs:is_Pause],0
jmp over_delay

next_Collision5:
sub di,528
cmp word[es:di],0x1700
jne next_Collision6
mov byte [cs:is_Over],0
mov byte[cs:is_Pause],0
jmp over_delay

 next_Collision6:
cmp word[cs:bird_Row],33
jne collision_End
mov byte [cs:is_Over],0
mov byte[cs:is_Pause],0
jmp over_delay


over_delay:
cmp byte[cs:is_Over],0
jne collision_End
call WRITE_FRAME
push 0xffff
call delay
push 0xffff
call delay
push 0xffff
call delay
push 0xffff
call delay
push 0xffff
call delay
push 0xffff
call delay
push 0xffff
call delay


call dropper

push 0xffff
call delay
push 0xffff
call delay
push 0xffff
call delay
push 0xffff
call delay
push 0xffff
call delay
push 0xffff
call delay
push 0xffff
call delay
push 0xffff
call delay
push 0xffff
call delay
push 0xffff
call delay
push 0xffff
call delay
push 0xffff
call delay
push 0xffff
call delay
push 0xffff
call delay
push 0xffff
call delay
push 0xffff
call delay
push 0xffff
call delay
push 0xffff
call delay
push 0xffff
call delay
push 0xffff
call delay




collision_End:

pop es
popa
ret

Calculate_Score:
pusha
push es

cmp byte[cs:is_Pause],0
je score_Calculation_End
cmp byte[score_Check],0
jne calculation

cmp word[cs:pipe1_Coordinates],15
jne next_Score
mov byte[cs:score_Check],1
jmp score_Calculation_End

next_Score:
cmp word[cs:pipe2_Coordinates],15
jne score_Calculation_End
mov byte[cs:score_Check],1
jmp score_Calculation_End

calculation:
mov ax,[cs:pipe1_Coordinates]
add ax,10
cmp ax,30
jge next_Calculation
inc word[cs:score]
mov byte[cs:score_Check],0
jmp score_Calculation_End

next_Calculation:
mov ax,[cs:pipe2_Coordinates]
add ax,10
cmp ax,30
jge score_Calculation_End
inc word[cs:score]
mov byte[cs:score_Check],0
score_Calculation_End:
push 0x30
push 250
push word[cs:score]
call print_Score

pop es
popa
ret


print_Score: 
push bp
mov bp, sp
pusha
push es
mov di,buffer

push ds
pop es    ; point es to video base
mov ax, [bp+4] ; load number in ax
mov bx, 10 ; use base 10 for division
mov cx, 0 ; initialize count of digits
nextdigit: mov dx, 0 ; zero upper half of dividend
div bx ; divide by 10
add dl, 0x30 ; convert digit into ascii value
push dx ; save ascii value on stack
inc cx ; increment count of values
cmp ax, 0 ; is the quotient zero
jnz nextdigit ; if no divide it again
add di, [bp+6] ; point di to 70th column
nextpos: pop dx ; remove a digit from the stack
mov dh, [bp+8] ; use normal attribute
mov [es:di], dx ; print char on screen
add di, 2 ; move to next screen location
loop nextpos ; repeat for all digits on stack

pop es
popa
pop bp
ret 6

thanks_screen:
			push es
			push ax
			push di

			mov ax, 0xb800
			mov es, ax					; point es to video base
			mov di, 0					; point di to top left column

thnx:	mov word [es:di], 0x7020	; clear next char on screen
			add di, 2					; move to next screen location
			cmp di, 11352				; has the whole screen cleared
			jne thnx					; if no clear next position

			
			
			
push 0x74
push 0622h
push thanks0
call printstr
push 0x74
push 0722h
push thanks1
call printstr
push 0x74
push 0822h
push thanks2
call printstr
push 0x74
push 0922h
push thanks3
call printstr
push 0x74
push 0A22h
push thanks4
call printstr
push 0x74
push 0B22h
push thanks5
call printstr
push 0x74
push 0C22h
push thanks6
call printstr
push 0x74
push 0D22h
push thanks7
call printstr
push 0x74
push 0E22h
push thanks8
call printstr
push 0x74
push 0F22h
push thanks9
call printstr
push 0x74
push 1022h
push thanks10
call printstr



			pop di
			pop ax
			pop es
			ret


restarter:
  call clear
	mov ah, 0		
   int 0x16
ret

Clear_Bird:
      ; push registers to save current state
    push bp
    mov bp, sp
    pusha
    push es
    
    ; initialize video segment for text mode
    push ds
	pop es
	
	mov ax,132
	mul word[bp+4]
	add ax,30
	shl ax,1
	mov di,buffer
	add di,ax
	
	push di
	mov ax,0x3f20
	mov bx,2
	printer3:
	mov cx,4
	rep stosw
	add di,256
	dec bx
	cmp bx,0
	jnz printer3
	sub di,12
	push di
	mov bx,2
	printer4:
	mov cx,8
	rep stosw
	add di,248
	dec bx
	cmp bx,0
	jnz printer4
	pop di
	add di,8
	mov word [es:di],0x3f20
push di	
up_wings_1:
	sub di,264
	std
	mov ax,0x3f20
    mov cx,6
	rep stosw
pop di	
down_wings_1:
	add di,264
	std
	mov ax,0x3f20
    mov cx,6
	rep stosw 	

	out_wings_1:
	pop di
	add di,6
	mov word[es:di],0x3f20
	add di,266
	mov word[es:di],0x3020
	cld
	
    pop es
    popa
    pop bp
    ret 2
	
static_Screen:
push bp
pusha


mov ax, 0xb800
			mov es, ax					; point es to video base
			mov di, 0					; point di to top left column

nextloc2:	mov word [es:di], 0x3720	; clear next char on screen
			add di, 2					; move to next screen location
			cmp di, 9240				; has the whole screen cleared
			jne nextloc2	
nextloc3:	mov word [es:di], 0x62b2	; clear next char on screen
			add di, 2					; move to next screen location
			cmp di, 11352				; has the whole screen cleared
			jne nextloc3				; if no clear next position

call print_Background
mov word[cs:pipe1_Coordinates],110
call generate_Pipe 

call move_Screen
call WRITE_FRAME

push 0x60
push 2730h
push line10
call printstr

mov ah,0
int 0x16

pop bp
popa
ret

start:

mov ax, 100
out 0x40, al
mov al, ah
out 0x40, al

;132 X 43 graphics mode
mov ax, 0x0054;
int 0x10;


call print_Background
call restarter

call print_Background
call register_Task
call static_Screen
    xor ax,ax
    mov es,ax
    mov ax, [es:9*4]           ; Save old ISR offset
    mov [cs:oldisr], ax
    mov ax, [es:9*4+2]         ; Save old ISR segment
    mov [cs:oldisr+2], ax
	
	mov ax,[es:8*4]
	mov [cs:old_timer],ax
	
	mov ax,[es:8*4+2]
	mov [cs:old_timer+2],ax

    cli                        ; Disable interrupts
    mov word [es:9*4], kbisr   ; Set new ISR offset
    mov word [es:9*4+2], cs    ; Set new ISR segment
	
	mov word[es:8*4],timer
	mov word[es:8*4+2],cs
    sti 

infinity:

call Game_over_screen
call generate_Pipe
call move_Screen
call Calculate_Score
call Question_screen
call WRITE_FRAME

call collision  
cmp byte[cs:Terminator],1
jnz infinity

call thanks_screen

	xor ax, ax               ; Set ES to 0x0000 (IVT base address)
    mov es, ax

    cli                      ; Disable interrupts
    mov ax, [cs:oldisr]      ; Retrieve old ISR offset 
    mov [es:9*4], ax         ; Restore ISR offset
    mov ax, [cs:oldisr+2]    ; Retrieve old ISR segment
    mov [es:9*4+2], ax       ; Restore ISR segment
	
	mov ax, [cs:old_timer]      ; Retrieve old ISR offset 
    mov [es:8*4], ax         ; Restore ISR offset
    mov ax, [cs:old_timer+2]    ; Retrieve old ISR segment
    mov [es:8*4+2], ax       ; Restore ISR segment

    sti                      ; Re-enable interrupts
	
	
	

mov ax, 0x4c00
int 0x21




; subroutine to register a new thread
; takes the segment, offset, of the thread routine and a parameter
; for the target thread subroutine
register_Task: 	
            push bp
			push ax
			push bx
			push cx
			push si
			
			mov bx,1 ;read next available pcb index
			shl bx,5
			
			mov ax, cs          ; read segment parameter
			mov [pcb+bx+18], ax ; save in pcb space for cs
			mov ax, fazool      ; read offset parameter
			mov [pcb+bx+16], ax ; save in pcb space for ip
			mov [pcb+bx+22], ds ; set stack to our segment
			 
			mov si, [nextpcb]   ; read this pcb index
			mov cl, 9
			shl si, cl          ; multiply by 512...ix2^9 (512)
			add si, 256*2+stack ; end of stack for this thread
			; mov ax, [bp+4]     ; read parameter for subroutine
			sub si, 2           ; decrement thread stack pointer
			mov [pcb+bx+14], si ; save si in pcb space for sp
			
			mov word [pcb+bx+26], 0x0200 ; initialize thread flags
			mov ax, [pcb+28]             ; read next of 0th thread in ax
			mov [pcb+bx+28], ax          ; set as next of new thread
			
			mov ax, [nextpcb] ; read new thread index
			mov [pcb+28], ax  ; set as next of 0th thread
			 
			pop si
			pop cx
			pop bx
			pop ax
			pop bp
			ret 0
			
; timer interrupt service routine
timer:

pusha
cmp byte[cs:is_Pause],0
je timer_End

cmp byte[cs:bird_Direction],'d'
je timer_End

inc word[cs:flap_Count]
cmp word[cs:flap_Count],7000
jne timer_End

mov word[cs:flap_Count],0
mov byte[cs:bird_Direction],'d'

timer_End:
popa
	
            push ds
			push bx
			push cs
			pop ds ; initialize ds to data segment
			
			mov bx, [current] ; read index of current in bx
			shl bx, 5; multiply by 32 for pcb start
			
			cmp word[current],1
			jne next_Timer
			
			mov word [current],0
			jmp next2
			next_Timer:
			mov word[current],1
			
next2:
			
			mov [pcb+bx+0], ax  ; save ax in current pcb
			mov [pcb+bx+4], cx  ; save cx in current pcb
			mov [pcb+bx+6], dx  ; save dx in current pcb
			mov [pcb+bx+8], si  ; save si in current pcb
			mov [pcb+bx+10], di ; save di in current pcb
			mov [pcb+bx+12], bp ; save bp in current pcb
			mov [pcb+bx+24], es ; save es in current pcb
			pop ax              ; read original bx from stack
			mov [pcb+bx+2], ax  ; save bx in current pcb
			pop ax              ; read original ds from stack
			mov [pcb+bx+20], ax ; save ds in current pcb
			pop ax              ; read original ip from stack
			mov [pcb+bx+16], ax ; save ip in current pcb
			pop ax              ; read original cs from stack
			mov [pcb+bx+18], ax ; save cs in current pcb
			pop ax              ; read original flags from stack
			mov [pcb+bx+26], ax ; save cs in current pcb
			mov [pcb+bx+22], ss ; save ss in current pcb
			mov [pcb+bx+14], sp ; save sp in current pcb
			
			mov bx, [current] ; read next pcb of this pcb
			mov cl, 5
			shl bx, cl          ; multiply by 32 for pcb start
			
			mov cx, [pcb+bx+4] ; read cx of new process
			mov dx, [pcb+bx+6] ; read dx of new process
			mov si, [pcb+bx+8] ; read si of new process
			mov di, [pcb+bx+10] ; read diof new process
			mov bp, [pcb+bx+12] ; read bp of new process
			mov es, [pcb+bx+24] ; read es of new process
			mov ss, [pcb+bx+22] ; read ss of new process
			mov sp, [pcb+bx+14] ; read sp of new process
			push word [pcb+bx+26] ; push flags of new process
			push word [pcb+bx+18] ; push cs of new process
			push word [pcb+bx+16] ; push ip of new process
			push word [pcb+bx+20] ; push ds of new process
			
			mov al, 0x20
			out 0x20, al ; send EOI to PIC
			
			mov ax, [pcb+bx+0] ; read ax of new process
			mov bx, [pcb+bx+2] ; read bx of new process
			pop ds ; read ds of new process
			
			iret ; return to new process
			
fazool:
	
 ; Set playback frequency using DSP (optional, for better precision)
    mov dx, 0x22C        ; DSP command port
    mov al, 0x40         ; DSP command to set sample rate
    out dx, al
    mov al, 0x56         ; 22050 Hz (example)
    out dx, al

playback:
	cmp byte[cs:music_bool],1
	jne fazool_end
    ; Send DSP command 0x10 (Direct Mode)
    mov dx, 0x22C
.busy_dsp_command:
    in al, dx
    test al, 10000000b   ; Check if DSP ready
    jnz .busy_dsp_command
    mov al, 0x10         ; Direct Mode command
    out dx, al

    ; Send audio sample
    mov bx, [cs:sound_index]
    mov al, [cs:sound_data + bx]
.busy_dsp_sample:
    in al, dx
    test al, 10000000b   ; Wait until DSP is ready
    jnz .busy_dsp_sample
    mov al, [cs:sound_data + bx]
    out dx, al

    ; Delay loop for playback timing (optional if sample rate is set)
    mov cx, 100          ; Adjust this for timing
.delay_loop:
    nop
    loop .delay_loop

    ; Increment sound index and check end of data
    inc word [cs:sound_index]
    cmp word [cs:sound_index], 43000 ; Update for your data size
	fazool_end:
    jb playback

mov word[cs:sound_index],0
jmp playback
	
	sound_index dw 0

sound_data:
    ; incbin "8BitMelodyModified.wav" ; 51,529 bytes
    ; incbin "fake abdullah bhai.wav" ; 51,529 bytes
    ; incbin "fake abdullah bhai.wav" ; 51,529 bytes
  incbin "game_Sound.wav" ; 51,529 bytes	
			