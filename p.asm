[org 0x100] 
jmp start 

oldisr:                 dd  0 ; space for saving old isr
file:                   dw  0
filename:               db  ''
res:                    dw  0
msg_error2:             db  'Error! Input File is invalid ', 0
msg_score:              db  'Score:', 0
score:                  db  0
msg_intro:              db  'Boulder Dash', 0
msg_exit:               db  'Press Escape to quit', 0
msg_move:               db  'Bombs: ', 0
msg_in:                 db  'Enter Level Number', 0
msg:                    db  ' ', 0
msg_lives:              db  'Lives: ', 0
x:                      dw  3
y:                      dw  0
buffer:                 times 2000 db 0
rockford_loc:           dw  0
target_loc:             dw  0
lives:                  dw  3
bomb_count:             dw  0

;Splash screen variables
msg_splash:             db  'Welcome to Boulder Dash', 0
msg_studio:             db  'Made by: Ali Shahid', 0
msg_project:            db  'Spring 23 Project', 0
msg_enter:              db  'Press Enter to Play!', 0

;End Screen Variables
msg_thank:              db  'Thanks for Playing!', 0
msg_score_end:          db  'Score:', 0

;variables for user input
message:                db 10, 13, '$'
buffer_in:              times 81 db 0
maxlength:              dw 100

;level control
filename_2:             db  'l2.txt$', 0
filename_3:             db  'l3.txt$', 0
buffer_l2:              times 2000 db 0
buffer_l3:              times 2000 db 0
file_2:                 dw  0
file_3:                 dw  0
level_count:            db  1

;--------------------------------------------------------------------Clear Screen

clrscr: 	
push es
push ax
push di
mov ax, 0xb800
mov es, ax
mov di, 0 

nextchar_clrscr: 
mov word [es:di], 0x0720
add di, 2
cmp di, 4000
jne nextchar_clrscr
pop di
pop ax
pop es
ret

;--------------------------------------------------------------------Print String

printstr:
push bp 
mov bp, sp 
push es 
push ax 
push cx 
push si 
push di 
push ds 
pop es  
mov di, [bp + 4] 
mov cx, 0xffff 
xor al, al 
repne scasb 
mov ax, 0xffff  
sub ax, cx 
dec ax 
jz exit 
mov cx, ax 
mov ax, 0xb800 
mov es, ax 
mov al, 80 
mul byte [bp + 8] 
add ax, [bp + 10]
shl ax, 1 
mov di, ax
mov si, [bp + 4] 
mov ah, [bp + 6] 
cld 

nextchar: 
lodsb  
stosw 
loop nextchar 

exit:
pop di 
pop si 
pop cx 
pop ax 
pop es 
pop bp 
ret 8

;--------------------------------------------------------------------Print Numbers

printnum: 
push bp 
mov bp, sp 
push es 
push ax 
push bx 
push cx 
push dx 
push di 
mov ax, 0xb800 
mov es, ax 
mov ax, [bp + 4] 
mov bx, 10  
mov cx, 0 

nextdigit: 
mov dx, 0 
div bx
add dl, 0x30 
push dx 
inc cx 
cmp ax, 0
jnz nextdigit
mov di, 214

nextpos: 
pop dx 
mov dh, 0x07 
mov [es:di], dx 
add di, 2
loop nextpos 
pop di 
pop dx 
pop cx 
pop bx 
pop ax 
pop es 
pop bp 
ret 2

;--------------------------------------------------------------------Reset Cursor

reset_cursor:
mov ah, 0x0001
mov cx, 0x2607 
int 10h
ret

;--------------------------------------------------------------------Print Score at end

printnum_end: 
push bp 
mov bp, sp 
push es 
push ax 
push bx 
push cx 
push dx 
push di 
mov ax, 0xb800 
mov es, ax 
mov ax, [bp + 4] 
mov bx, 10  
mov cx, 0 

nextdigit_end: 
mov dx, 0 
div bx
add dl, 0x30 
push dx 
inc cx 
cmp ax, 0
jnz nextdigit_end
mov di, 2004

nextpos_end: 
pop dx 
mov dh, 0x07 
mov [es:di], dx 
add di, 2
loop nextpos_end 
pop di 
pop dx 
pop cx 
pop bx 
pop ax 
pop es 
pop bp 
ret 2

