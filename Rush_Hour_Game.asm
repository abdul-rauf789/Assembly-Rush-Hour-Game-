INCLUDE Irvine32.inc
includelib kernel32.lib
Beep PROTO :DWORD, :DWORD
.data

    drawBoard BYTE 1596 dup('0')
    height DWORD 28
    wid    DWORD 30
    startX BYTE 30   ; STARTING-X POINT
    startY BYTE 2    ; STARTING-Y POINT
    numBuildings DWORD 30
    numPersons   DWORD 05
    numTrees     DWORD 05
    numRandomCars DWORD 3 
    time         DWORD  0
    carColor     DWORD  ?
    score        SDWORD 0
    timeRem      DWORD  0
    startTime    DWORD  ?
    paused BYTE 0
    pickUp BYTE 0
    xPos  BYTE ?
    yPos  BYTE ?
    axPos BYTE ?
    ayPos BYTE ?
    rxPos BYTE ?
    ryPos BYTE ?
    inputChar BYTE ?
    car_color_num BYTE ?         ;0 for y_color,1 for r_color
    bxPos BYTE ?
    byPos BYTE ?
    pxPos BYTE ?
    pyPos BYTE ?
    txPos BYTE ?
    tyPos BYTE ?
    player_name BYTE 31 DUP(?)
    name_prompt BYTE "Player Name: ",0
    mode_prompt BYTE "Player Mode: ",0
    modeCareer  BYTE "Career Mode", 0
    modeTime    BYTE "Time Mode", 0
    modeEndless BYTE "Endless Mode", 0
    maxNameSize DWORD SIZEOF player_name - 1 
    namePrompt  BYTE "Enter your name: ", 0
    timePrompt  BYTE "Time: 00",0
    scorePrompt BYTE "SCORE: ", 0
    menuTitle   BYTE "-------------- MAIN MENU -------------", 0
    menuOption1 BYTE "1. New Game", 0
    menuOption2 BYTE "2. Continue", 0
    menuOption3 BYTE "3. Change Mode", 0
    menuOption4 BYTE "4. Change Difficulty Level", 0
    menuOption5 BYTE "5. View Leader Board", 0
    menuOption6 BYTE "6. Read Instructions", 0
    menuOption7 BYTE "7. Exit Game", 0
    menuPrompt  BYTE "Enter your choice (1-6): ", 0
    menuInput   BYTE ?
    gameMode    BYTE 'C' ; C=Career, T=Time, E=Endless
    modeTitle   BYTE "-------- SELECT GAME MODE --------", 0
    modeOptionC BYTE "1. Career Mode", 0
    modeOptionT BYTE "2. Time Mode", 0
    modeOptionE BYTE "3. Endless Mode", 0
    modePrompt  BYTE "Enter choice (1-3) or (M) to return to Main Menu: ", 0
    modeInput   BYTE ?
    pauseTitle  BYTE "-------- GAME PAUSED --------",0
    pauseOpt1   BYTE "1. Resume Game", 0
    pauseOpt2   BYTE "2. Instructions", 0
    pauseOpt3   BYTE "3. Quit to Main Menu", 0
    pauseOpt4   BYTE "4. Exit Application", 0
    pausePrompt BYTE "Enter your choice (1-4): ", 0
    diffTitle   BYTE "-------- SELECT DIFFICULTY LEVEL --------", 0
    diffOption1 BYTE "1. Easy", 0
    diffOption2 BYTE "2. Normal", 0
    diffOption3 BYTE "3. Hard", 0
    diffOption4 BYTE "4. Extreme", 0
    diffInput   BYTE ?
    diffPrompt  BYTE "Enter choice (1-4) or (M) to return to Main Menu: ", 0
    instTitle   BYTE "---------------- GAME INSTRUCTIONS ----------------", 0
    instObjective BYTE "Objective:", 0
    instObjectiveMsg BYTE "In Career Mode, you must drive your car ('C') to pick up all five persons ('P') scattered across the city block. When all Persons are Picked Up, the mission is complete.", 0
    instCtrl    BYTE "Ctrls:", 0
    instCtrlW   BYTE "W / Up Arrow: Move Forward (Up)", 0
    instCtrlS   BYTE "S / Down Arrow: Move Backward (Down)", 0
    instCtrlA   BYTE "A / Left Arrow: Turn Left", 0
    instCtrlD   BYTE "D / Right Arrow: Turn Right", 0
    instCtrlSpace BYTE "SPACEBAR: Pick up a Person (when on the same tile)", 0
    instCtrlE   BYTE "E: Exit Game (any time)", 0
    instHzds    BYTE "Hazards:", 0
    instHzdsMsg BYTE "Avoid driving into buildings ('B') or walls ('|'). Hitting a hazard will result in Score Deduction.", 0
    instExit       BYTE "Press any key to return to the Main Menu...", 0
    starterTitle   BYTE "-------- SELECT CAR COLOR --------", 0
    starterOption1 BYTE "1. Yellow ", 0
    starterOption2 BYTE "2. Red", 0
    starterOption3 BYTE "3. Random", 0
    starterInput   BYTE ?
    starterPrompt  BYTE "Enter choice (1-3) or (M) to return to Main Menu: ", 0
    gameOverMsg BYTE "GAME OVER! You hit a building.",0


