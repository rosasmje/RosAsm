
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
[DBGBP | cmp B$isDBG 0 | DB 074 01 0CC ]
[isDBG: D$ 0]
[CRLF 0A0D]


____________________________________________________________________________________________

[hInstance: 0];[winver: 0]

BaseRTLVersion::
    mov eax 010003
    ret


Proc Main:
    Arguments @Instance, @Reason, @Reserved



        .If D@Reason = &DLL_PROCESS_ATTACH
            ; ...
            move D$hInstance D@Instance
            call 'Kernel32.IsDebuggerPresent' | mov D$isDBG eax

        Else_If D@Reason = &DLL_PROCESS_DETACH
            ; ...

        Else_If D@Reason = &DLL_THREAD_ATTACH
            ; ...

        Else_If D@Reason = &DLL_THREAD_DETACH
            ; ...

        .End_If

        mov eax &TRUE
Endp


____________________________________________________________________________________________

TITLE rtlfuncs
____________________________________________________________________________________________



; DECIMAL conversions
Proc Dword2Decimal: ;ritern sLen
 ARGUMENTS @pDecimalString @Bit32
 USES EDI

    mov eax D@Bit32, edi D@pDecimalString, ecx 10
L0:
    sub edx edx | div ecx | or dl 030 | mov B$edi dl | inc edi
    test eax eax | jne L0<

    mov ecx D@pDecimalString | sub edi ecx | lea edx D$ecx+edi-1
L0: cmp ecx edx | jae L0>
    mov al B$ecx, ah B$edx, B$ecx ah, B$edx al | inc ecx | dec edx | jmp L0<
L0: mov eax edi
EndP

____________________________________________________________________________________________

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

Proc FillMemory::
 ARGUMENTS @pMem @MemSize @Byte
 USES edi

    CLD | mov eax D@Byte | mov ecx D@MemSize | mov edi D@pMem
    mov ah al | mov edx eax | shl eax 16 | mov ax dx
    mov edx ecx | shr ecx 2 | and edx 3
    rep stosd | mov ecx edx | rep stosb
EndP

Proc CopyMemory::
 ARGUMENTS @outMem @inMem @inMemSize
 USES ESI EDI

    CLD | mov ecx D@inMemSize | mov esi D@inMem | mov edi D@outMem | mov edx ecx
    shr ecx 2 | and edx 3 | REP MOVSD | mov ecx edx | REP MOVSB

EndP

Proc ReAllocMemory::
 ARGUMENTS @inMem @inMemSz @NewMemSize

    call VAlloc D@NewMemSize | mov edi eax | test eax eax | je P9>
    call CopyMemory edi D@inMem D@inMemSz
    call VFree D@inMem
    mov eax edi | mov edx D@NewMemSize
EndP

Proc GetTime::
 USES ebx
    sub esp 8
    call 'KERNEL32.GetSystemTimeAsFileTime', esp
    pop ebx, eax
    sub ebx &EPOCH_DIFF_SECS_INTERVAL_LOW | sbb eax &EPOCH_DIFF_SECS_INTERVAL_HIGH
    mov ecx &NANOSECONDS | mov edx 0
    div ecx | xchg ebx eax | div ecx | mov edx ebx
EndP

; TimeString format is comparable: "2020/12/31 02:42:08.012", 23 char long.
Proc GetCurrentTime2String::
 ARGUMENTS @pString
  Structure @SYSTEMTIME 16, @SYSTEMTIME_wYearDis 0,  @SYSTEMTIME_wMonthDis 2, @SYSTEMTIME_wDayOfWeekDis 4,  @SYSTEMTIME_wDayDis 6,
            @SYSTEMTIME_wHourDis 8,  @SYSTEMTIME_wMinuteDis 10,  @SYSTEMTIME_wSecondDis 12,  @SYSTEMTIME_wMillisecondsDis 14
 USES esi edi
    call 'KERNEL32.GetLocalTime', D@SYSTEMTIME
    CLD
    mov edi D@pString
    movzx eax W@SYSTEMTIME_wYearDis | call Dword2Decimal edi eax | add edi eax | mov al '/' | stosb
    movzx eax W@SYSTEMTIME_wMonthDis | call Dword2Decimal edi eax | add edi eax | cmp eax 2 | je L0>
    dec edi | mov al '0' | mov ah B$edi | stosw
L0: mov al '/' | stosb
    movzx eax W@SYSTEMTIME_wDayDis | call Dword2Decimal edi eax | add edi eax | cmp eax 2 | je L0>
    dec edi | mov al '0' | mov ah B$edi | stosw
L0: mov al ' ' | stosb
    movzx eax W@SYSTEMTIME_wHourDis | call Dword2Decimal edi eax | add edi eax | cmp eax 2 | je L0>
    dec edi | mov al '0' | mov ah B$edi | stosw
L0: mov al ':' | stosb
    movzx eax W@SYSTEMTIME_wMinuteDis | call Dword2Decimal edi eax | add edi eax | cmp eax 2 | je L0>
    dec edi | mov al '0' | mov ah B$edi | stosw
L0: mov al ':' | stosb
    movzx eax W@SYSTEMTIME_wSecondDis | call Dword2Decimal edi eax | add edi eax | cmp eax 2 | je L0>
    dec edi | mov al '0' | mov ah B$edi | stosw
L0: mov al '.' | stosb
    movzx eax W@SYSTEMTIME_wMillisecondsDis | call Dword2Decimal edi eax | cmp eax 3 | je L0>
    cmp eax 1 | je L1> | mov DX W$edi | mov B$edi '0' | mov W$edi+1 DX | jmp L0>
L1: mov DL B$edi | mov W$edi '00' | mov B$edi+2 DL
L0: mov eax 3 | add eax edi | sub eax D@pString
EndP


___________________________________________________________________________________________

[WrBufPartSz 0100000]
Proc WriteMem2FileNameA::
 ARGUMENTS @fnameA @pmem @sz
 cLocal @BytesWritten
 USES ebx esi edi

    call 'Kernel32.CreateFileA', D@fnameA, &GENERIC_READ__&GENERIC_WRITE, &FILE_SHARE_READ, 0, &CREATE_ALWAYS,
                                &FILE_ATTRIBUTE_NORMAL__&FILE_FLAG_WRITE_THROUGH, 0;
    cmp eax 0-1 | je L9> | mov ebx eax

    call 'Kernel32.SetFilePointer', ebx, D@sz, 0, &FILE_BEGIN | inc eax | je L8>
    call 'Kernel32.SetFilePointer', ebx, 0, 0, &FILE_BEGIN
    mov edi D@pmem, esi D@sz
L2: sub esi WrBufPartSz | js L0>
    push 0 | mov eax esp
    call 'Kernel32.WriteFile', ebx, edi, WrBufPartSz, eax, 0
    pop edx | add D@BytesWritten edx
    add edi WrBufPartSz | jmp L2<
L0: add esi WrBufPartSz | je L1>
    push 0 | mov eax esp
    call 'Kernel32.WriteFile', ebx, edi, esi, eax, 0
    pop edx | add D@BytesWritten edx
L1:
    call 'Kernel32.FlushFileBuffers', ebx
L8: call 'Kernel32.CloseHandle', ebx
L9:
    mov eax D@BytesWritten
EndP