;--------------------------------------------------------------------Print Lives

printnuml: 
push bp 
mov bp, sp 
push es 
push ax 
push bx 
push cx 
push dx 
push di 
mov ax, 0xb800 
mov es, ax 
mov ax, [bp + 4] 
mov bx, 10  
mov cx, 0 

nextdigitl: 
mov dx, 0 
div bx
add dl, 0x30 
push dx 
inc cx 
cmp ax, 0
jnz nextdigitl
mov di, 254

nextposl: 
pop dx 
mov dh, 0x07 
mov [es:di], dx 
add di, 2
loop nextposl 
pop di 
pop dx 
pop cx 
pop bx 
pop ax 
pop es 
pop bp 
ret 2

;--------------------------------------------------------------------Print Background
;attributes
;0 = Black
;1 = Blue
;2 = Green
;3 = Aqua
;4 = Red
;5 = Purple
;6 = Yellow
;7 = White
;8 = Gray,
;9 = Light Blue
print_background:
push bp
mov bp,sp
push ax
push es
push di
mov ax, 0xb800
mov es, ax
mov di,[bp + 4]
mov word [es:di], 0x00DB
pop di
pop es
pop ax
pop bp
ret 2

;--------------------------------------------------------------------Print Wall
;attributes
;0 = Black
;1 = Blue
;2 = Green
;3 = Aqua
;4 = Red
;5 = Purple
;6 = Yellow
;7 = White
;8 = Gray,
;9 = Light Blue
print_wall:
push bp
mov bp,sp
push ax
push es
push di
mov ax, 0xb800
mov es, ax
mov di, [bp + 4]
mov word [es:di], 0x08DB ;Grey Wall
pop di
pop es
pop ax
pop bp
ret 2

;--------------------------------------------------------------------Print Heart(boulder)
;attributes
;0 = Black
;1 = Blue
;2 = Green
;3 = Aqua
;4 = Red
;5 = Purple
;6 = Yellow
;7 = White
;8 = Gray,
;9 = Light Blue
print_heart:
push bp
mov bp,sp
push ax
push es
push di
mov ax, 0xb800
mov es, ax
mov di, [bp + 4]
mov word [es:di], 0x0404 ; red diamond
pop di
pop es
pop ax
pop bp
ret 2

;--------------------------------------------------------------------Print Diamond
;attributes
;0 = Black
;1 = Blue
;2 = Green
;3 = Aqua
;4 = Red
;5 = Purple
;6 = Yellow
;7 = White
;8 = Gray,
;9 = Light Blue
print_diamond:
push bp
mov bp, sp
push ax
push es
push di
mov ax, 0xb800
mov es, ax
mov di, [bp + 4]
mov word [es:di], 0x0B04 ; light blue diamond
pop di
pop es
pop ax
pop bp
ret 2

;--------------------------------------------------------------------Print Spade(end)
;attributes
;0 = Black
;1 = Blue
;2 = Green
;3 = Aqua
;4 = Red
;5 = Purple
;6 = Yellow
;7 = White
;8 = Gray,
;9 = Light Blue
print_spade:
push bp
mov bp, sp
push ax
push es
push di
mov ax, 0xb800
mov es, ax
mov di, [bp + 4]
mov word [es:di], 0x0602 ; orange smiley
pop di
pop es
pop ax
pop bp
ret 2

;--------------------------------------------------------------------Print Smile(Rockford)
;attributes
;0 = Black
;1 = Blue
;2 = Green
;3 = Aqua
;4 = Red
;5 = Purple
;6 = Yellow
;7 = White
;8 = Gray,
;9 = Light Blue
print_smile:
push bp
mov bp, sp
push ax
push es
push di
mov ax, 0xb800
mov es, ax
mov di, [bp + 4]
mov word [es:di], 0x0202 ;Green smile
pop di
pop es
pop ax
pop bp
ret 2

;--------------------------------------------------------------------Print Intro
;attributes
;0 = Black
;1 = Blue
;2 = Green
;3 = Aqua
;4 = Red
;5 = Purple
;6 = Yellow
;7 = White
;8 = Gray,
;9 = Light Blue
print_intro:
push ax
mov ax,32
push ax
mov ax, 1
push ax
mov ax, 2
push ax
mov ax, msg_intro
push ax
call printstr 