.code

;/////////////  MAIN PROC ////////////;

main PROC

    call Randomize   

    call menuProc
    call GetMSeconds
    mov timeRem, eax

    mov dh,startY
    mov dl,startX
    call boardPrint

    call DisplayNameProc

    mov dl, 90
    mov dh, 10
    call Gotoxy
    mov edx, OFFSET timePrompt
    call WriteString

    mov cl,startX
    mov ch,startY
    inc cl
    inc ch
    mov xPos,cl
    mov yPos,ch
   
    mov ecx,numBuildings
drawB:
    call drawBuilding
    loop drawB

    mov ecx,numPersons
drawP:
    call placePerson
    loop drawP

    mov ecx,numTrees
drawT:
    call placeTree
    loop drawT

    mov ecx,numRandomCars
drawA:
    call placeRandomCars
    loop drawA

    call DrawCar
    call scorePrint
    call UpdateTimer
gameLoop:
    call UpdateTimer
    call moveCar
    jmp gameLoop
    exit
main ENDP

;/////////////  MENU PROC ////////////;

menuProc Proc
    call CLRSCR
    mov  eax, green + (black * 16)
    call SetTextColor

    mov dl,35
    mov dh,2
    call GOTOXY
    
    mov  edx, OFFSET menuTitle
    call WriteString

    mov dl,38
    mov dh,5
    call GOTOXY
    mov  edx, OFFSET menuOption1
    call WriteString
    
    mov dl,38
    mov dh,6
    call GOTOXY
    mov  edx, OFFSET menuOption2
    call WriteString

    mov dl,38
    mov dh,7
    call GOTOXY
    mov  edx, OFFSET menuOption3
    call WriteString

    mov dl,38
    mov dh,8
    call GOTOXY
    mov  edx, OFFSET menuOption4
    call WriteString

    mov dl,38
    mov dh,9
    call GOTOXY
    mov  edx, OFFSET menuOption5
    call WriteString
    
    mov dl,38
    mov dh,10
    call GOTOXY
    mov  edx, OFFSET menuOption6
    call WriteString

    mov dl,38
    mov dh,11
    call GOTOXY
    mov  edx, OFFSET menuOption7
    call WriteString
    
    mov dl,38
    mov dh,14
    call GOTOXY
    mov  edx, OFFSET menuPrompt
    call WriteString
    
    call ReadChar
    mov menuInput, al

    cmp al, '1'
    je game_starter
    
    cmp al,'3'
    je modeProc

    cmp al,'4'
    je difficultyProc

    cmp al,'6'
    je instuctionProc

    cmp al, '7'
    je quitGame
    
    jmp menuProc

    
    ret

menuProc ENDP

;/////////////  NAME-MODE DISPLAY PROC ////////////;

DisplayNameProc PROC
    pushad
    
    mov dl, 2  
    mov dh, 10  
    call Gotoxy 

    mov edx,OFFSET name_prompt  
    call WriteString

    mov edx, OFFSET player_name 
    call WriteString

    mov dl,2
    mov dh,14
    call GOTOXY

    mov edx, OFFSET mode_prompt  
    call WriteString

    mov al, gameMode
    
    cmp al, 'C'
    je displayCareer
    
    cmp al, 'T'
    je displayTime

    cmp al,'E'
    je displayEndless

displayTime:
    mov edx, OFFSET modeTime
    jmp printMode
displayEndless:
    mov edx, Offset modeEndless
    jmp printMode
displayCareer:
    mov edx,offset modeCareer
    jmp printMode

printMode:
    call WriteString
    popad
    ret
DisplayNameProc ENDP

scorePrint Proc
    push eax
    push edx

    mov  eax, lightCyan  + (black * 16)
    call SetTextColor
    mov dl,90
    mov dh,10
    call GOTOXY

    mov  edx, OFFSET scorePrompt
    call WriteString

    mov eax,score
    call WriteInt

    pop edx
    pop eax
    ret
scorePrint ENDP

;/////////////  TIMER PROC ////////////;