Proc WriteMem2FileNameW::
 ARGUMENTS @fnameW @pmem @sz
 cLocal @BytesWritten
 USES ebx esi edi

    call 'Kernel32.CreateFileW', D@fnameW, &GENERIC_READ__&GENERIC_WRITE, &FILE_SHARE_READ, 0, &CREATE_ALWAYS,
                                &FILE_ATTRIBUTE_NORMAL__&FILE_FLAG_WRITE_THROUGH, 0;
    cmp eax 0-1 | je L9> | mov ebx eax

    call 'Kernel32.SetFilePointer', ebx, D@sz, 0, &FILE_BEGIN | inc eax | je L8>
    call 'Kernel32.SetFilePointer', ebx, 0, 0, &FILE_BEGIN
    mov edi D@pmem, esi D@sz
L2: sub esi WrBufPartSz | js L0>
    push 0 | mov eax esp
    call 'Kernel32.WriteFile', ebx, edi, WrBufPartSz, eax, 0
    pop edx | add D@BytesWritten edx
    add edi WrBufPartSz | jmp L2<
L0: add esi WrBufPartSz | je L1>
    push 0 | mov eax esp
    call 'Kernel32.WriteFile', ebx, edi, esi, eax, 0
    pop edx | add D@BytesWritten edx
L1:
    call 'Kernel32.FlushFileBuffers', ebx
L8: call 'Kernel32.CloseHandle', ebx
L9:
    mov eax D@BytesWritten
EndP

;returns in EAX-Buffer EDX-BytesRead
Proc LoadFileNameA2Mem::
 ARGUMENTS @pFileName
 USES ebx esi edi

    call 'Kernel32.CreateFileA', D@pFileName, &GENERIC_READ, &FILE_SHARE_READ, 0, &OPEN_EXISTING, &FILE_ATTRIBUTE_NORMAL, 0;
    mov ebx eax | inc eax | je P9>
    push 0 | call 'Kernel32.GetFileSize', ebx, esp | pop edx | test edx edx | jne B0>
    mov esi eax | inc eax | je B0> | cmp esi 0 | je B0>
    call VAlloc esi | mov edi eax | test eax eax | je B0>
    push 0 | mov eax esp
    call 'Kernel32.ReadFile', ebx, edi, esi, eax, 0
    pop edx | cmp esi edx | mov esi edx | jne B1>
    call 'Kernel32.CloseHandle', ebx | mov eax edi, edx esi | jmp P9>
B1: call 'Kernel32.VirtualFree', edi, 0, &MEM_RELEASE
B0: call 'Kernel32.CloseHandle', ebx | sub eax eax
EndP

;returns in EAX-Buffer EDX-BytesRead
Proc LoadFileNameW2Mem::
 ARGUMENTS @pFileName
 USES ebx esi edi

    call 'Kernel32.CreateFileW', D@pFileName, &GENERIC_READ, &FILE_SHARE_READ, 0, &OPEN_EXISTING, &FILE_ATTRIBUTE_NORMAL, 0;
    mov ebx eax | inc eax | je P9>
    push 0 | call 'Kernel32.GetFileSize', ebx, esp | pop edx | test edx edx | jne B0>
    mov esi eax | inc eax | je B0> | cmp esi 0 | je B0>
    call VAlloc esi | mov edi eax | test eax eax | je B0>
    push 0 | mov eax esp
    call 'Kernel32.ReadFile', ebx, edi, esi, eax, 0
    pop edx | cmp esi edx | mov esi edx | jne B1>
    call 'Kernel32.CloseHandle', ebx | mov eax edi, edx esi | jmp P9>
B1: call 'Kernel32.VirtualFree', edi, 0, &MEM_RELEASE
B0: call 'Kernel32.CloseHandle', ebx | sub eax eax
EndP


Proc FileOffsetRead::
 ARGUMENTS @handle @buff @bytes2read @offset
 USES ecx edx
    call 'Kernel32.SetFilePointer', D@handle, D@offset, 0, &FILE_BEGIN | inc eax | je P9>
    push 0 | mov edx esp | call 'Kernel32.ReadFile', D@handle, D@buff, D@bytes2read, edx, 0 | pop edx
    mov eax 0 | cmp D@bytes2read edx | jne P9> | mov eax edx
EndP