mov ax, 0
push ax
mov ax, 2
push ax
mov ax,9
push ax
mov ax, msg_move
push ax
call printstr

mov ax, 20
push ax
mov ax, 2
push ax
mov ax, 9
push ax
mov ax, msg_score
push ax
call printstr

mov ax, 40
push ax
mov ax, 2
push ax
mov ax, 9
push ax
mov ax, msg_lives
push ax
call printstr

mov ax, 60
push ax
mov ax,2
push ax
mov ax,9
push ax
mov ax,msg_exit
push ax
call printstr

mov ax,0
push ax
mov ax,24
push ax
mov ax,0x67
push ax
mov ax,msg_score
push ax
call printstr
pop ax
ret

;--------------------------------------------------------------------Print Boundries

print_boundries:
push ax

left_boundary:
mov ax, [y]
push ax
cmp word [x], 23
je next1
add word [x], 1
mov ax, [x]
push ax
mov ax, 0x17
push ax
mov ax, msg
push ax
call printstr
jmp left_boundary

next1:
mov word[x],3
mov word[y],-1

top_boundary:
cmp word [y],79
je next2
add word [y],1
mov ax, [y]
push ax
mov ax, [x]
push ax
mov ax, 0x17
push ax
mov ax, msg
push ax
call printstr
jmp top_boundary

next2:
mov word[x],24
mov word[y],-1

bottom_boundary:
cmp word [y],79
je next3
add word [y],1
mov ax, [y]
push ax
mov ax, [x]
push ax
mov ax, 0x17
push ax
mov ax, msg
push ax
call printstr
jmp bottom_boundary

next3:
mov word[x],3
mov word[y],79

right_boundary:
mov ax, [y]
push ax
cmp word [x],23
je next4
add word [x],1
mov ax, [x]
push ax
mov ax, 0x17
push ax
mov ax, msg
push ax
call printstr
jmp right_boundary

next4:
mov ax,0xb800
mov es,ax
mov word [es:340], 0x0Efe
mov ax,0xb800
mov es,ax
mov word [es:344], 0x0Efe
mov ax,0xb800
mov es,ax
mov word [es:348], 0x0Efe
pop ax
ret
 
;--------------------------------------------------------------------Print Error

print_error:
push ax
call clrscr
mov ax, 25
push ax
mov ax, 10
push ax
mov ax, 4
push ax
push msg_error2
call printstr
pop ax
ret

;--------------------------------------------------------------------Delay

delay:     
push cx
mov cx, 0xFFFF		;cx=0xffff
loop1:	
loop loop1			;repeat untill cx != 0
mov cx, 0xFFFF		;cx=0xffff
loop2:	
loop loop2			;repeat untill cx != 0
mov cx, 0xFFFF		;cx=0xffff
loop3:	
loop loop3			;repeat untill cx != 0
pop cx
ret

;--------------------------------------------------------------------End Screen

;attributes
;0 = Black
;1 = Blue
;2 = Green
;3 = Aqua
;4 = Red
;5 = Purple
;6 = Yellow
;7 = White
;8 = Gray,
;9 = Light Blue
end_screen:
pusha
call clrscr 
mov ah, 2
mov dh, 1 
mov dl, 2 
mov bh, 0  
int 10h
mov ah, 05h
mov al, 0
int 10h
mov al, 1 
mov bh, 0
mov bl, 3
mov cx, 19          ;length
mov dl, 30
mov dh, 10
push cs
pop es
mov bp, msg_thank
mov ah, 13h 
int 10h 
mov al, 1 
mov bh, 0
mov bl, 9 
mov cx, 6           ;length
mov dl, 34          ;column
mov dh, 12           ;row
push cs
pop es
mov bp, msg_score_end
mov ah, 13h 
int 10h 
mov al, 1 
mov bh, 0
mov bl, 00111011b 
mov cx, 23
mov dl, 36
mov dh, 14 
push cs
pop es
push word[score]
call printnum_end

;Smileys on four corners
mov ax, 0xb800
mov es, ax
mov word [es:0], 0x0202
mov word [es:158], 0x0202
mov word [es:3838], 0x0202
mov word [es:3680], 0x0202