UpdateTimer PROC
    push eax
    push edx
    
    call GetMSeconds
    sub eax, timeRem
    cmp eax, 1000
    jl skipUpdate
    
    inc time            ; One second passed - update time
    
    mov dl, 90
    mov dh, 14
    call Gotoxy
    
    mov eax, time
    mov bl, 10
    
    ; Convert to ASCII digits
    xor edx, edx
    div bl          ; AL = tens, AH = ones
    
    add al, '0'
    mov timePrompt+6, al    ; Tens place
    
    add ah, '0'
    mov timePrompt+7, ah    ; Ones place

    mov  eax, white + (black * 16)
    call SetTextColor

    ; Display it
    mov edx, OFFSET timePrompt
    call WriteString
    
    ; Reset timer
    call GetMSeconds
    mov timeRem, eax
    
skipUpdate:
    pop edx
    pop eax
    ret
UpdateTimer ENDP

;/////////////  GAME STARTER ////////////;

game_starter Proc
    call CLRSCR
    mov  eax, yellow + (black * 16)
    call SetTextColor
    
    mov dh, 2
    mov dl, 38
    call GOTOXY
    mov edx, OFFSET starterTitle
    call WriteString
    
    mov dh, 7
    mov dl, 38
    call GOTOXY
    mov edx, OFFSET starterOption1
    call WriteString
    
    mov dh, 8
    mov dl, 38
    call GOTOXY
    mov edx, OFFSET starterOption2
    call WriteString
    
    mov dh, 9
    mov dl, 38
    call GOTOXY
    mov edx, OFFSET starterOption3
    call WriteString

    mov dh, 13
    mov dl, 38
    call GOTOXY
    mov edx, OFFSET starterPrompt
    call WriteString

    call ReadChar
    mov starterInput, al
    
    cmp al, '1'
    je y_color
    
    cmp al, '2'
    je r_color
    
    cmp al, '3'
    je rand_color

    cmp al,'m'
    je menuProc

    cmp al,'M'
    je menuProc

    jmp game_starter
    
 y_color:
    mov eax,yellow + (black*16)
    mov carColor,eax
    mov car_color_num, 0
    jmp starter_end

r_color:
    mov eax,red + (black*16)
    mov carColor,eax
    mov car_color_num, 1
    jmp starter_end

rand_color:
    mov eax, 2
    call RandomRange
    cmp eax,0
    je y_color
    jne r_color

starter_end:
    call name_page
    ret
game_starter ENDP

;/////////////  NAME PAGE PROC ////////////;

name_page Proc
    call CLRSCR
    mov  eax, yellow + (black * 16)
    call SetTextColor
    
    mov dh, 10
    mov dl, 30
    call GOTOXY
    mov edx, OFFSET namePrompt  
    call WriteString
    
    mov edx, OFFSET player_name  
    mov ecx, maxNameSize        
    call ReadString
    ret
name_page ENDP

;/////////////  MODE PROC ////////////;

modeProc Proc
    call CLRSCR
    mov  eax, yellow + (black * 16)
    call SetTextColor
    
    mov dh, 2
    mov dl, 38
    call GOTOXY
    mov edx, OFFSET modeTitle
    call WriteString
    
    mov dh, 7
    mov dl, 38
    call GOTOXY
    mov edx, OFFSET modeOptionC
    call WriteString
    
    mov dh, 8
    mov dl, 38
    call GOTOXY
    mov edx, OFFSET modeOptionT
    call WriteString
    
    mov dh, 9
    mov dl, 38
    call GOTOXY
    mov edx, OFFSET modeOptionE
    call WriteString
    
    mov dh, 13
    mov dl, 38
    call GOTOXY
    mov edx, OFFSET modePrompt
    call WriteString
    
    call ReadChar
    mov modeInput, al
    
    cmp al, '1'
    je setCareerMode
    
    cmp al, '2'
    je setTimeMode
    
    cmp al, '3'
    je setEndlessMode
    
    cmp al, 'm'
    je returnToMenu
    
    cmp al, 'M'
    je returnToMenu
    
    jmp modeProc

setCareerMode:
    mov gameMode, 'C'
    jmp returnToMenu

setTimeMode:
    mov gameMode, 'T'
    jmp returnToMenu

setEndlessMode:
    mov gameMode, 'E'
    jmp returnToMenu

returnToMenu:
    call menuProc
    ret
modeProc ENDP

;/////////////  GAME INSTRUCTIONS ////////////;

