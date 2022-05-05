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
_____________________________________________________________________________________________

[Align_on | add #2 #1-1 | and #2 0-#1][Align_UP | and #2 0-#1 | add #2 #1 ]
;[DBGBP | nope]
[DBGBP | cmp B$isDBG 0 | DB 074 01 0CC ] [isDBG: D$ 0]
[CRLF 0A0D]


TITLE NThread


[ updateBitSize | mov edx #1 | mov eax #2
    call 'AnyBits.GetEffectiveHighBitSz32' | mov #2 eax ]
;[ updateByteSize | mov edx #1 | mov eax #2 | shl eax 3
;    call 'AnyBits.GetEffectiveHighBitSz32' | shr eax 3 | mov #2 eax ]

;[ERR_memalloc: B$ "Can't allocate Memory",0]
Proc THREADMain:
 USES EBX ESI EDI
;int3
[<16 dm: D$ 0 #010][trd1stack: D$ 0][trd1ebp: D$ 0]
[<16 JobThreadBlock:
 JobThreadBusy: D$ 0 JobProcAddr: 0 JobReporterAddr: 0 JobThreadhandle: 0 JobThreadPid: 0
 JobAskToEnd: 0 JobStartTick: 0 JobEndTick: 0 JobProcParamsCount: 0
 JobProcParams: 0 #32]
[writechunk 1000000]
[mem1: 0][curDword: D$ 0, divizor: 0][curQword: Q$ 0][AnyBitNum: D$ 0 AnyBitNumSz: 0 SieveMem: 0 SieveMemSz: 0 SieveBaseLowDword: 0 ][curTick: D$ 0][RDTSC1: D$ 0,0]
[szB32P: 0, mB32P: 0][B32Psize 203280220]
[B32primes: B$ 'BIT32PRIMES_01',0][start64BitPrime: B$ 'BIT64PrimeStarterQword',0][<16 mname: B$ 0 #40 ]

nop | DBGBP
 mov D$JobReporterAddr report64b
    mov D$trd1stack esp,  D$trd1ebp ebp
    cmp D$mB32P 0 | jne L0>
    call TryLoadB32primesFile | test eax eax | jne L1>

    call MakeB32primesFile | test eax eax | je EndThread

    call TryLoadB32primesFile | test eax eax | je EndThread
L1:
    mov D$mB32P eax, D$szB32P edx
L0:
    call 'BaseRTL.VAlloc' writechunk | test eax eax | je EndThread
    mov D$mem1 eax
;jmp L1>
    call 'BaseRTL.LoadFileNameA2Mem' start64BitPrime
    test eax eax | je L1> | cmp edx 8 | je L0> | call 'BaseRTL.VFree' eax | jmp L1>
L0:
    mov ebx D$eax, ebp D$eax+4 | call 'BaseRTL.VFree' eax
    call 'BaseCodecs.Q2H' mname, ebx, ebp | mov B$mname+16 0
    call 'BaseRTL.LoadFileNameA2Mem' mname | test eax eax | jne L0>
L1:
    mov ebx 0FFFFFFFB, ebp 0 ;  last 32bit Prime
    call 'BaseCodecs.Q2H' mname, ebx, ebp | mov B$mname+16 0
    call 'BaseRTL.LoadFileNameA2Mem' mname | test eax eax | je L1>
;loop next-files
L0:
    mov edi eax, esi edx
; call ConvertOldPrimeFromDiffArray eax eax edx | call WriteMem2FileNameA start64BitPrime edi esi | int 3
    call 'NUMERIKO.ExtractLastPrimeFromDiffArray' edi esi ebx ebp ;0FFFFFFF5 02 ;
L0:
    mov ebx eax, ebp edx
    call 'BaseRTL.VFree' edi
    call 'BaseCodecs.Q2H' mname, ebx, ebp | mov B$mname+16 0
    call 'BaseRTL.LoadFileNameA2Mem' mname | test eax eax | je L0>
    mov edi eax, esi edx
; call ConvertOldPrimeFromDiffArray edi edi esi | call WriteMem2FileNameA mname edi esi ; | int 3
    call 'NUMERIKO.ExtractLastPrimeFromDiffArray' edi esi ebx ebp
    jmp L0<
L1:
;int3
    mov ebx 0FFFFFFFB, ebp 0 ;  last 32bit Prime
;last 64bit Prime = 0FFFFFFFF_FFFFFFC5 ; 013BAE5F80 rdtsc ;
;mov ebx 0FFFFFEFF, ebp 0FFFFFFFF
;mov ebx 01D4F05, ebp 0-1
;mov ebx D$curQword, ebp D$curQword+4

L0:
    call 'KERNEL32.GetTickCount' | mov D$curTick eax

    sub esi esi | sub edi edi

LoopNumeriko64:
cmp D$JobAskToEnd 1 | je EndThread
    cmp esi ebx | jne L1> | cmp edi ebp | je E1>>
L1:
    mov esi ebx, edi ebp
;RDTSC | mov D$RDTSC1 eax, D$RDTSC1+4 edx

    call 'NUMERIKO.Numeriko64' D$mB32P, D$mem1, ebx, ebp, writechunk ;
    cmp ecx 0 | jne L0> | cmp ebp 0-1 | je E1>>
    call 'NUMERIKO.FindNextPrimeQword' ebx ebp | test eax eax | je E1>>
    mov D$curQword eax, D$curQword+4 edx
    sub eax ebx | shr eax 1 | mov edx D$mem1 | mov B$edx al | inc edx
    call 'NUMERIKO.Numeriko64' D$mB32P, edx, D$curQword, D$curQword+4, writechunk-1
    cmp ecx 0 | lea ecx D$ecx+1 | je E1>
L0:
    mov ebx eax, ebp edx | mov D$curQword eax, D$curQword+4 edx

;RDTSC | sub eax D$RDTSC1 | sbb edx D$RDTSC1+4 | mov D$RDTSC1 eax, D$RDTSC1+4 edx
    call report64

    push ecx
    call 'BaseCodecs.Q2H' mname esi edi | mov B$mname+16 0
;call D2H mname+17 D$RDTSC1+4 | call D2H mname+25 D$RDTSC1 | mov B$mname+16 '.' | mov B$mname+33 0
    pop ecx

    call 'BaseRTL.WriteMem2FileNameA' mname, D$mem1, ecx
jmp LoopNumeriko64


E1:
EndThread:
    mov ebp D$trd1ebp
    call 'BaseRTL.VFree' D$mem1 | and D$mem1 0
;    call 'Kernel32.CloseHandle', D$dm+010 | and D$dm+010 0 | and D$trd1stack 0
    ;call 'User32.SendMessageA', D$WindowHandle, &WM_TIMER, 0, 0
;call 'Kernel32.ExitThread', 0
EndP
INT3|INT3|INT3|INT3
____________________________________________________________________________________________

Proc MakeB32primesFile:
 cLocal @return @hB32P @mem0 @mem1
 USES EBX ESI EDI

;mov D@return 0
call 'BaseRTL.FileNameACreateWrite' B32primes &FALSE | test eax eax | mov D@hB32P eax | je P9>>

call 'BaseRTL.VAlloc' writechunk | test eax eax | mov D@mem0 eax | je E1>>
call 'BaseRTL.VAlloc' writechunk | test eax eax | mov D@mem1 eax | je E1>>

call 'KERNEL32.GetTickCount' | mov D$curTick eax
call 'NUMERIKO.Numeriko16' D@mem0 | mov esi eax | mov ebx writechunk | sub ebx edx | mov eax D@mem0 | add eax edx
call 'NUMERIKO.Numeriko32' D@mem0, eax, esi, ebx | mov ebx eax | mov D$curDword ebx
call report
call 'BaseCodecs.Q2H' mname, 0, 0 | mov B$mname+16 0
call 'BaseRTL.WriteMem2FileHandle' D@hB32P, D@mem0, writechunk


;call GetCPUspeed
call 'KERNEL32.GetTickCount' | mov D$curTick eax
;int3
;mov esi 0FFA110A9

;
sub esi esi

L0:
cmp ebx esi | je E0>
;call 'KERNEL32.GetTickCount' | mov ebp eax
mov esi ebx
call 'NUMERIKO.Numeriko32' D@mem0, D@mem1, esi, writechunk
mov ebx eax, edi edx | mov D$curDword ebx
call report
call 'BaseCodecs.Q2H' mname, esi, 0 | mov B$mname+16 0
call 'BaseRTL.WriteMem2FileHandle' D@hB32P, D@mem1, edi
jmp L0<
;

E0:
mov D@return 1
E1:
call 'BaseRTL.CloseFlushHandle' D@hB32P | and D@hB32P 0
call 'BaseRTL.VFree' D@mem0 | and D@mem0 0
call 'BaseRTL.VFree' D@mem1 | and D@mem1 0

mov eax D@return
EndP
;
;
;
;
Proc TryLoadB32primesFile:
 Local @return @mB32P @szB32P
; USES EBX ESI EDI

    and D@mB32P 0 | and D@szB32P 0
    call 'BaseRTL.LoadFileNameA2Mem' B32primes | test eax eax | je L9>
;JOB64:
    mov D@mB32P eax, D@szB32P edx
;JOB64a:
    cmp D@szB32P B32Psize | jne E2>
    call 'NUMERIKO.ExtractLastPrimeFromDiffArray' D@mB32P D@szB32P 1 0 | sub eax 0-5 | sbb edx 0 | or eax edx | je L0>
E2: call 'BaseRTL.VFree' D@mB32P | and D@mB32P 0 | and D@szB32P 0 | jmp L9>
L0: call 'NUMERIKO.FindNextPrimeQword' 0-5 0 | sub eax 0-5 | sbb edx 0 | shr eax 1
    mov edx D@mB32P | add edx D@szB32P | mov B$edx al
L9: mov eax D@mB32P, edx D@szB32P

EndP





report64a:
pushad
cmp D$WindowHandle 0 | je L0>
mov edi WndSizeTitle | call Qword2Decimal edi, D$curQword, D$curQword+4 | add edi eax
call 'User32.SendMessageA', D$WindowHandle, &WM_SETTEXT, 0, WndSizeTitle
L0: popad | ret

report64:
pushad
cmp D$WindowHandle 0 | je L0>
call 'KERNEL32.GetTickCount' | mov ebx eax | sub ebx D$curTick | mov D$curTick eax
mov edi WndSizeTitle | call 'BaseCodecs.pQword2HexA' edi curQword | add edi eax
mov B$edi 020 | inc edi | call DW2Decimal edi ebx | add edi eax | mov D$edi 'ms'
call 'User32.SendMessageA', D$WindowHandle, &WM_SETTEXT, 0, WndSizeTitle
L0: popad | ret

report64b:
[ MsgsendingTick: 0]
pushad
call 'KERNEL32.GetTickCount' | mov edx eax | sub edx D$MsgsendingTick | cmp edx 40 | jl L0>
mov D$MsgsendingTick eax
cmp D$WindowHandle 0 | je L0>
cmp D$JobThreadhandle 0 | je L0>
mov ebx D$trd1stack | cmp ebx 0 | je L0>
[ts@pTfirst 0-014 ts@pTnext 0-010 ts@startNLo 0-0C ts@startNHi 0-8 ts@scount 0-4 ]
mov eax D$ebx+ts@startNLo, edx D$ebx+ts@startNHi, esi D$ebx+ts@scount
mov edi WndSizeTitle
call 'BaseCodecs.Q2H' edi, eax, edx | add edi eax
mov B$edi 020 | inc edi | call DW2Decimal edi esi | add edi eax | mov B$edi 0
call 'User32.SendMessageA', D$WindowHandle, &WM_SETTEXT, 0, WndSizeTitle
L0: popad | ret

report:
pushad
cmp D$WindowHandle 0 | je L0>
call 'KERNEL32.GetTickCount' | mov ebx eax | sub ebx D$curTick | mov D$curTick eax
mov edi WndSizeTitle | call 'BaseCodecs.D2H' edi, D$curDword | add edi eax
mov B$edi 020 | inc edi | call DW2Decimal edi ebx | add edi eax | mov D$edi 'ms'
call 'User32.SendMessageA', D$WindowHandle, &WM_SETTEXT, 0, WndSizeTitle
L0: popad | ret


SetEditWndNum:
pushad
call Qword2Decimal WndSizeTitle D$curQword D$curQword+4 | mov edx WndSizeTitle | mov B$eax+edx 0
call 'User32.SendMessageA', D$EDIT0_handle, &WM_SETTEXT, 0, WndSizeTitle
popad
ret


overByte:
pushad | call 'BaseCodecs.D2H' mname, eax | mov B$mname+8 0
call 'USER32.MessageBoxA', 0, "Byte-overflow!", mname, 030 | popad
jmp EndThread | INT3

;;
call LoadFileNameA2Mem {'00000001FFFFFFF7',0};
test eax eax | je L0>
mov edi eax, esi edx
call ExtractPrimeFromDiffArray edi esi 0FFFFFFF7 01
mov ebx eax, ebp edx
call 'BaseRTL.VFree' edi
L0: ret
;;


TITLE threads2
____________________________________________________________________________________________

Proc StartFunctionThread:
 Arguments @ThreadProc @ThreadArg
DBGBP
    move D$JobProcAddr D@ThreadProc, D$JobProcParams D@ThreadArg
;    mov D$JobReporterAddr report6
    mov D$JobProcParamsCount 0
    mov eax D@ThreadArg | test eax eax | je L0>
    mov D$JobProcParamsCount 1, D$JobProcParams eax
L0:
    call 'BaseRTL.TryStartFunctionInNewThread' JobThreadBlock
EndP
;
;
closeThread:
pushad
    sub eax eax | xchg eax D$TimerId | test eax eax | je L0>
    call 'User32.KillTimer', D$WindowHandle, eax
L0:
    call reporters
    call 'BaseRTL.ThreadAbort' JobThreadBlock
;    cmp D$JobThreadBusy 0 | je L0>
;    call 'KERNEL32.Sleep' 1000
;    call 'BaseRTL.ThreadAbort' JobThreadBlock
L0:
popad
ret



Proc THREAD1Qword:
 USES EDI
DBGBP
    mov D$JobReporterAddr 0
    call 'KERNEL32.GetTickCount' | mov D$curTick eax
;RDTSC | push edx, eax
    and D$divizor 0
    call 'NUMERIKO.IsQwordPrime' D$curQword D$curQword+4 | test eax eax | jne L0>
    mov D$curQword 0, D$curQword+4 0, D$divizor ecx
    CLD | mov edi WndSizeTitle
    mov eax 'Divi' | STOSD | mov eax 'sor ' | STOSD
    call DW2Decimal edi D$divizor | add edi eax | mov al 0 | STOSB
    call 'User32.SendMessageA', D$WindowHandle, &WM_SETTEXT, 0, WndSizeTitle
jmp P9>
L0: ;RDTSC | pop ecx | sub eax ecx | pop ecx | sbb edx ecx | DBGBP
    ;call Qword2Decimal WndSizeTitle D$curQword D$curQword+4
    call report64
    ;call SetEditWndNum
EndP

INT 3

Proc THREAD1NextPQword:
DBGBP
    call 'KERNEL32.GetTickCount' | mov D$curTick eax
;RDTSC | push edx, eax
    call 'NUMERIKO.FindNextPrimeQword' D$curQword D$curQword+4 | mov D$curQword eax, D$curQword+4 edx
;RDTSC | pop ecx | sub eax ecx | pop ecx | sbb edx ecx | DBGBP
    call report64
    call SetEditWndNum
EndP

INT 3

Proc THREAD1PrevPQword:
DBGBP
    call 'KERNEL32.GetTickCount' | mov D$curTick eax
;RDTSC | push edx, eax
    call 'NUMERIKO.FindPrevPrimeQword' D$curQword D$curQword+4 | mov D$curQword eax, D$curQword+4 edx
;RDTSC | pop ecx | sub eax ecx | pop ecx | sbb edx ecx | DBGBP
    call report64
    call SetEditWndNum
EndP

INT 3

Proc THREAD1AnyBitNumPRP:
DBGBP
    call 'KERNEL32.GetTickCount' | mov D$curTick eax

    mov eax D$AnyBitNum | test eax eax | je L2>
    test D$eax 1 | je L0> ; even ?

    call PRPtests D$AnyBitNum D$AnyBitNumSz
    mov edx D$AnyBitNum | move D$curQword D$edx, D$curQword+4 D$edx+4 | call report64
    cmp eax 0-1 | je L2> | cmp eax 0 | je L0>

    call 'User32.MessageBoxA' D$WindowHandle "Is Probably prime!" "Fermat LT PRP test:" &MB_ICONINFORMATION | jmp P9>
L0:
    call 'User32.MessageBoxA' D$WindowHandle "Not a prime." "Fermat LT PRP test:" &MB_ICONINFORMATION | jmp P9>
L2:
    call PRPcalcError
EndP

Proc THREAD1AnyBitNumPRPprev:
DBGBP
    call 'KERNEL32.GetTickCount' | mov D$curTick eax

    mov eax D$AnyBitNum | test eax eax | je L2>>
    test D$eax 1 | jne L0> ; even ?
    or D$eax 1
L0:
    call makeLittleSieve
L0:
    call 'AnyBits.AnyBitsSubstractSelf32Bit' D$AnyBitNum D$AnyBitNumSz 2 | test eax eax | je L2> | test edx edx | jne L2>
    mov eax D$AnyBitNum, eax D$eax
    call 'Numeriko.IsNumberNonPrimeInLittleSieve' D$SieveMem D$SieveMemSz D$SieveBaseLowDword eax | test eax eax | jne L0<
    call PRPtests D$AnyBitNum D$AnyBitNumSz | cmp eax 0-1 | je L2> | cmp eax 0 | je L0<
    mov edx D$AnyBitNum | move D$curQword D$edx, D$curQword+4 D$edx+4 | call report64
    jmp P9>
L2:
    call PRPcalcError
EndP

Proc THREAD1AnyBitNumPRPnext:
DBGBP
    call 'KERNEL32.GetTickCount' | mov D$curTick eax

    mov eax D$AnyBitNum | test eax eax | je L2>>
    test D$eax 1 | jne L0> ; even ?
    call 'AnyBits.AnyBitsSubstractSelf32Bit' D$AnyBitNum D$AnyBitNumSz 1 | test eax eax | je L2>> | test edx edx | jne L2>
L0:
    call makeLittleSieve
L0:
    call 'AnyBits.AnyBitsAdditionSelf32Bit' D$AnyBitNum D$AnyBitNumSz 2 | test eax eax | je L2> | test edx edx | jne L2>
    mov eax D$AnyBitNum, eax D$eax
    call 'Numeriko.IsNumberNonPrimeInLittleSieve' D$SieveMem D$SieveMemSz D$SieveBaseLowDword eax | test eax eax | jne L0<
    call PRPtests D$AnyBitNum D$AnyBitNumSz | cmp eax 0-1 | je L2> | cmp eax 0 | je L0<
    mov edx D$AnyBitNum | move D$curQword D$edx, D$curQword+4 D$edx+4 | call report64
    jmp P9>
L2:
    call PRPcalcError
EndP


Proc PRPtests:
 ARGUMENTS @AnyBitNum @AnyBitNumSz
    call 'AnyBits.FermatLittleTheoremBase2PRPTest'     D@AnyBitNum D@AnyBitNumSz   | cmp eax 1 | jne P9>
    call 'AnyBits.FermatLittleTheoremBase32bitPRPTest' D@AnyBitNum D@AnyBitNumSz 3 | cmp eax 1 | jne P9>
    call 'AnyBits.FermatLittleTheoremBase32bitPRPTest' D@AnyBitNum D@AnyBitNumSz 5 | cmp eax 1 | jne P9>
EndP


Proc makeLittleSieve:
    cmp D$SieveMem 0 | jne P9>>
    mov eax D$AnyBitNum | or D$eax 1
    call 'BaseRTL.VAlloc' 01000 | mov D$SieveMem eax | mov D$SieveMemSz (01000*8)
    call 'AnyBits.AnyBitsSubstractSelf32Bit' D$AnyBitNum D$AnyBitNumSz (01000*4) | test eax eax | je P9> | test edx edx | jne P9>
    mov eax D$AnyBitNum | and D$eax 0-2 | move D$SieveBaseLowDword D$eax
    call 'Numeriko.Bit16PrimesSieveRangeFromAnyBitNumber' D$SieveMem D$SieveMemSz D$AnyBitNum D$AnyBitNumSz
    mov eax D$AnyBitNum | or D$eax 1
    call 'AnyBits.AnyBitsAdditionSelf32Bit' D$AnyBitNum D$AnyBitNumSz (01000*4) ;| test eax eax | je P9>
EndP


INT3
Proc reporters:

    mov eax D$JobReporterAddr | test eax eax | je P9>
    call eax

EndP

PRPcalcError:
    call 'User32.MessageBoxA' D$WindowHandle "FLT PRP calculation Error!" "Fermat LT PRP test:" &MB_ICONWARNING
    RET

ALIGN 4
DD 0CCCCCCCC







TITLE toolproc
___________________________________________________________________________________________

Align 16

Proc TranslateDecimal:
 ARGUMENTS @pDecimalString
 USES ebx esi

    mov esi D@pDecimalString
    mov eax 0, edx 0, ecx 0

L2: mov cl B$esi | inc esi                        ; (eax used for result > no lodsb)
    cmp cl 0 | je  L9>

      mov edx 10 | mul edx | jo L3>               ; loaded part * 10
                                                  ; Overflow >>> Qword
        sub  ecx '0' ;| jc L7>
        cmp  ecx 9   | ja L7>

          add  eax ecx | jnc  L2<
            jmp  L4>                              ; carry >>> Qword

                                                  ; if greater than 0FFFF_FFFF:
L3: sub ecx '0' ;| jc L7>
    cmp ecx 9   | ja L7>

      add eax ecx

L4:   adc edx 0 | jc L6>                          ; also Qword overflow
      mov cl B$esi | inc  esi
      cmp cl 0 | je L9>

        mov ebx eax, eax edx, edx 10 | mul edx    ; high part * 10
          jo L6>                                  ; Qword overflow
            xchg eax ebx | mov edx 10 | mul edx   ; low part * 10
            add  edx ebx
            jnc   L3<                             ; carry >>> overflow
L6:
L7: mov eax 0, edx 0
L9:                                            ; >>> number in EDX:EAX
EndP





Proc Qword2Decimal: ;ritern sLen
 ARGUMENTS @pDecimalString @loN @hiN
 USES EBX ESI EDI

    mov eax D@loN, edx D@hiN, ecx 10, edi D@pDecimalString


; double division
L0:
   cmp edx ecx | jb L1>
   mov ebx eax, eax edx
   sub edx edx | div ecx | mov esi eax
   mov eax ebx | div ecx | or dl 030 | mov B$edi dl | inc edi | mov edx esi
   jmp L0<

L1:
   div ecx | or dl 030 | mov B$edi dl | inc edi | sub edx edx
   test eax eax | jne L1<

    mov ecx D@pDecimalString | sub edi ecx | lea edx D$ecx+edi-1
L0: cmp ecx edx | jae L0>
    mov al B$ecx, ah B$edx, B$ecx ah, B$edx al | inc ecx | dec edx | jmp L0<
L0: mov eax edi
EndP


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


[HClose | mov eax #1 | call 'BaseRTL.CloseHandle']
HClose eax
    INT 3 | ALIGN 16

TITLE WINDOW
___________________________________________________________________________________________

; Data:

; For "GetMessage":
;;
[FirstMessage:
MSG.HWND: D$ 0
MSG.WMSG: 0
MSG.wPAR: 0
MSG.lPAR: 0
MSG.time: 0
MSG.Mx: 0
MSG.My: 0
]
;;
; Window Class Structure:

[WindowClass:
 style: &CS_VREDRAW__&CS_HREDRAW
 lpfnWndProc: MainWindowProc
 cbClsExtra: 0
 cbWndExtra: 0
 hInstance: 0
 hIcon: 0
 hCursor: 0
 hbrBackground: &COLOR_BACKGROUND
 lpszMenuName: 0
 lpszClassName: WindowClassName]

[WindowHandle: 0   MenuHandle: 0]

[WindowClassName: B$ 'Application' 0    WindowCaption: 'Numeriko' 0][tWait: B$ 'Wait..',0][tErrN: B$ 'Bad Input!',0][AnyBitsLoaded: B$ 'AnyBits_Number_Loaded',0]
[LastQwordPrime: B$ '18446744073709551557' 0];18446744073709551615
[WindowX: D$ 0  WindowY: 0  WindowW: 400  WindowH: 250]

___________________________________________________________________________________________
[winver: 0]
[startsize 0100]
[TimerId: 0][time1: D$0]
[WndSizeTitle: B$ 0 #80]
Main:
    call 'Kernel32.GetModuleHandleA' 0 | mov D$hInstance eax
    call 'Kernel32.GetVersion' | mov D$winver eax
    call setStartTime
    call 'Kernel32.IsDebuggerPresent' | mov D$isDBG eax
;push 02CBDD, 0;80000000 |
;L0:
;add D$esp 080000000 | adc D$esp+4 0
;mov eax esp ;
;call Create2PKSieveAnyFromBaseSieve 95996741 eax 64
;push 03, 080000000 | mov eax esp
;call Create2PKSieveAnyFromBaseSieve 1277 eax 64
;jmp L0< ;Exit
;call Create2PKSievingBase 95996741
;push 08, 080000000 | mov eax esp
;call Create2PKSieveAny 101 eax 64
;jmp Exit
;call IsDwordPrime 0-5 | ret
;call Create32bitSieveAndBytesDiff |
;call CreateSieveFor96bit4GbRange 01 | ret
;mov ecx esp | push 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 | mov eax esp | sub ecx esp | shl ecx 3
;call CreateSieveAnyBits4GbRange eax ecx | jmp Exit
;DBGBP |call SpeedTestDecimalConversion
    call 'User32.LoadIconA' D$hInstance, 1 | mov D$hIcon eax

    call 'User32.LoadCursorA' 0, &IDC_ARROW | mov D$hCursor eax

    call 'User32.RegisterClassA' WindowClass

    call 'User32.LoadMenuA' D$hInstance, M00_Menu | mov D$MenuHandle eax

    call 'User32.CreateWindowExA' &WS_EX_CLIENTEDGE, WindowClassName, WindowCaption,
                                 &WS_OVERLAPPED__&WS_SYSMENU__&WS_MINIMIZEBOX, ;__&WS_HSCROLL__&WS_VSCROLL,
                                 D$WindowX, D$WindowY, D$WindowW, D$WindowH, 0,
                                 D$MenuHandle, D$hInstance, 0
    mov D$WindowHandle eax


    call 'User32.CreateWindowExA',
        &WS_EX_CLIENTEDGE,
        {"EDIT",0},
        LastQwordPrime,
        &WS_CHILD+&WS_CLIPSIBLINGS+&WS_VISIBLE+&ES_NUMBER,
        40,24,210,24,
        D$WindowHandle,
        2,
        D$hInstance,
        0
    mov D$EDIT0_handle eax
    [EDIT0_handle: 0]
    call 'GDI32.CreateFontIndirectA' EDIT0_LOGFONTSTRUCT | mov D$EDIT0Font_handle eax
    call 'User32.SendMessageA' D$EDIT0_handle  &WM_SETFONT D$EDIT0Font_handle &TRUE
    [EDIT0Font_handle: 0]
    [EDIT0_LOGFONTSTRUCT:  0-16  0  0  0  400  0  822149635 'Courier New' 0 0 0 0 0 0 ]

    call 'User32.CreateWindowExA',
        0,
        {"BUTTON",0},
        {"Check",0},
        &WS_CHILD+&WS_CLIPSIBLINGS+&WS_VISIBLE,
        102,72,96,24,
        D$WindowHandle,
        3,
        D$hInstance,
        0
    mov D$BUTTON1_handle eax
    [BUTTON1_handle: 0]
    call 'User32.SendMessageA' D$BUTTON1_handle  &WM_SETFONT D$EDIT0Font_handle &TRUE

    call 'User32.CreateWindowExA',
        0,
        {"BUTTON",0},
        {"Check_>>",0},
        &WS_CHILD+&WS_CLIPSIBLINGS+&WS_VISIBLE,
        102,100,96,24,
        D$WindowHandle,
        4,
        D$hInstance,
        0
    mov D$BUTTON2_handle eax
    [BUTTON2_handle: 0]
    call 'User32.SendMessageA' D$BUTTON2_handle  &WM_SETFONT D$EDIT0Font_handle &TRUE

    call 'User32.CreateWindowExA',
        0,
        {"BUTTON",0},
        {"Check_<<",0},
        &WS_CHILD+&WS_CLIPSIBLINGS+&WS_VISIBLE,
        102,128,96,24,
        D$WindowHandle,
        5,
        D$hInstance,
        0
    mov D$BUTTON3_handle eax
    [BUTTON3_handle: 0]
    call 'User32.SendMessageA' D$BUTTON3_handle  &WM_SETFONT D$EDIT0Font_handle &TRUE


    call 'User32.ShowWindow' D$WindowHandle, &SW_SHOW
    call 'User32.UpdateWindow' D$WindowHandle
push 0,0,0,0,0,0,0,0 | mov EBX esp
    jmp L1>

    While eax >s 0
        call 'User32.TranslateMessage' EBX
        call 'User32.DispatchMessageA' EBX
L1:     call 'USER32.GetMessageA' EBX 0 0 0
    End_While
Exit:
    call 'Kernel32.ExitProcess' &NULL

    INT 3 | ALIGN 16

TITLE wndproc
___________________________________________________________________________________________
; These menu equates are given by the menu editor ([ClipBoard]):

[M00_Menu  2000                  M00_Start  2001                 M00_Minimize_n_start  2002
 M00_Stop  2003                  M00_Exit  2004                  M00_Sieve32bitRangeBytesDiff  2005
 M00_Sieve64bit4GbRangeDiff  2006                                M00_Sieve64bit4GbRange  2007
 M00_LoadAnyBitsNumber  2008]
___________________________________________________________________________________________

Proc MainWindowProc:
    Arguments @Addressee @Message @wParam @lParam
    USES ebx esi edi

            .If D@Message = &WM_CLOSE
                call closeThread
                call 'USER32.DestroyWindow' D@Addressee
                call 'GDI32.DeleteObject' D$EDIT0Font_handle

            Else_If D@Message = &WM_CHAR
                mov eax D@wParam | and eax 0FFFFFFDF
                cmp eax 'S' | je @STRT
                cmp eax 'T' | je @STP
                cmp eax 'M' | je @SMN

            Else_If D@Message = &WM_COMMAND
                If D@wParam = M00_Exit
                    call 'User32.SendMessageA' D@Addressee, &WM_CLOSE, 0, 0

                Else_If  D@wParam = M00_Sieve32bitRangeBytesDiff
                    cmp D$JobThreadhandle 0 | jne L2>
                    call StartFunctionThread Create32bitSieveAndBytesDiff 0
L2:
                Else_If  D@wParam = M00_Sieve64bit4GbRangeDiff
                    cmp D$JobThreadhandle 0 | jne L2>
                    call Input32BitNumber | test eax eax | je L2>
                    call StartFunctionThread CreateSieveAndDiffFor64bit4GbRange eax
L2:
                Else_If  D@wParam = M00_Sieve64bit4GbRange
                    cmp D$JobThreadhandle 0 | jne L2>
                    call Input32BitNumber | test eax eax | je L2>
                    call StartFunctionThread CreateSieveFor64bit4GbRange eax
L2:
                Else_If  D@wParam = M00_LoadAnyBitsNumber
                    cmp D$JobThreadhandle 0 | jne L2>
                    call LoadAnyBitsFile
L2:
                Else_If  D@wParam = M00_Start
@STRT:
                    cmp D$JobThreadhandle 0 | jne L2>
                    call StartFunctionThread THREADMain 0
L2:
                Else_If  D@wParam = M00_Stop
@STP:                 call closeThread

                Else_If  D@wParam = M00_Minimize_n_start
@SMN:               cmp D$JobThreadhandle 0 | jne L2>

                    call 'User32.ShowWindow' D$WindowHandle, &SW_MINIMIZE
                    and D$TimerId 0
                    call StartFunctionThread THREADMain 0
L2:
                Else
                    mov eax D@lParam
                    cmp D$AnyBitNum 0 | jne G2>
                    mov esi THREAD1Qword | cmp D$BUTTON1_handle eax | je G1>
                    mov esi THREAD1NextPQword | cmp D$BUTTON2_handle eax | je G1>;
                    mov esi THREAD1PrevPQword | cmp D$BUTTON3_handle eax | je G1>;
                    jmp L2>>
G2:
                    cmp D$JobThreadhandle 0 | jne L2>>
                    mov esi THREAD1AnyBitNumPRP | cmp D$BUTTON1_handle eax | je L0>
                    mov esi THREAD1AnyBitNumPRPnext | cmp D$BUTTON2_handle eax | je L0>;
                    mov esi THREAD1AnyBitNumPRPprev | cmp D$BUTTON3_handle eax | je L0>;
                    jmp L2>
G1:
                    cmp D$JobThreadhandle 0 | jne L2>
                    push 0,0,0,0,0,0,0,0 | mov ebx esp
                    call 'USER32.GetWindowTextA', D$EDIT0_handle, ebx, 21

                    call TranslateDecimal, ebx
                    add esp 020 | cmp eax 0 | jne L0>
                    call 'USER32.SetWindowTextA', D$WindowHandle, tErrN | jmp L2>
L0:
                    mov D$curQword eax, D$curQword+4 edx
                    call 'USER32.SetWindowTextA', D$WindowHandle, tWait

                    call StartFunctionThread ESI 0
L2:
                End_If

            Else_If D@Message = &WM_CREATE
                ;MOVE D$WindowHandle D@Addressee



            Else_If D@Message = &WM_DESTROY
                call 'User32.PostQuitMessage' 0

            Else_If D@Message = &WM_MOUSEMOVE
                call reporters | jmp L2>

;;
            Else_If D@Message = &WM_TIMER

                call D2H mname, D$curDword | call 'User32.SendMessageA', D$WindowHandle, &WM_SETTEXT, 0, mname
;;
L2:
            Else
                call 'User32.DefWindowProcA' D@Addressee, D@Message, D@wParam, D@lParam
                ExitP

            .End_If

    mov eax &FALSE
EndP

______________________________________________________________________________________


_______________________________________________________________________________________


; ****************************************
[<16 InputNum32Dialog:
 D$ 090CC08C0                  ; Style
 D$ 0                          ; ExStyle
 U$ 02 0 0 072 02C             ; Dim
 0                             ;      no Menu
 '' 0                          ; Class
 'Input 32bit number' 0        ; Title
 08 'Helv' 0]                  ; Font

[InputNum32DEdt:
 D$ 050802001                  ; Style
 D$ 0                          ; ExStyle
 U$ 014 08 031 0C              ; Dim
 IDC_INEDIT                    ; ID
 0FFFF 081                     ; Class
 '0000000000' 0                ; Title
 0]                            ; No creation data

[InputNum32DBtn:
 D$ 050000000                  ; Style
 D$ 0                          ; ExStyle
 U$ 010 019 038 0F             ; Dim
 IDC_INBTN                     ; ID
 0FFFF 080                     ; Class
 'Enter' 0                     ; Title
 0]                            ; No creation data


[<16 hINDlg: hINEdit: D$ 0 hINBtn: 0 InNumber: 0
 ErrMsgCaption: B$ 'Input Numer Error',0 ErrMsgText: 'Input number from 1 to 4294967295',0  inputNumText: '0000000000',0,0 ]
 [IDC_INEDIT 1001 | IDC_INBTN 1002 ]

Proc Input32BitNumber:
    and D$InNumber 0
    call 'USER32.DialogBoxIndirectParamA' D$hInstance InputNum32Dialog D$WindowHandle InputNumDLGPROC 0
EndP

Proc InputNumDLGPROC:
 Arguments @hDlg, @Message, @wParam, @lParam
  Uses ebx

 If D@message = &WM_COMMAND
    mov eax D@wParam
    cmp eax ( &BN_CLICKED shl 16 + IDC_INBTN ) | jne L0>
    call 'User32.SendMessageA' D$hINEdit &WM_GETTEXT 11 inputNumText | mov ebx eax
    call TranslateDecimal inputNumText | cmp eax 0 | je L1>
    mov D$InNumber eax
    call 'User32.PostMessageA' D@hDlg &WM_CLOSE 0 0 | jmp L0>
L1: call 'User32.MessageBoxA' D@hDlg ErrMsgText ErrMsgCaption &MB_ICONWARNING
L0:
 Else_If D@message = &WM_INITDIALOG
   call 'User32.GetDlgItem', D@hDlg, IDC_INEDIT | mov D$hINEdit eax
   call 'User32.GetDlgItem', D@hDlg, IDC_INBTN | mov D$hINBtn eax
 Else_If D@message = &WM_CLOSE
   call 'USER32.EndDialog' D@hDlg D$InNumber
 Else
L8: mov eax &FALSE | ExitP
 End_If

L9: mov eax &TRUE
Endp


Proc LoadAnyBitsFile:
 USES ebx

    sub eax eax | xchg D$AnyBitNum eax | call 'BaseRTL.VFree' eax
    sub eax eax | xchg  D$SieveMem eax | call 'BaseRTL.VFree' eax
    push '0' | call 'USER32.SetWindowTextA', D$EDIT0_handle, esp | add esp 4
    call 'BaseRTL.ChooseAndLoadFileByNameAnsi' D$WindowHandle | test eax eax | je L2>>
    SHL edx 3 | ALIGN_ON 32 edx | mov D$AnyBitNum eax, D$AnyBitNumSz edx
    updateBitSize D$AnyBitNum D$AnyBitNumSz | cmp D$AnyBitNumSz 64 | ja L0>
    push 0,0,0,0,0,0,0,0 | mov ebx esp | mov eax D$AnyBitNum, edx D$eax+4, eax D$eax
    call Qword2Decimal ebx eax edx
    call 'USER32.SetWindowTextA', D$EDIT0_handle, ebx | add esp (8*4)
    sub eax eax | xchg D$AnyBitNum eax | call 'BaseRTL.VFree' eax | jmp L2>
L0:
    call 'USER32.SetWindowTextA', D$EDIT0_handle, AnyBitsLoaded
L2:
EndP

;;;;;;;;;;
setStartTime:
pushad
call 'KERNEL32.GetTickCount' | mov ebx eax
L0: call 'KERNEL32.GetTickCount' | cmp ebx eax | je L0< | mov ebx eax
RDTSC | mov D$dm ebx, D$dm+4 eax, D$dm+8 edx
popad
ret

GetCPUspeed:
pushad
cmp D$dm+0C 0 | jne L1>
call 'KERNEL32.GetTickCount' | mov ebx eax
L0: call 'KERNEL32.GetTickCount' | cmp ebx eax | je L0< | mov ebx eax
RDTSC | sub ebx D$dm | sub eax D$dm+4 | sbb edx D$dm+8  | cmp ebx edx | jbe L1> | div ebx | mov D$dm+0C eax
L1:
popad
ret

____________________________________________________________________________________________

TITLE Sieves
____________________________________________________________________________________________

Proc CreateSieveFor64bit4GbRange:
 ARGUMENTS @Bit64HighDword
 Local  @pArrayBits @primecount ;@prevPrimeHi @prevPrimeLo
 USES EBX ESI EDI
;DBGBP
;    move D@prevPrimeHi D@Bit64HighDword | mov D@prevPrimeLo 0
    cmp D$mB32P 0 | jne L0>
    call TryLoadB32primesFile | test eax eax | je L1>
    mov D$mB32P eax, D$szB32P edx | jmp L0>
L1:
    call Create32bitSieveAndBytesDiff | test eax eax | je P9>>
    call TryLoadB32primesFile | test eax eax | je P9>>
    mov D$mB32P eax, D$szB32P edx
L0:
    call 'BaseRTL.VAlloc' 010000000 | test eax eax | je P9>>
    mov D@pArrayBits eax
    call 'NUMERIKO.Bit32PrimesSieve64Bit4GbRange' D$mB32P D@pArrayBits D@Bit64HighDword
    mov D@primecount eax
;;
CPUID | sub eax eax | RDTSC | push edx, eax
RDTSC | pop ecx | sub eax ecx | pop ecx | sbb edx ecx | push edx, eax
    call 'NUMERIKO.Bit32PrimesSieve64Bit4GbRange' D$mB32P D@pArrayBits D@Bit64HighDword

    call 'BaseRTL.VFree' D@pArrayBits
    call 'BaseRTL.VAlloc' 010000000 | test eax eax | je P9>>
    mov D@pArrayBits eax
CPUID | sub eax eax | RDTSC | push edx, eax

    call P3571113Sieve D$mB32P D@pArrayBits D@Bit64HighDword
    mov D@primecount eax

;RDTSC | pop ecx | sub eax ecx | pop ecx | sbb edx ecx
;DBGBP
;;
    call 'BaseCodecs.D2H' mname, D@Bit64HighDword | mov D$mname+8 '.sv' ;| mov B$mname+16 0
    call 'BaseRTL.WriteMem2FileNameA' mname D@pArrayBits 010000000
    call 'BaseRTL.VFree' D@pArrayBits

EndP
;
;
Proc CreateSieveAnyBits4GbRange:
 ARGUMENTS @pAnyBits @AnyBitsSz
 Local  @pArrayBits @primecount
 USES EBX ESI EDI
;DBGBP
    cmp D$mB32P 0 | jne L0>
    call TryLoadB32primesFile | test eax eax | je L1>
    mov D$mB32P eax, D$szB32P edx | jmp L0>
L1:
    call Create32bitSieveAndBytesDiff | test eax eax | je P9>>
    call TryLoadB32primesFile | test eax eax | je P9>>
    mov D$mB32P eax, D$szB32P edx
L0:
    call 'BaseRTL.VAlloc' 010000000 | test eax eax | je P9>>
    mov D@pArrayBits eax
    call 'NUMERIKO.Bit32PrimesSieveAny4GbRange' D$mB32P D@pArrayBits D@pAnyBits D@AnyBitsSz
    mov D@primecount eax
    mov eax D@pAnyBits, eax D$eax+4
    call 'BaseCodecs.D2H' mname, eax | mov D$mname+8 '.sva' | mov B$mname+12 0
    call 'BaseRTL.WriteMem2FileNameA' mname D@pArrayBits 010000000
    call 'BaseRTL.VFree' D@pArrayBits

EndP
;
;
Proc CreateSieveAndDiffFor64bit4GbRange:
 ARGUMENTS @Bit64HighDword
 Local  @pArrayBits @primecount @prevPrimeHi @prevPrimeLo
 USES EBX ESI EDI
;DBGBP
    move D@prevPrimeHi D@Bit64HighDword | mov D@prevPrimeLo 0
    cmp D$mB32P 0 | jne L0>
    call TryLoadB32primesFile | test eax eax | je L1>
    mov D$mB32P eax, D$szB32P edx | jmp L0>
L1:
    call Create32bitSieveAndBytesDiff | test eax eax | je P9>>
    call TryLoadB32primesFile | test eax eax | je P9>>
    mov D$mB32P eax, D$szB32P edx
L0:
    call 'BaseRTL.VAlloc' 010000000 | test eax eax | je P9>>
    mov D@pArrayBits eax
    call 'NUMERIKO.Bit32PrimesSieve64Bit4GbRange' D$mB32P D@pArrayBits D@Bit64HighDword
    mov D@primecount eax
    call 'BaseCodecs.D2H' mname, D@Bit64HighDword | mov D$mname+8 '.sv'
    call 'BaseRTL.WriteMem2FileNameA' mname D@pArrayBits 010000000

    mov eax D@primecount | mov edx eax | shr edx 8 | add eax edx
    call 'BaseRTL.VAlloc' eax | test eax eax | je E0>
    mov esi eax
    call 'NUMERIKO.FindPrevPrimeQword' 0, D@Bit64HighDword | test eax eax | je L0>
    mov D@prevPrimeHi edx, D@prevPrimeLo eax
L0:
    call 'NUMERIKO.ConvertSieveToDiffBytes' esi D@pArrayBits 080000000 D@Bit64HighDword eax
    mov ebx eax
    call 'BaseCodecs.Q2H' mname, D@prevPrimeLo, D@prevPrimeHi | mov B$mname+16 0
    call 'BaseRTL.WriteMem2FileNameA' mname esi ebx
    call 'BaseRTL.VFree' esi

E0:
    call 'BaseRTL.VFree' D@pArrayBits

EndP


;[filebytsdiff: B$ 'Bit32PrimesBytsDiff',0]
Proc Create32bitSieveAndBytesDiff:
 ARGUMENTS @HighestDword
 cLocal @pArrayBits @primecount @BytesDiff @result ; @mem0
 USES EBX ESI EDI

;    call 'BaseRTL.VAlloc', 02000 | test eax eax | mov D@mem0 eax | je E0>>
;    call 'NUMERIKO.Numeriko16' D@mem0 | cmp edx 0198E | jne E0>>
    call 'BaseRTL.VAlloc' 010000000 | test eax eax | je E0>>
    mov D@pArrayBits eax
    call 'NUMERIKO.Bit16PrimesSieve32BitRange' D@pArrayBits ; D@mem0
    mov D@primecount eax | cmp eax (B32Psize +1) | jne E0>
    call 'BaseCodecs.D2H' mname, 0 | mov D$mname+8 '.sv'
    call 'BaseRTL.WriteMem2FileNameA' mname D@pArrayBits 010000000
    call 'BaseRTL.VAlloc' D@primecount | test eax eax | je E0>
    mov D@BytesDiff eax
    call 'NUMERIKO.ConvertSieveToDiffBytes' D@BytesDiff D@pArrayBits 080000000 0 0
    cmp eax B32Psize | jne E0>
    call 'BaseRTL.WriteMem2FileNameA' B32primes D@BytesDiff eax | test eax eax | je E0>
    mov D@result 1
E0:
    call 'BaseRTL.VFree' D@BytesDiff
    call 'BaseRTL.VFree' D@pArrayBits
;    call 'BaseRTL.VFree' D@mem0
    mov eax D@result
EndP


;
Proc CreateSieveFor96bit4GbRange:
 ARGUMENTS @HighestDword
 Local  @pArrayBits @primecount
 USES EBX ESI EDI

;    move D@prevPrimeHi D@Bit64HighDword | mov D@prevPrimeLo 0
    cmp D$mB32P 0 | jne L0>
    call TryLoadB32primesFile | test eax eax | je L1>
    mov D$mB32P eax, D$szB32P edx | jmp L0>
L1:
    call Create32bitSieveAndBytesDiff | test eax eax | je P9>>
    call TryLoadB32primesFile | test eax eax | je P9>>
    mov D$mB32P eax, D$szB32P edx
L0:
    call 'BaseRTL.VAlloc' 010000000 | test eax eax | je P9>>
    mov D@pArrayBits eax
    call Bit32PrimesSieve96bit4GbRange D$mB32P D@pArrayBits D@HighestDword
    mov D@primecount eax

    call 'BaseCodecs.D2H' mname, D@HighestDword | mov D$mname+8 '.s96' | mov B$mname+12 0
    call 'BaseRTL.WriteMem2FileNameA' mname D@pArrayBits 010000000

    mov eax D@primecount | mov edx eax | shr edx 8 | add eax edx
    call 'BaseRTL.VAlloc' eax | test eax eax | je E0>
    mov esi eax
L0:
    call 'NUMERIKO.ConvertSieveToDiffBytes' esi D@pArrayBits 080000000 D@HighestDword 0
    mov ebx eax
    call 'BaseCodecs.D2H' mname, D@HighestDword | mov D$mname+8 '.b96' | mov B$mname+12 0
    call 'BaseRTL.WriteMem2FileNameA' mname esi ebx
    call 'BaseRTL.VFree' esi

E0:
    call 'BaseRTL.VFree' D@pArrayBits

EndP


Proc Bit32PrimesSieve96bit4GbRange:
 ARGUMENTS @mB32Primes @SieveMem @HighestDword
 Local  @upBorder
 USES EBX ESI EDI
;DBGBP
    sub eax eax
    cmp D@HighestDword 0 | je P9>
    mov esi D@SieveMem | mov edi D@mB32Primes
    sub ecx ecx | mov ebx 1
L0:
    movzx eax B$edi+ecx | shl eax 1 | add eax EBX | jc L9>
    mov ebx eax | inc ecx
    mov eax D@HighestDword | sub edx edx
    DIV ebx | mov eax 0
    DIV ebx | mov eax 0
    DIV ebx | mov eax 0
    test edx edx | jne L2> | mov edx ebx
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

TestPrimeInSieve:
mov D$SieveFileBase 0
call TryLoad4GBrangeSieveFile D$SieveFileBase | mov D$pSievePtr eax
mov ebx 1
L0:
call 'NUMERIKO.IsNumberPrimeInSieve' D$pSievePtr ebx
call 'NUMERIKO.GetNextPrimeFromSieve' D$pSievePtr ebx
cmp eax 0-1 | mov ebx eax | jne L0<
RET

[SieveFileBase: D$ 0 pSievePtr: 0 ]
Proc TryLoad4GBrangeSieveFile:
 ARGUMENTS @SieveBase

    call 'BaseCodecs.D2H' mname, D@SieveBase | mov D$mname+8 '.sv'
    call 'BaseRTL.LoadFileNameA2Mem' mname

EndP




TITLE Sieves2PK
____________________________________________________________________________________________


; returns count
Proc Bit32PrimesSieve2PK:
 ARGUMENTS @Sieve0Ptr @SieveMem @MExponent @MExponentK
 Local  @MExponent2 @MExponentKcopy @prevPrimeHi @prevPrimeLo
 USES EBX ESI EDI
DBGBP

    move D@MExponent2 D@MExponent | SHL D@MExponent2 1
    mov esi D@SieveMem
    sub edi edi | mov ebx 1
L0:
    call 'NUMERIKO.GetNextPrimeFromSieve' D@Sieve0Ptr ebx
    mov ebx eax | cmp D@MExponent ebx | je L0<
    inc edi | cmp edi 040001 | je L9>
    move D@MExponentKcopy D@MExponentK
L1:
    mov eax D@MExponent2 | MUL D@MExponentKcopy | or eax 1
    mov D@prevPrimeHi edx | mov D@prevPrimeLo eax
    cmp eax ebx | jne L4>
    test edx edx | je L2>
L4: lea eax D@prevPrimeLo
    call 'AnyBits.AnyBitsMod32Bit' eax 64 ebx
    test eax eax | je P9>>
    test edx edx | jne L2>
    mov eax D@MExponentKcopy | dec eax
L3:
    cmp eax 080000000 | jae L0<
    BTS D$esi eax
    add eax ebx | jmp L3<

L2: INC D@MExponentKcopy | cmp D@MExponentKcopy 080000000 | jbe L1<
    jmp L0<
; MOD8 03 05 case
L9: mov ebx 8, edi 1
L0: move D@MExponentKcopy D@MExponentK
    add edi 2 | cmp edi 5 | ja L9>
L1: mov eax D@MExponent2 | MUL D@MExponentKcopy | or eax 1
    mov D@prevPrimeHi edx | mov D@prevPrimeLo eax
    lea eax D@prevPrimeLo
    call 'AnyBits.AnyBitsMod32Bit' eax 64 ebx
    test eax eax | je P9>
    cmp edx edi | jne L2>
    mov eax D@MExponentKcopy | dec eax
L3:
    cmp eax 080000000 | jae L0<
    BTS D$esi eax
    add eax 4 | jmp L3<

L2: INC D@MExponentKcopy
    jmp L1<

L9:
    sub eax eax | sub edx edx
L0: BT D$esi edx | jc L1> | inc eax
L1: inc edx | cmp edx 080000000 | jb L0<

EndP
;
Proc Create2PKSieve:
 ARGUMENTS @MExponent @MExponentK
 Local  @Sieve0Ptr @pArrayBits @primecount
 USES EBX ESI EDI
DBGBP

    call TryLoad4GBrangeSieveFile 0 | mov D@Sieve0Ptr eax | test eax eax | je P9>
L0:
    call 'BaseRTL.VAlloc' 010000000 | mov D@pArrayBits eax | test eax eax | je L9>

    call Bit32PrimesSieve2PK D@Sieve0Ptr D@pArrayBits D@MExponent D@MExponentK | test eax eax | je L8>
    mov D@primecount eax

    call 'BaseCodecs.Q2H' mname, D@MExponent D@MExponentK | mov D$mname+16 '.2ps' | mov B$mname+20 0
    call 'BaseRTL.WriteMem2FileNameA' mname D@pArrayBits 010000000
L8: call 'BaseRTL.VFree' D@pArrayBits
L9: call 'BaseRTL.VFree' D@Sieve0Ptr

EndP

;
; returns count
Proc Bit32PrimesSieve2PKAny:
 ARGUMENTS @Sieve0Ptr @SieveMem @MExponent @MExponentK @MExponentKsz
 cLocal  @MExponent2 @MExponentKcopySz @MExponentKcopy @p2kSz @p2k @bsetcnt
 USES EBX ESI EDI
DBGBP
; Next K will start
    call 'AnyBits.AnyBitsAdditionSelf32Bit' D@MExponentK D@MExponentKSz 1 | jc E1>>
    mov eax D@MExponentKsz | add eax 32 | mov D@MExponentKcopySz eax |  shr eax 3
    call 'BaseRTL.VAlloc' eax | mov D@MExponentKcopy eax | test eax eax | je E1>>
    mov eax D@MExponentKcopySz | add eax 32 | mov D@p2kSz eax |  shr eax 3
    call 'BaseRTL.VAlloc' eax | mov D@p2k eax | test eax eax | je E1>>
    move D@MExponent2 D@MExponent | SHL D@MExponent2 1
    mov esi D@SieveMem
    sub edi edi | mov ebx 1
L0:
    call 'NUMERIKO.GetNextPrimeFromSieve' D@Sieve0Ptr ebx
    mov ebx eax | cmp D@MExponent ebx | je L0<
    inc edi | cmp edi 020001 | je L9>>
    mov eax D@MExponentKsz | shr eax 3
    call 'BaseRTL.CopyMemory' D@MExponentKcopy D@MExponentK eax
    call 'AnyBits.AnyBitsMul32Bit' D@p2k D@p2kSz D@MExponent2 D@MExponentKcopy D@MExponentKcopySz | test eax eax | je E1>>
    mov eax D@p2k | or D$eax 1
L1:
    call 'AnyBits.AnyBitsMod32Bit' D@p2k D@p2kSz ebx | test eax eax | je E1>>
    test edx edx | jne L2>
    mov eax D@MExponentKcopy, edx D@MExponentK, eax D$eax | sub eax D$edx ;| dec eax
    sub ecx ecx | sub edx edx
L3: cmp eax 080000000 | jae L3>
    BTS D$esi eax | adc ecx 0 | inc edx
    add eax ebx | jmp L3<
L3: cmp edx ecx | ja L0<< | inc D@bsetcnt | jmp L0<<
L2: call 'AnyBits.AnyBitsAdditionSelf32Bit' D@MExponentKcopy D@MExponentKcopySz 1 ;| jnc L1<
    call 'AnyBits.AnyBitsAdditionSelf32Bit' D@p2k D@p2kSz D@MExponent2 ;| jnc L1<

    mov eax D@MExponentKcopy, ecx D@MExponentK, edx D$eax+4, eax D$eax
    sub eax D$ecx | sbb edx D$ecx+4 | cmp edx 0 | jne L0<< | cmp eax 080000000 | jb L1<<
    jmp L0<<

; MOD8 03 05 case
L9:
    mov ebx 8, edi 1
L0: add edi 2 | cmp edi 5 | ja L9>
    mov eax D@MExponentKsz | shr eax 3
    call 'BaseRTL.CopyMemory' D@MExponentKcopy D@MExponentK eax
L1:
    call 'AnyBits.AnyBitsMul32Bit' D@p2k D@p2kSz D@MExponent2 D@MExponentKcopy D@MExponentKcopySz | test eax eax | je E1>
    mov eax D@p2k | or D$eax 1
    call 'AnyBits.AnyBitsMod32Bit' D@p2k D@p2kSz ebx | test eax eax | je E1>
    cmp edx edi | jne L2>
    mov eax D@MExponentKcopy, edx D@MExponentK, eax D$eax | sub eax D$edx ;| dec eax
L3:
    cmp eax 080000000 | jae L0<
    BTS D$esi eax
    add eax 4 | jmp L3<

L2: call 'AnyBits.AnyBitsAdditionSelf32Bit' D@MExponentKcopy D@MExponentKcopySz 1 | jnc L1<
    jmp L0<

E1: sub ebx ebx | jmp E0>
L9:
    sub eax eax | sub edx edx
L0: BT D$esi edx | jc L1> | inc eax
L1: inc edx | cmp edx 080000000 | jb L0<
    mov ebx eax
E0:
    call 'AnyBits.AnyBitsSubstractSelf32Bit' D@MExponentK D@MExponentKSz 1
    call 'BaseRTL.VFree' D@p2k | call 'BaseRTL.VFree' D@MExponentKcopy
    mov eax ebx
EndP
;
;
;
Proc Create2PKSieveAny:
 ARGUMENTS @MExponent @MExponentK @MExponentKsz
 Local  @Sieve0Ptr @pArrayBits @primecount
 USES EDI
DBGBP

    call TryLoad4GBrangeSieveFile 0 | mov D@Sieve0Ptr eax | test eax eax | je P9>>
L0:
    call 'BaseRTL.VAlloc' 010000000 | mov D@pArrayBits eax | test eax eax | je L9>

    call Bit32PrimesSieve2PKAny D@Sieve0Ptr D@pArrayBits D@MExponent D@MExponentK D@MExponentKsz | test eax eax | je L8>
    mov D@primecount eax
    mov eax D@MExponentK
    CLD | mov edi mname
    call 'BaseCodecs.Q2H' edi, D$eax, D$eax+4 | add edi eax | mov al '_' | STOSB
    call 'BaseCodecs.D2H' edi, D@MExponent | add edi eax
    mov eax '.2ps' | STOSD | mov B$edi 0
    call 'BaseRTL.WriteMem2FileNameA' mname D@pArrayBits 010000000
L8: call 'BaseRTL.VFree' D@pArrayBits
L9: call 'BaseRTL.VFree' D@Sieve0Ptr

EndP

; returns count
Proc Bit32PrimesCreate2PKSievingBase1:
 ARGUMENTS @Sieve0Ptr @BaseKMem @MExponent ; @Base0Bits
 cLocal  @currBaseKMem @MExponent2 ;@bsetcnt
 USES EBX ESI EDI
DBGBP

    move D@MExponent2 D@MExponent | SHL D@MExponent2 1
    move D@currBaseKMem D@BaseKMem
    mov ebx 1
    CLD
L0:
    call 'NUMERIKO.GetNextPrimeFromSieve' D@Sieve0Ptr ebx
    mov ebx eax | cmp D@MExponent ebx | je L4>
    cmp ebx 01000000 | ja L9>
    mov ecx D@MExponent2, edi 0
    mov eax ecx, edx 0 | DIV ebx | mov esi eax | or esi 1
; instead, P*x MOD 2p => 1
L1:
    mov eax esi | MUL ebx | DIV ecx
    cmp edx 1 | je L2>
    add ESI 2 | cmp ESI ecx | jae L3>
    jmp L1<
L3: INT3
    jmp L4>
L2: mov edx D@currBaseKMem
    mov D$edx eax | add D@currBaseKMem 4
;;
    mov EDI D@Base0Bits
    lea eax D$esi-1
    sub ecx ecx | sub edx edx
L3:
    BTS D$edi eax | adc ecx 0 | inc edx |
    add eax ebx | jns L3<
    cmp edx ecx | ja L2> | inc D@bsetcnt
L2: 
;;
    jmp L0<

L4: mov eax D@currBaseKMem
    and D$eax 0 | add D@currBaseKMem 4
    jmp L0< ;  k = P case for skip
;;
; MOD8 3 5 case
L9:
    mov ebx 8, edi 1
L0:
    mov ESI 1
    mov ecx D@MExponent2
    add edi 2 | cmp edi 5 | ja L9>
L1:
    mov eax ecx, edx 0 | or eax 1
    DIV ebx | cmp edx edi | je L2>
    add ESI 1
    add ecx D@MExponent2
    jmp L1<
L2:
    mov EDX D@Base0Bits
    lea eax D$esi-1
L3:
    BTS D$edx eax | add eax 4 | jns L3<
    jmp L0<
;;
L9:
    mov eax D@currBaseKMem
    sub eax D@BaseKMem
EndP
;
; returns count
Proc Bit32PrimesCreate2PKSievingBase:
 ARGUMENTS @Sieve0Ptr @BaseKMem @MExponent ; @Base0Bits
 cLocal  @currBaseKMem @MExponent2 ;@bsetcnt
 USES EBX ESI EDI
DBGBP
[startPrime 01C00000]
    move D@MExponent2 D@MExponent | SHL D@MExponent2 1
    move D@currBaseKMem D@BaseKMem
    mov ebx 1 ; startPrime +0
    CLD
L0:
    call 'NUMERIKO.GetNextPrimeFromSieve' D@Sieve0Ptr ebx
    mov ebx eax | cmp D@MExponent ebx | je L4>
    cmp ebx 0800000 | ja L9>; cmp ebx startPrime +0 +0100000 | ja L9>
    mov ESI 1
;k*2p +1 = P*x
    mov ecx D@MExponent2, edi 0
L1:
    mov eax ecx, edx edi | or eax 1
    DIV ebx | test edx edx | je L2>
    add ESI 1 | cmp ESI EBX | jae L3>
    add ecx D@MExponent2 | adc edi 0
    jmp L1<
L3: INT3
    jmp L4>
L2: mov eax D@currBaseKMem
    mov D$eax esi | add D@currBaseKMem 4
;;
    mov EDI D@Base0Bits
    lea eax D$esi-1
    sub ecx ecx | sub edx edx
L3:
    BTS D$edi eax | adc ecx 0 | inc edx |
    add eax ebx | jns L3<
    cmp edx ecx | ja L2> | inc D@bsetcnt
L2: 
;;
    jmp L0<

L4: mov eax D@currBaseKMem
    and D$eax 0 | add D@currBaseKMem 4
    jmp L0< ;  k = P case for skip
;;
; MOD8 3 5 case
L9:
    mov ebx 8, edi 1
L0:
    mov ESI 1
    mov ecx D@MExponent2
    add edi 2 | cmp edi 5 | ja L9>
L1:
    mov eax ecx, edx 0 | or eax 1
    DIV ebx | cmp edx edi | je L2>
    add ESI 1
    add ecx D@MExponent2
    jmp L1<
L2:
    mov EDX D@Base0Bits
    lea eax D$esi-1
L3:
    BTS D$edx eax | add eax 4 | jns L3<
    jmp L0<
;;
L9:
    mov eax D@currBaseKMem
    sub eax D@BaseKMem
EndP
;
; returns count
Proc Bit32PrimesCreate2PKSievingBaseU:
 ARGUMENTS @Sieve0Ptr @BaseKMem @MExponent ; @Base0Bits
 cLocal  @currBaseKMem @MExponent2 ;@bsetcnt
 USES EBX ESI EDI
DBGBP
;[startPrime 01C00000]
    move D@MExponent2 D@MExponent | SHL D@MExponent2 1
    move D@currBaseKMem D@BaseKMem
    mov ebx startPrime +0
    CLD
L0:
    call 'NUMERIKO.GetNextPrimeFromSieve' D@Sieve0Ptr ebx
    mov ebx eax | cmp D@MExponent ebx | je L4>
    cmp ebx startPrime +0 +0100000 | ja L9>
;k*2p +1 = P*x
; brute UP-down
    mov ESI ebx
    mov eax D@MExponent2
    MUL ESI
    mov ecx eax, edi edx
L1:
    mov eax ecx, edx edi | or eax 1
    DIV ebx | test edx edx | je L2>
    sub ESI 1 | jle L3>
    sub ecx D@MExponent2 | sbb edi 0
    jmp L1<
L3: INT3
    jmp L4>
L2: mov eax D@currBaseKMem
    mov D$eax esi | add D@currBaseKMem 4
    jmp L0<

L4: mov eax D@currBaseKMem
    and D$eax 0 | add D@currBaseKMem 4
    jmp L0< ;  k = P case for skip
L9:
    mov eax D@currBaseKMem
    sub eax D@BaseKMem
EndP
;
;
Proc Create2PKSievingBase:
 ARGUMENTS @MExponent
 Local  @Sieve0Ptr @BaseKMem @primecount; @Base0Bits
 USES EDI
DBGBP

    call TryLoad4GBrangeSieveFile 0 | mov D@Sieve0Ptr eax | test eax eax | je P9>>
L0:
    call 'BaseRTL.VAlloc'  01000000 | mov D@BaseKMem eax | test eax eax | je L9>>
;    call 'BaseRTL.VAlloc' 010000000 | mov D@Base0Bits eax | test eax eax | je L8>>

    call Bit32PrimesCreate2PKSievingBase D@Sieve0Ptr D@BaseKMem D@MExponent | test eax eax | je L8> ;D@Base0Bits
    mov D@primecount eax

    CLD | mov edi mname
;    mov ax '1.' | STOSW
    call 'BaseCodecs.D2H' edi, D@MExponent | add edi eax | mov al '_' | STOSB
    mov eax 'BASE' | STOSD | mov B$edi 0
    call 'BaseRTL.WriteMem2FileNameA' mname D@BaseKMem D@primecount
;;
    CLD | mov edi mname
    mov eax '0000' | STOSD | STOSD | STOSD | STOSD | mov al '_' | STOSB
    call 'BaseCodecs.D2H' edi, D@MExponent | add edi eax
    mov eax '.2ps' | STOSD | mov B$edi 0
    call 'BaseRTL.WriteMem2FileNameA' mname D@Base0Bits 010000000
;;
L8: ;call 'BaseRTL.VFree' D@Base0Bits
    call 'BaseRTL.VFree' D@BaseKMem
L9: call 'BaseRTL.VFree' D@Sieve0Ptr

EndP



; returns count
Proc Sieve2PKBase0:
 ARGUMENTS @BP32diff @SieveMem @BaseKpSieve @BaseKpSieveSz @MExponent
 ;cLocal  @BaseKprimed @bsetcnt
 USES EBX ESI EDI
DBGBP

    sub edi edi | mov ebx 1
    mov esi D@SieveMem
    SHR D@BaseKpSieveSz 2 | SHL D@MExponent 1
L0:
    mov eax D@BP32diff | movzx eax B$eax+edi | shl eax 1 | add ebx eax
    mov eax D@BaseKpSieve | mov eax D$eax+EDI*4 | test eax eax | je L2>
    mov ecx eax
    MUL D@MExponent | or eax 1 | xchg eax ecx
    cmp ecx ebx | jne L4> | add eax ebx
L4: dec eax
L3:
    BTS D$esi eax | add eax ebx | jns L3<
L2:
    inc edi | cmp edi D@BaseKpSieveSz | jb L0<
;
; MOD8 3 5 case
L9:
    mov ebx 8, edi 1
L0:
    mov ESI 1
    mov ecx D@MExponent
    add edi 2 | cmp edi 5 | ja L9>
L1:
    mov eax ecx, edx 0 | or eax 1
    DIV ebx | cmp edx edi | je L2>
    add ESI 1
    add ecx D@MExponent
    jmp L1<
L2:
    mov EDX D@SieveMem
    lea eax D$esi-1
L3:
    BTS D$edx eax | add eax 4 | jns L3<
    jmp L0<

L9: mov esi D@SieveMem
    sub eax eax | sub edx edx
L0: BT D$esi edx | jc L1> | inc eax
L1: inc edx | cmp edx 080000000 | jb L0<

EndP
;
;
; [directReadNextPrime32FromDiffArrayPosition
; mov eax D@pArray | add eax D@Position | movzx eax B$eax | shl eax 1 | add eax D@prevPrime]

; returns count
Proc Sieve2PKAnyFromBaseSieve:
 ARGUMENTS @BP32diff @SieveMem @BaseKpSieve @BaseKpSieveSz @MExponentK @MExponentKsz @MExponent
 cLocal  @BaseKprimed @MExponentKcopySz @MExponentKcopy @MExponentKcopy2Sz @MExponentKcopy2 @bsetcnt
 USES EBX ESI EDI
DBGBP
    lea eax D@bsetcnt
    call 'AnyBits.AnyBitsCompare' D@MExponentK D@MExponentKSz eax 32 | cmp eax 3 | je E1>> ; no null base here
;    call 'AnyBits.AnyBitsAdditionSelf32Bit' D@MExponentK D@MExponentKSz 1 | jc E1>>
    mov eax D@MExponentKsz | add eax 32 | mov D@MExponentKcopySz eax |  shr eax 3
    call 'BaseRTL.VAlloc' eax | mov D@MExponentKcopy eax | test eax eax | je E1>>
    mov eax D@MExponentKcopySz | add eax 32 | mov D@MExponentKcopy2Sz eax |  shr eax 3
    call 'BaseRTL.VAlloc' eax | mov D@MExponentKcopy2 eax | test eax eax | je E1>>
    sub edi edi | mov ebx 1
    mov esi D@SieveMem
    SHR D@BaseKpSieveSz 2
L0:
    mov eax D@BP32diff | movzx eax B$eax+edi | shl eax 1 | add ebx eax
    mov eax D@BaseKpSieve | mov eax D$eax+EDI*4 | test eax eax | je L2>> | mov D@BaseKprimed eax
    lea eax D@BaseKprimed
    call 'AnyBits.AnyBitsSubstraction' D@MExponentKcopy D@MExponentKcopySz eax 32 D@MExponentK D@MExponentKsz
    call 'AnyBits.AnyBitsDiv32Bit' D@MExponentKcopy D@MExponentKcopySz ebx | test eax eax | je E1>>
    call 'AnyBits.AnyBitsMul32Bit' D@MExponentKcopy2 D@MExponentKcopy2Sz ebx D@MExponentKcopy D@MExponentKcopySz
    call 'AnyBits.AnyBitsAdditionSelf32Bit' D@MExponentKcopy2 D@MExponentKcopy2Sz D@BaseKprimed

    mov eax D@MExponentKcopy2, edx D@MExponentK, eax D$eax | sub eax D$edx
L3: add eax ebx | jle L3< | dec eax
    sub ecx ecx | sub edx edx
L3: cmp eax 080000000 | jae L3>
    BTS D$esi eax | adc ecx 0 | inc edx
    add eax ebx | jmp L3<
L3: cmp edx ecx | ja L2> | inc D@bsetcnt ;| jmp L0<<
L2:
    inc edi | cmp edi D@BaseKpSieveSz | jb L0<<
;
; MOD8 03 05 case
L9: SHL D@MExponent 1
    mov ebx 8, edi 1
    call 'AnyBits.AnyBitsAdditionSelf32Bit' D@MExponentK D@MExponentKSz 1 | jc E1>>
L0: add edi 2 | cmp edi 5 | ja L9>
    mov eax D@MExponentKsz | shr eax 3
    call 'BaseRTL.CopyMemory' D@MExponentKcopy D@MExponentK eax
L1:
    call 'AnyBits.AnyBitsMul32Bit' D@MExponentKcopy2 D@MExponentKcopy2Sz D@MExponent D@MExponentKcopy D@MExponentKSz | test eax eax | je E1>
    mov eax D@MExponentKcopy2 | or D$eax 1
    call 'AnyBits.AnyBitsMod32Bit' D@MExponentKcopy2 D@MExponentKcopy2Sz ebx | test eax eax | je E1>
    cmp edx edi | jne L2>
    mov eax D@MExponentKcopy, edx D@MExponentK, eax D$eax | sub eax D$edx ;| dec eax
L3:
    cmp eax 080000000 | jae L0<
    BTS D$esi eax
    add eax 4 | jmp L3<
L2: call 'AnyBits.AnyBitsAdditionSelf32Bit' D@MExponentKcopy D@MExponentKSz 1 | jnc L1<
    jmp L0<
L9:
    call 'AnyBits.AnyBitsSubstractSelf32Bit' D@MExponentK D@MExponentKSz 1
    jmp L9>
;
E1: sub ebx ebx | jmp E0>
L9:
    sub eax eax | sub edx edx
L0: BT D$esi edx | jc L1> | inc eax
L1: inc edx | cmp edx 080000000 | jb L0<
    mov ebx eax
E0:
    call 'BaseRTL.VFree' D@MExponentKcopy2
    call 'BaseRTL.VFree' D@MExponentKcopy
    mov eax ebx
EndP
;



;
;
Proc Create2PKSieveAnyFromBaseSieve:
 ARGUMENTS @MExponent @MExponentK @MExponentKsz
 cLocal  @BaseKpSieveSz @BaseKpSieve @pArrayBits @primecount
 USES EDI
DBGBP

    cmp D$mB32P 0 | jne L0>
    call TryLoadB32primesFile | test eax eax | je L1>
    mov D$mB32P eax, D$szB32P edx | jmp L0>
L1:
    call Create32bitSieveAndBytesDiff | test eax eax | je P9>>
    call TryLoadB32primesFile | test eax eax | je P9>>
    mov D$mB32P eax, D$szB32P edx
L0:
    call 'BaseRTL.VAlloc' 010000000 | mov D@pArrayBits eax | test eax eax | je L9>>
    CLD | mov edi mname
    call 'BaseCodecs.D2H' edi, D@MExponent | add edi eax | mov al '_' | STOSB
    mov eax 'BASE' | STOSD | mov B$edi 0
    call 'BaseRTL.LoadFileNameA2Mem' mname | test eax eax | je L9>>
    mov D@BaseKpSieve eax D@BaseKpSieveSz edx

    lea eax D@primecount
    call 'AnyBits.AnyBitsCompare' D@MExponentK D@MExponentKSz eax 32 | cmp eax 3 | jne L1>
    call Sieve2PKBase0 D$mB32P D@pArrayBits D@BaseKpSieve D@BaseKpSieveSz D@MExponent | test eax eax | je L8>
    mov D@primecount eax | jmp L0>
L1:
    call Sieve2PKAnyFromBaseSieve D$mB32P D@pArrayBits D@BaseKpSieve D@BaseKpSieveSz D@MExponentK D@MExponentKsz D@MExponent | test eax eax | je L8>
    mov D@primecount eax
L0:
    mov eax D@MExponentK
    CLD | mov edi mname
    call 'BaseCodecs.Q2H' edi, D$eax, D$eax+4 | add edi eax | mov al '_' | STOSB
    call 'BaseCodecs.D2H' edi, D@MExponent | add edi eax
    mov eax '.2ps' | STOSD | mov B$edi 0
    call 'BaseRTL.WriteMem2FileNameA' mname D@pArrayBits 010000000

L8: call 'BaseRTL.VFree' D@BaseKpSieve
L9: call 'BaseRTL.VFree' D@pArrayBits

EndP