mov cx, 100
loop_delay_end:
call delay
call delay
call delay
loop loop_delay_end

call clrscr
popa
ret

;--------------------------------------------------------------------Splash Screen
;attributes
;0 = Black
;1 = Blue
;2 = Green
;3 = Aqua
;4 = Red
;5 = Purple
;6 = Yellow
;7 = White
;8 = Gray,
;9 = Light Blue
splash:
push ax
push es
push bx

mov ax, 28
push ax
mov ax, 8
push ax
mov ax, 2
push ax
mov ax, msg_splash
push ax
call printstr 

mov ax, 30
push ax
mov ax, 10
push ax
mov ax, 3
push ax
mov ax, msg_studio
push ax
call printstr 

mov ax, 31
push ax
mov ax, 12
push ax
mov ax, 8
push ax
mov ax, msg_project
push ax
call printstr 

mov ax, 30
push ax
mov ax, 14
push ax
mov ax, 4
push ax
mov ax, msg_enter
push ax
call printstr 

;Smileys on four corners
mov ax, 0xb800
mov es, ax
mov word [es:0], 0x0202
mov word [es:158], 0x0202
mov word [es:3838], 0x0202
mov word [es:3680], 0x0202

repeat_splash:
mov ah, 0    ; wait keystroke service
int 16h      ; returns scancode in AH
mov bl, ah   ; put scancode in BX
cmp bl,28
jne repeat_splash

pop bx
pop es
pop ax
ret
;--------------------------------------------------------------------------------------------------------------------------------
;--------------------------------------------------------------------Count Size of file
 
count:          ;this only counts those characters that are required inside the game
push bp
mov bp,sp
push ax
push bx
push cx
push dx
mov cx,0
mov ax,[bp+4]
cmp al,'x'
jne count_w
add cx,1

count_w:
cmp al,'W'
jne count_r
add cx,1

count_r:
cmp al,'R'
jne count_d
add cx,1

count_d:
cmp al,'D'
jne count_t
add cx,1

count_t:
cmp al,'T'
jne count_b
add cx,1

count_b:
cmp al,'B'
jne count_end
add cx,1

count_end:
mov word [bp+6],cx
pop dx
pop cx
pop bx
pop ax
;mov sp,bp
pop bp
ret 2

;--------------------------------------------------------------------Audio PEEPEE Diamond

pee_pee_diamond:
push ax
push cx

mov al, 182
out 43h, al
mov ax, 2153
out 42h, al
mov al, ah
out 42h, al
in  al, 61h
or al, 00000011b
out 61h, al
mov cx, 1

delay_loop_diamond:
call delay
loop delay_loop_diamond

and al, 11111100b
out 61h, al
pop cx
pop ax
ret
;--------------------------------------------------------------------Audio PEEPEE Boulder
pee_pee_boulder:
push ax
push cx
mov al, 182
out 43h, al
mov ax, 2153
out 42h, al
mov al, ah
out 42h, al
in  al, 61h
or al, 00000011b
out 61h, al
mov cx, 5

delay_loop_boulder:
call delay
call delay
call delay
loop delay_loop_boulder

and al, 11111100b
out 61h, al
pop cx
pop ax
ret

;--------------------------------------------------------------------Check kill

check_boulder:  ;bx(6)     di(4)      return(2)      bp
push bp
mov bp,sp
push cx
push bx
mov bx, [bp + 6]                           ; initial location of rockford
mov di, [bp + 4]                           ; current location of rockford
cmp word [es:bx + di - 160], 0x0404        ; checkes boulder above
jne printscores1

dec word[cs:lives]                          ; lives--
dec word[score]                             ; score--
mov word [es:bx + di - 160], 0x00DB
mov word [es:bx + di], 0x0404
call pee_pee_boulder

mov cx, 5

delay_loop_kill:                            ; creates a delay so that the boulder is visible moving down
call delay
call delay
call delay
loop delay_loop_kill

mov word [es:bx + di], 0x00DB
mov word [es:bx + di - 160], 0x0404
mov word [es:bx + di], 0x0202

printscores1:
push word [cs:lives]
call printnuml
push word [score]
call printnum
pop bx
pop cx
pop bp
ret 4

;--------------------------------------------------------------------Check at target?

check_target:   ;bx(6)     di(4)      return(2)      bp
push bp
mov bp, sp
push bx