instuctionProc Proc
    call CLRSCR
    mov  eax, brown + (black * 16) 
    call SetTextColor
    
    mov dl,34
    mov dh,2
    call GOTOXY
    mov edx, OFFSET instTitle
    call WriteString
    
    call CRLF
    mov  eax, yellow + (black * 16)
    call SetTextColor
    mov edx, OFFSET instObjective
    call WriteString
    call CRLF
    mov  eax, white + (black * 16)
    call SetTextColor
    mov edx, OFFSET instObjectiveMsg
    call WriteString
    
    call CRLF
    call CRLF
    mov  eax, yellow + (black * 16)
    call SetTextColor
    mov edx, OFFSET instCtrl
    call WriteString
    
    mov  eax, white + (black * 16)
    call SetTextColor
    
    call CRLF
    mov edx, OFFSET instCtrlW
    call WriteString
    
    call CRLF
    mov edx, OFFSET instCtrlS
    call WriteString
    
    call CRLF
    mov edx, OFFSET instCtrlA
    call WriteString

    call CRLF
    mov edx, OFFSET instCtrlD
    call WriteString
    
    call CRLF
    mov edx, OFFSET instCtrlSpace
    call WriteString

    call CRLF
    mov edx, OFFSET instCtrlE
    call WriteString
    
    call CRLF
    call CRLF
    mov  eax, red + (black * 16)
    call SetTextColor
    mov edx, OFFSET instHzds
    call WriteString
    
    call CRLF
    mov  eax, white + (black * 16)
    call SetTextColor
    mov edx, OFFSET instHzdsMsg
    call WriteString

    call CRLF
    mov edx, OFFSET instExit
    call WriteString
    
    call ReadChar 
    cmp paused,1
    je return_pause

    
    call menuProc
    ret
return_pause:
    mov paused,0
    call pause_game
    ret

instuctionProc ENDP

;/////////////  DIFFICULTY LEVEL PROC ////////////;

difficultyProc Proc
    call CLRSCR
    mov  eax, yellow + (black * 16)
    call SetTextColor
    
    mov dh, 2
    mov dl, 38
    call GOTOXY
    mov edx, OFFSET diffTitle
    call WriteString
    
    mov dh, 7
    mov dl, 38
    call GOTOXY
    mov edx, OFFSET diffOption1
    call WriteString
    
    mov dh, 8
    mov dl, 38
    call GOTOXY
    mov edx, OFFSET diffOption2
    call WriteString
    
    mov dh, 9
    mov dl, 38
    call GOTOXY
    mov edx, OFFSET diffOption3
    call WriteString

    mov dh, 10
    mov dl, 38
    call GOTOXY
    mov edx, OFFSET diffOption4
    call WriteString

    mov dh, 13
    mov dl, 38
    call GOTOXY
    mov edx, OFFSET diffPrompt
    call WriteString

    call ReadChar
    mov modeInput, al
    
    cmp al, '1'
    je easyMode
    
    cmp al, '2'
    je normalMode
    
    cmp al, '3'
    je hardMode
    
    cmp al, '4'
    je extremeMode
    
    cmp al, 'm'
    je returnToMenu

    cmp al, 'M'
    je returnToMenu
    
    jmp difficultyProc

easyMode:
    mov numBuildings,50
    jmp returnToMenu

normalMode:
    mov numBuildings,100
    jmp returnToMenu

hardMode:
    mov numBuildings,200
    jmp returnToMenu

extremeMode:
    mov numBuildings,300
    jmp returnToMenu
    
returnToMenu:
    call game_starter
    ret

difficultyProc ENDP

;/////////////  PRINT BOARD PROC ////////////;

boardPrint Proc
    mov  eax,brown + (black*16)
    call SetTextColor
    call CLRSCR
   
    mov dh,startY
    mov dl,startX
    mov ebx,wid
    add ebx,ebx
    sub ebx,3       
   
    ; Print Top Line
    mov ecx, ebx
printTopLine:
    call GOTOXY
    mov al, '_'
    call WriteChar
    inc dl
    loop printTopLine
   
    call Crlf
    inc dh
    mov dl,startX
   
    ; Print Middle Lines
    mov ecx, height
    dec ecx            
printMiddle:
    call GOTOXY
    mov al, '|'
    call WriteChar
    inc dl
   
    mov ebx, wid
    sub ebx, 2          
printSpaces:
    call GOTOXY
    mov al, ' '
    call WriteChar
    inc dl

    push eax                    
    push ebx
    push ecx

    movzx eax, dl
    movzx ecx,startX
    sub eax, ecx     
    movzx ebx, dh
    movzx ecx,startY
    sub ebx, ecx       
    imul ebx, 57       
    add eax, ebx       
   
    mov esi, OFFSET drawBoard
    mov BYTE PTR [esi+eax], '|'  ; Save barrier to memory
   
    pop ecx
    pop ebx
    pop eax

    call GOTOXY
    mov al, '|'
    call WriteChar
    inc dl
    dec ebx
    jnz printSpaces    
 
    call Crlf
    inc dh
    mov dl,startX
    loop printMiddle
   
    mov ebx,wid
    add ebx,ebx
    sub ebx,3
   
    ; Print Bottom Line
    mov ecx, ebx