[HClose | mov eax #1 | call CloseHandle]
CloseHandle::
    test eax eax | je L0>
    call 'KERNEL32.CloseHandle' eax
L0: ret


FileNameOpenRead:: ;returns: EAX-hFile, ECX- fszLow, EDX- fszHigh ; fail > EAX=0
Proc FileNameAOpenRead::
 ARGUMENTS @fNameA
 cLocal @fszLo @fszHi
 USES ebx

    sub ebx ebx
    call 'KERNEL32.CreateFileA', D@fNameA, &GENERIC_READ, &FILE_SHARE_READ, &NULL, &OPEN_EXISTING,
         &FILE_ATTRIBUTE_NORMAL, 0
    cmp eax 0-1 | je L8> | mov ebx eax
    lea eax D@fszHi | call 'KERNEL32.GetFileSize' ebx, eax | mov D@fszLo eax
    cmp D@fszLo 0-1 | jne L9>
    call 'KERNEL32.GetLastError' | cmp eax &NO_ERROR | jne L9>
L8: HClose ebx | sub ebx ebx | mov D@fszLo ebx, D@fszHi ebx
L9: mov eax ebx, ecx D@fszLo, edx D@fszHi
EndP

Proc FileNameWOpenRead::
 ARGUMENTS @fNameW
 cLocal @fszLo @fszHi
 USES ebx

    sub ebx ebx
    call 'KERNEL32.CreateFileW', D@fNameW, &GENERIC_READ, &FILE_SHARE_READ, &NULL, &OPEN_EXISTING,
         &FILE_ATTRIBUTE_NORMAL, 0
    cmp eax 0-1 | je L8> | mov ebx eax
    lea eax D@fszHi | call 'KERNEL32.GetFileSize' ebx, eax | mov D@fszLo eax
    cmp D@fszLo 0-1 | jne L9>
    call 'KERNEL32.GetLastError' | cmp eax &NO_ERROR | jne L9>
L8: HClose ebx | sub ebx ebx | mov D@fszLo ebx, D@fszHi ebx
L9: mov eax ebx, ecx D@fszLo, edx D@fszHi
EndP


Proc FileNameAOpenCreateWriteAppend::
 ARGUMENTS @fNameA
 USES ebx

    mov eax &OPEN_ALWAYS
L0: call 'KERNEL32.CreateFileA', D@fNameA, &GENERIC_READ__&GENERIC_WRITE, &FILE_SHARE_READ, &NULL, eax,
         &FILE_ATTRIBUTE_NORMAL, 0 ; __&FILE_FLAG_WRITE_THROUGH
    inc eax | je P9> | dec eax
    mov ebx eax
    call 'Kernel32.SetFilePointer', ebx, 0, 0, &FILE_END
    mov eax ebx

EndP


FileNameCreateWrite:: ;returns: EAX-hFile; fail > EAX=0
Proc FileNameACreateWrite::
 ARGUMENTS @fNameA @force

    mov eax &CREATE_NEW | cmp D@force &FALSE | je L0> | mov eax &CREATE_ALWAYS
L0: call 'KERNEL32.CreateFileA', D@fNameA, &GENERIC_READ__&GENERIC_WRITE, &FILE_SHARE_READ, &NULL, eax,
         &FILE_ATTRIBUTE_NORMAL__&FILE_FLAG_WRITE_THROUGH, 0
    inc eax | je P9> | dec eax
EndP

Proc FileNameWCreateWrite::
 ARGUMENTS @fNameW @force

    mov eax &CREATE_NEW | cmp D@force &FALSE | je L0> | mov eax &CREATE_ALWAYS
L0: call 'KERNEL32.CreateFileW', D@fNameW, &GENERIC_READ__&GENERIC_WRITE, &FILE_SHARE_READ, &NULL, eax,
         &FILE_ATTRIBUTE_NORMAL__&FILE_FLAG_WRITE_THROUGH, 0
    inc eax | je P9> | dec eax
EndP


Proc WriteMem2FileHandle::
 ARGUMENTS @fHandle @pmem @sz
    call 'Kernel32.WriteFile', D@fHandle, D@pmem, D@sz, esp, 0
EndP

Proc CloseFlushHandle::
 ARGUMENTS @fHandle

    cmp D@fHandle 0 | je P9>
    call 'Kernel32.FlushFileBuffers', D@fHandle
    call 'Kernel32.CloseHandle', D@fHandle
EndP


FileNameMapRead:: ;returns: EAX-hMap, ECX- fszLow, EDX- fszHigh ; fail > EAX=0
Proc FileNameAMapRead::
 ARGUMENTS @fNameA
 cLocal @fszLo @fszHi
 USES ebx esi edi

    sub ebx ebx | sub esi esi | sub edi edi
    call 'KERNEL32.CreateFileA', D@fNameA, &GENERIC_READ, &FILE_SHARE_READ, &NULL, &OPEN_EXISTING,
          &FILE_ATTRIBUTE_NORMAL, 0
    cmp eax 0-1 | je L8> | mov ebx eax

    lea eax D@fszHi | call 'KERNEL32.GetFileSize' ebx, eax | mov D@fszLo eax
    cmp D@fszLo 0-1 | jne L0>
    call 'KERNEL32.GetLastError' | cmp eax &NO_ERROR | jne L8>
L0: cmp D@fszHi 0 | jne L8> | cmp D@fszLo 0 | je L8>

    call 'Kernel32.CreateFileMappingA', ebx, 0, &PAGE_READONLY, 0, 0, 0;
    cmp eax 0 | je L8> | mov esi eax

    call 'Kernel32.MapViewOfFile', esi, &FILE_MAP_READ, 0, 0, 0 | mov edi eax
L8:
    HClose esi
    HClose ebx
    mov eax edi, ecx D@fszLo, edx D@fszHi
EndP

Proc FileNameWMapRead::
 ARGUMENTS @fNameW
 cLocal @fszLo @fszHi
 USES ebx esi edi

    sub ebx ebx | sub esi esi | sub edi edi
    call 'KERNEL32.CreateFileW', D@fNameW, &GENERIC_READ, &FILE_SHARE_READ, &NULL, &OPEN_EXISTING,
          &FILE_ATTRIBUTE_NORMAL, 0
    cmp eax 0-1 | je L8> | mov ebx eax

    lea eax D@fszHi | call 'KERNEL32.GetFileSize' ebx, eax | mov D@fszLo eax
    cmp D@fszLo 0-1 | jne L0>
    call 'KERNEL32.GetLastError' | cmp eax &NO_ERROR | jne L8>
L0: cmp D@fszHi 0 | jne L8>

    call 'Kernel32.CreateFileMappingW', ebx, 0, &PAGE_READONLY, 0, 0, 0;
    cmp eax 0 | je L8> | mov esi eax

    call 'Kernel32.MapViewOfFile', esi, &FILE_MAP_READ, 0, 0, 0 | mov edi eax
L8:
    HClose esi
    HClose ebx
    mov eax edi, ecx D@fszLo, edx D@fszHi
EndP


FileNameMapRW:: ;returns: EAX-hMap, ECX- fszLow, EDX- fszHigh ; fail > EAX=0
Proc FileNameAMapRW::
 ARGUMENTS @fNameA
 cLocal @fszLo @fszHi
 USES ebx esi edi

    sub ebx ebx | sub esi esi | sub edi edi
    call 'KERNEL32.CreateFileA', D@fNameA, &GENERIC_READ__&GENERIC_WRITE, &FILE_SHARE_READ, &NULL, &OPEN_EXISTING,
          &FILE_ATTRIBUTE_NORMAL, 0
    cmp eax 0-1 | je L8> | mov ebx eax

    lea eax D@fszHi | call 'KERNEL32.GetFileSize' ebx, eax | mov D@fszLo eax
    cmp D@fszLo 0-1 | jne L0>
    call 'KERNEL32.GetLastError' | cmp eax &NO_ERROR | jne L8>
L0: cmp D@fszHi 0 | jne L8>

    call 'Kernel32.CreateFileMappingA', ebx, 0, &PAGE_READWRITE, 0, 0, 0;
    cmp eax 0 | je L8> | mov esi eax

    call 'Kernel32.MapViewOfFile', esi, &FILE_MAP_WRITE, 0, 0, 0 | mov edi eax
L8:
    HClose esi
    HClose ebx
    mov eax edi, ecx D@fszLo, edx D@fszHi
EndP

Proc FileNameWMapRW::
 ARGUMENTS @fNameW
 cLocal @fszLo @fszHi
 USES ebx esi edi

    sub ebx ebx | sub esi esi | sub edi edi
    call 'KERNEL32.CreateFileW', D@fNameW, &GENERIC_READ__&GENERIC_WRITE, &FILE_SHARE_READ, &NULL, &OPEN_EXISTING,
          &FILE_ATTRIBUTE_NORMAL, 0
    cmp eax 0-1 | je L8> | mov ebx eax

    lea eax D@fszHi | call 'KERNEL32.GetFileSize' ebx, eax | mov D@fszLo eax
    cmp D@fszLo 0-1 | jne L0>
    call 'KERNEL32.GetLastError' | cmp eax &NO_ERROR | jne L8>
L0: cmp D@fszHi 0 | jne L8>

    call 'Kernel32.CreateFileMappingW', ebx, 0, &PAGE_READWRITE, 0, 0, 0;
    cmp eax 0 | je L8> | mov esi eax

    call 'Kernel32.MapViewOfFile', esi, &FILE_MAP_WRITE, 0, 0, 0 | mov edi eax
L8:
    HClose esi
    HClose ebx
    mov eax edi, ecx D@fszLo, edx D@fszHi
EndP


Proc hFileMapRead::
 ARGUMENTS @hfile
 USES ebx esi edi

    sub ebx ebx | sub esi esi | sub edi edi

    call 'KERNEL32.GetFileSize' D@hfile, 0 | inc eax | je P9>
    dec eax | mov ebx eax

    call 'Kernel32.CreateFileMappingA', D@hfile, 0, &PAGE_READONLY, 0, 0, 0;
    cmp eax 0 | je L8> | mov esi eax

    call 'Kernel32.MapViewOfFile', esi, &FILE_MAP_READ, 0, 0, 0;
    mov edi eax
L8:
    HClose esi
    mov eax edi, edx ebx
EndP


Proc FileMapClose::
 ARGUMENTS @hMap
    cmp D@hMap 0 | je P9>
    call 'Kernel32.UnmapViewOfFile' D@hMap
EndP


DeleteFile::
Proc DelFileA::
 ARGUMENTS @fNameA
    call 'Kernel32.DeleteFileA' D@fNameA
EndP

Proc DelFileW::
 ARGUMENTS @fNameW
    call 'Kernel32.DeleteFileA' D@fNameW
EndP


Proc CopyFileContent::
 ARGUMENTS @fhWrite @fhRead @szLo @szHi
 cLocal @BytesWrittenLo @BytesWrittenHi @vbuff
 USES ebx esi edi

    call 'Kernel32.SetFilePointer', D@fhRead, 0, 0, &FILE_BEGIN | inc eax | je L9>>
    push D@szHi | mov eax esp
    call 'Kernel32.SetFilePointer', D@fhWrite, D@szLo, eax, &FILE_BEGIN | pop edx | inc eax | jne L0>
    call 'KERNEL32.GetLastError' | cmp eax &NO_ERROR | je L9>>
L0:
    call 'Kernel32.SetFilePointer', D@fhWrite, 0, 0, &FILE_BEGIN | inc eax | je L9>>
    call VAlloc WrBufPartSz | test eax eax | je L9>> | mov D@vbuff eax
    mov edi D@szHi, esi D@szLo

L2: sub esi WrBufPartSz | sbb edi 0 | js L0>

    push 0 | mov edx esp
    call 'Kernel32.ReadFile', D@fhRead, D@vbuff, WrBufPartSz, edx, 0
    pop edx | test eax eax | je L1>> | cmp edx WrBufPartSz | jne L1>

    push 0 | mov edx esp
    call 'Kernel32.WriteFile', D@fhWrite, D@vbuff, WrBufPartSz, edx, 0
    pop edx | add D@BytesWrittenLo edx | adc D@BytesWrittenHi 0
    test eax eax | je L1> | cmp edx WrBufPartSz | jne L1>
    jmp L2<

L0: add esi WrBufPartSz | adc edi 0 | test esi esi | je L1>

    push 0 | mov edx esp
    call 'Kernel32.ReadFile', D@fhRead, D@vbuff, esi, edx, 0
    pop edx | test eax eax | je L1> | cmp edx esi | jne L1>

    push 0 | mov edx esp
    call 'Kernel32.WriteFile', D@fhWrite, D@vbuff, esi, edx, 0
    pop edx | add D@BytesWrittenLo edx | adc D@BytesWrittenHi 0
    ;test eax eax | je L1> | cmp edx esi | jne L1>

L1: call 'Kernel32.SetEndOfFile', D@fhWrite
    call 'Kernel32.FlushFileBuffers', D@fhWrite
    call 'Kernel32.SetFilePointer', D@fhWrite, 0, 0, &FILE_BEGIN
L9: call VFree D@vbuff
    mov eax D@BytesWrittenLo, edx D@BytesWrittenHi
EndP
;************
Proc CopyFile::
 ARGUMENTS @fWrite @fRead
 cLocal @fhop @fszLo @fszHi @fhsv @result

    call FileNameOpenRead D@fRead | test eax eax | je L9>
    mov D@fhop eax, D@fszLo ecx, D@fszHi edx | or ecx edx | je L8>
    call FileNameCreateWrite D@fWrite &TRUE | test eax eax | je L8> | mov D@fhsv eax
    call CopyFileContent D@fhsv, D@fhop, D@fszLo, D@fszHi
    sub eax D@fszLo | sbb edx D@fszHi | or eax edx | sete B@result
L8:
    HClose D@fhsv | HClose D@fhop
    cmp B@result &FALSE | jne P9> | call DeleteFile D@fWrite
L9: mov eax D@result
EndP


Proc CopyDamagedFileContent::
 ARGUMENTS @fhWrite @fhRead @szLo @szHi @chunkSZ
 cLocal @BytesWrittenLo @BytesWrittenHi @vbuff @BytesRFailedLo @BytesRFailedHi @curFPosLo @curFPosHi
 USES ebx esi edi
DBGBP
;    call 'Kernel32.SetFilePointer', D@fhRead, 0, 0, &FILE_BEGIN | inc eax | je L9>>
    push D@szHi | mov eax esp
    call 'Kernel32.SetFilePointer', D@fhWrite, D@szLo, eax, &FILE_BEGIN | pop edx | inc eax | jne L0>
    call 'KERNEL32.GetLastError' | cmp eax &NO_ERROR | je L9>>
L0:
    call 'Kernel32.SetFilePointer', D@fhWrite, 0, 0, &FILE_BEGIN | inc eax | je L9>>
    call VAlloc D@chunkSZ | test eax eax | je L9>> | mov D@vbuff eax
    mov edi D@szHi, esi D@szLo

L2: sub esi D@chunkSZ | sbb edi 0 | js L0>>
    push D@curFPosHi | mov eax esp
    call 'Kernel32.SetFilePointer', D@fhRead, D@curFPosLo, eax, &FILE_BEGIN | pop edx | inc eax | jne L4>
    call 'KERNEL32.GetLastError' | cmp eax &NO_ERROR | jne L9>>
L4:
    push 0 | mov edx esp
    call 'Kernel32.ReadFile', D@fhRead, D@vbuff, D@chunkSZ, edx, 0
    pop edx | mov ecx D@chunkSZ | add D@curFPosLo ecx | adc D@curFPosHi 0
    test eax eax | jne L3> ;| cmp edx D@chunkSZ | jne L1>
DBGBP
    push edi
    mov edi D@vbuff, ecx D@chunkSZ, edx ecx, eax 0 | add D@BytesRFailedLo ecx | adc D@BytesRFailedHi 0
    shr ecx 2 | and edx 3 | rep stosd | mov ecx edx | rep stosb
    pop edi
L3:
    push 0 | mov edx esp
    call 'Kernel32.WriteFile', D@fhWrite, D@vbuff, D@chunkSZ, edx, 0
    pop edx | add D@BytesWrittenLo edx | adc D@BytesWrittenHi 0
    test eax eax | je L1> | cmp edx D@chunkSZ | jne L1>
    jmp L2<<

L0: add esi D@chunkSZ | adc edi 0 | test esi esi | je L1>

    push 0 | mov edx esp
    call 'Kernel32.ReadFile', D@fhRead, D@vbuff, esi, edx, 0
    pop edx | add D@curFPosLo esi | adc D@curFPosHi 0
    test eax eax | jne L3> ;| cmp edx esi | jne L1>

    push edi
    mov edi D@vbuff, ecx esi, edx ecx, eax 0 | add D@BytesRFailedLo ecx | adc D@BytesRFailedHi 0
    shr ecx 2 | and edx 3 | rep stosd | mov ecx edx | rep stosb
    pop edi
L3:
    push 0 | mov edx esp
    call 'Kernel32.WriteFile', D@fhWrite, D@vbuff, esi, edx, 0
    pop edx | add D@BytesWrittenLo edx | adc D@BytesWrittenHi 0
    ;test eax eax | je L1> | cmp edx esi | jne L1>

L1: call 'Kernel32.SetEndOfFile', D@fhWrite
    call 'Kernel32.FlushFileBuffers', D@fhWrite
    call 'Kernel32.SetFilePointer', D@fhWrite, 0, 0, &FILE_BEGIN
L9: call VFree D@vbuff
    mov eax D@BytesWrittenLo, edx D@BytesWrittenHi
EndP

;&FILE_ATTRIBUTE_ARCHIVE__&FILE_ATTRIBUTE_HIDDEN__&FILE_ATTRIBUTE_SYSTEM__&FILE_ATTRIBUTE_READONLY__&FILE_ATTRIBUTE_TEMPORARY,


TITLE THREADS
;
GetTimeTick: jmp 'Kernel32.GetTickCount'

;[<16 JobThreadBusy: D$ 0 JobProcAddr: 0 JobReporterAddr: 0 JobThreadhandle: 0 JobThreadPid: 0
; JobAskToEnd: 0 JobStartTick: 0 JobEndTick: 0 JobProcParamsCount: 0
; JobProcParams: 0 #32]
[Thread@Busy 0 | Thread@ProcAddr 04 | Thread@ReporterAddr 08 | Thread@Handle 0C | Thread@Pid 010
 Thread@AskToEnd 014 | Thread@StartTick 018 | Thread@EndTick 01C | Thread@ProcParamsCount 020 | Thread@ProcParams 024 ]
; 0=fail, 1=start, -1=busy
Proc TryStartFunctionInNewThread::
 ARGUMENTS @ThreadBlock
 USES EBX EDI
DBGBP
    CLD
    mov ebx D@ThreadBlock
    mov eax 0-1 | LOCK xchg D$ebx+Thread@Busy eax | cmp eax 0-1 | je P9>;@busy
    and D$ebx+Thread@Handle 0 | and D$ebx+Thread@Pid 0 | and D$ebx+Thread@AskToEnd 0
    and D$ebx+Thread@StartTick 0 | and D$ebx+Thread@EndTick 0
    call StartNewThreadForFunction EBX ;D$ebx+Thread@ProcAddr
    mov D$ebx+Thread@Handle eax | mov D$ebx+Thread@Pid edx
    test eax eax | mov eax 1 | jne P9>
    sub eax eax
    LOCK xchg D$ebx+Thread@Busy eax | sub eax eax
EndP

; EAX=hThread EDX=ThreadId ; 0=ERROR
Proc StartNewThreadForFunction::
 ARGUMENTS @ThreadBlock

    push 0
    call 'Kernel32.CreateThread', 0, 0100000, ThreadStartStub D@ThreadBlock, 0, esp
    pop edx

EndP


Proc ThreadStartStub::
 ARGUMENTS @ThreadBlock
 USES EBX ESI
DBGBP
    CLD
    mov eax 0-1
    mov ebx D@ThreadBlock | test ebx ebx | jle P9>
    call GetTimeTick | mov D$ebx+Thread@StartTick eax
    mov ecx D$ebx+Thread@ProcParamsCount | lea esi D$ebx+Thread@ProcParams
L0: sub ecx 1 | jl L0> | LODSD | push eax | jmp L0<
L0:
    lea eax D$ebx+Thread@AskToEnd
    call D$ebx+Thread@ProcAddr | mov esi eax
    mov ebx D@ThreadBlock
    call GetTimeTick | mov D$ebx+Thread@EndTick eax
    sub eax eax | LOCK xchg D$ebx+Thread@Handle eax
    call CloseHandle ;eax
    and D$ebx+Thread@Pid 0 | and D$ebx+Thread@ReporterAddr 0
    sub eax eax | LOCK xchg D$ebx+Thread@Busy eax
    mov eax esi
EndP


Proc ThreadAbort::
 ARGUMENTS @ThreadBlock
 USES EBX ESI
DBGBP
; on 1st Ask, on 2nd abort
    mov ebx D@ThreadBlock
    mov eax 0-1 | LOCK xchg D$ebx+Thread@Busy eax | cmp eax 0 | je L1>
    mov eax 1 | LOCK xchg D$ebx+Thread@AskToEnd eax | test eax eax | je P9>
    sub eax eax | LOCK xchg eax D$ebx+Thread@ReporterAddr | test eax eax | je L0>
    call eax
L0:
    sub esi esi | LOCK xchg D$ebx+Thread@Handle esi | test esi esi | je L0>
    call 'Kernel32.TerminateThread' esi 0-1
    HClose ESI
L0:
    and D$ebx+Thread@Pid 0
    call GetTimeTick | mov D$ebx+Thread@EndTick eax
L1: sub eax eax | LOCK xchg D$ebx+Thread@Busy eax
EndP


;Proc reporters:
;
;    mov eax D$JobReporterAddr | test eax eax | je P9>
;    call eax
;
;EndP


TITLE LogFile
____________________________________________________________________________________________
; will open/create LogFile & write Start time
Proc LogDumpStartTime::
 ARGUMENTS @LogStruct
 USES EBX
    mov ebx D@LogStruct
    call LogFileInit ebx | test eax eax | je P9>
    sub esp 28
    push 't:  '
    push 'Star'
    lea edx D$esp+8
    call GetCurrentTime2String edx | mov W$esp+eax+8 0A0D | add eax 10 | mov edx esp
    call LogAppendToBuffer ebx edx eax
    call LogFlushBuffer ebx
EndP
; will write End time & close LogFile
Proc LogDumpEndTime::
 ARGUMENTS @LogStruct
 USES EBX
    mov ebx D@LogStruct
    call LogFileInit ebx | test eax eax | je P9>
    sub esp 28
    push '    '
    push 'End:'
    lea edx D$esp+8
    call GetCurrentTime2String edx | mov W$esp+eax+8 0A0D | add eax 10 | mov edx esp
    call LogAppendToBuffer ebx edx eax
    call LogFileClose ebx
EndP
;
[hUser32: D$ 0 MsgBoxAadr: 0][user32dll: B$ 'USER32.DLL',0 MsgBoxA: 'MessageBoxA',0 ]
[Log@FileNamePtr 0 | Log@FileHandle 04 | Log@Buffer 08 | Log@BufferCurPos 0C ]
[LogBufferSize 0F000 ]
[LogMBoxErTe: B$ "Can't create Log file!
Try other name?",0 LogMBoxErTl: "ERROR!",0 ]
; initialize Log File & Buffer
Proc LogFileInit::
 ARGUMENTS @LogStruct
 cLocal @MsgBoxAadr
 SZLocal 16 @nam
 USES ebx esi edi
    sub esi esi
    mov ebx D@LogStruct
    cmp D$ebx+Log@FileHandle 0 | jne L9>
    mov edi D$ebx+Log@FileNamePtr | cmp edi 0 | jle E0>
L0: call FileNameAOpenCreateWriteAppend edi | mov D$ebx+Log@FileHandle eax | cmp eax 0 | je E0>
    call VAlloc LogBufferSize | mov D$ebx+Log@Buffer eax, D$ebx+Log@BufferCurPos eax | test eax eax | je E0>
L9: mov eax 1 | jmp P9>
E0:
    HClose D$ebx+Log@FileHandle | and D$ebx+Log@FileHandle 0 | test esi esi | jne L1>
    call User32LdrMsgBoxA | mov esi edx | mov D@MsgBoxAadr eax | test eax eax | je E1>
L1: call D@MsgBoxAadr D$WindowHandle LogMBoxErTe LogMBoxErTl &MB_ICONERROR__&MB_OKCANCEL
    cmp eax &IDCANCEL | je E1>
    call GetTime
    lea edi D@nam
    mov D$edi 'Log', D$edi+8 '   .', D$edi+12 'txt' | lea edx D$edi+3
    call 'BaseCodecs.D2H' edx eax
    jmp L0<<
E1: call UnloadDLL esi ; once loaded U32, it won't unload..
    sub eax eax
EndP
;
;
Proc LogAppendToFile::
 ARGUMENTS @LogStruct @pMem @Sz
 USES ebx
    mov ebx D@LogStruct
    call LogFileInit ebx | test eax eax | je P9>
    call WriteMem2FileHandle D$ebx+Log@FileHandle D@pMem D@Sz
EndP
;
;
Proc LogAppendToBuffer::
 ARGUMENTS @LogStruct @pMem @Sz
 USES EBX ESI EDI
    mov ebx D@LogStruct
    cmp D@Sz LogBufferSize | jb L0>
L2:
    call LogFlushBuffer ebx
    call LogAppendToFile ebx D@pMem D@Sz
    jmp P9>
L0:
    mov eax LogBufferSize
    add eax D$ebx+Log@Buffer | sub eax D$ebx+Log@BufferCurPos | ja L0>
    call LogFlushBuffer ebx
    mov eax LogBufferSize
L0: cmp D@Sz eax | jbe L0>
    call LogFlushBuffer ebx
L0: mov edi D$ebx+Log@BufferCurPos, esi D@pMem, ecx D@Sz | CLD | REP MOVSB
    mov D$ebx+Log@BufferCurPos edi
EndP
;
;
Proc LogFlushBuffer::
 ARGUMENTS @LogStruct
 USES ebx
    mov ebx D@LogStruct
    mov eax D$ebx+Log@BufferCurPos | sub eax D$ebx+Log@Buffer | jle L0>
    cmp eax LogBufferSize | jbe L1>
    mov eax LogBufferSize ; ? size damaged?
L1: call WriteMem2FileHandle D$ebx+Log@FileHandle D$ebx+Log@Buffer eax
L0: move D$ebx+Log@BufferCurPos D$ebx+Log@Buffer
EndP
;
;
Proc LogFileClose::
 ARGUMENTS @LogStruct
 USES EBX ESI EDI
    mov ebx D@LogStruct
    sub esi esi | sub edi edi
    lock xchg D$ebx+Log@FileHandle esi | lock xchg D$ebx+Log@Buffer edi | test esi esi | je P9>
    mov eax D$ebx+Log@BufferCurPos | sub eax edi | jbe L0>
    cmp eax LogBufferSize | jbe L1>
    mov eax LogBufferSize ; ? size damaged?
L1: call WriteMem2FileHandle esi edi eax
L0: call CloseFlushHandle esi
    call VFree edi
EndP
;
;

Proc User32LdrMsgBoxA:
 USES EDI
    sub edi edi
    call LoadDllA user32dll | test eax eax | mov edi eax | je P9>
    call GetProcAdr EDI MsgBoxA
    mov edx edi
EndP





TITLE GETFNs
____________________________________________________________________________________________

[hCOMDLG32: D$ 0, pGOPFA: 0, pGOPFW: 0, pGSFA: 0, pGSFW: 0,
 pOFileName1: D$ 0, pOFileTitle1: D$ 0, pSFileName1: D$ 0, pSFileTitle1: D$ 0 WindowHandle: 0]

[GOPFN_lStructSize 04C
 GOPFN_hWndOwner 04
 GOPFN_hInstance 08
 GOPFN_lpstrFilter 0C
 GOPFN_lpstrCustomFilter 010
 GOPFN_nMaxCustFilter 014
 GOPFN_nFilterIndex 018
 GOPFN_lpstrFile 01C
 GOPFN_nMaxFile 020
 GOPFN_lpstrFileTitle 024
 GOPFN_nMaxFileTitle 028
 GOPFN_lpstrInitialDir 02C
 GOPFN_lpstrTitle 030
 GOPFN_Flags 034
 GOPFN_nFileOffset 038
 GOPFN_nFileExtension 03A
 GOPFN_lpstrDefExt 03C
 GOPFN_lCustData 040
 GOPFN_lpfnHook 044
 GOPFN_lpTemplateName 048 ]
[COMDLG32: B$ 'COMDLG32.DLL',0,
 GOPFA: 'GetOpenFileNameA',0, GOPFW: 'GetOpenFileNameW',0 GSFA: 'GetSaveFileNameA',0, GSFW: 'GetSaveFileNameW',0 ]
[<16 gFilesFiltersA: B$ 'All'  0  '*.*'   0  0]
[gopFTitle1A: B$ 'Choose file..', 0]
[gspFTitle1A: B$ 'Choose name..', 0]

[<16 gFilesFiltersW: U$ 'All'  0  '*.*'   0  0]
[gopFTitle1W: U$ 'Choose file..', 0]
[gspFTitle1W: U$ 'Choose name..', 0]
;;
Proc ComDLG32Load:
 USES edi
    cmp D$hCOMDLG32 0 | jne G0>
    call 'KERNEL32.LoadLibraryA' COMDLG32 | test eax eax | je E0>
    mov D$hCOMDLG32 eax | mov edi 'KERNEL32.GetProcAddress'
    call EDI D$hCOMDLG32 GOPFA | mov D$pGOPFA eax
    call EDI D$hCOMDLG32 GOPFW | mov D$pGOPFW eax
    call EDI D$hCOMDLG32 GSFA | mov D$pGSFA eax
    call EDI D$hCOMDLG32 GSFW | mov D$pGSFW eax

G0: LOCK add D$cCOMDLG32 1
    mov eax 1 | jmp P9>
E0: mov eax 0
EndP

Proc ComDLG32Unload:
    LOCK sub D$cCOMDLG32 1 | ja P9>
    sub eax eax | xchg eax D$hCOMDLG32 | test eax eax | je L0>
    call 'KERNEL32.FreeLibrary' eax
L0: and D$pGOPFA 0 | and D$pGOPFW 0 | and D$pGSFA 0 | and D$pGSFW 0
EndP
;;

Proc ComDLG32LdrGOPFA:
 USES EDI
    sub edi edi
    call LoadDllA COMDLG32 | test eax eax | mov edi eax | je P9>
    call GetProcAdr EDI GOPFA
    mov edx edi
EndP

Proc ComDLG32LdrGOPFW:
 USES EDI
    sub edi edi
    call LoadDllA COMDLG32 | test eax eax | mov edi eax | je P9>
    call GetProcAdr EDI GOPFW
    mov edx edi
EndP

Proc ComDLG32LdrGSFA:
 USES EDI
    sub edi edi
    call LoadDllA COMDLG32 | test eax eax | mov edi eax | je P9>
    call GetProcAdr EDI GSFA
    mov edx edi
EndP

Proc ComDLG32LdrGSFW:
 USES EDI
    sub edi edi
    call LoadDllA COMDLG32 | test eax eax | mov edi eax | je P9>
    call GetProcAdr EDI GSFW
    mov edx edi
EndP

Proc LoadDllA:
  Arguments @pDLLname
    call 'KERNEL32.LoadLibraryA' D@pDLLname
EndP

Proc UnloadDLL:
  Arguments @hDLL
    mov eax D@hDLL | test eax eax | je P9>
    call 'KERNEL32.FreeLibrary' eax
EndP

Proc GetProcAdr:
  Arguments @hDLL @pAddrName
    call 'KERNEL32.GetProcAddress' D@hDLL D@pAddrName
EndP


;;
GetOpenFileName::
;cmp B$winver 04 | ja GetOpenFileNameWide
Proc GetOpenFileNameAnsi::
 USES EBX

    sub ebx ebx
 call ComDLG32Load | test eax eax | je L9>>
    cmp D$pOFileName1 0 | jne L0>
    call VAlloc 010000 | mov D$pOFileName1 eax | test eax eax | je L9>>
L0: cmp D$pOFileTitle1 0 | jne L0>
    call VAlloc 010000 | mov D$pOFileTitle1 eax | test eax eax | je B0>

L0: mov ecx GOPFN_lStructSize | shr ecx 2
L0: push 0 | loop L0<

    mov eax esp
    mov D$eax GOPFN_lStructSize
    move D$eax+GOPFN_hWndOwner D$WindowHandle
    mov D$eax+GOPFN_lpstrFilter gFilesFiltersA

    mov edx D$pOFileName1 | mov D$edx 0 | mov D$eax+GOPFN_lpstrFile edx
    mov D$eax+GOPFN_nMaxFile 0FFFF

    mov edx D$pOFileTitle1 | mov D$edx 0 | mov D$eax+GOPFN_lpstrFileTitle edx
    mov D$eax+GOPFN_nMaxFileTitle 0FFFF

    mov D$eax+GOPFN_Flags &OFN_FILEMUSTEXIST__&OFN_LONGNAMES__&OFN_NONETWORKBUTTON__&OFN_PATHMUSTEXIST
    mov D$eax+GOPFN_lpstrTitle gopFTitle1A
    call D$pGOPFA eax | mov ebx eax | test eax eax | jne L9>
B0:
    call VFree D$pOFileName1 | call VFree D$pOFileTitle1 | and D$pOFileName1 0 | and D$pOFileTitle1 0
L9: call ComDLG32Unload | mov eax ebx
EndP

Proc GetOpenFileNameWide::
 USES EBX

    sub ebx ebx
 call ComDLG32Load | test eax eax | je L9>>
    cmp D$pOFileName1 0 | jne L0>
    call VAlloc 010000 | mov D$pOFileName1 eax | test eax eax | je L9>>
L0: cmp D$pOFileTitle1 0 | jne L0>
    call VAlloc 010000 | mov D$pOFileTitle1 eax | test eax eax | je B0>

L0: mov ecx GOPFN_lStructSize | shr ecx 2
L0: push 0 | loop L0<

    mov eax esp
    mov D$eax GOPFN_lStructSize
    move D$eax+GOPFN_hWndOwner D$WindowHandle
    mov D$eax+GOPFN_lpstrFilter gFilesFiltersW

    mov edx D$pOFileName1 | mov W$edx 0 | mov D$eax+GOPFN_lpstrFile edx
    mov D$eax+GOPFN_nMaxFile 0FFFF

    mov edx D$pOFileTitle1 | mov W$edx 0 | mov D$eax+GOPFN_lpstrFileTitle edx
    mov D$eax+GOPFN_nMaxFileTitle 0FFFF

    mov D$eax+GOPFN_Flags &OFN_FILEMUSTEXIST__&OFN_LONGNAMES__&OFN_NONETWORKBUTTON__&OFN_PATHMUSTEXIST
    mov D$eax+GOPFN_lpstrTitle gopFTitle1W
    call D$pGOPFW eax | mov ebx eax | test eax eax | jne L9>
B0:
    call VFree D$pOFileName1 | call VFree D$pOFileTitle1 | and D$pOFileName1 0 | and D$pOFileTitle1 0
L9: call ComDLG32Unload | mov eax ebx
EndP


GetSaveFileName::
;cmp B$winver 04 | ja GetSaveFileNameWide
Proc GetSaveFileNameAnsi::
 USES EBX

    sub ebx ebx
 call ComDLG32Load | test eax eax | je L9>>
    cmp D$pSFileName1 0 | jne L0>
    call VAlloc 010000 | mov D$pSFileName1 eax | test eax eax | je L9>>
L0: cmp D$pSFileTitle1 0 | jne L0>
    call VAlloc 010000 | mov D$pSFileTitle1 eax | test eax eax | je B0>

L0: mov ecx GOPFN_lStructSize | shr ecx 2
L0: push 0 | loop L0<

    mov eax esp
    mov D$eax GOPFN_lStructSize
    move D$eax+GOPFN_hWndOwner D$WindowHandle
    mov D$eax+GOPFN_lpstrFilter gFilesFiltersA

    mov edx D$pSFileName1 | and D$edx 0 | mov D$eax+GOPFN_lpstrFile edx
    mov D$eax+GOPFN_nMaxFile 0FFFF

    mov edx D$pSFileTitle1 | and D$edx 0 | mov D$eax+GOPFN_lpstrFileTitle edx
    mov D$eax+GOPFN_nMaxFileTitle 0FFFF

    mov D$eax+GOPFN_Flags &OFN_LONGNAMES__&OFN_NONETWORKBUTTON__&OFN_PATHMUSTEXIST
    mov D$eax+GOPFN_lpstrTitle gspFTitle1A
    call D$pGSFA eax | mov ebx eax | test eax eax | jne L9>
B0:
    call VFree D$pSFileName1 | call VFree D$pSFileTitle1 | and D$pSFileName1 0 | and D$pSFileTitle1 0
L9: call ComDLG32Unload | mov eax ebx
EndP

Proc GetSaveFileNameWide::
 USES EBX

    sub ebx ebx
 call ComDLG32Load | test eax eax | je L9>>
    cmp D$pSFileName1 0 | jne L0>
    call VAlloc 010000 | mov D$pSFileName1 eax | test eax eax | je L9>>
L0: cmp D$pSFileTitle1 0 | jne L0>
    call VAlloc 010000 | mov D$pSFileTitle1 eax | test eax eax | je B0>

L0: mov ecx GOPFN_lStructSize | shr ecx 2
L0: push 0 | loop L0<

    mov eax esp
    mov D$eax GOPFN_lStructSize
    move D$eax+GOPFN_hWndOwner D$WindowHandle
    mov D$eax+GOPFN_lpstrFilter gFilesFiltersW

    mov edx D$pSFileName1 | and D$edx 0 | mov D$eax+GOPFN_lpstrFile edx
    mov D$eax+GOPFN_nMaxFile 0FFFF

    mov edx D$pSFileTitle1 | and D$edx 0 | mov D$eax+GOPFN_lpstrFileTitle edx
    mov D$eax+GOPFN_nMaxFileTitle 0FFFF

    mov D$eax+GOPFN_Flags &OFN_LONGNAMES__&OFN_NONETWORKBUTTON__&OFN_PATHMUSTEXIST
    mov D$eax+GOPFN_lpstrTitle gspFTitle1W
    call D$pGSFW eax | mov ebx eax | test eax eax | jne L9>
B0:
    call VFree D$pSFileName1 | call VFree D$pSFileTitle1 | and D$pSFileName1 0 | and D$pSFileTitle1 0
L9: call ComDLG32Unload | mov eax ebx
EndP
;;



;returns EAX=pFileNameA EDX=pFileTitleA ; onError EAX=NULL
Proc ChooseFileByNameAnsi::
 Arguments @ParentWindowHandle
 cLocal @pFileNameA @pFileTitleA
 USES ESI EDI

    call ComDLG32LdrGOPFA | test eax eax | je P9>>
    mov esi eax, edi edx
    call VAlloc 010000 | mov D@pFileNameA eax | test eax eax | je B0>
    call VAlloc 010000 | mov D@pFileTitleA eax | test eax eax | je B0>

L0: mov ecx GOPFN_lStructSize | shr ecx 2
L0: push 0 | loop L0<

    mov eax esp
    mov D$eax GOPFN_lStructSize
    move D$eax+GOPFN_hWndOwner D@ParentWindowHandle
    mov D$eax+GOPFN_lpstrFilter gFilesFiltersA

    mov edx D@pFileNameA | and D$edx 0 | mov D$eax+GOPFN_lpstrFile edx
    mov D$eax+GOPFN_nMaxFile 0FFFF

    mov edx D@pFileTitleA | and D$edx 0 | mov D$eax+GOPFN_lpstrFileTitle edx
    mov D$eax+GOPFN_nMaxFileTitle 0FFFF

    mov D$eax+GOPFN_Flags &OFN_FILEMUSTEXIST__&OFN_LONGNAMES__&OFN_NONETWORKBUTTON__&OFN_PATHMUSTEXIST
    mov D$eax+GOPFN_lpstrTitle gopFTitle1A
    call esi eax | test eax eax | je B0>
    call UnloadDLL EDI
    mov eax D@pFileNameA | mov edx D@pFileTitleA | jmp P9>
B0:
    call UnloadDLL EDI
    call VFree D@pFileNameA | call VFree D@pFileTitleA
    sub eax eax
EndP


;returns EAX=pFileNameW EDX=pFileTitleW ; onError EAX=NULL
Proc ChooseFileByNameWide::
 Arguments @ParentWindowHandle
 cLocal @pFileNameW @pFileTitleW
 USES ESI EDI

    call ComDLG32LdrGOPFW | test eax eax | je P9>>
    mov esi eax, edi edx
    call VAlloc 010000 | mov D@pFileNameW eax | test eax eax | je B0>
    call VAlloc 010000 | mov D@pFileTitleW eax | test eax eax | je B0>

L0: mov ecx GOPFN_lStructSize | shr ecx 2
L0: push 0 | loop L0<

    mov eax esp
    mov D$eax GOPFN_lStructSize
    move D$eax+GOPFN_hWndOwner D@ParentWindowHandle
    mov D$eax+GOPFN_lpstrFilter gFilesFiltersW

    mov edx D@pFileNameW | and D$edx 0 | mov D$eax+GOPFN_lpstrFile edx
    mov D$eax+GOPFN_nMaxFile 0FFFF

    mov edx D@pFileTitleW | and D$edx 0 | mov D$eax+GOPFN_lpstrFileTitle edx
    mov D$eax+GOPFN_nMaxFileTitle 0FFFF

    mov D$eax+GOPFN_Flags &OFN_FILEMUSTEXIST__&OFN_LONGNAMES__&OFN_NONETWORKBUTTON__&OFN_PATHMUSTEXIST
    mov D$eax+GOPFN_lpstrTitle gopFTitle1W
    call esi eax | test eax eax | je B0>
    call UnloadDLL EDI
    mov eax D@pFileNameW | mov edx D@pFileTitleW | jmp P9>
B0:
    call UnloadDLL EDI
    call VFree D@pFileNameW | call VFree D@pFileTitleW
    sub eax eax
EndP


;returns EAX=pFileNameA EDX=pFileTitleA ; onError EAX=NULL
Proc ChooseFileNameAnsi::
 Arguments @ParentWindowHandle
 cLocal @pFileNameA @pFileTitleA
 USES ESI EDI

    call ComDLG32LdrGSFA | test eax eax | je P9>>
    mov esi eax, edi edx
    call VAlloc 010000 | mov D@pFileNameA eax | test eax eax | je B0>
    call VAlloc 010000 | mov D@pFileTitleA eax | test eax eax | je B0>

L0: mov ecx GOPFN_lStructSize | shr ecx 2
L0: push 0 | loop L0<

    mov eax esp
    mov D$eax GOPFN_lStructSize
    move D$eax+GOPFN_hWndOwner D@ParentWindowHandle
    mov D$eax+GOPFN_lpstrFilter gFilesFiltersA

    mov edx D@pFileNameA | and D$edx 0 | mov D$eax+GOPFN_lpstrFile edx
    mov D$eax+GOPFN_nMaxFile 0FFFF

    mov edx D@pFileTitleA | and D$edx 0 | mov D$eax+GOPFN_lpstrFileTitle edx
    mov D$eax+GOPFN_nMaxFileTitle 0FFFF

    mov D$eax+GOPFN_Flags &OFN_LONGNAMES__&OFN_NONETWORKBUTTON__&OFN_PATHMUSTEXIST
    mov D$eax+GOPFN_lpstrTitle gspFTitle1A
    call esi eax | test eax eax | je B0>
    call UnloadDLL EDI
    mov eax D@pFileNameA | mov edx D@pFileTitleA | jmp P9>
B0:
    call UnloadDLL EDI
    call VFree D@pFileNameA | call VFree D@pFileTitleA
    sub eax eax
EndP


;returns EAX=pFileNameA EDX=pFileTitleA ; onError EAX=NULL
Proc ChooseFileNameWide::
 Arguments @ParentWindowHandle
 cLocal @pFileNameW @pFileTitleW
 USES ESI EDI

    call ComDLG32LdrGSFW | test eax eax | je P9>>
    mov esi eax, edi edx
    call VAlloc 010000 | mov D@pFileNameW eax | test eax eax | je B0>
    call VAlloc 010000 | mov D@pFileTitleW eax | test eax eax | je B0>

L0: mov ecx GOPFN_lStructSize | shr ecx 2
L0: push 0 | loop L0<

    mov eax esp
    mov D$eax GOPFN_lStructSize
    move D$eax+GOPFN_hWndOwner D@ParentWindowHandle
    mov D$eax+GOPFN_lpstrFilter gFilesFiltersW

    mov edx D@pFileNameW | and D$edx 0 | mov D$eax+GOPFN_lpstrFile edx
    mov D$eax+GOPFN_nMaxFile 0FFFF

    mov edx D@pFileTitleW | and D$edx 0 | mov D$eax+GOPFN_lpstrFileTitle edx
    mov D$eax+GOPFN_nMaxFileTitle 0FFFF

    mov D$eax+GOPFN_Flags &OFN_LONGNAMES__&OFN_NONETWORKBUTTON__&OFN_PATHMUSTEXIST
    mov D$eax+GOPFN_lpstrTitle gspFTitle1W
    call esi eax | test eax eax | je B0>
    call UnloadDLL EDI
    mov eax D@pFileNameW | mov edx D@pFileTitleW | jmp P9>
B0:
    call UnloadDLL EDI
    call VFree D@pFileNameW | call VFree D@pFileTitleW
    sub eax eax
EndP


;returns EAX=pMemory EDX=Size ; onError EAX=NULL
Proc ChooseAndLoadFileByNameAnsi::
 Arguments @ParentWindowHandle
 cLocal @pFileNameA
 USES ESI EDI

    sub esi esi | sub edi edi
    call ChooseFileByNameAnsi D@ParentWindowHandle
    test eax eax | je P9> |  mov D@pFileNameA eax
    call VFree EDX
    call LoadFileNameA2Mem D@pFileNameA
    mov esi eax | mov edi edx
    call VFree D@pFileNameA
    mov eax esi | mov edx edi
EndP

;returns EAX=BytesWritten ; onError EAX=NULL
Proc ChooseAndSaveToFileNameAnsi::
 Arguments @ParentWindowHandle @pMem @sz
 cLocal @pFileNameA
 USES ESI

    sub esi esi
    call ChooseFileNameAnsi D@ParentWindowHandle
    test eax eax | je P9> |  mov D@pFileNameA eax
    call VFree EDX
    call WriteMem2FileNameA D@pFileNameA D@pMem D@sz
    mov esi eax
    call VFree D@pFileNameA
    mov eax esi
EndP

;returns EAX=pMemory EDX=Size ; onError EAX=NULL
Proc ChooseAndLoadFileByNameWide::
 Arguments @ParentWindowHandle
 cLocal @pFileNameW
 USES ESI EDI

    sub esi esi | sub edi edi
    call ChooseFileByNameWide D@ParentWindowHandle
    test eax eax | je P9> |  mov D@pFileNameW eax
    call VFree EDX
    call LoadFileNameW2Mem D@pFileNameW
    mov esi eax | mov edi edx
    call VFree D@pFileNameW
    mov eax esi | mov edx edi
EndP

;returns EAX=BytesWritten ; onError EAX=NULL
Proc ChooseAndSaveToFileNameWide::
 Arguments @ParentWindowHandle @pMem @sz
 cLocal @pFileNameW
 USES ESI

    sub esi esi
    call ChooseFileNameWide D@ParentWindowHandle
    test eax eax | je P9> |  mov D@pFileNameW eax
    call VFree EDX
    call WriteMem2FileNameW D@pFileNameW D@pMem D@sz
    mov esi eax
    call VFree D@pFileNameW
    mov eax esi
EndP