mov bx, [bp + 6]                            ; initial location of rockford
mov di, [bp + 4]                            ; current location of rockford

cmp word [es:bx + di], 0x0602               ; if at target
jne check_target_end

call clrscr

is1:
cmp byte [level_count], 1                   ; checks if level count is 1 i.e user was on level 1.
jne is2
add byte [level_count], 1                   ; if true then it increments the level count to 2 and calls run_2 with level 2 file.
jmp run_2

is2:
cmp byte [level_count], 2                   ; check if level count is 2 i.e user was on level 2. 
jne check_game_end
add byte [level_count], 1                   ; if true then it increments the level count to 3 and calls run_3 with level 3 file.
jmp run_3

run_2:
push filename_2
push buffer_l2
push word [file_2]
call run
jmp check_target_end

run_3:
push filename_3
push buffer_l3
push word [file_3]
call run

check_game_end:
cmp byte [level_count], 3
jne check_target_end
call clrscr

check_target_end:
pop bx
pop bp
ret 4

;--------------------------------------------------------------------Check Bombs

check_bombs:    ; this function is called when left shift is pressed. It checks all 4 directions of rockford and if there is a
push bp         ; wall it blows it up :-)
mov bp,sp
push ax
push bx

mov bx, [cs:rockford_loc]
mov di, [bp + 4]

cmp word [es:bx + di + 2], 0x08DB   ; Comparing right direction if there is a wall
jne left_wall
call pee_pee_boulder
mov word[es:bx+di+2], 0x00DB        ; Move to the location dirt particle

left_wall:
cmp word [es:bx+di-2], 0x08DB
jne up_wall
call pee_pee_boulder
mov word[es:bx+di-2], 0x00DB

up_wall:
cmp word [es:bx+di-160], 0x08DB
jne down_wall
call pee_pee_boulder
mov word[es:bx+di-160], 0x00DB

down_wall:
cmp word [es:bx+di+160], 0x08DB
jne end_call
call pee_pee_boulder
mov word[es:bx+di+160], 0x00DB

end_call:
pop bx
pop ax
pop bp
ret 2

;------------------------------------------------------------------------------------------------------------KBISR

kbisr: 
push ax 
push es 
push bx
mov bx, [cs:rockford_loc]
mov ax, 0xb800 
mov es, ax          ; point es to video memory 
in al, 0x60         ; read a char from keyboard port 

nextcmp_esc:;--------------------------------------------------------Esc Key
cmp al, 0x01                    ; is the key es 
jne near nextcmp_leftshift      ; no, try next comparison 

call clrscr
push word [score]
call printnum_end
call end_screen
jmp nomatch                     ; leave interrupt routine

nextcmp_leftshift:;--------------------------------------------------Left Shift Key
cmp al,0x2a
jne nextcmp_up
cmp word[cs:bomb_count], 3      ; if all three bombs have been used
je near nomatch

next_shift:
cmp word[cs:bomb_count], 0
jg next_shift1
mov ax, 0xb800
mov es, ax
mov word[es:188], 0x00DB        ; makes boundary disappear 
push di
call check_bombs                
inc word[cs:bomb_count]
jmp nomatch

next_shift1:
cmp word[cs:bomb_count], 1
jg next_shift2
mov ax,0xb800
mov es,ax
mov word[es:184],0x00DB
push di
call check_bombs
inc word[cs:bomb_count]
jmp nomatch

next_shift2:
cmp word[cs:bomb_count],2
jg near nomatch
mov ax,0xb800
mov es,ax
mov word[es:180],0x00DB
push di
call check_bombs
inc word[cs:bomb_count]
jmp nomatch

nextcmp_up:;---------------------------------------------------------Up Key
cmp al, 0x48                    ; check if up arrow key
jne nextcmp_down  
mov bx, [cs:rockford_loc]  
cmp word [cs:lives], 0          ; if lives are zero then leave the game
jne up_continue
call clrscr
jmp nomatch

up_continue:
cmp word [es:bx + di - 160], 0x08DB; if wall
je nextcmp_down
cmp word [es:bx + di - 160], 0x0404; if boulder
je nextcmp_down
cmp word [es:bx + di - 160], 0x1720; if game boundary
je nextcmp_down
cmp word [es:bx + di - 160], 0x0B04; if diamond
jne no_addup