printBottomLine:
    call GOTOXY
    mov al, '-'
    call WriteChar
    inc dl
    loop printBottomLine
    ret
boardPrint ENDP

;/////////////  DRAW BUILDING ////////////;

drawBuilding Proc
tryAgain:
    mov eax, 29 - 3 + 1    
    call RandomRange        
    add al, 3              
    mov byPos, al

    mov eax, 85 - 32 + 1    
    call RandomRange        
    add al, 32              
    mov bxPos, al

    mov dl, bxPos
    mov dh, byPos
   
    call checkCollision   
    cmp ah, 1
    je tryAgain         

    push eax
    push ebx
    push ecx
   
    movzx eax, dl
    movzx ecx,startX
    sub eax, ecx      
    movzx ebx, dh
    movzx ecx,startY
    sub ebx, ecx      
    imul ebx, 57          
    add eax, ebx  
   
    mov esi, OFFSET drawBoard
    mov BYTE PTR [esi+eax], 'B'  
   
    pop ecx
    pop ebx
    pop eax

    ; 5. Draw 'B' on Screen
    mov dl, bxPos
    mov dh, byPos
    call Gotoxy
    mov eax, white + (red * 16)    
    call SetTextColor
    mov al, 'B'
    call WriteChar
   
    ret
drawBuilding ENDP

;/////////////  PERSONS RANDOM GENERATION ////////////;

placePerson Proc
    push eax
    push ecx
    push edi
    push esi

    mov esi,offset drawBoard
tryAgain:
    mov eax, 29 - 3 + 1    
    call RandomRange        
    add al, 3              
    mov pyPos, al

    mov eax, 85 - 32 + 1    
    call RandomRange        
    add al, 32              
    mov pxPos, al

    mov dl, pxPos
    mov dh, pyPos
   
    call checkCollision    
    cmp ah, 1
    je tryAgain
    
    movzx eax, dl
    movzx ecx,startX
    sub eax, ecx       
    movzx ebx, dh
    movzx ecx,startY
    sub ebx, ecx      
    imul ebx, 57       
    add eax, ebx       
   
    mov esi, OFFSET drawBoard
    mov BYTE PTR [esi+eax], 'P' 

    call drawPerson
    pop esi
    pop edi
    pop ecx
    pop eax
    ret
placePerson ENDP

;/////////////  DRAW PERSON PROC ////////////;

drawPerson Proc
    mov dl,pxPos
    mov dh,pyPos
    call GotoXY
    mov eax,lightCyan + ( brown * 16)  
    call SetTextColor
    mov al,'P'
    call WriteChar
    ret
drawPerson ENDP

;/////////////  PLACE TREE PROC ////////////;

placeTree Proc
    push eax
    push ecx
    push edi
    push esi

    mov esi,offset drawBoard
tryAgain:
    mov eax, 29 - 3 + 1    
    call RandomRange        
    add al, 3              
    mov tyPos, al

    mov eax, 85 - 32 + 1    
    call RandomRange        
    add al, 32              
    mov txPos, al

    mov dl, txPos
    mov dh, tyPos
   
    call checkCollision    
    cmp ah, 1
    je tryAgain
    
    movzx eax, dl
    movzx ecx,startX
    sub eax, ecx       
    movzx ebx, dh
    movzx ecx,startY
    sub ebx, ecx      
    imul ebx, 57       
    add eax, ebx       
   
    mov esi, OFFSET drawBoard
    mov BYTE PTR [esi+eax], 'T' 

    call drawTree
    pop esi
    pop edi
    pop ecx
    pop eax
    ret
placeTree ENDP

;/////////////  DRAW TREE PROC ////////////;

drawTree Proc
    mov dl,txPos
    mov dh,tyPos
    call GotoXY
    mov eax,green + (brown * 16)  
    call SetTextColor
    mov al,'T'
    call WriteChar
    ret
drawTree ENDP

;/////////////  CHECK COLLISION PROC ////////////;

checkCollision Proc
    push ebx
    push ecx
    push esi
   
    ; Calculate Array Index
    movzx eax, dl
    movzx ecx,startX
    sub eax, ecx      
   
    movzx ebx, dh
    movzx ecx,startY
    sub ebx, ecx      
   
    imul ebx, 57       
    add eax, ebx       

    mov esi, OFFSET drawBoard

    cmp BYTE PTR [esi + eax], '|'
    je collision_found

    cmp BYTE PTR [esi + eax], 'B'                
    je collision_found

    cmp BYTE PTR [esi + eax], 'P'                
    je collision_found

    cmp BYTE PTR [esi + eax], 'T'                
    je collision_found

    cmp BYTE PTR [esi + eax], 'C'                
    je collision_found
   
    mov ah, 0         
    jmp check_end
   
