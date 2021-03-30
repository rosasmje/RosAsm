____________________________________________________________________________________________

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
[Align_on | add #2 #1-1 | and #2 0-#1]
_____________________________________________________________________________________________















TITLE numeriko

; find all below 010002
; returns EAX last Prime, EDX next poiner
proc Numeriko16::
 ARGUMENTS @pT
 USES EBX ESI EDI

    cld
    mov edi D@pT | mov ebx 1 | mov esi ebx | jmp N0>
R0: mov ecx 1
; divisor loop
R1: add ecx 2 | cmp ebx ecx | jbe G1>

    mov eax ebx | sub edx edx | div ecx | test edx edx | je N0>
    cmp eax ecx | jbe G1> | jmp R1<
;is good
G1: mov eax ebx | sub eax esi | shr eax 1 | mov esi ebx | stosb
N0: add ebx 2 | cmp ebx 010002 | jb R0<
    mov eax esi
    sub edi D@pT | mov edx edi
EndP



; returns EAX last Prime, EDX bytes-count
proc Numeriko32::
 ARGUMENTS @pTfirst @pTnext @startN @count
 LOCAL @prevN
 USES EBX ESI EDI

    cld
    mov edi D@pTnext | mov ebx D@startN | mov D@prevN ebx | jmp N0>
R0:
    mov ecx 1 | mov esi D@pTfirst
R1: ; divisor loop
    movzx eax B$esi | shl eax 1 | inc esi | add ecx eax ;| cmp ebx ecx | jbe G1>

    mov eax ebx | sub edx edx | div ecx | test edx edx | je N0>
    cmp eax ecx | jbe G1> | jmp R1<
;is good
G1: mov eax ebx | sub eax D@prevN | cmp eax 01FE | ja B2>
B0:
    shr eax 1 | stosb | mov D@prevN ebx | dec D@count | jle L9>
N0: add ebx 2 | jnc R0<
    mov al 0 | mov ecx D@count | push edi | rep stosb | pop edi
L9: mov edx edi
    mov eax D@prevN
    sub edx D@pTnext
jmp P9>
B2: int3
EndP


; returns EAX last Prime_Lo, EDX last Prime_Hi, ECX count
; will stop on 4GB bounds
proc Numeriko64::
 ARGUMENTS @pTfirst @pTnext @startNLo @startNHi @count
 LOCAL @pnext
 USES EBX ESI EDI

    cld
    move D@pnext D@pTnext
    mov ebx D@startNLo | mov edi D@startNHi | add D@pTfirst 1 | test ebx 1 | je P9>>
    add ebx 2 | adc edi 0 | jc L8>
R0:
    mov ecx 3 | mov esi D@pTfirst | jmp A3>
R1: ; divisor loop
    movzx eax B$esi | inc esi | shl eax 1 | add ecx eax | jc G1>
A3:
    cmp edi ecx | jae R2>
    mov eax ebx | mov edx edi | div ecx | test edx edx | je N0>
    cmp eax ecx | jbe G1> | jmp R1<
; double division
R2:
    sub edx edx | mov eax edi | div ecx
    mov eax ebx | div ecx | test edx edx | je N0>
    jmp R1<
;is good
G1: mov eax ebx ;| mov edx edi |
    sub eax D@startNLo ;| sbb edx D@startNHi |
    cmp eax 01FE | ja B2>
B0: shr eax 1
    mov edx D@pnext | mov B$edx al
    mov D@startNLo ebx | mov D@startNHi edi | inc D@pnext | dec D@count | jle L9>
N0: add ebx 2 | jnc R0< ; | adc edi 0
L8:
    mov al 0 | mov edi D@pnext | mov ecx D@count | rep stosb
L9:
    mov eax D@startNLo | mov edx D@startNHi | mov ecx D@pnext | sub ecx D@pTnext
    jmp P9>
B2: mov edx D@pnext | mov ecx D@count
B3: mov B$edx 0 | inc edx | sub ecx 1 | jle L8<
    sub eax 01FE | cmp eax 01FE | ja B3<
    mov D@pnext edx | mov D@count ecx | jmp B0<
;    call overByte | int3
EndP


; returns EAX last Prime_Lo, EDX last Prime_Hi, ECX count
proc Numeriko64A:
 ARGUMENTS @pTfirst @pTnext @startNLo @startNHi @count
 LOCAL @mod13171923 @mod35711 @pnext
 USES EBX ESI EDI

    cld
    move D@pnext D@pTnext
    mov ebx D@startNLo | mov edi D@startNHi | add D@pTfirst 10 | test ebx 1 | je P9>>

    call GetOddNumModPosition ebx edi 3
    mov B@mod35711 al

;0 2 4 1 3
;5 4 3 2 1
    call GetOddNumModPosition ebx edi 5
    mov B@mod35711+1 al

;0 2 4 6 1 3 5
;7 6 5 4 3 2 1
    call GetOddNumModPosition ebx edi 7
    mov B@mod35711+2 al

;0  2  4 6 8 10 1 3 5 7 9
;11 10 9 8 7 6  5 4 3 2 1
    call GetOddNumModPosition ebx edi 11
    mov B@mod35711+3 al

    call GetOddNumModPosition ebx edi 13
    mov B@mod13171923 al

    call GetOddNumModPosition ebx edi 17
    mov B@mod13171923+1 al

    call GetOddNumModPosition ebx edi 19
    mov B@mod13171923+2 al

    call GetOddNumModPosition ebx edi 23
    mov B@mod13171923+3 al

    jmp N0>>

R0: sub edx edx

    sub B@mod35711 1 | jne L0>
    mov B@mod35711 3 | or edx 1

L0: sub B@mod35711+1 1 | jne L0>
    mov B@mod35711+1 5 | or edx 1

L0: sub B@mod35711+2 1 | jne L0>
    mov B@mod35711+2 7 | or edx 1

L0: sub B@mod35711+3 1 | jne L0>
    mov B@mod35711+3 11 | or edx 1

L0: sub B@mod13171923 1 | jne L0>
    mov B@mod13171923 13 | or edx 1

L0: sub B@mod13171923+1 1 | jne L0>
    mov B@mod13171923+1 17 | or edx 1

L0: sub B@mod13171923+2 1 | jne L0>
    mov B@mod13171923+2 19 | or edx 1

L0: sub B@mod13171923+3 1 | jne L0>
    mov B@mod13171923+3 23 | or edx 1

L0:
    test edx edx | jne N0>
    mov esi D@pTfirst | mov ecx 23 | ;jmp A3>
R1: ; divisor loop
    movzx eax B$esi | inc esi | test eax 1 | jne A2>
A1: add ecx eax | jc G1>
A3:
    cmp edi ecx | jae R2>
    mov eax ebx | mov edx edi | div ecx | test edx edx | je N0>
    cmp eax ecx | jbe G1> | jmp R1<
; double division
R2:
    sub edx edx | mov eax edi | div ecx
    mov eax ebx | div ecx | test edx edx | je N0>
    jmp R1<
A2: and eax 0-2 | or eax 0100 | jmp A1<
;is good
G1: mov eax ebx ;| mov edx edi |
    sub eax D@startNLo ;| sbb edx D@startNHi |
    cmp eax 0FE | ja B1>
B0:
    mov edx D@pnext | mov B$edx al
    mov D@startNLo ebx | mov D@startNHi edi | inc D@pnext | dec D@count | jle L9>
N0: add ebx 2 | adc edi 0 | jnc R0<<

L8:
    mov al 0 | mov edi D@pnext | mov ecx D@count | rep stosb
L9:
    mov eax D@startNLo | mov edx D@startNHi | mov ecx D@pnext | sub ecx D@pTnext
    jmp P9>
B1: cmp eax 01FE | ja B2> | or al 1 | jmp B0<
B2: mov edx D@pnext | mov ecx D@count
B3: mov B$edx 0 | inc edx | sub ecx 1 | jle L8<
    sub eax 01FE | cmp eax 01FE | ja B3<
    mov D@pnext edx | mov D@count ecx
    cmp eax 0FE | jbe B0<
    or al 1 | jmp B0<
;    call overByte | int3
EndP


; returns EAX last Prime_Lo, EDX last Prime_Hi, ECX count
proc Numeriko64B:
 ARGUMENTS @pTfirst @pTnext @startNLo @startNHi @count
 LOCAL @mod29313741 @mod13171923 @mod35711 @pnext
 USES EBX ESI EDI

    cld
    move D@pnext D@pTnext
    mov ebx D@startNLo | mov edi D@startNHi | add D@pTfirst 14 | test ebx 1 | je P9>>

    call GetOddNumModPosition ebx edi 3
    mov B@mod35711 al
;0 2 4 1 3
;5 4 3 2 1
    call GetOddNumModPosition ebx edi 5
    mov B@mod35711+1 al
;0 2 4 6 1 3 5
;7 6 5 4 3 2 1
    call GetOddNumModPosition ebx edi 7
    mov B@mod35711+2 al
;0  2  4 6 8 10 1 3 5 7 9
;11 10 9 8 7 6  5 4 3 2 1
    call GetOddNumModPosition ebx edi 11
    mov B@mod35711+3 al

    call GetOddNumModPosition ebx edi 13
    mov B@mod13171923 al

    call GetOddNumModPosition ebx edi 17
    mov B@mod13171923+1 al

    call GetOddNumModPosition ebx edi 19
    mov B@mod13171923+2 al

    call GetOddNumModPosition ebx edi 23
    mov B@mod13171923+3 al

    call GetOddNumModPosition ebx edi 29
    mov B@mod29313741 al

    call GetOddNumModPosition ebx edi 31
    mov B@mod29313741+1 al

    call GetOddNumModPosition ebx edi 37
    mov B@mod29313741+2 al

    call GetOddNumModPosition ebx edi 41
    mov B@mod29313741+3 al

    jmp N0>>

R0: sub edx edx

    sub B@mod35711 1 | jne L0>
    mov B@mod35711 3 | or edx 1

L0: sub B@mod35711+1 1 | jne L0>
    mov B@mod35711+1 5 | or edx 1

L0: sub B@mod35711+2 1 | jne L0>
    mov B@mod35711+2 7 | or edx 1

L0: sub B@mod35711+3 1 | jne L0>
    mov B@mod35711+3 11 | or edx 1

L0: sub B@mod13171923 1 | jne L0>
    mov B@mod13171923 13 | or edx 1

L0: sub B@mod13171923+1 1 | jne L0>
    mov B@mod13171923+1 17 | or edx 1

L0: sub B@mod13171923+2 1 | jne L0>
    mov B@mod13171923+2 19 | or edx 1

L0: sub B@mod13171923+3 1 | jne L0>
    mov B@mod13171923+3 23 | or edx 1

L0: sub B@mod29313741 1 | jne L0>
    mov B@mod29313741 29 | or edx 1

L0: sub B@mod29313741+1 1 | jne L0>
    mov B@mod29313741+1 31 | or edx 1

L0: sub B@mod29313741+2 1 | jne L0>
    mov B@mod29313741+2 37 | or edx 1

L0: sub B@mod29313741+3 1 | jne L0>
    mov B@mod29313741+3 41 | or edx 1

L0:
    test edx edx | jne N0>
    mov esi D@pTfirst | mov ecx 41 | ;jmp A3>
R1: ; divisor loop
    movzx eax B$esi | inc esi | test eax 1 | jne A2>
A1: add ecx eax | jc G1>
A3:
    cmp edi ecx | jae R2>
    mov eax ebx | mov edx edi | div ecx | test edx edx | je N0>
    cmp eax ecx | jbe G1> | jmp R1<
; double division
R2:
    sub edx edx | mov eax edi | div ecx
    mov eax ebx | div ecx | test edx edx | je N0>
    jmp R1<
A2: and eax 0-2 | or eax 0100 | jmp A1<
;is good
G1: mov eax ebx ;| mov edx edi |
    sub eax D@startNLo ;| sbb edx D@startNHi |
    cmp eax 0FE | ja B1>
B0:
    mov edx D@pnext | mov B$edx al
    mov D@startNLo ebx | mov D@startNHi edi | inc D@pnext | dec D@count | jle L9>
N0: add ebx 2 | adc edi 0 | jnc R0<<

L8:
    mov al 0 | mov edi D@pnext | mov ecx D@count | rep stosb
L9:
    mov eax D@startNLo | mov edx D@startNHi | mov ecx D@pnext | sub ecx D@pTnext
    jmp P9>
B1: cmp eax 01FE | ja B2> | or al 1 | jmp B0<
B2: mov edx D@pnext | mov ecx D@count
B3: mov B$edx 0 | inc edx | sub ecx 1 | jle L8<
    sub eax 01FE | cmp eax 01FE | ja B3<
    mov D@pnext edx | mov D@count ecx
    cmp eax 0FE | jbe B0<
    or al 1 | jmp B0<
;    call overByte | int3
EndP


Proc GetOddNumModPosition:
 ARGUMENTS @NLo @NHi @Mod32
 USES ESI EDI

    mov ecx D@Mod32
    mov esi ecx | mov edi esp | sub edx edx | jmp L1>
L0: add esi 2 | sub edx edx | mov eax esi | div ecx | test edx edx | je L0>
L1: dec edi | mov B$edi dl | jmp L0<
L0:
    sub edx edx | mov eax D@NHi | div ecx | mov eax D@NLo | div ecx
    mov eax edi
L0: cmp B$eax dl | je L0> | inc eax | jmp L0<
L0: sub eax edi | inc eax
EndP


;;
proc IsQwordPrime0:
 ARGUMENTS @NLo @NHi
 USES EBX EDI

    cld
    mov ebx D@NLo | mov edi D@NHi | test ebx 1 | je B0>

    mov ecx 1
R1: ; divisor loop
    add ecx 2 | cmp ecx 0FFFFFFFB | ja G1>

    cmp edi ecx | jae R2>
    mov eax ebx | mov edx edi | div ecx | test edx edx | je B0>
    cmp eax ecx | jbe G1> | jmp R1<
; double division
R2:
    sub edx edx | mov eax edi | div ecx
    mov eax ebx | div ecx | test edx edx | je B0>
    jmp R1<

;N0: add ebx 2 | adc edi 0 | jnc R0<
;?
B0: mov eax 0 | jmp P9>
G1:
    mov eax 1 ;ebx | mov edx edi
EndP


proc FindNextPrimeQword0:
 ARGUMENTS @NLo @NHi
 USES EBX EDI

    cld
    mov ebx D@NLo | mov edi D@NHi
    test edi edi | jne L0>
    cmp ebx 3 | jae L0> | inc ebx | jmp G1>
L0: test ebx 1 | jne N0> | or ebx 1

R0:
    mov ecx 1
R1: ; divisor loop
    add ecx 2 | cmp ecx 0FFFFFFFB | ja G1>

    cmp edi ecx | jae R2>
    mov eax ebx | mov edx edi | div ecx | test edx edx | je N0>
    cmp eax ecx | jbe G1> | jmp R1<
R2: ; double division
    sub edx edx | mov eax edi | div ecx
    mov eax ebx | div ecx | test edx edx | je N0>
    jmp R1<

N0: add ebx 2 | adc edi 0 | jnc R0<
B0: mov ebx 0, edi 0
G1: mov eax ebx | mov edx edi
EndP


proc FindPrevPrimeQword0:
 ARGUMENTS @NLo @NHi
 USES EBX EDI

    cld
    mov ebx D@NLo | mov edi D@NHi
    test edi edi | jne L0>
    cmp ebx 5 | ja L0> | je L1> | dec ebx | je B0> | jmp G1>
L1: mov ebx 3 | jmp G1>
L0: test ebx 1 | jne N0> | or ebx 1 | jmp N0>

R0:
    mov ecx 1
R1: ; divisor loop
    add ecx 2 | cmp ecx 0FFFFFFFB | ja G1>

    cmp edi ecx | jae R2>
    mov eax ebx | mov edx edi | div ecx | test edx edx | je N0>
    cmp eax ecx | jbe G1> | jmp R1<
R2: ; double division
    sub edx edx | mov eax edi | div ecx
    mov eax ebx | div ecx | test edx edx | je N0>
    jmp R1<

N0: sub ebx 2 | sbb edi 0 | jnc R0<
B0: mov ebx 0, edi 0
G1: mov eax ebx | mov edx edi
EndP
;;


; returns EAX True, ECX last divisor
proc IsDwordPrimeNumeriko32::
 ARGUMENTS @Bit32
 LOCAL @prevN
 USES EBX ESI

    mov ebx D@Bit32 | test ebx 1 | mov ecx 2 | je N0>
    cmp ebx 4 | jb G1>
R0: mov ecx 1 | mov esi Bit16Primes
; divisor loop
R1:
    movzx eax B$esi | shl eax 1 | inc esi | add ecx eax

    mov eax ebx | sub edx edx | div ecx | test edx edx | je N0>
    cmp eax ecx | jbe G1> | jmp R1<
N0: mov eax 0 | jmp P9>
;is good
G1: mov eax 1
EndP
;

;
proc FindNextPrimeDwordNumeriko32::
 ARGUMENTS @Num32
 USES EBX ESI

    mov ebx D@Num32 | cmp ebx 3 | jae L0> | inc ebx | jmp G1>
L0: test ebx 1 | jne N0> | or ebx 1

R0: mov ecx 1 | mov esi Bit16Primes
; divisor loop
R1:
    movzx eax B$esi | shl eax 1 | inc esi | add ecx eax

    mov eax ebx | sub edx edx | div ecx | test edx edx | je N0>
    cmp eax ecx | jbe G1> | jmp R1<

N0: add ebx 2 | jnc R0<
B0: mov ebx 0
G1: mov eax ebx
EndP
;

; returns EAX > True/False, ECX > divisor
proc IsQwordPrimeNumeriko64::
 ARGUMENTS @pB32Primes @QwordLo @QwordHi
 LOCAL @pnext
 USES EBX ESI EDI

    mov ebx D@QwordLo | mov edi D@QwordHi | test ebx 1 | mov ecx 2 | je N0>
    test edi edi | jne R0> | cmp ebx 4 | jb G1>
R0: mov ecx 1 | mov esi D@pB32Primes
; divisor loop
R1:
    movzx eax B$esi | inc esi | shl eax 1 | add ecx eax | jc G1>
    cmp edi ecx | jae R2>
    mov eax ebx | mov edx edi | div ecx | test edx edx | je N0>
    cmp eax ecx | jbe G1> | jmp R1<
; double division
R2:
    sub edx edx | mov eax edi | div ecx
    mov eax ebx | div ecx | test edx edx | jne R1<

N0: mov eax 0 | jmp P9>
G1: mov eax 1
EndP
;
;
; returns EAX > True/False, ECX > divisor
proc FindNextPrimeQwordNumeriko64::
 ARGUMENTS @pB32Primes @QwordLo @QwordHi
 LOCAL @pnext
 USES EBX ESI EDI

    mov ebx D@QwordLo | mov edi D@QwordHi | test ebx 1 | jne N0>
    or ebx 1 | test edi edi | jne R0> | cmp ebx 4 | jb G1>

R0: mov ecx 1 | mov esi D@pB32Primes
; divisor loop
R1:
    movzx eax B$esi | inc esi | shl eax 1 | add ecx eax | jc G1>
    cmp edi ecx | jae R2>
    mov eax ebx | mov edx edi | div ecx | test edx edx | je N0>
    cmp eax ecx | jbe G1> | jmp R1<
; double division
R2:
    sub edx edx | mov eax edi | div ecx
    mov eax ebx | div ecx | test edx edx | jne R1<

N0: add ebx 2 | adc edi 0 | jnc R0<
B0: mov ebx 0, edi 0
G1: mov eax ebx, edx edi
EndP
;

; 0-5 > 14979 Divs for 7, 13618 for 11
proc IsDwordPrime::
 ARGUMENTS @Num32
 LOCAL @mod35711 ;@cnt
 USES EBX
;mov D@cnt 0

    mov ebx D@Num32
    cmp ebx 4 | ja L0> | je B0>> | cmp ebx 0 | je B0>> | jmp G1>>
L0: test ebx 1 | je B0>>
    mov ecx 1
R1: ; divisor loop
    add ecx 2 | cmp ecx 7 | ja L0>

    mov eax ebx | sub edx edx | div ecx | test edx edx | je B0>>
    cmp eax ecx | jbe G1>> | jmp R1<
L0:
;;
    call GetOddNumModPosition 11 0 3
    mov B@mod35711 al
    call GetOddNumModPosition 11 0 5
    mov B@mod35711+1 al
    call GetOddNumModPosition 11 0 7
    mov B@mod35711+2 al
    call GetOddNumModPosition 11 0 11
    mov B@mod35711+3 al
;;
    mov D@mod35711 070401 ; 0B050202
    mov ecx 7
;ALIGN 16
R1: ; divisor loop
    add ecx 2 | cmp ecx 0FFF1 | ja G1>

    sub edx edx
    sub B@mod35711 1 | jne L0> | mov B@mod35711 3 | or edx 1
L0: sub B@mod35711+1 1 | jne L0> | mov B@mod35711+1 5 | or edx 1
L0: sub B@mod35711+2 1 | jne L0> | mov B@mod35711+2 7 | or edx 1
;L0: sub B@mod35711+3 1 | jne L0> | mov B@mod35711+3 11 | or edx 1
L0: test edx edx | jne R1<
;inc D@cnt
    mov eax ebx | sub edx edx | div ecx | test edx edx | je B0>
    cmp eax ecx | jbe G1> | jmp R1<

B0: mov eax 0 | jmp P9>
G1: mov eax 1
EndP
;

;
proc FindNextPrimeDword::
 ARGUMENTS @Num32
 LOCAL @mod35711
 USES EBX

    mov ebx D@Num32
    cmp ebx 3 | jae L0> | inc ebx | jmp G1>>
L0: test ebx 1 | jne N0> | or ebx 1
R0:
    mov ecx 1
R1: ; divisor loop
    add ecx 2 | cmp ecx 7 | ja L0>

    mov eax ebx | sub edx edx | div ecx | test edx edx | je N0>
    cmp eax ecx | jbe G1> | jmp R1<
; double division
L0:
    mov D@mod35711 070401; 0B050202
    mov ecx 7
;ALIGN 16
R1: ; divisor loop
    add ecx 2 | cmp ecx 0FFF1 | ja G1>

    sub edx edx
    sub B@mod35711 1 | jne L0> | mov B@mod35711 3 | or edx 1
L0: sub B@mod35711+1 1 | jne L0> | mov B@mod35711+1 5 | or edx 1
L0: sub B@mod35711+2 1 | jne L0> | mov B@mod35711+2 7 | or edx 1
;L0: sub B@mod35711+3 1 | jne L0> | mov B@mod35711+3 11 | or edx 1
L0: test edx edx | jne R1<

    mov eax ebx | sub edx edx | div ecx | test edx edx | je N0>
    cmp eax ecx | jbe G1> | jmp R1<

N0: add ebx 2 | jnc R0<
B0: mov ebx 0
G1: mov eax ebx
EndP
;

;
proc FindPrevPrimeDword::
 ARGUMENTS @Num32
 LOCAL @mod35711
 USES EBX

    mov ebx D@Num32
    cmp ebx 5 | ja L0> | je L1> | dec ebx | je B0>> | jmp G1>>
L1: mov ebx 3 | jmp G1>>
L0: test ebx 1 | jne N0> | or ebx 1 | jmp N0>

R0:
    mov ecx 1
R1: ; divisor loop
    add ecx 2 | cmp ecx 7 | ja L0>

    mov eax ebx | sub edx edx | div ecx | test edx edx | je N0>
    cmp eax ecx | jbe G1> | jmp R1<
L0:
    mov D@mod35711 070401; 0B050202
    mov ecx 7
;ALIGN 16
R1: ; divisor loop
    add ecx 2 | cmp ecx 0FFF1 | ja G1>

    sub edx edx
    sub B@mod35711 1 | jne L0> | mov B@mod35711 3 | or edx 1
L0: sub B@mod35711+1 1 | jne L0> | mov B@mod35711+1 5 | or edx 1
L0: sub B@mod35711+2 1 | jne L0> | mov B@mod35711+2 7 | or edx 1
;L0: sub B@mod35711+3 1 | jne L0> | mov B@mod35711+3 11 | or edx 1
L0: test edx edx | jne R1<

    mov eax ebx | sub edx edx | div ecx | test edx edx | je N0>
    cmp eax ecx | jbe G1> | jmp R1<

N0: sub ebx 2 | jnc R0<
B0: mov ebx 0
G1: mov eax ebx
EndP
;

;
proc IsQwordPrime::
 ARGUMENTS @NLo @NHi
 LOCAL @mod35711 ;@cnt
 USES EBX EDI
;mov D@cnt 0
;    cld
    mov ebx D@NLo | mov edi D@NHi
    test edi edi | jne L0>
    cmp ebx 4 | ja L0> | je B0>> | cmp ebx 0 | je B0>> | jmp G1>>
L0: test ebx 1 | je B0>>
    mov ecx 1
R1: ; divisor loop
    add ecx 2 | cmp ecx 7 | ja L0>

    cmp edi ecx | jae R2>
    mov eax ebx | mov edx edi | div ecx | test edx edx | je B0>>
    cmp eax ecx | jbe G1>> | jmp R1<
; double division
R2:
    sub edx edx | mov eax edi | div ecx
    mov eax ebx | div ecx | test edx edx | je B0>
    jmp R1<
L0:
;;
    call GetOddNumModPosition 11 0 3
    mov B@mod35711 al
    call GetOddNumModPosition 11 0 5
    mov B@mod35711+1 al
    call GetOddNumModPosition 11 0 7
    mov B@mod35711+2 al
    call GetOddNumModPosition 11 0 11
    mov B@mod35711+3 al
;;
    mov D@mod35711 070401 ;0B050202
    mov ecx 7
ALIGN 16
R1: ; divisor loop
    add ecx 2 | cmp ecx 0FFFFFFFB | ja G1>

    sub edx edx
    sub B@mod35711 1 | jne L0> | mov B@mod35711 3 | or edx 1
L0: sub B@mod35711+1 1 | jne L0> | mov B@mod35711+1 5 | or edx 1
L0: sub B@mod35711+2 1 | jne L0> | mov B@mod35711+2 7 | or edx 1
;L0: sub B@mod35711+3 1 | jne L0> | mov B@mod35711+3 11 | or edx 1
L0: test edx edx | jne R1<
;inc D@cnt
    cmp edi ecx | jae R2>
    mov eax ebx | mov edx edi | div ecx | test edx edx | je B0>
    cmp eax ecx | jbe G1> | jmp R1<
; double division
R2:
    sub edx edx | mov eax edi | div ecx
    mov eax ebx | div ecx | test edx edx | je B0>
    jmp R1<

B0: mov eax 0 | jmp P9>
G1:
    mov eax 1 ;ebx | mov edx edi
EndP
;


;
proc FindNextPrimeQword::
 ARGUMENTS @NLo @NHi
 LOCAL @mod35711
 USES EBX EDI

    mov ebx D@NLo | mov edi D@NHi
    test edi edi | jne L0>
    cmp ebx 3 | jae L0> | inc ebx | jmp G1>>
L0: test ebx 1 | jne N0>> | or ebx 1
R0:
    mov ecx 1
R1: ; divisor loop
    add ecx 2 | cmp ecx 7 | ja L0>

    cmp edi ecx | jae R2>
    mov eax ebx | mov edx edi | div ecx | test edx edx | je N0>>
    cmp eax ecx | jbe G1>> | jmp R1<
; double division
R2:
    sub edx edx | mov eax edi | div ecx
    mov eax ebx | div ecx | test edx edx | je N0>
    jmp R1<
L0:
    mov D@mod35711 070401; 0B050202
    mov ecx 7
ALIGN 16
R1: ; divisor loop
    add ecx 2 | cmp ecx 0FFFFFFFB | ja G1>

    sub edx edx
    sub B@mod35711 1 | jne L0> | mov B@mod35711 3 | or edx 1
L0: sub B@mod35711+1 1 | jne L0> | mov B@mod35711+1 5 | or edx 1
L0: sub B@mod35711+2 1 | jne L0> | mov B@mod35711+2 7 | or edx 1
;L0: sub B@mod35711+3 1 | jne L0> | mov B@mod35711+3 11 | or edx 1
L0: test edx edx | jne R1<

    cmp edi ecx | jae R2>
    mov eax ebx | mov edx edi | div ecx | test edx edx | je N0>
    cmp eax ecx | jbe G1> | jmp R1<
R2: ; double division
    sub edx edx | mov eax edi | div ecx
    mov eax ebx | div ecx | test edx edx | je N0>
    jmp R1<

N0: add ebx 2 | adc edi 0 | jnc R0<<
B0: mov ebx 0, edi 0
G1: mov eax ebx | mov edx edi
EndP
;

;
proc FindPrevPrimeQword::
 ARGUMENTS @NLo @NHi
 LOCAL @mod35711
 USES EBX EDI

    mov ebx D@NLo | mov edi D@NHi
    test edi edi | jne L0>
    cmp ebx 5 | ja L0> | je L1> | dec ebx | je B0>> | jmp G1>>
L1: mov ebx 3 | jmp G1>>
L0: test ebx 1 | jne N0>> | or ebx 1 | jmp N0>>

R0:
    mov ecx 1
R1: ; divisor loop
    add ecx 2 | cmp ecx 7 | ja L0>

    cmp edi ecx | jae R2>
    mov eax ebx | mov edx edi | div ecx | test edx edx | je N0>>
    cmp eax ecx | jbe G1>> | jmp R1<
; double division
R2:
    sub edx edx | mov eax edi | div ecx
    mov eax ebx | div ecx | test edx edx | je N0>
    jmp R1<
L0:
    mov D@mod35711 070401; 0B050202
    mov ecx 7
ALIGN 16
R1: ; divisor loop
    add ecx 2 | cmp ecx 0FFFFFFFB | ja G1>

    sub edx edx
    sub B@mod35711 1 | jne L0> | mov B@mod35711 3 | or edx 1
L0: sub B@mod35711+1 1 | jne L0> | mov B@mod35711+1 5 | or edx 1
L0: sub B@mod35711+2 1 | jne L0> | mov B@mod35711+2 7 | or edx 1
;L0: sub B@mod35711+3 1 | jne L0> | mov B@mod35711+3 11 | or edx 1
L0: test edx edx | jne R1<

    cmp edi ecx | jae R2>
    mov eax ebx | mov edx edi | div ecx | test edx edx | je N0>
    cmp eax ecx | jbe G1> | jmp R1<
R2: ; double division
    sub edx edx | mov eax edi | div ecx
    mov eax ebx | div ecx | test edx edx | je N0>
    jmp R1<

N0: sub ebx 2 | sbb edi 0 | jnc R0<<
B0: mov ebx 0, edi 0
G1: mov eax ebx | mov edx edi
EndP
;
;
;
TITLE SIEVES
;
;
;
Proc ExtractLastPrimeFromDiffArray::
 ARGUMENTS @pArray @count @BaseLo @BaseHi
 USES EBX ESI

    mov eax D@BaseLo | mov edx D@BaseHi | mov esi D@pArray
    mov ecx D@count | cmp ecx 0 | jg L0>
E0: sub eax eax | sub edx edx | jmp P9>

L0: movzx ebx B$esi | inc esi | shl ebx 1 | je L3>
L1: add eax ebx | adc edx 0 | jc E0<
    dec ecx | jne L0<
    jmp P9>
L3: add ebx 01FE | dec ecx | je P9>
    cmp B$esi 0 | jne L3>
    inc esi | jmp L3<
L3: add eax ebx | adc edx 0 | jc E0< | jmp L0<

EndP
;
;
; ret: 0 on Error or on 64bit end; EDX:EAX=Prime64, ECX=NextPrimePosition
Proc FindNearPrime64FromDiffArray::
 ARGUMENTS @pArray @ArrayCount @BaseLo @BaseHi @NumberLo @NumberHi
 USES EBX ESI

    mov eax D@BaseLo | mov edx D@BaseHi | mov esi D@pArray
    mov ecx D@ArrayCount | cmp ecx 0 | jg L0>
E0: sub eax eax | sub edx edx | jmp P9>

L0: movzx ebx B$esi | inc esi | shl ebx 1 | je L3>
L1: add eax ebx | adc edx 0 | jc E0< ; overflow Bit64
    cmp edx D@NumberHi | jne L4> | cmp eax D@NumberLo ; double CMP!
L4: ja L9> ; found
    dec ecx | jne L0<
    jmp E0< ; not found
L3: add ebx 01FE | dec ecx | je E0<
    cmp B$esi 0 | jne L3>
    inc esi | jmp L3<
L3: add eax ebx | adc edx 0 | jc E0< | jmp L0<
L9: mov ecx esi | sub ecx D@pArray
EndP
;
;
; ret: 0 on Error or on 64bit end; EDX:EAX=Prime64, ECX=NextPrimePosition
Proc GetNextPrime64FromDiffArrayPosition::
 ARGUMENTS @pArray @ArrayCount @Position @prevPrimeLo @prevPrimeHi
 USES EBX ESI

    mov eax D@prevPrimeLo | mov edx D@prevPrimeHi
    mov esi D@pArray | mov ecx D@ArrayCount | cmp ecx 0 | jle E0>
    add esi D@Position | sub ecx D@Position | jg L0>
E0: sub eax eax | sub edx edx | jmp P9>

L0: movzx ebx B$esi | inc esi | shl ebx 1 | je L3>
L1: add eax ebx | adc edx 0 | jc E0< ; overflow Bit64
    jmp L9>
L3: add ebx 01FE | dec ecx | je E0< ; end
    cmp B$esi 0 | jne L3>
    inc esi | jmp L3<
L3: add eax ebx | adc edx 0 | jc E0< | jmp L0<
L9: mov ecx esi | sub ecx D@pArray
EndP
;
;
; ret: 0 on Error or on 32bit end;  EAX=Prime32, ECX=NextPrimePosition
; Number can be no-prime
Proc FindNearPrime32FromBit32DiffArray::
 ARGUMENTS @pArray @ArrayCount @Base @Number
 USES EBX ESI

    mov eax D@Base | mov esi D@pArray | mov edx D@Number
    mov ecx D@ArrayCount | cmp ecx 0 | jg L0>
E0: sub eax eax | jmp P9>

L0: movzx ebx B$esi | inc esi | shl ebx 1 | je E0< ; can't be 0
L1: add eax ebx | jc E0< ; overflow Bit32
    cmp eax edx | ja L9> ; found
    dec ecx | jne L0<
    jmp E0< ; not found
L9: mov ecx esi | sub ecx D@pArray
EndP
;
;
; ret: 0 on Error or on 32bit end;  EAX=Prime32, ECX=NextPrimePosition
Proc GetNextPrime32FromDiffArrayPosition::
 ARGUMENTS @pArray @ArrayCount @Position @prevPrime
 USES EBX ESI

    mov eax D@prevPrime | mov esi D@pArray
    mov ecx D@ArrayCount | cmp ecx 0 | jle E0>
    add esi D@Position | sub ecx D@Position | jg L0>
E0: sub eax eax | jmp P9>

L0: movzx ebx B$esi | inc esi | shl ebx 1 | je E0< ; can't be 0
L1: add eax ebx | jc E0< ; overflow Bit32
L9: mov ecx esi | sub ecx D@pArray
EndP

; [directReadNextPrime32FromDiffArrayPosition
; mov eax D@pArray | add eax D@Position | movzx eax B$eax | shl eax 1 | add eax D@prevPrime]

;;
; ret Num
Proc ConvertOldPrimeFromDiffArray:
 ARGUMENTS @pArrayNew @pArrayOld @count
 USES EBX ESI EDI

    CLD | sub eax eax | mov edi D@pArrayNew | mov esi D@pArrayOld
    mov ecx D@count | cmp ecx 0 | jg L0>
    sub eax eax | jmp P9>

L0: lodsb | test eax eax | je L1>
    shr eax 1 | jnc L1>
    or eax 080
L1: stosb | dec ecx | jne L0<
    mov eax edi | sub eax D@pArrayNew
EndP
;;

;;
; returns count
Proc Bit32PrimesSieve64Bit4GbRange::
 ARGUMENTS @mB32Primes @SieveMem @Bit64HighDword
 Local  @divisorbound
 USES EBX ESI EDI
;DBGBP
    mov eax D@Bit64HighDword | test eax eax | je P9>>

    push D@Bit64HighDword | push 0-1 | BT D$esp+4 31 | setc cl | jnc L0>
    shr D$esp+4 2
L0: FINIT | FILD Q$esp | FSQRT | FWAIT | FISTP Q$ESP
    pop eax | pop edx | shl eax cl | jne L0>
    mov eax 0-5
L0: mov D@divisorbound eax

    mov esi D@SieveMem | mov edi D@mB32Primes
    sub ecx ecx | mov ebx 1
L0:
    movzx eax B$edi+ecx | shl eax 1 | add eax EBX | jc L9>
    mov ebx eax | inc ecx | cmp ebx D@divisorbound | ja L9>
; B64 MOD B32
    sub edx edx | mov eax D@Bit64HighDword | div ebx | mov eax 0 | div ebx
    mov eax 0 | test edx edx | jne L2> | mov edx ebx
L2: sub eax edx | add eax ebx | jmp L3>
L1:
    add eax ebx | jb L0<
L3: test eax 1 | je L1<
    ;dec eax |
    mov edx eax | shr edx 1
    BTS D$esi edx
    jmp L1<
L9:
    sub eax eax | sub ecx ecx
L0: BT D$esi ecx | jc L1> | inc eax
L1: inc ecx | cmp ecx 080000000 | jb L0< ; jno..
EndP
;;

[P3571113id 09B4B34FE | P3571113cnt 15015 ]
; returns count
Proc Bit32PrimesSieve64Bit4GbRange::
 ARGUMENTS @mB32Primes @SieveMem @Bit64HighDword
 Local  @divisorbound
 USES EBX ESI EDI
;DBGBP
    mov eax D@Bit64HighDword | test eax eax | je P9>>

    push D@Bit64HighDword | push 0-1 | BT D$esp+4 31 | setc cl | jnc L0>
    shr D$esp+4 2
L0: FINIT | FILD Q$esp | FSQRT | FWAIT | FISTP Q$ESP
    pop eax | pop edx | shl eax cl | jne L0>
    mov eax 0-5
L0: mov D@divisorbound eax

    CLD

    mov esi D@SieveMem | mov edi D@mB32Primes
    sub ecx ecx | mov ebx 1
L0: cmp ecx 5 | je L4>
    movzx eax B$edi+ecx | shl eax 1 | add eax EBX; | jc L9>
    mov ebx eax | inc ecx; | cmp ebx D@divisorbound | ja L9>
; B64 MOD B32
    sub edx edx | mov eax D@Bit64HighDword | div ebx | mov eax 0 | div ebx
    mov eax 0 | test edx edx | jne L2> | mov edx ebx
L2: sub eax edx | add eax ebx | jmp L3>
L1:
    add eax ebx | cmp eax (P3571113cnt*32) | ja L0<
L3: test eax 1 | je L1<
    mov edx eax | shr edx 1
    BTS D$esi edx
    jmp L1<

L4:
    mov edi D@SieveMem | mov eax P3571113id | mov ecx (P3571113cnt*2)
L0: REPNE SCASB | jne E0>> | cmp D$edi-1 eax | jne L0<
    dec edi
    mov ebx edi
    add edi P3571113cnt

    mov edx 010000000 | add edx D@SieveMem | sub edx edi
L0:
    mov esi ebx, ecx P3571113cnt | REP MOVSB
    sub edx P3571113cnt | cmp edx P3571113cnt | jae L0<
    mov esi ebx, ecx edx | REP MOVSB
;DBGBP
    mov esi D@SieveMem | mov edi D@mB32Primes

;    sub ecx ecx | mov ebx 1
;    mov edx 5 |
;L0: movzx eax B$edi+ecx | shl eax 1 | add eax EBX | mov ebx eax | inc ecx | dec edx | jne L0<
    mov ecx 5 | mov ebx 13

L0:
    movzx eax B$edi+ecx | shl eax 1 | add eax EBX | jc L9>
    mov ebx eax | inc ecx | cmp ebx D@divisorbound | ja L9>
; B64 MOD B32
    sub edx edx | mov eax D@Bit64HighDword | div ebx | mov eax 0 | div ebx
    mov eax 0 | test edx edx | jne L2> | mov edx ebx
L2: sub eax edx | add eax ebx | jmp L3>
L1:
    add eax ebx | jb L0<
L3: test eax 1 | je L1<
    ;dec eax |
    mov edx eax | shr edx 1
    BTS D$esi edx
    jmp L1<
E0: sub eax eax | jmp P9>
; count
L9:
    sub eax eax | sub ecx ecx
L0: BT D$esi ecx | jc L1> | inc eax
L1: inc ecx | cmp ecx 080000000 | jb L0< ; jno..

EndP


; returns count
Proc Bit16PrimesSieve32BitRange::
 ARGUMENTS @SieveMem ; @mBit16Primes
 USES EBX ESI EDI

    mov esi D@SieveMem | mov edi Bit16Primes; D@mBit16Primes
    sub ecx ecx | mov ebx 1
L0:
    movzx eax B$edi+ecx | shl eax 1 | add eax EBX | cmp eax 0FFF1 | ja L9>
    mov ebx eax | inc ecx
    sub eax eax
    add eax ebx ; first is self
L1:
    add eax ebx | jb L0<
    test eax 1 | je L1<
    ;dec eax |
    mov edx eax | shr edx 1
    BTS D$esi edx
    jmp L1<
L9:
    sub eax eax | sub ecx ecx
L0: BT D$esi ecx | jc L1> | inc eax
L1: inc ecx | cmp ecx 080000000 | jb L0< ; jno..
EndP

; returns count
Proc Bit32PrimesSieveAny4GbRange::
 ARGUMENTS @mB32Primes @SieveMem @inMem @inMemSz
 Local  @upBorder
 USES EBX ESI EDI
;DBGBP
    or eax 0-1
    mov edx D@inMemSz
    test edx 00_11111 | jne P9> | shr edx 3 | je P9>
    add edx D@inMem | mov D@upBorder edx
    mov esi D@SieveMem | mov edi D@mB32Primes
    sub ecx ecx | mov ebx 1
L0:
    movzx eax B$edi+ecx | shl eax 1 | add eax EBX | jc L9>
    mov ebx eax | inc ecx
    push ecx
    call AnyBitsMod32Bit D@inMem D@inMemSz ebx
    pop ecx | test eax eax | je P9>
    mov eax 0 | test edx edx | jne L2> | mov edx ebx
L2: sub eax edx | add eax ebx | jmp L3>
L1:
    add eax ebx | jb L0<
L3: test eax 1 | je L1<
    ;dec eax |
    mov edx eax | shr edx 1
    BTS D$esi edx
    jmp L1<
L9:
    sub eax eax | sub ecx ecx
L0: BT D$esi ecx | jc L1> | inc eax
L1: inc ecx | cmp ecx 080000000 | jb L0< ; jno..
EndP

;from AnyBits
Proc AnyBitsMod32Bit:
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


Proc ConvertSieveToDiffBytes::
 ARGUMENTS @pDiffBytes @SieveMem @SieveBitSz @SieveBaseHigh64Addr @BasePrevPrimeLowDword
 USES EBX ESI EDI

    CLD
    sub eax eax
    mov edi D@pDiffBytes, esi D@SieveMem
    test D@SieveBitSz 01F | jne E0>

    sub edx edx
    mov ebx D@BasePrevPrimeLowDword | test ebx ebx | jne L3>
    cmp D@SieveBaseHigh64Addr 0 | je L0>
    mov ebx 0-1 | jmp L3>; without known prev prime, use prev odd
L0:
    cmp D$esi 09B4B3490 | jne E0> ; 0 base, unknown bits??
    mov ebx 1 | mov edx 1 ; 0 base, start from 1

L3: BT D$esi EDX | jc L2>
    lea ecx D$edx*2+1 | mov eax ecx | sub eax ebx
L1: cmp eax 01FE | jbe L1>
    mov B$edi 0 | sub eax 01FE | inc edi | jmp L1<
L1: shr eax 1 | STOSB | mov ebx ecx
L2: inc edx | cmp edx D@SieveBitSz | jb L3<

    mov eax edi | sub eax D@pDiffBytes | jmp P9>
E0:
    sub eax eax ;| jmp P9>

EndP

;returns True/false
Proc IsNumberPrimeInSieve::
 ARGUMENTS @pSieve @NumberLo

    mov eax D@pSieve | mov edx D@NumberLo | shr edx 1
    BT D$eax edx | mov eax 0 | sbb eax eax | add eax 1

EndP

;returns NumberLo, 0 on error
Proc GetNextPrimeFromSieve::
 ARGUMENTS @pSieve @NumberLo

    mov eax D@NumberLo | mov edx D@pSieve | shr eax 1
L0: add eax 1 | cmp eax 080000000 | jae E0>
    BT D$edx eax | jc L0<
    shl eax 1 | or eax 1 | jmp P9>
E0: sub eax eax
EndP

;returns NumberLo, 0 on error
Proc GetFirstPrimeFromSieve::
 ARGUMENTS @pSieve

    mov eax 0-1 | mov edx D@pSieve
L0: add eax 1 | cmp eax 080000000 | jae E0>
    BT D$edx eax | jc L0<
    shl eax 1 | or eax 1 | jmp P9>
E0: sub eax eax
EndP










TITLE MAIN
___________________________________________________________________________________________

Main:
;   cmp D$Bit16Primes 0 | jne L0>
;    sub eax eax | RDTSC | push edx, eax
;   call Numeriko16 Bit16PrimesA
;   mov esi Bit16Primes, edi Bit16PrimesA, ecx 01990 | REPE CMPSB
;    sub eax eax | RDTSC | pop ecx | sub eax ecx | pop ecx | sbb edx ecx
;    INT 3
L0: mov eax 1 | ret 0C

ALIGN 0100
Bit16Primes:
DB 1 1 1 2 1 2 1 2 3 1 3 2 1 2 3 3 1 3 2 1 3 2 3 4 2 1 2 1 2 7 2 3 1 5 1 3 3 2 3 3 1 5 1 2 1 6 6 2 1 2 3 1 5 3 3 3 1 3 2 1 5 7 2 1 2 7 3 5 1 2 3 4 3 3 2 3 4 2 4 5 1 5 1 3 2 3 4 2 1 2 6 4 2 4 2 3 6 1 9 3 5 3 3 1 3 5 3 3 1 3 3 2 1 6 5 1 2 3 3 1 6 2 3 4 5 4 5 4 3 3 2 4 3 2 4 2 7 5 6 1 5 1 2 1 5 7 2 1 2 7 2 1 2 10 2 4 5 4 2 3 3 7 2 3 3 4 3 6 2 3 1 5 1 3 5 1 5 1 3 9 2 1 2 3 3 4 3 3 11 1 5 4 5 3 3 4 6 2 3 3 1 3 6 5 9 1 2 3 1 3 2 1 2 6 1 3 17 3 3 4 9 5 7 2 1 2 3 4 2 1 3 6 5 1 2 1 2 3 6 6 4 6 3 2 3 4 2 4 2 7 2 3 1 2 3 1 3 5 10 3 2 1 12 2 1 5 6 1 5 4 3 3 3 9 3 2 1 6 5 6 4 8 7 3 2 1 2 1 5 6 3 3 9 1 8 1 11 3 4 3 2 1 2 4 3 5 1 5 7 5 3 6 1 2 1 5 6 1 8 1 3 2 1 5 4 9 12 2 3 4 8 1 2 4 8 1 2 4 3 3 2 6 1 11 3 1 3 2 3 7 3 2 1 3 2 3 6 3 3 7 2 3 6 4 3 2 13 9 5 4 2 3 1 3 11 6 1 8 4 2 6 7 5 1 2 4 3 3 2 1 2 3 4 2 1 3 5 1 5 4 2 7 5 6 1 3 2 1 8 7 2 3 4 3 2 9 4 5 3 3 4 5 6 7 2 3 3 1 14 1 5 4 2 7 2 4 6 3 6 2 3 10 5 1 8 13 2 1 6 3 2 6 3 4 2 4 11 1 2 1 6 14 1 3 3 3 2 3 1 6 2 6 1 5 1 8 1 8 3 10 8 4 2 1 2 1 11 4 6 3 5 1 2 3 1 3 5 1 6 5 1 5 7 3 2 3 4 3 3 8 6 1 2 7 3 2 4 5 4 3 3 11 3 1 5 7 2 3 9 1 5 7 2 1 5 7 2 4 9 2 3 1 2 3 1 6 2 10 11 6 1 2 3 3 1 3 11 1 3 8 3 6 1 3 6 8 1 2 3 7 2 1 9 12 5 3 1 5 1 5 1 5 3 1 5 1 5 3 4 15 5 1 5 4 3 5 9 3 6 6 1 9 3 2 3 3 9 1 5 7 3 2 1 2 12 1 6 3 8 4 3 3 9 8 1 2 3 1 3 3 5 3 6 6 9 1 3 2 9 4 12 2 1 2 3 1 6 2 7 15 5 3 6 7 3 5 6 1 2 3 4 3 5 1 2 7 3 3 2 3 1 5 1 8 6 4 9 2 3 6 1 3 3 3 14 3 7 2 4 5 4 6 9 2 1 2 12 6 3 1 8 3 3 7 5 7 2 15 3 3 3 4 3 2 1 6 3 2 1 3 11 3 1 2 9 1 2 6 1 3 2 13 3 3 2 4 5 16 8 1 3 2 1 2 1 5 7 3 2 4 5 3 10 2 1 3 15 2 4 5 3 3 4 3 6 2 3 1 3 2 3 1 5 1 8 3 10 2 6 7 14 3 10 2 9 4 3 2 3 7 3 3 5 1 5 6 4 5 1 5 4 6 5 12 1 2 4 3 2 4 9 5 3 3 1 3 5 6 1 5 3 3 3 4 3 5 3 1 3 3 3 5 4 12 3 11 1 9 2 4 5 15 4 9 2 1 5 3 1 3 2 9 4 6 9 8 3 1 6 3 5 1 5 1 3 5 7 2 12 1 8 1 5 1 5 10 2 1 2 4 8 3 3 1 6 8 4 2 3 15 1 5 1 3 2 3 3 4 3 2 6 3 4 6 2 7 6 5 12 3 6 3 1 11 4 9 5 3 7 2 1 3 5 4 3 2 3 15 7 5 1 6 5 1 8 1 9 12 9 3 8 9 3 1 9 2 3 1 5 4 5 3 3 4 2 3 1 5 1 6 2 3 3 1 6 2 7 9 2 3 10 2 4 3 2 4 2 7 3 2 7 6 2 1 15 2 12 3 3 6 6 7 3 2 1 2 9 3 6 4 3 2 6 1 6 15 8 1 3 11 7 3 5 6 3 1 2 4 5 3 3 12 7 3 2 4 6 9 5 1 5 1 2 3 10 3 2 7 2 1 2 7 3 6 12 5 3 4 5 1 15 2 3 1 6 2 7 3 17 6 4 3 5 1 2 10 5 4 8 1 5 7 2 1 6 3 8 3 4 2 4 2 3 4 3 3 6 3 2 3 3 4 9 2 10 2 6 1 5 3 1 5 6 1 2 10 3 15 3 2 4 5 6 3 1 14 1 3 2 1 8 6 1 3 5 4 12 6 3 9 3 2 7 3 2 6 4 3 6 2 3 6 3 6 1 8 10 2 1 5 9 4 2 7 2 1 3 11 3 7 3 3 5 3 1 5 1 2 1 11 1 2 3 3 6 3 7 5 6 3 4 2 18 7 6 3 2 3 1 6 3 6 8 1 5 4 11 1 6 3 2 3 9 1 6 3 2 6 4 3 6 2 3 6 3 1 6 6 2 7 3 8 3 1 5 4 9 3 17 1 14 1 11 3 1 5 6 1 3 2 4 11 3 1 5 4 2 3 4 2 6 9 6 10 2 3 3 4 2 1 8 6 1 5 4 5 1 2 3 7 6 11 4 14 1 2 10 2 1 2 7 5 6 1 6 8 1 14 4 11 4 2 3 3 7 2 4 6 3 3 2 10 2 9 1 6 3 2 3 7 9 5 4 5 16 3 5 3 3 1 3 8 3 1 6 3 14 1 5 4 8 3 4 3 5 12 10 5 1 5 1 6 2 3 10 2 1 6 9 5 1 5 1 2 10 8 13 2 4 3 2 6 3 4 6 6 3 2 4 11 1 8 7 5 3 6 6 7 3 2 10 2 6 3 1 3 3 8 4 11 1 14 4 3 2 10 2 6 12 10 2 4 5 1 8 1 6 6 17 1 2 3 6 3 3 4 3 2 1 3 12 2 10 5 3 3 7 2 3 3 1 6 3 5 1 5 3 10 2 13 2 1 3 11 1 12 2 3 1 2 3 12 3 4 2 1 17 3 4 8 6 1 5 1 5 3 4 2 4 6 11 3 7 2 13 2 1 6 5 4 2 4 6 2 7 3 8 3 4 2 3 3 4 3 5 6 1 3 3 8 4 3 3 6 5 1 3 9 2 3 3 3 6 9 4 3 5 4 9 2 7 3 9 5 4 5 6 1 3 6 6 18 2 3 4 2 3 1 2 9 6 3 4 3 3 2 9 1 2 1 12 2 3 3 7 15 3 2 3 6 3 10 2 4 2 4 3 3 2 15 1 5 6 4 5 4 12 3 6 2 7 2 3 1 14 7 8 1 6 3 2 10 5 3 3 3 4 5 6 7 5 7 8 7 5 7 3 8 3 4 3 8 10 5 1 3 2 1 2 6 1 5 1 3 11 3 1 2 9 4 5 4 11 1 5 9 7 2 1 2 9 1 2 3 4 5 1 15 2 15 1 5 1 9 2 9 3 7 5 1 2 10 18 3 2 3 7 2 10 5 7 11 3 1 15 6 5 9 1 2 7 3 11 9 1 6 3 2 4 2 4 3 5 1 6 9 5 7 8 7 2 3 3 1 3 2 1 14 1 14 3 1 2 3 7 2 6 7 8 7 2 3 4 3 2 3 3 3 4 2 4 2 7 8 4 3 2 6 4 8 1 5 4 2 3 13 3 5 4 2 3 6 7 15 2 7 11 4 6 2 3 4 5 3 7 5 3 1 5 6 6 7 3 3 9 5 3 4 9 2 3 1 3 5 1 5 4 3 3 5 1 9 5 1 6 2 3 4 5 6 7 6 2 4 5 3 3 10 2 7 8 7 5 4 5 6 1 9 3 6 5 6 1 2 1 6 3 2 4 2 22 2 1 2 1 5 6 3 3 7 2 3 3 3 4 3 18 9 2 3 1 6 3 3 3 2 7 11 6 1 9 5 3 13 12 2 1 2 1 2 7 2 3 3 4 8 6 1 21 2 1 2 12 3 3 1 9 2 7 3 14 9 7 3 5 6 1 3 6 15 3 2 3 3 7 2 1 12 2 3 3 13 5 9 3 4 3 3 15 2 6 6 1 8 1 3 2 6 9 1 3 2 13 6 3 6 2 12 12 6 3 1 6 14 4 2 3 6 1 9 3 2 3 3 10 8 1 3 3 9 5 3 1 2 4 3 3 12 8 3 4 5 3 7 11 4 8 3 1 6 2 1 11 4 9 17 1 3 9 2 3 3 4 5 4 9 3 2 1 2 4 8 1 6 6 3 9 2 3 3 3 1 3 6 5 10 6 9 2 3 1 8 1 5 7 2 15 1 5 6 1 12 3 8 4 5 1 6 11 3 1 8 10 5 1 6 6 9 5 6 3 1 5 1 3 5 9 1 6 3 2 3 1 12 14 1 2 1 5 1 8 6 4 11 1 3 2 1 5 3 10 6 5 4 6 3 3 3 2 9 1 2 6 9 1 6 3 2 1 8 6 6 7 2 4 9 2 6 7 3 3 2 4 3 2 10 6 5 7 2 1 8 1 6 15 2 3 12 10 12 5 4 6 5 6 3 6 6 3 4 8 7 3 2 3 18 10 5 15 6 1 2 1 14 6 7 3 11 4 2 9 3 7 9 2 3 1 3 17 9 1 8 3 9 1 12 2 1 3 6 3 6 5 4 3 8 6 4 5 7 20 3 1 3 2 6 7 2 1 2 1 2 4 3 5 3 3 1 3 3 3 6 3 12 5 1 5 3 6 3 3 7 3 3 26 10 3 5 1 5 4 5 6 6 1 3 2 7 8 4 6 3 11 1 5 4 3 11 1 11 3 4 5 6 6 1 5 3 6 1 2 7 5 1 3 9 2 6 4 9 6 3 3 2 3 3 7 2 1 6 6 2 3 9 9 6 1 8 6 4 9 5 13 2 3 4 3 3 2 1 5 10 2 3 4 2 10 5 1 17 1 2 12 1 6 6 5 3 1 6 15 3 6 8 6 1 11 9 6 7 5 1 6 6 2 1 2 3 6 1 8 9 1 20 4 8 3 4 5 1 2 9 4 5 4 6 2 9 1 9 5 1 2 1 2 4 14 1 3 11 6 3 7 9 2 3 4 3 3 5 4 2 1 9 5 3 10 11 4 3 15 2 1 2 9 3 15 1 2 4 3 2 3 6 7 17 7 3 2 1 3 2 7 2 1 3 14 1 2 3 4 5 1 5 1 5 1 2 15 1 6 6 5 9 6 7 5 1 6 3 5 3 7 6 2 7 2 9 1 5 4 2 4 5 6 9 9 4 3 9 8 7 3 3 5 7 2 3 1 6 6 2 3 3 6 1 8 1 6 3 2 7 3 2 1 6 9 2 18 9 6 6 1 2 1 2 4 6 2 18 3 9 1 6 5 3 6 12 4 3 3 8 6 1 9 5 10 5 1 3 9 2 1 20 3 1 8 1 2 4 9 5 6 3 1 5 4 2 3 6 1 5 9 4 3 2 10 2 3 18 3 1 5 3 12 3 7 8 3 9 1 5 10 5 4 3 2 3 1 5 1 6 2 1 2 4 5 3 6 9 7 6 8 4 3 8 4 2 1 3 9 12 9 5 6 1 2 7 5 3 3 3 9 6 1 14 9 7 8 6 7 12 6 11 3 1 5 4 2 1 2 7 6 3 2 3 7 2 1 2 15 3 1 3 5 1 15 11 1 2 3 4 3 3 8 6 6 3 4 2 1 12 6 2 3 4 3 3 5 1 3 6 14 7 3 2 6 4 3 6 2 3 7 3 6 5 3 3 4 3 3 2 1 2 4 6 2 7 9 5 1 8 3 10 3 5 4 2 15 18 6 4 11 6 1 3 6 8 3 3 1 9 2 13 2 4 9 5 4 5 3 7 2 10 11 9 6 4 14 6 3 3 4 3 6 12 8 7 2 7 6 3 5 6 10 3 2 4 9 6 9 5 1 2 10 5 7 2 3 1 5 12 9 1 2 10 8 7 5 7 3 2 3 10 3 5 3 1 6 3 15 5 4 3 2 3 4 20 1 2 1 6 9 2 3 4 5 3 9 9 1 6 8 4 3 2 3 3 1 26 7 2 10 8 1 2 3 6 1 3 6 6 3 2 7 5 3 3 7 5 7 8 4 3 6 2 4 11 3 1 9 11 3 1 9 3 8 7 5 3 6 1 3 2 4 9 6 8 1 2 7 2 4 6 6 15 8 4 2 1 3 11 6 4 5 3 3 3 7 3 9 5 6 1 5 1 2 13 2 6 4 2 9 4 5 7 8 3 3 4 5 3 4 3 6 5 10 5 4 2 6 13 9 2 6 9 3 15 3 4 3 11 6 1 2 3 3 1 5 1 2 3 3 1 3 11 9 3 9 6 4 6 3 5 6 1 8 1 5 1 5 9 3 10 2 1 3 11 3 3 9 3 7 6 8 1 3 3 2 7 6 2 1 9 8 18 6 3 7 14 1 6 3 6 3 2 1 8 15 4 12 3 15 5 1 9 2 3 6 4 11 1 3 11 9 1 5 1 5 15 1 14 3 7 8 3 10 8 1 3 2 16 2 1 2 3 1 6 2 3 3 6 1 3 2 3 4 3 2 10 2 16 5 4 8 1 11 1 2 3 4 3 8 7 2 9 4 2 10 3 6 6 3 5 1 5 1 6 14 6 9 1 9 5 4 5 24 1 2 3 4 5 1 5 15 1 18 3 5 3 1 9 2 3 4 8 7 8 3 7 2 10 2 3 1 5 6 1 3 6 3 3 2 6 1 3 2 6 3 4 2 1 3 9 5 3 4 6 3 11 1 3 6 9 2 7 3 2 10 3 8 4 2 4 11 4 6 3 3 8 6 9 15 4 2 1 2 3 13 2 7 12 11 3 1 3 5 3 7 3 3 6 5 3 1 6 5 6 4 9 9 5 3 4 8 3 3 4 8 10 2 1 5 1 5 6 3 4 3 5 10 5 9 13 2 3 15 1 2 4 3 6 6 9 2 4 11 3 1 6 17 3 9 6 3 1 14 7 8 7 2 7 6 2 3 3 1 18 2 3 10 6 12 3 11 1 8 9 6 6 9 1 3 3 3 2 3 7 2 1 11 4 6 3 5 3 4 6 9 6 3 5 1 11 7 3 3 2 9 3 10 11 1 6 12 2 9 9 1 11 1 2 6 4 6 5 7 2 1 9 8 19 3 3 3 6 5 3 6 4 3 2 3 7 15 3 5 4 11 3 4 6 5 1 5 1 3 5 1 5 6 9 10 3 2 4 11 3 3 15 3 7 3 6 6 3 5 1 5 15 1 8 4 2 1 3 9 2 1 3 2 13 2 4 3 5 1 2 3 4 2 3 15 6 1 3 3 2 10 11 4 2 1 2 36 4 2 4 11 1 2 7 5 1 2 10 3 5 9 3 10 8 3 4 3 2 10 6 11 1 2 1 6 5 9 1 11 3 9 15 1 5 7 5 4 8 25 3 5 4 5 6 3 9 1 11 3 1 2 3 4 3 3 5 9 1 11 1 8 7 5 3 1 6 5 10 2 7 3 2 18 1 2 3 6 1 2 7 6 3 2 3 1 3 2 10 5 1 5 3 6 1 12 6 6 3 3 2 12 1 2 12 1 3 2 3 4 8 3 1 5 6 7 3 17 3 7 3 2 1 15 11 4 2 3 4 2 1 14 1 3 2 13 9 11 1 3 8 3 1 8 6 1 6 2 3 3 7 5 3 4 6 2 9 1 5 4 8 3 3 15 1 5 9 1 5 4 2 4 6 12 20 1 6 5 3 6 1 6 2 1 2 3 9 7 6 3 2 7 15 2 4 5 4 3 5 9 4 2 7 8 3 4 2 3 1 5 1 6 2 1 2 3 4 2 3 16 12 5 4 9 5 1 3 5 1 2 9 3 6 1 8 1 11 3 3 4 9 2 9 6 4 3 2 10 3 15 11 6 1 3 9 2 31 2 1 6 3 5 1 6 6 14 1 2 7 11 3 1 3 3 5 7 2 1 5 3 4 5 7 5 3 1 6 11 9 4 5 9 6 1 6 2 6 1 5 1 3 9 3 3 17 3 1 6 2 3 9 9 1 8 3 3 4 3 5 9 4 5 4 5 1 2 9 13 6 11 1 2 1 11 3 3 7 8 3 10 5 6 1 9 21 2 12 1 3 5 6 1 3 5 4 2 3 6 6 4 2 3 6 15 10 3 12 3 5 6 1 5 10 3 3 2 6 7 5 9 6 4 3 6 2 7 5 1 6 15 8 1 6 3 2 1 2 3 13 2 9 1 2 3 7 27 3 26 1 8 3 3 6 13 2 1 3 11 3 1 6 6 3 5 9 1 6 6 5 9 6 3 4 3 5 3 4 2 1 2 10 12 3 3 5 7 5 1 11 3 7 5 13 2 9 4 6 6 5 6 3 4 8 3 4 3 3 11 1 5 10 5 3 22 9 3 5 1 2 3 7 2 13 2 1 6 5 4 2 4 6 2 6 4 11 4 3 5 9 3 3 4 3 6 2 4 9 5 6 3 6 1 3 2 1 8 6 6 7 5 7 3 5 6 1 6 3 2 3 1 6 2 13 3 9 3 5 3 1 9 5 4 2 13 5 10 3 8 10 6 5 4 5 1 8 3 10 5 10 2 15 1 2 4 8 1 9 2 1 3 5 9 6 7 9 3 8 10 3 2 4 3 2 3 6 4 5 1 6 3 2 1 3 5 1 8 6 7 5 3 4 3 14 1 3 9 15 17 1 8 6 1 9 8 3 4 5 4 5 4 5 22 3 3 2 10 2 1 2 7 14 4 3 8 7 15 3 15 2 7 5 3 3 4 2 9 6 3 1 11 6 4 3 6 2 7 2 3 1 2 9 10 3 8 19 8 1 2 3 1 20 21 7 2 3 1 12 5 3 1 9 5 6 1 8 1 3 8 3 4 2 1 5 3 4 5 1 9 8 4 6 9 6 3 6 5 3 3 9 6 7 2 1 5 10 3 6 3 8 13 2 9 1 2 16 5 4 3 2 3 3 7 3 9 2 1 9 5 4 5 4 5 1 2 3 1 5 21 4 6 2 3 9 1 8 4 2 1 5 7 6 5 10 2 4 5 19 2 3 1 5 10 5 6 3 6 13 6 2 4 14 4 2 4 12 3 5 4 3 8 6 4 5 6 4 11 3 1 5 1 3 5 3 3 4 3 2 7 14 4 8 9 4 2 3 10 2 9 3 1 12 12 3 3 6 6 2 1 11 1 5 3 4 6 2 10 9 3 2 6 12 3 3 27 4 3 2 13 18 2 1 2 13 6 6 2 3 3 4 6 5 1 6 8 9 3 4 3 6 9 5 1 27 2 1 5 15 6 4 2 4 8 7 6 3 2 3 6 3 1 2 7 6 2 7 3 12 3 3 5 6 6 10 9 3 3 8 4 2 3 10 2 16 2 7 5 1 3 6 8 1 2 3 6 1 5 4 3 2 1 5 7 3 3 6 9 17 4 5 3 12 3 1 5 6 1 15 5 7 6 6 8 3 3 1 9 2 3 15 7 2 3 3 1 3 2 3 7 3 2 4 5 6 3 16 5 4 11 1 5 3 12 4 2 15 3 1 6 8 4 3 2 3 4 8 7 3 3 2 1 5 6 1 8 7 2 1 2 10 9 5 1 5 3 6 15 4 9 6 5 1 3 3 2 6 6 1 2 6 9 12 1 5 3 4 8 4 3 6 5 7 3 6 3 3 2 1 12 2 3 4 3 2 1 2 3 7 2 4 5 12 12 6 1 3 6 11 15 1 3 9 5 3 3 4 2 1 3 5 4 5 3 4 8 3 7 3 2 12 4 5 1 6 3 2 18 1 11 3 4 3 5 4 3 6 5 7 5 3 9 6 1 6 2 13 5 7 8 9 4 9 6 6 3 8 7 12 5 6 4 11 3 1 5 30 3 1 2 4 8 7 5 3 12 3 6 9 12 1 15 2 1 6 3 5 1 2 7 3 8 1 5 4 11 10 3 2 16 3 9 2 1 2 1 2 4 26 7 11 1 11 10 5 4 5 1 3 2 7 2 3 10 2 3 1 6 6 3 6 8 1 6 5 4 2 3 1 14 6 4 5 6 1 2 7 14 4 3 2 1 2 3 1 6 29 3 7 5 1 3 14 16 2 15 4 3 2 3 6 6 1 2 3 3 7 8 4 15 2 1 5 4 3 2 3 13 2 6 1 5 9 6 6 9 1 2 6 4 6 5 10 2 4 8 6 4 3 8 4 5 6 7 3 2 4 6 2 10 3 20 4 8 3 18 1 3 2 3 1 11 9 1 5 3 18 7 6 2 9 4 2 7 5 1 5 4 2 1 9 8 6 7 5 7 3 3 21 5 3 3 10 5 4 6 2 6 9 1 5 7 9 5 9 4 3 2 7 3 5 15 7 3 3 2 6 19 2 1 2 3 4 6 5 3 9 3 25 3 2 3 6 4 5 16 3 11 1 5 6 9 1 3 2 15 4 3 3 9 5 1 2 6 10 5 4 12 5 1 3 11 3 1 9 5 6 1 15 9 6 14 1 3 2 3 7 3 6 5 4 2 6 13 5 4 3 8 1 5 9 7 3 2 3 7 8 1 3 2 6 10 2 10 2 3 6 1 18 2 3 1 5 1 11 4 3 5 6 6 9 7 12 18 2 10 12 5 3 1 14 3 9 4 2 3 4 3 2 1 6 14 9 7 8 7 9 5 4 3 2 3 3 4 11 6 1 5 9 3 1 9 5 1 6 5 9 16 3 2 3 3 4 3 3 5 10 3 6 5 4 5 7 3 5 7 2 1 11 9 1 5 1 2 10 2 1 17 1 6 3 5 1 5 9 3 7 6 6 11 4 3 8 3 4 2 6 3 4 2 18 3 3 10 12 3 6 9 5 1 5 13 3 8 4 3 2 12 9 4 6 6 5 9 6 1 12 2 6 9 6 7 5 1 2 12 6 7 5 3 1 3 2 3 13 2 3 3 1 11 4 9 2 9 4 2 12 1 6 6 2 1 26 1 9 3 2 3 6 1 3 6 5 4 2 1 12 5 1 5 1 6 3 9 20 3 10 8 1 6 3 5 6 1 2 3 7 6 6 11 3 4 2 1 8 9 6 1 3 8 3 1 3 2 6 15 4 8 1 9 5 12 1 3 12 2 1 11 1 8 1 3 6 2 9 4 2 7 2 9 12 3 1 3 5 1 5 19 3 5 7 3 3 12 2 1 6 8 7 8 6 1 3 5 13 2 1 6 3 2 6 4 6 5 9 3 7 14 1 3 5 1 2 7 17 1 3 11 1 5 7 2 1 8 4 5 3 4 5 4 2 3 1 8 3 3 9 15 7 3 2 15 1 5 7 2 10 5 4 2 4 9 2 7 3 2 12 3 3 9 9 1 18 3 5 7 6 2 3 1 15 3 2 1 3 14 10 2 10 6 12 8 9 6 7 3 2 6 16 6 3 5 4 5 3 9 1 8 7 3 11 3 6 1 9 2 4 15 6 2 6 1 5 19 11 1 2 7 3 6 12 2 1 2 7 6 5 1 8 3 10 2 10 11 6 1 2 1 6 11 12 3 3 1 3 2 3 1 5 6 6 3 1 3 8 4 3 2 9 6 6 7 2 6 3 4 3 9 3 5 6 7 3 2 4 11 3 1 14 9 1 9 5 3 7 5 1 5 7 3 5 1 11 3 4 3 8 6 4 11 1 2 7 9 6 3 12 3 5 1 6 11 9 3 10 3 5 7 2 1 3 6 11 7 6 2 3 4 11 1 5 6 4 20 1 3 5 4 2 21 10 2 16 6 5 3 6 6 1 5 4 3 2 4 2 13 9 2 4 14 3 9 3 6 1 5 3 3 7 5 6 7 12 3 2 10 11 1 9 2 3 6 1 8 9 7 3 3 2 3 4 9 2 7 15 2 9 4 5 1 2 4 6 2 6 9 1 6 5 1 8 4 2 15 1 3 14 1 5 1 9 5 7 2 13 3 9 2 10 3 2 4 9 2 6 13 12 2 10 11 1 9 11 1 2 6 1 3 3 3 2 3 7 2 12 6 3 9 1 6 14 7 2 3 4 11 3 6 9 4 2 10 3 2 3 1 9 3 2 6 6 4 14 3 4 5 1 12 6 5 12 4 5 10 6 3 6 6 2 7 6 12 17 9 4 5 3 9 4 2 4 8 7 3 2 3 12 1 3 2 3 1 8 3 3 10 12 2 1 2 7 2 9 1 3 6 2 7 2 1 9 8 3 3 1 8 10 3 3 15 2 4 3 12 8 3 3 4 6 15 2 9 9 4 2 13 5 1 11 4 5 7 3 2 9 4 6 14 1 3 2 6 3 12 3 4 5 10 8 4 15 3 3 2 1 5 7 3 5 16 11 9 1 2 1 2 4 11 4 9 6 14 1 8 6 9 7 5 9 6 3 16 5 7 3 5 1 5 1 3 11 1 2 3 4 5 3 7 3 2 6 15 12 3 3 4 3 2 1 2 3 4 3 3 11 9 4 2 1 9 3 2 1 8 9 10 5 3 3 15 1 6 14 3 3 3 1 6 5 4 9 9 2 4 9 5 1 14 1 5 7 2 1 15 6 11 13 5 4 3 5 4 8 7 3 3 5 7 3 2 1 5 6 1 3 5 4 2 1 5 13 11 3 1 6 9 2 13 2 4 5 3 7 5 1 9 3 5 10 3 3 2 12 1 2 4 3 8 7 8 9 1 2 6 1 5 1 3 6 5 3 3 10 3 2 3 19 2 3 6 7 2 6 4 5 6 6 4 2 3 7 5 3 6 1 5 9 1 9 5 4 5 1 6 2 7 14 1 8 1 9 3 5 3 4 8 7 15 5 10 3 5 12 1 14 1 6 8 3 4 18 2 4 2 7 6 5 4 6 2 3 4 2 3 7 11 4 3 2 1 5 3 10 5 4 3 3 11 9 1 8 3 10 2 13 2 7 11 7 2 6 3 4 2 3 3 13 5 1 9 9 2 1 8 1 9 2 3 4 2 3 6 1 3 3 14 19 2 4 8 13 2 1 5 6 1 5 4 3 5 6 1 5 1 12 2 15 13 3 3 9 3 3 11 1 5 9 13 2 9 4 3 3 6 8 3 4 8 3 4 8 1 21 29 4 2 3 1 2 4 8 3 10 2 6 6 3 6 1 5 1 3 11 1 5 3 4 3 5 7 3 3 2 9 4 5 4 8 7 5 1 5 1 6 3 2 10 5 4 26 4 5 3 1 5 4 5 3 3 4 5 1 11 1 2 3 7 2 1 12 6 2 13 9 2 3 7 15 3 2 3 1 11 4 2 3 1 11 3 4 8 3 7 2 3 9 4 6 3 6 12 15 8 4 17 4 11 3 7 5 9 7 2 6 4 2 18 3 3 1 5 1 2 10 3 3 5 6 3 1 20 4 3 14 3 1 6 9 2 12 7 3 3 5 10 5 7 8 7 8 3 4 18 2 6 6 3 6 25 6 3 2 3 3 4 3 5 1 5 1 9 5 7 8 4 3 2 10 2 1 5 3 7 9 5 19 5 9 1 5 1 6 2 1 2 7 3 5 4 20 3 10 2 6 4 3 17 4 11 4 6 5 1 8 21 6 4 11 4 11 4 3 17 1 3 2 7 3 8 1 11 3 4 12 11 3 1 6 2 3 7 2 4 12 2 3 3 1 11 10 3 2 7 2 3 3 4 3 5 3 4 3 8 7 3 3 11 3 12 16 3 9 3 9 5 4 15 9 3 8 6 3 6 1 3 2 6 4 3 11 4 3 2 7 5 9 10 5 1 3 2 1 14 9 1 5 3 3 3 7 20 12 1 2 4 6 2 10 2 16 9 8 3 18 4 3 2 3 7 2 3 13 3 5 7 9 5 3 3 7 5 3 3 7 3 12 2 7 11 4 6 5 4 6 9 5 9 4 12 5 4 2 12 3 9 3 1 5 15 1 5 1 2 1 20 1 14 4 3 3 9 3 5 7 2 9 15 9 1 6 15 3 15 2 9 6 1 2 7 3 5 3 4 3 5 6 1 3 6 5 1 9 2 10 2 3 7 3 3 11 3 3 4 9 9 5 1 5 1 3 2 3 6 9 1 5 4 2 9 1 3 3 3 5 4 5 3 9 6 4 6 3 2 3 7 8 1 6 2 3 19 3 3 8 10 14 10 5 3 3 7 2 13 2 7 5 9 7 14 1 2 7 8 1 14 3 4 3 17 4 2 9 1 8 4 3 20 4 9 2 15 3 6 1 15 3 5 7 20 7 5 1 6 5 4 2 4 3 3 14 1 2 6 7 8 4 15 8 9 1 5 9 3 16 2 9 3 1 6 5 9 1 3 5 7 9 14 3 4 8 1 2 10 5 4 9 5 1 5 4 2 3 6 3 10 2 1 3 2 10 5 13 9 5 1 9 3 8 7 2 13 2 7 5 6 7 3 3 2 7 5 1 15 9 11 1 8

;[Bit16PrimesA: B$ ? #02000]