call pee_pee_diamond                ; this part will run in case rockford gets a diamond
add byte [score], 2                 ; increase score

no_addup:
mov word [es:bx + di], 0x0002
sub di, 160
push bx
push di
call check_target
mov word [es:bx + di], 0x0202
push bx
push di
call check_boulder   
jmp nomatch

nextcmp_down:;-------------------------------------------------------Down Key
cmp al, 0x50
jne nextcmp_left
mov bx, [cs:rockford_loc]
cmp word [cs:lives], 0
jne down_continue
call clrscr
jmp nomatch

down_continue:
cmp word [es:bx + di + 160], 0x08DB; if wall
je nextcmp_left
cmp word [es:bx + di + 160], 0x0404; if boulder
je nextcmp_left
cmp word [es:bx + di + 160], 0x1720; if game boundary
je nextcmp_left
cmp word [es:bx + di + 160], 0x0B04; if diamond
jne no_adddown

call pee_pee_diamond
add byte [score], 2

no_adddown:
mov word [es:bx + di], 0x0002
add di, 160
push bx
push di
call check_target 
mov word [es:bx + di], 0x0202
push bx
push di
call check_boulder
jmp nomatch

nextcmp_left:;-------------------------------------------------------Left Key
cmp al, 0x4B
jne nextcmp_right
mov bx, [cs:rockford_loc]
cmp word [cs:lives], 0
jne left_continue
call clrscr
jmp nomatch

left_continue:
cmp word [es:bx + di - 2], 0x08DB; if wall
je nextcmp_right
cmp word [es:bx + di - 2], 0x0404; if boulder
je nextcmp_right
cmp word [es:bx + di - 2], 0x1720; if game boundary
je nextcmp_right
cmp word [es:bx + di - 2], 0x0B04; if diamond
jne noadd_left

call pee_pee_diamond
add byte [score], 2

noadd_left:
mov word [es:bx + di], 0x0002
sub di, 2
push bx
push di
call check_target
mov word [es:bx + di], 0x0202
push bx
push di
call check_boulder
jmp nomatch

nextcmp_right:;------------------------------------------------------Right Key
cmp al, 0x4D
jne nomatch
mov bx, [cs:rockford_loc]
cmp word [cs:lives], 0
jne right_continue
call clrscr
jmp nomatch

right_continue:
cmp word [es:bx + di + 2], 0x08DB; if wall
je nomatch
cmp word [es:bx + di + 2], 0x0404; if boulder
je nomatch
cmp word [es:bx + di + 2], 0x1720; if game boundary
je nomatch
cmp word [es:bx + di + 2], 0x0B04; if diamond
jne noadd_right

call pee_pee_diamond
add byte [score], 2

noadd_right:
mov word [es:bx + di], 0x0002
add di, 2
push bx
push di
call check_target 
mov word [es:bx + di], 0x0202
push bx
push di
call check_boulder

nomatch: 
pop bx
pop es 
pop ax 
jmp far [cs:oldisr] 

;------------------------------------------------------------------------------------------------------------Run

run:            ;filename8       buffer6      file4        return2      bp
push bp
mov bp, sp
push ax
push cx
push si
push di
push es
push ds

call clrscr
                    ; Open the file
mov ah, 3dh         ; DOS function 3Dh: open file
mov al, 0           ; read-only mode
mov dx, [bp + 8]    ; filename
int 0x21            ; call DOS     
mov [bp + 4], ax    ; save file handle
                    ; Read the file
mov ah, 3fh         ; DOS function 3Fh: read file      
mov bx, [bp + 4]    ; file handle
mov cx, 1600        ; number of bytes to read
mov dx, [bp + 6]    ; buffer
mov si, [bp + 6]
int 0x21            ; call DOS

mov ax,0
mov bx,0
mov cx,0
mov dx,0

;--------------------------------------------------------------------Check character count

char_count:         ;this checks if the file has the correct size
mov al, [si + bx]
sub sp, 2
push ax
call count	        ; only counts required
pop cx
add dx, cx          ; adding count to dx. dx is running total
add bx, 1
cmp bx, 1558        ; comparing bx with the number of times this char_count will iterate
jne char_count
mov word [res], dx
cmp dx, 0x5f0       ; cmp with 1520
je check_print      ; if size is ok then procede to printing the map
call print_error
jmp l1