collision_found:
    mov ah, 1          ; Collision detected
   
check_end:
    pop esi
    pop ecx
    pop ebx
    ret
checkCollision ENDP

;/////////////  PLACE RANDOM PERSON PROC ////////////;

placeRandomCars Proc
    push eax
    push ecx
    push edi
    push esi

    mov esi,offset drawBoard
tryAgain:
    mov eax, 29 - 3 + 1    
    call RandomRange        
    add al, 3              
    mov ayPos, al

    mov eax, 85 - 32 + 1    
    call RandomRange        
    add al, 32              
    mov axPos, al

    mov dl, axPos
    mov dh, ayPos
   
    call checkCollision    
    cmp ah, 1
    je tryAgain
    
    movzx eax, dl
    movzx ecx,startX
    sub eax, ecx       
    movzx ebx, dh
    movzx ecx,startY
    sub ebx, ecx      
    imul ebx, 57       
    add eax, ebx       
   
    mov esi, OFFSET drawBoard
    mov BYTE PTR [esi+eax], 'A' 

    call drawRandomCar
    pop esi
    pop edi
    pop ecx
    pop eax
    ret
placeRandomCars ENDP

;/////////////  DRAW RANDOM CAR PROC ////////////;

drawRandomCar Proc
    mov dl,axPos
    mov dh,ayPos
    call GotoXY
    mov eax,lightMagenta + ( brown * 16)  
    call SetTextColor
    mov al,'A'
    call WriteChar
    ret
drawRandomCar ENDP

;/////////////  CHECK CAR COLISION PROC ////////////;

CheckCarCollision PROC
    push eax
    push ebx
    push ecx
    push esi

    ; Calculate Index in drawBoard
    movzx eax, xPos
    movzx ecx, startX
    sub eax, ecx        
   
    movzx ebx, yPos
    movzx ecx, startY
    sub ebx, ecx        
   
    imul ebx, 57        
    add eax, ebx        
   
    mov esi, OFFSET drawBoard
    cmp BYTE PTR [esi + eax], 'P'
    je score_deduct_person
    cmp BYTE PTR [esi + eax], 'B'
    je score_deduct_building 
    cmp BYTE PTR [esi + eax], 'T'
    je score_deduct_building 
    cmp BYTE PTR [esi + eax], 'A'
    je score_deduct_car
    
    pop esi
    pop ecx
    pop ebx
    pop eax
    ret
score_deduct_person:
    INVOKE Beep, 1000, 100
    sub score,5
    jmp check_collision_end
score_deduct_building:
    INVOKE Beep, 1000, 100
    cmp car_color_num,0
    je y_deduct
    jne r_deduct
score_deduct_car:
    INVOKE Beep, 1000, 100
    cmp car_color_num,0
    je y_car_deduct
    jne r_car_deduct
y_deduct:
    sub score,4
    jmp check_collision_end
r_car_deduct:
    sub score,3
    jmp check_collision_end
y_car_deduct:
    sub score,2
    jmp check_collision_end
r_deduct:
    sub score,2
    jmp check_collision_end
check_collision_end:
    pop esi
    pop ecx
    pop ebx
    pop eax
    call scorePrint
    ret
CheckCarCollision ENDP

;/////////////  DARW CAR PROC ////////////;

DrawCar PROC
    movzx eax, xPos
    movzx ecx, startX
    sub eax, ecx       
   
    movzx ebx, yPos
    movzx ecx, startY
    sub ebx, ecx       
   
    imul ebx, 57       
    add eax, ebx       
   
    mov esi, OFFSET drawBoard
    cmp BYTE PTR [esi + eax], 'D'
    je skip_draw_car
    cmp BYTE PTR [esi + eax], 'B'
    je skip_draw_car
    cmp BYTE PTR [esi + eax], 'P'
    je skip_draw_car
    cmp BYTE PTR [esi + eax], 'T'
    je skip_draw_car
    cmp BYTE PTR [esi + eax], 'A'
    je skip_draw_car
    
    mov dl,xPos
    mov dh,yPos
    call GotoXY
    mov eax,carColor 
    call SetTextColor
    mov al,'C'
    call WriteChar
    ret
skip_draw_car:
    ret
DrawCar ENDP

;/////////////  ERASE CAR PROC ////////////;

