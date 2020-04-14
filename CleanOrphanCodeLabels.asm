

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

[GetMember | {#3 ebp-(#F-#2)} | #+2]
[Structure | {#1 ebp-(&2+#2+4)} | sub esp #2 | push esp | GetMember &2+#2 #L>3 | &2=&2+#2+4 ]

[Return | #If #N=1 | mov eax #1 | #EndIf | jmp P9>>]

[ExitP | jmp P9>>]

[EndP | P9: |  #If &3<>0 | lea esp D$ebp-(&2) | #End_If | &3 | leave | ret &1]
_____________________________________________________________________________________________

[Align_on | add #2 #1-1 | and #2 0-#1][Align_UP | and #2 0-#1 | add #2 #1 ]
[DBGBP | nope]
;[DBGBP | cmp B$isDBG 0 | DB 074 01 0CC ] [isDBG: D$ 0]
[CRLF 0A0D]





TITLE console
____________________________________________________________________________________________

; User-defined Data
[stdHin: 0 stdHout: 0 cmdline: 0][hInstance: 0 winver: 0]
____________________________________________________________________________________________

[ConTitle: B$ 'Orphaned Code Label Cleaner' ,0 ]
[<4 PressAnyKey: B$ 'Press ENTER to exit...' PressAnyKeyLen: D$ Len
 ErrStrOut: B$ 'String Output Error!' ErrStrOutLen: D$ Len]

ConsoleWriteCRLF:
    push CRLF | mov eax esp
    call ConsoleWrite eax 2
    pop edx
RET

Proc ConsoleRead:
 ARGUMENTS @buff @count
    push 0 | mov ecx esp
    call 'KERNEL32.ReadFile' D$stdHin, D@buff, D@count, ecx, 0
    pop ecx
EndP

Proc ConsoleWrite:
 ARGUMENTS @buff @count
    push 0 | mov eax esp
    call 'KERNEL32.WriteFile' D$stdHout, D@buff, D@count, eax, 0
    pop edx

EndP

Proc ConsoleWriteStringNull:
 ARGUMENTS @pStringNull
 USES EDI
    mov edi D@pStringNull, eax 0, ecx 256
    CLD | REPNE SCASB | JNE E0>
    INC ecx | mov eax 256 | sub eax ecx | je E0>
    call ConsoleWrite D@pStringNull eax | jmp P9>
E0:
    call ConsoleWrite ErrStrOut D$ErrStrOutLen
    sub eax eax
EndP

cpause:
    call ConsoleWrite PressAnyKey  D$PressAnyKeyLen

    push 0 | mov eax esp
    call ConsoleRead eax 1
    pop edx
RET

Main:
    call 'Kernel32.GetModuleHandleA' 0 | mov D$hInstance eax
    call 'Kernel32.GetVersion' | mov D$winver eax
    call 'Kernel32.GetStdHandle' &STD_INPUT_HANDLE | mov D$stdHin eax
    call 'Kernel32.GetStdHandle' &STD_OUTPUT_HANDLE | mov D$stdHout eax
    call 'KERNEL32.SetConsoleTitleA' ConTitle
    call 'KERNEL32.GetCommandLineA' &NULL | mov D$cmdline eax
;    call 'Kernel32.IsDebuggerPresent' | mov D$isDBG eax

        call Main4
    call cpause
call "KERNEL32.ExitProcess" &NULL



Proc ReportNumper:
 ARGUMENTS @dword
 USES EDI

    mov edi reportbuf
    call DW2Decimal edi D@dword | add edi eax | mov eax ' ' | STOSB
    call 'BaseRTL.GetCurrentTime2String' EDI | add edi eax
    mov eax CRLF | STOSW | sub edi reportbuf
    call ConsoleWrite reportbuf edi

EndP






















___________________________________________________________________________________________

Align 16


Proc DW2Decimal: ;ritern sLen
 ARGUMENTS @pString, @dwrd
 USES EDI
    cld
    push 0-1 | mov ecx 10 | mov edi D@pString, eax D@dwrd
L0: sub edx edx | div ecx | push edx | cmp eax 0 | ja L0<
L2: pop eax | cmp al 0FF | je L9>
    add al '0' | stosb | jmp L2<
L9: sub edi D@pString | mov eax edi
EndP


TITLE cleaner
___________________________________________________________________________________________

[VAlloc 'BaseRTL.VAlloc'][VFree 'BaseRTL.VFree']

[ErrorMsg: B$ 'Error Happend..', W$ CRLF, B$ 0]
[tselectfile: B$ 'select source asm file..', W$ CRLF, B$ 0 ]
[tchooseoutfile: B$ 'choose output file name..', W$ CRLF, B$ 0 ]
[tfilesz: B$ 'file size:', W$ CRLF, B$ '  ', 0 ]
[tcleaned: B$ 'orphaned code labels removed:', W$ CRLF, B$ '  ', 0 ]

[inmem: D$ 0 inmemSsz: 0 outmem: 0 outSz: 0 orpcount: 0]

[reportbuf: B$ ? #080]

Align 16


Proc Main4:
 USES EBX ESI
;L1:
    call ConsoleWriteStringNull tselectfile
    call 'KERNEL32.Sleep' 900
    AND D$inmem 0 | AND D$inmemSsz 0
    AND D$outMem 0 | AND D$outSz 0
    call 'BaseRTL.ChooseAndLoadFileByNameAnsi' 0 | test eax eax | je P9>>
    mov D$inmem eax, D$inmemSsz edx

    call ConsoleWriteStringNull tfilesz
    call ReportNumper D$inmemSsz

    call 'KERNEL32.SetUnhandledExceptionFilter' FinalExceptionHandler | mov ebx eax
DBGBP
    call OrphanCodeLabelsKill D$inmem D$inmemSsz | mov D$orpcount eax, D$outSz edx

    call 'KERNEL32.SetUnhandledExceptionFilter' ebx

    call ConsoleWriteStringNull tcleaned
    call ReportNumper D$orpcount

    cmp D$orpcount 0 | je L0>

    call ConsoleWriteStringNull tchooseoutfile
    call 'KERNEL32.Sleep' 900
    call 'BaseRTL.ChooseAndSaveToFileNameAnsi' 0 D$inmem D$outSz
L0:
 call VFree D$inmem
;jmp L1<<
EndP
;
;
FinalExceptionHandler:

    call ConsoleWriteStringNull ErrorMsg
    call cpause
    call "KERNEL32.ExitProcess" &NULL
DB 0CC
RET
;
;


Proc FindBytes:
 ARGUMENTS @pMem @MemSzb @pBytes @BytestSz
 USES ebx esi edi

    CLD | mov edi D@pMem, ecx D@MemSzb, esi D@pBytes, edx D@BytestSz
    test ecx ecx | JLE B0> | cmp ecx edx | jb B0>
    LODSB | sub edx 1  | JLE B0>
L0:
    REPNE SCASB | jne B0>
    cmp ecx edx | jb B0>
    PUSH ecx, esi edi
    mov ecx edx | REPE CMPSB
    POP edi esi ecx
    jne L0<
    lea eax D$edi-1 | jmp P9>

B0: sub eax eax

EndP
;
;
; EAX > count, EDX > new size
Proc OrphanCodeLabelsKill:
 ARGUMENTS @pMem @MemSzb
 cLocal @szLabel @cnt
 USES ebx esi edi

    sub eax eax
    CLD | mov esi D@pMem, ebx D@MemSzb
    cmp D$esi 0A0D3B3B | je L3>
    dec esi
L1:
    inc esi | dec ebx | js L9>> ;| cmp ebx 09000 | ja L0> | int 3 | L0:
    mov AL B$esi

    cmp AL ';' | jne L0>
    cmp D$esi-1 0D3B3B0A | jne L2>
L3:
    inc esi | dec ebx | js L9>>
    cmp D$esi-1 0D3B3B0A | jne L3< | add esi 2 | sub ebx 2 | js L9>> | jmp L1<

L2: inc esi | dec ebx | js L9>> | cmp B$esi 020 | jae L2< | jmp L1<

L0: cmp AL '[' | jne L7>
L2:
    inc esi | dec ebx | js L9>>
    mov AL B$esi

L0: cmp AL '"' | jne L0>
L6:
    inc esi | dec ebx | js L9>>
    cmp B$esi '"' | jne L6<
    mov AL B$esi

L0: cmp AL "'" | jne L0>
L6:
    inc esi | dec ebx | js L9>>
    cmp B$esi "'" | jne L6<
L0:
    cmp B$esi ']' | jne L2< | jmp L1<<
L7:

L0: cmp AL '"' | jne L0>
L2:
    inc esi | dec ebx | js L9>>
    cmp B$esi '"' | jne L2< | jmp L1<<

L0: cmp AL "'" | jne L0>
L2:
    inc esi | dec ebx | js L9>>
    cmp B$esi "'" | jne L2< | jmp L1<<

L0:
    cmp AL ':' | jne L1<<
    cmp B$esi+1 ':' | jne L2> | inc esi | dec ebx | jmp L1<<
L2:
    mov edi esi
L2: dec edi | cmp B$edi '|' | je L0>
    cmp B$edi '0' | jae L2<
    cmp B$edi '$' | je L1<<
L0:
    inc edi
    cmp B$edi '@' | je L1<<
    mov eax D$edi | and eax (NOT 020202020) | cmp eax 'MAIN' | je L1<<

    mov D@szLabel esi | sub D@szLabel edi | cmp D@szLabel 2 | je L1<<

    mov eax D@pMem, edx D@MemSzb
L3: mov edx eax | sub edx D@pMem | sub edx D@MemSzb | neg edx
    call FindBytes eax edx edi D@szLabel | test eax eax | je L1<<
    cmp edi eax | je L3>
    mov edx eax
; upper cases
; is in comment?
L4: dec edx ;| cmp D@pMem edx
    cmp B$edx ' ' | jae L4<
L2: inc edx | cmp eax edx | je L1<<
    cmp  B$edx ';' | jne L2<
    inc eax | jmp L3<

L3:
    lea eax D$edi+1
L3:
    mov edx eax | sub edx D@pMem | sub edx D@MemSzb | neg edx
    call FindBytes eax edx edi D@szLabel | test eax eax | je L5>
    mov edx eax
; is in comment?
L4: dec edx ;| cmp D@pMem edx
    cmp B$edx ' ' | jae L4<
L2: inc edx | cmp eax edx | je L1<<
    cmp  B$edx ';' | jne L2<
    inc eax | jmp L3<
; kill
L5: cmp B$edi ':' | je L2>
    mov B$edi 01 | inc edi | jmp L5<
L2: mov B$edi 01 | inc D@cnt | jmp L1<<

L9:
    mov esi D@pMem, edi esi, ecx D@MemSzb

L0: LODSB | cmp AL 01 | je L1> | STOSB
L1: LOOP L0<
    mov edx edi | sub edx D@pMem
    mov eax D@cnt
EndP



