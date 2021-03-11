
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
___________________________________________________________________________________________

[Align_on | add #2 #1-1 | and #2 0-#1]
;[DBGBP | nope]
;[DBGBP | cmp B$isDBG 0 | DB 074 01 0CC ]
;[isDBG: D$ 0]
[CRLF 0A0D]


TITLE BaseCodecs
____________________________________________________________________________________________

[<16 tbase16: B$
0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FE 0FF 0FF 0FE 0FF 0FF
0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF
0FE 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF
0   01  02  03  04  05  06  07  08  09  0FF 0FF 0FF 0FF 0FF 0FF
0FF 0A  0B  0C  0D  0E  0F  0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF
0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF
0FF 0A  0B  0C  0D  0E  0F  0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF
0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF
0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF
0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF
0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF
0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF
0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF
0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF
0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF
0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF]

[<16 tbase24: B$
0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FE 0FF 0FF 0FE 0FF 0FF
0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF
0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF
0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF
0FF 0 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E
0F 010 011 012 013 014 015 016 017 0FF 0FF 0FF 0FF 0FF 0FF 0FF
0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF
0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF
0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF
0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF
0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF
0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF
0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF
0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF
0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF
0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF]

[<16 tbase41: B$
0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FE 0FF 0FF 0FE 0FF 0FF
0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF
0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF
0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF
0FF 0 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E
0F 010 011 012 013 014 015 016 017 018 019 0FF 0FF 0FF 0FF 0FF
0FF 01A 01B 01C 01D 01E 01F 020 021 022 023 024 025 026 027 028
0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF
0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF
0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF
0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF
0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF
0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF
0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF
0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF
0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF]

[<16 tbase53: B$
0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FE 0FF 0FF 0FE 0FF 0FF
0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF
0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF
034 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF
0FF 0 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E
0F 010 011 012 013 014 015 016 017 018 019 0FF 0FF 0FF 0FF 0FF
0FF 01A 01B 01C 01D 01E 01F 020 021 022 023 024 025 026 027 028
029 02A 02B 02C 02D 02E 02F 030 031 032 033 0FF 0FF 0FF 0FF 0FF
0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF
0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF
0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF
0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF
0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF
0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF
0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF
0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF]

[<16 tbase62: B$
0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF
0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF
0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF
0 01 02 03 04 05 06 07 08 09 0FF 0FF 0FF 0FF 0FF 0FF
0FF 0A 0B 0C 0D 0E 0F 010 011 012 013 014 015 016 017 018
019 01A 01B 01C 01D 01E 01F 020 021 022 023 0FF 0FF 0FF 0FF 0FF
0FF 024 025 026 027 028 029 02A 02B 02C 02D 02E 02F 030 031 032
033 034 035 036 037 038 039 03A 03B 03C 03D 0FF 0FF 0FF 0FF 0FF
0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF
0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF
0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF
0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF
0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF
0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF
0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF
0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF]

[<16 tbase64: B$
0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FE 0FF 0FF 0FE 0FF 0FF
0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF
0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 03E 0FF 0FF 0FF 03F
034 035 036 037 038 039 03A 03B 03C 03D 0FF 0FF 0FF 0FF 0FF 0FF
0FF 0 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E
0F 010 011 012 013 014 015 016 017 018 019 0FF 0FF 0FF 0FF 0FF
0FF 01A 01B 01C 01D 01E 01F 020 021 022 023 024 025 026 027 028
029 02A 02B 02C 02D 02E 02F 030 031 032 033 0FF 0FF 0FF 0FF 0FF
0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF
0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF
0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF
0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF
0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF
0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF
0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF
0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF]

[<16 tbase75: B$
0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FE 0FF 0FF 0FE 0FF 0FF
0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF
0FF 03E 0FF 03F 040 041 0FF 0FF 042 043 0FF 0FF 0FF 0FF 0FF 0FF
034 035 036 037 038 039 03A 03B 03C 03D 0FF 0FF 0FF 0FF 0FF 044
045 0 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E
 0F 010 011 012 013 014 015 016 017 018 019 0FF 0FF 0FF 0FF 046
0FF 01A 01B 01C 01D 01E 01F 020 021 022 023 024 025 026 027 028
029 02A 02B 02C 02D 02E 02F 030 031 032 033 047 048 049 04A 0FF
0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF
0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF
0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF
0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF
0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF
0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF
0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF
0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF 0FF]

Proc BaseHEXA2BinaryDecode::
 ARGUMENTS @pout, @pin, @insz
 USES ebx esi edi

    CLD | sub eax eax
    mov ecx D@insz, esi D@pin, edi D@pout | lea ebx D$esi+ecx
    dec esi
ALIGN 16
L2: inc esi
    cmp ebx esi | jbe L1>
    movzx ecx B$esi | mov ah B$ecx+tbase16
    cmp ah 0FE | je L2< ; skip
    cmp ah 0FF | je L1> ; to end
    shl ah 4
L0: inc esi
    cmp ebx esi | jbe L1>
    movzx ecx B$esi | mov al B$ecx+tbase16
    cmp al 0FE | je L1> ; No skip!
    cmp al 0FF | je L1> ; to end
    or al ah
    stosb
    jmp L2<

L1: sub edi D@pout | mov eax edi
EndP

Proc BaseHex2iBinaryDecode::
 ARGUMENTS @pout, @iBinSZ @pin, @insz
 USES ebx esi edi

    sub eax eax
    mov ecx D@insz, esi D@pin, edi D@pout | lea ebx D$esi+ecx
    dec esi | mov ecx D@iBinSZ
L3: inc esi
    cmp ebx esi | jbe L1>
    movzx edx B$esi | mov ah B$edx+tbase16
    cmp ah 0FE | je L3< ; skip only before first!
    cmp ah 0FF | je L1> ; to end
    jmp L2>
ALIGN 16
L0: inc esi
    cmp ebx esi | jbe L1>
    movzx edx B$esi | mov ah B$edx+tbase16
    cmp ah 0FE | je L1> ; NO skip!
    cmp ah 0FF | je L1> ; to end
L2: shl ah 4
    inc esi
    cmp ebx esi | jbe L1>
    movzx edx B$esi | mov al B$edx+tbase16
    cmp al 0FE | je L1> ; NO skip!
    cmp al 0FF | je L1> ; to end
    or al ah
    mov B$edi+ecx-1 al
    dec ecx | jne L0<
    mov ecx D@iBinSZ | add edi ecx
    jmp L3<

L1: sub edi D@pout | mov eax edi
EndP


[<16 sbase24: B$ 'ABCDEFGHIJKLMNOPQRSTUVWX',0,0D,0A,0];[<16 sbase24: B$ '0123456789ABCDEFGHIJKLMN',0,0D,0A,0]
Proc Base24Enc:: ;ritern sLen
  ARGUMENTS @pout, @pin, @sz
  USES ebx esi edi

    CLD | mov eax 0 | cmp D@sz 0 | jle P9>>
    mov ebx 24 | mov esi D@pin | mov edi D@pout | jmp L1>

L2:
    lodsd | mov ecx 7
L0: sub edx edx | div ebx | mov dl B$sbase24+edx | mov B$edi+ecx-1 dl | sub ecx 1 | jne L0<
    add edi 7
L1: sub D@sz 4 | jge L2<

    add D@sz 4 | mov ecx D@sz | je L9>
; least 1-3 bytes >> 2-6 chars
    sub eax eax
L0: shl eax 8 | mov al B$esi+ecx-1 | sub ecx 1 | jg L0<

    mov ecx D@sz | shl ecx 1 | mov esi edi | add edi ecx
L0: sub edx edx | div ebx | mov dl B$sbase24+edx | mov B$esi+ecx-1 dl | sub ecx 1 | jne L0<

L9: sub edi D@pout | mov eax edi
EndP


; ARGs: @pout, @pin, @sz ; returns byte Length
Base24Dec::
  push ebx ebp esi edi

    sub eax eax | mov ecx D$esp+01C | test ecx ecx | jle L8>>
    mov esi D$esp+018 | mov edi D$esp+014 | lea ebx D$esi+ecx | jmp L2>

B1: mov edx 7 | sub edx ebp | mov ebp edx | jmp L7>
B2: inc esi | jmp L3>
ALIGN 16
L2:
    sub eax eax | mov ebp 7
L3: cmp esi ebx | jae B1<
    movzx ecx B$esi | mov cl B$ecx+tbase24
    cmp cl 0FE | je B2< ; skip
    cmp cl 0FF | je B1< ; to end

    test eax eax | je L5>
    mov edx 24 | mul edx | jc L9> ;Overflows
L5:
    add eax ecx | jc L9> ;Overflows

    inc esi | dec ebp | jne L3<
    stosd
    jmp L2<

;   Least 2,4,6 chars >> 1,2,3 bytes
L7: test ebp ebp | je L9> | test ebp 1 | jne L9> ; 0=end, 1,3,5 can't be
    mov D$edi eax
    shr ebp 1 | add edi ebp

L9: sub edi D$esp+014 | mov eax edi
L8: pop edi esi ebp ebx
    ret 0C


[<16 sbase41: B$ 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmno',0,0D,0A,0]
Proc Base41Enc:: ;ritern sLen
  ARGUMENTS @pout, @pin, @sz
  USES ebx esi edi

    CLD | mov eax 0 | cmp D@sz 0 | jle P9>>
    mov ebx 41 | mov esi D@pin | mov edi D@pout | jmp L1>
ALIGN 16
L2:
    movzx eax W$esi | mov ecx 3
L0: sub edx edx | div ebx | mov dl B$sbase41+edx | mov B$edi+ecx-1 dl | sub ecx 1 | jne L0<
    add esi 2
    add edi 3
L1: sub D@sz 2 | jge L2<

    add D@sz 2 | mov ecx D@sz | je L9>
; least 1 byte >> 2 chars
    movzx eax B$esi
    mov ecx 2 | mov esi edi | add edi ecx
L0: sub edx edx | div ebx | mov dl B$sbase41+edx | mov B$esi+ecx-1 dl | sub ecx 1 | jne L0<

L9: sub edi D@pout | mov eax edi
EndP


; ARGs: @pout, @pin, @sz ; returns byte Length
Base41Dec::
  push ebx ebp esi edi

    sub eax eax | mov ecx D$esp+01C | test ecx ecx | jle L8>>
    mov esi D$esp+018 | mov edi D$esp+014 | lea ebx D$esi+ecx | jmp L2>

B1: mov edx 3 | sub edx ebp | mov ebp edx | jmp L7>
B2: inc esi | jmp L3>
ALIGN 16
L2:
    sub eax eax | mov ebp 3
L3: cmp esi ebx | jae B1<
    movzx ecx B$esi | mov cl B$ecx+tbase41
    cmp cl 0FE | je B2< ; skip
    cmp cl 0FF | je B1< ; to end

    test eax eax | je L5>
    mov edx 41 | mul dx | jc L9> ;Overflows
L5:
    add ax cx | jc L9> ;Overflows

    inc esi | dec ebp | jne L3<
    stosw
    jmp L2<

;   Least 2 chars >> 1 byte
L7: test ebp ebp | je L9> | cmp ebp 2 | jne L9> ; 0=end, 1 can't be
    mov B$edi al
    sub ebp 1 | add edi ebp

L9: sub edi D$esp+014 | mov eax edi
L8: pop edi esi ebp ebx
    ret 0C


[<16 sbase53: B$ 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0',0,0D,0A,0]
Proc Base53Enc:: ; returns char Len
  ARGUMENTS @pout, @pin, @sz
  Local @Bit64
  USES ebx esi edi

    CLD | mov eax 0 | cmp D@sz 0 | jle P9>>
    mov ebx 53 | mov esi D@pin | mov edi D@pout | jmp L1>
L2:
    mov ecx (7-1)
    sub edx edx
    movzx eax B$esi+4 | div ebx | mov D@Bit64 eax
    mov eax D$esi | div ebx
    mov dl B$sbase53+edx | mov B$edi+6 dl | add esi 5
    mov edx D@Bit64 | jmp L3>
L0:
    sub edx edx
L3: div ebx | mov dl B$sbase53+edx | mov B$edi+ecx-1 dl
    dec ecx | jne L0<
    add edi 7
L1: sub D@sz 5 | jge L2<

    add D@sz 5 | mov ecx D@sz | je L9>

    sub eax eax
L0: shl eax 8 | mov al B$esi+ecx-1 | sub ecx 1 | jg L0<

;   Least 1,2,3,4 bytes >> 2,3,5,6 chars
    mov ecx D@sz | cmp ecx 2 | jbe L0> | inc ecx
L0: inc ecx | mov esi edi | add edi ecx

L0: sub edx edx
    div ebx | mov dl B$sbase53+edx | mov B$esi+ecx-1 dl
    dec ecx | jne L0<

L9: sub edi D@pout | mov eax edi
EndP
;;
Proc Base53Enc0: ; returns char Len
  ARGUMENTS @pout, @pin, @sz
  SZLocal 8 @Bit64
  USES ebx esi edi

    CLD | mov eax 0 | cmp D@sz 0 | jle P9>>
    mov ebx 53 | mov esi D@pin | mov edi D@pout | jmp L1>
L2:
    mov ecx 6
    sub edx edx
    movzx eax B$esi+4 | div ebx | mov D@Bit64+4 eax
    mov eax D$esi | div ebx | mov D@Bit64 eax
    mov dl B$sbase53+edx | mov B$edi+6 dl | add esi 5
L0:
    sub edx edx
    mov eax D@Bit64+4 | div ebx | mov D@Bit64+4 eax
    mov eax D@Bit64 | div ebx | mov D@Bit64 eax
    mov dl B$sbase53+edx | mov B$edi+ecx-1 dl
    dec ecx | jne L0<
    add edi 7

L1: sub D@sz 5 | jge L2<

    add D@sz 5 | mov ecx D@sz | je L9>

    sub eax eax
L0: shl eax 8 | mov al B$esi+ecx-1 | sub ecx 1 | jg L0<

;   Least 1,2,3,4 bytes >> 2,3,5,6 chars
    mov ecx D@sz | cmp ecx 2 | jbe L0> | inc ecx
L0: inc ecx | mov esi edi | add edi ecx

L0: sub edx edx
    div ebx | mov dl B$sbase53+edx | mov B$esi+ecx-1 dl
    dec ecx | jne L0<

L9: sub edi D@pout | mov eax edi
EndP
;;

; ARGs @pout, @pin, @sz ; returns byte Length
Base53Dec::
  push ebx ebp esi edi

    sub eax eax | mov ecx D$esp+01C | test ecx ecx | jle L8>>
    mov esi D$esp+018 | mov edi D$esp+014 | lea ebx D$esi+ecx | jmp L2>

B1: mov edx 7 | sub edx ebp | mov ebp edx | jmp L7>
B2: inc esi | jmp L3>
ALIGN 16
L2:
    mov ebp 7
L3: cmp esi ebx | jae B1<
    movzx ecx B$esi | mov cl B$ecx+tbase53
    cmp cl 0FE | je B2< ; skip
    cmp cl 0FF | je B1< ; to end

    mov eax D$edi+4 | test eax eax | je L5>
    mov edx 53 | mul edx | mov D$edi+4 eax ;| test edx edx | jne L9> ;Overflows
L5:
    mov eax D$edi | test eax eax | je L5>
    mov edx 53 | mul edx | mov D$edi eax | test edx edx | je L5>
    add D$edi+4 edx ;| jc L9> ;Overflows
L5:
    add D$edi ecx | jnc L5>
    add D$edi+4 1 ;| jc L9> ;Overflows
L5:
    inc esi | dec ebp | jne L3<
    cmp B$edi+5 0 | jne L9> ; Overflows only here!
    add edi 5
    jmp L2<

;   Least 2,3,5,6 chars >> 1,2,3,4 bytes
L7: cmp ebp 1 | jle L9> | cmp ebp 4 | je L9> ; 0=end, 1 & 4 can't be
    cmp ebp 5 | jb L0> | dec ebp
L0: dec ebp | add edi ebp

L9: sub edi D$esp+014 | mov eax edi
L8: pop edi esi ebp ebx
    ret 0C



[<16 sbase62: B$ '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz',0,0]
Proc AnyBits2Base62:: ;ritern sLen
 ARGUMENTS @pBASE62String @pBits @nBits
 USES EBX ESI EDI

; AnyBitNum must be DWORD (32bit) aligned
    mov eax 0 | mov ecx D@nBits | test ecx 00_11111 | jne P9>> | shr ecx 3 | je P9>

    mov edi D@pBASE62String | mov esi D@pBits | lea esi D$esi+ecx-4 | mov ecx 62

L0: mov ebx esi | sub edx edx
    mov eax D$ebx | test eax eax | jne L3>
    sub esi 4 | cmp esi D@pBits | jae L0< | jmp L2>
L1:
    mov eax D$ebx
L3:
    div ecx | mov D$ebx eax
    sub ebx 4 | cmp ebx D@pBits | jae L1<

    mov dl B$edx+sbase62
    mov B$edi dl | inc edi | jmp L0<

L2: mov B$edi 0 ; for NULLstring
    mov ecx D@pBASE62String | sub edi ecx | jne L0>
    mov W$ecx '0' | mov eax 1 | jmp P9> ; for 0 case - store one '0'
; invert string
L0:
    lea edx D$ecx+edi-1
L0: cmp ecx edx | jae L0>
    mov al B$ecx, ah B$edx, B$ecx ah, B$edx al | inc ecx | dec edx | jmp L0<
L0: mov eax edi
EndP


; riterns Bits size in BYTES, (32bit-aligned) or NULL on Error.
; nBits must be DWORD (32bit) aligned
; Bits_buffer will be cleaned, so it can be dirty
Proc Base62ToBits::
 ARGUMENTS @pBits @nBits @pDecimalString
 Local @upBorder
 USES EBX ESI EDI

    mov eax 0 | mov ecx D@nBits | mov ebx ecx | test ecx 00_11111 | jne P9>> | shr ecx 5 | je P9>>
    mov edi D@pBits | shr ebx 3 | add ebx edi | mov D@upBorder ebx | CLD | rep stosd
    mov esi D@pDecimalString | mov ebx D@pBits | add ebx 4
; first char
L0: movzx ecx B$esi | inc esi
    mov cl B$ecx+tbase62 | cmp cl 0FF | je L9>>
    cmp ecx 0 | je L0< ; skip 1st '0's if any
    mov edi D@pBits | mov D$edi ecx
; next chars
L0:
    movzx ecx B$esi | inc esi
    mov cl B$ecx+tbase62 | cmp cl 0FF | je L9>
; Bits MUL 62, from upper dwords must ; EBX is current upper Null ptr
    lea edi D$ebx-4
L4:
    mov eax D$edi | test eax eax | je L1>
    mov edx 62 | mul edx | mov D$edi eax
    test edx edx | je L1>
    lea eax D$edi+4 | cmp eax D@upBorder | jae B0> | cmp eax ebx | jb L3> | lea ebx D$eax+4
L3: add D$eax edx | jnc L1>
L2: add eax 4 | cmp eax D@upBorder | jae B0> | cmp eax ebx | jb L3> | lea ebx D$eax+4
L3: add D$eax 1 | jc L2<

L1: sub edi 4 | cmp edi D@pBits | jae L4<

; Bits+ecx
    add edi 4 | add D$edi ecx | jnc L0<
L2: add edi 4 | cmp edi D@upBorder | jae B0> | cmp edi ebx | jb L3> | lea ebx D$edi+4
L3: add D$edi 1 | jc L2<
    jmp L0<

; overflow
B0: mov eax 0 | jmp P9>
L9: cmp D$ebx-4 0 | jne L0> | sub ebx 4 | cmp ebx D@pBits | ja L9< | add ebx 4
L0: sub ebx D@pBits | mov eax ebx ; nBits length in bytes, min=4
EndP


[<16 sbase64: B$ 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/',0,0D,0A,0]
Proc Base64Enc::
  ARGUMENTS @pou, @pin, @sz
  USES ebx esi edi

    mov ebx sbase64 | mov esi D@pin | mov edi D@pou | mov ecx D@sz
    test ecx ecx | jle @endo
    jmp @strt

@lp:
    mov edx D$esi
    bswap edx | shr edx 8
    mov al dl | and eax 03F | shr edx 6 | mov al B$ebx+eax | mov B$edi+3 al
    mov al dl | and eax 03F | shr edx 6 | mov al B$ebx+eax | mov B$edi+2 al
    mov al dl | and eax 03F | shr edx 6 | mov al B$ebx+eax | mov B$edi+1 al
    and edx 03F | mov al B$ebx+edx | mov B$edi al
    add esi 3 | add edi 4
@strt:
    sub ecx 3 | jae @lp
    add ecx 3 | je @endo

    sub edx edx
    mov dl B$esi | inc esi
    cmp ecx 1 | je L0>
    mov dh B$esi | inc esi
L0:
    bswap edx | shr edx 8
    mov D$edi '===='
    shr edx 6
    mov al dl | and eax 03F | shr edx 6 | cmp ecx 1 | je L0>
    mov al B$ebx+eax | mov B$edi+2 al
L0:
    mov al dl | and eax 03F | shr edx 6 | mov al B$ebx+eax | mov B$edi+1 al
    and edx 03F | mov al B$ebx+edx | mov B$edi al
    add edi 4

@endo:
    mov eax edi
    sub eax D@pou

EndP


Proc Base64Dec::
  ARGUMENTS @pou, @pin, @sz
  USES ebx esi edi

    sub eax eax | mov esi D@pin | mov edi D@pou | mov ecx D@sz
    test ecx ecx | jle L9>
    lea ebx D$esi+ecx | sub ecx ecx
ALIGN 16

;@lp:
L2:
    cmp esi ebx | jae L3>
    movzx eax B$esi | mov al B$tbase64+eax

    cmp al 0FE | je L1> ;@skp
    cmp al 0FF | je L3>

    cmp ecx 0 | jne L0> | sub edx edx
L0:
    shl edx 6 | or dl al | inc ecx | cmp ecx 4 | jb L1>
    sub ecx ecx | shl edx 8 | BSWAP edx
    mov W$edi dx | shr edx 16 | mov B$edi+2 dl | add edi 3
L1: inc esi | jmp L2< ;jmp @lp

;@to3D:
;    cmp al '=' | jne @endo

L3:
    cmp ecx 0 | je L9>
    cmp ecx 1 | je L9>
    cmp ecx 3 | je L0>
    shl edx 20 | BSWAP edx | mov B$edi dl | add edi 1 | jmp L9>
L0: shl edx 14 | BSWAP edx | mov W$edi dx | add edi 2
L9:
    mov eax edi
    sub eax D@pou

EndP

;;
Proc Base64Enc1:
  ARGUMENTS @pou, @pin, @sz
  USES ebx esi edi

    sub eax eax | mov ebx 3
    mov esi D@pin | mov edi D@pou | mov ecx D@sz
    test ecx ecx | jle @endo
    jmp @strt

@lp0:
    mov edx D$esi | bswap edx | shr edx 8
@lp1:
    mov al dl | and al 03F | shr edx 6
    cmp al 26 | jb L1> | cmp al 52 | jb L2> | cmp al 62 | jb L3> | jne L4>
    mov al '+' | jmp L0>
L4: mov al '/' | jmp L0>
L3: sub al 4 | jmp L0>
L2: add al 6 ;| jmp L0>
L1: add al 'A' ;| jmp L0>
L0:
    mov B$edi+ebx al | sub ebx 1 | jns @lp1
    mov ebx 3 | add esi 3 | add edi 4
@strt:
    sub ecx 3 | ja @lp0 | js L0>
; last3 case > read 3 byte
    mov dx W$esi | bswap edx | mov dh B$esi+2 | shr edx 8 | jmp @lp1

; last 1 or 2
L0: add ecx 3 | je @endo ; for last3 case
    sub edx edx
    mov dl B$esi | inc esi
    cmp ecx 1 | je L0>
    mov dh B$esi | inc esi
L0:
    bswap edx | mov D$edi '===='
    shr edx 14 | cmp ecx 2 | je L0> | shr edx 6
L0:
    mov ebx ecx | mov ecx 0 | jmp @lp1 ; like last3

@endo:
    mov eax edi
    sub eax D@pou

EndP
;;
;;
Proc Base64Dec1:
  ARGUMENTS @pou, @pin, @sz
  USES ebx esi edi

    sub eax eax | mov esi D@pin | mov edi D@pou | mov ecx D@sz
    test ecx ecx | jle L9>>
    lea ebx D$esi+ecx | sub ecx ecx
ALIGN 16
@lp:
    cmp esi ebx | jae @endo
    mov al B$esi

    cmp al 'a' | jae @naz1
    cmp al 'A' | jae @nAZ0
    cmp al '0' | jae @n09
    cmp al '+' | je @nplus
    cmp al '/' | je @nslash
    cmp al 0D | je @skp | cmp al 0A | je @skp
    jmp @endo
@skp:
    inc esi | jmp @lp
@nplus:
    mov al 03E | jmp @mk
@nslash:
    mov al 03F | jmp @mk
@n09:
    cmp al '9' | ja @to3D
    add al 4 | jmp @mk

@naz1:
    cmp al 'z' | ja @endo
    sub al 047 | jmp @mk

@nAZ0:
    cmp al 'Z' | ja @endo
    sub al 'A'; | jmp @mk

@mk:
    cmp ecx 0 | jne L0> | sub edx edx
L0:
    shl edx 6 | or dl al | inc ecx | cmp ecx 4 | jb L0>
    sub ecx ecx | shl edx 8 | BSWAP edx | mov D$edi edx | add edi 3
L0: inc esi | jmp @lp

@to3D:
;    cmp al '=' | jne @endo

@endo:
    cmp ecx 0 | je L9>
    cmp ecx 1 | je L9>
    cmp ecx 3 | je L0>
    shl edx 20 | BSWAP edx | mov B$edi dl | add edi 1 | jmp L9>
L0: shl edx 14 | BSWAP edx | mov W$edi dx | add edi 2
L9:
    mov eax edi
    sub eax D@pou

EndP
;;

____________________________________________________________________________________________

[<16 sbase75: B$ 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!#$%()?@_{|}~',0,0D,0A,0]

Proc Base75Enc:: ; returns char Len
  ARGUMENTS @pout, @pin, @sz
  SZLocal 8 @Bit75
  USES ebx esi edi

    CLD | mov eax 0 | cmp D@sz 0 | jle P9>>
    mov ebx 75 | mov esi D@pin | mov edi D@pout | jmp L1>
L2:
    mov ecx 8
    sub edx edx
    mov eax D$esi+3 | shr eax 8 | div ebx | mov D@Bit75+4 eax
    mov eax D$esi | div ebx | mov D@Bit75 eax
    mov dl B$sbase75+edx | mov B$edi+8 dl | add esi 7
L0:
    sub edx edx
    mov eax D@Bit75+4 | div ebx | mov D@Bit75+4 eax
    mov eax D@Bit75 | div ebx | mov D@Bit75 eax
    mov dl B$sbase75+edx | mov B$edi+ecx-1 dl
    dec ecx | jne L0<
    add edi 9

L1: sub D@sz 7 | jge L2<

    add D@sz 7 | mov ecx D@sz | je L9>

    mov edx edi
    lea edi D@Bit75
L0: lodsb | stosb | dec ecx | jne L0<
    lea ecx D@Bit75+6 | sub ecx edi | sub eax eax | rep stosb
    mov edi edx
;   Least 1..3-4..6 bytes >> 2..4-6..8 chars
    mov ecx D@sz | cmp ecx 3 | jbe L0> | inc ecx
L0: inc ecx | mov esi edi | add edi ecx

L0: sub edx edx
    mov eax D@Bit75+4 | div ebx | mov D@Bit75+4 eax
    mov eax D@Bit75 | div ebx | mov D@Bit75 eax
    mov dl B$sbase75+edx | mov B$esi+ecx-1 dl
    dec ecx | jne L0<

L9: sub edi D@pout | mov eax edi
EndP


; ARGs @pout, @pin, @sz ; returns byte Length
; terminates on..
; ?? TSTICKS for 1 char
Base75Dec::
  push ebx ebp esi edi

    sub eax eax | mov ecx D$esp+01C | test ecx ecx | jle L8>>
    mov esi D$esp+018 | mov edi D$esp+014 | lea ebx D$esi+ecx | jmp L2>

B1: mov edx 9 | sub edx ebp | mov ebp edx | jmp L7>
B2: inc esi | jmp L3>
ALIGN 16
L2:
    mov ebp 9
L3: cmp esi ebx | jae B1<
    movzx ecx B$esi | mov cl B$ecx+tbase75
    cmp cl 0FE | je B2< ; skip
    cmp cl 0FF | je B1< ; to end

    mov eax D$edi+4 | test eax eax | je L5>
    mov edx 75 | mul edx | mov D$edi+4 eax ;| test edx edx | jne L9> ;Overflows
L5:
    mov eax D$edi | test eax eax | je L5>
    mov edx 75 | mul edx | mov D$edi eax | test edx edx | je L5>
    add D$edi+4 edx ;| jc L9> ;Overflows
L5:
    add D$edi ecx | jnc L5>
    add D$edi+4 1 ;| jc L9> ;Overflows
L5:
    inc esi | dec ebp | jne L3<
    cmp B$edi+7 0 | jne L9> ; Overflows only here!
    add edi 7
    jmp L2<

;   Least 2..4-6..8 chars >> 1..3-4..6 bytes
L7: cmp ebp 1 | jbe L9> | cmp ebp 5 | je L9> ; 0=end, 1 & 5 can't be
    cmp ebp 6 | jb L0> | dec ebp
L0: dec ebp | add edi ebp

L9: sub edi D$esp+014 | mov eax edi
L8: pop edi esi ebp ebx
    ret 0C

;;
Proc Base75Enc0: ; returns char Len
  ARGUMENTS @pout, @pin, @sz
  SZLocal 8 @Bit75
  USES ebx esi edi

    CLD | mov eax 0 | cmp D@sz 0 | jle P9>>
    mov ebx 75 | mov esi D@pin | mov edi D@pout | jmp L1>
L2:
    mov ecx 8
    sub edx edx
    mov eax D$esi+3 | shr eax 8 | div ebx | mov D@Bit75+4 eax
    mov eax D$esi | div ebx | mov D@Bit75 eax
    add edx 021 | mov B$edi+8 dl | add esi 7
L0:
    sub edx edx
    mov eax D@Bit75+4 | div ebx | mov D@Bit75+4 eax
    mov eax D@Bit75 | div ebx | mov D@Bit75 eax
    add edx 021 | mov B$edi+ecx-1 dl | dec ecx | jne L0<
    add edi 9

L1: sub D@sz 7 | jge L2<

    add D@sz 7 | mov ecx D@sz | je L9>

    mov edx edi
    lea edi D@Bit75
L0: lodsb | stosb | dec ecx | jne L0<
    lea ecx D@Bit75+6 | sub ecx edi | sub eax eax | rep stosb
    mov edi edx
;   Least 1..3-4..6 bytes >> 2..4-6..8 chars
    mov ecx D@sz | cmp ecx 3 | jbe L0> | inc ecx
L0: inc ecx | mov esi edi | add edi ecx

L0: sub edx edx
    mov eax D@Bit75+4 | div ebx | mov D@Bit75+4 eax
    mov eax D@Bit75 | div ebx | mov D@Bit75 eax
    add edx 021 | mov B$esi+ecx-1 dl | dec ecx | jne L0<

L9: sub edi D@pout | mov eax edi
EndP


ALIGN 16
Base75Dec0:
  push ebx ebp esi edi

    sub eax eax | mov ecx D$esp+01C | test ecx ecx | jle L8>>
    mov esi D$esp+018 | mov edi D$esp+014 | lea ebx D$esi+ecx | jmp L2>

B0: add ecx 021 | cmp cl 0D | je B2> | cmp cl 0A | jne B1> ; skip CRLF
B2: inc esi | jmp L3>
B1: mov edx 9 | sub edx ebp | mov ebp edx | jmp L7>
ALIGN 16
L2:
    mov ebp 9
L3: cmp esi ebx | jae B1<
    movzx ecx B$esi | sub ecx 021 | cmp ecx 75 | jae B0<

    mov eax D$edi+4 | test eax eax | je L5>
    mov edx 75 | mul edx | mov D$edi+4 eax ;| test edx edx | jne L9> ;Overflows
L5:
    mov eax D$edi | test eax eax | je L5>
    mov edx 75 | mul edx | mov D$edi eax | test edx edx | je L5>
    add D$edi+4 edx ;| jc L9> ;Overflows
L5:
    add D$edi ecx | jnc L5>
    add D$edi+4 1 ;| jc L9> ;Overflows
L5:
    inc esi | dec ebp | jne L3<
    cmp B$edi+7 0 | jne L9> ; Overflows only here!
    add edi 7
    jmp L2<

;   Least 2..4-6..8 chars >> 1..3-4..6 bytes
L7: cmp ebp 1 | jbe L9> | cmp ebp 5 | je L9> ; 0=end, 1 & 5 can't be
    cmp ebp 6 | jb L0> | dec ebp
L0: dec ebp | add edi ebp

L9: sub edi D$esp+014 | mov eax edi
L8: pop edi esi ebp ebx
    ret 0C
;;
____________________________________________________________________________________________

Proc Base85EncI:: ; returns char Len
  ARGUMENTS @pout, @pin, @sz
  USES ebx esi edi

    CLD | mov eax 0 | mov ecx D@sz | test ecx ecx | jle P9>
    mov ebx 85 | mov esi D@pin | mov edi D@pout | jmp L1>
L2:
    lodsd | mov ecx 5
L0: sub edx edx | div ebx | add edx 021 | mov B$edi+ecx-1 dl | sub ecx 1 | jne L0< | add edi 5
L1: sub D@sz 4 | jge L2<

    add D@sz 4 | mov ecx D@sz | je L9>
    sub eax eax
L0: shl eax 8 | mov al B$esi+ecx-1 | sub ecx 1 | ja L0<

    mov ecx D@sz | add ecx 1 | mov esi edi | add edi ecx
L0: sub edx edx | div ebx | add edx 021 | mov B$esi+ecx-1 dl | sub ecx 1 | jne L0<

L9: sub edi D@pout | mov eax edi
EndP


; ARGs @pout, @pin, @sz ; returns byte Length
; terminates on End, nonbase char, overflow; skips CR_LF
Base85DecI::
  push ebx ebp esi edi

    CLD | sub eax eax | mov ecx D$esp+01C | test ecx ecx | jle L8>>
    mov esi D$esp+018 | mov edi D$esp+014 | lea ebx D$esi+ecx | jmp L1>

B0: add ecx 021 | cmp cl 0A | je B2> | cmp cl 0D | je B2> | cmp cl 020 | je B2> ; skip CRLF
B1: mov edx 5 | sub edx ebp | mov ebp edx | jmp L4>>
B2: add esi 1 | sub D$esp+01C 1 | jmp L3>
L2:
    mov ebp 5 | sub eax eax
L3: cmp esi ebx | jae B1<
    movzx ecx B$esi | sub ecx 021 | cmp ecx 85 | jae B0<
    mov edx 85 | mul edx | jc L9> | add eax ecx | jc L9> ; Overflows
    add esi 1 | sub ebp 1 | jne L3<
    stosd
L1: sub D$esp+01C 5 | jge L2<
    add D$esp+01C 5 | jle L9>
    jmp L2>

B0: add edx 021 | cmp cl 0A | je B2> | cmp cl 0D | je B2> | cmp cl 020 | je B2> ; skip CRLF
B1: mov edx D$esp+01C | sub edx ebp | mov ebp edx | jmp L4>
B2: add esi 1 | sub D$esp+01C 1 | jmp L3>
;   Least 2-4 chars > 1-3 bytes
L2:
    mov ebp D$esp+01C | sub eax eax
L3: cmp esi ebx | jae B1<
    movzx ecx B$esi | sub ecx 021 | cmp ecx 85 | jae B0<
    mov edx 85 | mul edx | jc L9> | add eax ecx | jc L9> ; Overflows
    add esi 1 | sub ebp 1 | jne L3<
    mov ebp D$esp+01C
L4:
    sub ebp 1 | jle L9>
L0: stosb | shr eax 8 | sub ebp 1 | jne L0<

L9: sub edi D$esp+014 | mov eax edi
L8: pop edi esi ebp ebx
    ret 0C
;;
[RFC1924sbase85: B$ '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz!#$%&()*+-;<=>?@^_`{|}~',0]

Proc Base85EncII: ; returns char Len
  ARGUMENTS @pout, @pin, @sz
  USES ebx esi edi

    CLD | mov eax 0 | mov ecx D@sz | test ecx ecx | jle P9>
    mov ebx 85 | mov esi D@pin | mov edi D@pout | jmp L1>
L2:
    lodsd | mov ecx 5
L0: sub edx edx | div ebx | mov dl B$RFC1924sbase85+edx | mov B$edi+ecx-1 dl | sub ecx 1 | jne L0< | add edi 5
L1: sub D@sz 4 | jae L2<

    add D@sz 4 | mov ecx D@sz | je L9>
    sub eax eax
L0: shl eax 8 | mov al B$esi+ecx-1 | sub ecx 1 | ja L0<

    mov ecx D@sz | add ecx 1 | mov esi edi | add edi ecx
L0: sub edx edx | div ebx | mov dl B$RFC1924sbase85+edx | mov B$esi+ecx-1 dl | sub ecx 1 | jne L0<

L9: sub edi D@pout | mov eax edi
EndP
;;

____________________________________________________________________________________________

Proc Base94Enc:: ; returns char Len
  ARGUMENTS @pout, @pin, @sz
  SZLocal 12 @Bit96
  USES ebx esi edi

    CLD | mov eax 0 | cmp D@sz 0 | jle P9>>
    mov ebx 94 | mov esi D@pin | mov edi D@pout | jmp L1>
L2:
    mov ecx 10
;    lodsd | mov D@Bit96 eax | lodsd | mov D@Bit96+4 eax | sub eax eax | lodsb | mov D@Bit96+8 eax
    sub edx edx
    movzx eax B$esi+8 | div ebx | mov D@Bit96+8 eax
    mov eax D$esi+4 | div ebx | mov D@Bit96+4 eax
    mov eax D$esi | div ebx | mov D@Bit96 eax
    add edx 021 | mov B$edi+10 dl | add esi 9
L0:
    sub edx edx
    mov eax D@Bit96+8 | div ebx | mov D@Bit96+8 eax
    mov eax D@Bit96+4 | div ebx | mov D@Bit96+4 eax
    mov eax D@Bit96 | div ebx | mov D@Bit96 eax
    add edx 021 | mov B$edi+ecx-1 dl | dec ecx | jne L0<
    add edi 11

L1: sub D@sz 9 | jge L2<

    add D@sz 9 | mov ecx D@sz | je L9>

    mov edx edi
    lea edi D@Bit96
L0: lodsb | stosb | dec ecx | jne L0<
    lea ecx D@Bit96+8 | sub ecx edi | sub eax eax | rep stosb
    mov edi edx
;   Least 1..4-5..8 bytes >> 2..5-7..10 chars
    mov ecx D@sz | cmp ecx 4 | jbe L0> | inc ecx
L0: inc ecx | mov esi edi | add edi ecx

L0: sub edx edx
    mov eax D@Bit96+4 | div ebx | mov D@Bit96+4 eax
    mov eax D@Bit96 | div ebx | mov D@Bit96 eax
    add edx 021 | mov B$esi+ecx-1 dl | dec ecx | jne L0<

L9: sub edi D@pout | mov eax edi
EndP


; ARGs @pout, @pin, @sz ; returns byte Length
; terminates on..end_of_input or other char (SPACE)
; best=34 TSTICKS for 1 char
ALIGN 16
Base94Dec::
  push ebx ebp esi edi

    sub eax eax | mov ecx D$esp+01C | test ecx ecx | jle L8>>
    mov esi D$esp+018 | mov edi D$esp+014 | lea ebx D$esi+ecx | jmp L2>

B0: add ecx 021 | cmp cl 0D | je B2> | cmp cl 0A | jne B1> ; skip CRLF
B2: inc esi | jmp L3>
B1: mov edx 11 | sub edx ebp | mov ebp edx | jmp L7>

ALIGN 16
L2:
    mov ebp 11
L3: cmp esi ebx | jae B1<
    movzx ecx B$esi | sub ecx 021 | cmp ecx 94 | jae B0<


    mov eax D$edi+8 | test eax eax | je L5>
    mov edx 94 | mul edx | mov D$edi+8 eax ;| test edx edx | jne L9>
L5:
    mov eax D$edi+4 | test eax eax | je L5>
    mov edx 94 | mul edx | mov D$edi+4 eax | test edx edx | je L5>
    add D$edi+8 edx ;| jc L9>
L5:
    mov eax D$edi | test eax eax | je L5>
    mov edx 94 | mul edx | mov D$edi eax | test edx edx | je L5>
    add D$edi+4 edx | jnc L5> | add D$edi+8 1 ;| jc L9>
L5:
    add D$edi ecx | jnc L5>
    add D$edi+4 1 | jnc L5>
    add D$edi+8 1 ;| jc L9>
L5:
    inc esi | dec ebp | jne L3<
    cmp B$edi+9 0 | jne L9> ; Overflows only here!
    add edi 9
    jmp L2<

;   Least 2..5-7..10 chars >> 1..4-5..8 bytes
L7: cmp ebp 1 | jle L9> | cmp ebp 6 | je L9> ; 0=end, 1 & 6 can't be
    cmp ebp 7 | jb L0> | dec ebp
L0: dec ebp | add edi ebp

L9: sub edi D$esp+014 | mov eax edi
L8: pop edi esi ebp ebx
    ret 0C
;;
ALIGN 16
Base94Dec0:
  push ebx ebp esi edi

    sub eax eax | mov ecx D$esp+01C | test ecx ecx | jle L8>>
    mov esi D$esp+018 | mov edi D$esp+014 | lea ebx D$esi+ecx | jmp L2>

B0: add ecx 021 | cmp cl 0D | je B2> | cmp cl 0A | jne B1> ; skip CRLF
B2: inc esi | jmp L3>
B1: mov edx 11 | sub edx ebp | mov ebp edx | jmp L7>

ALIGN 16
L2:
    mov ebp 11
L3: cmp esi ebx | jae B1<
    movzx ecx B$esi | sub ecx 021 | cmp ecx 94 | jae B0<

    lea ecx D$edi+8
L6:
    mov eax D$ecx | test eax eax | je L5>
    mov edx 94 | mul edx | mov D$ecx eax | test edx edx | je L5>
    lea eax D$ecx+4 | add D$eax edx | jnc L5>
L4: add eax 4 | add D$eax 1 | jc L4<
L5: sub ecx 4 | cmp ecx edi | jae L6<

    movzx ecx B$esi | sub ecx 021
    mov eax edi | add D$eax ecx | jnc L5>
L4: add eax 4 | add D$eax 1 | jc L4<
L5:
    inc esi | dec ebp | jne L3<
    cmp B$edi+9 0 | jne L9> ; Overflows
    add edi 9
    jmp L2<

;   Least 2..5-7..10 chars >> 1..4-5..8 bytes
L7: cmp ebp 1 | jle L9> | cmp ebp 6 | je L9> ; 0=end, 1 & 6 can't be
    cmp ebp 7 | jb L0> | dec ebp
L0: dec ebp | add edi ebp

L9: sub edi D$esp+014 | mov eax edi
L8: pop edi esi ebp ebx
    ret 0C
;;
;;
int 3
BuildBaseTables:
call VAlloc 02000 | mov ebx eax
call BuildBaseTableFromBaseString tbase24 sbase24
call Bytes2Source ebx tbase24 0100
call WriteMem2FileNameA {"tbase24",0} ebx eax
call BuildBaseTableFromBaseString tbase41 sbase41
call Bytes2Source ebx tbase41 0100
call WriteMem2FileNameA {"tbase41",0} ebx eax
call BuildBaseTableFromBaseString tbase53 sbase53
call Bytes2Source ebx tbase53 0100
call WriteMem2FileNameA {"tbase53",0} ebx eax

call BuildBaseTableFromBaseString tbase62 sbase62
call Bytes2Source ebx tbase62 0100
call WriteMem2FileNameA {"tbase62",0} ebx eax
call BuildBaseTableFromBaseString tbase64 sbase64
call Bytes2Source ebx tbase64 0100
call WriteMem2FileNameA {"tbase64",0} ebx eax
call BuildBaseTableFromBaseString tbase75 sbase75
call Bytes2Source ebx tbase75 0100
call WriteMem2FileNameA {"tbase75",0} ebx eax
call VFree ebx
ret
int 3

Proc BuildBaseTableFromBaseString:
 ARGUMENTS @TBase @SBase
  USES esi edi

CLD
mov esi D@SBase | mov edi D@TBase
or eax 0-1 | mov ecx 040 | rep stosd | mov edi D@TBase

L0: movzx eax B$esi+ecx | test eax eax | je L0>
    mov B$edi+eax cl | inc ecx | cmp ecx 0100 | jb L0< | jmp P9>
L0: lea esi D$esi+ecx+1 ; escape-bytes
L0: movzx eax B$esi | test eax eax | je P9>
    mov B$edi+eax 0FE | inc esi | jmp L0<
EndP

proc Bytes2Source:
 ARGUMENTS @pSrc @pBytes @cnt
  USES ebx esi edi

    CLD
    mov esi D@pBytes | mov edi D@pSrc

L1:
    mov ebx 16 | sub D@cnt 16 | jb L2>
L0: LODSB | call AL2EdiHexA_T | mov al ' ' | stosb | dec ebx | jne L0<
    inc edi | mov W$edi-2 CRLF | jmp L1<
L2: add D@cnt 16 | jle L9>

    mov ebx D@cnt
L0: LODSB | call AL2EdiHexA_T | mov al ' ' | stosb | dec ebx | jne L0<

L9: mov eax edi | sub eax D@pSrc
EndP
;;

;;
[dnum 080]
[<16 multA: D$ 0 #(dnum+1) ]
[<16 multB: D$ 0 #(dnum+1) ]

basetest:
; BASE94 9/11 1.2222  68/83
; BASE91 13/16 1.2307
; BASE85 4/5 1.25   137/171
; BASE79 11/14 1.2727
; BASE75 7/9 1.2857    109/140
; BASE72 10/13 1.3   37/48 64/83
; BASE64 3/4 1.3333
; BASE62 5/7 8/11  20/27 1.35  32/43 1.34375
; BASE57 8/11 1.375
; BASE53 5/7 1.4
; BASE41 2/3 1.5
; BASE32 5/8 1.6
; BASE24 4/7 1.75
; BASE23 5/9 1.8  9/16 1.7777
; BASE22 5/9 1.8
; BASE21 6/11
; BASE20 7/13
; BASE19 9/17

FINIT
push 0,0
mov ebx 15

L85:
DBGBP
mov D$esp 1 | mov D$esp+4 1 | FILD Q$esp | FSTP Q$esp

inc bl | je L9>
mov edi multA | mov ecx (dnum+1) | sub eax eax | cld | rep stosd
mov edi multB | mov ecx (dnum+1) | sub eax eax | cld | rep stosd


mov D$multA ebx
mov edi multB, esi multA, ebp 1

L0:
call AnyBitsMul32Bit edi (dnum*32+32), esi (dnum*32), ebx
inc ebp | cmp ebp 32 | ja L85

L1: cmp B$edi+eax 0 | jne L1> | dec eax | jmp L1<
L1: cmp B$edi+eax BL | jae L1>

push eax, ebp

FILD D$esp | add esp 4 | FILD D$esp | add esp 4

FDIVP ST1 ST0 | FLD Q$esp | FCOMIP ST1 | jb L2> | FSTP Q$esp | jmp L1>
L2: FSTP

L1:
xchg esi edi | jmp L0<

L9: add esp 8 | ret


[<16 BaseXByteCharCountPair: B$ 0 #0200 ]
[BaseXByteCharCountPairCurrPos: D$ 0]
basegenericoEncSZ:

pushad
FINIT
push 0,0
mov ebx 15

L86:
DBGBP
mov D$esp 1 | mov D$esp+4 1 | FILD Q$esp | FSTP Q$esp

inc ebx | cmp ebx 95 | jae L9>>
mov edi multA | mov ecx (dnum+1) | sub eax eax | cld | rep stosd
mov edi multB | mov ecx (dnum+1) | sub eax eax | cld | rep stosd
mov D$BaseXByteCharCountPairCurrPos BaseXByteCharCountPair
mov ebp 0

L0:
inc ebp | cmp ebp 0FF | ja L86
mov edi multA, ecx ebp, al 0FF | CLD | rep stosb | mov D$edi 0
mov eax ebp | shl eax 3 | ALIGN_ON 32 eax
call AnyBits2BaseX multB ebx multA eax
cmp eax 0FF | ja L86
mov ecx D$BaseXByteCharCountPairCurrPos | mov W$ecx bp, B$ecx+1 al
add D$BaseXByteCharCountPairCurrPos 2

push ebp, eax

FILD D$esp | add esp 4 | FILD D$esp | add esp 4

FDIVP ST1 ST0 | FLD Q$esp | FCOMIP ST1 | jb L2> | FSTP Q$esp | jmp L1>
L2: FSTP

L1:
jmp L0<

L9: DBGBP | add esp 8 | popad |  ret


Proc AnyBits2BaseX: ;ritern sLen
 ARGUMENTS @pBASEXString @BaseX @pBits @nBits
 USES EBX ESI EDI

; AnyBitNum must be DWORD (32bit) aligned
    mov eax 0 | mov ecx D@nBits | test ecx 00_11111 | jne P9>> | shr ecx 3 | je P9>

    mov edi D@pBASEXString | mov esi D@pBits | lea esi D$esi+ecx-4 | mov ecx D@BaseX

L0: mov ebx esi | sub edx edx
    mov eax D$ebx | test eax eax | jne L3>
    sub esi 4 | cmp esi D@pBits | jae L0< | jmp L2>
L1:
    mov eax D$ebx
L3:
    div ecx | mov D$ebx eax
    sub ebx 4 | cmp ebx D@pBits | jae L1<

    add dl '!'
    mov B$edi dl | inc edi | jmp L0<

L2: mov B$edi 0 ; for NULLstring
    mov ecx D@pBASEXString | sub edi ecx | jne L0>
    mov W$ecx '0' | mov eax 1 | jmp P9> ; for 0 case - store one '0'
; invert string
L0:
    lea edx D$ecx+edi-1
L0: cmp ecx edx | jae L0>
    mov al B$ecx, ah B$edx, B$ecx ah, B$edx al | inc ecx | dec edx | jmp L0<
L0: mov eax edi
EndP

;******************
basegenericoDecSZ: ;62
[baseXvalue 62]
pushad
FINIT
push 0,0
mov ebx baseXvalue

L87:
DBGBP
mov D$esp 1 | mov D$esp+4 0 | FILD Q$esp | FSTP Q$esp

mov edi multA | mov ecx (dnum+1) | sub eax eax | cld | rep stosd
mov edi multB | mov ecx (dnum+1) | sub eax eax | cld | rep stosd
mov D$BaseXByteCharCountPairCurrPos BaseXByteCharCountPair
mov ebp 0

L0:
inc ebp | cmp ebp 0FF | ja L9>
mov edi multA, ecx ebp | mov eax 'z' | CLD | rep stosb | mov D$edi 0
call Base62ToBits multB (0100*8) multA
cmp eax 0FF | ja L9> | cmp eax 0 | je L9>

mov edi multB
L1: cmp B$edi+eax-1 0 | jne L1> | dec eax | jmp L1<
L1:

mov ecx D$BaseXByteCharCountPairCurrPos | mov W$ecx bp, B$ecx+1 al
add D$BaseXByteCharCountPairCurrPos 2

push eax, ebp

FILD D$esp | add esp 4 | FILD D$esp | add esp 4

FDIVP ST1 ST0 | FLD Q$esp | FCOMIP ST1 | ja L2> | FSTP Q$esp | jmp L1>
L2: FSTP

L1:
jmp L0<

L9: DBGBP | add esp 8 | popad |  ret

;;

____________________________________________________________________________________________

TITLE HEXconversions

;Arguments @pString @byte
B2H::
 mov al B$esp+04 | mov edx D$esp+08
 mov ah al
 shr al 04 | and ah 0F | or eax 03030
 cmp al 03A | jb B1> | add al 07
B1:
 cmp ah 03A | jb B1> | add ah 07
B1:
 mov W$edx ax
; mov B$edx+2 0; last NULL
 mov eax 2
 ret 08

;Arguments @pString, @WORD
W2H::
 cld
 push edi
 mov edi D$esp+08 | mov dx W$esp+0C | mov ecx 2
 ror edx 8
B0:
 mov al dl | mov ah dl
 shr al 04 | and ah 0F | or eax 03030
 cmp al 03A | jb B1> | add al 07
B1:
 cmp ah 03A | jb B1> | add ah 07
B1:
 stosw
 rol edx 08 | dec ecx | jne B0<
; mov B$edi 0
 mov eax 04
 pop edi
 ret 08

ALIGN 16
;Arguments @pString, @DWORD
D2H::
 cld
 push edi
 mov edi D$esp+08 | mov edx D$esp+0C | mov ecx 4
 rol edx 8
B0:
 mov al dl | mov ah dl
 shr al 04 | and ah 0F | or eax 03030
 cmp al 03A | jb B1> | add al 07
B1:
 cmp ah 03A | jb B1> | add ah 07
B1:
 stosw
 rol edx 08 | dec ecx | jne B0<
; mov B$edi 0
 mov eax 08
 pop edi
 ret 08
;
proc Q2H::
 Arguments  @pString @QWordLo @QWordHi
 USES esi edi
    lea esi D@QWordLo | mov edi D@pString
    mov ecx 8
    call iBin2HexA
    mov eax 16
 EndP


proc pWord2HexA::
 Arguments @pString @source
 USES esi edi
    mov ecx 2 | mov esi D@source | mov edi D@pString
    call iBin2HexA
    mov eax edi | sub eax D@pString
EndP

proc pDword2HexA::
 Arguments @pString @source
 USES esi edi
    mov ecx 4 | mov esi D@source | mov edi D@pString
    call iBin2HexA
    mov eax edi | sub eax D@pString
EndP

proc pQword2HexA::
 Arguments @pString @source
 USES esi edi
    mov ecx 8 | mov esi D@source | mov edi D@pString
    call iBin2HexA
    mov eax edi | sub eax D@pString
 EndP

proc pOword2HexA::
 Arguments @pString @source
 USES esi edi
    mov ecx 16 | mov esi D@source | mov edi D@pString
    call iBin2HexA
    mov eax edi | sub eax D@pString
 EndP

proc pAnyBits2HexA::
 Arguments @pString @source @nBits
 USES esi edi
    mov ecx D@nBits | mov esi D@source | mov edi D@pString
    shr ecx 3
    call iBin2HexA
    mov eax edi | sub eax D@pString
 EndP

ALIGN 16
; ecx=bytesCnt, esi=pSource, edi=pString
iBin2HexA::
 cld
B0:
 mov al B$esi+ecx-1 | mov ah al
 shr al 04 | and ah 0F | or eax 03030
 cmp al 03A | jb B1> | add al 07
B1:
 cmp ah 03A | jb B1> | add ah 07
B1:
 stosw | dec ecx | jne B0<
; mov B$edi 0; last NULL
 ret


ALIGN 16
proc Binary2HexA::
 Arguments @dest @source @BytesCount
 USES esi edi

 cld
 mov ecx D@BytesCount | mov esi D@source | mov edi D@dest
B0:
 lodsb | mov ah al
 shr al 04 | and ah 0F | or eax 03030
 cmp al 03A | jb B1> | add al 07
B1:
 cmp ah 03A | jb B1> | add ah 07
B1:
 stosw
 dec ecx | jne B0<
; mov B$edi 0; last NULL
 mov eax edi | sub eax D@dest
EndP

____________________________________________________________________________________________


;ALIGN 16
proc Byte2HexA_T::
 Arguments @pString, @BYTE
 USES edi
  mov AL B@BYTE | mov edi D@pString

;AL2EdiHexA_T:
 CLD
 test al al | jne B1>
 mov al '0' | stosb | jmp B4> ; 0 case
B1:
 test al 0F0 | je B0> | mov B$edi '0' | inc edi ; leading 0
B0:
 mov ah al
 shr al 04 | and ah 0F | or eax 03030
 cmp al 03A | jb B1> | add al 07
B1:
 cmp ah 03A | jb B1> | add ah 07
B1:
 stosw
B4: ;mov B$edi 0; last NULL

  mov eax edi | sub eax D@pString
EndP


proc Word2HexA_T::
 Arguments @pString, @WORD
 USES edi
  mov edx D@WORD | mov edi D@pString
  call DX2EdiHexA_T
  mov eax edi | sub eax D@pString
EndP

proc Dword2HexA_T::
 Arguments @pString, @DWORD
 USES edi
  mov edx D@DWORD | mov edi D@pString
  call Edx2EdiHexA_T
  mov eax edi | sub eax D@pString
EndP

proc pDword2HexA_T::
Arguments @pString, @pDWORD
USES ecx esi edi
 mov ecx 4 | mov esi D@pDWORD | mov edi D@pString
 call iBIN2HEX_TRUNCATED
 mov eax edi | sub eax D@pString
EndP

proc pQword2HexA_T::
Arguments @pString, @pQWORD
USES ecx esi edi
 mov ecx 8 | mov esi D@pQWORD | mov edi D@pString
 call iBIN2HEX_TRUNCATED
 mov eax edi | sub eax D@pString
EndP

proc pOword2HexA_T::
Arguments @pString, @pQWORD
USES ecx esi edi
 mov ecx 16 | mov esi D@pQWORD | mov edi D@pString
 call iBIN2HEX_TRUNCATED
 mov eax edi | sub eax D@pString
EndP

proc pAnyBits2HexA_T::
 Arguments @pString @pBits @nBits
 USES esi edi
    mov ecx D@nBits | mov esi D@pBits | mov edi D@pString
    shr ecx 3
    call iBIN2HEX_TRUNCATED
    mov eax edi | sub eax D@pString
 EndP


ALIGN 16
; ecx=bytesCnt, esi=pSource, edi=pString
iBIN2HEX_TRUNCATED:
 cld
B0:
 mov al B$esi+ecx-1 | test al al | jne B1>
 sub ecx 1 | jg B0<
 mov al '0' | stosb | jmp B4>
B1:
 test al 0F0 | je B0> | mov al '0' | stosb ; leading 0
B0:
 mov al B$esi+ecx-1 | mov ah al
 shr al 04 | and ah 0F | or eax 03030
 cmp al 03A | jb B1> | add al 07
B1:
 cmp ah 03A | jb B1> | add ah 07
B1:
 stosw | dec ecx | jne B0<
B4: ;mov B$edi 0; last NULL
 ret


DX2EdiHexA_T:
 cld
 ror edx 8 | mov ecx 2 | jmp B0>

EDX2EdiHexA_T:
 cld
 rol edx 8 | mov ecx 4

B0:
 test dl dl | jne B1> | rol edx 8 | sub ecx 1 | jg B0<
 mov al '0' | stosb | jmp B4> ; 0 case
B1:
 test dl 0F0 | je B0> | mov al '0' | stosb ; leading 0
B0:
 mov al dl | mov ah dl
 shr al 04 | and ah 0F | or eax 03030
 cmp al 03A | jb B1> | add al 07
B1:
 cmp ah 03A | jb B1> | add ah 07
B1:
 stosw | rol edx 8 | dec ecx | jne B0<
B4: ;mov B$edi 0; last NULL
 ret

AL2EdiHexA_T:
 CLD
 test al al | jne B1>
 mov al '0' | stosb | jmp B4> ; 0 case
B1:
 test al 0F0 | je B0> | mov B$edi '0' | inc edi ; leading 0
B0:
 mov ah al
 shr al 04 | and ah 0F | or eax 03030
 cmp al 03A | jb B1> | add al 07
B1:
 cmp ah 03A | jb B1> | add ah 07
B1:
 stosw
B4: ;mov B$edi 0; last NULL
 ret

____________________________________________________________________________________________

TITLE DecimalConversion
____________________________________________________________________________________________


Proc AnyBits2Decimal:: ;ritern sLen
 ARGUMENTS @pDecimalString @pBits @nBits
 USES EBX ESI EDI

; AnyBitNum must be DWORD (32bit) aligned
    mov eax 0 | mov ecx D@nBits | test ecx 00_11111 | jne P9> | shr ecx 3 | je P9>

    mov edi D@pDecimalString | mov esi D@pBits | lea esi D$esi+ecx-4 | mov ecx 10

L0: mov ebx esi | sub edx edx
    mov eax D$ebx | test eax eax | jne L3>
    sub esi 4 | cmp esi D@pBits | jae L0< | jmp L2>
L1:
    mov eax D$ebx
L3:
    div ecx | mov D$ebx eax
    sub ebx 4 | cmp ebx D@pBits | jae L1<
    or dl 030 | mov B$edi dl | inc edi | jmp L0<

L2: mov B$edi 0 ; for NULLstring
    mov ecx D@pDecimalString | sub edi ecx | jne L0>
    mov W$ecx '0' | mov eax 1 | jmp P9> ; for 0 case - store one '0'
; invert string
L0:
    lea edx D$ecx+edi-1
L0: cmp ecx edx | jae L0>
    mov al B$ecx, ah B$edx, B$ecx ah, B$edx al | inc ecx | dec edx | jmp L0<
L0: mov eax edi
EndP


Proc AnyBits2DecimalF9x:: ;ritern sLen
 ARGUMENTS @pDecimalString @pBits @nBits
 USES EBX ESI EDI

; AnyBitNum must be DWORD (32bit) aligned
    mov eax 0 | mov ecx D@nBits | test ecx 00_11111 | jne P9>> | shr ecx 3 | je P9>>

    mov edi D@pDecimalString | mov esi D@pBits | lea esi D$esi+ecx-4

L0: mov ebx esi | sub edx edx | mov ecx 1000000000
    mov eax D$ebx | test eax eax | jne L3>
    sub esi 4 | cmp esi D@pBits | jae L0< | jmp L2>
L1:
    mov eax D$ebx
L3:
    div ecx | mov D$ebx eax
    sub ebx 4 | cmp ebx D@pBits | jae L1<

    mov eax edx | mov ecx 10 | mov ebx 9
L4:
    sub edx edx | div ecx | or dl 030 | mov B$edi dl | inc edi | dec ebx | jne L4<
    jmp L0<

L2: cmp edi D@pDecimalString | je L2>
    cmp B$edi-1 '0' | jne L2> | dec edi | jmp L2<
L2: mov B$edi 0 ; for NULLstring
    mov ecx D@pDecimalString | sub edi ecx | jne L0>
    mov W$ecx '0' | mov eax 1 | jmp P9> ; for 0 case - store one '0'
; invert string
L0:
    lea edx D$ecx+edi-1
L0: cmp ecx edx | jae L0>
    mov al B$ecx, ah B$edx, B$ecx ah, B$edx al | inc ecx | dec edx | jmp L0<
L0: mov eax edi
EndP


;;
Proc AnyDecimal2Bits0: ;riterns nBits 32-aligned
 ARGUMENTS @pBits @nBits @pDecimalString
 USES EBX ESI EDI

; nBits must be DWORD (32bit) aligned
    mov eax 0 | mov ecx D@nBits | mov ebx ecx | test ecx 00_11111 | jne P9>> | shr ecx 5 | je P9>>
    mov edi D@pBits | shr ebx 3 | add ebx edi | CLD | rep stosd
    mov esi D@pDecimalString
; first char
L0: movzx ecx B$esi | inc esi | sub ecx 030 | cmp ecx 9 | ja L9>
    cmp ecx 0 | je L0< ; skip 1st 0s
    mov edi D@pBits | mov D$edi ecx
; next chars
L0:
    movzx ecx B$esi | inc esi | sub ecx 030 | cmp ecx 9 | ja L9>
; Bits mul 10, from upper dwords must
    lea edi D$ebx-4
L4:
    mov eax D$edi | test eax eax | je L1>
    mov edx 10 | mul edx | mov D$edi eax
    test edx edx | je L1> ;jno L1> ;
    lea eax D$edi+4 | cmp eax ebx | jae B0> | add D$eax edx | jnc L1>
L2: add eax 4 | cmp eax ebx | jae B0> | add D$eax 1 | jc L2<

L1: sub edi 4 | cmp edi D@pBits | jae L4<

; Bits+ecx
    mov edi D@pBits | add D$edi ecx | jnc L0<
L2: add edi 4 | cmp edi ebx | jae B0> | add D$edi 1 | jc L2<
    jmp L0<

; overflow
B0: mov eax 0 | jmp P9>
L9: cmp D$ebx-4 0 | jne L0> | sub ebx 4 | cmp ebx D@pBits | ja L9< | add ebx 4 ; min=4
L0: sub ebx D@pBits | mov eax ebx | shl eax 3 ; bits
EndP
;;

; riterns nBits actual size in BYTES, (32bit-aligned) or NULL on Error.
; if no ERROR, ECX = processed chars
; nBits must be DWORD (32bit) aligned
; Bits_buffer will be cleaned, so it can be dirty
Proc AnyDecimal2Bits::
 ARGUMENTS @pBits @nBits @pDecimalString
 Local @upBorder
 USES EBX ESI EDI

    sub eax eax | mov ecx D@nBits | mov ebx ecx | test ecx 00_11111 | jne B1>> | shr ecx 5 | je B1>>
    mov edi D@pBits | shr ebx 3 | add ebx edi | mov D@upBorder ebx | CLD | rep stosd
    mov esi D@pDecimalString | mov ebx D@pBits | add ebx 4
; is first Number?
    movzx ecx B$esi | sub ecx 030 | cmp ecx 9 | ja B1>> ; ERROR: not Number
; skip 1st '0's if any
    dec esi
L0: inc esi | cmp B$esi '0' | je L0<
; first char
    movzx ecx B$esi | sub ecx 030 | cmp ecx 9 | ja L9>> ; NULL case out
    inc esi | mov edi D@pBits | mov D$edi ecx
ALIGN 16
; next chars
L0:
    movzx ecx B$esi | sub ecx 030 | cmp ecx 9 | ja L9>
    inc esi
; Bits MUL 10, from upper dwords must ; EBX is current upper Null ptr
    lea edi D$ebx-4
L4:
    mov eax D$edi | test eax eax | je L1>
    mov edx 10 | mul edx | mov D$edi eax
    test edx edx | je L1>
    lea eax D$edi+4 | cmp eax D@upBorder | jae B0>
    cmp eax ebx | jb L3> | lea ebx D$eax+4 ; update current upBorder
L3: add D$eax edx | jnc L1>
L2: add eax 4 | cmp eax D@upBorder | jae B0>
    cmp eax ebx | jb L3> | lea ebx D$eax+4 ; update current upBorder
L3: add D$eax 1 | jc L2<

L1: sub edi 4 | cmp edi D@pBits | jae L4<

; Bits+ecx
    add edi 4 | add D$edi ecx | jnc L0<
; BIG-ADC
L2: add edi 4 | cmp edi D@upBorder | jae B0>
    cmp edi ebx | jb L3> | lea ebx D$edi+4 ; update current upBorder
L3: add D$edi 1 | jc L2<
    jmp L0<
; Bad params
B1: mov eax 0 | mov ecx 0 | jmp P9>
; overflow
B0: mov eax 0 | or ecx 0-1 | jmp P9>
L9: cmp D$ebx-4 0 | jne L0> | sub ebx 4 | cmp ebx D@pBits | ja L9< | add ebx 4
; EAX = actual nBits length in bytes (min 4) ; ECX = processed chars
L0: mov eax ebx | sub eax D@pBits | mov ecx esi | sub ecx D@pDecimalString
EndP


; riterns Bits size in BYTES, (32bit-aligned) or NULL on Error.
; nBits must be DWORD (32bit) aligned
; Bits_buffer will be cleaned, so it can be dirty
Proc AnyDecimal2BitsF9x::
 ARGUMENTS @pBits @nBits @pDecimalString
 Local @upBorder @lastMUL
 USES EBX ESI EDI

    sub eax eax | mov ecx D@nBits | mov ebx ecx | test ecx 00_11111 | jne B1>> | shr ecx 5 | je B1>>
    mov edi D@pBits | shr ebx 3 | add ebx edi | mov D@upBorder ebx | CLD | rep stosd
    mov esi D@pDecimalString | mov ebx D@pBits | add ebx 4
; is first Number?
    movzx ecx B$esi | sub ecx 030 | cmp ecx 9 | ja B1>> ; ERROR: not Number
; skip 1st '0's if any
    dec esi
L0: inc esi | cmp B$esi '0' | je L0<

; first case
    mov edi 9 | sub eax eax
L0: movzx ecx B$esi | sub ecx 030 | cmp ecx 9 | ja L8>>
    mov edx 10 | mul edx | add eax ecx | inc esi | dec edi | jne L0<
    mov edi D@pBits | mov D$edi eax
ALIGN 16
; nexts
L0:
    mov edi 9 | sub eax eax
L5: movzx ecx B$esi | sub ecx 030 | cmp ecx 9 | ja L9>>
    mov edx 10 | mul edx | add eax ecx | inc esi | dec edi | jne L5<
    mov ecx eax

; Bits MUL 1000000000, from upper dwords must ; EBX is current upper Null ptr
    lea edi D$ebx-4
L4:
    mov eax D$edi | test eax eax | je L1>
    mov edx 1000000000 | mul edx | mov D$edi eax
    test edx edx | je L1>
    lea eax D$edi+4 | cmp eax D@upBorder | jae B0>>
    cmp eax ebx | jb L3> | lea ebx D$eax+4 ; update current upBorder
L3: add D$eax edx | jnc L1>
L2: add eax 4 | cmp eax D@upBorder | jae B0>>
    cmp eax ebx | jb L3> | lea ebx D$eax+4 ; update current upBorder
L3: add D$eax 1 | jc L2<

L1: sub edi 4 | cmp edi D@pBits | jae L4<
    add edi 4
; Bits+ecx
    add D$edi ecx | jnc L0<
; BIG-ADC
L2: add edi 4 | cmp edi D@upBorder | jae B0>>
    cmp edi ebx | jb L3> | lea ebx D$edi+4 ; update current upBorder
L3: add D$edi 1 | jc L2<
    jmp L0<<

; last case
L9: cmp edi 9 | je L7>>

    mov ecx eax | mov edx 9 | sub edx edi | mov edi edx | mov eax 1
L0: mov edx 10 | mul edx | dec edi | jne L0< | mov D@lastMUL eax

    lea edi D$ebx-4
L4:
    mov eax D$edi | test eax eax | je L1>
    mul D@lastMUL | mov D$edi eax
    test edx edx | je L1>
    lea eax D$edi+4 | cmp eax D@upBorder | jae B0>
    cmp eax ebx | jb L3> | lea ebx D$eax+4 ; update current upBorder
L3: add D$eax edx | jnc L1>
L2: add eax 4 | cmp eax D@upBorder | jae B0>
    cmp eax ebx | jb L3> | lea ebx D$eax+4 ; update current upBorder
L3: add D$eax 1 | jc L2<

L1: sub edi 4 | cmp edi D@pBits | jae L4<
    add edi 4
; Bits+ecx
    add D$edi ecx | jnc L7>
; BIG-ADC last
L2: add edi 4 | cmp edi D@upBorder | jae B0>
    cmp edi ebx | jb L3> | lea ebx D$edi+4 ; update current upBorder
L3: add D$edi 1 | jc L2<
    jmp L7>

; first case out
L8: mov edi D@pBits | mov D$edi eax | jmp L7>

; Bad params
B1: mov eax 0 | mov ecx 0 | jmp P9>
; overflow
B0: mov eax 0 | or ecx 0-1 | jmp P9>

L7: cmp D$ebx-4 0 | jne L0> | sub ebx 4 | cmp ebx D@pBits | ja L7< | add ebx 4
; EAX = actual nBits length in bytes (min 4) ; ECX = processed chars
L0: mov eax ebx | sub eax D@pBits | mov ecx esi | sub ecx D@pDecimalString
EndP
____________________________________________________________________________________________
TITLE DLLMAIN

[hInstance: 0]

Proc Main:
    Arguments @Instance, @Reason, @Reserved

        move D$hInstance D@Instance

        .If D@Reason = &DLL_PROCESS_ATTACH
            ; ...

        Else_If D@Reason = &DLL_PROCESS_DETACH
            ; ...

        Else_If D@Reason = &DLL_THREAD_ATTACH
            ; ...

        Else_If D@Reason = &DLL_THREAD_DETACH
            ; ...

        .End_If

        mov eax &TRUE
Endp


;;
Proc VAlloc:
 ARGUMENTS @vsize
    mov eax D@vsize | cmp eax 0 | jg L0> | sub eax eax | jmp P9>
L0:
    call 'Kernel32.VirtualAlloc', 0, eax, &MEM_COMMIT__&MEM_RESERVE, &PAGE_READWRITE
EndP

Proc VFree:
 ARGUMENTS @addr
    mov eax D@addr | cmp eax 0 | jg L0> | sub eax eax | jmp P9>
L0:
    call 'Kernel32.VirtualFree', eax, 0, &MEM_RELEASE
EndP
;;