EraseCar PROC
    push eax
    push ebx
    push ecx
    push esi

    movzx eax, xPos
    movzx ecx, startX
    sub eax, ecx       
   
    movzx ebx, yPos
    movzx ecx, startY
    sub ebx, ecx       
   
    imul ebx, 57       
    add eax, ebx       
   
    mov esi, OFFSET drawBoard
    cmp BYTE PTR [esi + eax], 'D'
    je erase_car_end
    cmp BYTE PTR [esi + eax], 'B'
    je erase_car_end
    cmp BYTE PTR [esi + eax], 'T'
    je erase_car_end
    cmp BYTE PTR [esi + eax], 'P'
    je erase_car_end
    cmp BYTE PTR [esi + eax], 'A'
    je erase_car_end
    cmp BYTE PTR [esi + eax], 'C'
    jne skipErase
    mov BYTE PTR [esi + eax], ' '   
skipErase:
    pop esi
    pop ecx
    pop ebx
    pop eax

    mov dl,xPos
    mov dh,yPos
    call GotoXY
    mov eax,white+ (black * 16)
    call SetTextColor
    mov al,' '  
    call WriteChar
    ret
erase_car_end:
    pop esi
    pop ecx
    pop ebx
    pop eax
    ret
EraseCar ENDP

;/////////////  QUIT GAME PROC ////////////;

quitGame Proc
    exit
quitGame ENDP

;/////////////  MOVE CAR PROC ////////////;

MoveCar PROC
    cmp gameMode,'C'
    je checkNumPersons
checkNumPersons:
    cmp numPersons,0
    jne skip_persons_check
    call quitGame

skip_persons_check:
    call ReadChar
    jz no_key_pressed

    mov inputChar,al

    cmp inputChar,'e'
    je quitGame

    ; 2. Erase old car position
    call EraseCar

    ; 3. Update Position based on input
    cmp inputChar,'w'  ; up
    je moveUp
    cmp inputChar,'s'  ; down
    je moveDown
    cmp inputChar,'a'  ; left
    je moveLeft
    cmp inputChar,'d'  ; right
    je moveRight
    cmp inputChar,'W'  ; up
    je moveUp
    cmp inputChar,'S'  ; down
    je moveDown
    cmp inputChar,'A'  ; left
    je moveLeft
    cmp inputChar,'D'  ; right
    je moveRight
    cmp inputChar,'e'  ; exit
    je quitGame
    cmp inputChar,'E'  ; exit
    je quitGame
    cmp inputChar,'P'  ; pause game
    je pause_game_call
    cmp inputChar,'p'
    je pause_game_call

    cmp inputChar, ' ' ; space for passenger pickup
    je handlePickup
   
    ; If invalid key, just redraw
    jmp no_key_pressed
    call DrawCar
    call scorePrint
    ret

moveUp:
    cmp yPos,3
    jle confirmMove
    dec yPos
    jmp confirmMove
moveDown:
    cmp yPos,29
    jge confirmMove
    inc yPos
    jmp confirmMove
moveLeft:
    cmp xPos,32
    jle confirmMove
    sub xPos,2
    jmp confirmMove
moveRight:
    cmp xPos,85  
    jge confirmMove
    add xPos,2
    jmp confirmMove

confirmMove:
    call CheckCarCollision  
    call DrawCar
    call scorePrint
    ret
handlePickup:
    cmp pickUp,1
    je handleDropOff

    call checkPerson
    jmp redraw_car

handleDropOff:
    call dropedPerson

redraw_car:             
    call DrawCar
    call scorePrint     
    ret
no_key_pressed:
    ret
pause_game_call:
    call pause_game
    call clrscr
    call boardPrint

    call scorePrint
    call DrawCar
    ret
MoveCar ENDP

;/////////////  PAUSE GAME PROC ////////////;

pause_game Proc
    call CLRSCR
    mov  eax, yellow + (black * 16)
    call SetTextColor
    
    mov dh, 2
    mov dl, 38
    call GOTOXY
    mov edx, OFFSET pauseTitle  
    call WriteString
    
    mov dh, 5
    mov dl, 38
    call GOTOXY
    mov edx, OFFSET pauseOpt1  
    call WriteString

    mov dh, 6
    mov dl, 38
    call GOTOXY
    mov edx, OFFSET pauseOpt2 
    call WriteString

    mov dh, 7
    mov dl, 38
    call GOTOXY
    mov edx, OFFSET pauseOpt3  
    call WriteString

    mov dh, 8
    mov dl, 38
    call GOTOXY
    mov edx, OFFSET pauseOpt4  
    call WriteString

    mov dh, 13
    mov dl, 38
    call GOTOXY
    mov edx, OFFSET pausePrompt  
    call WriteString

    call ReadChar

    cmp al,'1'
    je pause_end

    cmp al,'2'
    je call_instructions

    cmp al,'3'
    je menuProc

    cmp al,'4'
    je quitGame