;--------------------------------------------------------------------Check Print

check_print:
mov bx, 0
mov ax, 0
mov di, 642

start_print:        ; this compares the characters in the file and prints accordingly
mov al, [si + bx]   ; moving a character from file to al
cmp al, 'x'
jne smile
push di
call print_background
add di,2
add bx,1
cmp bx, 1600
jne start_print

smile:
cmp al, 'R'
jne heart
mov word [rockford_loc], di ; saving starting lcoation of rockford
sub word [rockford_loc], 160
push di
call print_smile
add di,2
add bx,1
cmp bx,1600
jne start_print

heart:
cmp al, 'B'
jne diamond
push di
call print_heart
add di,2
add bx,1
cmp bx,1600
jne start_print

diamond:
cmp al, 'D'
jne spade
push di
call print_diamond
add di,2
add bx,1
cmp bx,1600
jne start_print

spade:
cmp al, 'T'
jne wall
push di
call print_spade
mov word [target_loc], di
add di,2
add bx,1
cmp bx,1600
jne start_print

wall:
cmp al,'W'
jne start_print_end
push di
call print_wall

start_print_end:
add di,2
add bx,1
cmp bx,1600
jne start_print

run_end:
call print_intro    ; this is printing info such as score etc
call print_boundries; this is priniting the blue colored boundries 
call reset_cursor
                    ; Close the file		
mov ah, 3eh         ; DOS function 3Eh: close file
;mov bx, [file]      ; file handle
mov bx, [bp + 4]
int 21h             ; call DOS

pop ds
pop es
pop di
pop si
pop cx
pop ax
pop bp
ret 6

;------------------------------------------------------------------------------------------------------------Start

start: 

xor ax, ax 
mov es, ax                  ; point es to IVT base 
mov ax, [es:9*4] 
mov [oldisr], ax            ; save offset of old routine 
mov ax, [es:9*4+2] 
mov [oldisr+2], ax          ; save segment of old routine 
cli                         ; disable interrupts 
mov word [es:9*4], kbisr    ; store offset at n*4 
mov [es:9*4+2], cs          ; store segment at n*4+2 
sti                         ; enable interrupts

call clrscr
call splash                 ; rendering the initail splash screen prompting user to press enter to play
call clrscr

push 30
push 11
push 3
push msg_in                 ; rendering message to user to enter the level number
call printstr

;--------------------------------------------------------------------User Input 

user_in:
mov cx, [maxlength]							; load maximum length in cx
mov si, buffer_in						    ; point si to start of buffer_in
mov di, 0

in_nexrchar:
mov ah, 1									; service 1 – read character
int 0x21									; dos services
cmp al, 13									; is enter pressed
je user_in_exit								; yes, leave input
mov [si], al								; no, save this character
inc si										; increment buffer_in pointer
loop in_nexrchar							; repeat for next input char

user_in_exit:
mov byte [si], '$'							; append $ to user input
mov dx, message								; greetings message
mov ah, 9									; service 9 – write string
int 0x21									; dos services
mov dx, buffer_in							; user input buffer_in
mov ah, 9									; service 9 – write string
int 0x21	

mov si, filename
mov di, buffer_in

validate_file:                              ; takes user input and moves into filename
cmp byte [di], '$'
je validate_end
mov ax, [di]
mov [si], ax
inc si
inc di
jmp validate_file	

validate_end:
inc si
mov byte[si], 0

;--------------------------------------------------------------------Calling run to make the map
push filename
push buffer
push word [file]
call run                

l1: 
mov ah, 0                   ; service 0 – get keystroke 
int 0x16                    ; call BIOS keyboard service 
cmp al, 0x01                ; is the Esc key pressed  
jne l1                      ; if no, check for next key 
mov ax, [oldisr]            ; read old offsetin ax 
mov bx, [oldisr + 2]        ; read old segment in bx 
cli                         ; disable interrupts 
mov [es:9*4], ax            ; restore old offset from ax 
mov [es:9*4 + 2], bx        ; restore old segment from bx 
sti                         ; enable interrupts 

end_program:
mov ax, 0x4c00              ; terminate program 
int 0x21 