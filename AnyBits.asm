
;;
  Used Macros Strings Variables:
  
    &1, &2, &3              Proc
    &9, &10 to &19          For
 
  Used Macros Counters Variables:
 
    &&0, &&1                If
    &&2, &&3                While
    &&4, &&5                Do
    &&6, &&7                For
    
  Local Labels Attributions:
  
    O1                      On
    P9                      Proc
    I0,... I9, J0,... J9    If
    W0,... W9               While
    D0,... D9               Do
    F0,... F9               For
;;
____________________________________________________________________________________________

[= e   < b    > a    <s l    >s g    =< be    <= be    => ae    >= ae    <> ne]
____________________________________________________________________________________________

; Multi push, pop, mov, move, inc, and dec  Macros:

[push | push #1 | #+1]
[pop | pop #1 | #+1]
[mov | mov #1 #2 | #+2]
[move | push #2 | pop #1 | #+2]
[inc | inc #1 | #+1]
[dec | dec #1 | #+1]
____________________________________________________________________________________________

[Exchange | push #1 | push #2 | pop #1 | pop #2 | #+2]
____________________________________________________________________________________________

[On | cmp #1 #3 | jn#2 O1> | #4>L | O1:]
____________________________________________________________________________________________

[call | #If #1=str
            ApiPush #L>2
        #Else
            push #L>2
        #End_If
        call #1]

[ApiPush | #If #1=str
                push {#1, 0}
           #Else
                push #1
           #End_If
           #+1]
____________________________________________________________________________________________

; C calling convention:

[ccall
    push #L>2 | call #1
    #If #N>1
        add esp ((#N-1)*4)
    #EndIf]
____________________________________________________________________________________________

[.If
    #If &&0<>0
        #If &&0<> '0'
            #Error 'Unpaired If'
        #End_If
    #End_If
    &&0= '0' | &&1=Pos
    AndCmp I&&0>>, #1>L]

[.End_If | I&&0: | J&&0:
    #If &&0<> '0'
        #ErrorPos &&1 'Unpaired If'
    #End_If
    &&0=0]

[If
    #If &&0=0
        &&0= '0'
    #Else
        &&0=&&0+1
    #End_If

    AndCmp I&&0>>, #1>L]

[Else_If | jmp J&&0>> | I&&0:
    AndCmp I&&0>>, #1>L]

[Else | jmp J&&0>> | I&&0: ]

[End_If | I&&0: | J&&0:
    #If &&0= '0'
        &&0=0
    #Else
        &&0=&&0-1
    #End_If]

[AndCmp | cmp #2 #4 | jn#3 #F | #+3]
____________________________________________________________________________________________

[.While
    #If &&2<>0
        #If &&2<> '0'
                #Error 'Unpaired While'
        #End_If
    #End_If

    &&2= '0' | &&3=Pos

    W&&2: cmp #1 #3 | jn#2 W&&2>>]

[.End_While
    #If &&2<> '0'
        #ErrorPos  &&3 'Unpaired While'
    #End_If
    jmp W&&2<< | w&&2:
    &&2=0]

[While
    #If &&2=0
        &&2= '0'
    #Else
        &&2=&&2+1
    #End_If
    W&&2: cmp #1 #3 | jn#2 W&&2>>]

[End_While | jmp W&&2<< | w&&2:
             #If &&2= '0'
                &&2=0
             #Else
                &&2=&&2-1
             #End_If]
____________________________________________________________________________________________

[.Do
    #If &&4<>0
        #If &&4<> '0'
                #Error 'Unpaired Do'
        #End_If
    #End_If

    &&4= '0' | &&5=Pos

    D&&4:]

[.Loop_Until
    #If &&4<> '0'
        #ErrorPos  &&5 'Unpaired Do Until'
    #End_If

    cmp #1 #3 | jn#2 D&&4<<
    &&4=0]

[.Loop_While
    #If &&4<> '0'
        #ErrorPos  &&5 'Unpaired Do While'
    #End_If

    cmp #1 #3 | j#2 D&&4<<
    &&4=0]

[Do
    #If &&4= 0
        &&4= '0'
    #Else
        &&4=&&4+1
    #End_If

    D&&4: ]

[Loop_Until | cmp #1 #3 | jn#2 D&&4<<  | D&&4:
 #If &&4= '0'
    &&4=0
 #Else
    &&4=&&4-1
 #End_If]

[Loop_While | cmp #1 #3 | j#2 D&&4<<  | D&&4:
 #If &&4= '0'
    &&4=0
 #Else
    &&4=&&4-1
 #End_If]
____________________________________________________________________________________________

[.For
    #If &&6<>0
        #If &&6<> '0'
            #Error 'Unpaired For'
        #End_If
    #End_If
    &&6= '0' | &&7=Pos

    #If #3=imm
        mov #1 (#3-1)
    #Else
        mov #1 #3
        dec #1
    #EndIf
 F&&6:
    inc #1 | cmp #1 #5 | ja F&&6>> ]

[.Next | jmp F&&6<<
 F&&6:
    #If &&6<> '0'
        #ErrorPos &&7 'Unpaired For'
    #End_If
    &&6=0]

[For
    #If &&6=0
        &&6= '0'
    #Else
        &&6=&&6+1
    #EndIf

    #If #3=imm
        mov #1 (#3-1)
    #Else
        mov #1 #3
        dec #1
    #EndIf
 F&&6:
    inc #1 | cmp #1 #5 | ja F&&6>> ]


[Next | jmp F&&6<< | F&&6: &&6=&&6-1]

[Break | jmp F&&6>>]
[Continue | jmp F&&6<<]
[ExitF | jmp F0>>]
____________________________________________________________________________________________

;;
  &1 = Size of arguments 
  &2 = Size of local data (local+structures) 
  &3 = preserved regs 
;;

[Proc | &1=0 | &2=0 | &3= | &4= | #1 | push ebp | mov ebp esp]

[Arguments | {#1 ebp+4+(#x shl 2)} | #+1 | &1=(#N shl 2)]
[Local | {#1 ebp-(#x shl 2 +&2)} | #+1 | &2=&2+(#N shl 2) | sub esp (#N shl 2)]
[cLocal | {#1 ebp-(#x shl 2 +&2)} | push 0 | #+1 | &2=&2+(#N shl 2)]

[BYTE 1 | WORD 2 | DWORD 4 | QWORD 8 | OWORD 16]
[SZLocal | &2=&2+#1 | &4=&4+#1 | {#2 ebp-(&2)} | {#2@SZ #1} | #+2 | sub esp &4 | &4= | nope ]

[Uses | &2=&2+(#N shl 2) | push #1>L | &3=pop #L>1 ]

;[StackSafe | #If &3<>0 | lea esp D$ebp-(&2) | #End_If]


[GetMember | {#3 ebp-(#F-#2)} | #+2]
[Structure | {#1 ebp-(&2+#2+4)} | sub esp #2 | push esp | GetMember &2+#2 #L>3 | &2=&2+#2+4 ]

[Return | #If #N=1 | mov eax #1 | #EndIf | jmp P9>>]

[ExitP | jmp P9>>]

[EndP | P9: |  #If &3<>0 | lea esp D$ebp-(&2) | #End_If | &3 | leave | ret &1]
___________________________________________________________________________________________

[Align_on | add #2 #1-1 | and #2 0-#1][Align_UP | and #2 0-#1 | add #2 #1 ]
;[DBGBP | nope]
;[DBGBP | cmp B$isDBG 0 | DB 074 01 0CC ]
;[isDBG: D$ 0]




TITLE BigMath
___________________________________________________________________________________________

; 'Negate' means (0 minus number); nBits must be 32bit-aligned
Proc AnyBitsNegate::
 ARGUMENTS @pBits @nBits

    sub eax eax
    mov edx D@pBits | mov ecx D@nBits | test ecx 00_11111 | jne P9> | shr ecx 3 | je P9>
    add ecx edx ; ECX = upperBorder
L0: ; optimised for 0 case
    mov eax 0 | sub eax D$edx | jne L1>
    add edx 4 | cmp edx ecx | jb L0< | jmp L3>
; If happend one negation, then Null_number's upper bits now are turned on- GRAND_SBB
L0: mov eax 0-1 | sub eax D$edx
L1: mov D$edx eax | add edx 4 | cmp edx ecx | jb L0<
L3: mov eax 1
EndP


; 'Not' (Inverse bits); nBits must be 8bit-aligned
Proc AnyBitsNot::
 ARGUMENTS @pBits @nBits

    sub eax eax
    mov edx D@pBits | mov ecx D@nBits | test ecx 00_111 | jne P9> | shr ecx 3 | je P9>

L0: sub ecx 4 | jl L0>
    NOT D$edx | add edx 4 | jmp L0<
L0:
    add ecx 4 | je L1>
; 1-3 Bytes are left?
L0:
    NOT B$edx
    add edx 1 | sub ecx 1 | jg L0<
L1:
    mov eax 1
EndP
____________________________________________________________________________________________

; AnyBits1 + AnyBits2 = AnyBitsSumm ;
; returns 0 on Error, else 1; Sets Cflag (if not fits in Summ_buffer) & EDX bits.
; Must be 32Bit aligned
; Summ can't be less then bigger operand
; Summ_buffer can be bigger_operand itself, but use AnyBitsAdditionSelf
; Summ_buffer can be dirty
Proc AnyBitsAddition::
 ARGUMENTS @pSummBits @nSummBits @pAnyBits2 @nAnyBits2 @pAnyBits1 @nAnyBits1
 Local @upBorder3 @upBorder2 @upBorder1
 USES EBX ESI EDI

    mov eax D@nAnyBits1 | test eax 00_11111 | jne B0> | shr eax 3 | je B0>
    mov ecx D@nAnyBits2 | test ecx 00_11111 | jne B0> | shr ecx 3 | je B0>
    mov edx D@nSummBits | test edx 00_11111 | jne B0> | shr edx 3 | je B0>
L0:
    mov ebx D@pAnyBits1 | mov esi D@pAnyBits2 | mov edi D@pSummBits
    cmp eax ecx | jae L0> | xchg eax ecx | xchg ebx esi ; Bigger will 1st
L0:
    cmp edx eax | jae L0>         ; Summ_size can't be less
B0: sub eax eax | jmp P9>         ; ERROR case
L0:
    add eax ebx | mov D@upBorder1 eax
    add ecx esi | mov D@upBorder2 ecx
    add edx edi | mov D@upBorder3 edx
    sub ecx ecx | sub edx edx     ; EDX holds CFlag state
L0:
    mov eax D$ebx | add eax edx   ; add saved CFlag
    setc cl                       ; "child" CFlag can appear here, either
    add eax D$esi | setc dl       ; "main" CFlag can appear here.
    mov D$edi eax | or edx ecx    ; summarize CFlags
    add ebx 4 | add esi 4 | add edi 4
    cmp esi D@upBorder2 | jne L0< ; 2nd can be shorter
L0:
    cmp ebx D@upBorder1 | je L0> ; Copy remaining bits + CFlag
    mov eax D$ebx | add eax edx | setc dl | mov D$edi eax
    add ebx 4 | add edi 4 | jmp L0<
L0:
    cmp edi D@upBorder3 | je L0>
    ; if possible, store CFlag state, then Nullify remaining bits, if any
    mov D$edi edx | add edi 4 | sub edx edx
L1:
    cmp edi D@upBorder3 | je L0>
    mov D$edi 0 | add edi 4 | jmp L1<
L0:
    neg edx ; activates CFlag, if not stored & EDX al bits set, else = 0;
    mov eax &TRUE

EndP


; AnyBits1 - AnyBits2 = AnyBitsSub ;
; returns 0 on Error, else 1; Sets Cflag & EDX bits.
; Must be 32Bit aligned
; BitsSub can't be less then bigger operand
; BitsSub can be bigger_operand itself, but use AnyBitsSubstractionSelf.
; BitsSub can be dirty.
Proc AnyBitsSubstraction::
 ARGUMENTS @pBitsSub @nBitsSub @pAnyBits2 @nAnyBits2 @pAnyBits1 @nAnyBits1
 Local @upBorder3 @upBorder2 @upBorder1
 USES EBX ESI EDI

    mov eax D@nAnyBits1 | test eax 00_11111 | jne B0> | shr eax 3 | je B0>
    mov ecx D@nAnyBits2 | test ecx 00_11111 | jne B0> | shr ecx 3 | je B0>
    mov edx D@nBitsSub | test edx 00_11111 | jne B0> | shr edx 3 | je B0>
L0:
    mov ebx D@pAnyBits1 | mov esi D@pAnyBits2 | mov edi D@pBitsSub
    cmp eax ecx | jb B0>          ; 1st >= 2nd
L0:
    cmp edx eax | jae L0>         ; Sub_size can't be less
B0: sub eax eax | jmp P9>         ; ERROR case
L0:
    add eax ebx | mov D@upBorder1 eax
    add ecx esi | mov D@upBorder2 ecx
    add edx edi | mov D@upBorder3 edx
    sub ecx ecx | sub edx edx     ; EDX holds CFlag state
L0:
    mov eax D$ebx | sub eax edx   ; sub saved CFlag
    setc cl                       ; "child" CFlag can appear here, either
    sub eax D$esi | setc dl       ; "main" CFlag can appear here.
    mov D$edi eax | or edx ecx    ; summarize CFlags
    add ebx 4 | add esi 4 | add edi 4
    cmp esi D@upBorder2 | jne L0< ; 2nd can be shorter
L0:
    cmp ebx D@upBorder1 | je L0> ; Copy remaining bits - CFlag
    mov eax D$ebx | sub eax edx | setc dl | mov D$edi eax
    add ebx 4 | add edi 4 | jmp L0<
L0:
    ; if BitsSub bigger, store CFlag state to remaining bits
    mov eax edx | neg eax
L1:
    cmp edi D@upBorder3 | je L0>
    mov D$edi eax | add edi 4 | jmp L1<
L0:
    neg edx ; activates CFlag & EDX al bits set, else = 0;
    mov eax &TRUE

EndP


; AnyBits1 + AnyBits2 = AnyBits1 ;
; returns 0 on params_Error, else 1; Sets Cflag state & EDX bits.
; Must be 32Bit aligned
; AnyBits1_size >= AnyBits2_size
Proc AnyBitsAdditionSelf::
 ARGUMENTS @pAnyBits2 @nAnyBits2 @pAnyBits1 @nAnyBits1
 Local @upBorder1 @upBorder2
 USES ESI EDI

    mov eax D@nAnyBits1 | test eax 00_11111 | jne B0> | shr eax 3 | je B0>
    mov ecx D@nAnyBits2 | test ecx 00_11111 | jne B0> | shr ecx 3 | je B0>
L0:
    mov edi D@pAnyBits1 | mov esi D@pAnyBits2
    cmp eax ecx | jae L0>         ; 1st >= 2nd
B0: sub eax eax | jmp P9>         ; ERROR case
L0:
    add eax edi | mov D@upBorder1 eax
    add ecx esi | mov D@upBorder2 ecx
    sub ecx ecx | sub edx edx     ; EDX holds CFlag state
L0:
    mov eax D$edi | add eax edx   ; add saved CFlag
    setc cl                       ; "child" CFlag can appear here, either
    add eax D$esi | setc dl       ; "main" CFlag can appear here.
    mov D$edi eax | or edx ecx    ; Logical_OR CFlags
    add esi 4 | add edi 4
    cmp esi D@upBorder2 | jne L0< ; 2nd <= 1st
L0:
    cmp edi D@upBorder1 | je L0> ; remaining bits + CFlag
    add D$edi edx | setc dl      ; CFlag until death :)
    add edi 4 | test edx edx | jne L0<
L0:
    neg edx ; activates CFlag & EDX al bits set, else = 0;
    mov eax &TRUE

EndP


; AnyBits1 = AnyBits1 + (2* AnyBits2) ;
; returns 0 on params_Error, else 1; Sets Cflag state & EDX (1,2) for extending or 0.
; Must be 32Bit aligned
; AnyBits1_size >= AnyBits2_size
Proc AnyBitsAddition2XSelf::
 ARGUMENTS @pAnyBits2 @nAnyBits2 @pAnyBits1 @nAnyBits1
 Local @upBorder1 @upBorder2
 USES EBX ESI EDI

    mov eax D@nAnyBits1 | test eax 00_11111 | jne B0> | shr eax 3 | je B0>
    mov ecx D@nAnyBits2 | test ecx 00_11111 | jne B0> | shr ecx 3 | je B0>
L0:
    mov edi D@pAnyBits1 | mov esi D@pAnyBits2
    cmp eax ecx | jae L0>         ; 1st >= 2nd
B0: sub eax eax | jmp P9>         ; ERROR case
L0:
    add eax edi | mov D@upBorder1 eax
    add ecx esi | mov D@upBorder2 ecx
    sub ebx ebx | sub ecx ecx | sub edx edx ; EDX holds CFlag state
L0:
    mov eax D$esi | add eax eax | setc BL ; double's Cflag
    add eax edx   ; add saved CFlag
    setc cl                       ; "child" CFlag can appear here, either
    add D$edi eax | setc dl       ; "main" CFlag can appear here.
    or edx ecx    ; Logical_OR CFlags
    add edx ebx   ; Double
    add esi 4 | add edi 4
    cmp esi D@upBorder2 | jne L0< ; 2nd <= 1st
L0:
    cmp edi D@upBorder1 | je L0> ; remaining bits + CFlag
    add D$edi edx | setc dl      ; CFlag until death :)
    add edi 4 | test edx edx | jne L0<
L0:
    neg edx
    neg edx ; activates CFlag & EDX holds overload for extending, else = 0;
    mov eax &TRUE

EndP


; AnyBits = AnyBits + 32Bit ;
; returns 0 on params_Error, else 1; Sets C-flag state & EDX bits.
; Must be 32Bit aligned
Proc AnyBitsAdditionSelf32Bit::
 ARGUMENTS @pAnyBits @nAnyBits @Number32
; Local @upBorder1 ; @upBorder2
 USES EDI

    mov ecx D@nAnyBits | test ecx 00_11111 | jne B0> | shr ecx 3 | jne L0>
B0: sub eax eax | jmp P9>         ; ERROR case
L0: mov edi D@pAnyBits
    add ecx edi
    mov eax D@Number32

    sub edx edx     ; EDX for CFlag state
    add D$edi eax | jnc L2>
; bigSBB
L1: add edi 4 | cmp edi ecx | jae L0> | add D$edi 1 | jc L1< | jmp L2>
L0: mov edx 1
L2: neg edx ; activates CFlag & EDX al bits set, else = 0;
    mov eax &TRUE

EndP


; AnyBits1 - AnyBits2 =  AnyBits1 ;
; returns 0 on params_Error, else 1; Sets Cflag state & EDX bits.
; Must be 32Bit aligned
; AnyBits1_size >= AnyBits2_size
Proc AnyBitsSubstractionSelf::
 ARGUMENTS @pAnyBits2 @nAnyBits2 @pAnyBits1 @nAnyBits1
 Local @upBorder1 @upBorder2
 USES ESI EDI

    mov eax D@nAnyBits1 | test eax 00_11111 | jne B0> | shr eax 3 | je B0>
    mov ecx D@nAnyBits2 | test ecx 00_11111 | jne B0> | shr ecx 3 | je B0>
L0:
    mov edi D@pAnyBits1 | mov esi D@pAnyBits2
    cmp eax ecx | jae L0>         ; 1st >= 2nd
B0: sub eax eax | jmp P9>         ; ERROR case
L0:
    add eax edi | mov D@upBorder1 eax
    add ecx esi | mov D@upBorder2 ecx
    sub ecx ecx | sub edx edx     ; EDX holds CFlag state
L0:
    mov eax D$edi | sub eax edx   ; sub saved CFlag
    setc cl                       ; "child" CFlag can appear here, either
    sub eax D$esi | setc dl       ; "main" CFlag can appear here.
    mov D$edi eax | or edx ecx    ; Logical_OR CFlags
    add esi 4 | add edi 4
    cmp esi D@upBorder2 | jne L0< ; 2nd <= 1st
L0:
    cmp edi D@upBorder1 | je L0> ; remaining bits - CFlag
    sub D$edi edx | setc dl      ; CFlag until death :)
    add edi 4 | test edx edx | jne L0<
L0:
    neg edx ; activates CFlag & EDX al bits set, else = 0;
    mov eax &TRUE

EndP


; AnyBits = AnyBits - 32Bit ;
; returns 0 on params_Error, else 1; Sets C-flag state & EDX bits.
; Must be 32Bit aligned
Proc AnyBitsSubstractSelf32Bit::
 ARGUMENTS @pAnyBits @nAnyBits @Number32
; Local @upBorder1 ; @upBorder2
 USES EDI

    mov ecx D@nAnyBits | test ecx 00_11111 | jne B0> | shr ecx 3 | jne L0>
B0: sub eax eax | jmp P9>         ; ERROR case
L0: mov edi D@pAnyBits
    add ecx edi
    mov eax D@Number32

    sub edx edx     ; EDX for CFlag state
    sub D$edi eax | jnc L2>
; bigSBB
L1: add edi 4 | cmp edi ecx | jae L0> | sub D$edi 1 | jc L1< | jmp L2>
L0: mov edx 1
L2: neg edx ; activates CFlag & EDX al bits set, else = 0;
    mov eax &TRUE

EndP


; Compare = AnyBits1 - AnyBits2
; returns 0 on params_Error, else:
; 1 - 1st is bigger, 2 - 2nd is bigger, 3 = are EQUAL
; Must be 32Bit aligned
Proc AnyBitsCompare::
 ARGUMENTS @pAnyBits2 @nAnyBits2 @pAnyBits1 @nAnyBits1
 USES ESI EDI
; firstly, just compare High Bits
    call GetHighestBitPosition D@pAnyBits2 D@nAnyBits2
    cmp eax 0-1 | jne L0> | cmp edx 0-1 | je E0>
L0: mov esi eax
    call GetHighestBitPosition D@pAnyBits1 D@nAnyBits1
    cmp eax 0-1 | jne L0> | cmp edx 0-1 | je E0>
L0: mov ecx esi | cmp eax ecx | je L0> | mov eax 1 | ja P9>
    mov eax 2 | jmp P9>
E0: mov eax 0 | jmp P9>
; High Bits are Equial, do more
L0: ALIGN_UP 32 ecx | shr ecx 3
    mov esi D@pAnyBits1 | mov edi D@pAnyBits2
L0:
    mov eax D$esi+ecx-4
    cmp eax D$edi+ecx-4 | jne L0>
    sub ecx 4 | jne L0<
    mov eax 3 | jmp P9> ; Equal case
L0: mov eax 1 | ja P9>
    mov eax 2
EndP

____________________________________________________________________________________________


; AnyBits1 * AnyBits2 = AnyBits3 ;
; returns 0 on params_Error, else 1
; Parameters Must be 32Bit aligned
; AnyBits3_size = AnyBits1_size + AnyBits2_size ;
; Out_buffer can be dirty, we clean.
Proc AnyBitsMultiplicationBinary::
 ARGUMENTS @pAnyBits3 @nAnyBits3 @pAnyBits2 @nAnyBits2 @pAnyBits1 @nAnyBits1
 Local @upBorder1 @upBorder2 ;@upBorder3 ; < not used
 USES EBX ESI EDI

    mov eax D@nAnyBits1 | test eax 00_11111 | jne B0> | shr eax 3 | je B0>
    mov ecx D@nAnyBits2 | test ecx 00_11111 | jne B0> | shr ecx 3 | je B0>
    mov edx D@nAnyBits3 | test edx 00_11111 | jne B0> | shr edx 3 | je B0>
    lea ebx D$eax+ecx | cmp edx ebx | jb B0> ; out_buf_len check
    mov edi D@pAnyBits3 | ;add ebx edi | mov D@upBorder3 ebx ; buffer can be no-need bigger
    mov ebx D@pAnyBits1 | mov esi D@pAnyBits2
    cmp eax ecx | jae L0>
    xchg eax ecx | xchg ebx esi | mov D@pAnyBits1 ebx| mov D@pAnyBits2 esi ; Bigger -> 1st param
L0: add eax ebx | add ecx esi | mov D@upBorder1 eax | mov D@upBorder2 ecx
    mov ecx edx | sub eax eax | shr ecx 2 | CLD | rep stosd ; clean outBuff
    sub ecx ecx | jmp L0>
B0: sub eax eax | jmp P9> ; params ERROR case

; we will MUL as SHIFT&ADD
; test Multiplier bits
ALIGN 16
L0: BT D$esi ecx | jnc L1>
    mov ebx D@pAnyBits1 | mov edi D@pAnyBits3 ;
L4:
    sub edx edx | mov eax D$ebx | test ecx ecx | je L5> ;cmp cl 0 | je L5>
    mov edx eax
    shl eax cl
    ;mov ch cl | mov cl 32 | sub cl ch | shr edx cl | mov cl ch | mov ch 0 ; 1ver
    ;neg ecx | add ecx 32 | shr edx cl | sub ecx 32 | neg ecx ; 2ver
    NOP | rol edx cl | xor edx eax ; 3ver
L5:
    add D$edi eax | adc D$edi+4 edx | jnc L3>
    lea eax D$edi+4
L2: add eax 4 | add D$eax 1 | jc L2< ; BIG-ADC ; no need upBorder check > sizes checked
L3: add ebx 4 | add edi 4 | cmp ebx D@upBorder1 | jb L4<
L1:
    inc ecx | cmp ecx 32 | jb L0<
    sub ecx ecx | add esi 4 | add D@pAnyBits3 4 ; 32bit SHIFT
    cmp esi D@upBorder2 | jb L0<

    mov eax &TRUE

EndP


;;
Proc AnyBitsBinaryMultiplicationT1:
 ARGUMENTS @pAnyBits3 @nAnyBits3 @pAnyBits2 @nAnyBits2 @pAnyBits1 @nAnyBits1
 Local @upBorder1 @upBorder2 ;@upBorder3 ; < not used
 USES EBX ESI EDI

    mov eax D@nAnyBits1 | test eax 00_11111 | jne B0> | shr eax 3 | je B0>
    mov ecx D@nAnyBits2 | test ecx 00_11111 | jne B0> | shr ecx 3 | je B0>
    mov edx D@nAnyBits3 | test edx 00_11111 | jne B0> | shr edx 3 | je B0>
    lea ebx D$eax+ecx | cmp edx ebx | jb B0> ; out_buf_len check
    mov edi D@pAnyBits3 | ;add ebx edi | mov D@upBorder3 ebx ; buffer can be no-need bigger
    mov ebx D@pAnyBits1 | mov esi D@pAnyBits2
    cmp eax ecx | jae L0>
    xchg eax ecx | xchg ebx esi | mov D@pAnyBits1 ebx| mov D@pAnyBits2 esi ; Bigger - 1st param
L0: add eax ebx | add ecx esi | mov D@upBorder1 eax | mov D@upBorder2 ecx
    mov ecx edx | sub eax eax | shr ecx 2 | CLD | rep stosd ; clean outBuff
    jmp L6>
B0: sub eax eax | jmp P9> ; params ERROR case

; we will do SHIFT&ADD
; test Multiplier bits
ALIGN 16

L0: shr esi 1 | jnc L1>
    mov ebx D@pAnyBits1 | mov edi D@pAnyBits3 ;
L4:
    sub edx edx | mov eax D$ebx | test ecx ecx | je L5>
    mov edx eax
    shl eax cl
    NOP | rol edx cl | xor edx eax
L5:
    add D$edi eax | adc D$edi+4 edx | jnc L3>
    lea eax D$edi+4
L2: add eax 4 | add D$eax 1 | jc L2< ; BIG-ADC ; no need upBorder check > sizes checked
L3: add ebx 4 | add edi 4 | cmp ebx D@upBorder1 | jb L4< | test esp esp ; setnz
L1: je L7> ; terminate loop (can do earlier!)
    inc ecx | jmp L0<
L7: 
    add D@pAnyBits2 4 | add D@pAnyBits3 4 ; 32bit SHIFT
L6: sub ecx ecx
    mov esi D@pAnyBits2 | cmp esi D@upBorder2 | jnb L0> | mov esi D$esi | jmp L0<
L0:
    mov eax &TRUE
EndP
;;
;;
Proc AnyBitsBinaryMultiplicationT:
 ARGUMENTS @pAnyBits3 @nAnyBits3 @pAnyBits2 @nAnyBits2 @pAnyBits1 @nAnyBits1
 Local @upBorder1 @upBorder2 ;@upBorder3 ; < not used
 USES EBX ESI EDI

    mov eax D@nAnyBits1 | test eax 00_11111 | jne B0> | shr eax 3 | je B0>
    mov ecx D@nAnyBits2 | test ecx 00_11111 | jne B0> | shr ecx 3 | je B0>
    mov edx D@nAnyBits3 | test edx 00_11111 | jne B0> | shr edx 3 | je B0>
    lea ebx D$eax+ecx | cmp edx ebx | jb B0> ; out_buf_len check
    mov edi D@pAnyBits3 | ;add ebx edi | mov D@upBorder3 ebx ; buffer can be no-need bigger
    mov ebx D@pAnyBits1 | mov esi D@pAnyBits2
    cmp eax ecx | jae L0>
    xchg eax ecx | xchg ebx esi | mov D@pAnyBits1 ebx| mov D@pAnyBits2 esi ; Bigger - 1st param
L0: add eax ebx | add ecx esi | mov D@upBorder1 eax | mov D@upBorder2 ecx
    mov ecx edx | sub eax eax | shr ecx 2 | CLD | rep stosd ; clean outBuff
    jmp L6>
B0: sub eax eax | jmp P9> ; params ERROR case

; we will MUL as SHIFT&ADD
; test Multiplier bits
ALIGN 16
L6: mov esi D$esi

L0: BT esi ecx | jnc L1>
    mov ebx D@pAnyBits1 | mov edi D@pAnyBits3 ;
L4:
    sub edx edx | mov eax D$ebx | cmp cl 0 | je L5>
    mov edx eax
    shl eax cl
    NOP | rol edx cl | xor edx eax
L5:
    add D$edi eax | adc D$edi+4 edx | jnc L3>
    lea eax D$edi+4
L2: add eax 4 | add D$eax 1 | jc L2< ; BIG-ADC ; no need upBorder check > sizes checked
L3: add ebx 4 | add edi 4 | cmp ebx D@upBorder1 | jb L4<
L1:
    inc ecx | cmp ecx 32 | jb L0<
    sub ecx ecx | add D@pAnyBits2 4 | add D@pAnyBits3 4 ; 32bit SHIFT
    mov esi D@pAnyBits2 | cmp esi D@upBorder2 | jb L6<

    mov eax &TRUE
EndP
;;
;;
; 16>>32 bit expanding
Proc AnyBitsBinaryMultiplication1632:
 ARGUMENTS @pAnyBits3 @nAnyBits3 @pAnyBits2 @nAnyBits2 @pAnyBits1 @nAnyBits1
 Local @upBorder1 @upBorder2 ;@upBorder3 ; < not used
 USES EBX ESI EDI

    mov eax D@nAnyBits1 | test eax 00_11111 | jne B0> | shr eax 3 | je B0>
    mov ecx D@nAnyBits2 | test ecx 00_11111 | jne B0> | shr ecx 3 | je B0>
    mov edx D@nAnyBits3 | test edx 00_11111 | jne B0> | shr edx 3 | je B0>
    lea ebx D$eax+ecx | cmp edx ebx | jb B0> ; out_buf_len check
    mov edi D@pAnyBits3 | ;add ebx edi | mov D@upBorder3 ebx ; buffer can be no-need bigger
    mov ebx D@pAnyBits1 | mov esi D@pAnyBits2
    cmp eax ecx | jae L0>
    xchg eax ecx | xchg ebx esi | mov D@pAnyBits1 ebx| mov D@pAnyBits2 esi ; Bigger - 1st param
L0: add eax ebx | add ecx esi | mov D@upBorder1 eax | mov D@upBorder2 ecx
    mov ecx edx | sub eax eax | shr ecx 2 | CLD | rep stosd ; clean outBuff
    jmp L6>
B0: sub eax eax | jmp P9> ; params ERROR case

; we will MUL as SHIFT&ADD
; test Multiplier bits
ALIGN 16
L6: movzx esi W$esi

L0: BT esi ecx | jnc L1>
    mov ebx D@pAnyBits1 | mov edi D@pAnyBits3 ;
L4:
    movzx eax W$ebx | cmp cl 0 | shl eax cl
L5:
    add D$edi eax | jnc L3>
    lea eax D$edi+2
L2: add eax 2 | add W$eax 1 | jc L2< ; BIG-ADC ; no need upBorder check > sizes checked
L3: add ebx 2 | add edi 2 | cmp ebx D@upBorder1 | jb L4<
L1:
    inc ecx | cmp ecx 16 | jb L0<
    sub ecx ecx | add D@pAnyBits2 2 | add D@pAnyBits3 2 ; 16bit SHIFT
    mov esi D@pAnyBits2 | cmp esi D@upBorder2 | jb L6<

    mov eax &TRUE
EndP
;;

; AnyBits1 * AnyBits2 = AnyBits3 ;
; returns 0 on params_Error, else 1
; Parameters Must be 32Bit aligned
; AnyBits3_size = AnyBits1_size + AnyBits2_size ;
; Out_buffer can be dirty, we clean.
Proc AnyBitsMultiplicationLong::
 ARGUMENTS @pAnyBits3 @nAnyBits3 @pAnyBits2 @nAnyBits2 @pAnyBits1 @nAnyBits1
 Local @upBorder1 @upBorder2 ;@upBorder3 ; < not used
 USES EBX ESI EDI

    mov eax D@nAnyBits1 | test eax 00_11111 | jne B0> | shr eax 3 | je B0>
    mov ecx D@nAnyBits2 | test ecx 00_11111 | jne B0> | shr ecx 3 | je B0>
    mov edx D@nAnyBits3 | test edx 00_11111 | jne B0> | shr edx 3 | je B0>
    lea ebx D$eax+ecx | cmp edx ebx | jb B0> ; out_buf_len check
    mov edi D@pAnyBits3 | ;add ebx edi | mov D@upBorder3 ebx ; buffer can be no-need bigger
    mov ebx D@pAnyBits1 | mov esi D@pAnyBits2
    cmp eax ecx | jae L0>
    xchg eax ecx | xchg ebx esi | mov D@pAnyBits1 ebx| mov D@pAnyBits2 esi ; Bigger - 1st param
L0: add eax ebx | add ecx esi | mov D@upBorder1 eax | mov D@upBorder2 ecx
    mov ecx edx | sub eax eax | shr ecx 2 | CLD | rep stosd ; clean outBuff
    jmp L0>
B0: sub eax eax | jmp P9> ; params ERROR case

ALIGN 16
L0: mov ecx D$esi | test ecx ecx | je L1>
    mov ebx D@pAnyBits1 | mov edi D@pAnyBits3 ;
L4:
    mov eax D$ebx | mul ecx
    add D$edi eax | adc D$edi+4 edx | jnc L3>
; BIG-ADC ; no need upBorder check > sizes checked
    lea eax D$edi+4
L2: add eax 4 | add D$eax 1 | jc L2<
L3: add ebx 4 | add edi 4 | cmp ebx D@upBorder1 | jb L4<
L1:
    add esi 4 | add D@pAnyBits3 4 ; 32bit SHIFT
    cmp esi D@upBorder2 | jb L0<

    mov eax &TRUE
EndP

;[BIGADCcounter1: D$ 0 BIGADCcounter2: D$ 0 BIGADCcounter3: D$ 0 BIGADCcounter4: D$ 0 ]
;;
ALIGN 4
; AnyBits1 Square = AnyBits2 ;
; returns 0 on params_Error, else 1
; Parameters Must be 32Bit aligned
; AnyBits2_size = AnyBits1_size *2 ;
; Out_buffer can be dirty, we clean.
Proc AnyBitsSquareLong1::
 ARGUMENTS @pAnyBits2 @nAnyBits2 @pAnyBits1 @nAnyBits1
 Local @upBorder1 ;@upBorder2 ;@upBorder3 ; < not used
 USES EBX ESI EDI

    mov eax D@nAnyBits1 | test eax 00_11111 | jne B0> | shr eax 3 | je B0>
    mov ecx D@nAnyBits2 | test ecx 00_11111 | jne B0> | shr ecx 3 | je B0>
    mov edx eax | shl edx 1 | cmp ecx edx | jb B0> ; out_buf_len check

    mov esi D@pAnyBits1 | mov edi D@pAnyBits2

L0: add eax esi | mov D@upBorder1 eax
    sub eax eax | shr ecx 2 | CLD | rep stosd ; clean outBuff
    jmp L0>
B0: sub eax eax | jmp P9> ; params ERROR case

ALIGN 16
L0: mov ecx D$esi | test ecx ecx | je L1>
    mov ebx D@pAnyBits1 | mov edi D@pAnyBits2 ;
L4: cmp ebx esi | jae L6>
    mov eax esi | sub eax ebx | add edi eax | add ebx eax
L6: mov eax D$ebx | mul ecx
    cmp ebx esi | je L3>
; 2x EDX:EAX
    add eax eax | adc edx edx | jnc L3>
;inc D$BIGADCcounter1
    add D$edi+8 1 | jnc L3> ; +1 chance to avoid BIG-ADC
;inc D$BIGADCcounter2
; BIG-ADC
    push edi ;eax
    add edi 8 ;lea eax D$edi+8
L2: add edi 4 | add D$edi 1 | jc L2<
    pop edi

L3: add D$edi eax | adc D$edi+4 edx | jnc L5>
;inc D$BIGADCcounter3
    add D$edi+8 1 | jnc L5> ; +1 chance to avoid BIG-ADC
;inc D$BIGADCcounter4
; BIG-ADC
    lea eax D$edi+8
L2: add eax 4 | add D$eax 1 | jc L2<

L5: add ebx 4 | add edi 4 | cmp ebx D@upBorder1 | jb L4<
L1:
    add esi 4 | add D@pAnyBits2 4 ; 32bit SHIFT
    cmp esi D@upBorder1 | jb L0<

    mov eax &TRUE
EndP
;;
;
ALIGN 8
; AnyBits1 Square = AnyBits2 ;
; returns 0 on params_Error, else 1
; Parameters Must be 32Bit aligned
; AnyBits2_size = AnyBits1_size *2 ;
; Out_buffer can be dirty, we clean.
Proc AnyBitsSquareLong::
 ARGUMENTS @pAnyBits2 @nAnyBits2 @pAnyBits1 @nAnyBits1
 Local @upBorder1 ;@upBorder2 ;@upBorder3 ; < not used
 USES EBX ESI EDI

    mov eax D@nAnyBits1 | test eax 00_11111 | jne B0> | shr eax 3 | je B0>
    mov ecx D@nAnyBits2 | test ecx 00_11111 | jne B0> | shr ecx 3 | je B0>
    mov edx eax | SHL edx 1 | cmp ecx edx | jb B0> ; out_buf_len check

    mov edi D@pAnyBits1
    mov ecx eax | SHR ecx 2 | add edi eax
    sub eax eax | sub edi 4 | STD | REPE SCASD | CLD | je L1>
    add edi 8 | mov D@upBorder1 edi | jmp L0> ; cut upper nulls
; NULL case: clean outBuff & exit
L1: mov edi D@pAnyBits2 | mov ecx D@nAnyBits2
    sub eax eax | SHR ecx 5 | CLD | REP STOSD | mov eax 1 | jmp P9>>
B0: sub eax eax | jmp P9>> ; params ERROR case

L0: mov ecx D@upBorder1 | mov esi D@pAnyBits1 | mov edi D@pAnyBits2
    sub ecx esi | SHR ecx 2
L0: ;firstly square every dword, so no need to clean buffer
    mov eax D$esi | MUL eax | mov D$edi eax, D$edi+4 edx
    add esi 4 | add edi 8 | dec ecx | jne L0<
; clean rest of upper
    mov ecx D@nAnyBits2 | SHR ecx 3 | add ecx D@pAnyBits2 | sub ecx edi | je L0>
    sub eax eax | SHR ecx 2 | CLD | REP STOSD
L0:
    cmp D@nAnyBits1 32 | je L9> ; for 32bit job done
    mov esi D@pAnyBits1 | add esi 4 ; this excludes last dword
ALIGN 8
L0: mov ecx D$esi-4 | test ecx ecx | je L1>
    mov ebx D@pAnyBits1 | mov edi D@pAnyBits2

L4: cmp ebx esi | ja L6>
    mov eax esi | sub eax ebx | add edi eax | add ebx eax
L6: mov eax D$ebx | MUL ecx

; 2x EDX:EAX
    add eax eax | adc edx edx | jnc L3>
;inc D$BIGADCcounter1
    add D$edi+8 1 | jnc L3> ; +1 chance to avoid BIG-ADC
;inc D$BIGADCcounter2
; BIG-ADC
    push edi
    add edi 8
L2: add edi 4 | add D$edi 1 | jc L2<
    pop edi

L3: add D$edi eax | adc D$edi+4 edx | jnc L5>
;inc D$BIGADCcounter3
    add D$edi+8 1 | jnc L5> ; +1 chance to avoid BIG-ADC
;inc D$BIGADCcounter4
; BIG-ADC
    lea eax D$edi+8
L2: add eax 4 | add D$eax 1 | jc L2<

L5: add ebx 4 | add edi 4 | cmp ebx D@upBorder1 | jb L4<

L1:
    add esi 4 | add D@pAnyBits2 4 ; 32bit SHIFT
    cmp esi D@upBorder1 | jb L0<
L9:
    mov eax &TRUE
EndP
;
;
ALIGN 4
; AnyBitsIn pow N = AnyBitsOut ;
; returns 0 on params_Error, else:
; EAX>VAllocated Buffer of AnyBitsPow, EDX>@nAnyBitsPow in bits
; Parameter @nAnyBits Must be 32Bit aligned
; @Power
Proc AnyBitsPower::
 ARGUMENTS @pAnyBits @nAnyBits @Power
 cLocal @AnyBitsLen @nAnyBitsPowFin @nAnyBitsPow1 @pAnyBitsPow1 @nAnyBitsPow2 @pAnyBitsPow2,
        @nAnyBitsSquare1 @pAnyBitsSquare1 @nAnyBitsSquare2 @pAnyBitsSquare2 ; @upBorder1
 USES EBX ESI EDI

; params check
    sub eax eax
    test D@nAnyBits 00_11111 | jne P9>> | shr D@nAnyBits 3 | je P9>>

; search highest bits.
L0:
    mov edx D@pAnyBits | add edx D@nAnyBits
L0: sub edx 4 | cmp edx D@pAnyBits | jb L1> ; AnyBits is 0, End.
    BSR eax D$edx | je L0<
    sub edx D@pAnyBits | lea edx D$edx*8+eax | mov D@AnyBitsLen edx
    test edx edx | je C1>
    jmp L0>
; 0 case
L1: call VAlloc 4 | test eax eax | je P9>>
    mov D$eax 0 , edx 32 | jmp P9>>
L0:
    cmp D@power 0 | jne L0>
; 1 case
C1: call VAlloc 4 | test eax eax | je P9>>
    mov D$eax 1 , edx 32 | jmp P9>>
L0: test D@power 080000000 | je L0> | neg D@power

; calc final BitSz
L0: mov eax D@AnyBitsLen | inc eax | mul D@Power
    mov D@nAnyBitsPowFin eax
    ;ALIGN_UP 32 eax | shr eax 3 | mov D@nAnyBitsPow1 eax
; alloc buffers
    call VAlloc 4 | mov D@pAnyBitsPow1 eax
    call VAlloc D@nAnyBits | mov D@pAnyBitsSquare1 eax
    cmp D@pAnyBitsPow1 0 | je B0>
    cmp D@pAnyBitsSquare1 0 | je B0>
    jmp L0>
B0:
    call VFree D@pAnyBitsPow1
    call VFree D@pAnyBitsPow2
    call VFree D@pAnyBitsSquare1
    call VFree D@pAnyBitsSquare2
    sub eax eax | jmp P9>>
L0: mov eax D@pAnyBitsPow1, D$eax 1
    mov ecx D@nAnyBits, esi D@pAnyBits, edi D@pAnyBitsSquare1, D@nAnyBitsSquare1 ecx
    CLD | shr ecx 2 | REP movsd
    shl D@nAnyBitsSquare1 3 | mov D@nAnyBitsPow1 32

L0:
    test D@power 1 | je L3>
    mov eax D@nAnyBitsSquare1 | add eax D@nAnyBitsPow1 | mov D@nAnyBitsPow2 eax
    shr eax 3
L1: call VAlloc eax | mov D@pAnyBitsPow2 eax | test eax eax | je B0<
    call AnyBitsMultiplication D@pAnyBitsPow2 D@nAnyBitsPow2, D@pAnyBitsPow1 D@nAnyBitsPow1, D@pAnyBitsSquare1 D@nAnyBitsSquare1
    test eax eax | je B0<<

    UpdateBitSize D@pAnyBitsPow2 D@nAnyBitsPow2

    Exchange D@pAnyBitsPow1 D@pAnyBitsPow2, D@nAnyBitsPow1 D@nAnyBitsPow2
    call VFree D@pAnyBitsPow2 | and D@pAnyBitsPow2 0
L3:
    shr D@power 1 | je E2>>
    mov eax D@nAnyBitsSquare1 | shl eax 1 | mov D@nAnyBitsSquare2 eax
    shr eax 3
    call VAlloc eax | mov D@pAnyBitsSquare2 eax | test eax eax | je B0<<
    call AnyBitsSquare D@pAnyBitsSquare2 D@nAnyBitsSquare2 D@pAnyBitsSquare1 D@nAnyBitsSquare1
    test eax eax | je B0<<

    UpdateBitSize D@pAnyBitsSquare2 D@nAnyBitsSquare2

    Exchange D@pAnyBitsSquare1 D@pAnyBitsSquare2, D@nAnyBitsSquare1 D@nAnyBitsSquare2
    call VFree D@pAnyBitsSquare2 | and D@pAnyBitsSquare2 0
jmp L0<<
E2:
;    call VFree D@pAnyBitsPow2
    call VFree D@pAnyBitsSquare1
;    call VFree D@pAnyBitsSquare2
;    shl D@nAnyBitsPow1 3
    UpdateBitSize D@pAnyBitsPow1 D@nAnyBitsPow1
    mov eax D@pAnyBitsPow1, edx D@nAnyBitsPow1
EndP


ALIGN 4
; AnyBits1 * 32Bit = AnyBits3 ;
; returns 0 on params_Error, else size in length (dword aligned), min=4
; Parameters Must be 32Bit aligned
; AnyBits3_size = AnyBits1_size + 32Bits ;
; Out_buffer can be dirty, we clean.
Proc AnyBitsMul32Bit::
 ARGUMENTS @pAnyBits3 @nAnyBits3 @Bit32 @pAnyBits1 @nAnyBits1
 ;Local @upBorder3
 USES EBX ESI EDI

    mov eax D@nAnyBits1 | test eax 00_11111 | jne B0> | shr eax 3 | je B0>
    mov ecx D@nAnyBits3 | test ecx 00_11111 | jne B0> | shr ecx 3 | je B0>
    add eax 4 | cmp ecx eax | jb B0> ; out_buff_len check
    sub eax 4
    mov esi D@pAnyBits1 | mov edi D@pAnyBits3
    lea esi D$esi+eax-4 | lea edx D$edi+eax-4 | lea ebx D$edi+eax+4
    add ecx edi | mov edi edx | sub ecx edx
    shr ecx 2 | sub eax eax | CLD | rep stosd ; clean upper chunk only enough
    mov edi edx | mov ecx D@Bit32 | jmp L0>
B0: sub eax eax | jmp P9> ; params ERROR case

; MUL from upper dwords
L0:
    mov eax D$esi | mul ecx | mov D$edi eax | test edx edx | je L1>
    add D$edi+4 edx | jnc L1>
    lea eax D$edi+4 ; BIG-ADC ; no need upBorder check
L2: add eax 4 | add D$eax 1 | jc L2<
L1: sub edi 4 | sub esi 4 | cmp edi D@pAnyBits3 | jae L0<

L0: cmp D$ebx-4 0 | jne L0>
    sub ebx 4 | cmp ebx D@pAnyBits3 | ja L0< | add ebx 4
L0: sub ebx D@pAnyBits3 | mov eax ebx
EndP


ALIGN 4
; AnyBits = AnyBits * 32Bit ; upper dword must be 0 to exclude overflow
; returns 0 on params_Error, else size in length (dword aligned), min=4
; Bits size Must be 32Bit aligned
Proc AnyBitsMul32BitSelf::
 ARGUMENTS @pAnyBits @nAnyBits @Bit32
 USES ESI

    mov eax D@nAnyBits | test eax 00_11111 | jne B0> | shr eax 3 | je B0>
    mov esi D@pAnyBits | mov ecx D@Bit32
    lea esi D$esi+eax-4 | cmp D$esi 0 | je L0> ; upper dword = 0
B0: sub eax eax | jmp P9> ; params ERROR case

; MUL from upper dwords
L0:
    mov eax D$esi | test eax eax | je L1>
    MUL ecx | mov D$esi eax | test edx edx | je L1>
    add D$esi+4 edx | jnc L1>
    lea eax D$esi+4 ; BIG-ADC ; no need upBorder check
L2: add eax 4 | add D$eax 1 | jc L2<
L1: sub esi 4 | cmp esi D@pAnyBits | jae L0<

    mov eax D@nAnyBits | shr eax 3 | add eax D@pAnyBits
L0: cmp D$eax-4 0 | jne L0>
    sub eax 4 | cmp eax D@pAnyBits | ja L0< | add eax 4
L0: sub eax D@pAnyBits
EndP


____________________________________________________________________________________________
;;
ALIGN 16

; AnyBits1 / AnyBits2 = AnyBits3 ; Quotent becomes Reminder
; returns EAX> FALSE on params_Error, else TRUE, EDX> Has REMINDER FALSE/TRUE
; Parameters Must be 32Bit aligned
; AnyBits3_size = (AnyBits1_HighBit - AnyBits2_HighBit) up_aligned on 32;
; AnyBits3 Out_buffer can be dirty, we clean.
Proc AnyBitsDivision0::
 ARGUMENTS @pAnyBits3 @nAnyBits3 @pAnyBits2 @nAnyBits2 @pAnyBits1 @nAnyBits1
 Local @upBorder1 @upBorder2 @upBorder3 @AnyBits1Len @AnyBits2Len @HasReminder
 USES EBX ESI EDI

    mov eax D@nAnyBits1 | test eax 00_11111 | jne B0>> | shr eax 3 | je B0>>
    mov ecx D@nAnyBits2 | test ecx 00_11111 | jne B0>> | shr ecx 3 | je B0>>
    mov edx D@nAnyBits3 | test edx 00_11111 | jne B0>> | shr edx 3 | je B0>>
    mov edi D@pAnyBits3 | mov ebx D@pAnyBits1 | mov esi D@pAnyBits2
    add eax ebx | add ecx esi | add edx edi
    mov D@upBorder1 eax | mov D@upBorder2 ecx | mov D@upBorder3 edx

; search Divisor's highest bits.
L0:
    mov edx D@upBorder2
L0: sub edx 4 | cmp edx D@pAnyBits2 | jb B0>> ; Divisor can't be 0
    BSR eax D$edx | je L0< | lea ecx D$edx+4 | mov D@upBorder2 ecx ; update upBorder
    sub edx D@pAnyBits2 | lea edx D$edx*8+eax
    mov D@AnyBits2Len edx
; search Quotent's highest bits.
    mov D@HasReminder 0
    mov edx D@upBorder1
L0: sub edx 4 | cmp edx D@pAnyBits1 | jb L1> ; Quotent is 0, End.
    BSR eax D$edx | je L0< | lea ecx D$edx+4 | mov D@upBorder1 ecx ; update upBorder
    sub edx D@pAnyBits1 | lea edx D$edx*8+eax
    mov D@AnyBits1Len edx
    mov D@HasReminder 1
; calculate Divident minimum size
    sub edx D@AnyBits2Len | jb L1> ; Quotent is less then Divisor, End.
    and edx 0-32 | add edx 32 ; up_align_on 32
    cmp D@nAnyBits3 edx | jb B0>> ; less size
; clean Divident Buff
    mov ecx D@upBorder3 | sub ecx edi | sub eax eax | shr ecx 2 | CLD | rep stosd
    jmp L4>
L1:
; clean Divident Buff for quick-out case.
    mov ecx D@upBorder3 | sub ecx edi | sub eax eax | shr ecx 2 | CLD | rep stosd
    jmp L9>>

ALIGN 16
;
L4:
    mov ecx D@upBorder1
L0: sub ecx 4 ;| cmp ecx D@pAnyBits1 | jb L9>> ; quotent is 0, End. <NEVER
    BSR eax D$ecx | jne L0> | mov D@upBorder1 ecx | jmp L0< ; update upBorder
L0: sub ecx D@pAnyBits1 | lea ecx D$ecx*8+eax
    ;mov D@AnyBits1Len ecx

; find ( bit_difference -1 ) for UpShifting
L0: ;mov ecx D@AnyBits1Len |
    sub ecx D@AnyBits2Len | jbe L3>
    dec ecx ; | mov D@BitDiff ecx
    mov ebx ecx | and ecx 00_11111 | shr ebx 3 | and ebx 0-4

    mov esi D@pAnyBits2 | mov edi D@pAnyBits1 | mov edx D@pAnyBits3
; write UpShifting Value at same Bit-position in Divident
    sub eax eax | BTS eax ecx
    add D$edx+ebx eax | jnc L0> | lea edx D$edx+ebx
L2: add edx 4 | add D$edx 1 | jc L2< ; Big-ADC

; UpShift&Substract
L0:
    cmp esi D@upBorder2 | jae L4<
    LODSD | test ecx ecx | je L1>
;    sub edx edx | shld edx eax cl | shl eax cl | test edx edx | je L1> ; less fast
    mov edx eax | shl eax cl | NOP | rol edx cl | xor edx eax | je L1>
    sub D$edi+ebx eax | sbb D$edi+ebx+4 edx | jnc L5>
    lea eax D$edi+ebx+4 | jmp L2>
L1: sub D$edi+ebx eax | jnc L5>
    lea eax D$edi+ebx
L2: add eax 4 | sub D$eax 1 | jc L2< ; Big-SBB
L5: add edi 4 | jmp L0<

; last step ; if Quotent is less > End
L3: jb L9>

; here Quotent_HighBit =  divisor_HighBit. Can last substraction happen?
; Big-Comparision now
    mov ecx D@upBorder2 | mov esi D@pAnyBits1 | mov edi D@pAnyBits2
    sub ecx edi
L0:
    mov eax D$esi+ecx-4 | cmp eax D$edi+ecx-4 | jne L0>
    sub ecx 4 | jne L0<
    mov D@HasReminder 0
; Equal case
; if Quotent is less > End
L0: jb L9>

; else, we can set Divident's 1st bit, and last substraction can happen
    mov esi D@pAnyBits2 | mov edi D@pAnyBits1 | mov edx D@pAnyBits3
    add D$edx 1 | jnc L0>
L2: add edx 4 | add D$edx 1 | jc L2< ; Big-ADC
; last, direct substraction
L0:
    cmp esi D@upBorder2 | jae L9>
    LODSD
L1: sub D$edi eax | jnc L1>
    mov eax edi
L2: add eax 4 | sub D$eax 1 | jc L2< ; Big-SBB
L1: add edi 4 | jmp L0<

L9: mov edx D@HasReminder
    mov eax &TRUE | jmp P9>
B0:
   sub eax eax ; params ERROR case
EndP


ALIGN 16

; AnyBits1 MOD AnyBits2 ; Quotent becomes Reminder
; returns EAX> FALSE on params_Error, else TRUE, EDX> Has REMINDER FALSE/TRUE
; Parameters Must be 32Bit aligned
Proc AnyBitsModulus0::
 ARGUMENTS @pAnyBits2 @nAnyBits2 @pAnyBits1 @nAnyBits1
 Local @upBorder1 @upBorder2 @AnyBits1Len @AnyBits2Len @HasReminder
 USES EBX ESI EDI

    mov eax D@nAnyBits1 | test eax 00_11111 | jne B0>> | shr eax 3 | je B0>>
    mov ecx D@nAnyBits2 | test ecx 00_11111 | jne B0>> | shr ecx 3 | je B0>>

    mov ebx D@pAnyBits1 | mov esi D@pAnyBits2
    add eax ebx | add ecx esi
    mov D@upBorder1 eax | mov D@upBorder2 ecx
    CLD
; search Divisor's highest bits.
L0:
    mov edx D@upBorder2
L0: sub edx 4 | cmp edx D@pAnyBits2 | jb B0>> ; Divisor can't be 0
    BSR eax D$edx | je L0< | lea ecx D$edx+4 | mov D@upBorder2 ecx ; update upBorder
    sub edx D@pAnyBits2 | lea edx D$edx*8+eax
    mov D@AnyBits2Len edx
; search Quotent's highest bits.
    mov D@HasReminder 0
    mov edx D@upBorder1
L0: sub edx 4 | cmp edx D@pAnyBits1 | jb L9>> ; Quotent is 0, End.
    BSR eax D$edx | je L0< | lea ecx D$edx+4 | mov D@upBorder1 ecx ; update upBorder
    sub edx D@pAnyBits1 | lea edx D$edx*8+eax
    mov D@AnyBits1Len edx
    mov D@HasReminder 1
ALIGN 8
;
L4:
    mov ecx D@upBorder1
L0: sub ecx 4 ;| cmp ecx D@pAnyBits1 | jb L9>> ; quotent is 0, End. <NEVER
    BSR eax D$ecx | jne L0> | mov D@upBorder1 ecx | jmp L0< ; update upBorder
L0: sub ecx D@pAnyBits1 | lea ecx D$ecx*8+eax
    ;mov D@AnyBits1Len ecx

; find ( bit_difference -1 ) for UpShifting
L0: ;mov ecx D@AnyBits1Len |
    sub ecx D@AnyBits2Len | jbe L3>
    dec ecx ; | mov D@BitDiff ecx
    mov ebx ecx | and ecx 00_11111 | shr ebx 3 | and ebx 0-4
    mov esi D@pAnyBits2 | mov edi D@pAnyBits1

; UpShift&Substract
L0:
    cmp esi D@upBorder2 | jae L4<
    LODSD | test ecx ecx | je L1>
;    sub edx edx | shld edx eax cl | shl eax cl | test edx edx | je L1> ; less fast
    mov edx eax | shl eax cl | NOP | rol edx cl | xor edx eax | je L1>
    sub D$edi+ebx eax | sbb D$edi+ebx+4 edx | jnc L5>
    lea eax D$edi+ebx+4 | jmp L2>
L1: sub D$edi+ebx eax | jnc L5>
    lea eax D$edi+ebx
L2: add eax 4 | sub D$eax 1 | jc L2< ; Big-SBB
L5: add edi 4 | jmp L0<

; last step ; if Quotent is less > End
L3: jb L9>
; here Quotent_HighBit =  divisor_HighBit. Can last substraction happen?
; Big-Comparision now
    mov ecx D@upBorder2 | mov esi D@pAnyBits1 | mov edi D@pAnyBits2
    sub ecx edi
L0:
    mov eax D$esi+ecx-4 | cmp eax D$edi+ecx-4 | jne L0>
    sub ecx 4 | jne L0<
    mov D@HasReminder 0
; Equal case
; if Quotent is less > End
L0: jb L9>

; else, last substraction can happen
    mov esi D@pAnyBits2 | mov edi D@pAnyBits1
; last, direct substraction
L0:
    cmp esi D@upBorder2 | jae L9>
    LODSD
L1: sub D$edi eax | jnc L1>
    mov eax edi
L2: add eax 4 | sub D$eax 1 | jc L2< ; Big-SBB
L1: add edi 4 | jmp L0<

L9: mov edx D@HasReminder
    mov eax &TRUE | jmp P9>
B0:
   sub eax eax ; params ERROR case
EndP
;;

ALIGN 16

; AnyBits1 / AnyBits2 = AnyBits3 ; Quotent becomes Reminder
; returns EAX> FALSE on params_Error, else TRUE, EDX> Has REMINDER FALSE/TRUE
; Parameters Must be 32Bit aligned
; AnyBits3_size = (AnyBits1_HighBit - AnyBits2_HighBit) up_aligned on 32;
; AnyBits3 Out_buffer can be dirty, we clean.
Proc AnyBitsDivision::
 ARGUMENTS @pAnyBits3 @nAnyBits3 @pAnyBits2 @nAnyBits2 @pAnyBits1 @nAnyBits1
 Local @upBorder1 @upBorder2 @upBorder3 @AnyBits1Len @AnyBits2Len @HasReminder @DivsHi32Bits
 USES EBX ESI EDI

    mov eax D@nAnyBits1 | test eax 00_11111 | jne B0>> | shr eax 3 | je B0>>
    mov ecx D@nAnyBits2 | test ecx 00_11111 | jne B0>> | shr ecx 3 | je B0>>
    mov edx D@nAnyBits3 | test edx 00_11111 | jne B0>> | shr edx 3 | je B0>>
    mov edi D@pAnyBits3 | mov ebx D@pAnyBits1 | mov esi D@pAnyBits2
    add eax ebx | add ecx esi | add edx edi
    mov D@upBorder1 eax | mov D@upBorder2 ecx | mov D@upBorder3 edx
    CLD
; search Divisor's highest bits.
L0:
    mov edx D@upBorder2
L0: sub edx 4 | cmp edx D@pAnyBits2 | jb B0>> ; Divisor can't be 0
    BSR eax D$edx | je L0< | lea ecx D$edx+4 | mov D@upBorder2 ecx ; update upBorder
    sub edx D@pAnyBits2 | lea edx D$edx*8+eax
    mov D@AnyBits2Len edx
; extract Divisor's Hi32bits
    mov ebx D@upBorder2 | mov ecx 31 | cmp edx 32 | jae L0>
    mov eax D$ebx-4 | sub ecx edx | SHL eax CL | mov D@DivsHi32Bits eax | jmp L1>
L0: and edx 00_11111 | sub ecx edx
    mov eax D$ebx-4 | mov ebx D$ebx-8 | SHLD eax ebx CL | mov D@DivsHi32Bits eax
L1:
; search Quotent's highest bits.
    mov D@HasReminder 0
    mov edx D@upBorder1
L0: sub edx 4 | cmp edx D@pAnyBits1 | jb L1> ; Quotent is 0, End.
    BSR eax D$edx | je L0< | lea ecx D$edx+4 | mov D@upBorder1 ecx ; update upBorder
    sub edx D@pAnyBits1 | lea edx D$edx*8+eax
    mov D@AnyBits1Len edx
    mov D@HasReminder 1
; calculate Divident minimum size
    sub edx D@AnyBits2Len | jb L1> ; Quotent is less then Divisor, End.
    and edx 0-32 | add edx 32 ; up_align_on 32
    cmp D@nAnyBits3 edx | jb B0>> ; less size
; clean Divident Buff
    mov ecx D@upBorder3 | sub ecx edi | sub eax eax | shr ecx 2 | CLD | rep stosd
    jmp L4>
L1:
; clean Divident Buff for quick-out case.
    mov ecx D@upBorder3 | sub ecx edi | sub eax eax | shr ecx 2 | CLD | rep stosd
    jmp L9>>
ALIGN 16
;
L4:
    mov edx D@upBorder1
L0: sub edx 4 ;| cmp edx D@pAnyBits1 | jb L9>> ; quotent is 0, End. <NEVER
    BSR eax D$edx | jne L0> | mov D@upBorder1 edx | jmp L0< ; update upBorder
L0: sub edx D@pAnyBits1 | lea edx D$edx*8+eax
    mov D@AnyBits1Len edx

; find bit_difference for UpShifting
L0: cmp edx D@AnyBits2Len | jbe L3>>
    mov ebx D@upBorder1 | mov ecx 31 | cmp edx 32 | jae L0>
    mov eax D$ebx-4 | sub ecx edx | SHL eax CL | jmp L1>
L0: and edx 00_11111 | sub ecx edx | mov eax D$ebx-4 | mov ebx D$ebx-8 | SHLD eax ebx CL
L1: cmp D@DivsHi32Bits eax | SETAE AL | and eax 1
    mov ecx D@AnyBits1Len
    sub ecx D@AnyBits2Len
    sub ecx eax
    mov ebx ecx | and ecx 00_11111 | shr ebx 3 | and ebx 0-4

    mov esi D@pAnyBits2 | mov edi D@pAnyBits1 | mov edx D@pAnyBits3
; write UpShifting Value at same Bit-position in Divident
    sub eax eax | BTS eax ecx
    add D$edx+ebx eax | jnc L0> | lea edx D$edx+ebx
L2: add edx 4 | add D$edx 1 | jc L2< ; Big-ADC

; UpShift&Substract
L0:
    cmp esi D@upBorder2 | jae L4<<
    LODSD | test ecx ecx | je L1>
;    sub edx edx | shld edx eax cl | NOP | shl eax cl | test edx edx | je L1> ; less fast ?
    mov edx eax | shl eax cl | NOP | rol edx cl | xor edx eax | je L1>
    sub D$edi+ebx eax | sbb D$edi+ebx+4 edx | jnc L5>
    lea eax D$edi+ebx+4 | jmp L2>
L1: sub D$edi+ebx eax | jnc L5>
    lea eax D$edi+ebx
L2: add eax 4 | sub D$eax 1 | jc L2< ; Big-SBB
L5: add edi 4 | jmp L0<

; last step ; if Quotent is less > End
L3: jb L9>

; here Quotent_HighBit =  divisor_HighBit. Can last substraction happen?
; Big-Comparision now
    mov ecx D@upBorder2 | mov esi D@pAnyBits1 | mov edi D@pAnyBits2
    sub ecx edi
L0:
    mov eax D$esi+ecx-4 | cmp eax D$edi+ecx-4 | jne L0>
    sub ecx 4 | jne L0<
    mov D@HasReminder 0
; Equal case
; if Quotent is less > End
L0: jb L9>

; else, we can set Divident's 1st bit, and last substraction can happen
    mov esi D@pAnyBits2 | mov edi D@pAnyBits1 | mov edx D@pAnyBits3
    add D$edx 1 | jnc L0>
L2: add edx 4 | add D$edx 1 | jc L2< ; Big-ADC
; last, direct substraction
L0:
    cmp esi D@upBorder2 | jae L9>
    LODSD
L1: sub D$edi eax | jnc L1>
    mov eax edi
L2: add eax 4 | sub D$eax 1 | jc L2< ; Big-SBB
L1: add edi 4 | jmp L0<

L9: mov edx D@HasReminder
    mov eax &TRUE | jmp P9>
B0:
   sub eax eax ; params ERROR case
EndP


ALIGN 16

; AnyBits1 MOD AnyBits2 ; Quotent becomes Reminder
; returns EAX> FALSE on params_Error, else TRUE, EDX> Has REMINDER FALSE/TRUE
; Parameters Must be 32Bit aligned
Proc AnyBitsModulus::
 ARGUMENTS @pAnyBits2 @nAnyBits2 @pAnyBits1 @nAnyBits1
 Local @upBorder1 @upBorder2 @AnyBits1Len @AnyBits2Len @HasReminder @DivsHi32Bits
 USES EBX ESI EDI

    mov eax D@nAnyBits1 | test eax 00_11111 | jne B0>> | shr eax 3 | je B0>>
    mov ecx D@nAnyBits2 | test ecx 00_11111 | jne B0>> | shr ecx 3 | je B0>>

    mov ebx D@pAnyBits1 | mov esi D@pAnyBits2
    add eax ebx | add ecx esi
    mov D@upBorder1 eax | mov D@upBorder2 ecx
    CLD
; search Divisor's highest bits.
L0:
    mov edx D@upBorder2
L0: sub edx 4 | cmp edx D@pAnyBits2 | jb B0>> ; Divisor can't be 0
    BSR eax D$edx | je L0< | lea ecx D$edx+4 | mov D@upBorder2 ecx ; update upBorder
    sub edx D@pAnyBits2 | lea edx D$edx*8+eax
    mov D@AnyBits2Len edx
; extract Divisor's Hi32bits
    mov ebx D@upBorder2 | mov ecx 31 | cmp edx 32 | jae L0>
    mov eax D$ebx-4 | sub ecx edx | SHL eax CL | mov D@DivsHi32Bits eax | jmp L1>
L0: and edx 00_11111 | sub ecx edx
    mov eax D$ebx-4 | mov ebx D$ebx-8 | SHLD eax ebx CL | mov D@DivsHi32Bits eax
L1:
; search Quotent's highest bits.
    mov D@HasReminder 0
    mov edx D@upBorder1
L0: sub edx 4 | cmp edx D@pAnyBits1 | jb L9>> ; Quotent is 0, End.
    BSR eax D$edx | je L0< | lea ecx D$edx+4 | mov D@upBorder1 ecx ; update upBorder
    sub edx D@pAnyBits1 | lea edx D$edx*8+eax
    mov D@AnyBits1Len edx ;| cmp D@AnyBits2Len edx | ja L9>> ; Divisor > Quotent, End.
    mov D@HasReminder 1
ALIGN 8
;
L4:
    mov edx D@upBorder1
L0: sub edx 4 ;| cmp edx D@pAnyBits1 | jb L9>> ; quotent is 0, End. <NEVER
    BSR eax D$edx | jne L0> | mov D@upBorder1 edx | jmp L0< ; update upBorder
L0: sub edx D@pAnyBits1 | lea edx D$edx*8+eax
    mov D@AnyBits1Len edx

; find bit_difference for UpShifting
L0: cmp edx D@AnyBits2Len | jbe L3>>
    mov ebx D@upBorder1 | mov ecx 31 | cmp edx 32 | jae L0>
    mov eax D$ebx-4 | sub ecx edx | SHL eax CL | jmp L1>
L0: and edx 00_11111 | sub ecx edx | mov eax D$ebx-4 | mov ebx D$ebx-8 | SHLD eax ebx CL
L1: cmp D@DivsHi32Bits eax | SETAE AL | and eax 1
    mov ecx D@AnyBits1Len
    sub ecx D@AnyBits2Len
    sub ecx eax
    mov ebx ecx | and ecx 00_11111 | shr ebx 3 | and ebx 0-4
    mov esi D@pAnyBits2 | mov edi D@pAnyBits1

; UpShift&Substract
L0:
    cmp esi D@upBorder2 | jae L4<
    LODSD | test ecx ecx | je L1>
;    sub edx edx | shld edx eax cl | NOP | shl eax cl | test edx edx | je L1> ; less fast ?
    mov edx eax | shl eax cl | NOP | rol edx cl | xor edx eax | je L1>
    sub D$edi+ebx eax | sbb D$edi+ebx+4 edx | jnc L5>
    lea eax D$edi+ebx+4 | jmp L2>
L1: sub D$edi+ebx eax | jnc L5>
    lea eax D$edi+ebx
L2: add eax 4 | sub D$eax 1 | jc L2< ; Big-SBB
L5: add edi 4 | jmp L0<

; last step ; if Quotent is less > End
L3: jb L9>
; here Quotent_HighBit =  divisor_HighBit. Can last substraction happen?
; Big-Comparision now
    mov ecx D@upBorder2 | mov esi D@pAnyBits1 | mov edi D@pAnyBits2
    sub ecx edi
L0:
    mov eax D$esi+ecx-4 | cmp eax D$edi+ecx-4 | jne L0>
    sub ecx 4 | jne L0<
    mov D@HasReminder 0
; Equal case
; if Quotent is less > End
L0: jb L9>

; else, last substraction can happen
    mov esi D@pAnyBits2 | mov edi D@pAnyBits1
; last, direct substraction
L0:
    cmp esi D@upBorder2 | jae L9>
    LODSD
L1: sub D$edi eax | jnc L1>
    mov eax edi
L2: add eax 4 | sub D$eax 1 | jc L2< ; Big-SBB
L1: add edi 4 | jmp L0<

L9: mov edx D@HasReminder
    mov eax &TRUE | jmp P9>
B0:
   sub eax eax ; params ERROR case
EndP


ALIGN 16

; for Bits above 32bit size! > size in bytes
; AnyBits1 MOD AnyBits2 ; Quotent becomes Reminder
; returns EAX> FALSE on params_Error, else TRUE, EDX> Has REMINDER FALSE/TRUE
; Parameters Must be 4Byte aligned
Proc AnyBitsModulusGrand::
 ARGUMENTS @pAnyBits2 @nAnyBits2Bytes @pAnyBits1 @nAnyBits1Bytes
 Local @upBorder1 @upBorder2 @AnyBits1BytesLen @AnyBits1Len32 @AnyBits2BytesLen @AnyBits2Len32 @HasReminder @DivsHi32Bits
 USES EBX ESI EDI

    mov eax D@nAnyBits1Bytes | test eax 00_11 | jne B0>> | cmp eax 0 | jle B0>>
    mov ecx D@nAnyBits2Bytes | test ecx 00_11 | jne B0>> | cmp ecx 0 | jle B0>>

    mov ebx D@pAnyBits1 | mov esi D@pAnyBits2
    add eax ebx | add ecx esi
    mov D@upBorder1 eax | mov D@upBorder2 ecx
    CLD
; search Divisor's highest bits.
L0:
    mov edx D@upBorder2
L0: sub edx 4 | cmp edx D@pAnyBits2 | jb B0>> ; Divisor can't be 0
    BSR eax D$edx | je L0< | lea ecx D$edx+4 | mov D@upBorder2 ecx ; update upBorder
    sub edx D@pAnyBits2 | mov D@AnyBits2BytesLen edx | mov D@AnyBits2Len32 eax
    mov edx eax
; extract Divisor's Hi32bits
    mov ebx D@upBorder2 | mov ecx 31 | cmp D@AnyBits2BytesLen 4 | jae L0>
    mov eax D$ebx-4 | sub ecx edx | SHL eax CL | mov D@DivsHi32Bits eax | jmp L1>
L0: sub ecx edx
    mov eax D$ebx-4 | mov ebx D$ebx-8 | SHLD eax ebx CL | mov D@DivsHi32Bits eax
L1:
; search Quotent's highest bits.
    mov D@HasReminder 0
    mov edx D@upBorder1
L0: sub edx 4 | cmp edx D@pAnyBits1 | jb L9>> ; Quotent is 0, End.
    BSR eax D$edx | je L0< | lea ecx D$edx+4 | mov D@upBorder1 ecx ; update upBorder
    sub edx D@pAnyBits1 | mov D@AnyBits1BytesLen edx | mov D@AnyBits1Len32 eax
    mov D@HasReminder 1
NOP | NOP ;ALIGN
;
L4:
    mov edx D@upBorder1
L0: sub edx 4
    BSR eax D$edx | jne L0> | mov D@upBorder1 edx | jmp L0< ; update upBorder
L0: sub edx D@pAnyBits1 | mov D@AnyBits1BytesLen edx | mov D@AnyBits1Len32 eax

; find bit_difference for UpShifting
L0: cmp edx D@AnyBits2BytesLen | jb L3>> | ja L0>
    cmp eax D@AnyBits2Len32 | jbe L3>>
L0: mov edx eax
    mov ebx D@upBorder1 | mov ecx 31 | cmp D@AnyBits2BytesLen 4 | jae L0>
    mov eax D$ebx-4 | sub ecx edx | SHL eax CL | jmp L1>
L0: sub ecx edx | mov eax D$ebx-4 | mov ebx D$ebx-8 | SHLD eax ebx CL
L1: cmp D@DivsHi32Bits eax | SETAE AL | and eax 1
    mov ecx D@AnyBits1Len32
    sub ecx D@AnyBits2Len32
    sub ecx eax | jns L0> | add ecx 32 | sub D@AnyBits1BytesLen 4
L0: mov ebx D@AnyBits1BytesLen | sub ebx D@AnyBits2BytesLen
    mov esi D@pAnyBits2 | mov edi D@pAnyBits1

; UpShift&Substract
L0:
    cmp esi D@upBorder2 | jae L4<<
    LODSD | test ecx ecx | je L1>
;    sub edx edx | shld edx eax cl | NOP | shl eax cl | test edx edx | je L1> ; less fast ?
    mov edx eax | shl eax cl | NOP | rol edx cl | xor edx eax | je L1>
    sub D$edi+ebx eax | sbb D$edi+ebx+4 edx | jnc L5>
    lea eax D$edi+ebx+4 | jmp L2>
L1: sub D$edi+ebx eax | jnc L5>
    lea eax D$edi+ebx
L2: add eax 4 | sub D$eax 1 | jc L2< ; Big-SBB
L5: add edi 4 | jmp L0<

; last step ; if Quotent is less > End
L3: jb L9>
; here Quotent_HighBit =  divisor_HighBit. Can last substraction happen?
; Big-Comparision now
    mov ecx D@upBorder2 | mov esi D@pAnyBits1 | mov edi D@pAnyBits2
    sub ecx edi
L0:
    mov eax D$esi+ecx-4 | cmp eax D$edi+ecx-4 | jne L0>
    sub ecx 4 | jne L0<
; Equal case
    mov D@HasReminder 0
; if Quotent is less > End
L0: jb L9>

; else, last substraction can happen
    mov esi D@pAnyBits2 | mov edi D@pAnyBits1
; last, direct substraction
L0:
    cmp esi D@upBorder2 | jae L9>
    LODSD
L1: sub D$edi eax | jnc L1>
    mov eax edi
L2: add eax 4 | sub D$eax 1 | jc L2< ; Big-SBB
L1: add edi 4 | jmp L0<

L9: mov edx D@HasReminder
    mov eax &TRUE | jmp P9>
B0:
   sub eax eax ; params ERROR case
EndP


ALIGN 16

; AnyBits MOD (2^n)-1; Quotent becomes Reminder
; returns EAX> FALSE on params_Error, else TRUE, EDX> Has REMINDER FALSE/TRUE
; Parameters Must be 32Bit aligned
Proc AnyBitsModulusOn2pNm1::
 ARGUMENTS @pAnyBits2 @nAnyBits2 @pAnyBits1 @nAnyBits1
 Local @upBorder1 @upBorder2 @AnyBits1Len @AnyBits2Len @HasReminder
 USES EBX ESI EDI

    mov eax D@nAnyBits1 | test eax 00_11111 | jne B0>> | shr eax 3 | je B0>>
    mov ecx D@nAnyBits2 | test ecx 00_11111 | jne B0>> | shr ecx 3 | je B0>>

    mov ebx D@pAnyBits1 | mov esi D@pAnyBits2
    add eax ebx | add ecx esi
    mov D@upBorder1 eax | mov D@upBorder2 ecx
    CLD
; search Divisor's highest bits.
L0:
    mov edx D@upBorder2
L0: sub edx 4 | cmp edx D@pAnyBits2 | jb B0>> ; Divisor can't be 0
    BSR eax D$edx | je L0< | lea ecx D$edx+4 | mov D@upBorder2 ecx ; update upBorder
    sub edx D@pAnyBits2 | lea edx D$edx*8+eax
    mov D@AnyBits2Len edx
; search Quotent's highest bits.
    mov D@HasReminder 0
    mov edx D@upBorder1
L0: sub edx 4 | cmp edx D@pAnyBits1 | jb L9>> ; Quotent is 0, End.
    BSR eax D$edx | je L0< | lea ecx D$edx+4 | mov D@upBorder1 ecx ; update upBorder
    sub edx D@pAnyBits1 | lea edx D$edx*8+eax
    mov D@AnyBits1Len edx
    mov D@HasReminder 1
    mov edx D@pAnyBits1
;
L4:
    mov ecx D@upBorder1
L0: sub ecx 4 ;| cmp ecx D@pAnyBits1 | jb L9>> ; quotent is 0, End. ?
    BSR eax D$ecx | jne L0> | mov D@upBorder1 ecx | jmp L0< ; update upBorder

L0: sub ecx D@pAnyBits1 | lea ecx D$ecx*8+eax
    ;mov D@AnyBits1Len ecx
    cmp ecx D@AnyBits2Len | jbe L3>
; remove heading BIT
    BTR D$edx ecx
    sub ecx D@AnyBits2Len
    dec ecx
    mov ebx ecx | and ecx 00_11111 | shr ebx 3 | and ebx 0-4
; add BIT below
    sub eax eax | BTS eax ecx
    add D$edx+ebx eax | jnc L4<
    lea eax D$edx+ebx
L2: add eax 4 | add D$eax 1 | jc L2< ; Big-ADC
    jmp L4<

; last step ; if Quotent is less > End
L3: jb L9>
; here Quotent_HighBit =  divisor_HighBit. Can last substraction happen?
; Big-Comparision now
    mov ecx D@upBorder2 | mov esi D@pAnyBits1 | mov edi D@pAnyBits2
    sub ecx edi
L0:
    mov eax D$esi+ecx-4 | cmp eax D$edi+ecx-4 | jne L0>
    sub ecx 4 | jne L0<
    mov D@HasReminder 0
; Equal case
; if Quotent is less > End
L0: jb L9>

; else, last substraction can happen
    mov esi D@pAnyBits2 | mov edi D@pAnyBits1
; last, direct substraction
L0:
    cmp esi D@upBorder2 | jae L9>
    LODSD
L1: sub D$edi eax | jnc L1>
    mov eax edi
L2: add eax 4 | sub D$eax 1 | jc L2< ; Big-SBB
L1: add edi 4 | jmp L0<

L9: mov edx D@HasReminder
    mov eax &TRUE | jmp P9>
B0:
   sub eax eax ; params ERROR case
EndP



; AnyBits MOD (2^N)+1 ; Quotent becomes Reminder
; returns EAX> FALSE on params_Error, else TRUE, EDX> Has REMINDER FALSE/TRUE
; AnyBitsSz Must be Dword aligned
Proc AnyBitsModulusOn2pNp1::
 ARGUMENTS @ExponentOf2 @pAnyBits @AnyBitsSz
 Local @upBorder1 @AnyBits1Len @FnHi @FmHiLoDiff @FnBitsLen @HasReminder
 USES EBX ESI EDI

    mov eax D@AnyBitsSz | test eax eax | jle B0>> | test eax 00_11 | jne B0>>
    mov ebx D@pAnyBits
    add eax ebx
    mov D@upBorder1 eax
L0:
    mov ecx D@ExponentOf2 | cmp ecx 0FFFFFFDF | ja B0>> ; max Highest Bit
    cmp ecx 32 | jae L0>
;    cmp ecx 0 | je L9>> ; Divisor=1
    mov ebx 1 |  BTS ebx ecx
    mov eax D@AnyBitsSz | shl eax 3
    call AnyBitsMod32Bit D@pAnyBits eax ebx | test eax eax | je B0>>
    mov edi D@pAnyBits, ecx D@AnyBitsSz | CLD | SHR ecx 2 | sub eax eax | REP STOSD
    mov edi D@pAnyBits, D$edi edx | neg edx | sbb edx edx | and edx 1
    mov D@HasReminder edx | jmp L9>>
L0: mov D@FnBitsLen ecx
    mov ebx ecx | and ecx 00_11111 | shr ebx 3 | and ebx 0-4 | mov D@FmHiLoDiff ebx
    sub eax eax | BTS eax ecx | mov D@FnHi eax ; High bit's dword

; search Quotent's highest bits.
    mov D@HasReminder 0
    mov edx D@upBorder1
L0: sub edx 4 | cmp edx D@pAnyBits | jb L9>> ; Quotent is 0, End.
    BSR eax D$edx | je L0<
    lea ecx D$edx+4 | mov D@upBorder1 ecx ; update upBorder
    sub edx D@pAnyBits | lea edx D$edx*8+eax
    mov D@AnyBits1Len edx
    mov D@HasReminder 1
;
L4:
    mov ecx D@upBorder1
L0: sub ecx 4
    BSR eax D$ecx | jne L0> | mov D@upBorder1 ecx | jmp L0< ; update upBorder
L0: sub ecx D@pAnyBits | lea ecx D$ecx*8+eax
    ;mov D@AnyBits1Len ecx

; find ( bit_difference -1 ) for UpShifting
L0: ;mov ecx D@AnyBits1Len |
    sub ecx D@FnBitsLen | jbe L3>>
    dec ecx
    mov ebx ecx | and ecx 00_11111 | shr ebx 3 | and ebx 0-4
    mov edi D@pAnyBits

; UpShift&Substract
    mov eax 1
    shl eax cl
    sub D$edi+ebx eax | jnc L5>
    lea eax D$edi+ebx
L2: add eax 4 | sub D$eax 1 | jc L2< ; Big-SBB

L5: add ebx D@FmHiLoDiff
    mov eax D@FnHi | test ecx ecx | je L1>
    mov edx eax | shl eax cl | NOP | rol edx cl | xor edx eax | je L1>
    sub D$edi+ebx eax | sbb D$edi+ebx+4 edx | jnc L5>
    lea eax D$edi+ebx+4 | jmp L2>
L1: sub D$edi+ebx eax | jnc L4<
    lea eax D$edi+ebx
L2: add eax 4 | sub D$eax 1 | jc L2< ; Big-SBB
 L5: jmp L4<<

; last step ; if Quotent is less > End
L3: jb L9>
; here Quotent_HighBit =  divisor_HighBit. Can last substraction happen?
; Big-Comparision now
    mov ecx D@FmHiLoDiff | add ecx 4
    mov esi D@pAnyBits
    cmp D$esi+ecx-4 1 | jne L0> | jmp L1>
L0:
    cmp D$esi+ecx-4 0 | jne L0>
L1: sub ecx 4 | cmp ecx 4 | ja L0<
    cmp D$esi+ecx-4 1 | jne L0>
    mov D@HasReminder 0
; Equal case
; if Quotent is less > End
L0: jb L9>

; else, last substraction can happen
    mov edi D@pAnyBits
    sub D$edi 1 | jnc L1>
    mov eax edi
L2: add eax 4 | sub D$eax 1 | jc L2< ; Big-SBB

L1: mov edi D@upBorder1 | mov eax D@FnHi | sub edi 4
    sub D$edi eax | jnc L1>
    mov eax edi ; must not happen!
L2: add eax 4 | sub D$eax 1 | jc L2< ; Big-SBB
L1:

L9: mov edx D@HasReminder
    mov eax &TRUE | jmp P9>
B0:
   sub eax eax ; ERROR case
EndP



; returns &FALSE on params_Error, else: eax=&TRUE, edx=Reminder
; Parameters Must be 32Bit aligned
; Quotent becomes Divident
Proc AnyBitsDiv32Bit::
 ARGUMENTS @pAnyBits @nBits @Bit32
 USES ESI EDI

; AnyBitNum must be DWORD (32bit) aligned; Divisor can't be 0;
    sub eax eax
    mov edx D@nBits | test edx 00_11111 | jne P9> | shr edx 3 | je P9>
    mov ecx D@Bit32 | test ecx ecx | je P9>

    mov esi D@pAnyBits | mov edi esi | lea esi D$esi+edx-4

L0: sub edx edx | mov eax D$esi | test eax eax | jne L3>
    sub esi 4 | cmp esi edi | jae L0< | jmp L0> ; Quotent is 0
L1:
    mov eax D$esi
L3:
    div ecx | mov D$esi eax
    sub esi 4 | cmp esi edi | jae L1<

L0: mov eax 1; EDX=Mod32
EndP


; returns &FALSE on params_Error, else: eax=&TRUE, edx=Reminder
; Parameters Must be 32Bit aligned
; Do not modifies Quotent
Proc AnyBitsMod32Bit::
 ARGUMENTS @pAnyBits @nBits @Bit32
 USES ESI EDI

; AnyBitNum must be DWORD (32bit) aligned; Divisor can't be 0;
    sub eax eax
    mov edx D@nBits | test edx 00_11111 | jne P9> | shr edx 3 | je P9>
    mov ecx D@Bit32 | test ecx ecx | je P9>

    mov esi D@pAnyBits | mov edi esi | lea esi D$esi+edx-4

L0: sub edx edx | mov eax D$esi | test eax eax | jne L3>
    sub esi 4 | cmp esi edi | jae L0< | jmp L0> ; Quotent is 0
L1:
    mov eax D$esi
L3:
    div ecx
    sub esi 4 | cmp esi edi | jae L1<

L0: mov eax 1; EDX=Mod32
EndP


; AnyBitsSHL
; nBitsShift < nBits
; nBits can byte aligned?!
; nBits => 32
Proc AnyBitsShiftLeft::
 ARGUMENTS @pAnyBits @nBits @nBitsShift
 USES EBX ESI EDI

    sub eax eax
    mov edi D@nBits | test edi 00_111 | jne P9>> ; should we check byte ALIGN or dword ALIGN?
    cmp edi 32 | jb P9>> ; hey! not less then 32bit
    mov edx D@nBitsShift | cmp edx edi | jae P9>> ; nBitsShift < nBits
    cmp edx 0 | je L9>>

    mov ecx edx | shr edx 3 | shr edi 3
    mov ebx D@pAnyBits | add edi ebx ; EBX will LowBorder ; EDI is at UpBorder
    mov esi edi | sub esi edx | and ecx 7 | je L3>> ; goto simple byte moving
    sub esi 1 | jmp L1>
ALIGN 16
; from 5 byte will build 32bits of EAX ;
L0:
    mov eax D$esi+1 | movzx edx B$esi
    shl eax cl | shl edx cl | or al dh
    mov D$edi eax
L1: sub edi 4 | sub esi 4 | cmp esi ebx | jae L0<

    mov eax ebx | sub eax esi
    cmp eax 1 | jne L1>
; -1 below LowBorder
    mov eax D$esi+1 | shl eax cl | mov D$edi eax
    jmp L2>
L1: cmp eax 2 | jne L1>
; -2
    add edi 1 | mov eax D$esi+2 | shl eax 8 | shl eax cl | mov B$edi ah | shr eax 16 | mov W$edi+1 ax
    jmp L2>
L1: cmp eax 3 | jne L1>
; -3
    add edi 2 | movzx eax W$esi+3 | shl eax 16 | shl eax cl | shr eax 16 | mov W$edi ax
    jmp L2>
L1: ;cmp eax 4 ;| jne L1>
; -4
    add edi 3 | movzx eax B$esi+4 | shl eax 24 | shl eax cl | shr eax 24 | mov B$edi al
;    jmp L2>

; wipe below bits
L2: mov ecx edi | mov edi ebx | sub ecx ebx | jle L9>
    sub eax eax | CLD | REP STOSB | jmp L9>

; simple byte moving, then wiping of below bits
L3: mov ecx esi | sub ecx ebx | dec esi | dec edi | STD | REP MOVSB | CLD
    inc edi | mov ecx edi | mov edi ebx | sub ecx ebx | jle L9> | sub eax eax | REP STOSB ;| jmp L9>

L9: mov eax 1
EndP


; AnyBits1SHL returns False on error, Highest bit -> EDX & C-flag
; nBits Dword aligned
; nBits => 32
Proc AnyBitsShift1Left::
 ARGUMENTS @pAnyBits @nBits
; USES EBX ESI EDI

    sub eax eax
    mov ecx D@nBits | test ecx 00_11111 | jne P9> ; dword ALIGN
    cmp ecx 32 | jb P9> ; not less then 32bit
    shr ecx 3
    mov eax D@pAnyBits | add ecx eax ; EAX LowBorder ; ECX UpBorder
    sub edx edx | sub ecx 4 | SHL D$ecx 1 | adc edx 0 ; save Highest bit
L0:
    sub ecx 4 | cmp ecx eax | jb L0>
    SHL D$ecx 1 | jnc L0< | or D$ecx+4 1 | jmp L0<
L0: neg edx ; set EDX & C-flag
    mov eax 1
EndP

; AnyBits1SHR returns False on error, Lowest bit -> EDX & C-flag
; nBits Dword aligned
; nBits => 32
Proc AnyBitsShift1Right::
 ARGUMENTS @pAnyBits @nBits
; USES EBX ESI EDI

    sub eax eax
    mov ecx D@nBits | test ecx 00_11111 | jne P9> ; dword ALIGN
    cmp ecx 32 | jb P9> ; not less then 32bit
    shr ecx 3
    mov eax D@pAnyBits | add ecx eax ; EAX LowBorder ; ECX UpBorder
    sub edx edx | SHR D$eax 1 | adc edx 0 ; save Lowest bit
L0:
    add eax 4 | cmp eax ecx | jae L0>
    SHR D$eax 1 | jnc L0< | or D$eax-4 080000000 | jmp L0<
L0: neg edx ; set EDX & C-flag
    mov eax 1
EndP


; AnyBitsSHR
; nBitsShift < nBits
; nBits can byte aligned?!
; nBits => 32
Proc AnyBitsShiftRight::
 ARGUMENTS @pAnyBits @nBits @nBitsShift
 USES EBX ESI EDI

    sub eax eax
    mov esi D@nBits | test esi 00_111 | jne P9>> ; should we check byte ALIGN or dword ALIGN?
    cmp esi 32 | jb P9>> ; hey! not less then 32bit
    mov edx D@nBitsShift | cmp edx esi | jae P9>> ; nBitsShift < nBits
    cmp edx 0 | je L9>>

    mov ecx edx | shr edx 3 | shr esi 3
    mov edi D@pAnyBits | mov ebx edi | add ebx esi ; EBX will UpBorder, EDI is at LowBorder
    mov esi edi | add esi edx | and ecx 00_0111 | je L3>> ; goto simple byte moving
    sub edi 4 | add esi 1 | jmp L1>
ALIGN 16
; from 5 byte will build 32bits of EAX ;
L0:
    mov eax D$esi-5 | movzx edx B$esi-1
    shr eax cl | ror edx cl | and edx 0FF000000 | or eax edx
    mov D$edi eax
L1: add edi 4 | add esi 4 | cmp esi ebx | jbe L0<

    mov eax esi | sub eax ebx
    cmp eax 1 | jne L1>
; +1 over UpBorder
    mov eax D$esi-5 | shr eax cl | mov D$edi eax | add edi 4
    jmp L2>
L1: cmp eax 2 | jne L1>
; +2
    mov eax D$esi-6 | shr eax 8 | shr eax cl | mov W$edi ax | shr eax 16 | mov B$edi+2 al | add edi 3
    jmp L2>
L1: cmp eax 3 | jne L1>
; +3
    movzx eax W$esi-5 | shr eax cl | mov W$edi ax | add edi 2
    jmp L2>
L1: ;cmp eax 4 ;| jne L1>
; +4
    movzx eax B$esi-5 | shr eax cl | mov B$edi al | add edi 1
;    jmp L2>

; wipe upper bits
L2: mov ecx ebx | sub ecx edi | jle L9>
    sub eax eax | CLD | REP STOSB | jmp L9>

; simple byte moving, then wiping of upper bits
L3: mov ecx ebx | sub ecx esi | CLD | REP MOVSB
    mov ecx ebx | sub ecx edi | jle L9> | sub eax eax | REP STOSB ;| jmp L9>

L9: mov eax 1
EndP


; Rotate Bytes array UP
; nRotate < nBytes
Proc RotateBytesUP::
 ARGUMENTS @pBytes @nBytes @nRotate
 USES EBX ESI EDI

    sub eax eax | mov edi D@pBytes, ecx D@nBytes, edx D@nRotate
    test ecx ecx | jle P9> | cmp edx ecx | jae P9> | cmp edx 0 | je L9>
 ; ESI upBorder
    lea esi D$edi+ecx | jmp L2>

L0: dec ecx | je L9>
    mov ah B$edi | mov B$edi al
L1: mov al ah
    add edi edx | cmp edi esi | jb L0<
    sub edi D@nBytes | cmp ebx edi | jne L0<
    mov B$edi al | dec ecx | je L9>
    inc edi
L2: mov ah B$edi | mov ebx edi | jmp L1<

L9: mov eax 1
EndP


; AnyBitsROL
; nBitsShift < nBits
; nBits can byte aligned?!
; nBits => 32
Proc AnyBitsRotateLeft::
 ARGUMENTS @pAnyBits @nBits @nBitsShift
 Local @HighBitsSave
 USES EBX ESI EDI

    sub eax eax
    mov edi D@nBits | test edi 00_111 | jne P9>> ; byte ALIGN
    cmp edi 32 | jb P9>> ; hey! not less then 32bit
    mov edx D@nBitsShift | cmp edx edi | jae P9>> ; nBitsShift < nBits
    cmp edx 0 | je L9>>

    mov ebx D@pAnyBits
    shr edi 3 | shr edx 3 | je L0>
    call RotateBytesUP ebx, edi, edx | test eax eax | je P9>>
L0:
    mov ecx D@nBitsShift | and ecx 00_0111 | je L9>> ; bytes rotated alrady
    add edi ebx ; EBX will LowBorder ; EDI is at UpBorder
    mov esi edi
; save HIGH bits
    movzx eax B$edi-1 | shl eax cl | shr eax 8 | mov D@HighBitsSave eax
    sub esi 1 | jmp L1>

ALIGN 16
; from 5 byte will build 32bits of EAX ;
L0:
    mov eax D$esi+1 | movzx edx B$esi
    shl eax cl | shl edx cl | or al dh
    mov D$edi eax
L1: sub edi 4 | sub esi 4 | cmp esi ebx | jae L0<

    mov eax ebx | sub eax esi
    cmp eax 1 | jne L1>
; -1 below LowBorder
    mov eax D$esi+1 | shl eax cl | mov D$edi eax
    jmp L2>
L1: cmp eax 2 | jne L1>
; -2
    add edi 1 | mov eax D$esi+2 | shl eax 8 | shl eax cl | mov B$edi ah | shr eax 16 | mov W$edi+1 ax
    jmp L2>
L1: cmp eax 3 | jne L1>
; -3
    add edi 2 | movzx eax W$esi+3 | shl eax 16 | shl eax cl | shr eax 16 | mov W$edi ax
    jmp L2>
L1: ;cmp eax 4 ;| jne L1>
; -4
    add edi 3 | movzx eax B$esi+4 | shl eax 24 | shl eax cl | shr eax 24 | mov B$edi al
;    jmp L2>

; wipe below bits
L2: ;mov ecx edi | mov edi ebx | sub ecx ebx | jle L0>
    ;sub eax eax | CLD | REP STOSB
; write saved high bits
L0: mov eax D@HighBitsSave | or B$ebx al

L9: mov eax 1
EndP


; Rotate Bytes array DOWN
; nRotate < nBytes
Proc RotateBytesDOWN::
 ARGUMENTS @pBytes @nBytes @nRotate
 USES EBX ESI EDI

    sub eax eax | mov esi D@pBytes, ecx D@nBytes, edx D@nRotate
    test ecx ecx | jle P9> | cmp edx ecx | jae P9> | cmp edx 0 | je L9>

    lea edi D$esi+ecx-1 | jmp L2>

L0: dec ecx | je L9>
    mov ah B$edi | mov B$edi al
L1: mov al ah
    sub edi edx | cmp edi esi | jae L0<
    add edi D@nBytes | cmp ebx edi | jne L0<
    mov B$edi al | dec ecx | je L9>
    dec edi
L2: mov ah B$edi | mov ebx edi | jmp L1<

L9: mov eax 1
EndP


; AnyBitsROR
; nBitsShift < nBits
; nBits can byte aligned?!
; nBits => 32
Proc AnyBitsRotateRight::
 ARGUMENTS @pAnyBits @nBits @nBitsShift
 Local @LowBitsSave
 USES EBX ESI EDI

    sub eax eax
    mov esi D@nBits | test esi 00_111 | jne P9>> ; byte ALIGN
    cmp esi 32 | jb P9>> ; hey! not less then 32bit
    mov edx D@nBitsShift | cmp edx esi | jae P9>> ; nBitsShift < nBits
    cmp edx 0 | je L9>>

    mov edi D@pAnyBits
    shr esi 3 | shr edx 3 | je L0>
    call RotateBytesDOWN edi, esi, edx | test eax eax | je P9>>
L0:
    mov ecx D@nBitsShift | and ecx 00_0111 | je L9>> ; bytes rotated alrady
    mov ebx edi | add ebx esi ; EBX will UpBorder, EDI is at LowBorder
    mov esi edi
; save LOW bits
    movzx eax B$edi | shl eax 8 | shr eax cl | and eax 0FF | mov D@LowBitsSave eax
    sub edi 4 | add esi 1 | jmp L1>

ALIGN 16
; from 5 byte will build 32bits of EAX ;
L0:
    mov eax D$esi-5 | movzx edx B$esi-1
    shr eax cl | ror edx cl | and edx 0FF000000 | or eax edx
    mov D$edi eax
L1: add edi 4 | add esi 4 | cmp esi ebx | jbe L0<

    mov eax esi | sub eax ebx
    cmp eax 1 | jne L1>
; +1 over UpBorder
    mov eax D$esi-5 | shr eax cl | mov D$edi eax | add edi 4
    jmp L2>
L1: cmp eax 2 | jne L1>
; +2
    mov eax D$esi-6 | shr eax 8 | shr eax cl | mov W$edi ax | shr eax 16 | mov B$edi+2 al | add edi 3
    jmp L2>
L1: cmp eax 3 | jne L1>
; +3
    movzx eax W$esi-5 | shr eax cl | mov W$edi ax | add edi 2
    jmp L2>
L1: ;cmp eax 4 ;| jne L1>
; +4
    movzx eax B$esi-5 | shr eax cl | mov B$edi al | add edi 1
;    jmp L2>

; wipe upper bits
L2: ;mov ecx ebx | sub ecx edi | jle L0>
    ;sub eax eax | CLD | REP STOSB
; write saved low bits
L0: mov eax D@LowBitsSave | or B$ebx-1 al

L9: mov eax 1
EndP

; EAX=BITsz EDX=pBITs
GetEffectiveHighBitSz32::
    shr eax 3 | add eax edx
L0: sub eax 4 | cmp eax edx | jb L0> ; AnyBits is 0 -> 32BIT.
    cmp D$eax 0 | je L0<
    add eax 4 | sub eax edx | shl eax 3
    ret
L0: mov eax 32 | ret

; returns EAX=HighestBitPosition, on params error: 0-1 in EAX:EDX
Proc GetHighestBitPosition::
 ARGUMENTS @pBits @nBits
    sub eax eax
    mov ecx D@pBits, edx D@nBits | test edx 00_0001_1111 | jne L1>
    shr edx 3 | je L1>
    lea edx D$ecx+edx
L0: sub edx 4 | cmp edx ecx | jb P9>
    BSR eax D$edx | je L0<
    sub edx ecx | lea eax D$edx*8+eax | jmp P9>
L1: or eax 0-1 | or edx 0-1
EndP



; exchange Bits. Highest position bit <-> Lowest bit;
; nAnybits 32bit aligned
Proc AnyBitsSwapBits::
 ARGUMENTS @pAnybitsOut @pAnybitsIn @nAnybits
 USES ebx

    mov edx D@nAnybits | test edx 00_11111 | je L0>
    sub eax eax | jmp P9>
L0: dec edx
    sub ecx ecx
    mov ebx D@pAnybitsIn
    mov eax D@pAnybitsOut
L0:
    BT D$ebx edx | jc L1> | BTR D$eax ecx | jmp L2>
L1: BTS D$eax ecx
L2: add ecx 1 | sub edx 1 | jnc L0<
    mov eax 1
EndP


; exchange Bits. Highest bit <-> Lowest bit;
; nAnybits 32bit aligned
Proc AnyBitsSwapBitsSelf::
 ARGUMENTS @pAnybits @nAnybits
 USES ebx

    mov edx D@nAnybits | test edx 00_11111 | je L0>
    sub eax eax | jmp P9>
L0: dec edx
    sub eax eax | sub ecx ecx
    mov ebx D@pAnybits
L0:
    BT D$ebx ecx | SETC AL ; Lo bit
    BT D$ebx edx | SETC AH ; Hi bit
    cmp eax 0 | je L3> ; skip on similar bits
    cmp eax 0101 | je L3>
; case 01-00
    cmp eax 01 | je L2>
    BTR D$ebx edx | BTS D$ebx ecx | jmp L3>
; case 00-01
L2: BTS D$ebx edx | BTR D$ebx ecx
L3: inc ecx | dec edx | cmp ecx edx | jb L0<
    mov eax 1
EndP


; exchange Bits. Highest(active!) bit <-> Lowest bit;
; nAnybits 32bit aligned
Proc AnyBitsSwapBitsHi2Lo::
 ARGUMENTS @pAnybitsOut @pAnybitsIn @nAnybits
 USES edi

    call GetHighestBitPosition D@pAnybitsIn D@nAnybits | cmp edx 0-1 | jne L0>
    sub eax eax | jmp P9>
L0: mov edx eax
    mov ecx D@nAnybits | mov edi D@pAnybitsOut ; cleanUp bits above Hi
    SHR ecx 3 | SHR eax 3 | add edi eax | sub ecx eax
    sub eax eax | CLD | REP STOSB
    mov edi D@pAnybitsIn
    mov eax D@pAnybitsOut
    sub ecx ecx
L0:
    BT D$edi edx | jc L1> | BTR D$eax ecx | jmp L2>
L1: BTS D$eax ecx
L2: add ecx 1 | sub edx 1 | jnc L0<
    mov eax 1
EndP


; exchange Bits. Highest(active!) bit <-> Lowest bit;
; nAnybits 32bit aligned
Proc AnyBitsSwapBitsHi2LoSelf::
 ARGUMENTS @pAnybits @nAnybits
 USES ebx

    call GetHighestBitPosition D@pAnybits D@nAnybits | cmp edx 0-1 | jne L0>
    sub eax eax | jmp P9>
L0: mov edx eax
    sub eax eax | sub ecx ecx
    mov ebx D@pAnybits
L0:
    BT D$ebx ecx | SETC AL ; Lo bit
    BT D$ebx edx | SETC AH ; Hi bit
    cmp eax 0 | je L3> ; skip on similar bits
    cmp eax 0101 | je L3>
; case 01-00
    cmp eax 01 | je L2>
    BTR D$ebx edx | BTS D$ebx ecx | jmp L3>
; case 00-01
L2: BTS D$ebx edx | BTR D$ebx ecx
L3: inc ecx | dec edx | cmp ecx edx | jb L0<
    mov eax 1
EndP


;
;
[ updateBitSize | mov edx #1 | mov eax #2
    call GetEffectiveHighBitSz32 | mov #2 eax ]
[ updateByteSize | mov edx #1 | mov eax #2 | shl eax 3
    call GetEffectiveHighBitSz32 | shr eax 3 | mov #2 eax ]
;
;
AnyBitsSquare::
    cmp D$esp+010 040000 | ja AnyBitsSquareKaratsubaRecursiveM
    cmp D$esp+010  04000 | ja AnyBitsSquareKaratsubaRecursiveS
    jmp AnyBitsSquareLong
;
;
[krtsbMin 0280][krtsbStackMin 08000]
Proc AnyBitsSquareKaratsubaRecursiveM::
 ARGUMENTS @M3p @M3sz @M1p @M1sz
 Local @X0sz @X1sz @X1p @X0X0sz @X1X1sz @X1X1p @X0X1sz @X0X1p @Z1sz @Z1p @result; @X0X0p
 USES EBX ESI EDI

    mov eax D@M1sz | test eax 00_11111 | jne B0> | shr eax 3 | je B0>
    mov ecx D@M3sz | test ecx 00_11111 | jne B0> | shr ecx 3 | je B0>
    UpdateBitSize D@M1p D@M1sz ; shrink input, but than clean output's uppers
    shr eax 2 | cmp ecx eax | jb B0> | shr eax 1
    cmp eax krtsbMin | ja C0>
    call AnyBitsSquareLong D@M3p D@M3sz D@M1p D@M1sz
    jmp P9>>
C0:
    cmp eax krtsbStackMin | ja C0>
    call AnyBitsSquareKaratsubaRecursiveS D@M3p D@M3sz D@M1p D@M1sz
    jmp P9>>

B0: sub eax eax | jmp P9>>

C0:
; cleanup input ?
;    mov eax D@M3sz | shr eax 3 | call FillMemory D@M3p eax 0

    and D@X0X1p 0 | and D@Z1p 0 | and D@result 0

;X0sz half+ X1sz half-
    mov ebx D@M1sz | mov edi ebx
    shr ebx 1 | ALIGN_ON 32 ebx
    mov D@X0sz ebx | sub edi ebx
    mov D@X1sz edi
    shr ebx 3
    mov eax D@M1p | add eax ebx | mov D@X1p eax

; make x0*x0
    mov ebx D@X0sz | shl ebx 1 | mov D@X0X0sz ebx
;    move D@X0X0p D@M3p
    shr ebx 3
; do x0*x0
    call AnyBitsSquareKaratsubaRecursiveM D@M3p D@X0X0sz D@M1p D@X0sz | test eax eax | je B1>>
    UpdateBitSize D@M3p D@X0X0sz
; make x1*x1
    mov edi D@X1sz | shl edi 1 | mov D@X1X1sz edi
    mov eax D@M3p | add eax ebx | mov D@X1X1p eax
; do x1*x1
    call AnyBitsSquareKaratsubaRecursiveM D@X1X1p D@X1X1sz D@X1p D@X1sz | test eax eax | je B1>>
    UpdateBitSize D@X1X1p D@X1X1sz

; x0+x1
    mov eax D@X0sz | mov edx D@X1sz | cmp eax edx | jae L0> | mov eax edx
L0: add eax 32 | mov D@X0X1sz eax | shr eax 3
    call VAlloc eax | test eax eax | mov D@X0X1p eax | je B1>>
    call AnyBitsAddition D@X0X1p D@X0X1sz D@X1p D@X1sz D@M1p D@X0sz | test eax eax | je B1>>
    UpdateBitSize D@X0X1p D@X0X1sz
; (x0+x1)^
    mov eax D@X0X1sz | shl eax 1 | add eax 32 | mov D@Z1sz eax | shr eax 3
    call VAlloc eax | test eax eax | mov D@Z1p eax | je B1>>
    call AnyBitsSquareKaratsubaRecursiveM D@Z1p D@Z1sz D@X0X1p D@X0X1sz | test eax eax | je B1>>
; - x1x1
    call AnyBitsSubstractionSelf D@X1X1p D@X1X1sz D@Z1p D@Z1sz | test eax eax | je B1>>
; - x0x0
    call AnyBitsSubstractionSelf D@M3p D@X0X0sz D@Z1p D@Z1sz | test eax eax | je B1>
    UpdateBitSize D@Z1p D@Z1sz
; Z2 +Z1 +Z0
    mov eax D@X0sz | mov edx D@M3sz | sub edx eax | shr eax 3 | add eax D@M3p
    call AnyBitsAdditionSelf D@Z1p D@Z1sz eax edx | test eax eax | je B1>
; clean output's uppers
    mov edi D@M1sz | mov ecx D@M3sz | SHR edi 2 | SHR ecx 3 | add edi D@M3p | add ecx D@M3p
    sub ecx edi | je L0> | sub eax eax | SHR ecx 2 | CLD | REP STOSD
L0:
    mov D@result 1
B1:
    call VFree D@Z1p
    call VFree D@X0X1p

    mov eax D@result
EndP
;
;
;
Proc AnyBitsSquareKaratsubaRecursiveS::
 ARGUMENTS @M3p @M3sz @M1p @M1sz
 Local @X0sz @X1sz @X1p @X0X0sz @X1X1sz @X1X1p @X0X1sz @X0X1p @Z1sz @Z1p @result; @X0X0p
 USES EBX ESI EDI

    mov eax D@M1sz | test eax 00_11111 | jne B0> | shr eax 3 | je B0>
    mov ecx D@M3sz | test ecx 00_11111 | jne B0> | shr ecx 3 | je B0>
    UpdateBitSize D@M1p D@M1sz ; shrink input, but than clean output's uppers
    shr eax 2 | cmp ecx eax | jb B0> | shr eax 1
    cmp eax krtsbMin | ja C0>
    call AnyBitsSquareLong D@M3p D@M3sz D@M1p D@M1sz
    jmp P9>>
B0: sub eax eax | jmp P9>>

C0:
; cleanup input ?
;    mov eax D@M3sz | shr eax 3 | call FillMemory D@M3p eax 0

    and D@X0X1p 0 | and D@Z1p 0 | and D@result 0

;X0sz half+ X1sz half-
    mov ebx D@M1sz | mov edi ebx
    shr ebx 1 | ALIGN_ON 32 ebx
    mov D@X0sz ebx | sub edi ebx
    mov D@X1sz edi
    shr ebx 3
    mov eax D@M1p | add eax ebx | mov D@X1p eax

; make x0*x0
    mov ebx D@X0sz | shl ebx 1 | mov D@X0X0sz ebx
;    move D@X0X0p D@M3p
    shr ebx 3
; do x0*x0
    call AnyBitsSquareKaratsubaRecursiveS D@M3p D@X0X0sz D@M1p D@X0sz | test eax eax | je B1>>
    UpdateBitSize D@M3p D@X0X0sz
; make x1*x1
    mov edi D@X1sz | shl edi 1 | mov D@X1X1sz edi
    mov eax D@M3p | add eax ebx | mov D@X1X1p eax
; do x1*x1
    call AnyBitsSquareKaratsubaRecursiveS D@X1X1p D@X1X1sz D@X1p D@X1sz | test eax eax | je B1>>
    UpdateBitSize D@X1X1p D@X1X1sz

; x0+x1
    mov eax D@X0sz | mov edx D@X1sz | cmp eax edx | jae L0> | mov eax edx
L0: add eax 32 | mov D@X0X1sz eax | shr eax 3
    push 0 ; border
    call SAlloc eax | test eax eax | mov D@X0X1p eax | je B1>>
    call AnyBitsAddition D@X0X1p D@X0X1sz D@X1p D@X1sz D@M1p D@X0sz | test eax eax | je B1>>
    UpdateBitSize D@X0X1p D@X0X1sz
; (x0+x1)^
    mov eax D@X0X1sz | shl eax 1 | add eax 32 | mov D@Z1sz eax | shr eax 3
    push 0 ; border
    call SAlloc eax | test eax eax | mov D@Z1p eax | je B1>>
    call AnyBitsSquareKaratsubaRecursiveS D@Z1p D@Z1sz D@X0X1p D@X0X1sz | test eax eax | je B1>>
; - x1x1
    call AnyBitsSubstractionSelf D@X1X1p D@X1X1sz D@Z1p D@Z1sz | test eax eax | je B1>>
; - x0x0
    call AnyBitsSubstractionSelf D@M3p D@X0X0sz D@Z1p D@Z1sz | test eax eax | je B1>
    UpdateBitSize D@Z1p D@Z1sz
; Z2 +Z1 +Z0
    mov eax D@X0sz | mov edx D@M3sz | sub edx eax | shr eax 3 | add eax D@M3p
    call AnyBitsAdditionSelf D@Z1p D@Z1sz eax edx | test eax eax | je B1>
; clean output's uppers
    mov edi D@M1sz | mov ecx D@M3sz | SHR edi 2 | SHR ecx 3 | add edi D@M3p | add ecx D@M3p
    sub ecx edi | je L0> | sub eax eax | SHR ecx 2 | CLD | REP STOSD
L0:
    mov D@result 1
B1:
    mov eax D@result
EndP
;
;

[StackAllocMax 020000]
; initialize dirty stack memory (pos & size aligned on 16)
; ARGUMENT: size in bytes
SAlloc:
    sub eax eax | mov ecx D$esp+4
    cmp ecx StackAllocMax | jbe L0> | RET 04
L0: mov edx D$esp | add esp 8
    ALIGN_ON 16 ecx
L0: test esp 0F | je L0> | push 0 | jmp L0< ; align stack on 16

L0: sub ecx &PAGE_SIZE | jl L0>
    sub esp (&PAGE_SIZE -4) | push 0 | jmp L0< ; init stack pages
L0: add ecx &PAGE_SIZE
    sub esp ecx | add esp 4 | push 0 | mov eax esp
    push edx | RET






;
Proc AnyBitsMultiplicationKaratsubaRecursive::
 ARGUMENTS @M3p @M3sz @M2p @M2sz @M1p @M1sz
 cLocal @X0sz @X1sz @X1p @Y0sz @Y1sz @Y1p @X0Y0sz @X0Y0p @X1Y1sz @X1Y1p @X0X1sz @X0X1p @Y1Y0sz @Y1Y0p @Z1sz @Z1p @result
 USES EBX ESI EDI

    mov eax D@M1sz | test eax 00_11111 | jne B0>> | shr eax 3 | je B0>>
    mov edx D@M2sz | test edx 00_11111 | jne B0>> | shr edx 3 | je B0>
    mov ecx D@M3sz | test ecx 00_11111 | jne B0> | shr ecx 3 | je B0>
L0:
    cmp eax edx | jne L1>
    add eax edx
    cmp ecx eax | jb B0>
    cmp edx krtsbMin | ja C0>
; too slow :(
;    mov edx D@M1p | mov eax D@M1sz
;    call GetEffectiveHighBitSz32 | cmp eax krtsbMin | jbe L1>
;    mov edx D@M2p | mov eax D@M2sz
;    call GetEffectiveHighBitSz32 | cmp eax krtsbMin | ja C0>
L1: call AnyBitsMultiplicationLong D@M3p D@M3sz D@M2p D@M2sz D@M1p D@M1sz
    jmp P9>>
B0: sub eax eax | jmp P9>>

C0:
;X0sz half+ X1sz half-
    mov ebx D@M1sz | mov edi ebx
    shr ebx 1 | ALIGN_ON 32 ebx
    mov D@X0sz ebx | sub edi ebx
    mov D@X1sz edi
    shr ebx 3
    mov eax D@M1p | add eax ebx | mov D@X1p eax

;Y0sz=X0sz Y1sz=M2sz-X0sz
    mov ebx D@X0sz | mov edi D@M2sz
    mov D@Y0sz ebx | sub edi ebx | jbe B0<
    mov D@Y1sz edi
    shr ebx 3
    mov eax D@M2p | add eax ebx | mov D@Y1p eax

; make x0*y0
    mov ebx D@X0sz | add ebx D@Y0sz | mov D@X0Y0sz ebx | shr ebx 3
    call VAlloc ebx | test eax eax | mov D@X0Y0p eax | je B1>>
; do x0*y0
    call AnyBitsMultiplicationKaratsubaRecursive D@X0Y0p D@X0Y0sz D@M2p D@Y0sz D@M1p D@X0sz | test eax eax | je B1>>

; make x1*y1
    mov ebx D@X1sz | add ebx D@Y1sz | mov D@X1Y1sz ebx | shr ebx 3
    call VAlloc ebx | test eax eax | mov D@X1Y1p eax | je B1>>
; do x1*y1
    call AnyBitsMultiplicationKaratsubaRecursive D@X1Y1p D@X1Y1sz D@Y1p D@Y1sz D@X1p D@X1sz | test eax eax | je B1>>

; x0+x1
    mov eax D@X0sz | mov edx D@X1sz | cmp eax edx | jae L0> | mov eax edx
L0: add eax 32 | mov D@X0X1sz eax | shr eax 3
    call VAlloc eax | test eax eax | mov D@X0X1p eax | je B1>>
    call AnyBitsAddition D@X0X1p D@X0X1sz D@X1p D@X1sz D@M1p D@X0sz | test eax eax | je B1>>
;    UpdateBitSize D@X0X1p D@X0X1sz
; y1+y0
    mov eax D@Y1sz | mov edx D@Y0sz | cmp eax edx | jae L0> | mov eax edx
L0: add eax 32 | mov D@Y1Y0sz eax | shr eax 3
    call VAlloc eax | test eax eax | mov D@Y1Y0p eax | je B1>>
    call AnyBitsAddition D@Y1Y0p D@Y1Y0sz D@M2p D@Y0sz D@Y1p D@Y1sz | test eax eax | je B1>>
;    UpdateBitSize D@Y1Y0p D@Y1Y0sz
; (x0+x1) * (y1+y0)
    mov eax D@Y1Y0sz | add eax D@X0X1sz | add eax 32 | mov D@Z1sz eax | shr eax 3
    call VAlloc eax | test eax eax | mov D@Z1p eax | je B1>>
    call AnyBitsMultiplicationKaratsubaRecursive D@Z1p D@Z1sz D@Y1Y0p D@Y1Y0sz D@X0X1p D@X0X1sz | test eax eax | je B1>>
; - x1y1
    call AnyBitsSubstractionSelf D@X1Y1p D@X1Y1sz D@Z1p D@Z1sz | test eax eax | je B1>>
; - x0y0
    call AnyBitsSubstractionSelf D@X0Y0p D@X0Y0sz D@Z1p D@Z1sz | test eax eax | je B1>
    UpdateBitSize D@Z1p D@Z1sz
; Z2 +Z1 +Z0
;    mov eax D@M3sz | shr eax 3 | call FillMemory D@M3p eax 0
    call AnyBitsAdditionSelf D@X0Y0p D@X0Y0sz D@M3p D@M3sz | test eax eax | je B1>
    mov eax D@X0sz | mov edx D@M3sz | sub edx eax | shr eax 3 | add eax D@M3p
    call AnyBitsAdditionSelf D@Z1p D@Z1sz eax edx | test eax eax | je B1>
    mov eax D@X0sz | mov edx D@M3sz | shl eax 1 | sub edx eax | shr eax 3 | add eax D@M3p
    call AnyBitsAdditionSelf D@X1Y1p D@X1Y1sz eax edx | test eax eax | je B1>
    mov D@result 1
B1:
    call VFree D@Z1p
    call VFree D@Y1Y0p
    call VFree D@X0X1p
    call VFree D@X1Y1p
    call VFree D@X0Y0p
;    call VFree D@Y1p
;    call VFree D@X1p

    mov eax D@result
EndP
;
;
;
Proc AnyBitsMultiplication::
 ARGUMENTS @M3p @M3sz @M2p @M2sz @M1p @M1sz

    mov eax D@M1sz | test eax 00_11111 | jne B0> | shr eax 3 | je B0>
    mov edx D@M2sz | test edx 00_11111 | jne B0> | shr edx 3 | je B0>
    mov ecx D@M3sz | test ecx 00_11111 | jne B0> | shr ecx 3 | je B0>

;    cmp eax edx | jae L0>
;    EXCHANGE D@M1p D@M2p, D@M1sz D@M2sz | xchg eax edx
;L0:
    add eax edx
    cmp ecx eax | jb B0>
    cmp edx krtsbMin | ja C0>
L1: call AnyBitsMultiplicationLong D@M3p D@M3sz D@M2p D@M2sz D@M1p D@M1sz
    jmp P9>>
B0: sub eax eax | jmp P9>>
C0:
    mov eax D@M1sz | cmp D@M2sz eax | jne L1<
    call AnyBitsMultiplicationKaratsubaRecursive D@M3p D@M3sz D@M2p D@M2sz D@M1p D@M1sz

EndP


TITLE MPowPRP

; ModPow for base2
; returns: EAX=new_result_buffer EDX=bitSize; NULL on error;
Proc AnyBitsModPowBase2AA::
 Arguments @pExponent @szExponent @pMod @szMod
 cLocal @sq1sz @sq1 @sq2sz @sq2 @sqsz
 USES EBX ESI EDI

    mov edx D@szMod | test edx 00_11111 | jne E1> | shr edx 3 | je E1>
    mov edx D@szExponent | test edx 00_11111 | jne E1> | shr edx 3 | je E1>
    call GetHighestBitPosition D@pExponent D@szExponent | cmp edx 0-1 | je E1>
    test eax eax | je E1> ; 0, 1 = End.
    mov ebx eax
    call GetHighestBitPosition D@pMod D@szMod | cmp edx 0-1 | je E1>
    test eax eax | jne L0> ; 0, 1 = End.
E1: sub eax eax | jmp P9>>
L0:
    ALIGN_UP 32 eax | mov edi eax | shl edi 1 | add edi 32 | mov D@sqsz edi | shr edi 3
    call VAlloc edi | mov D@sq1 eax | test eax eax | je E0>>
    call VAlloc edi | mov D@sq2 eax | test eax eax | je E0>>
    mov D@sq1sz 32
    mov esi D@sq1 | mov edi D@sq2
    mov D$esi 1
L1: ; square
    mov eax D@sq1sz | shl eax 1 | mov D@sq2sz eax
    call AnyBitsSquare edi D@sq2sz, esi D@sq1sz | test eax eax | je E0>>
    updateBitSize edi D@sq2sz
    xchg esi edi | Exchange D@sq1sz D@sq2sz
    mov eax D@pExponent | BT D$eax ebx | jnc L0>
    ; x2
    call AnyBitsShift1Left esi D@sq1sz | jnc L0>
    mov eax D@sq1sz | shr eax 3 | mov D$esi+eax 1 | add D@sq1sz 32 ; enlarge
L0: ; mod
    call AnyBitsModulus D@pMod D@szMod esi D@sq1sz | test eax eax | je E0>
    updateBitSize esi D@sq1sz
    sub ebx 1 | jae L1<<
    mov D@sq1 esi, D@sq2 edi
    jmp L2>
E0: sub esi esi | and D@sq1sz 0
    call VFree D@sq1
L2: call VFree D@sq2
    mov eax esi, edx D@sq1sz, ecx D@sqsz
EndP


; ModPow for base2 ; caller passes 2 buffer for squaring
; returns: EAX=result_buffer EDX=bitSize; NULL on error;
Proc AnyBitsModPowBase2AAm::
 Arguments @sq1 @sq2 @sqsz @pExponent @szExponent @pMod @szMod
 cLocal @sq1sz @sq2sz
 USES EBX ESI EDI

    mov edx D@szMod | test edx 00_11111 | jne E1> | shr edx 3 | je E1>
    mov edx D@szExponent | test edx 00_11111 | jne E1> | shr edx 3 | je E1>
    call GetHighestBitPosition D@pExponent D@szExponent | cmp edx 0-1 | je E1>
    test eax eax | je E1> ; 0, 1 = End.
    mov ebx eax
    call GetHighestBitPosition D@pMod D@szMod | cmp edx 0-1 | je E1>
    test eax eax | jne L0> ; 0, 1 = End.
E1: sub eax eax | jmp P9>>
L0:
    ALIGN_UP 32 eax | shl eax 1 | add eax 32 | cmp eax D@sqsz | ja E1<
    mov D@sq1sz 32
    mov esi D@sq1 | mov edi D@sq2
    mov D$esi 1
L1: ; square
    mov eax D@sq1sz | shl eax 1 | mov D@sq2sz eax
    call AnyBitsSquare edi D@sq2sz, esi D@sq1sz | test eax eax | je E0>
    updateBitSize edi D@sq2sz
    xchg esi edi | Exchange D@sq1sz D@sq2sz
    mov eax D@pExponent | BT D$eax ebx | jnc L0>
    ; x2
    call AnyBitsShift1Left esi D@sq1sz | jnc L0>
    mov eax D@sq1sz | shr eax 3 | mov D$esi+eax 1 | add D@sq1sz 32 ; enlarge
L0: ; mod
    call AnyBitsModulus D@pMod D@szMod esi D@sq1sz | test eax eax | je E0>
    updateBitSize esi D@sq1sz
    sub ebx 1 | jae L1<<
    jmp L2>
E0: sub esi esi | and D@sq1sz 0
L2:
    mov eax esi, edx D@sq1sz
EndP


; ModPow for any 32bit base
; returns: EAX=new_result_buffer EDX=bitSize; NULL on error;
Proc AnyBitsModPowBase32bitAA::
 Arguments @Base @pExponent @szExponent @pMod @szMod
 cLocal @sq1sz @sq1 @sq2sz @sq2 @sqsz
 USES EBX ESI EDI

    mov edx D@szMod | test edx 00_11111 | jne E1> | shr edx 3 | je E1>
    mov edx D@szExponent | test edx 00_11111 | jne E1> | shr edx 3 | je E1>
    cmp D@Base 2 | jb E1>
    call GetHighestBitPosition D@pExponent D@szExponent | cmp edx 0-1 | je E1>
    test eax eax | je E1> ; 0, 1 = End.
    mov ebx eax
    call GetHighestBitPosition D@pMod D@szMod | cmp edx 0-1 | je E1>
    test eax eax | jne L0> ; 0, 1 = End.
E1: sub eax eax | jmp P9>>
L0:
    ALIGN_UP 32 eax | mov edi eax | shl edi 1 | add edi 32 | mov D@sqsz edi | shr edi 3
    call VAlloc edi | mov D@sq1 eax | test eax eax | je E0>>
    call VAlloc edi | mov D@sq2 eax | test eax eax | je E0>>
    mov D@sq1sz 32
    mov esi D@sq1 | mov edi D@sq2
    mov D$esi 1
L1: ; square
    mov eax D@sq1sz | shl eax 1 | mov D@sq2sz eax
    call AnyBitsSquare edi D@sq2sz, esi D@sq1sz | test eax eax | je E0>>
    updateBitSize edi D@sq2sz
    xchg esi edi | Exchange D@sq1sz D@sq2sz
    mov eax D@pExponent | BT D$eax ebx | jnc L0>
    ; mul Base
    mov eax D@sq1sz | add eax 32 | mov D@sq2sz eax
    call AnyBitsMul32Bit edi D@sq2sz D@Base esi D@sq1sz | test eax eax | je E0>
    updateBitSize edi D@sq2sz
    xchg esi edi | Exchange D@sq1sz D@sq2sz
L0: ; mod
    call AnyBitsModulus D@pMod D@szMod esi D@sq1sz | test eax eax | je E0>
    updateBitSize esi D@sq1sz
    sub ebx 1 | jae L1<<
    mov D@sq1 esi, D@sq2 edi
    jmp L2>
E0: sub esi esi | and D@sq1sz 0
    call VFree D@sq1
L2: call VFree D@sq2
    mov eax esi, edx D@sq1sz, ecx D@sqsz
EndP


; ModPow for any base
; returns: EAX=new_result_buffer EDX=bitSize; NULL on error;
Proc AnyBitsModPowAAA::
 Arguments @pBase @szBase @pExponent @szExponent @pMod @szMod
 cLocal @sq1sz @sq1 @sq2sz @sq2 @sqsz
 USES EBX ESI EDI

    mov edx D@szMod | test edx 00_11111 | jne E1> | shr edx 3 | je E1>
    mov edx D@szExponent | test edx 00_11111 | jne E1> | shr edx 3 | je E1>
    mov edx D@szBase | test edx 00_11111 | jne E1> | shr edx 3 | je E1>

    call GetHighestBitPosition D@pExponent D@szExponent | cmp edx 0-1 | je E1>
    test eax eax | je E1> ; 0, 1 = End.
    mov ebx eax
    call GetHighestBitPosition D@pMod D@szMod | cmp edx 0-1 | je E1>
    test eax eax | jne L0> ; 0, 1 = End.
E1: sub eax eax | jmp P9>>
L0:
    ALIGN_UP 32 eax | mov edi eax | shl edi 1 | add edi D@szBase | mov D@sqsz edi | shr edi 3
    call VAlloc edi | mov D@sq1 eax | test eax eax | je E0>>
    call VAlloc edi | mov D@sq2 eax | test eax eax | je E0>>
    mov D@sq1sz 32
    mov esi D@sq1 | mov edi D@sq2
    mov D$esi 1
L1: ; square
    mov eax D@sq1sz | shl eax 1 | mov D@sq2sz eax
    call AnyBitsSquare edi D@sq2sz, esi D@sq1sz | test eax eax | je E0>>
    updateBitSize edi D@sq2sz
    xchg esi edi | Exchange D@sq1sz D@sq2sz
    mov eax D@pExponent | BT D$eax ebx | jnc L0>
    ; mul Base
    mov eax D@sq1sz | add eax D@szBase | mov D@sq2sz eax
    call AnyBitsMultiplication edi D@sq2sz D@pBase D@szBase esi D@sq1sz | test eax eax | je E0>
    updateBitSize edi D@sq2sz
    xchg esi edi | Exchange D@sq1sz D@sq2sz
L0: ; mod
    call AnyBitsModulus D@pMod D@szMod esi D@sq1sz | test eax eax | je E0>
    updateBitSize esi D@sq1sz
    sub ebx 1 | jae L1<<
    mov D@sq1 esi, D@sq2 edi
    jmp L2>
E0: sub esi esi | and D@sq1sz 0
    call VFree D@sq1
L2: call VFree D@sq2
    mov eax esi, edx D@sq1sz, ecx D@sqsz
EndP


; Fermat's Little Theorem PRP Test for Base2
; returns: 1 - is probably prime, 0 - is NOT prime; -1 on error;
Proc FermatLittleTheoremBase2PRPTest::
 Arguments @pNum @szNum
 cLocal @sq1sz @sq1 @sq2sz @sq2 @sqsz
 USES EBX ESI EDI

    mov edx D@szNum | test edx 00_11111 | jne E1> | shr edx 3 | je E1>
    call GetHighestBitPosition D@pNum D@szNum | cmp edx 0-1 | je E1>
    test eax eax | je E1> ; 0, 1 = End.
    cmp eax 1 | je P9>> ; 2, 3 = End.
    mov ebx eax
    mov edx D@pNum | mov eax D$edx | and eax 1 | je P9>>
    jmp L0>
E1: or eax 0-1 | jmp P9>>
L0: mov edi ebx
    ALIGN_UP 32 edi | shl edi 1 | add edi 32 | mov D@sqsz edi | shr edi 3
    call VAlloc edi | mov D@sq1 eax | test eax eax | je E0>>
    call VAlloc edi | mov D@sq2 eax | test eax eax | je E0>>
    mov D@sq1sz 32
    mov esi D@sq1 | mov edi D@sq2
    mov D$esi 1
L1: ; square
    mov eax D@sq1sz | shl eax 1 | mov D@sq2sz eax
    call AnyBitsSquare edi D@sq2sz, esi D@sq1sz | test eax eax | je E0>>
    updateBitSize edi D@sq2sz
    xchg esi edi | Exchange D@sq1sz D@sq2sz
    mov eax D@pNum | BT D$eax ebx | jnc L0>
    ; mul Base
    test ebx ebx | je L0> ; skip 0 pos
    call AnyBitsShift1Left esi D@sq1sz | jnc L0>
    mov eax D@sq1sz | shr eax 3 | mov D$esi+eax 1 | add D@sq1sz 32 ; enlarge
L0: ; mod
    call AnyBitsModulus D@pNum D@szNum esi D@sq1sz | test eax eax | je E0>
    updateBitSize esi D@sq1sz
    sub ebx 1 | jae L1<<
    mov ebx 0 | cmp D@sq1sz 32 | jne L2>
    cmp D$esi 1 | jne L2>
    mov ebx 1
    jmp L2>
E0: or ebx 0-1
L2: call VFree D@sq1
    call VFree D@sq2
    mov eax ebx
EndP


; for smaller (~1024bit?) numbers memory for squaring use on stack
; Fermat's Little Theorem PRP Test for Base2
; returns: 1 - is probably prime, 0 - is NOT prime; -1 on error;
Proc FermatLittleTheoremBase2PRPTestS::
 Arguments @pNum @szNum
 cLocal @sq1sz @sq1 @sq2sz @sq2 @sqsz
 USES EBX ESI EDI

    mov edx D@szNum | test edx 00_11111 | jne E1> | shr edx 3 | je E1>
    call GetHighestBitPosition D@pNum D@szNum | cmp edx 0-1 | je E1>
    test eax eax | je E1> ; 0, 1 = End.
    cmp eax 1 | je P9>> ; 2, 3 = End.
    mov ebx eax
    mov edx D@pNum | mov eax D$edx | and eax 1 | je P9>>
    jmp L0>
E1: or eax 0-1 | jmp P9>>
L0: mov edi ebx
    ALIGN_UP 32 edi | shl edi 1 | add edi 32 | mov D@sqsz edi

    push 0 ; border
    mov ecx edi
; allocate stack
    SHR ecx 5 ; bits > dwords
L0: push 0 | LOOP L0<
L0: test esp (16-1) | je L0> | push 0 | jmp L0< ; stack down align 16
L0: mov D@sq1 esp

    push 0,0,0,0 ; border
    mov ecx edi
; allocate stack
    SHR ecx 5
L0: push 0 | LOOP L0<
L0: test esp (16-1) | je L0> | push 0 | jmp L0<
L0: mov D@sq2 esp

    mov D@sq1sz 32
    mov esi D@sq1 | mov edi D@sq2
    mov D$esi 1
L1: ; square
    mov eax D@sq1sz | shl eax 1 | mov D@sq2sz eax
    call AnyBitsSquare edi D@sq2sz, esi D@sq1sz | test eax eax | je E0>>
    updateBitSize edi D@sq2sz
    xchg esi edi | Exchange D@sq1sz D@sq2sz
    mov eax D@pNum | BT D$eax ebx | jnc L0>
    ; mul Base
    test ebx ebx | je L0> ; skip 0 pos
    call AnyBitsShift1Left esi D@sq1sz | jnc L0>
    mov eax D@sq1sz | shr eax 3 | mov D$esi+eax 1 | add D@sq1sz 32 ; enlarge
L0: ; mod
    call AnyBitsModulus D@pNum D@szNum esi D@sq1sz | test eax eax | je E0>
    updateBitSize esi D@sq1sz
    sub ebx 1 | jae L1<<
    mov ebx 0 | cmp D@sq1sz 32 | jne L2>
    cmp D$esi 1 | jne L2>
    mov ebx 1
    jmp L2>
E0: or ebx 0-1 ; err case
L2:
    mov eax ebx
EndP ; stack restored in EndP macro



; Fermat's Little Theorem PRP Test for any 32bit base
; returns: 1 - is probably prime, 0 - is NOT prime; -1 on error;
Proc FermatLittleTheoremBase32bitPRPTest::
 Arguments @pNum @szNum @Base
 cLocal @sq1sz @sq1 @sq2sz @sq2 @sqsz
 USES EBX ESI EDI

    cmp D@Base 2 | jb E1>
    mov edx D@szNum | test edx 00_11111 | jne E1> | shr edx 3 | je E1>
    call GetHighestBitPosition D@pNum D@szNum | cmp edx 0-1 | je E1>
    test eax eax | je E1> ; 0, 1 = End.
    cmp eax 1 | je P9>> ; 2, 3 = End.
    mov ebx eax
    mov edx D@pNum | mov eax D$edx | and eax 1 | je P9>>
    call AnyBitsMod32Bit D@pNum D@szNum D@Base | test eax eax | je E1>
    mov eax edx | test eax eax | je P9>>
    jmp L0>
E1: or eax 0-1 | jmp P9>>
L0: mov edi ebx
    ALIGN_UP 32 edi | shl edi 1 | add edi 32 | mov D@sqsz edi | shr edi 3
    call VAlloc edi | mov D@sq1 eax | test eax eax | je E0>>
    call VAlloc edi | mov D@sq2 eax | test eax eax | je E0>>
    mov D@sq1sz 32
    mov esi D@sq1 | mov edi D@sq2
    mov D$esi 1
L1: ; square
    mov eax D@sq1sz | shl eax 1 | mov D@sq2sz eax
    call AnyBitsSquare edi D@sq2sz, esi D@sq1sz | test eax eax | je E0>>
    updateBitSize edi D@sq2sz
    xchg esi edi | Exchange D@sq1sz D@sq2sz
    mov eax D@pNum | BT D$eax ebx | jnc L0>
    ; mul Base
    test ebx ebx | je L0> ; skip 0 pos
    mov eax D@sq1sz | add eax 32 | mov D@sq2sz eax
    call AnyBitsMul32Bit edi D@sq2sz D@Base esi D@sq1sz | test eax eax | je E0>
    updateBitSize edi D@sq2sz
    xchg esi edi | Exchange D@sq1sz D@sq2sz
L0: ; mod
    call AnyBitsModulus D@pNum D@szNum esi D@sq1sz | test eax eax | je E0>
    updateBitSize esi D@sq1sz
    sub ebx 1 | jae L1<<
    mov ebx 0 | cmp D@sq1sz 32 | jne L2>
    cmp D$esi 1 | jne L2>
    mov ebx 1
    jmp L2>
E0: or ebx 0-1
L2: call VFree D@sq1
    call VFree D@sq2
    mov eax ebx
EndP


; for smaller (~1024bit?) numbers memory for squaring use on stack
; Fermat's Little Theorem PRP Test for any 32bit base
; returns: 1 - is probably prime, 0 - is NOT prime; -1 on error;
Proc FermatLittleTheoremBase32bitPRPTestS::
 Arguments @pNum @szNum @Base
 cLocal @sq1sz @sq1 @sq2sz @sq2 @sqsz
 USES EBX ESI EDI

    cmp D@Base 2 | jb E1>
    mov edx D@szNum | test edx 00_11111 | jne E1> | shr edx 3 | je E1>
    call GetHighestBitPosition D@pNum D@szNum | cmp edx 0-1 | je E1>
    test eax eax | je E1> ; 0, 1 = End.
    cmp eax 1 | je P9>> ; 2, 3 = End.
    mov ebx eax
    mov edx D@pNum | mov eax D$edx | and eax 1 | je P9>>
    call AnyBitsMod32Bit D@pNum D@szNum D@Base | test eax eax | je E1>
    mov eax edx | test eax eax | je P9>>
    jmp L0>
E1: or eax 0-1 | jmp P9>>
L0: mov edi ebx
    ALIGN_UP 32 edi | shl edi 1 | add edi 32 | mov D@sqsz edi

    push 0 ; border
    mov ecx edi
; allocate stack
    SHR ecx 5 ; bits > dwords
L0: push 0 | LOOP L0<
L0: test esp (16-1) | je L0> | push 0 | jmp L0< ; stack down align 16
L0: mov D@sq1 esp

    push 0,0,0,0 ; border
    mov ecx edi
; allocate stack
    SHR ecx 5
L0: push 0 | LOOP L0<
L0: test esp (16-1) | je L0> | push 0 | jmp L0<
L0: mov D@sq2 esp

    mov D@sq1sz 32
    mov esi D@sq1 | mov edi D@sq2
    mov D$esi 1
L1: ; square
    mov eax D@sq1sz | shl eax 1 | mov D@sq2sz eax
    call AnyBitsSquare edi D@sq2sz, esi D@sq1sz | test eax eax | je E0>>
    updateBitSize edi D@sq2sz
    xchg esi edi | Exchange D@sq1sz D@sq2sz
    mov eax D@pNum | BT D$eax ebx | jnc L0>
    ; mul Base
    test ebx ebx | je L0> ; skip 0 pos
    mov eax D@sq1sz | add eax 32 | mov D@sq2sz eax
    call AnyBitsMul32Bit edi D@sq2sz D@Base esi D@sq1sz | test eax eax | je E0>
    updateBitSize edi D@sq2sz
    xchg esi edi | Exchange D@sq1sz D@sq2sz
L0: ; mod
    call AnyBitsModulus D@pNum D@szNum esi D@sq1sz | test eax eax | je E0>
    updateBitSize esi D@sq1sz
    sub ebx 1 | jae L1<<
    mov ebx 0 | cmp D@sq1sz 32 | jne L2>
    cmp D$esi 1 | jne L2>
    mov ebx 1
    jmp L2>
E0: or ebx 0-1
L2:
    mov eax ebx
EndP ; stack restored in EndP macro



TITLE SQRT

ALIGN 16

; returns uint32 in EAX
Proc SQRT32::
ARGUMENTS @Bits32
 USES EBX
;DBGBP
    sub eax eax
    sub ebx ebx
    lea edx D@Bits32

L0: BSR ebx D$edx | je P9> ; 0
    inc eax
    shr ebx 1 | je P9> ; 1,2,3
    mov ecx D@Bits32 | cmp ecx (64*64 -1) | ja L1>
    mov edx 4
L0:
    inc eax | lea edx D$eax*2+edx+1
    cmp ecx edx | jb P9> | jne L0< | inc eax | jmp P9>
L1:
    sub ecx ecx

    add ebx 1
L0: sub ebx 1 | jl L3>
    BTS ecx ebx
    mov eax ecx | MUL eax
    cmp eax D@Bits32 | jb L0< | je L3>
L1:
    BTR ecx ebx
    jmp L0<

L3: mov eax ecx
EndP


; returns uint32 in EAX
Proc SQRT64::
ARGUMENTS @pBits64
 USES EBX ESI
;DBGBP
    sub eax eax
    sub ebx ebx
    mov esi D@pBits64
    lea edx D$esi+8

L0: sub edx 4 | cmp edx esi | jb P9> ; 0, End.
    BSR ebx D$edx | je L0<
    sub edx esi | lea ebx D$edx*8+ebx

L0: shr ebx 1
    sub ecx ecx

    add ebx 1
L0: sub ebx 1 | jl L3>
    BTS ecx ebx
    mov eax ecx | MUL eax
    cmp edx D$esi+4 | ja L1> | jb L0<
    cmp eax D$esi | jb L0< | je L3>
L1:
    BTR ecx ebx
    jmp L0<

L3: mov eax ecx
EndP


; returns uint64 in EDX:EAX
Proc SQRT128::
ARGUMENTS @pBits128
 Local @H4 @H3 @H2 @H1
 USES EBX ESI EDI
;DBGBP
    sub eax eax
    sub ecx ecx
    sub edi edi
    sub ebx ebx
    mov esi D@pBits128
    lea edx D$esi+16

L0: sub edx 4 | cmp edx esi | jb L3>> ; 0, End.
    BSR ebx D$edx | je L0<
    sub edx esi | lea ebx D$edx*8+ebx
    cmp ebx 64 | jae L0>
    call SQRT64 esi | sub edx edx | jmp P9>>
L0:
    shr ebx 1
    add ebx 1
L0: sub ebx 1
    cmp ebx 32 | jb L2>
    BTS edi ebx
    mov eax edi | MUL eax
    cmp edx D$esi+0C | ja L1> | jb L0<
    cmp eax D$esi+08 | jb L0< | je L0>
L1: BTR edi ebx
    jmp L0<
L0: mov ebx 31
L2:
    add ebx 1
L0: sub ebx 1 | jl L3>
    BTS ecx ebx
    mov eax edi | MUL eax | mov D@H4 edx | mov D@H3 eax ; Square 64bit
    mov eax ecx | MUL eax | mov D@H2 edx | mov D@H1 eax
    mov eax ecx | MUL edi | sub esi esi
    add edx edx | adc esi 0 | add eax eax | adc edx 0 | adc esi 0
    add D@H2 eax | adc D@H3 edx | adc D@H4 esi
    mov esi D@pBits128 ; cmp 128bits
    mov eax D@H4 | cmp eax D$esi+0C | ja L1> | jb L0<
    mov eax D@H3 | cmp eax D$esi+08 | ja L1> | jb L0<
    mov eax D@H2 | cmp eax D$esi+04 | ja L1> | jb L0<
    mov eax D@H1 | cmp eax D$esi | jb L0< | je L3>
L1: BTR ecx ebx
    jmp L0<

L3: mov eax ecx | mov edx edi
EndP
;
;
;
Proc AnyBitsSQR2predict:
 ARGUMENTS @pAnyBits2 @nAnyBits2 @pAnyBits1 @nAnyBits1
 cLocal @nSqSqr @SqSqr @PowBitLen @AnyBits1Len
 USES EBX ESI EDI

    mov eax D@nAnyBits1 | test eax 00_11111 | jne B0>> | shr eax 3 | je B0>>
    mov ecx D@nAnyBits2 | test ecx 00_11111 | jne B0>> | shr ecx 3 | je B0>>
    add eax D@pAnyBits1
; search highest bits.
    mov edx eax
L0: sub edx 4 | cmp edx D@pAnyBits1 | jb B0>> ; Quotent is 0, End.
    BSR eax D$edx | je L0<
    sub edx D@pAnyBits1 | lea edx D$edx*8+eax
    mov D@AnyBits1Len edx, eax edx, ecx D@nAnyBits2 | ALIGN_UP 32 edx | mov D@nAnyBits1 edx
    SHR eax 1 | mov ebx eax
    ALIGN_UP 32 eax | cmp ecx eax | jb B0>> | mov D@nAnyBits2 eax

    mov edi D@pAnyBits2, eax 0 | SHR ecx 5 | CLD | REP STOSD
;DBGBP
    mov esi D@pAnyBits1, edi D@pAnyBits2, edx D@nAnyBits2
    sub edx (PredictSz*8) | sub ebx edx
    SHR edx 3 | add edi edx ; Num upper chunk position
    SHL edx 1 | add esi edx ; SQR2 upper chunk position
    mov eax D@nAnyBits1 | SHL edx 3 | sub eax edx | mov D@PowBitLen eax; SQR2 upper chunk size
; align stack 16
L0: test esp (16-1) | je L0> | push 0 | jmp L0<
L0:
    mov ecx (PredictSz*2*8); | ALIGN_ON 64 ecx
; allocate stack
    SHR ecx 5
L0: push 0 | LOOP L0<
    mov D@SqSqr esp

    add ebx 1
L0: sub ebx 1 | jl L3>
    BTS D$edi ebx
    call AnyBitsSquareLong D@SqSqr (PredictSz*2*8) edi (PredictSz*8) | test eax eax | je B0>
    call AnyBitsCompare D@SqSqr (PredictSz*2*8) ESI D@PowBitLen | test eax eax | je B0>
    cmp eax 1 | je L1> | cmp eax 3 | je L3>
    BTR D$edi ebx ; is >
L1:
    jmp L0<
L3:
    mov eax 1 | jmp P9>
B0:
    sub eax eax ; params ERROR case
EndP



; returns EAX 0 on error; EAX=TRUE, EDX=SQRT bitSize
Proc AnyBitsSquareRoot::
 Arguments @pSqrBits @nSqrBits @pBits @nBits

    updateBitSize D@pBits D@nBits
    mov ecx D@nBits
    cmp ecx 08000 | jae L1>
    cmp ecx 32 | je L2>
    cmp ecx 64 | je L3>
    cmp ecx 128 | je L4>
    LEAVE | jmp AnyBitsSquareRootSmall
L2:
    mov edx D@pBits
    call SQRT32 D$edx
    mov edx D@pSqrBits | mov D$edx eax
    mov eax 1, edx 32 | jmp P9>
L3:
    call SQRT64 D@pBits
    mov ecx D@pSqrBits | mov D$ecx eax
    mov eax 1, edx 32 | jmp P9>
L4:
    sub eax eax | cmp D@nSqrBits 64 | jb P9>
    call SQRT128 D@pBits
    mov ecx D@pSqrBits | mov D$ecx eax | mov D$ecx+4 edx
    mov eax 1, edx 64 | jmp P9>
L1:
    call AnyBitsSquareRootBigM D@pSqrBits D@nSqrBits D@pBits D@nBits
EndP
;
;
;
; returns EAX 0 on error;
; New pSQRTmem=EAX, EDX=SQRTbitSize ; nBits>=256
Proc AnyBitsSquareRootBig::
 Arguments @pBits @nBits
 cLocal @nSqrBits @pSqrBits @nSqrBits1 @pSqrBits1 @tpSqrBits @tnBits @pBits1 @tpBits
 USES EBX EDI

    sub ebx ebx
    mov edi D@nBits | test edi 00_11111 | jne E0>> | shr edi 3 | je E0>>

    call GetHighestBitPosition  D@pBits D@nBits | cmp edx 0-1 | je E0>>
    mov edi eax | ALIGN_UP 32 eax | cmp eax 0100 | jb E0>>

    ALIGN_UP 32 edi
    mov D@nBits edi | SHR edi 3
    call VAlloc edi | test eax eax | je E0>> | mov D@pBits1 eax
    shr edi 1 | je E0>> | ALIGN_ON 4 edi | add edi 4
    call VAlloc edi | test eax eax | je E0>> | mov D@pSqrBits eax
    call VAlloc edi | test eax eax | je E0>> | mov D@pSqrBits1 eax
    SHL edi 3 | mov D@nSqrBits1 edi | sub edi 32 | mov D@nSqrBits edi
;DBGBP
[PredictSz 8]
    call AnyBitsSQR2predict D@pSqrBits D@nSqrBits D@pBits D@nBits | test eax eax | je E0>>

    mov edi PredictSz
L5:
    SHL edi 1 ; upper chunk next size

    mov eax D@nBits | shr eax 5 |  cmp edi eax | jbe L0> ; cmp to 1/4 of SQ size
    mov eax D@nSqrBits | shr eax 3 | cmp edi eax | ja L3>>
    mov edi eax ; load full
 L0:
    mov eax D@nSqrBits | shr eax 3 | add eax D@pSqrBits | sub eax edi | mov D@tpSqrBits eax ; Num chunk pos
    lea eax D$edi*8 | add eax 32 | mov D@nSqrBits1 eax ; Num chunk sz+32
    mov eax D@tpSqrBits | sub eax D@pSqrBits | SHL eax 1 | add eax D@pBits | mov D@tpBits eax ; SQ chunk pos
    mov edx D@nBits | shr edx 3 | add edx D@pBits | sub edx D@tpBits | SHL edx 3 | mov D@tnBits edx ; SQ chunk sz
    jmp L4>>

L0:
    call AnyBitsCompare D@pSqrBits1 D@nSqrBits1 D@tpSqrBits D@nSqrBits1 | test eax eax | je E0>>
    cmp eax 3 | je L5<
    cmp ecx 4 | ja L1>
    cmp eax 1 ; low dword direct adjustment
    mov eax D@tpSqrBits, edx D@pSqrBits1, ecx D$eax, edx D$edx
    je L2>
    sub edx ecx | cmp edx 1 | je L5<<
    add edx ecx
L6: add ecx edx | mov edx 0 | adc edx 0 | shr ecx 1 | ror edx 1 | or ecx edx | mov D$eax ecx
    jmp L4>
L2:
    sub ecx edx | cmp ecx 1 | jne L2> | mov D$eax edx | jmp L5<<
L2:
    add ecx edx | jmp L6<

L1:
;    DBGBP
    cmp eax 2 | jne L1>
    call AnyBitsSubstraction D@pBits1 D@nSqrBits1 D@tpSqrBits D@nSqrBits1 D@pSqrBits1 D@nSqrBits1
    call GetHighestBitPosition  D@pBits1 D@nSqrBits1 | cmp edx 0-1 | je E0>>
    cmp eax 2 | jb L5<<
L1:
    call AnyBitsAdditionSelf D@pSqrBits1 D@nSqrBits1 D@tpSqrBits D@nSqrBits1 | test eax eax | je E0>
    call AnyBitsShift1Right D@tpSqrBits D@nSqrBits1 | test eax eax | je E0>
L4:
    mov eax D@tnBits | shr eax 3 | call CopyMemory D@pBits1 D@tpBits eax
    call AnyBitsDivision D@pSqrBits1 D@nSqrBits1 D@tpSqrBits D@nSqrBits1 D@pBits1 D@tnBits | test eax eax | je E0>
jmp L0<<

L3:
    mov ebx 1
E0:
    call VFree D@pSqrBits1
    call VFree D@pBits1
    test ebx ebx | jne L0>
    call VFree D@pSqrBits | and D@pSqrBits 0
L0: mov ebx D@pSqrBits, edx D@nSqrBits
    mov eax ebx
EndP
;
;
; returns EAX 0 on error; EAX=TRUE, EDX=SQRTbitSize ; nBits>=256
; min nSqrtBits = (nBits /2)+32
Proc AnyBitsSquareRootBigM::
 Arguments @pSqrtBits @nSqrtBits @pBits @nBits
 cLocal @nSqrBits1 @pSqrBits1 @tpSqrBits @tnBits @pBits1 @tpBits
 USES EBX EDI

    sub ebx ebx
    mov edi D@nBits | test edi 00_11111 | jne E0>> | shr edi 3 | je E0>>
    mov eax D@nSqrtBits | test eax 00_11111 | jne E0>> | shr eax 3 | je E0>>
    call GetHighestBitPosition  D@pBits D@nBits | cmp edx 0-1 | je E0>>
    mov edi eax | ALIGN_UP 32 edi | cmp edi 0100 | jb E0>>
    shr eax 1 | ALIGN_UP 32 eax | add eax 32 | cmp eax D@nSqrtBits | ja E0>>

    mov D@nBits edi | SHR edi 3
    call VAlloc edi | test eax eax | je E0>> | mov D@pBits1 eax
    shr edi 1 | je E0>> | ALIGN_ON 4 edi | add edi 4
;    call VAlloc edi | test eax eax | je E0>> | mov D@pSqrBits eax
    call VAlloc edi | test eax eax | je E0>> | mov D@pSqrBits1 eax
    SHL edi 3 | mov D@nSqrBits1 edi | mov D@nSqrtBits edi
;DBGBP
;[PredictSz 8]
    call AnyBitsSQR2predict D@pSqrtBits D@nSqrtBits D@pBits D@nBits | test eax eax | je E0>>
    sub D@nSqrtBits 32
    mov edi PredictSz
L5:
    SHL edi 1 ; upper chunk next size

    mov eax D@nBits | shr eax 5 |  cmp edi eax | jbe L0> ; cmp to 1/4 of SQ size
    mov eax D@nSqrtBits | shr eax 3 | cmp edi eax | ja L3>>
    mov edi eax ; load full
 L0:
    mov eax D@nSqrtBits | shr eax 3 | add eax D@pSqrtBits | sub eax edi | mov D@tpSqrBits eax ; Num chunk pos
    lea eax D$edi*8 | add eax 32 | mov D@nSqrBits1 eax ; Num chunk sz+32
    mov eax D@tpSqrBits | sub eax D@pSqrtBits | SHL eax 1 | add eax D@pBits | mov D@tpBits eax ; SQ chunk pos
    mov edx D@nBits | shr edx 3 | add edx D@pBits | sub edx D@tpBits | SHL edx 3 | mov D@tnBits edx ; SQ chunk sz
    jmp L4>>

L0:
    call AnyBitsCompare D@pSqrBits1 D@nSqrBits1 D@tpSqrBits D@nSqrBits1 | test eax eax | je E0>>
    cmp eax 3 | je L5<
    cmp ecx 4 | ja L1>
    cmp eax 1 ; low dword direct adjustment
    mov eax D@tpSqrBits, edx D@pSqrBits1, ecx D$eax, edx D$edx
    je L2>
    sub edx ecx | cmp edx 1 | je L5<<
    add edx ecx
L6: add ecx edx | mov edx 0 | adc edx 0 | shr ecx 1 | ror edx 1 | or ecx edx | mov D$eax ecx
    jmp L4>
L2:
    sub ecx edx | cmp ecx 1 | jne L2> | mov D$eax edx | jmp L5<<
L2:
    add ecx edx | jmp L6<

L1:
;    DBGBP
    cmp eax 2 | jne L1>
    call AnyBitsSubstraction D@pBits1 D@nSqrBits1 D@tpSqrBits D@nSqrBits1 D@pSqrBits1 D@nSqrBits1
    call GetHighestBitPosition  D@pBits1 D@nSqrBits1 | cmp edx 0-1 | je E0>>
    cmp eax 2 | jb L5<<
L1:
    call AnyBitsAdditionSelf D@pSqrBits1 D@nSqrBits1 D@tpSqrBits D@nSqrBits1 | test eax eax | je E0>
    call AnyBitsShift1Right D@tpSqrBits D@nSqrBits1 | test eax eax | je E0>
L4:
    mov eax D@tnBits | shr eax 3 | call CopyMemory D@pBits1 D@tpBits eax
    call AnyBitsDivision D@pSqrBits1 D@nSqrBits1 D@tpSqrBits D@nSqrBits1 D@pBits1 D@tnBits | test eax eax | je E0>
jmp L0<<

L3:
    mov ebx 1
E0:
    call VFree D@pSqrBits1
    call VFree D@pBits1
    test ebx ebx | jne L0>
    and D@nSqrtBits 0
L0: mov edx D@nSqrtBits
    mov eax ebx
EndP
;
;
;
;
;
; returns EAX 0 on error, EDX actual Bit Size ; nBits>64bit
; min nSqrtBits = (nBits /2)align32 +32
Proc AnyBitsSquareRootSmall::
 Arguments @pSqrBits @nSqrBits @pBits @nBits
 cLocal @nSqrBits1 @pSqrBits1 @tpSqrBits @tnBits @pBits1 @tpBits

 USES EBX EDI ; ESI

    sub ebx ebx
    mov edi D@nBits | test edi 00_11111 | jne E0>> | shr edi 3 | je E0>>
    mov eax D@nSqrBits | test eax 00_11111 | jne E0>> | shr eax 3 | je E0>>
    call GetHighestBitPosition  D@pBits D@nBits | cmp edx 0-1 | je E0>>
    cmp eax 64 | jb E0>>
    mov edi eax | mov ecx D@nSqrBits
    SHR eax 1 | ALIGN_UP 32 eax | add eax 32 | cmp eax ecx | ja E0>>
    sub eax 32 | mov D@nSqrBits eax | ALIGN_UP 32 edi | mov D@nBits edi
    sub eax eax | mov edi D@pSqrBits | SHR ecx 5 | CLD | REP STOSD | mov edi D@nBits
    push 0 ; border
; align stack 16
L0: test esp (16-1) | je L0> | push 0 | jmp L0<
L0:
    mov ecx edi | ALIGN_ON 128 ecx
; allocate stack
    SHR ecx 5
L0: push 0 | LOOP L0<
    mov D@pBits1 esp

    push 0,0,0,0 ; border
L0:
    shr edi 1 | je E0>> | ALIGN_ON 32 edi | add edi 32 ; +32bit
    mov ecx edi | ALIGN_ON 128 ecx
; allocate stack
    SHR ecx 5
L0: push 0 | LOOP L0<
    mov D@pSqrBits1 esp

    mov D@nSqrBits1 edi

[PredictSSz 4]
    mov edx D@nBits | shr edx 3 | add edx D@pBits | sub edx (PredictSSz*2)
;DBGBP
call SQRT64 edx
    mov edx D@nSqrBits | shr edx 3 | add edx D@pSqrBits | sub edx PredictSSz
    mov ecx D@nBits | and ecx 32 | SHR ecx 4 | sub edx ecx | mov D$edx eax
    test ecx 2 | je L0> | and W$edx-2 0 | and W$edx+4 0
L0:
    mov edi PredictSSz
L5:
    SHL edi 1 ; upper chunk next size

    mov eax D@nBits | shr eax 5 |  cmp edi eax | jbe L0> ; cmp to 1/4 of SQ size
    mov eax D@nSqrBits | shr eax 3 | cmp edi eax | ja L3>>
    mov edi eax ; load full
 L0:
    mov eax D@nSqrBits | shr eax 3 | add eax D@pSqrBits | sub eax edi | mov D@tpSqrBits eax ; Num chunk pos
    lea eax D$edi*8 | add eax 32 | mov D@nSqrBits1 eax ; Num chunk sz+32
    mov eax D@tpSqrBits | sub eax D@pSqrBits | SHL eax 1 | add eax D@pBits | mov D@tpBits eax ; SQ chunk pos
    mov edx D@nBits | shr edx 3 | add edx D@pBits | sub edx D@tpBits | SHL edx 3 | mov D@tnBits edx ; SQ chunk sz
    jmp L4>>

L0:
    call AnyBitsCompare D@pSqrBits1 D@nSqrBits1 D@tpSqrBits D@nSqrBits1 | test eax eax | je E0>>
    cmp eax 3 | je L5<
    cmp ecx 4 | ja L1>
    cmp eax 1 ; low dword direct adjustment
    mov eax D@tpSqrBits, edx D@pSqrBits1, ecx D$eax, edx D$edx
    je L2>
    sub edx ecx | cmp edx 1 | je L5<<
    add edx ecx
L6: add ecx edx | mov edx 0 | adc edx 0 | shr ecx 1 | ror edx 1 | or ecx edx | mov D$eax ecx
    jmp L4>
L2:
    sub ecx edx | cmp ecx 1 | jne L2> | mov D$eax edx | jmp L5<<
L2:
    add ecx edx | jmp L6<

L1:
;    DBGBP
    cmp eax 2 | jne L1>
    call AnyBitsSubstraction D@pBits1 D@nSqrBits1 D@tpSqrBits D@nSqrBits1 D@pSqrBits1 D@nSqrBits1 | test eax eax | je E0>>
    call GetHighestBitPosition  D@pBits1 D@nSqrBits1 | cmp edx 0-1 | je E0>>
    cmp eax 2 | jb L5<<
L1:
    call AnyBitsAdditionSelf D@pSqrBits1 D@nSqrBits1 D@tpSqrBits D@nSqrBits1 | test eax eax | je E0>
    call AnyBitsShift1Right D@tpSqrBits D@nSqrBits1 | test eax eax | je E0>
L4:
    mov eax D@tnBits | shr eax 3 | call CopyMemory D@pBits1 D@tpBits eax
    call AnyBitsDivision D@pSqrBits1 D@nSqrBits1 D@tpSqrBits D@nSqrBits1 D@pBits1 D@tnBits | test eax eax | je E0>
jmp L0<<

L3:
    mov ebx 1
    mov edx D@nSqrBits
E0:
    mov eax ebx
EndP


TITLE SQRTN

ALIGN 16

Proc NRoot32::
ARGUMENTS @Bits32 @RotN
 USES EBX ESI
;DBGBP
    sub eax eax
    lea edx D@Bits32
    BSR ebx D$edx | je P9> ; 0
    CMP D@RotN 2 | jl P9>

    mov eax ebx | sub edx edx | DIV D@RotN
    mov ebx eax | mov eax 1 | cmp ebx 2 | jb P9>

    sub ecx ecx
    add ebx 1
L0: sub ebx 1 | jl L3>
    mov esi D@RotN
    BTS ecx ebx
    mov eax ecx | jmp L4>

L2: MUL ecx | jo L1>
L4: sub esi 1 | jg L2<
    cmp eax D@Bits32 | jb L0< | je L3>
L1:
    BTR ecx ebx
    jmp L0<

L3: mov eax ecx
EndP
;
;
Proc NRoot64::
 ARGUMENTS @pBits64 @RotN
 Local @n64 @n32
 USES EBX ESI EDI
;DBGBP
    sub eax eax
;    sub ebx ebx
    mov esi D@pBits64
    lea edx D$esi+8

L0: sub edx 4 | cmp edx esi | jb P9> ; 0, End.
    BSR ebx D$edx | je L0<
    sub edx esi | lea ebx D$edx*8+ebx
;    cmp ebx 32 | jae L0>
;    call NRoot32 D$esi D@RotN | jmp P9>
    CMP D@RotN 2 | jl P9>

    mov eax ebx | sub edx edx | DIV D@RotN
    mov ebx eax | mov eax 1 | cmp ebx 2 | jb P9>

    sub ecx ecx
    add ebx 1
    mov edi D@pBits64
L0: sub ebx 1 | jl L3>
    mov esi D@RotN
    BTS ecx ebx
    mov D@n32 ecx | and D@n64 0
    jmp L4>

L2: mov eax D@n32 | MUL ecx
    mov D@n32 eax | mov eax D@n64 | mov D@n64 edx | MUL ecx | jo L1>
    add D@n64 eax | jc L1>
L4: sub esi 1 | jg L2<
    mov edx D@n64
    cmp edx D$edi+4 | ja L1> | jb L0<
    mov eax D@n32
    cmp eax D$edi | jb L0< | je L3>
L1:
    BTR ecx ebx
    jmp L0<

L3: mov eax ecx
EndP
;
;
Proc AnyBitsNRootSmall::
 ARGUMENTS @pAnyBits2 @nAnyBits2 @pAnyBits1 @nAnyBits1 @RotN
 cLocal @SqSqr ;@AnyBits1Len
 USES EBX EDI
;DBGBP
    mov eax D@nAnyBits1 | test eax 00_11111 | jne B0>> | shr eax 3 | je B0>>
    mov ecx D@nAnyBits2 | test ecx 00_11111 | jne B0>> | shr ecx 3 | je B0>>

    CMP D@RotN 2 | jl B0>>

    add eax D@pAnyBits1
; search highest bits.
    mov edx eax
L0: sub edx 4 | cmp edx D@pAnyBits1 | jb B0>> ; 0, End.
    BSR eax D$edx | je L0<
    sub edx D@pAnyBits1 | lea edx D$edx*8+eax
;    mov D@AnyBits1Len edx
    mov ebx edx
    ALIGN_UP 32 edx | mov D@nAnyBits1 edx

    sub edx edx | mov eax ebx | DIV D@RotN | mov ebx eax
    ALIGN_UP 32 eax | cmp eax D@nAnyBits2 | ja B0>>

    mov ecx D@nAnyBits2, edi D@pAnyBits2 | mov D@nAnyBits2 eax
    sub eax eax | SHR ecx 5 | CLD | REP STOSD

    cmp ebx 2 | jae L0>
    mov edx D@pAnyBits2, eax 1, D$edx eax | jmp P9>

L0:
    mov edi D@pAnyBits2
    add ebx 1
L0: sub ebx 1 | jl L3>
    BTS D$edi ebx ; Try bit
    call AnyBitsPower D@pAnyBits2 D@nAnyBits2 D@RotN | test eax eax | je B0>
    mov D@SqSqr eax
    call AnyBitsCompare D@SqSqr edx D@pAnyBits1 D@nAnyBits1 | test eax eax | je B0>
    cmp eax 1 | je L1> | cmp eax 3 | je L3>
    BTR D$edi ebx ; reset bit
L1:
    call VFree D@SqSqr | and D@SqSqr 0
    jmp L0<
L3:
    call VFree D@SqSqr
    mov edx D@nAnyBits2
    mov eax 1 | jmp P9>
B0:
    call VFree D@SqSqr
    sub eax eax ; params ERROR case
EndP
;
;
;
Proc AnyBitsNRoot::
 Arguments @pSqrBits @nSqrBits @pBits @nBits @NRoot
 cLocal @nSqrBits1 @pSqrBits1

    updateBitSize D@pBits D@nBits
    mov ecx D@NRoot
    cmp ecx 2 | jl E0> | cmp ecx 010000000 | jb L0>
E0: sub eax eax | jmp P9>>
L0:
    cmp D@nBits 32 | je L2>
    cmp D@nBits 64 | je L3>

    call GetHighestBitPosition  D@pBits D@nBits | cmp edx 0-1 | je E0<
    mov ecx eax
    sub edx edx | DIV D@NRoot
    cmp eax 96 | jae L1>
    LEAVE | jmp AnyBitsNRootSmall
L2:
    mov edx D@pBits
    call NRoot32 D$edx D@NRoot | test eax eax | je P9>
    mov edx D@pSqrBits | mov D$edx eax
    mov eax 1, edx 32 | jmp P9>
L3:
    mov edx D@pBits
    call NRoot64 edx D@NRoot | test eax eax | je P9>
    mov edx D@pSqrBits | mov D$edx eax
    mov eax 1, edx 32 | jmp P9>
L1:
    call AnyBitsNRootBig D@pBits D@nBits D@NRoot | test eax eax | je P9>
    mov D@pSqrBits1 eax, D@nSqrBits1 edx
    SHR edx 3 | call CopyMemory D@pSqrBits D@pSqrBits1 edx
    call VFree D@pSqrBits1
    mov eax 1, edx D@nSqrBits1
EndP
;
;
;
Proc AnyBitsNRootBig::
 Arguments @pBits @nBits @NRoot
 cLocal @nSqrBits @pSqrBits @nSqrBits1 @pSqrBits1 @pBits1 @tnSqrBits @tpSqrBits @tnBits @tpBits @nSqSqr @SqSqr @lastdo
 USES EBX ESI EDI

    sub ebx ebx
    CMP D@NRoot 2 | jl E0>>
    mov eax D@nBits | test eax 00_11111 | jne E0>> | shr eax 3 | je E0>>

    call GetHighestBitPosition  D@pBits D@nBits | cmp edx 0-1 | je E0>>
;    cmp eax 04000 | jbe E0>>
    mov edi eax, esi eax

    ALIGN_UP 32 edi
    mov D@nBits edi | SHR edi 3
    call VAlloc edi | test eax eax | je E0>> | mov D@pBits1 eax
    sub edx edx | mov eax esi | DIV D@NRoot | cmp eax 96 | JB E0>>
    mov edi eax | ALIGN_UP 32 edi | add edi 64 | SHR edi 3 ; allocate +8
    call VAlloc edi | test eax eax | je E0>> | mov D@pSqrBits eax
    call VAlloc edi | test eax eax | je E0>> | mov D@pSqrBits1 eax
    SHL edi 3 | sub edi 32 | mov D@nSqrBits1 edi | sub edi 32 | mov D@nSqrBits edi

[PredictNRootsz 8]
    call AnyBitsNRootPredict D@pSqrBits D@nSqrBits D@pBits D@nBits D@NRoot | test eax eax | je E0>>
; we can't afford incorect prediction
    mov edi PredictNRootsz
L5:
;DBGBP
    SHL edi 1
;L1:
    mov eax edi | MUL D@NRoot | mov ecx eax
    mov eax D@nBits | shr eax 4 |  cmp ecx eax | jbe L0>

    mov eax D@nSqrBits | shr eax 3 | cmp edi eax | ja L3>>
    mov edi D@nSqrBits | shr edi 3
L0:
    mov eax D@nSqrBits | shr eax 3 | add eax D@pSqrBits | sub eax edi
    mov D@tpSqrBits eax
    lea eax D$edi*8 | mov D@tnSqrBits eax | add eax 32 | mov D@nSqrBits1 eax

    mov eax D@tpSqrBits | sub eax D@pSqrBits | MUL D@NRoot | add eax D@pBits | mov D@tpBits eax
    mov edx D@nBits | shr edx 3 | add edx D@pBits | sub edx D@tpBits | SHL edx 3
    mov D@tnBits edx
    jmp L4>>

L0:
    call AnyBitsCompare D@pSqrBits1 D@nSqrBits1 D@tpSqrBits D@tnSqrBits | test eax eax | je E0>>
    cmp eax 3 | je L5<<
    cmp eax 2 | jne L1>
    call AnyBitsSubstraction D@pBits1 D@nSqrBits1 D@tpSqrBits D@tnSqrBits D@pSqrBits1 D@nSqrBits1 | test eax eax | je E0>>
    call GetHighestBitPosition  D@pBits1 D@nSqrBits1 | cmp edx 0-1 | je E0>>
    cmp eax 32 | jae L1> ;| DBGBP
    mov eax D@pBits1, eax D$eax | cmp eax D@NRoot | ja L1>
    mov edx D@nSqrBits | shr edx 3 | cmp edi edx | jne L5<<
    cmp eax D@NRoot | JB L5<< ; if = do last average
    cmp D@lastdo 0 | jne L5<< | or D@lastdo 1
L1:
    mov eax D@NRoot | dec eax
    mov esi D@tnSqrBits | add esi 32
    call AnyBitsMul32Bit D@pBits1 esi eax D@tpSqrBits D@tnSqrBits | test eax eax | je E0>>
;    updateBitSize D@pBits1 esi
    mov eax D@nSqrBits1 | cmp eax esi | CMOVL eax esi | mov D@tnSqrBits eax
    call AnyBitsAddition D@tpSqrBits D@tnSqrBits D@pSqrBits1 D@nSqrBits1 D@pBits1 esi | test eax eax | je E0>>
    test edx edx | je L2>
    mov eax D@tnSqrBits | SHR eax 3 | add eax D@tpSqrBits | mov D$eax 1 | add D@tnSqrBits 32 ; enlarge. need check??
L2: call AnyBitsDiv32Bit D@tpSqrBits D@tnSqrBits D@NRoot | test eax eax | je E0>>
    updateBitSize D@tpSqrBits D@tnSqrBits
L4:
    mov eax D@NRoot | dec eax
    call AnyBitsPower D@tpSqrBits D@tnSqrBits eax | test eax eax | je E0>
    mov D@SqSqr eax, D@nSqSqr edx

    mov eax D@tnBits | shr eax 3 | call CopyMemory D@pBits1 D@tpBits eax

    mov eax D@tnBits | sub eax D@nSqSqr | jle E0>
    add eax 32 | mov D@nSqrBits1 eax
    call AnyBitsDivision D@pSqrBits1 D@nSqrBits1 D@SqSqr D@nSqSqr D@pBits1 D@tnBits | test eax eax | je E0>
    call VFree D@SqSqr | and D@SqSqr 0
    updateBitSize D@pSqrBits1 D@nSqrBits1
jmp L0<<

L3:
    mov ebx 1
E0:
    call VFree D@SqSqr
    call VFree D@pSqrBits1
    call VFree D@pBits1
    test ebx ebx | jne L0>
    call VFree D@pSqrBits | and D@pSqrBits 0
L0: mov ebx D@pSqrBits, edx D@nSqrBits
    mov eax ebx
EndP
;
;
;
[NRootpredictBits (PredictNRootsz*8) ]
Proc AnyBitsNRootPredict:
 ARGUMENTS @pAnyBits2 @nAnyBits2 @pAnyBits1 @nAnyBits1 @NRoot
 cLocal @nSqSqr @SqSqr @AnyBits1Len @PowBitLen
 USES EBX ESI EDI

    mov eax D@nAnyBits1 | test eax 00_11111 | jne B0>> | shr eax 3 | je B0>>
    mov ecx D@nAnyBits2 | test ecx 00_11111 | jne B0>> | shr ecx 3 | je B0>>
    add eax D@pAnyBits1
; search highest bits.
    mov edx eax
L0: sub edx 4 | cmp edx D@pAnyBits1 | jb B0>> ; Quotent is 0, End.
    BSR eax D$edx | je L0<
    sub edx D@pAnyBits1 | lea edx D$edx*8+eax
    mov D@AnyBits1Len edx, eax edx, ecx D@nAnyBits2 | ALIGN_UP 32 edx | mov D@nAnyBits1 edx
    sub edx edx | DIV D@NRoot | mov ebx eax
    ALIGN_UP 32 eax | cmp ecx eax | jb B0>> | mov D@nAnyBits2 eax

    mov edi D@pAnyBits2, eax 0 | SHR ecx 5 | CLD | REP STOSD
;DBGBP
    mov edi D@pAnyBits2, edx D@nAnyBits2
    sub edx NRootpredictBits | sub ebx edx
    SHR edx 3 | add edi edx ; Num upper chunk position
    mov eax edi | sub eax D@pAnyBits2 | MUL D@NRoot
    mov esi D@pAnyBits1 | add esi eax ; upper chunk position
    mov eax D@nAnyBits1 | SHR eax 3 | add eax D@pAnyBits1 | sub eax esi | SHL eax 3 | mov D@PowBitLen eax; upper chunk size

    add ebx 1
L0: sub ebx 1 | jl L3>
    BTS D$edi ebx
    call AnyBitsPower edi NRootpredictBits D@NRoot | test eax eax | je B0>
    mov D@SqSqr eax, D@nSqSqr edx
    call AnyBitsCompare D@SqSqr D@nSqSqr ESI D@PowBitLen | test eax eax | je B0>
    cmp eax 1 | je L1> | cmp eax 3 | je L3>
    BTR D$edi ebx ; is >
L1:
    call VFree D@SqSqr | and D@SqSqr 0
    jmp L0<
L3:
    call VFree D@SqSqr
    mov eax 1 | jmp P9>
B0:
    call VFree D@SqSqr
    sub eax eax ; params ERROR case
EndP



TITLE GCDs


ALIGN 16

; returns: EAX=0 params error: 32bit unaligned memory size or subsequent procs fails;
; EAX=1, no GCD; EAX=3 numbers are same!; else EAX=GCDptr, EDX=GCDbitSize
Proc GCD::
 ARGUMENTS @pAnyBits2 @nAnyBits2 @pAnyBits1 @nAnyBits1
 USES edi
    mov eax D@nAnyBits1 | test eax 00_11111 | jne E0>> | shr eax 3 | je E0>>
    mov ecx D@nAnyBits2 | test ecx 00_11111 | jne E0>> | shr ecx 3 | je E0>>

    updateBitSize D@pAnyBits1 D@nAnyBits1
    updateBitSize D@pAnyBits2 D@nAnyBits2

    call AnyBitsCompare D@pAnyBits2 D@nAnyBits2 D@pAnyBits1 D@nAnyBits1 | test eax eax | je E0>>
    cmp eax 3 | je P9>> | cmp eax 1 | je L0>
    exchange D@pAnyBits1 D@pAnyBits2, D@nAnyBits1 D@nAnyBits2
L0:
    call GetHighestBitPosition D@pAnyBits2 D@nAnyBits2 | cmp eax 0 | jne L0>
    mov eax D@pAnyBits2 | mov eax D$eax | cmp eax 1 | je P9>> ; on 1, say no GCD, as on finish
    mov eax D@pAnyBits1, edx D@nAnyBits1 ; on 0, other is GCD. by convention.
    jmp P9>>
L0:
    cmp D@nAnyBits2 32 | je L1>
    call AnyBitsModulus D@pAnyBits2 D@nAnyBits2 D@pAnyBits1 D@nAnyBits1 | test eax eax | je E0>>
    updateBitSize D@pAnyBits1 D@nAnyBits1
    call GetHighestBitPosition D@pAnyBits1 D@nAnyBits1 | cmp eax 0 | je L0>>
    exchange D@pAnyBits1 D@pAnyBits2, D@nAnyBits1 D@nAnyBits2
    jmp L0<
L1:
    mov eax D@pAnyBits2 | call AnyBitsMod32Bit D@pAnyBits1 D@nAnyBits1 D$eax | test eax eax | je E0>>
    mov ecx D@nAnyBits1 | mov edi D@pAnyBits1 | SHR ecx 5 | sub eax eax | REP STOSD
    mov edi D@pAnyBits1 | mov D$edi edx | mov D@nAnyBits1 32 | cmp edx 1 | jbe L0>
;    exchange D@pAnyBits1 D@pAnyBits2, D@nAnyBits1 D@nAnyBits2
    mov eax D@pAnyBits1 | mov edx D@pAnyBits2
    call GCD32 D$edx D$eax | cmp eax 1 | ja L1> | xchg eax edx
L1: mov ecx D@pAnyBits1 | mov edi D@pAnyBits2 | mov D$ecx edx | mov D$edi eax
    jmp L0>
L0:
; 0 or 1 ?
    sub edx edx | mov eax D@pAnyBits1 | mov eax D$eax | cmp eax 1 | je P9> ; on 1, say no GCD
    mov eax D@pAnyBits2, edx D@nAnyBits2
    jmp P9>
E0:
    sub eax eax ; params ERROR case
EndP



ALIGN 4

; EAX=1: no GCD EDX=lastDivisor; EAX=0: numbers are same; else EAX=GCD,EDX=0
Proc GCD32::
 ARGUMENTS @Num32B @Num32A

    sub edx edx | mov eax D@Num32A | mov ecx D@Num32B | cmp eax ecx | jne L0>
    mov eax 0 | jmp P9> ; same nums
L0: ja L1> | xchg eax ecx | jmp L1>
; eax > ecx
L0:
    sub edx edx | DIV ecx | mov eax ecx | mov ecx edx
L1:
    cmp ecx 0 | je P9> ; on 0, EAX is GCD. even on start, by convention.
    cmp ecx 1 | jne L0<
    mov edx eax ; last divisor
L2: mov eax 1 ; no GCD

EndP






TITLE DLLMAIN
____________________________________________________________________________________________

ALIGN 16

main:
    mov eax 1
    ret 0C


AnyBitsVersion::
    mov eax 010004
    ret


Proc VAlloc::
 ARGUMENTS @vsize
    mov eax D@vsize | cmp eax 0 | jg L0> | sub eax eax | jmp P9>
L0:
    call 'Kernel32.VirtualAlloc', 0, eax, &MEM_COMMIT__&MEM_RESERVE, &PAGE_READWRITE
EndP

Proc VFree::
 ARGUMENTS @addr
    mov eax D@addr | cmp eax 0 | jg L0> | sub eax eax | jmp P9>
L0:
    call 'Kernel32.VirtualFree', eax, 0, &MEM_RELEASE
EndP


Proc CopyMemory:
 ARGUMENTS @outMem @inMem @inMemSize
 USES ESI EDI

    CLD | mov ecx D@inMemSize | mov esi D@inMem | mov edi D@outMem | mov edx ecx
    shr ecx 2 | and edx 3 | REP MOVSD | mov ecx edx | REP MOVSB

EndP