call_instructions:
    mov paused,1
    call instuctionProc
    ret

    jmp pause_game

pause_end:
    ret
pause_game ENDP

;/////////////  PERSON DROPED PROC ////////////;

dropedPerson Proc
    push eax
    push ebx
    push ecx
    push esi

    movzx eax, xPos
    movzx ecx, startX
    sub eax, ecx       
   
    movzx ebx, yPos
    movzx ecx, startY
    sub ebx, ecx       
   
    imul ebx, 57       
    add eax, ebx       
   
    mov esi, OFFSET drawBoard
    cmp BYTE PTR [esi + eax], 'D'
    jne not_reached

    add score, 10           
    mov pickUp, 0
    dec numPersons

    mov BYTE PTR [esi + eax], ' '
    mov dl, xPos
    mov dh, yPos
    call GOTOXY
    
    mov eax, brown + (black * 16)
    call SetTextColor
    mov al, ' '
    call WriteChar

    cmp gameMode,'E'
    je make_new_person
    cmp gameMode,'T'
    je make_new_person
    jmp not_reached 

make_new_person:
    call placePerson
    inc numPersons

not_reached:
    pop esi
    pop ecx
    pop ebx
    pop eax
    ret
dropedPerson ENDP


;///////////// CHECK PERSON PROC ////////////;

checkPerson Proc
    push eax
    push ebx
    push ecx
    push edx
    push esi

    mov dl,xPos
    mov dh,yPos

    dec dh                 ;Up Case
    call checkPoint 
    cmp ah, 1              ;Person found and removed
    je pickedUp
   
    add dh,2               ;Down Case
    call checkPoint 
    cmp ah, 1              
    je pickedUp

    dec dh                 ;Left Case
    sub dl,2
    call checkPoint 
    cmp ah, 1              
    je pickedUp
 
    add dl,4                ;Right Case
    call checkPoint 
    cmp ah, 1              
    je pickedUp

pickedUp:
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
checkPerson ENDP

;/////////////  CHECK POINT PROC ////////////;

checkPoint Proc
    push ebx
    push ecx
    push edi
    push eax

    movzx eax, dl
    movzx ecx, startX
    sub eax, ecx      
    movzx ebx, dh
    movzx ecx, startY
    sub ebx, ecx        
    imul ebx, 57        
    add eax, ebx        

    mov edi,eax

    mov esi, OFFSET drawBoard    ;Checking Memory
    cmp BYTE PTR [esi + edi], 'P'
    jne no_match
    
    mov pickUp, 1

    mov BYTE PTR [esi + edi], ' '
    call GOTOXY          
    mov eax, brown + (black * 16) 
    call SetTextColor
    mov al, ' '
    call WriteChar
    call personDropPoint
    mov ah, 1            
    jmp checkPoint_end

no_match:
    mov ah, 0            
    
checkPoint_end:
    pop eax
    pop edi
    pop ecx
    pop ebx
    ret
checkPoint ENDP

;/////////////  PERSON DROP POINT PROC ////////////;

personDropPoint Proc
tryAgain:
    mov eax, 29 - 3 + 1    
    call RandomRange        
    add al, 3              
    mov ryPos, al

    mov eax, 85 - 32 + 1    
    call RandomRange        
    add al, 32              
    mov rxPos, al

    mov dl, rxPos
    mov dh, ryPos
   
    call checkCollision    
    cmp ah, 1
    je tryAgain           

    push eax
    push ebx
    push ecx
   
    movzx eax, rxPos
    movzx ecx,startX
    sub eax, ecx      
    movzx ebx, ryPos
    movzx ecx,startY
    sub ebx, ecx      
    imul ebx, 57          
    add eax, ebx  
   
    mov esi, OFFSET drawBoard
    mov BYTE PTR [esi+eax], 'D'  
   
    pop ecx
    pop ebx
    pop eax

    mov dl, rxPos
    mov dh, ryPos
    call Gotoxy
    mov eax, black + (green * 16)    
    call SetTextColor
    mov al, 'D'
    call WriteChar
    ret
personDropPoint ENDP

;/////////////  GAME OVER PROC ////////////;

GameOver PROC
    mov eax, white + (red * 16)
    call SetTextColor
    call Clrscr
   
    mov dl, 30
    mov dh, 12
    call Gotoxy
   
    mov edx, OFFSET gameOverMsg
    call WriteString
   
    exit
GameOver ENDP

END main
