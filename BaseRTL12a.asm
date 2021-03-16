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

[Align_on | add #2 #1-1 | and #2 0-#1][Align_UP | and #2 0-#1 | add #2 #1 ]
;[DBGBP | nope]
[DBGBP | cmp B$isDBG 0 | DB 074 01 0CC ]
[isDBG: D$ 0]
[CRLF 0A0D]






TITLE start

VAlloc: jmp 'BaseRTL.VAlloc' | NOP | NOP
VFree: jmp 'BaseRTL.VFree' | NOP | NOP
; Data:

[WindowClass:
 style: 3
 lpfnWndProc: MainWindowProc
 cbClsExtra: 0
 cbWndExtra: 0
 hInstance: 0
 hIcon: 0
 hCursor: 0
 hbrBackground: 6
 lpszMenuName: 0 ;M00_Menu
 lpszClassName: WindowClassName]

[MenuHandle: 0]
;Wnd Handles, NULL terminated
[Wnd_Handles:
WindowHandle: 0
EDIT0_handle: 0
0]
; GDI obj handles, NULL terminated
[GDI_handles:
EDIT0Font_handle: 0
0]
[WindowClassName: B$ 'Application' 0    WindowCaption: 'Base RTL' 0]

[WindowX: 50  WindowY: 50  WindowW: startX  WindowH: startY]
[EditClassName: B$ 'EDIT' 0    Edit0Caption: 'HeLLo!' 0]
[EDIT0_LOGFONTSTRUCT:  -12  0  0  0  0  0  020000000 'Courier New' 0 0 0 0 0 0 ]
___________________________________________________________________________________________
[winver: 0]
[startX 352 | startY 160];[WndDC: D$ 0 DIBSect: 0 HBmp: 0]
[WndW: startX, WndH: startY, ClientRectX: 0, ClientRectY: 0, WndWsub: 0, WndHsub: 0]
[DesktW: 0 DesktH: 0][curTick: D$ 0][endTick: D$ 0]
[WndSizeTitle: B$ 0 #64]
[<16 JobThreadBlock:
 JobThreadBusy: D$ 0 JobProcAddr: 0 JobReporterAddr: 0 JobThreadhandle: 0 JobThreadPid: 0
 JobAskToEnd: 0 JobStartTick: 0 JobEndTick: 0 JobProcParamsCount: 0
 JobProcParams: 0 #32]

Main: ;call MULspeedTest ;MULDIVtest ;shifttest;call Rotetebytesttest
    call 'Kernel32.GetModuleHandleA', 0 | mov D$hInstance eax
    call 'Kernel32.GetVersion' | mov D$winver eax
    call 'Kernel32.IsDebuggerPresent' | mov D$isDBG eax
    call 'AnyBits.AnyBitsVersion' | cmp eax 010003 | jne exito
    call 'BaseCodecs.BaseCodecsVersion' | cmp eax 010003 | jne exito
;call doRationalBits2RationalDecimal | call 'Kernel32.ExitProcess' &NULL | ret | L0:
;call do2P1MTFAnyBitMTFactorFunnyBL; jmp ktest;AnyBitsSQ2Test;jmp L0> | call doLLTestExponent |
;call 'Kernel32.ExitProcess' &NULL | ret | L0:
    call 'User32.LoadIconA' D$hInstance, 1 | mov D$hIcon eax
    call 'User32.LoadCursorA' 0, &IDC_ARROW | mov D$hCursor eax
    call 'User32.RegisterClassA' WindowClass
    call 'User32.LoadMenuA' D$hInstance, M00_Menu | mov D$MenuHandle eax
    call 'User32.CreateWindowExA' &WS_EX_CLIENTEDGE,
                                  WindowClassName, WindowCaption,
                                  &WS_OVERLAPPEDWINDOW, ;__&WS_VISIBLE,
                                  D$WindowX, D$WindowY, D$WindowW, D$WindowH,
                                  0,
                                  D$MenuHandle,
                                  D$hInstance,
                                  0
    mov D$WindowHandle eax

    call 'User32.ShowWindow' D$WindowHandle, &SW_SHOW
    call 'User32.UpdateWindow' D$WindowHandle
push 0,0,0,0,0,0,0,0 | mov EBX esp
    jmp L1>
    While eax >s 0
        call 'User32.TranslateMessage' EBX ;FirstMessage
        call 'User32.DispatchMessageA' EBX
L1:     call 'USER32.GetMessageA' EBX, 0, 0, 0
    End_While
exito:
    call 'Kernel32.ExitProcess' &NULL
INT 3
CreateChilds:
    call 'User32.CreateWindowExA',
        &WS_EX_CLIENTEDGE,
        EditClassName, Edit0Caption,
        &WS_CHILD+&WS_CLIPSIBLINGS+&WS_GROUP+&WS_VISIBLE+&ES_AUTOHSCROLL+&ES_AUTOVSCROLL+&ES_LEFT+&ES_MULTILINE+&ES_READONLY,
        0,0,startX,startY,
        D$WindowHandle,
        101,
        D$hInstance,
        0
    mov D$EDIT0_handle eax
    call 'GDI32.CreateFontIndirectA' EDIT0_LOGFONTSTRUCT | mov D$EDIT0Font_handle eax
    call 'User32.SendMessageA' D$EDIT0_handle  &WM_SETFONT eax &TRUE
ret
INT 3
___________________________________________________________________________________________
; These menu equates are given by the menu editor ([ClipBoard]):

[M00_Menu  2000                  M00_New  2001                   M00_Open  2002
 M00_Save  2003                  M00_Save_As  2004               M00_Stop_JobThread  2005
 M00_Relocate_Executable  2006   M00_BuildRelocFromPointers  2007    M00_CopyDamagedFile  2008
 M00_RtlDecompress  2009         M00_InverseFileBytes  2010      M00_Exit  2011
 M00_Undo  2012                  M00_Cut  2013                   M00_Copy  2014
 M00_Paste  2015                 M00_Delete  2016                M00_Select_All  2017
 M00_Bin2Hex  2018               M00_Hex2Bin  2019               M00_Bin2HexBytes  2020
 M00_HexBytes2Bin  2021          M00_Bin2HexWords  2022          M00_HexWords2Bin  2023
 M00_Bin2HexDwords  2024         M00_HexDwords2Bin  2025         M00_Bin2HexQwords  2026
 M00_HexQwords2Bin  2027         M00_Bin2HexOwords  2028         M00_HexOwords2Bin  2029
 M00_Bin2Dec  2030               M00_Dec2Bin  2031               M00_RatioBits2RatioDecs  2032
 M00_RatioDecs2RatioBits  2033   M00_Bytes2Decimals  2034        M00_Decimals2Bytes  2035
 M00_Words2Decimals  2036        M00_Decimals2Words  2037        M00_Dwords2Decimals  2038
 M00_Decimals2Dwords  2039       M00_Qwords2Decimals  2040       M00_Decimals2Qwords  2041
 M00_Owords2Decimals  2042       M00_Decimals2Owords  2043       M00_Base24Encode  2044
 M00_Base24Decode  2045          M00_Base41Encode  2046          M00_Base41Decode  2047
 M00_Base53Encode  2048          M00_Base53Decode  2049          M00_Base64Encode  2050
 M00_Base64Decode  2051          M00_Base75Encode  2052          M00_Base75Decode  2053
 M00_Base85Encode  2054          M00_Base85Decode  2055          M00_Base94Encode  2056
 M00_Base94Decode  2057          M00_Base62Encode  2058          M00_Base62Decode  2059
 M00_AnyBitsADD  2060            M00_AnyBitsADD32  2061          M00_AnyBitsSUB  2062
 M00_AnyBitsSUB32  2063          M00_AnyBitsNEG  2064            M00_AnyBitsNOT  2065
 M00_AnyBitsMULbin  2066         M00_AnyBitsMUL  2067            M00_AnyBitsMUL32  2068
 M00_AnyBitsSQ2  2069            M00_AnyBitsPOW  2070            M00_AnyBitsDIV  2071
 M00_AnyBitsDIV32  2072          M00_AnyBitsMOD  2073            M00_AnyBitsMOD32  2074
 M00_AnyBitsSQRoot  2075         M00_AnyBitsNRoot  2076          M00_AnyBitsSHL  2077
 M00_AnyBitsSHR  2078            M00_AnyBitsROL  2079            M00_AnyBitsROR  2080
 M00_TestFunc0  2081             M00_TestFunc1  2082             M00_TestFunc2  2083
 M00_TestFunc3  2084             M00_TestFunc4  2085             M00_TestFunc5  2086
 M00_TestFunc6  2087             M00_TestFunc7  2088             M00_TestFunc8  2089
 M00_TestFunc9  2090             M00_About  2091]
___________________________________________________________________________________________

Proc MainWindowProc:
    Arguments @hWnd @Message @wParam @lParam

    USES EBX ESI EDI

        .If D@Message = &WM_CLOSE
            mov ebx GDI_handles
L0:         mov eax D$ebx | test eax eax | je L0>
            add ebx 4
            call 'GDI32.DeleteObject' eax | jmp L0<
L0:
            call 'USER32.DestroyWindow' D@hWnd

        Else_If D@Message = &WM_DESTROY
            call 'User32.PostQuitMessage' 0

        Else_If D@Message = &WM_CREATE
            MOVE D$WindowHandle D@hWnd
            call DesktopSZ | mov D$DesktW eax, D$DesktH edx
            call ClientRectSUBS D@hWnd
            call CreateChilds
        Else_If D@Message = &WM_SIZE
            call OnSize D@wParam, D@lParam
            ;ON D@wParam = &SIZE_MAXIMIZED, call

        Else_If D@Message = &WM_MOUSEMOVE
            call reporters | jmp L0>>

        Else_If D@Message = &WM_COMMAND
;DBGBP
          XOR EBX EBX
            If D@wParam = M00_Exit
               call 'User32.SendMessageA' D@hWnd, &WM_CLOSE, 0, 0

            Else_If  D@wParam = M00_New
               call OnMenuNew
            Else_If  D@wParam = M00_Open
               call OnMenuOpen
            Else_If  D@wParam = M00_Save
               call OnMenuSave
            Else_If  D@wParam = M00_Save_As
               call OnMenuSaveAs
            Else_If  D@wParam = M00_Stop_JobThread
               call ThreadAbort

            Else_If  D@wParam = M00_Relocate_Executable
               call OnMenuRelocateExecutable
            Else_If  D@wParam = M00_BuildRelocFromPointers
               call OnBuildRelocFromPointers
            Else_If  D@wParam = M00_CopyDamagedFile
               call OnCopyDamagedFile
            Else_If  D@wParam = M00_RtlDecompress
               call OnRtlDecompress
            Else_If  D@wParam = M00_InverseFileBytes
               call OnInverseFileBytes

            Else_If  D@wParam = M00_Bin2Dec
               mov ebx doBin2Dec
            Else_If  D@wParam = M00_Dec2Bin
               mov ebx doDec2Bin
            Else_If  D@wParam = M00_RatioBits2RatioDecs
               mov ebx doRationalBits2RationalDecimal
            Else_If  D@wParam = M00_RatioDecs2RatioBits
               mov ebx doRationalDecimal2RationalBits;
            Else_If  D@wParam = M00_Bytes2Decimals
               call OnBytes2Decimals
            Else_If  D@wParam = M00_Decimals2Bytes
               call OnDecimals2Bytes
            Else_If  D@wParam = M00_Words2Decimals
               call OnWords2Decimals
            Else_If  D@wParam = M00_Decimals2Words
               call OnDecimals2Words
            Else_If  D@wParam = M00_Dwords2Decimals
               call OnDwords2Decimals
            Else_If  D@wParam = M00_Decimals2Dwords
               call OnDecimals2Dwords
            Else_If  D@wParam = M00_QWords2Decimals
               call OnQWords2Decimals
            Else_If  D@wParam = M00_Decimals2QWords
               call OnDecimals2QWords
            Else_If  D@wParam = M00_OWords2Decimals
               call OnOWords2Decimals
            Else_If  D@wParam = M00_Decimals2OWords
               call OnDecimals2OWords

            Else_If  D@wParam = M00_Bin2Hex
               call OnBin2Hex
            Else_If  D@wParam = M00_Hex2Bin
               call OnHex2Bin
            Else_If  D@wParam = M00_Bin2HexBytes
               call OnBin2HexBytes
            Else_If  D@wParam = M00_HexBytes2Bin
               call OnHexBytes2Bin
            Else_If  D@wParam = M00_Bin2HexWords
               call OnBin2HexWords
            Else_If  D@wParam = M00_HexWords2Bin
               call OnHexWords2Bin
            Else_If  D@wParam = M00_Bin2HexDWords
               call OnBin2HexDWords
            Else_If  D@wParam = M00_HexDWords2Bin
               call OnHexDWords2Bin
            Else_If  D@wParam = M00_Bin2HexQWords
               call OnBin2HexQWords
            Else_If  D@wParam = M00_HexQWords2Bin
               call OnHexQWords2Bin
            Else_If  D@wParam = M00_Bin2HexOWords
               call OnBin2HexOWords
            Else_If  D@wParam = M00_HexOWords2Bin
               call OnHexOWords2Bin

            Else_If  D@wParam = M00_Base24Encode
               call OnBase24Encode
            Else_If  D@wParam = M00_Base24Decode
               call OnBase24Decode
            Else_If  D@wParam = M00_Base41Encode
               call OnBase41Encode
            Else_If  D@wParam = M00_Base41Decode
               call OnBase41Decode
            Else_If  D@wParam = M00_Base53Encode
               call OnBase53Encode
            Else_If  D@wParam = M00_Base53Decode
               call OnBase53Decode

            Else_If  D@wParam = M00_Base64Encode
               call OnBase64Encode
            Else_If  D@wParam = M00_Base64Decode
               call OnBase64Decode
            Else_If  D@wParam = M00_Base85Encode
               call OnBase85Encode
            Else_If  D@wParam = M00_Base85Decode
               call OnBase85Decode
            Else_If  D@wParam = M00_Base62Encode
               call OnBase62Encode
            Else_If  D@wParam = M00_Base62Decode
               call OnBase62Decode
            Else_If  D@wParam = M00_Base94Encode
               call OnBase94Encode
            Else_If  D@wParam = M00_Base94Decode
               call OnBase94Decode
            Else_If  D@wParam = M00_Base75Encode
               call OnBase75Encode
            Else_If  D@wParam = M00_Base75Decode
               call OnBase75Decode

            Else_If  D@wParam = M00_AnyBitsADD
               call OnAnyBitsADD
            Else_If  D@wParam = M00_AnyBitsADD32
               call OnAnyBitsAdd32Bit
            Else_If  D@wParam = M00_AnyBitsSUB
               call OnAnyBitsSUB
            Else_If  D@wParam = M00_AnyBitsSUB32
               call OnAnyBitsSub32Bit
            Else_If  D@wParam = M00_AnyBitsNEG
               call OnAnyBitsNEG
            Else_If  D@wParam = M00_AnyBitsNOT
               call OnAnyBitsNOT
            Else_If  D@wParam = M00_AnyBitsMULbin
               mov ebx doAnyBitsMULBinary
            Else_If  D@wParam = M00_AnyBitsMUL
               mov ebx doAnyBitsMUL
            Else_If  D@wParam = M00_AnyBitsMUL32
               call OnAnyBitsMul32Bit
            Else_If  D@wParam = M00_AnyBitsSQ2
               mov ebx doAnyBitsSQ2;AnyBitsSQ2Test;
            Else_If  D@wParam = M00_AnyBitsPOW
               mov ebx doAnyBitsPOW
            Else_If  D@wParam = M00_AnyBitsDIV
               mov ebx doAnyBitsDIV
            Else_If  D@wParam = M00_AnyBitsMOD
               mov ebx doAnyBitsMOD
            Else_If  D@wParam = M00_AnyBitsDIV32
               call OnAnyBitsDiv32Bit
            Else_If  D@wParam = M00_AnyBitsMOD32
               call OnAnyBitsMod32Bit
            Else_If  D@wParam = M00_AnyBitsSQRoot
               mov ebx doAnyBitsSquareRoot
            Else_If  D@wParam = M00_AnyBitsNRoot
               mov ebx doAnyBitsNRoot

            Else_If  D@wParam = M00_AnyBitsSHL
               call OnAnyBitsSHL
            Else_If  D@wParam = M00_AnyBitsSHR
               call OnAnyBitsSHR
            Else_If  D@wParam = M00_AnyBitsROL
               call OnAnyBitsROL
            Else_If  D@wParam = M00_AnyBitsROR
               call OnAnyBitsROR

            Else_If  D@wParam = M00_TestFunc0
               call onTestFunc0
            Else_If  D@wParam = M00_TestFunc1
               call onTestFunc1
            Else_If  D@wParam = M00_TestFunc2
               call onTestFunc2
            Else_If  D@wParam = M00_TestFunc3
               call onTestFunc3
            Else_If  D@wParam = M00_TestFunc4
               call onTestFunc4
            Else_If  D@wParam = M00_TestFunc5
               call onTestFunc5
            Else_If  D@wParam = M00_TestFunc6
               call onTestFunc6
            Else_If  D@wParam = M00_TestFunc7
               call onTestFunc7
            Else_If  D@wParam = M00_TestFunc8
               call onTestFunc8
            Else_If  D@wParam = M00_TestFunc9
               call onTestFunc9

            Else_If  D@wParam = M00_Undo
               call OnMenuUndo
            Else_If  D@wParam = M00_Cut
               call OnMenuCut
            Else_If  D@wParam = M00_Copy
               call OnMenuCopy
            Else_If  D@wParam = M00_Paste
               call OnMenuPaste
            Else_If  D@wParam = M00_Delete
               call OnMenuDelete
            Else_If  D@wParam = M00_Select_All
               call OnMenuSelectAll
            Else_If  D@wParam = M00_About
               call OnMenuAbout
            Else

            End_If

         TEST EBX EBX | je L0> | call TryStartFunctionInNewThread EBX
L0:
      Else
          call 'User32.DefWindowProcA' D@hWnd, D@Message, D@wParam, D@lParam
          ExitP

      .End_If
L9:
      mov eax &FALSE

EndP
______________________________________________________________________________________


Proc ClientRectSUBS:
 ARGUMENTS @HWnd
 Structure @RECT 16, @RECT_left 0,  @RECT_top 4,  @RECT_right 8,  @RECT_bottom 12
;DBGBP
    call 'USER32.SetWindowPos'  D@HWnd, &HWND_NOTOPMOST, 0,0, startX, startY, &SWP_NOMOVE
    call 'user32.GetClientRect', D@HWnd D@RECT
    mov eax startX | sub eax D@RECT_right | mov D$WndWsub eax
    mov edx startY | sub edx D@RECT_bottom | mov D$WndHsub edx
    add eax startX | add edx startY |  ;mov D$WndW eax, D$WndH edx
    call 'USER32.SetWindowPos'  D@HWnd, &HWND_NOTOPMOST, 0,0, eax, edx, &SWP_NOMOVE
;    call 'user32.GetClientRect', D@HWnd D@RECT
EndP


Proc OnSize:
 ARGUMENTS @wParam, @lParam
; Structure @RECT 16, @RECT_left 0,  @RECT_top 4,  @RECT_right 8,  @RECT_bottom 12
    pushad
;DBGBP
    mov eax D@lParam | mov W$ClientRectX ax | shr eax 16 | mov D$ClientRectY eax
    mov eax D@wParam
    IF eax = &SIZE_RESTORED

    Else_If eax = &SIZE_MINIMIZED
    Else_If eax = &SIZE_MAXIMIZED
    Else_If eax = &SIZE_MAXSHOW
    Else_If eax = &SIZE_MAXHIDE
    End_If
;;
    ;add eax D$WndWsub | add edx D$WndHsub
;    call WriteSizeToTitle
;;
L9: popad
EndP

Proc DesktopSZ:
 Structure @RECT 16, @RECT_left 0,  @RECT_top 4,  @RECT_right 8,  @RECT_bottom 12
    call 'user32.GetDesktopWindow'
    call 'user32.GetWindowRect', eax D@RECT | test eax eax | mov edx 0 | je P9>
    mov eax D@RECT_right, edx D@RECT_bottom
EndP

;;
AdjustWndSize:
    cmp B$winver 04 | ja L2> ; W9x limited in sizes
    cmp D$WndW 010000 | jb L2> | mov eax D$WndW, edx D$WndH | mul edx
    mov ecx 08000 | sub edx edx | div ecx | test edx edx | je L0> | inc eax
L0: mov D$WndW 08000, D$WndH eax
L2:
    call DesktopSZ | mov D$DesktW eax, D$DesktH edx
    sub eax D$WndWsub | sub edx D$WndHsub
    cmp D$WndW eax | jae D0> | mov eax D$WndW
D0: cmp D$WndH edx | jae D0> | mov edx D$WndH
D0: add eax D$WndWsub | add edx D$WndHsub
    call 'USER32.SetWindowPos'  D$WindowHandle, &HWND_NOTOPMOST, 0,0, eax, edx, &SWP_NOCOPYBITS
;    call WriteSizeToTitle
ret
;;

;EAX > Ticks spent
report:
pushad
cmp D$WindowHandle 0 | je L0>
mov edi WndSizeTitle | call Dword2Decimal edi eax | add edi eax | mov D$edi 'ms'
;call 'User32.SendMessageA', D$WindowHandle, &WM_SETTEXT, 0, WndSizeTitle
call 'User32.SendMessageA', D$EDIT0_handle, &WM_SETTEXT, 0, WndSizeTitle
L0: popad | ret

SetStartTick:
pushad
call GetTimeTick | mov D$curTick eax
popad | ret

SetEndTick:
pushad
call GetTimeTick | mov D$endTick eax
popad | ret

SetEndTickReport:
pushad
call GetTimeTick | sub eax D$curTick
call report
popad | ret
; Tag Dialog 20
; ****************************************
[<16 InputHEXNumDialog:
 D$ 090CC08C0                  ; Style
 D$ 0                          ; ExStyle
 U$ 02 0 0 072 02C             ; Dim
 0                             ;      no Menu
 '' 0                          ; Class
 'Input HEX' 0                 ; Title
 08 'Courier New' 0]                  ; Font

[InputHEXNumDEdt:
 D$ 050800001                  ; Style
 D$ 0                          ; ExStyle
 U$ 014 08 048 0C              ; Dim
 IDC_INEDIT                    ; ID
 0FFFF 081                     ; Class
 '0000000000000000' 0          ; Title
 0]                            ; No creation data

[InputHEXNumDBtn:
 D$ 050000000                  ; Style
 D$ 0                          ; ExStyle
 U$ 010 019 038 0F             ; Dim
 IDC_INBTN                     ; ID
 0FFFF 080                     ; Class
 'Enter' 0                     ; Title
 0]                            ; No creation data

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

; ****************************************
[<16 InputNum64Dialog:
D$ 090CC08C0                   ; Style
 D$ 0                          ; ExStyle
 U$ 02 0 0 07D 02C             ; Dim
 0                             ;      no Menu
 '' 0                          ; Class
 'Input 64bit number' 0        ; Title
 08 'Helv' 0]                  ; Font

[InputNum64DEdt:
 D$ 050802001                  ; Style
 D$ 0                          ; ExStyle
 U$ 012 08 057 0C              ; Dim
 03E9                          ; ID
 0FFFF 081                     ; Class
 '00000000000000000000' 0      ; Title
 0]                            ; No creation data

[InputNum64DBtn:
 D$ 050000000                  ; Style
 D$ 0                          ; ExStyle
 U$ 020 018 038 0F             ; Dim
 03EA                          ; ID
 0FFFF 080                     ; Class
 'Enter' 0                     ; Title
 0]                            ; No creation data

[<16 hINDlg: hINEdit: D$ 0 hINBtn: 0 InNumber: 0 InNumberHi64: 0
 ErrMsgCaption: B$ 'Input Numer Error',0 ErrMsgText: 'Input number from 1 to 4294967295',0  inputNumText: '0000000000',0,0
 ErrMsgText64: 'Input number from 1 to 2^64 -1',0 inputNumText64: '00000000000000000000',0,0
 ErrMsgHEX64: 'Input paired HEXa chars',0 inputHEXNumText: '0000000000000000',0,0 ]
 [IDC_INEDIT 1001 | IDC_INBTN 1002 ]

Proc InputHEXNumber:
    and D$InNumber 0 | and D$InNumberHi64 0
    call 'USER32.DialogBoxIndirectParamA' D$hInstance InputHEXNumDialog D$WindowHandle InputHEXNumDLGPROC 0
EndP

Proc InputHEXNumDLGPROC:
 Arguments @hDlg, @Message, @wParam, @lParam
  Uses ebx

 If D@message = &WM_COMMAND
    mov eax D@wParam
    cmp eax ( &BN_CLICKED shl 16 + IDC_INBTN ) | jne L0>
    call 'User32.SendMessageA' D$hINEdit &WM_GETTEXT 17 inputHEXNumText | mov ebx eax
    cmp ebx 16 | ja L1> | test ebx 1 | jne L1> | test ebx ebx | je L1>
    SHR eax 1
    call 'BaseCodecs.BaseHex2iBinaryDecode' InNumber eax inputHEXNumText ebx | test eax eax | je L1>
    mov eax D$InNumber | or eax D$InNumberHi64 | je L1>
    call 'User32.PostMessageA' D@hDlg &WM_CLOSE 0 0 | jmp L0>
L1: call 'User32.MessageBoxA' D@hDlg ErrMsgHEX64 ErrMsgCaption &MB_ICONWARNING
L0:
 Else_If D@message = &WM_INITDIALOG
   call 'User32.GetDlgItem', D@hDlg, IDC_INEDIT | mov D$hINEdit eax
   call 'User32.GetDlgItem', D@hDlg, IDC_INBTN | mov D$hINBtn eax
 Else_If D@message = &WM_CLOSE
   call 'USER32.EndDialog' D@hDlg 1
 Else
L8: mov eax &FALSE | ExitP
 End_If

L9: mov eax &TRUE
Endp

Proc Input32BitNumber:
    and D$InNumber 0 | and D$InNumberHi64 0
    call 'USER32.DialogBoxIndirectParamA' D$hInstance InputNum32Dialog D$WindowHandle InputNumDLGPROC 0
EndP

Proc InputNumDLGPROC:
 Arguments @hDlg, @Message, @wParam, @lParam
  Uses ebx

 If D@message = &WM_COMMAND
    mov eax D@wParam
    cmp eax ( &BN_CLICKED shl 16 + IDC_INBTN ) | jne L0>
    call 'User32.SendMessageA' D$hINEdit &WM_GETTEXT 11 inputNumText | mov ebx eax
    call TranslateDecimal2Dword inputNumText | cmp ecx ebx | jne L1> | cmp eax 0 | je L1>
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

Proc Input64BitNumber:
    and D$InNumber 0 | and D$InNumberHi64 0
    call 'USER32.DialogBoxIndirectParamA' D$hInstance InputNum64Dialog D$WindowHandle InputNum64DLGPROC 0
    mov eax D$InNumber, edx D$InNumberHi64
EndP

Proc InputNum64DLGPROC:
 Arguments @hDlg, @Message, @wParam, @lParam
  Uses ebx

 If D@message = &WM_COMMAND
    mov eax D@wParam
    cmp eax ( &BN_CLICKED shl 16 + IDC_INBTN ) | jne L0>
    call 'User32.SendMessageA' D$hINEdit &WM_GETTEXT 21 inputNumText64 | mov ebx eax
    call TranslateDecimal2Qword inputNumText64 | cmp ecx ebx | jne L1>
    mov D$InNumber eax, D$InNumberHi64 edx
    or eax edx | je L1>
    call 'User32.PostMessageA' D@hDlg &WM_CLOSE 0 0 | jmp L0>
L1: call 'User32.MessageBoxA' D@hDlg ErrMsgText64 ErrMsgCaption &MB_ICONWARNING
L0:
 Else_If D@message = &WM_INITDIALOG
   call 'User32.GetDlgItem', D@hDlg, IDC_INEDIT | mov D$hINEdit eax
   call 'User32.GetDlgItem', D@hDlg, IDC_INBTN | mov D$hINBtn eax
 Else_If D@message = &WM_CLOSE
   call 'USER32.EndDialog' D@hDlg 1
 Else
L8: mov eax &FALSE | ExitP
 End_If

L9: mov eax &TRUE
Endp


Proc reporters:

    mov eax D$JobReporterAddr | test eax eax | je P9>
    call eax

EndP


TITLE MenuFunctions
____________________________________________________________________________________________

[ updateBitSize | mov edx #1 | mov eax #2
    call 'AnyBits.GetEffectiveHighBitSz32' | mov #2 eax ]
[ updateByteSize | mov edx #1 | mov eax #2 | shl eax 3
    call 'AnyBits.GetEffectiveHighBitSz32' | shr eax 3 | mov #2 eax ]

OnMenuNew:
ret

OnMenuOpen:
Proc AlignPE:
  cLocal @infotxt @realigned @RelocsSorted @rlcp @rlcsz
  USES ebx esi edi

    call GetOpenFileName | test eax eax | je P9>>
DBGBP
    call 'BaseRTL.GetTime'
    push 0,'.txt',0,0 | mov edx esp
    call 'BaseCodecs.D2H' edx eax
    mov edx esp
    call 'BaseRTL.FileNameACreateWrite' edx &TRUE | test eax eax | je P9>>
    mov D@infotxt eax

    call MapExeInit bufff D$pOFileName1 | test eax eax | jne L9>>
    mov D@realigned edx, ebx ecx
    mov D$esp+08 '.dmp'
    mov edx esp
    call 'BaseRTL.WriteMem2FileNameA' edx D@realigned ebx ;| add esp 010

    call Exports2DummySource D@realigned ebx | test eax eax | je L0>
    mov edi eax
    call 'BaseRTL.WriteMem2FileHandle' D@infotxt edi edx
    call VFree edi
L0:
    mov edi D@realigned | add edi D$edi+ExeProps_e_lfanewDis
    mov edx D$edi+OptionalHeader.DataDirectoryBaseRelocationSizeDis
    mov edi D$edi+OptionalHeader.DataDirectoryBaseRelocationDis
    test edi edi | jle L9>> | test edx edx | jle L9>> | cmp ebx edx | jbe L9>>
    add edi D@realigned | mov D@rlcp edi, D@rlcsz edx
    call ScanRelocation D@rlcp D@rlcsz ebx | test eax eax | je L9>>
push eax edi
    push 0 0 0 0 'CSN:','RELO'
    lea edx D$esp+08
    call Dword2Decimal edx eax | mov edi esp | add edi 08 | add edi eax
    mov ax 0A0A | STOSW
    sub edi esp
    mov edx esp
    call 'BaseRTL.WriteMem2FileHandle' D@infotxt edx edi | add esp 018
pop edi eax
    lea eax D$eax*4+010
    call 'BaseRTL.VAlloc' eax | mov D@RelocsSorted eax | test eax eax | je L9>
    call BuildRVAPointersFromReloc D@RelocsSorted D@rlcp D@rlcsz | mov edi eax
    call DualBubbleSortDWORDs D@RelocsSorted, edi
    call VFree D@realigned | and D@realigned 0

    mov eax 0A | MUL edi
    call VAlloc eax | test eax eax | je L9>
    mov ebx eax, D@realigned eax
    mov esi D@RelocsSorted
    CLD
L0: LODSD
    call 'BaseCodecs.D2H' ebx eax | mov W$ebx+8 CRLF | add ebx 0A | dec edi | jne L0<
    sub ebx D@realigned
    call 'BaseRTL.WriteMem2FileHandle' D@infotxt D@realigned ebx
L9:
    call VFree D@RelocsSorted
    call VFree D@realigned
    call 'BaseRTL.CloseFlushHandle' D@infotxt
Endp

OnMenuSave:
ret

OnMenuSaveAs:
call GetSaveFileName
ret

OnMenuUndo:
ret

OnMenuCut:
ret

OnMenuCopy:
ret

OnMenuPaste:
ret

OnMenuDelete:
ret

OnMenuSelectAll:
ret

Proc OnMenuRelocateExecutable:
 cLocal @hMap @fsz
    call GetOpenFileName | test eax eax | je P9>>
    call GetSaveFileName | test eax eax | je P9>>
DBGBP
    call 'BaseRTL.CopyFile' D$pSFileName1 D$pOFileName1 | cmp eax &FALSE | je P9>
    call 'BaseRTL.FileNameMapRW', D$pSFileName1 | test eax eax | je P9>
    mov D@hMap eax, D@fsz ecx
    call isStandartValidMZPE D@hMap D@fsz | test eax eax | jne L8>
    mov eax inputHEXNumText, D$eax '0101', D$eax+4 '0000', D$eax+8 0, D$InNumber 01010000
    call InputHEXNumber D$InNumber
    call RelocateEXEfile D@hMap D$InNumber
L8: call 'BaseRTL.FileMapClose' D@hMap
EndP

Proc OnBuildRelocFromPointers:
 cLocal @hMap @nPtrs, @RLCmem, @RLCmemsz
;DBGBP
    call ChooseAndLoadFileA | test eax eax | je P9>
    shr edx 2 | mov D@hMap eax, D@nPtrs edx
    call DualBubbleSortDWORDs D@hMap, D@nPtrs
    call BuildRelocFromSortedPointers 010000000, D@hMap, D@nPtrs | mov D@RLCmem eax, D@RLCmemsz edx
    cmp D@RLCmem 0 | je P9>
    call ChooseAndSaveFileA D@RLCmem, D@RLCmemsz ;| test eax eax | je P9>
    ;call BuildRVAPointersFromReloc D@hMap, D@RLCmem, D@RLCmemsz
    call VFree D@RLCmem
    call VFree D@hMap
EndP

Proc OnCopyDamagedFile:
    call GetOpenFileName | test eax eax | je P9>
    call GetSaveFileName | test eax eax | je P9>
    call 'User32.ShowWindow' D$WindowHandle, &SW_HIDE
    call CopyDamagedFile D$pSFileName1 D$pOFileName1
    call 'User32.ShowWindow' D$WindowHandle, &SW_SHOW
EndP


Proc OnRtlDecompress:
    call GetOpenFileName | test eax eax | je P9>
    call GetSaveFileName | test eax eax | je P9>
    call 'User32.ShowWindow' D$WindowHandle, &SW_HIDE
    call RtlDecompress D$pSFileName1 D$pOFileName1
    call 'User32.ShowWindow' D$WindowHandle, &SW_SHOW
EndP



Proc OnBin2Hex:
 cLocal @outSz @outMem @inSz @inMem

    call ChooseAndLoadFileA | test eax eax | je P9>
    mov D@inMem eax, D@inSz edx
    shl edx 1
    mov D@outSz edx
    call VAlloc D@outSz | mov D@outMem eax | test eax eax | je @BM

    call 'BaseCodecs.Binary2HexA' D@outMem D@inMem D@inSz | mov D@outSz eax

    call ChooseAndSaveFileA D@outMem D@outSz
@BM:
    call VFree D@outMem | call VFree D@inMem
EndP

Proc OnHex2Bin:
 cLocal @outSz @outMem @inSz @inMem

    call ChooseAndLoadFileA | test eax eax | je P9>
    mov D@inMem eax, D@inSz edx
    shr edx 1
    mov D@outSz edx
    call VAlloc D@outSz | mov D@outMem eax | test eax eax | je @BM

    call 'BaseCodecs.BaseHEXA2BinaryDecode' D@outMem D@inMem D@inSz | mov D@outSz eax

    call ChooseAndSaveFileA D@outMem D@outSz
@BM:
    call VFree D@outMem | call VFree D@inMem
EndP
;
;
Proc OnBin2HexBytes:
 cLocal @outSz @outMem @inSz @inMem
 USES ESI EDI

    call ChooseAndLoadFileA | test eax eax | je P9>
    mov D@inMem eax, D@inSz edx
    mov eax 3 | mul edx | jc @BM
    mov D@outSz eax
    call VAlloc D@outSz | mov D@outMem eax | test eax eax | je @BM
;Binary2HexA
    mov ecx D@inSz | mov esi D@inMem | mov edi D@outMem
    sub eax eax
    cld
B0:
    lodsb | mov ah al | shr al 04 | and ah 0F | or eax 03030
    cmp al 03A | jb B1> | add al 07
B1:
    cmp ah 03A | jb B1> | add ah 07
B1:
    stosw | mov al 020 | stosb | dec ecx | jne B0<
    mov eax edi | sub eax D@outMem

    mov D@outSz eax

    call ChooseAndSaveFileA D@outMem D@outSz
@BM:
    call VFree D@outMem | call VFree D@inMem
EndP
;
OnHexBytes2Bin: jmp OnHex2Bin ;******************************
;
;
Proc OnBin2HexWords:
 cLocal @outSz @outMem @inSz @inMem
 USES EBX ESI EDI

    call ChooseAndLoadFileA | test eax eax | je P9>
    mov D@inMem eax | and edx 0-2 | mov D@inSz edx ; cut if last odd byte
    mov eax 5 | mul edx | jc @BM
    mov D@outSz eax
    call VAlloc D@outSz | mov D@outMem eax | test eax eax | je @BM

    cld
    mov esi D@inMem | mov edi D@outMem | mov ebx D@inSz | jmp L0>

B0: call 'BaseCodecs.iBin2HexA'
    mov al 020 | stosb
    add esi 2
L0:
    mov ecx 2 | sub ebx 2 | jge b0<
    mov eax edi | sub eax D@outMem

    mov D@outSz eax

    call ChooseAndSaveFileA D@outMem D@outSz
@BM:
    call VFree D@outMem | call VFree D@inMem
EndP
;
Proc OnHexWords2Bin:
 cLocal @outSz @outMem @inSz @inMem

    call ChooseAndLoadFileA | test eax eax | je P9>
    mov D@inMem eax, D@inSz edx
    shr edx 1
    mov D@outSz edx
    call VAlloc D@outSz | mov D@outMem eax | test eax eax | je @BM

    call 'BaseCodecs.BaseHex2iBinaryDecode' D@outMem 2 D@inMem D@inSz | mov D@outSz eax

    call ChooseAndSaveFileA D@outMem D@outSz
@BM:
    call VFree D@outMem | call VFree D@inMem
EndP
;
;
Proc OnBin2HexDwords:
 cLocal @outSz @outMem @inSz @inMem
 USES EBX ESI EDI

    call ChooseAndLoadFileA | test eax eax | je P9>
    mov D@inMem eax | and edx 0-4 | mov D@inSz edx ; cut if last bytes
    mov eax 9 | mul edx | jc @BM
    mov D@outSz eax
    call VAlloc D@outSz | mov D@outMem eax | test eax eax | je @BM

    cld
    mov esi D@inMem | mov edi D@outMem | mov ebx D@inSz | jmp L0>

B0: call 'BaseCodecs.iBin2HexA'
    mov al 020 | stosb
    add esi 4
L0:
    mov ecx 4 | sub ebx 4 | jge b0<
    mov eax edi | sub eax D@outMem

    mov D@outSz eax
    call ChooseAndSaveFileA D@outMem D@outSz
@BM:
    call VFree D@outMem | call VFree D@inMem
EndP

Proc OnHexDwords2Bin:
 cLocal @outSz @outMem @inSz @inMem

    call ChooseAndLoadFileA | test eax eax | je P9>
    mov D@inMem eax, D@inSz edx
    shr edx 1
    mov D@outSz edx
    call VAlloc D@outSz | mov D@outMem eax | test eax eax | je @BM

    call 'BaseCodecs.BaseHex2iBinaryDecode' D@outMem 4 D@inMem D@inSz | mov D@outSz eax

    call ChooseAndSaveFileA D@outMem D@outSz
@BM:
    call VFree D@outMem | call VFree D@inMem
EndP
;
;
Proc OnBin2HexQwords:
 cLocal @outSz @outMem @inSz @inMem
 USES EBX ESI EDI

    call ChooseAndLoadFileA | test eax eax | je P9>
    mov D@inMem eax | and edx 0-8 | mov D@inSz edx ; cut if last bytes
    mov eax 17 | mul edx | jc @BM
    mov D@outSz eax
    call VAlloc D@outSz | mov D@outMem eax | test eax eax | je @BM

    cld
    mov esi D@inMem | mov edi D@outMem | mov ebx D@inSz | jmp L0>

B0: call 'BaseCodecs.iBin2HexA'
    mov al 020 | stosb
    add esi 8
L0:
    mov ecx 8 | sub ebx 8 | jge b0<
    mov eax edi | sub eax D@outMem

    mov D@outSz eax
    call ChooseAndSaveFileA D@outMem D@outSz
@BM:
    call VFree D@outMem | call VFree D@inMem
EndP

Proc OnHexQwords2Bin:
 cLocal @outSz @outMem @inSz @inMem

    call ChooseAndLoadFileA | test eax eax | je P9>
    mov D@inMem eax, D@inSz edx
    shr edx 1
    mov D@outSz edx
    call VAlloc D@outSz | mov D@outMem eax | test eax eax | je @BM

    call 'BaseCodecs.BaseHex2iBinaryDecode' D@outMem 8 D@inMem D@inSz | mov D@outSz eax

    call ChooseAndSaveFileA D@outMem D@outSz
@BM:
    call VFree D@outMem | call VFree D@inMem
EndP
;
;
Proc OnBin2HexOwords:
 cLocal @outSz @outMem @inSz @inMem
 USES EBX ESI EDI

    call ChooseAndLoadFileA | test eax eax | je P9>
    mov D@inMem eax | and edx 0-16 | mov D@inSz edx ; cut if last bytes
    mov eax 33 | mul edx | jc @BM
    mov D@outSz eax
    call VAlloc D@outSz | mov D@outMem eax | test eax eax | je @BM

    cld
    mov esi D@inMem | mov edi D@outMem | mov ebx D@inSz | jmp L0>

B0: call 'BaseCodecs.iBin2HexA'
    mov al 020 | stosb
    add esi 16
L0:
    mov ecx 16 | sub ebx 16 | jge b0<
    mov eax edi | sub eax D@outMem

    mov D@outSz eax
    call ChooseAndSaveFileA D@outMem D@outSz
@BM:
    call VFree D@outMem | call VFree D@inMem
EndP

Proc OnHexOwords2Bin:
 cLocal @outSz @outMem @inSz @inMem

    call ChooseAndLoadFileA | test eax eax | je P9>
    mov D@inMem eax, D@inSz edx
    shr edx 1
    mov D@outSz edx
    call VAlloc D@outSz | mov D@outMem eax | test eax eax | je @BM

    call 'BaseCodecs.BaseHex2iBinaryDecode' D@outMem 16 D@inMem D@inSz | mov D@outSz eax

    call ChooseAndSaveFileA D@outMem D@outSz
@BM:
    call VFree D@outMem | call VFree D@inMem
EndP
;
;
____________________________________________________________________________________________
;
;
Proc doBin2Dec:
 cLocal @outSz @outMem @inSz @inMem

    call ChooseAndLoadFileA | test eax eax | je P9>
    mov D@inMem eax, D@inSz edx

    mov eax edx | sub edx edx | mov ecx 12 | div ecx | inc eax | mov edx 29 | mul edx | jc @BM
    mov D@outSz eax
    call VAlloc D@outSz | mov D@outMem eax | test eax eax | je @BM

call SetStartTick
;RDTSC | push edx, eax
    mov eax D@inSz | ALIGN_ON 4 eax | shl eax 3
    call 'BaseCodecs.AnyBits2DecimalF9x', D@outMem, D@inMem, eax | test eax eax | je @BM
    mov D@outSz eax
;RDTSC | pop ecx | sub eax ecx | pop ecx | sbb edx ecx | push edx, eax | DBGBP
call SetEndTickReport

    call ChooseAndSaveFileA D@outMem D@outSz
@BM:
    call VFree D@outMem | call VFree D@inMem
EndP


Proc doDec2Bin:
 cLocal @outSz @outMem @inSz @inMem

    call ChooseAndLoadFileA | test eax eax | je P9>>
    mov D@inMem eax, D@inSz edx

    mov eax edx, edx 5, ecx 12 | mul edx | div ecx | test edx edx | je L0> | inc eax
L0:
    ALIGN_ON 4 eax
    mov D@outSz eax
    call VAlloc D@outSz | mov D@outMem eax | test eax eax | je @BM

call SetStartTick
    mov eax D@outSz | shl eax 3
    call 'BaseCodecs.AnyDecimal2BitsF9x', D@outMem, eax, D@inMem | test eax eax | je @BM
    SHR eax 3 | mov D@outSz eax
call SetEndTickReport

    call ChooseAndSaveFileA D@outMem D@outSz
@BM:
    call VFree D@outMem | call VFree D@inMem
EndP


Proc doRationalDecimal2RationalBits:
 cLocal @outSz @outMem @inSz @inMem

    call ChooseAndLoadFileA | test eax eax | je P9>>
    mov D@inMem eax, D@inSz edx
DBGBP
    mov eax edx, edx 5, ecx 12 | mul edx | div ecx | adc eax 4
L0:
    ALIGN_ON 4 eax
    mov D@outSz eax
L1: call VAlloc D@outSz | mov D@outMem eax | test eax eax | je @BM

call SetStartTick
    mov eax D@outSz | shl eax 3
    call 'BaseCodecs.AnyRationalDecimal2RationalBits'  D@outMem, eax, D@inMem | test eax eax | jne L0>
    inc ecx | jne @BM | call VFree D@outMem | add D@outSz 16 | jmp L1<
L0:
    mov D@outSz eax | add D@outSz edx | SHR D@outSz 3
call SetEndTickReport

    call ChooseAndSaveFileA D@outMem D@outSz
@BM:
    call VFree D@outMem | call VFree D@inMem
EndP
;
;
Proc doRationalBits2RationalDecimal:
 cLocal @outSz @outMem @inSz @inMem
 USES ebx

    call ChooseAndLoadFileA | test eax eax | je P9>>
    mov D@inMem eax, D@inSz edx
DBGBP
L2: call Input32BitNumber | test eax eax | mov ebx eax | je L0>
    test ebx 01F | jne L2<
L0:

    mov eax D@inSz | sub edx edx | mov ecx 12 | div ecx | inc eax | mov edx 29 | mul edx | jc @BM
L0:
    ALIGN_ON 4 eax
L1: mov D@outSz eax
    call VAlloc D@outSz | mov D@outMem eax | test eax eax | je @BM
call SetStartTick
    mov eax D@inSz | SHL eax 3 | sub eax ebx
    call 'BaseCodecs.AnyRationalBits2RationalDecimal' D@outMem D@inMem eax ebx | test eax eax | jne L0>
    inc ecx | jne @BM | call VFree D@outMem | add D@outSz 16 | jmp L1<
L0: mov D@outSz eax
call SetEndTickReport

    call ChooseAndSaveFileA D@outMem D@outSz
@BM:
    call VFree D@outMem | call VFree D@inMem
EndP
;
;
Proc OnBytes2Decimals:
 cLocal @outSz @outMem @inSz @inMem @inMemEnd
 USES ESI EDI

    call ChooseAndLoadFileA | test eax eax | je P9>
    mov D@inMem eax, D@inSz edx | add eax edx | mov D@inMemEnd eax
    mov eax 4 | mul edx | jc @BM
    mov D@outSz eax
    call VAlloc D@outSz | mov D@outMem eax | test eax eax | je @BM

    CLD | mov edi D@outMem, esi D@inMem | jmp L1>
L0: movzx eax B$esi | add esi 1
    call DwordReg2Decimal edi
    add edi eax | mov al 020 | stosb
L1: cmp esi D@inMemEnd | jb L0<

    sub edi D@outMem | mov D@outSz edi
    call ChooseAndSaveFileA D@outMem D@outSz
@BM:
    call VFree D@outMem | call VFree D@inMem
EndP

Proc OnDecimals2Bytes:
 cLocal @outSz @outMem @inSz @inMem
 USES EBX ESI EDI

    call ChooseAndLoadFileA | test eax eax | je P9>>
    mov D@inMem eax, D@inSz edx
    call CountDecimalNumbersInText D@inMem D@inSz | test eax eax | je @BM

    mov D@outSz eax
    call VAlloc D@outSz | mov D@outMem eax | test eax eax | je @BM

    mov edi D@outMem, esi D@inMem, ebx D@inSz
    add ebx esi

    dec esi
;seek number
L0: inc esi | cmp esi ebx | jae L1>
    movzx eax B$esi | sub eax 030 | cmp eax 9 | ja L0<

    call TranslateDecimal2Dword esi | cmp ecx 0-1 | je L1> | add esi ecx
    cmp eax 0FF | ja L1>
    mov B$edi al | add edi 1 | jmp L0<
L1: mov eax edi | sub eax D@outMem
    mov D@outSz eax
    call ChooseAndSaveFileA D@outMem D@outSz
@BM:
    call VFree D@outMem | call VFree D@inMem
EndP
;
;
Proc OnWords2Decimals:
 cLocal @outSz @outMem @inSz @inMem @inMemEnd
 USES ESI EDI

    call ChooseAndLoadFileA | test eax eax | je P9>
    mov D@inMem eax | and edx 0-2 | mov D@inSz edx ; cut if last bytes
    add eax edx | mov D@inMemEnd eax
    mov eax 6 | mul edx | jc @BM
    mov D@outSz eax
    call VAlloc D@outSz | mov D@outMem eax | test eax eax | je @BM

    CLD | mov edi D@outMem, esi D@inMem | jmp L1>
L0: movzx eax W$esi | add esi 2
    call DwordReg2Decimal edi
    add edi eax | mov al 020 | stosb
L1: cmp esi D@inMemEnd | jb L0<

    sub edi D@outMem | mov D@outSz edi
    call ChooseAndSaveFileA D@outMem D@outSz
@BM:
    call VFree D@outMem | call VFree D@inMem
EndP

Proc OnDecimals2Words:
 cLocal @outSz @outMem @inSz @inMem
 USES EBX ESI EDI

    call ChooseAndLoadFileA | test eax eax | je P9>>
    mov D@inMem eax, D@inSz edx
    call CountDecimalNumbersInText D@inMem D@inSz | test eax eax | je @BM
    mov edx 2 | mul edx | jc @BM
    mov D@outSz eax
    call VAlloc D@outSz | mov D@outMem eax | test eax eax | je @BM

    mov edi D@outMem, esi D@inMem, ebx D@inSz
    add ebx esi

    dec esi
;seek number
L0: inc esi | cmp esi ebx | jae L1>
    movzx eax B$esi | sub eax 030 | cmp eax 9 | ja L0<

    call TranslateDecimal2Dword esi | cmp ecx 0-1 | je L1> | add esi ecx
    cmp eax 0FFFF | ja L1>
    mov W$edi ax | add edi 2 | jmp L0<
L1: mov eax edi | sub eax D@outMem
    mov D@outSz eax
    call ChooseAndSaveFileA D@outMem D@outSz
@BM:
    call VFree D@outMem | call VFree D@inMem
EndP
;
;
Proc OnDwords2Decimals:
 cLocal @outSz @outMem @inSz @inMem @inMemEnd
 USES ESI EDI

    call ChooseAndLoadFileA | test eax eax | je P9>>
    mov D@inMem eax | and edx 0-4 | mov D@inSz edx ; cut if last bytes
    add eax edx | mov D@inMemEnd eax
    mov eax 11 | mul edx | jc @BM
    mov D@outSz eax
    call VAlloc D@outSz | mov D@outMem eax | test eax eax | je @BM

    CLD | mov edi D@outMem, esi D@inMem | jmp L1>
L0: LODSD
    call DwordReg2Decimal edi
    add edi eax | mov al 020 | stosb
L1: cmp esi D@inMemEnd | jb L0<

    sub edi D@outMem | mov D@outSz edi
    call ChooseAndSaveFileA D@outMem D@outSz
@BM:
    call VFree D@outMem | call VFree D@inMem
EndP

Proc OnDecimals2Dwords:
 cLocal @outSz @outMem @inSz @inMem
 USES EBX ESI EDI

    call ChooseAndLoadFileA | test eax eax | je P9>>
    mov D@inMem eax, D@inSz edx
    call CountDecimalNumbersInText D@inMem D@inSz | test eax eax | je @BM
    mov edx 4 | mul edx | jc @BM
    mov D@outSz eax
    call VAlloc D@outSz | mov D@outMem eax | test eax eax | je @BM

    mov edi D@outMem, esi D@inMem, ebx D@inSz
    add ebx esi

    dec esi
;seek number
L0: inc esi | cmp esi ebx | jae L1>
    movzx eax B$esi | sub eax 030 | cmp eax 9 | ja L0<

    call TranslateDecimal2Dword esi | cmp ecx 0-1 | je L1> | add esi ecx
    mov D$edi eax | add edi 4 | jmp L0<
L1: mov eax edi | sub eax D@outMem
    mov D@outSz eax
    call ChooseAndSaveFileA D@outMem D@outSz
@BM:
    call VFree D@outMem | call VFree D@inMem
EndP
;
;
Proc OnQwords2Decimals:
 cLocal @outSz @outMem @inSz @inMem @inMemEnd ;@CurInMem @CurOoutMem
 USES ESI EDI

    call ChooseAndLoadFileA | test eax eax | je P9>>
    mov D@inMem eax | and edx 0-8 | mov D@inSz edx ; cut if last bytes
    add eax edx | mov D@inMemEnd eax
    shr edx 3 | mov eax 21 | mul edx | jc @BM
    mov D@outSz eax
    call VAlloc D@outSz | mov D@outMem eax | test eax eax | je @BM

    CLD | mov edi D@outMem, esi D@inMem | jmp L1>
L0: mov eax D$esi, edx D$esi+4 | add esi 8
    call QwordReg2Decimal edi
    add edi eax | mov al 020 | stosb
L1: cmp esi D@inMemEnd | jb L0<

    sub edi D@outMem | mov D@outSz edi
    call ChooseAndSaveFileA D@outMem D@outSz
@BM:
    call VFree D@outMem | call VFree D@inMem
EndP

Proc OnDecimals2Qwords:
 cLocal @outSz @outMem @inSz @inMem
 USES EBX ESI EDI

    call ChooseAndLoadFileA | test eax eax | je P9>>
    mov D@inMem eax, D@inSz edx
    call CountDecimalNumbersInText D@inMem D@inSz | test eax eax | je @BM
    mov edx 8 | mul edx | jc @BM
    mov D@outSz eax
    call VAlloc D@outSz | mov D@outMem eax | test eax eax | je @BM

    mov edi D@outMem, esi D@inMem, ebx D@inSz
    add ebx esi

    dec esi
;seek number
L0: inc esi | cmp esi ebx | jae L1>
    movzx eax B$esi | sub eax 030 | cmp eax 9 | ja L0<

    call TranslateDecimal2Qword esi | cmp ecx 0-1 | je L1> | add esi ecx
    mov D$edi eax, D$edi+4 edx | add edi 8 | jmp L0<
L1: mov eax edi | sub eax D@outMem
    mov D@outSz eax
    call ChooseAndSaveFileA D@outMem D@outSz
@BM:
    call VFree D@outMem | call VFree D@inMem
EndP
;
;
Proc OnOwords2Decimals:
 cLocal @outSz @outMem @inSz @inMem @inMemEnd ;@CurInMem @CurOoutMem
 USES ESI EDI

    call ChooseAndLoadFileA | test eax eax | je P9>>
    mov D@inMem eax | and edx 0-16 | mov D@inSz edx ; cut if last bytes
    add eax edx | mov D@inMemEnd eax
    shr edx 4 | mov eax 40 | mul edx | jc @BM
    mov D@outSz eax
    call VAlloc D@outSz | mov D@outMem eax | test eax eax | je @BM

    mov edi D@outMem, esi D@inMem | jmp L1>
L0: call 'BaseCodecs.AnyBits2Decimal' edi esi 128 | test eax eax | je @BM
    add edi eax | mov B$edi 020 | inc edi | add esi 16
L1: cmp esi D@inMemEnd | jb L0<

    sub edi D@outMem | mov D@outSz edi
    call ChooseAndSaveFileA D@outMem D@outSz
@BM:
    call VFree D@outMem | call VFree D@inMem
EndP

Proc OnDecimals2Owords:
 cLocal @outSz @outMem @inSz @inMem
 USES EBX ESI EDI

    call ChooseAndLoadFileA | test eax eax | je P9>>
    mov D@inMem eax, D@inSz edx
    call CountDecimalNumbersInText D@inMem D@inSz
    mov edx 16 | mul edx | jc @BM
    mov D@outSz eax
    call VAlloc D@outSz | mov D@outMem eax | test eax eax | je @BM

    mov edi D@outMem, esi D@inMem, ebx D@inSz
    add ebx esi

    dec esi
;seek number
L0: inc esi | cmp esi ebx | jae L1>
    movzx eax B$esi | sub eax 030 | cmp eax 9 | ja L0<

    call 'BaseCodecs.AnyDecimal2Bits' edi 128 esi | test eax eax | je L1>
    add edi 16 | add esi ecx | jmp L0<
L1: mov eax edi | sub eax D@outMem
    mov D@outSz eax
    call ChooseAndSaveFileA D@outMem D@outSz
@BM:
    call VFree D@outMem | call VFree D@inMem
EndP
;
;
__________________________________________________________________________________________________________________________________________

; BIG MATH
Proc OnAnyBitsADD:
 cLocal @inSz1 @inMem1 @inSz2 @inMem2 @outSz @outMem

    call ChooseAndLoadFileA | test eax eax | je P9>>
    ALIGN_ON 4 edx
    mov D@inMem1 eax, D@inSz1 edx
    call ChooseAndLoadFileA | test eax eax | je P9>>
    ALIGN_ON 4 edx
    mov D@inMem2 eax, D@inSz2 edx
DBGBP
    updateByteSize D@inMem1 D@inSz1
    updateByteSize D@inMem2 D@inSz2

    mov eax D@inSz1 | mov edx D@inSz2 | cmp eax edx | jae L0> | mov eax edx
L0: add eax 4 | mov D@outSz eax
    call VAlloc D@outSz | mov D@outMem eax | test eax eax | je @BM

    mov eax D@inSz1, edx D@inSz2, ecx D@outSz
    shl eax 3 | shl edx 3 | shl ecx 3
    call 'AnyBits.AnyBitsAddition' D@outMem ecx D@inMem2 edx D@inMem1 eax | test eax eax | je @BM
    call ChooseAndSaveFileA D@outMem D@outSz
@BM:
    call VFree D@outMem | call VFree D@inMem1 | call VFree D@inMem2
EndP
;
;
Proc OnAnyBitsSUB:
 cLocal @inSz1 @inMem1 @inSz2 @inMem2 @outSz @outMem

    call ChooseAndLoadFileA | test eax eax | je P9>>
    ALIGN_ON 4 edx
    mov D@inMem1 eax, D@inSz1 edx
    call ChooseAndLoadFileA | test eax eax | je @BM
    ALIGN_ON 4 edx
    mov D@inMem2 eax, D@inSz2 edx
DBGBP
    updateByteSize D@inMem2 D@inSz2

    cmp D@inSz1 eax | jb @BM
    move D@outSz D@inSz1
    call VAlloc D@outSz | mov D@outMem eax | test eax eax | je @BM

    mov eax D@inSz1, edx D@inSz2, ecx D@outSz
    shl eax 3 | shl edx 3 | shl ecx 3
    call 'AnyBits.AnyBitsSubstraction' D@outMem ecx D@inMem2 edx D@inMem1 eax | test eax eax | je @BM
    call ChooseAndSaveFileA D@outMem D@outSz
@BM:
    call VFree D@outMem | call VFree D@inMem1 | call VFree D@inMem2
EndP
;
;
Proc OnAnyBitsNEG:
 cLocal @inSz1 @inMem1

    call ChooseAndLoadFileA | test eax eax | je P9>
    ALIGN_ON 4 edx
    mov D@inMem1 eax, D@inSz1 edx
DBGBP
    mov eax D@inSz1 | shl eax 3
    call 'AnyBits.AnyBitsNegate' D@inMem1 eax | test eax eax | je @BM
    call ChooseAndSaveFileA D@inMem1 D@inSz1
@BM:
    call VFree D@inMem1
EndP
;
;
Proc OnAnyBitsNOT:
 cLocal @inSz1 @inMem1

    call ChooseAndLoadFileA | test eax eax | je P9>
    mov D@inMem1 eax, D@inSz1 edx
DBGBP
    mov eax D@inSz1 | shl eax 3
    call 'AnyBits.AnyBitsNot' D@inMem1 eax | test eax eax | je @BM
    call ChooseAndSaveFileA D@inMem1 D@inSz1
@BM:
    call VFree D@inMem1
EndP
;
;
Proc doAnyBitsMULBinary:
 cLocal @inSz1 @inMem1 @inSz2 @inMem2 @outSz @outMem

    call ChooseAndLoadFileA | test eax eax | je P9>>
    ALIGN_ON 4 edx
    mov D@inMem1 eax, D@inSz1 edx
    call ChooseAndLoadFileA | test eax eax | je @BM
    ALIGN_ON 4 edx
    mov D@inMem2 eax, D@inSz2 edx

    updateByteSize D@inMem1 D@inSz1
    updateByteSize D@inMem2 D@inSz2

    mov eax D@inSz1 | add eax D@inSz2 | mov D@outSz eax
    call VAlloc D@outSz | mov D@outMem eax | test eax eax | je @BM
DBGBP
call SetStartTick
    mov eax D@inSz1, edx D@inSz2, ecx D@outSz
    shl eax 3 | shl edx 3 | shl ecx 3
    call 'AnyBits.AnyBitsMultiplicationBinary' D@outMem ecx D@inMem2 edx D@inMem1 eax | test eax eax | je @BM ;
call SetEndTickReport
    updateByteSize D@outMem D@outSz
    call ChooseAndSaveFileA D@outMem D@outSz
@BM:
    call VFree D@outMem | call VFree D@inMem1 | call VFree D@inMem2
EndP
;
[krtsbMin 0280]
[krtsbMinMul 03C00]
;
Proc doAnyBitsMUL:
 cLocal @inSz1 @inMem1 @inSz2 @inMem2 @outSz @outMem
 USES edi
    call ChooseAndLoadFileA | test eax eax | je P9>>
    ALIGN_ON 4 edx
    mov D@inMem1 eax, D@inSz1 edx
    call ChooseAndLoadFileA | test eax eax | je @BM
    ALIGN_ON 4 edx
    mov D@inMem2 eax, D@inSz2 edx
DBGBP
    updateByteSize D@inMem1 D@inSz1
    updateByteSize D@inMem2 D@inSz2

    mov eax D@inSz1 | cmp eax D@inSz2 | jae L0>
    EXCHANGE D@inMem1 D@inMem2, D@inSz1 D@inSz2
L0:
    mov eax D@inSz2 | cmp eax krtsbMinMul | jbe L1>
;;
    mov edx D@inSz1 | mov eax 01000
L0: cmp eax edx | jae L0> | shl eax 1 | jmp L0<
L0: je L0>
    call 'BaseRTL.ReAllocMemory' D@inMem1 D@inSz1 eax | test eax eax | je @BM
    mov D@inMem1 eax | mov D@inSz1 edx
;;
L0: call 'BaseRTL.ReAllocMemory' D@inMem2 D@inSz2 D@inSz1 | test eax eax | je @BM
    mov D@inMem2 eax | mov D@inSz2 edx

L1: mov eax D@inSz1 | add eax D@inSz2 | mov D@outSz eax
    call VAlloc D@outSz | mov D@outMem eax | test eax eax | je @BM
call SetStartTick
    mov eax D@inSz1, edx D@inSz2, ecx D@outSz
    shl eax 3 | shl edx 3 | shl ecx 3
    call 'AnyBits.AnyBitsMultiplication' D@outMem ecx D@inMem2 edx D@inMem1 eax | test eax eax | je @BM
call SetEndTickReport
    updateByteSize D@outMem D@outSz
    call ChooseAndSaveFileA D@outMem D@outSz
@BM:
    call VFree D@outMem | call VFree D@inMem1 | call VFree D@inMem2
EndP
;
;
Proc doAnyBitsSQ2:
 cLocal @inSz @inMem @outSz @outMem

    call ChooseAndLoadFileA | test eax eax | je P9>>
    ALIGN_ON 4 edx
    mov D@inMem eax, D@inSz edx
DBGBP
    updateByteSize D@inMem D@inSz
;;
    mov edx D@inSz | cmp edx krtsbMinMul | jmp L1>
    mov eax 01000
L0: cmp eax edx | jae L0> | shl eax 1 | jmp L0<
L0: je L1>
    call 'BaseRTL.ReAllocMemory' D@inMem D@inSz eax | test eax eax | je @BM
    mov D@inMem eax | mov D@inSz edx
L1:
;;
;;
    mov edx D@inSz | cmp edx krtsbMinMul | jb L1>
    shr edx 2 | mov eax 0200
L0: cmp eax edx | jae L0> | shl eax 1 | jmp L0<
L0: je L1>
    shl eax 2
    call 'BaseRTL.ReAllocMemory' D@inMem D@inSz eax | test eax eax | je @BM
    mov D@inMem eax | mov D@inSz edx
L1:
;;
    mov eax D@inSz | add eax eax | mov D@outSz eax
    call VAlloc D@outSz | mov D@outMem eax | test eax eax | je @BM
call SetStartTick
    mov eax D@inSz, ecx D@outSz
    shl eax 3 | shl ecx 3
    call 'AnyBits.AnyBitsSquare' D@outMem ecx, D@inMem eax | test eax eax | je @BM ;AnyBitsSquareKaratsubaRecursive4
call SetEndTickReport
    updateByteSize D@outMem D@outSz
    call ChooseAndSaveFileA D@outMem D@outSz
@BM:
    call VFree D@outMem | call VFree D@inMem
EndP

;
;
Proc doAnyBitsPOW:
 cLocal @inSz @inMem @outSz @outMem @Power
DBGBP
    call Input32BitNumber | cmp eax 0 | je P9>> | mov D@Power eax
    call ChooseAndLoadFileA | test eax eax | je P9>
    ALIGN_ON 4 edx
    mov D@inMem eax, D@inSz edx

    updateByteSize D@inMem D@inSz
call SetStartTick
    shl eax 3
    call 'AnyBits.AnyBitsPower' D@inMem eax D@Power | test eax eax | je @BM
call SetEndTickReport
    shr edx 3 | mov D@outMem eax , D@outSz edx
    call ChooseAndSaveFileA D@outMem D@outSz
@BM:
    call VFree D@outMem | call VFree D@inMem
EndP
;
;
;
;
Proc doAnyBitsDIV:
 cLocal @inSz1 @inMem1 @inSz2 @inMem2 @outSz @outMem

    call ChooseAndLoadFileA | test eax eax | je P9>>
    ALIGN_ON 4 edx
    mov D@inMem1 eax, D@inSz1 edx

    call ChooseAndLoadFileA | test eax eax | je @BM
    ALIGN_ON 4 edx
    mov D@inMem2 eax, D@inSz2 edx
DBGBP
    updateByteSize D@inMem1 D@inSz1
    updateByteSize D@inMem2 D@inSz2

    mov eax D@inSz1 | sub eax D@inSz2 | add eax 4 | mov D@outSz eax
    call VAlloc D@outSz | mov D@outMem eax | test eax eax | je @BM

    move D$AnyBitsDIVQuotent D@inMem1, D$AnyBitsDIVQuotent+4 D@inSz1 | SHL D$AnyBitsDIVQuotent+4 3
    move D$AnyBitsDIVDivizor D@inMem2, D$AnyBitsDIVDivizor+4 D@inSz2 | SHL D$AnyBitsDIVDivizor+4 3
    call 'AnyBits.GetHighestBitPosition' D$AnyBitsDIVDivizor D$AnyBitsDIVDivizor+4 | mov D$AnyBitsDIVDivizor+4 eax
    mov D$JobReporterAddr reportAnyBitsDIV
call SetStartTick
    mov eax D@inSz1, edx D@inSz2, ecx D@outSz
    shl eax 3 | shl edx 3 | shl ecx 3
    call 'AnyBits.AnyBitsDivision' D@outMem ecx D@inMem2 edx D@inMem1 eax | test eax eax | je @BM
    cmp edx 0 | jne L0> | mov D@inSz1 0
L0:
call SetEndTickReport
and D$JobReporterAddr 0
; output divident
    updateByteSize D@outMem D@outSz
    call ChooseAndSaveFileA D@outMem D@outSz

; output IF reminder
    cmp D@inSz1 0 | je @BM
    updateByteSize D@inMem1 D@inSz1
;    cmp eax 4 | ja L0> | mov eax D@inMem1 | cmp D$eax 0 | je @BM
;L0:
    call ChooseAndSaveFileA D@inMem1 D@inSz1
@BM:
    call VFree D@outMem | call VFree D@inMem2 | call VFree D@inMem1
EndP
;
;
[AnyBitsDIVQuotent: D$ 0,0
 AnyBitsDIVDivizor: 0,0]
Proc reportAnyBitsDIV:
DBGBP
    updateBitSize D$AnyBitsDIVQuotent D$AnyBitsDIVQuotent+4
    call 'AnyBits.GetHighestBitPosition' D$AnyBitsDIVQuotent D$AnyBitsDIVQuotent+4
    sub eax D$AnyBitsDIVDivizor+4
    call Dword2Decimal pReportBuffer eax | mov B$pReportBuffer+eax 0
    call 'User32.SendMessageA', D$EDIT0_handle, &WM_SETTEXT, 0, pReportBuffer

EndP
;



Proc doAnyBitsMOD:
 cLocal @inSz1 @inMem1 @inSz2 @inMem2

    call ChooseAndLoadFileA | test eax eax | je P9>>
    ALIGN_ON 4 edx
    mov D@inMem1 eax, D@inSz1 edx
    call ChooseAndLoadFileA | test eax eax | je @BM
    ALIGN_ON 4 edx
    mov D@inMem2 eax, D@inSz2 edx
DBGBP
    updateByteSize D@inMem1 D@inSz1
    updateByteSize D@inMem2 D@inSz2
call SetStartTick
    mov eax D@inSz1, edx D@inSz2
    shl eax 3 | shl edx 3
    call 'AnyBits.AnyBitsModulus' D@inMem2 edx D@inMem1 eax | test eax eax | je @BM
call SetEndTickReport
; output reminder
    cmp edx 0 | jne L0>
    call 'User32.MessageBoxA' D$WindowHandle "0" "NULL REMINDER!" &MB_ICONINFORMATION | jmp @BM
L0:
    updateByteSize D@inMem1 D@inSz1
;    cmp eax 4 | ja L0> | mov eax D@inMem1 | cmp D$eax 0 | je @BM
;L0:
    call ChooseAndSaveFileA D@inMem1 D@inSz1
@BM:
    call VFree D@inMem2 | call VFree D@inMem1
EndP
;
;
Proc OnAnyBitsAdd32Bit:
 cLocal @inSz1 @inMem1 @Bit32

    call Input32BitNumber | cmp eax 0 | je P9>> | mov D@Bit32 eax
    call ChooseAndLoadFileA | test eax eax | je P9>
    ALIGN_ON 4 edx
    mov D@inMem1 eax, D@inSz1 edx
DBGBP
    updateByteSize D@inMem1 D@inSz1

call SetStartTick
    mov eax D@inSz1
    shl eax 3
    call 'AnyBits.AnyBitsAdditionSelf32Bit' D@inMem1 eax D@Bit32 | test eax eax | je @BM
call SetEndTickReport
    updateByteSize D@inMem1 D@inSz1
    call ChooseAndSaveFileA D@inMem1 D@inSz1
@BM:
    call VFree D@inMem1
EndP
;
;
Proc OnAnyBitsSub32Bit:
 cLocal @inSz1 @inMem1 @Bit32

    call Input32BitNumber | cmp eax 0 | je P9>> | mov D@Bit32 eax
    call ChooseAndLoadFileA | test eax eax | je P9>
    ALIGN_ON 4 edx
    mov D@inMem1 eax, D@inSz1 edx
DBGBP
    updateByteSize D@inMem1 D@inSz1

call SetStartTick
    mov eax D@inSz1
    shl eax 3
    call 'AnyBits.AnyBitsSubstractSelf32Bit' D@inMem1 eax D@Bit32 | test eax eax | je @BM
call SetEndTickReport
    updateByteSize D@inMem1 D@inSz1
    call ChooseAndSaveFileA D@inMem1 D@inSz1
@BM:
    call VFree D@inMem1
EndP
;
;
Proc OnAnyBitsMul32Bit:
 cLocal @inSz1 @inMem1 @outSz @outMem @Bit32

    call Input32BitNumber | cmp eax 0 | je P9>> | mov D@Bit32 eax
    call ChooseAndLoadFileA | test eax eax | je P9>>
    ALIGN_ON 4 edx
    mov D@inMem1 eax, D@inSz1 edx
DBGBP
    updateByteSize D@inMem1 D@inSz1

    mov eax D@inSz1 | add eax 4 | mov D@outSz eax
    call VAlloc D@outSz | mov D@outMem eax | test eax eax | je @BM
call SetStartTick
    mov eax D@inSz1, edx D@outSz
    shl eax 3 | shl edx 3
    call 'AnyBits.AnyBitsMul32Bit' D@outMem edx D@Bit32 D@inMem1 eax | test eax eax | je @BM
call SetEndTickReport
    updateByteSize D@outMem D@outSz
    call ChooseAndSaveFileA D@outMem D@outSz
@BM:
    call VFree D@outMem | call VFree D@inMem1
EndP
;
;
Proc OnAnyBitsDiv32Bit:
 cLocal @inSz1 @inMem1 @Bit32 @numSz
  USES EDI
    call Input32BitNumber | cmp eax 0 | je P9>> | mov D@Bit32 eax
    call ChooseAndLoadFileA | test eax eax | je P9>>
    ALIGN_ON 4 edx
    mov D@inMem1 eax, D@inSz1 edx
DBGBP
    updateByteSize D@inMem1 D@inSz1
call SetStartTick
    mov eax D@inSz1
    shl eax 3
    call 'AnyBits.AnyBitsDiv32Bit' D@inMem1 eax D@Bit32 | test eax eax | je @BM
call SetEndTickReport
    mov D@Bit32 edx

    updateByteSize D@inMem1 D@inSz1
    call GetSaveFileName | test eax eax | je @BM
    call 'BaseRTL.WriteMem2FileNameA' D$pSFileName1 D@inMem1 D@InSz1
    cmp D@Bit32 0 | je @BM
    call Dword2Decimal inputNumText D@Bit32 | mov D@numSz eax | add eax inputNumText | mov B$eax 0
    mov edi D$pSFileTitle1 | sub eax eax | mov ecx 0FF0 | CLD | REPNE SCASB | jne @BM
    mov B$edi-1 '_', D$edi 'REMI', D$edi+4 'NDER', D$edi+8 '.TXT', B$edi+12 0
    call 'BaseRTL.WriteMem2FileNameA' D$pSFileTitle1 inputNumText D@numSz
@BM:
    call VFree D@inMem1
EndP
;
;
Proc OnAnyBitsMod32Bit:
 cLocal @inSz1 @inMem1 @Bit32 @numSz
  USES EDI
    call Input32BitNumber | cmp eax 0 | je P9>> | mov D@Bit32 eax
    call GetOpenFileName | test eax eax | je P9>>
    call 'BaseRTL.LoadFileNameA2Mem' D$pOFileName1 | test eax eax | je P9>>
    ALIGN_ON 4 edx
    mov D@inMem1 eax, D@inSz1 edx
DBGBP
    updateByteSize D@inMem1 D@inSz1
call SetStartTick
    mov eax D@inSz1
    shl eax 3
    call 'AnyBits.AnyBitsMod32Bit' D@inMem1 eax D@Bit32 | test eax eax | je @BM
call SetEndTickReport
    cmp edx 0 | jne L0>
    call 'User32.MessageBoxA' D$WindowHandle "0" "NULL REMINDER!" &MB_ICONINFORMATION | jmp @BM
L0:
    call Dword2Decimal inputNumText edx | mov D@numSz eax | add eax inputNumText | mov B$eax 0
    mov edi D$pOFileTitle1 | sub eax eax | mov ecx 0FF0 | CLD | REPNE SCASB | jne @BM
    mov B$edi-1 '_', D$edi 'REMI', D$edi+4 'NDER', D$edi+8 '.TXT', B$edi+12 0
    call 'BaseRTL.WriteMem2FileNameA' D$pOFileTitle1 inputNumText D@numSz
    call 'User32.SendMessageA', D$EDIT0_handle, &WM_SETTEXT, 0, inputNumText
@BM:
    call VFree D@inMem1
EndP
;
;
Proc doAnyBitsSquareRoot:
 cLocal @inSz1 @inMem1 @outSz @outMem

    call ChooseAndLoadFileA | test eax eax | je P9>>
DBGBP
    mov D@inMem1 eax, D@inSz1 edx
    updateByteSize D@inMem1 D@inSz1
    mov edx D@inSz1 | SHL edx 3 | ALIGN_ON 64 edx | mov D@inSz1 edx
    SHR edx 1 | ALIGN_ON 64 edx | mov D@outSz edx
    SHR edx 3
    call VAlloc edx | test eax eax | je @BM
    mov D@outMem eax
call SetStartTick
    call 'AnyBits.AnyBitsSquareRoot' D@outMem D@outSz D@inMem1 D@inSz1 | test eax eax | je @BM
call SetEndTickReport
    mov D@outSz edx
    updateBitSize D@outMem D@outSz | SHR D@outSz 3
    call ChooseAndSaveFileA D@outMem D@outSz
@BM:
    call VFree D@outMem | call VFree D@inMem1
EndP
;
;
Proc doAnyBitsNRoot:
 cLocal @inSz1 @inMem1 @outSz @outMem @Bit32

    call Input32BitNumber | cmp eax 0 | je P9>> | mov D@Bit32 eax
    call ChooseAndLoadFileA | test eax eax | je P9>>
DBGBP
    mov D@inMem1 eax, D@inSz1 edx
    updateByteSize D@inMem1 D@inSz1
    mov eax D@inSz1 | SHL eax 3 | ALIGN_ON 32 eax | mov D@inSz1 eax
    sub edx edx | div D@Bit32 | cmp edx 0 | setne DL | and edx 1 | add eax edx
    ALIGN_ON 32 eax | mov D@outSz eax
    SHR eax 3
    call VAlloc eax | test eax eax | je @BM
    mov D@outMem eax
call SetStartTick
    call 'AnyBits.AnyBitsNRoot' D@outMem D@outSz D@inMem1 D@inSz1 D@Bit32 | test eax eax | je @BM
call SetEndTickReport
    mov D@outSz edx
    updateBitSize D@outMem D@outSz | SHR D@outSz 3
    call ChooseAndSaveFileA D@outMem D@outSz
@BM:
    call VFree D@outMem | call VFree D@inMem1
EndP
;
;
Proc OnAnyBitsSHL:
 cLocal @inSz1 @inMem1 @Bit32

    call Input32BitNumber | cmp eax 0 | je P9> | mov D@Bit32 eax
    call ChooseAndLoadFileA | test eax eax | je P9>
    mov D@inMem1 eax, D@inSz1 edx
DBGBP
    shl edx 3
    call 'AnyBits.AnyBitsShiftLeft' D@inMem1 edx D@Bit32 | test eax eax | je @BM
    call ChooseAndSaveFileA D@inMem1 D@InSz1
@BM:
    call VFree D@inMem1
EndP
;
;
Proc OnAnyBitsSHR:
 cLocal @inSz1 @inMem1 @Bit32

    call Input32BitNumber | cmp eax 0 | je P9> | mov D@Bit32 eax
    call ChooseAndLoadFileA | test eax eax | je P9>
    mov D@inMem1 eax, D@inSz1 edx
DBGBP
    shl edx 3
    call 'AnyBits.AnyBitsShiftRight' D@inMem1 edx D@Bit32 | test eax eax | je @BM
    call ChooseAndSaveFileA D@inMem1 D@InSz1
@BM:
    call VFree D@inMem1
EndP
;
;
Proc OnAnyBitsROL:
 cLocal @inSz1 @inMem1 @Bit32

    call Input32BitNumber | cmp eax 0 | je P9> | mov D@Bit32 eax
    call ChooseAndLoadFileA | test eax eax | je P9>
    mov D@inMem1 eax, D@inSz1 edx
DBGBP
    shl edx 3
    call 'AnyBits.AnyBitsRotateLeft' D@inMem1 edx D@Bit32 | test eax eax | je @BM
    call ChooseAndSaveFileA D@inMem1 D@InSz1
@BM:
    call VFree D@inMem1
EndP
;
;
Proc OnAnyBitsROR:
 cLocal @inSz1 @inMem1 @Bit32

    call Input32BitNumber | cmp eax 0 | je P9> | mov D@Bit32 eax
    call ChooseAndLoadFileA | test eax eax | je P9>
    mov D@inMem1 eax, D@inSz1 edx
DBGBP
    shl edx 3
    call 'AnyBits.AnyBitsRotateRight' D@inMem1 edx D@Bit32 | test eax eax | je @BM
    call ChooseAndSaveFileA D@inMem1 D@InSz1
@BM:
    call VFree D@inMem1
EndP
;
;










































____________________________________________________________________________________________

Proc OnBase24Encode:
 cLocal @outSz @outMem @inSz @inMem

    call ChooseAndLoadFileA | test eax eax | je P9>
    mov D@inMem eax, D@inSz edx
    mov eax edx, ecx 4, edx 0 | div ecx | inc eax | mov ecx 7 | mul ecx
    mov D@outSz eax
    call VAlloc D@outSz | mov D@outMem eax | test eax eax | je @BM

    call 'BaseCodecs.Base24Enc' D@outMem D@inMem D@inSz | mov D@outSz eax

    call ChooseAndSaveFileA D@outMem D@outSz
@BM:
    call VFree D@outMem | call VFree D@inMem
EndP


Proc OnBase24Decode:
 cLocal @outSz @outMem @inSz @inMem

    call ChooseAndLoadFileA | test eax eax | je P9>
    mov D@inMem eax, D@inSz edx
    mov eax edx, ecx 7, edx 0 | div ecx | inc eax | mov ecx 4 | mul ecx
    mov D@outSz eax
    call VAlloc D@outSz | mov D@outMem eax | test eax eax | je @BM

    call 'BaseCodecs.Base24Dec' D@outMem D@inMem D@inSz | mov D@outSz eax

    call ChooseAndSaveFileA D@outMem D@outSz
@BM:
    call VFree D@outMem | call VFree D@inMem
EndP


Proc OnBase41Encode:
 cLocal @outSz @outMem @inSz @inMem

    call ChooseAndLoadFileA | test eax eax | je P9>
    mov D@inMem eax, D@inSz edx
    mov eax edx, ecx 2, edx 0 | div ecx | inc eax | mov ecx 3 | mul ecx
    mov D@outSz eax
    call VAlloc D@outSz | mov D@outMem eax | test eax eax | je @BM

    call 'BaseCodecs.Base41Enc' D@outMem D@inMem D@inSz | mov D@outSz eax

    call ChooseAndSaveFileA D@outMem D@outSz
@BM:
    call VFree D@outMem | call VFree D@inMem
EndP


Proc OnBase41Decode:
 cLocal @outSz @outMem @inSz @inMem

    call ChooseAndLoadFileA | test eax eax | je P9>
    mov D@inMem eax, D@inSz edx
    mov eax edx, ecx 3, edx 0 | div ecx | inc eax | mov ecx 2 | mul ecx
    mov D@outSz eax
    call VAlloc D@outSz | mov D@outMem eax | test eax eax | je @BM

    call 'BaseCodecs.Base41Dec' D@outMem D@inMem D@inSz | mov D@outSz eax

    call ChooseAndSaveFileA D@outMem D@outSz
@BM:
    call VFree D@outMem | call VFree D@inMem
EndP


Proc OnBase53Encode:
 cLocal @outSz @outMem @inSz @inMem

    call ChooseAndLoadFileA | test eax eax | je P9>
    mov D@inMem eax, D@inSz edx
    mov eax edx, ecx 5, edx 0 | div ecx | inc eax | mov ecx 7 | mul ecx
    mov D@outSz eax
    call VAlloc D@outSz | mov D@outMem eax | test eax eax | je @BM

    call 'BaseCodecs.Base53Enc' D@outMem D@inMem D@inSz | mov D@outSz eax

    call ChooseAndSaveFileA D@outMem D@outSz
@BM:
    call VFree D@outMem | call VFree D@inMem
EndP


Proc OnBase53Decode:
 cLocal @outSz @outMem @inSz @inMem

    call ChooseAndLoadFileA | test eax eax | je P9>
    mov D@inMem eax, D@inSz edx
    mov eax edx, ecx 7, edx 0 | div ecx | inc eax | mov ecx 5 | mul ecx | add eax 3
    mov D@outSz eax
    call VAlloc D@outSz | mov D@outMem eax | test eax eax | je @BM

    call 'BaseRTL.FillMemory' D@outMem, D@outSz, 0
    call 'BaseCodecs.Base53Dec' D@outMem D@inMem D@inSz | mov D@outSz eax

    call ChooseAndSaveFileA D@outMem D@outSz
@BM:
    call VFree D@outMem | call VFree D@inMem
EndP


Proc OnBase64Encode:
 cLocal @outSz @outMem @inSz @inMem

    call ChooseAndLoadFileA | test eax eax | je P9>
    mov D@inMem eax, D@inSz edx
    mov eax edx, ecx 3, edx 0 | div ecx | inc eax | shl eax 2 | inc eax
    mov D@outSz eax
    call VAlloc D@outSz | mov D@outMem eax | test eax eax | je @BM

    call 'BaseCodecs.Base64Enc' D@outMem D@inMem D@inSz | mov D@outSz eax

    call ChooseAndSaveFileA D@outMem D@outSz
@BM:
    call VFree D@outMem | call VFree D@inMem
EndP


Proc OnBase64Decode:
 cLocal @outSz @outMem @inSz @inMem

    call ChooseAndLoadFileA | test eax eax | je P9>
    mov D@inMem eax, D@inSz edx
    mov eax edx, ecx 4, edx 0 | div ecx | inc eax | lea eax D$eax*2+eax | inc eax
    mov D@outSz eax
    call VAlloc D@outSz | mov D@outMem eax | test eax eax | je @BM

    call 'BaseCodecs.Base64Dec' D@outMem D@inMem D@inSz | mov D@outSz eax

    call ChooseAndSaveFileA D@outMem D@outSz
@BM:
    call VFree D@outMem | call VFree D@inMem
EndP


Proc OnBase75Encode:
 cLocal @outSz @outMem @inSz @inMem

    call ChooseAndLoadFileA | test eax eax | je P9>
    mov D@inMem eax, D@inSz edx
    mov eax edx, ecx 7, edx 0 | div ecx | inc eax | mov ecx 9 | mul ecx
    mov D@outSz eax
    call VAlloc D@outSz | mov D@outMem eax | test eax eax | je @BM

    call 'BaseCodecs.Base75Enc' D@outMem D@inMem D@inSz | mov D@outSz eax

    call ChooseAndSaveFileA D@outMem D@outSz
@BM:
    call VFree D@outMem | call VFree D@inMem
EndP


Proc OnBase75Decode:
 cLocal @outSz @outMem @inSz @inMem @cntr @bval1 @bval2

    call ChooseAndLoadFileA | test eax eax | je P9>
    mov D@inMem eax, D@inSz edx
    mov eax edx, ecx 9, edx 0 | div ecx | inc eax | mov ecx 7 | mul ecx | add eax 1
    mov D@outSz eax
    call VAlloc D@outSz | mov D@outMem eax | test eax eax | je @BM

;mov D@bval1 0-1, D@bval2 0-1
;mov D@cntr 010000
;L0:
    call 'BaseRTL.FillMemory' D@outMem, D@outSz, 0
;ALIGN 16
;NOP | RDTSC | push edx, eax

    call 'BaseCodecs.Base75Dec' D@outMem D@inMem D@inSz | mov D@outSz eax

;RDTSC | pop ecx | sub eax ecx | pop ecx | sbb edx ecx
;cmp D@bval1 eax | jbe L1> | mov D@bval1 eax
;L1: dec D@cntr | jne L0< ;| DBGBP
;;
mov D@cntr 010000
L0:
    call FillMemmory D@outMem, D@outSz, 0
ALIGN 16
NOP | RDTSC | push edx, eax

    call Base75Dec D@outMem D@inMem D@inSz ;| mov D@outSz eax

RDTSC | pop ecx | sub eax ecx | pop ecx | sbb edx ecx
cmp D@bval2 eax | jbe L1> | mov D@bval2 eax
L1: dec D@cntr | jne L0< | DBGBP
;;
    call ChooseAndSaveFileA D@outMem D@outSz
@BM:
    call VFree D@outMem | call VFree D@inMem
EndP


Proc OnBase85Encode:
 cLocal @outMem @outSz @inMem @inSz

    call ChooseAndLoadFileA | test eax eax | je P9>
    mov D@inMem eax, D@inSz edx
    mov eax edx, ecx 4, edx 0 | div ecx | inc eax | mov ecx 5 | mul ecx
    mov D@outSz eax
    call VAlloc D@outSz | mov D@outMem eax | test eax eax | je @BM

    call 'BaseCodecs.Base85EncI' D@outMem D@inMem D@inSz | mov D@outSz eax

    call ChooseAndSaveFileA D@outMem D@outSz
@BM:
    call VFree D@outMem | call VFree D@inMem
EndP


Proc OnBase85Decode:
 cLocal @outSz @outMem @inSz @inMem

    call ChooseAndLoadFileA | test eax eax | je P9>
    mov D@inMem eax, D@inSz edx
    mov eax edx, ecx 5, edx 0 | div ecx | inc eax | shl eax 2
    mov D@outSz eax
    call VAlloc D@outSz | mov D@outMem eax | test eax eax | je @BM

    call 'BaseCodecs.Base85DecI' D@outMem D@inMem D@inSz | mov D@outSz eax

    call ChooseAndSaveFileA D@outMem D@outSz
@BM:
    call VFree D@outMem | call VFree D@inMem
EndP


Proc OnBase94Encode:
 cLocal @outSz @outMem @inSz @inMem

    call ChooseAndLoadFileA | test eax eax | je P9>
    mov D@inMem eax, D@inSz edx
    mov eax edx, ecx 9, edx 0 | div ecx | inc eax | mov ecx 11 | mul ecx
    mov D@outSz eax
    call VAlloc D@outSz | mov D@outMem eax | test eax eax | je @BM

    call 'BaseCodecs.Base94Enc' D@outMem D@inMem D@inSz | mov D@outSz eax

    call ChooseAndSaveFileA D@outMem D@outSz
@BM:
    call VFree D@outMem | call VFree D@inMem
EndP


Proc OnBase94Decode:
 cLocal @outSz @outMem @inSz @inMem @cntr @bval1 @bval2

    call ChooseAndLoadFileA | test eax eax | je P9>
    mov D@inMem eax, D@inSz edx
    mov eax edx, ecx 11, edx 0 | div ecx | inc eax | mov ecx 9 | mul ecx | add eax 3
    mov D@outSz eax
    call VAlloc D@outSz | mov D@outMem eax | test eax eax | je @BM

;mov D@bval1 0-1, D@bval2 0-1
;mov D@cntr 100000
;L0:
    call 'BaseRTL.FillMemory' D@outMem, D@outSz, 0

;NOP | RDTSC | push edx, eax
    call 'BaseCodecs.Base94Dec' D@outMem D@inMem D@inSz | mov D@outSz eax
;;
RDTSC | pop ecx | sub eax ecx | pop ecx | sbb edx ecx
cmp D@bval1 eax | jbe L1> | mov D@bval1 eax
L1: dec D@cntr | jne L0< | ;DBGBP

mov D@cntr 100000
L0:
    call FillMemmory D@outMem, D@outSz, 0

NOP | RDTSC | push edx, eax

    call Base94DecI D@outMem D@inMem D@inSz ;| mov D@outSz eax

RDTSC | pop ecx | sub eax ecx | pop ecx | sbb edx ecx
cmp D@bval2 eax | jbe L1> | mov D@bval2 eax
L1: dec D@cntr | jne L0< | DBGBP
;;
    call ChooseAndSaveFileA D@outMem D@outSz
@BM:
    call VFree D@outMem | call VFree D@inMem
EndP



Proc OnBase62Encode:
 cLocal @outSz @outMem @inSz @inMem

    call ChooseAndLoadFileA | test eax eax | je P9>
    mov D@inMem eax, D@inSz edx
    mov eax edx, ecx 8, edx 0 | div ecx | inc eax | mov ecx 11 | mul ecx
    mov D@outSz eax
    call VAlloc D@outSz | mov D@outMem eax | test eax eax | je @BM

    mov eax D@inSz | shl eax 3 | ALIGN_ON 32 eax
    call 'BaseCodecs.AnyBits2Base62' D@outMem D@inMem eax | mov D@outSz eax

    call ChooseAndSaveFileA D@outMem D@outSz
@BM:
    call VFree D@outMem | call VFree D@inMem
EndP


Proc OnBase62Decode:
 cLocal @outSz @outMem @inSz @inMem

    call ChooseAndLoadFileA | test eax eax | je P9>
    mov D@inMem eax, D@inSz edx
    mov eax edx, ecx 4, edx 0 | div ecx | add eax 2 | mov ecx 3 | mul ecx
    ALIGN_ON 4 eax | mov D@outSz eax
    call VAlloc D@outSz | mov D@outMem eax | test eax eax | je @BM

    mov eax D@outSz | shl eax 3
    call 'BaseCodecs.Base62ToBits' D@outMem eax D@inMem | mov D@outSz eax

    call ChooseAndSaveFileA D@outMem D@outSz
@BM:
    call VFree D@outMem | call VFree D@inMem
EndP


;**************************************************************************************************
Proc CopyDamagedFile:
 ARGUMENTS @fWrite @fRead
 cLocal @fhop @fszLo @fszHi @fhsv @result

    call 'BaseRTL.FileNameOpenRead' D@fRead | test eax eax | je L9>
    mov D@fhop eax, D@fszLo ecx, D@fszHi edx | or ecx edx | je L8>
    call 'BaseRTL.FileNameCreateWrite' D@fWrite &TRUE | test eax eax | je L8> | mov D@fhsv eax
    call 'BaseRTL.CopyDamagedFileContent' D@fhsv, D@fhop, D@fszLo, D@fszHi, 0800
    sub eax D@fszLo | sbb edx D@fszHi | or eax edx | sete B@result
L8:
    HClose D@fhsv | HClose D@fhop
    cmp B@result &FALSE | jne P9> | ;call 'BaseRTL.DeleteFile' D@fWrite
L9: mov eax D@result
EndP

;************
Proc RtlDecompress:
 ARGUMENTS @fWrite @fRead
 cLocal @opBuff @opBuffSz @WrBuff @WrBuffSz @result
DBGBP
    call 'BaseRTL.LoadFileNameA2Mem' D@fRead | test eax eax | je L9>
    mov D@opBuff eax, D@opBuffSz edx

    call RtlDecompressBuff D@opBuff D@opBuffSz | test eax eax | je L8>
    mov D@WrBuff eax, D@WrBuffSz edx

    call 'BaseRTL.WriteMem2FileNameA' D@fWrite D@WrBuff D@WrBuffSz
    test eax eax | setne B@result
    cmp B@result &FALSE | jne L8> | call 'BaseRTL.DeleteFile' D@fWrite

L8: call VFree D@opBuff | call VFree D@WrBuff
L9: mov eax D@result

EndP


Proc RtlDecompressBuff:
 ARGUMENTS @rBuff @rBuffSz
 cLocal  @wBuff @wBuffSz @FinalUncompressedSize

    mov eax D@rBuffSz | shl eax 2
    mov D@wBuffSz eax
    call VAlloc eax | mov D@wBuff eax | test eax eax | je P9>

    lea eax D@FinalUncompressedSize
    Call 'NtDll.RtlDecompressBuffer', &COMPRESSION_FORMAT_LZNT1, D@wBuff, D@wBuffSz, D@rBuff D@rBuffSz, eax
    test eax eax | jne B0>
    mov eax D@wBuff, edx D@FinalUncompressedSize | jmp P9>

B0: call VFree D@wBuff | mov eax 0
EndP





OnMenuAbout:
call 'USER32.MessageBoxA' D$WindowHandle, "Base Application", 'About:', &MB_ICONINFORMATION__&MB_OK
ret






Proc OnSimpleRol4:
 cLocal @inMem @inSz

    call ChooseAndLoadFileA | test eax eax | je P9>
    mov D@inMem eax, D@inSz edx

    mov eax D@inMem, ecx D@inSz
L0:
    rol B$eax 4 | inc eax | dec ecx | jne L0<

    call ChooseAndSaveFileA D@inMem D@inSz
    call VFree D@inMem
EndP


Proc OnInverseFileBytes:
 cLocal @inMem @inSz

    call ChooseAndLoadFileA | test eax eax | je P9>
    mov D@inMem eax, D@inSz edx

    call InverseBytesArray D@inMem D@inSz

    call ChooseAndSaveFileA D@inMem D@inSz
    call VFree D@inMem
EndP

____________________________________________________________________________________________

Proc onTestFunc0:

    call 'USER32.MessageBoxA' D$WindowHandle, "Call TestNumberOn32BitPrimes?", 'Function:', &MB_ICONQUESTION__&MB_OKCANCEL
    cmp eax &IDCANCEL | je P9>
    call TryStartFunctionInNewThread TestNumberOn32BitPrimes
EndP

Proc onTestFunc1:

    call TryStartFunctionInNewThread doLLTestExponentRpt;
EndP


Proc onTestFunc2:

    call TryStartFunctionInNewThread doLLTestExponent
EndP

Proc onTestFunc3:

    call TryStartFunctionInNewThread doFermatLT2Rpt
EndP

Proc onTestFunc4:

    call TryStartFunctionInNewThread doFermatNum2Rpt
EndP

Proc onTestFunc5:
    call TryStartFunctionInNewThread do2P1MTFAnyBitMTFactorFunnyB
EndP

Proc onTestFunc6:
    call TryStartFunctionInNewThread do2P1MTFAnyBitMTFactorFunnyBL2;do2P1MTFAnyBitMTFactorFunnyBLXY
EndP

Proc onTestFunc7:
    call TryStartFunctionInNewThread do2P1MTF32BitPrimes
EndP

Proc onTestFunc8:
    call TryStartFunctionInNewThread PrimesOutFromAnyBits
EndP

Proc onTestFunc9:
    call TryStartFunctionInNewThread Primes64OutFromAnyBits
EndP














TITLE Conversions
____________________________________________________________________________________________

Proc TranslateDecimal: ;Decimal is NULLstring
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
L7: mov eax 0, edx 0 ; ERROR case easy way out..
L9:                                            ; >>> number in EDX:EAX
EndP

; non-number char ends Decimal.
; EAX returns Dword
; ECX returns processed chars count. OR
; ECX= -1 signals Dword overflow ERROR ; ECX=0 -> was not number
Proc TranslateDecimal2Dword:
 ARGUMENTS @pDecimalString
 USES esi

    mov esi D@pDecimalString
    sub eax eax

L0: movzx ecx B$esi
    sub ecx '0' | cmp ecx 9 | ja L1>
    inc  esi
    mov edx 10 | mul edx | jc L2>          ; carry >>> Dword overflow
    add eax ecx | jnc L0<                  ; Dword overflow

L2: or ecx 0-1 | sub eax eax | jmp P9>     ; Dword overflow ERROR
L1: mov ecx esi | sub ecx D@pDecimalString ; >>> number in EDX:EAX
EndP

; non-number char ends Decimal.
; EAX:EDX returns Qword
; ECX returns processed chars count. OR
; ECX= -1 signals Qword overflow ERROR ; ECX=0 -> was not number
Proc TranslateDecimal2Qword:
 ARGUMENTS @pDecimalString
 USES ebx esi

    mov esi D@pDecimalString
    sub eax eax | sub edx edx | sub ebx ebx

L0: movzx ecx B$esi
    sub ecx '0' | cmp ecx 9 | ja L1>
    inc  esi
    test edx edx | je L3>
    mov ebx eax, eax edx, edx 10 | mul edx        ; high part * 10
    jo L2>                                        ; Qword overflow
    xchg eax ebx
L3: mov edx 10 | mul edx                          ; low part * 10
    add  edx ebx
    jc L2>                                        ; carry >>> Qword overflow

    add eax ecx | adc edx 0 | jnc L0<             ; Qword overflow

L2: or ecx 0-1 | sub eax eax | sub edx edx | jmp P9>       ; Qword overflow ERROR
L1: mov ecx esi | sub ecx D@pDecimalString        ; >>> number in EDX:EAX
EndP

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

; DECIMAL conversions
Proc DwordReg2Decimal: ;ritern sLen
 ARGUMENTS @pDecimalString ; EAX is dword
 USES EDI

    mov edi D@pDecimalString, ecx 10
L0:
    sub edx edx | div ecx | or dl 030 | mov B$edi dl | inc edi
    test eax eax | jne L0<

    mov ecx D@pDecimalString | sub edi ecx | lea edx D$ecx+edi-1
L0: cmp ecx edx | jae L0>
    mov al B$ecx, ah B$edx, B$ecx ah, B$edx al | inc ecx | dec edx | jmp L0<
L0: mov eax edi
EndP

Proc QwordPtr2Decimal: ;ritern sLen
 ARGUMENTS @pDecimalString @pQword
 USES EBX ESI EDI

    mov edx D@pQword, eax D$edx, edx D$edx+4, ecx 10, edi D@pDecimalString
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


Proc QwordHiLo2Decimal: ;ritern sLen
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

Proc QwordReg2Decimal: ;ritern sLen
 ARGUMENTS @pDecimalString ; QWORD is in EDX:EAX
 USES EBX ESI EDI

   mov edi D@pDecimalString, ecx 10
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

Proc CountDecimalNumbersInText: ;ritern Num Count
 ARGUMENTS @pText @Size
 USES ESI

    sub eax eax
    mov esi D@pText, ecx D@Size | test ecx ecx | jle P9>
    lea edx D$esi+ecx
L0: ;seek number
    cmp esi edx | jae P9>
    movzx ecx B$esi | inc esi | sub ecx 030 | cmp ecx 9 | ja L0<
    inc eax
L1: ;seek number's end
    cmp esi edx | jae P9>
    movzx ecx B$esi | inc esi | sub ecx 030 | cmp ecx 9 | jbe L1< | jmp L0<

EndP



TITLE Sorting

Proc InverseBytesArray:
 ARGUMENTS @array, @size

    mov ecx D@array, edx D@size | lea edx D$ecx+edx-1
L0: cmp ecx edx | jae P9>
    mov al B$ecx, ah B$edx, B$ecx ah, B$edx al | inc ecx | dec edx | jmp L0<
EndP

Proc AlignOnVal:
 ARGUMENTS @aligner @value
 USES edx
    mov eax D@value
    sub edx edx | div D@aligner | test edx edx | jne L0> | add eax 1
L0: mul D@aligner
EndP

Proc TruncAlignOnVal:
 ARGUMENTS @aligner @value
 USES edx
    mov eax D@value
    sub edx edx | div D@aligner | mul D@aligner
Endp


proc DualBubbleSortDWORDs: ; << jE! >>
 ARGUMENTS @array, @num

PUSHAD
    mov ecx D@num | mov ebx D@array | dec ecx | jle L9>
    lea ecx D$ebx+ecx*4 | lea edx D$ebx-4 | sub edi edi
ALIGN 16
B0:
B1: add edx 4 | cmp edx ecx | jae N1>
    mov esi D$edx | mov eax D$edx+4 | cmp esi eax | jbe B1<
    mov D$edx+4 esi | mov D$edx eax | or edi 1 |jmp B1<

N1: sub ecx 4 | dec edi | jne L9>

B3: sub edx 4 | cmp edx ebx | jbe N2>
    mov esi D$edx-4 | mov eax D$edx | cmp esi eax | jbe B3<
    mov D$edx esi | mov D$edx-4 eax | or edi 1 | jmp B3<

N2: add ebx 4 | dec edi | je B0<

L9: POPAD
EndP













TITLE rtlfuncs
____________________________________________________________________________________________

[WrBufPartSz 080000]

[HClose | mov eax #1 | call CloseHandle]
CloseHandle:
    test eax eax | je L0>
    call 'KERNEL32.CloseHandle' eax
L0: ret


Proc TryStartFunctionInNewThread:
 Arguments @ThreadProc ;@ThreadArg
DBGBP
    move D$JobProcAddr D@ThreadProc
    mov D$JobProcParamsCount 0
    call 'BaseRTL.TryStartFunctionInNewThread' JobThreadBlock | cmp eax 1 | je P9>
    cmp eax 0-1 | je @Busy
    call 'USER32.MessageBoxA' D$WindowHandle, "Thread start Fail!", 'Fail!', &MB_ICONWARNING__&MB_OK
    jmp P9>
@Busy:
    call 'USER32.MessageBoxA' D$WindowHandle, "Another Job is running!", 'Busy!', &MB_ICONWARNING__&MB_OK
EndP
;

ThreadAbort:
    push JobThreadBlock
    call 'BaseRTL.ThreadAbort'
    RET
; on 1st Ask, on 2nd abort



GetTimeTick: jmp 'Kernel32.GetTickCount'



Proc dumpStartTime:
  USES EDI

    call InitLogFile | test eax eax | je P9>

    mov edi pReportBuffer
    mov eax 'Star' | stosd
    mov eax 't:  ' | stosd
    call 'BaseRTL.GetCurrentTime2String' EDI | add edi eax | mov eax 0A0D | stosw | mov B$edi 0
    call 'User32.SendMessageA', D$EDIT0_handle, &WM_SETTEXT, 0,  pReportBuffer
    sub edi pReportBuffer
    call AppendToLogBuffer pReportBuffer edi
    call FlushLogBuffer
EndP

Proc dumpEndTime:
  USES EDI

    call InitLogFile | test eax eax | je P9>

    mov edi pReportBuffer
    mov eax 'End:' | stosd
    mov eax ' ' | stosb
    call 'BaseRTL.GetCurrentTime2String' EDI | add edi eax | mov eax 0A0D | stosw | mov B$edi 0
    call 'User32.SendMessageA', D$EDIT0_handle, &WM_SETTEXT, 0, pReportBuffer
    sub edi pReportBuffer
    call AppendToLogBuffer pReportBuffer edi
    call FlushLogBuffer
EndP
;
[<16 pOutputBuffer: D$ 0 pOutBufCurPos: 0 LogFileHandle: 0
LogCreateErrStr: "Can't create Log file!
Try next name?", 0 ]
[<4 LogFileName: B$ 'Log_0000.txt',0]
[LogBufferSize 0F000]
;[<16 pReportBuffer: B$ ? #256 ]
;
Proc InitLogFile:
    mov eax D$LogFileHandle | test eax eax | jne P9>>
L0:
    call 'BaseRTL.FileNameAOpenCreateWriteAppend' LogFileName | mov D$LogFileHandle eax | cmp eax 0 | je E0>
    call VAlloc LogBufferSize | mov D$pOutputBuffer eax, D$pOutBufCurPos eax | test eax eax | jne P9>
    call 'BaseRTL.CloseFlushHandle' D$LogFileHandle
E0:
    call 'User32.MessageBoxA' D$WindowHandle LogCreateErrStr "ERROR!!" &MB_ICONERROR__&MB_OKCANCEL
    ;call 'User32.PostQuitMessage' 0 | sub eax eax | call 'Kernel32.ExitThread' 0-1 |
    cmp eax &IDCANCEL | je L0>
    lea edx D$LogFileName+4
    push 0 | mov eax esp
    call 'BaseCodecs.BaseHex2iBinaryDecode' eax, 2, edx, 4
    pop eax | add eax 1
    lea edx D$LogFileName+4 | call 'BaseCodecs.W2H' edx eax
    jmp L0<<
L0: sub eax eax
EndP
;
;
Proc AppendToLogFile:
  ARGUMENTS @pMem @Sz
    call InitLogFile | test eax eax | je P9>
    call 'BaseRTL.WriteMem2FileHandle' D$LogFileHandle D@pMem D@Sz
EndP
;
;
FlushLogBuffer:
    mov eax D$pOutBufCurPos | sub eax D$pOutputBuffer | jle L0>
    cmp eax LogBufferSize | jbe L1> ; ? size damaged?
    mov eax LogBufferSize
L1: call AppendToLogFile D$pOutputBuffer eax
L0: move D$pOutBufCurPos D$pOutputBuffer
    ret
;
;
Proc AppendToLogBuffer:
  ARGUMENTS @pMem @Sz
  USES ESI EDI
    cmp D$LogFileHandle 0 | je P9>
    cmp D@Sz LogBufferSize | jb L0>
L2:
    call FlushLogBuffer
    call AppendToLogFile D@pMem D@Sz
    jmp P9>
L0:
    mov eax LogBufferSize
    add eax D$pOutputBuffer | sub eax D$pOutBufCurPos | ja L0>
    call FlushLogBuffer
    mov eax LogBufferSize
L0: cmp D@Sz eax | jbe L0>
    call FlushLogBuffer
L0: mov edi D$pOutBufCurPos, esi D@pMem, ecx D@Sz
    CLD | REP MOVSB
    mov D$pOutBufCurPos edi
EndP
;
;
Proc CloseLogFile:
  USES ESI EDI
    sub esi esi | sub edi edi
    lock xchg D$LogFileHandle esi | lock xchg D$pOutputBuffer edi
    test esi esi | je P9>
    mov eax D$pOutBufCurPos | sub eax edi | jbe L0>
    cmp eax LogBufferSize | jbe L1> ; ? size damaged?
    mov eax LogBufferSize
L1: call 'BaseRTL.WriteMem2FileHandle' esi edi eax
L0: call 'BaseRTL.CloseFlushHandle' esi
    call VFree edi
EndP
;
;
TITLE GETFNs
____________________________________________________________________________________________

[pOFileName1: D$ 0, pOFileTitle1: D$ 0, pSFileName1: D$ 0, pSFileTitle1: D$ 0]
;;
[gFilesFiltersA: B$ 'All'  0  '*.*'   0  0]
[gopFTitle1A: 'Choose file..', 0]
[gspFTitle1A: 'Choose name..', 0]

[gFilesFiltersW: U$ 'All'  0  '*.*'   0  0]
[gopFTitle1W: U$ 'Choose file..', 0]
[gspFTitle1W: U$ 'Choose name..', 0]
;;
GetOpenFileName:
;cmp B$winver 04 | ja GetOpenFileNameWide
sub eax eax | LOCK xchg eax D$pOFileName1 | call VFree eax
sub eax eax | LOCK xchg eax D$pOFileTitle1 | call VFree eax
call 'BaseRTL.ChooseFileByNameAnsi' D$WindowHandle
mov D$pOFileName1 eax, D$pOFileTitle1 edx
ret

GetSaveFileName:
sub eax eax | LOCK xchg eax D$pSFileName1 | call VFree eax
sub eax eax | LOCK xchg eax D$pSFileTitle1 | call VFree eax
call 'BaseRTL.ChooseFileNameAnsi' D$WindowHandle
mov D$pSFileName1 eax, D$pSFileTitle1 edx
ret

;jmp 'BaseRTL.GetOpenFileNameAnsi'

ChooseAndLoadFileA:
    call 'BaseRTL.ChooseAndLoadFileByNameAnsi' D$WindowHandle
ret

Proc ChooseAndSaveFileA:
 Arguments @outMem @outSz
    call 'BaseRTL.ChooseAndSaveToFileNameAnsi' D$WindowHandle D@outMem D@outSz
EndP





































TITLE CreateProcess
____________________________________________________________________________________________

;;
[CommandLineString: B$ ? #&MAX_PATH]

[STARTUPINFO: SI_cb: ?              SI_lpReserved: ?       SI_lpDesktop: ?
              SI_lpTitle: ?         SI_dwX: ?              SI_dwY: ?
              SI_dwXSize: ?         SI_dwYSize: ?          SI_dwXCountChars: ?
              SI_dwYCountChars: ?   SI_dwFillAttribute: ?  SI_dwFlags: ?
              SI_wShowWindow: W$ ?  SI_cbReserved2: W$ ?   SI_lpReserved2: D$ ?
              SI_hStdInput: ?       SI_hStdOutput: ?       SI_hStdError: ?]

[PROCESS_INFORMATION:
 PI.hProcess: ?
 PI.hThread: ?
 PI.dwProcessId: ?
 PI.dwThreadId: ?]
;;
;;
[PI.hProcess 0
 PI.hThread 4
 PI.dwProcessId 8
 PI.dwThreadId 12]

[ContextFlags 0
 C.iDr0 4
 C.iDr1 8
 C.iDr2 12
 C.iDr3 16
 C.iDr6 20
 C.iDr7 24
 C.FloatSave.ControlWord 28
 C.FloatSave.StatusWord 32
 C.FloatSave.TagWord 36
 C.FloatSave.ErrorOffset 40
 C.FloatSave.ErrorSelector 44
 C.FloatSave.DataOffset 48
 C.FloatSave.DataSelector 52
 C.FloatSave.RegisterArea 56
 C.FloatSave.Cr0NpxState 136
 C.regGs 140
 C.regFs 144
 C.regEs 148
 C.regDs 152
 C.regEdi 156
 C.regEsi 160
 C.regEbx 164
 C.regEdx 168
 C.regEcx 172
 C.regEax 176
 C.regEbp 180
 C.regEip 184
 C.regCs 188
 C.regFlag 192
 C.regEsp 196
 C.regSs 200
 C.ExtendedRegisters 204]

[C.regMM 236
 C.regXMM 364
 C.UnknownExtendedRegs 492
 EndOfContext 716]

StartProcess:
Proc StartProcessA:
 ARGUMENTS @ExeName @CLine
 Structure @PROCESS_INFORMATION 16, @PROCESS_INFORMATION_hProcessDis 0,
           @PROCESS_INFORMATION_hThreadDis 4,  @PROCESS_INFORMATION_dwProcessIdDis 8,  @PROCESS_INFORMATION_dwThreadIdDis 12
 USES ebx, esi

    sub ebx ebx
    sub esp 048 | mov esi esp
    call 'KERNEL32.GetStartupInfoA' esi

    lea edx D@PROCESS_INFORMATION
    call 'KERNEL32.CreateProcessA' D@ExeName, D@CLine, &NULL, &NULL, &FALSE,
                                   0, &NULL, &NULL, esi, edx
    test eax eax | mov ebx eax | je @EEnd
@endpr:
    HClose D@PROCESS_INFORMATION_hThreadDis
    HClose D@PROCESS_INFORMATION_hProcessDis
@EEnd:
    mov eax ebx
EndP

Proc StartProcessW:
 ARGUMENTS @ExeName @CLine
 Structure @PROCESS_INFORMATION 16, @PROCESS_INFORMATION_hProcessDis 0,
           @PROCESS_INFORMATION_hThreadDis 4,  @PROCESS_INFORMATION_dwProcessIdDis 8,  @PROCESS_INFORMATION_dwThreadIdDis 12
 USES ebx, esi

    sub ebx ebx
    sub esp 048 | mov esi esp
    call 'KERNEL32.GetStartupInfoW' esi

    lea edx D@PROCESS_INFORMATION
    call 'KERNEL32.CreateProcessW' D@ExeName, D@CLine, &NULL, &NULL, &FALSE,
                                   0, &NULL, &NULL, esi, edx
    test eax eax | mov ebx eax | je @EEnd
@endpr:
    HClose D@PROCESS_INFORMATION_hThreadDis
    HClose D@PROCESS_INFORMATION_hProcessDis
@EEnd:
    mov eax ebx
EndP


Proc CreateSuspProcessA1: ;int3
 ARGUMENTS @ExeName @CLine @ProcInfo
 cLocal @return
 USES ebx, esi, edi

    sub esp EndOfContext | mov esi esp
    call 'KERNEL32.GetStartupInfoA' esi

    mov ebx D@ProcInfo
    call 'KERNEL32.CreateProcessA' D@ExeName, D@CLine, &NULL, &NULL, &FALSE,
                                   &CREATE_SUSPENDED, &NULL, &NULL, esi, ebx
    test eax eax | je @EEnd

    mov edi esi, ecx (EndOfContext SHR 2), eax 0CCCCCCCC | rep stosd
    mov D$esi+ContextFlags 01003F
;    call 'KERNEL32.GetThreadContext' 0-2, esi | test eax eax | je @bendpr
    call 'KERNEL32.GetThreadContext' D$ebx+PI.hThread, esi | test eax eax | je @bend
;cleans
    CLD
    lea edi D$esi+C.iDr0 | mov ecx 6 | sub eax eax | rep stosd
    lea edi D$esi+C.FloatSave.ErrorOffset | stosd | stosd | stosd | stosw
    add edi 2 | mov ecx (&SIZE_OF_80387_REGISTERS / 4)| rep stosd
    lea edi D$esi+C.regMM | mov ecx 120 | rep stosd

    mov D$esi+ContextFlags 01003F
    call 'KERNEL32.SetThreadContext' D$ebx+PI.hThread, esi | test eax eax | je @bend

    call 'KERNEL32.ResumeThread' D$ebx+PI.hThread
    test eax eax | je @bend
    mov D@return 1
    jmp @endpr
@bend:
    call 'KERNEL32.TerminateProcess', D$ebx+PI.hProcess, 0-1
    HClose D$ebx+PI.hThread
    HClose D$ebx+PI.hProcess
@endpr:
@EEnd:
mov eax D@return
EndP


Proc CreateProcessAInjectDll: ;int3
 ARGUMENTS @ExeName @CLine @ProcInfo @InjectDllMem @injectSZ
 cLocal @return
 USES ebx, esi, edi

    sub esp EndOfContext | mov esi esp
    call 'KERNEL32.GetStartupInfoA' esi

    mov ebx D@ProcInfo
    call 'KERNEL32.CreateProcessA' D@ExeName, D@CLine, &NULL, &NULL, &FALSE,
                                   &CREATE_SUSPENDED, &NULL, &NULL, esi, ebx
    test eax eax | je @EEnd

    mov edi esi, ecx (EndOfContext SHR 2), eax 0CCCCCCCC | rep stosd
    mov D$esi+ContextFlags 01003F
;    call 'KERNEL32.GetThreadContext' 0-2, esi | test eax eax | je @bendpr
    call 'KERNEL32.GetThreadContext' D$ebx+PI.hThread, esi | test eax eax | je @bend
;cleans
    CLD
    lea edi D$esi+C.iDr0 | mov ecx 6 | sub eax eax | rep stosd
    lea edi D$esi+C.FloatSave.ErrorOffset | stosd | stosd | stosd | stosw
    add edi 2 | mov ecx (&SIZE_OF_80387_REGISTERS / 4)| rep stosd
    lea edi D$esi+C.regMM | mov ecx 120 | rep stosd

    call 'Kernel32.VirtualAllocEx', D$ebx+PI.hProcess, 0, D@injectSZ, &MEM_RESERVE_&MEM_COMMIT, &PAGE_EXECUTE_READWRITE
    mov edi eax | test eax eax | je @bend
; call RelocateImage
    call 'KERNEL32.WriteProcessMemory' D$ebx+PI.hProcess, edi, D@InjectDllMem, D@injectSZ, &NULL
    test eax eax | je @bend

    mov eax D$edi+03C | add eax edi | move D$ebx+C.regEax D$eax+OptionalHeader.AddressOfEntryPointDis
    mov D$esi+ContextFlags 01003F
    call 'KERNEL32.SetThreadContext' D$ebx+PI.hThread, esi | test eax eax | je @bend

    call 'KERNEL32.ResumeThread' D$ebx+PI.hThread | test eax eax | je @bend
    mov D@return 1
    jmp @endpr
@bend:
    call 'KERNEL32.TerminateProcess', D$ebx+PI.hProcess, 0-1
    HClose D$ebx+PI.hThread
    HClose D$ebx+PI.hProcess
@endpr:
@EEnd:
mov eax D@return
EndP

;;








TITLE MZPE
____________________________________________________________________________________________

[ExeProps 0
ExeProps_e_magicDis 0
ExeProps_e_lfanewDis 60]
;IMAGE_NT_HEADERS
[SignatureDis 0
 FileHeader.MachineDis 4
 FileHeader.NumberOfSectionsDis 6
 FileHeader.TimeDateStampDis 8
 FileHeader.PointerToSymbolTableDis 12
 FileHeader.NumberOfSymbolsDis 16
 FileHeader.SizeOfOptionalHeaderDis 20
 FileHeader.CharacteristicsDis 22
 OptionalHeader.MagicDis 24
 OptionalHeader.MajorLinkerVersionDis 26
 OptionalHeader.MinorLinkerVersionDis 27
 OptionalHeader.SizeOfCodeDis 28
 OptionalHeader.SizeOfInitializedDataDis 32
 OptionalHeader.SizeOfUninitializedDataDis 36
 OptionalHeader.AddressOfEntryPointDis 40
 OptionalHeader.BaseOfCodeDis 44
 OptionalHeader.BaseOfDataDis 48
 OptionalHeader.ImageBaseDis 52
 OptionalHeader.SectionAlignmentDis 56
 OptionalHeader.FileAlignmentDis 60
 OptionalHeader.MajorOperatingSystemVersionDis 64
 OptionalHeader.MinorOperatingSystemVersionDis 66
 OptionalHeader.MajorImageVersionDis 68
 OptionalHeader.MinorImageVersionDis 70
 OptionalHeader.MajorSubsystemVersionDis 72
 OptionalHeader.MinorSubsystemVersionDis 74
 OptionalHeader.Win32VersionValueDis 76
 OptionalHeader.SizeOfImageDis 80
 OptionalHeader.SizeOfHeadersDis 84
 OptionalHeader.CheckSumDis 88
 OptionalHeader.SubsystemDis 92
 OptionalHeader.DllCharacteristicsDis 94
 OptionalHeader.SizeOfStackReserveDis 96
 OptionalHeader.SizeOfStackCommitDis 100
 OptionalHeader.SizeOfHeapReserveDis 104
 OptionalHeader.SizeOfHeapCommitDis 108
 OptionalHeader.LoaderFlagsDis 112
 OptionalHeader.NumberOfRvaAndSizesDis 116
 OptionalHeader.DataDirectoryDis 120
 OptionalHeader.DataDirectoryExportDis 120
 OptionalHeader.DataDirectoryExportSizeDis 124
 OptionalHeader.DataDirectoryImportDis 128
 OptionalHeader.DataDirectoryImportSizeDis 132
 OptionalHeader.DataDirectoryResourceDis 136
 OptionalHeader.DataDirectoryResourceSizeDis 140
 OptionalHeader.DataDirectoryExceptionDis 144
 OptionalHeader.DataDirectoryExceptionSizeDis 148
 OptionalHeader.DataDirectoryCertificateDis 152
 OptionalHeader.DataDirectoryCertificateSizeDis 156
 OptionalHeader.DataDirectoryBaseRelocationDis 160
 OptionalHeader.DataDirectoryBaseRelocationSizeDis 164
 OptionalHeader.DataDirectoryDebugDis 168
 OptionalHeader.DataDirectoryDebugSizeDis 172
 OptionalHeader.DataDirectoryArchitectureDis 176
 OptionalHeader.DataDirectoryArchitectureSizeDis 180
 OptionalHeader.DataDirectoryGlobalPtrDis 184
 OptionalHeader.DataDirectoryGlobalPtrSizeDis 188
 OptionalHeader.DataDirectoryTLSDis 192
 OptionalHeader.DataDirectoryTLSsizeDis 196
 OptionalHeader.DataDirectoryLoadConfigDis 200
 OptionalHeader.DataDirectoryLoadConfigsizeDis 204
 OptionalHeader.DataDirectoryBoundImportDis 208
 OptionalHeader.DataDirectoryBoundImportsizeDis 212
 OptionalHeader.DataDirectoryIATDis 216
 OptionalHeader.DataDirectoryIATsizeDis 220
 OptionalHeader.DataDirectoryDelayImportDescriptorDis 224
 OptionalHeader.DataDirectoryDelayImportDescriptorSizeDis 228
 OptionalHeader.DataDirectoryCOMRuntimeHeaderDis 232
 OptionalHeader.DataDirectoryCOMRuntimeHeaderSizeDis 236
 OptionalHeader.DataDirectoryReservedDis 240
]
[Name1Dis 0
 MiscVirtualSizeDis 8
 VirtualAddressDis 12
 SizeOfRawDataDis 16
 PointerToRawDataDis 20
 PointerToRelocationsDis 24
 PointerToLinenumbersDis 28
 NumberOfRelocationsDis 32
 NumberOfLinenumbersDis 34
 CharacteristicsDis 36]

Proc isStandartValidMZPE:
  ARGUMENTS @PeStart @PeSize
  Local @PEend @psects @nsects @szimgraw @szovrl @ImageVsz @trueHeaderSz
  Uses EBX ESI EDI

    mov ebx D@PeStart | mov eax D@PeSize | add eax ebx | mov D@PEend eax
    cmp W$ebx 'MZ' | jne @invalidPE
    mov esi D$ebx+03C | test esi esi | je @invalidPE
    cmp D@PeSize esi | jbe @invalidPE
    lea eax D$esi+078 | cmp D@PeSize eax | jbe @invalidPE
    add esi ebx | cmp D$esi 'PE' | jne @invalidPE
    cmp W$esi+FileHeader.MachineDis 014C | jne @invalidPE
    cmp W$esi+OptionalHeader.MagicDis 010B | jne @invalidPE
    cmp W$esi+OptionalHeader.SubsystemDis 3 | ja @invalidPE
;OptHeader-size vs numRVASZ
    movzx eax W$esi+FileHeader.SizeOfOptionalHeaderDis
    mov ebx D$esi+OptionalHeader.NumberOfRvaAndSizesDis
    shl ebx 3 | add ebx 060 | cmp eax ebx | jne @invalidPE
;OptHeader-size vs File-sz
    lea edi D$esi+ebx+018 | mov D@psects edi | cmp D@PEend edi | jbe @invalidPE
    mov eax D$esi+OptionalHeader.SizeOfHeadersDis
    cmp D@PeSize eax | jb @invalidPE | sub edi D@PeStart | sub eax edi | jle @invalidPE
;Max-possible sections in Header
    sub edx edx | mov ecx 028 | div ecx
    movzx ecx W$esi+FileHeader.NumberOfSectionsDis | mov D@nsects ecx | cmp ecx eax | ja @invalidPE
;no-sects? non-loadable
    test ecx ecx | je @invalidPE
;OptHeader+Sect_size vs File-sz
    imul ecx ecx 028 | add ecx D@psects | cmp D@PEend ecx | jbe @invalidPE
;OptHeader+Sect in Headers
    sub ecx D@PeStart | cmp D$esi+OptionalHeader.SizeOfHeadersDis ecx | jb @invalidPE
;DBGBP
;calc TrueHeaderSz; Get lowest raw section; yep, raw sections can be shuffled in image!
    mov ecx D@nsects | mov edi D@psects | mov eax D$edi+PointerToRawDataDis | jmp L1>
L0: cmp D$edi+PointerToRawDataDis 0 | je L1> ; 0 = no data
    cmp D$edi+PointerToRawDataDis eax | jae L1>
    mov eax D$edi+PointerToRawDataDis
L1: add edi 028 | dec ecx | jne L0<
    test eax eax | je @invalidPE
    mov D@trueHeaderSz eax

    mov ecx D@nsects | mov edi D@psects
;calc RAWdataSZ
L0: add eax D$edi+SizeOfRawDataDis | jc @invalidPE
    add edi 028 | loop L0<
    cmp D@PeSize eax | jb @invalidPE

    move D@szovrl D@PeSize | mov D@szimgraw eax | sub D@szovrl eax
;check RawDataSize align -lastSect
    mov ebx D$esi+OptionalHeader.FileAlignmentDis
    mov ecx D@nsects | mov edi D@psects
    jmp L2>
L0: mov eax D$edi+SizeOfRawDataDis | add edi 028
    sub edx edx | div ebx | test edx edx | jne @invalidPE
L2: dec ecx | jg L0<
;check RawData align
    mov ecx D@nsects | mov edi D@psects
L0: mov eax D$edi+PointerToRawDataDis | add edi 028
    sub edx edx | div ebx | test edx edx | jne @invalidPE
    dec ecx | jg L0<
;align ImageVsz
    mov ebx D$esi+OptionalHeader.SectionAlignmentDis
    mov eax D$esi+OptionalHeader.SizeOfImageDis
    sub edx edx | div ebx | test edx edx | je L0> | inc eax
L0: mul ebx | mov D@ImageVsz eax
;check VA align
    mov ecx D@nsects | mov edi D@psects
L0: mov eax D$edi+VirtualAddressDis | add edi 028 | cmp D@ImageVsz eax | jb @invalidPE
    sub edx edx | div ebx | test edx edx | jne @invalidPE
    dec ecx | jg L0<
;calc VSz aligned
    mov ecx D@nsects | mov edi D@psects | mov eax D$esi+OptionalHeader.SizeOfHeadersDis
L2: sub edx edx | div ebx | test edx edx | je L1> | inc eax
L1: mul ebx | cmp D$edi+MiscVirtualSizeDis 0 | jne L4> | add eax D$edi+SizeOfRawDataDis | jmp L5> ; if Vsz=0 them grab RawSz
L4: add eax D$edi+MiscVirtualSizeDis
L5: add edi 028 | loop L2<
    sub edx edx | div ebx | test edx edx | je L1> | inc eax
L1: mul ebx | cmp D@ImageVsz eax | jne @invalidPE

    sub eax eax | jmp P9>
@invalidPE:
    or eax 0-1
EndP



[<16 bufff: D$ 0CCCCCCCC #0200 bufffend: ]
[sCantOpenFile: B$ "Can't open file!",0]

[ErFileOpen 1 | ErFileSize 2 | ErFileTooSmall 3 | ErFileTooBig 4 | ErNoMem 5
 ErFileRead 6 | ErBadMZPE 7 | ErFileMapRead 8]


Proc ReadExeInit:  ; eax=0 all_ok, edx D@exemem, ecx D@memsz ; eax - any number=nERROR
 ARGUMENTS @ExeProps @ExeName
 cLocal @nError @fh @fsz @exemem @memsz ; @fhm @fmap
 USES EBX ESI EDI

    mov D@nError ErFileOpen
    call 'BaseRTL.FileNameOpenRead' D@ExeName | cmp eax 0 | je @ERR0
    mov D@fh eax | mov D@fsz ecx

    mov D@nError ErFileTooBig | test edx edx | jne @ERR0 | cmp D@fsz 010000000 | ja @ERR0
    mov D@nError ErFileTooSmall | cmp D@fsz 0200 | jb @ERR0
;read MZhead
    mov ebx D@ExeProps
    mov D@nError ErFileRead
    call 'BaseRTL.FileOffsetRead' D@fh, ebx, 040, 0 | test eax eax | je @ERR0

    mov D@nError ErBadMZPE
    cmp W$ebx+ExeProps_e_magicDis 'MZ' | jne @ERR0
    mov esi D$ebx+ExeProps_e_lfanewDis | test esi esi | jle @ERR0
    cmp D@fsz esi | jbe @ERR0 | lea eax D$esi+078 | cmp D@fsz eax | jbe @ERR0 ;
;read PEhead
    mov D$ebx+ExeProps_e_lfanewDis 040
    add ebx 040
    mov D@nError ErFileRead
    call 'BaseRTL.FileOffsetRead' D@fh, ebx, 078, esi | test eax eax | je @ERR0

    mov D@nError ErBadMZPE
    cmp D$ebx 'PE' | jne @ERR0
;read Dirs
    add esi 078
    movzx edi W$ebx+FileHeader.SizeOfOptionalHeaderDis | cmp edi 0E0 | ja @ERR0
    sub edi 060 | jle @ERR0 | lea eax D$esi+edi | cmp D@fsz eax | jbe @ERR0
    lea eax D$ebx+078
    mov D@nError ErFileRead
    call 'BaseRTL.FileOffsetRead' D@fh, eax, edi, esi | test eax eax | je @ERR0
;read Sections
    mov D@nError ErBadMZPE
    movzx ecx W$ebx+FileHeader.NumberOfSectionsDis | imul ecx ecx 028 | test ecx ecx | je L0>
    add esi edi | lea eax D$esi+ecx | cmp D@fsz eax | jbe @ERR0
    lea eax D$ebx+0F8
    mov D@nError ErFileRead
    call 'BaseRTL.FileOffsetRead' D@fh, eax, ecx, esi | test eax eax | je @ERR0
L0:
DBGBP
    mov D@nError ErBadMZPE
    call isStandartValidMZPE D@ExeProps D@fsz | test eax eax | jne @ERR0

    mov eax D$ebx+OptionalHeader.SizeOfImageDis, D@memsz eax
    mov D@nError ErNoMem
    call VAlloc eax | test eax eax | je @ERR0
    mov D@exemem eax
;load headers
    mov D@nError ErFileRead
    call 'BaseRTL.FileOffsetRead' D@fh, D@exemem, D$ebx+OptionalHeader.SizeOfHeadersDis, 0 | test eax eax | je @ERR0

    movzx ecx W$ebx+FileHeader.NumberOfSectionsDis | lea esi D$ebx+0F8
L1:
    dec ecx | js L0>
    mov edi D$esi+VirtualAddressDis, eax D$esi+SizeOfRawDataDis, edx D$esi+PointerToRawDataDis
    add edi D@exemem | test eax eax | je L2>
    call 'BaseRTL.FileOffsetRead' D@fh, edi, eax, edx | test eax eax | je @ERR0
L2: add esi 028 | jmp L1<
L0:
    mov D@nError 0
@ERR0:
HClose D@fh
mov eax D@nError, edx D@exemem, ecx D@memsz
EndP


Proc MapExeInit: ; eax=0 all_ok, edx D@exemem, ecx D@memsz ; any number=nERROR
 ARGUMENTS @ExeProps @ExeName
 cLocal @nError @hMap @fsz @exemem @memsz ; @fhm @fmap
 USES EBX ESI EDI
;DBGBP
    mov D@nError ErFileMapRead
    call 'BaseRTL.FileNameMapRead' D@ExeName | cmp eax 0 | je @ERR0
    mov D@hMap eax | mov D@fsz ecx

    mov D@nError ErFileTooBig | test edx edx | jne @ERR0 | cmp D@fsz 010000000 | ja @ERR0
    mov D@nError ErFileTooSmall | cmp D@fsz 0200 | jb @ERR0

    mov D@nError ErBadMZPE
    call isStandartValidMZPE D@hMap D@fsz | test eax eax | jne @ERR0
;read MZhead
    mov ebx D@ExeProps
    call FileMapCopy D@hMap, ebx, 040, 0

    mov esi D$ebx+ExeProps_e_lfanewDis
    lea eax D$esi+078
;read PEhead
    mov D$ebx+ExeProps_e_lfanewDis 040
    add ebx 040
    call FileMapCopy D@hMap, ebx, 078, esi
;read Dirs
    add esi 078
    movzx edi W$ebx+FileHeader.SizeOfOptionalHeaderDis
    sub edi 060
    lea eax D$ebx+078
    call FileMapCopy D@hMap, eax, edi, esi
;read Sections
    movzx ecx W$ebx+FileHeader.NumberOfSectionsDis | imul ecx ecx 028 | test ecx ecx | je L0>
    add esi edi
    lea eax D$ebx+0F8
    call FileMapCopy D@hMap, eax, ecx, esi
L0:
    ;call 'BaseRTL.FileMapClose' D@hMap | and D@hMap 0

    mov eax D$ebx+OptionalHeader.SizeOfImageDis, D@memsz eax
    mov D@nError ErNoMem
    call VAlloc eax | test eax eax | je @ERR0
    mov D@exemem eax
;load headers
    mov D@nError ErFileRead
    call FileMapCopy D@hMap, D@exemem, D$ebx+OptionalHeader.SizeOfHeadersDis, 0
    call dumpfixMZPE D@exemem
    movzx ecx W$ebx+FileHeader.NumberOfSectionsDis
    movzx esi W$ebx+FileHeader.SizeOfOptionalHeaderDis | lea esi D$ebx+esi+OptionalHeader.MagicDis
L1:
    dec ecx | js L0>
    mov edi D$esi+VirtualAddressDis, eax D$esi+SizeOfRawDataDis, edx D$esi+PointerToRawDataDis
    add edi D@exemem | test eax eax | je L2>
    call FileMapCopy D@hMap, edi, eax, edx
L2: add esi 028 | jmp L1<
L0:
    mov D@nError 0
@ERR0:
    call 'BaseRTL.FileMapClose' D@hMap | and D@hMap 0
    mov eax D@nError, edx D@exemem, ecx D@memsz
EndP



Proc FileMapCopy:
 ARGUMENTS @hMap @buff @bytes2read @offset
 USES ecx esi edi

    mov esi D@hMap, edi D@buff, ecx D@bytes2read | shr ecx 2
    add esi D@offset | CLD | rep movsd | mov ecx D@bytes2read | and ecx 3 | rep movsb

EndP



Proc dumpfixMZPE:
 ARGUMENTS @pMZheader
 USES EBX ESI EDI
;DBGBP
    cld
    mov ebx D@pMZheader;
    cmp W$ebx 'MZ' | jne E0>
    add ebx D$ebx+ExeProps_e_lfanewDis
    cmp D$ebx 'PE' | jne E0>
    cmp D$ebx+OptionalHeader.SectionAlignmentDis 01000 | jne E0>

    ALIGN_ON 01000 D$ebx+OptionalHeader.SizeOfImageDis
    ALIGN_ON 01000 D$ebx+OptionalHeader.SizeOfHeadersDis
    movzx eax W$ebx+FileHeader.SizeOfOptionalHeaderDis
    movzx ecx W$ebx+FileHeader.NumberOfSectionsDis
    lea ebx D$ebx+eax+OptionalHeader.MagicDis
    add ebx 08
    sub ebx 028
L0:
    add ebx 028
    mov esi ebx
    lea edi D$ebx+08
    ALIGN_ON 01000  D$ebx
    movsd | movsd
    dec ecx | jg L0<
    xor eax eax
    inc eax
    pop edi
    pop esi
    pop ebx
    jmp P9>
E0:
    xor eax, eax
EndP



;;
function initexe(exe:PChar): cardinal;//0=all_ok, any number=ERROR_numb

ds:= PE.OptionalHeader.NumberOfRvaAndSizes * 8;
nns:= PE.FileHeader.NumberOfSections;
asm add cp, PEs; end;
'BaseRTL.CopyMemory'(@DDir,cp,ds);

n:= n + $18 + PE.FileHeader.SizeOfOptionalHeader;
asm mov eax, fm; add eax, n; mov cp, eax; end;
PSectMap:=NIL;
SetLength(PSectMap,nns+1);
'BaseRTL.CopyMemory'(@PSectMap[1], cp, (nns * $28));
mapexesections;
manageIT;
if isConsole
 then begin
 pD2H(@dstr[1],@nIIT);
 writeln(dstr+' Import Descritors');
 pD2H(@dstr[1],@nTHK);
 writeln(dstr+' Thunks');
 pD2H(@dstr[1],@ITsz);
 writeln(' IT size = '+dstr);
 end;
//asm db $cc; end;
 buildIT;
_lexit;
result:=0;
end;
;;



;;

;*************************
Proc isValidMZPEa:
  ARGUMENTS @PeStart @PeSize
  Local @PEend @psects @nsects @szimgraw @szovrl @ImageVsz
  Uses EBX ESI EDI

    mov ebx D@PeStart | mov eax D@PeSize | add eax ebx | mov D@PEend eax
    cmp W$ebx 'MZ' | jne @invalidPE
    mov esi D$ebx+03C | cmp D@PeSize esi | jbe @invalidPE
    lea eax D$esi+078 | cmp D@PeSize eax | jbe @invalidPE
    add esi ebx | cmp D$esi 'PE' | jne @invalidPE
    cmp W$esi+FileHeader.MachineDis 014C | jne @invalidPE
    cmp W$esi+OptionalHeader.MagicDis 010B | jne @invalidPE
    cmp W$esi+OptionalHeader.SubsystemDis 3 | ja @invalidPE
;OptHeader-size vs numRVASZ
    movzx eax W$esi+FileHeader.SizeOfOptionalHeaderDis
    mov ebx D$esi+OptionalHeader.NumberOfRvaAndSizesDis | shl ebx 3 | add ebx 060 | cmp eax ebx | jne @invalidPE
;OptHeader-size vs File-sz
    lea edi D$esi+ebx+018 | mov D@psects edi | cmp D@PEend edi | jbe @invalidPE
;Header-sz vs File-sz
    mov eax D$esi+OptionalHeader.SizeOfHeadersDis
    cmp D@PeSize eax | jb @invalidPE
;Header-sz vs OptHeader-size
    sub edi D@PeStart | sub eax edi | jle @invalidPE
;Max-possible sections in Header
    sub edx edx | mov ecx 028 | div ecx
    movzx ecx W$esi+FileHeader.NumberOfSectionsDis | mov D@nsects ecx | cmp ecx eax | ja @invalidPE
;OptHeader+Sect_size vs File-sz
    imul ecx ecx 028 | add ecx D@psects | cmp D@PEend ecx | jbe @invalidPE
;OptHeader+Sect in Headers
    sub ecx D@PeStart | cmp D$esi+OptionalHeader.SizeOfHeadersDis ecx | jb @invalidPE
;Base_Align
    test D$esi+OptionalHeader.ImageBaseDis 0FFFF | jne @invalidPE

;Sect_Align value check
    mov eax 010000 | mov ecx D$esi+OptionalHeader.SectionAlignmentDis
    cmp D$esi+OptionalHeader.FileAlignmentDis ecx | ja @invalidPE
    cmp ecx 01000 | jae L0> | cmp D$esi+OptionalHeader.FileAlignmentDis ecx | jne @invalidPE
L0:
    cmp ecx eax | je L1> | shr eax 1 | je @invalidPE | jmp L0<
L1:
;Data_Align value check
    mov eax 010000
L0:
    cmp D$esi+OptionalHeader.FileAlignmentDis eax | je L1> | shr eax 1 | je @invalidPE | jmp L0<
L1:

    mov ebx D$esi+OptionalHeader.FileAlignmentDis
;DataSz-aligment check
    mov ecx D@nsects | mov edi D@psects
    jmp L2>
L0: mov eax D$edi+SizeOfRawDataDis | add edi 028
    sub edx edx | div ebx | test edx edx | jne @invalidPE
L2: dec ecx | jg L0<
;pData-aligment check
    mov ecx D@nsects | mov edi D@psects
L0: mov eax D$edi+PointerToRawDataDis | add edi 028
    sub edx edx | div ebx | test edx edx | jne @invalidPE
    dec ecx | jg L0<
;lowest Sect pData
    mov ecx D@nsects | mov edi D@psects | mov eax D@PeSize
L0: cmp D$edi+PointerToRawDataDis 0 | je L1>
    cmp D$edi+PointerToRawDataDis eax | jae L1> | mov eax D$edi+PointerToRawDataDis
L1: add edi 028 | dec ecx | jg L0<
;DataSizes sum
    mov ecx D@nsects | mov edi D@psects
L0: add eax D$edi+SizeOfRawDataDis | add edi 028 | loop L0< | cmp D@PeSize eax | jb @invalidPE
    move D@szovrl D@PeSize | mov D@szimgraw eax | sub D@szovrl eax


    mov ebx D$esi+OptionalHeader.SectionAlignmentDis
;SizeOfImage align
    mov eax D$esi+OptionalHeader.SizeOfImageDis
    sub edx edx | div ebx | test edx edx | je L0> | inc eax
L0: mul ebx | mov D@ImageVsz eax

;VA-aligment check
    mov ecx D@nsects | mov edi D@psects
L0: mov eax D$edi+VirtualAddressDis | add edi 028 | cmp D@ImageVsz eax | jb @invalidPE
    sub edx edx | div ebx | test edx edx | jne @invalidPE
    dec ecx | jg L0<

;VA Sum
    mov ecx D@nsects | mov edi D@psects | mov eax D$esi+OptionalHeader.SizeOfHeadersDis
L2: sub edx edx | div ebx | test edx edx | je L1> | inc eax
L1: mul ebx | cmp D$edi+VirtualSizeDis 0 | jne L4> | add eax D$edi+SizeOfRawDataDis | jmp L5>
L4: add eax D$edi+VirtualSizeDis
L5: add edi 028 | loop L2<
    sub edx edx | div ebx | test edx edx | je L1> | inc eax
L1: mul ebx | cmp D@ImageVsz eax | jne @invalidPE

    sub eax eax | jmp P9>
@invalidPE:
    or eax 0-1
EndP
;;

____________________________________________________________________________________________

Proc RelocateEXEfile:
    ARGUMENTS @pEXEfile @NewBase
    Local @diff, @nSects, @pSects, @PEhdr ;, @OldBase
    USES ebx, esi, edi

    mov ebx D@pEXEfile | add ebx D$ebx+03C | mov D@PEhdr ebx
    mov esi D$ebx+OptionalHeader.DataDirectoryBaseRelocationDis
    test esi esi | je @noRelocs

    movzx eax W$ebx+FileHeader.SizeOfOptionalHeaderDis | lea eax D$ebx+eax+018
    mov D@pSects eax
    movzx ecx W$ebx+FileHeader.NumberOfSectionsDis
    mov D@nSects ecx
    mov eax D@NewBase | sub eax D$ebx+OptionalHeader.ImageBaseDis
    mov D@diff eax

    call RVA2RO D@pSects D@nSects esi | test eax eax | js P9>>
    mov esi eax | add esi D@pEXEfile


    mov edi D$ebx+OptionalHeader.DataDirectoryBaseRelocationDis+4
    mov edx D$ebx+OptionalHeader.SizeOfImageDis

    call ScanRelocation esi, edi, edx | test eax eax | je @noRelocs
    cmp D$ebx+OptionalHeader.SectionAlignmentDis 01000
    mov edx D@diff | mov ebx edi
    jae L0>
    cmp D$esi 0 | jne L0>
    sub ebx 8 | lodsd | jmp L2> ; DRIVER case
L0: ;@rep_ldsect:
    sub ebx 8
    lodsd | call RVA2RO D@pSects D@nSects eax | test eax eax | js P9>>
L2:
    mov edi eax | add edi D@pEXEfile | lodsd | lea ecx D$eax-8
    shr ecx 1
L1: ;@rep_ldw:
    dec ecx | js L0<
    sub ebx 2
    mov ax W$esi | shl eax 010| lodsw|
    shr ax 0C| je N0>| cmp al 06| je N0>| cmp al 07| je N0>
    shr eax 010| and eax 0FFF | add D$edi+eax edx
N0: ;@NullRlc:
    test ebx ebx | je L3>
    jmp L1<
L3: ;@Done:
    mov eax D@PEhdr | add D$eax+OptionalHeader.ImageBaseDis edx
    sub eax eax | jmp P9>

@noRelocs:
or eax 0-1
EndP

____________________________________________________________________________________________

Proc RVA2RO:
    ARGUMENTS @pSects @nSects @RVA
    USES ecx, edx

    mov eax D@RVA | mov ecx D@pSects | cmp D@nSects 0 | jle B0>
    test eax eax | jle B0>
    sub ecx 028
@loopSects: dec D@nSects | jns L0>
B0: or eax 0-1 | jmp P9>
L0: add ecx 028 | mov edx D$ecx+VirtualAddressDis | cmp edx eax | ja @loopSects
    cmp D$ecx+MiscVirtualSizeDis 0 | jne L0> | add edx D$ecx+SizeOfRawDataDis | jmp L1>
L0: add edx D$ecx+MiscVirtualSizeDis
L1: cmp edx eax | jbe @loopSects
    sub eax D$ecx+VirtualAddressDis | add eax D$ecx+PointerToRawDataDis
EndP

;;
____________________________________________________________________________________________

Proc getSectNumber:
    ARGUMENTS @pSects @nSects @RVA
    USES ecx, edx, ebx

    mov eax D@RVA | mov ecx D@pSects | cmp D@nSects 0 | je P9>
    test eax eax | je P9>
    sub ebx ebx
    sub ecx 028
@loopSects: dec D@nSects | jns L0> | or eax 0-1 | jmp P9>
L0: inc ebx | add ecx 028 | mov edx D$ecx+VirtualAddressDis | cmp edx eax | ja @loopSects
    cmp D$ecx+MiscVirtualSizeDis 0 | jne L0> | add edx D$ecx+SizeOfRawDataDis | jmp L1>
L0: add edx D$ecx+MiscVirtualSizeDis
L1: cmp edx eax | jbe @loopSects
    mov eax ebx
EndP

________________________________________________________
Proc getNewVA:
    ARGUMENTS @pSects @nSects @RVA
    USES ecx, edx, ebx

    mov eax D@RVA | mov ecx D@pSects | cmp D@nSects 0 | je P9>
    test eax eax | je P9>
    sub ecx 028
@loopSects: dec D@nSects | jns L0> | or eax 0-1 | jmp P9>
L0: add ecx 028 | mov edx D$ecx+VirtualAddressDis | cmp edx eax | ja @loopSects
    cmp D$ecx+MiscVirtualSizeDis 0 | jne L0> | add edx D$ecx+SizeOfRawDataDis | jmp L1>
L0: add edx D$ecx+MiscVirtualSizeDis
L1: cmp edx eax | jbe @loopSects
    mov edx D$ecx+SecTRez1 | sub edx D$ecx+VirtualAddressDis
    add eax edx
EndP
;;

____________________________________________________________________________________________

Proc RelocateEXE:
    ARGUMENTS @pEXE @disval
    USES ebx, esi, edi

    mov ebx D@pEXE | add ebx D$ebx+03C | mov esi D$ebx+OptionalHeader.DataDirectoryBaseRelocationDis
    test esi esi | je @noRelocs | add esi D@pEXE
    mov edi D$ebx+OptionalHeader.DataDirectoryBaseRelocationDis+4
    mov edx D$ebx+OptionalHeader.SizeOfImageDis

    call ScanRelocation esi, edi, edx |test eax eax | je @noRelocs
    mov edx D@disval
    mov ebx edi

L0: ;@rep_ldsect:
    sub ebx 8
    lodsd | add eax D@pEXE | mov edi eax | lodsd | lea ecx D$eax-8
    shr ecx 1
L1: ;@rep_ldw:
    dec ecx | js L0<
    sub ebx 2
    mov ax W$esi | shl eax 010| lodsw|
    shr ax 0C| je N0>| cmp al 06| je N0>| cmp al 07| je N0>
    shr eax 010| and eax 0FFF | add D$edi+eax edx
N0: ;@NullRlc:
    test ebx ebx | je L3>
    jmp L1<
L3: ;@Done:
    sub eax eax | jmp P9>

@noRelocs:
or eax 0-1
EndP


;************
Proc ScanRelocation: ; returns NumOfPointer or 0 on bad
 Arguments @Relocs, @RelocSize, @maxVA
  USES ECX EDX EBX ESI EDI

    cld| mov esi D@Relocs, ebx D@RelocSize, edi D@maxVA
    sub edi 4 | xor edx edx

L0: ;@szrep_ldsect:
    sub ebx 8 | jle B0>
    lodsd | cmp eax edi | ja B0>
    lodsd | lea ecx D$eax-8 | cmp ecx 0800 | ja B0>
    shr ecx 1
L1: ;@szrep_ldw:
    dec ecx | js L0<
    sub ebx 2 | js B0>
    lodsw
    shr ax 0C| je N0>| cmp al 06| je N0>| cmp al 07| je N0>| cmp al 03| jne B0>
    inc edx
N0: ;@szNullRlc:
    test ebx ebx | je L3>
    jmp L1<
B0: ;@szbadReloc:
    xor edx edx
L3: ;Done
    mov eax edx

EndP


________________________

Proc BuildRVAPointersFromReloc:
 Arguments @PntrsTable, @Relocs, @RelocSize
  USES EBX ESI EDI

    cld| mov edi D@PntrsTable, esi D@Relocs, ebx D@RelocSize

L0: ;@rep_ldsect:
    sub ebx 8 | jle B0>
    lodsd | mov edx eax | lodsd | lea ecx D$eax-8 | cmp ecx 0800 | ja B0>
    shr ecx 1
L1: ;@rep_ldw:
    dec ecx | js L0<
    sub ebx 2 | js B0>
    mov ax W$esi | shl eax 010| lodsw|
    shr ax 0C| je N0>| cmp al 06| je N0>| cmp al 07| je N0>| cmp al 03| jne B0>
    shr eax 010| and eax 0FFF | add eax edx | stosd
N0: ;@NullRlc:
    test ebx ebx | je L3>;Done
    jmp L1<;@rep_ldw
B0: ;@badReloc:
    sub eax eax | jmp P9>
L3: ;@Done:
    mov eax edi | sub eax D@PntrsTable | shr eax 2

EndP
________________________

Proc BuildRelocFromSortedPointers:
 Arguments @PEBase, @PtrsTable, @nPtrs
  cLocal @RLCmem @nRlcs
  USES EBX ESI EDI
 DBGBP
    mov esi D@PtrsTable, ecx D@nPtrs, edx D@PEBase
    test ecx ecx | jle P9>>
;calc req mem sz
    sub ebx ebx | sub edi edi
L0: sub ecx 1 | js L3> | lodsd
L2: cmp eax edx | jae L1>
    add ebx 2 | add edi 1 | jmp L0<
L1: add edx 01000 | test edi edi | je L2< ; no RLC for that page
    ALIGN_ON 4 ebx | add ebx 08 | add D@nRlcs edi | sub edi edi | jmp L2<
L3: ALIGN_ON 4 ebx | add ebx 08 | add D@nRlcs edi

    call VAlloc ebx | mov D@RLCmem eax, edi eax
    test eax eax | je P9>
    cld
    mov esi D@PtrsTable, edx D@PEBase
    sub ecx ecx
L0: sub D@nPtrs 1 | js L3> | lodsd
L2: cmp eax edx | jae L1>
    sub eax edx | add eax 04000 | mov W$edi+ecx+8 ax | add ecx 2 | jmp L0<
L1: add edx 01000 | test ecx ecx | je L2< ; no RLC for that page
    ALIGN_ON 4 ecx | add ecx 08 | mov eax edx | sub eax D@PEBase | sub eax 02000
    mov D$edi eax, D$edi+4 ecx | add edi ecx | sub ecx ecx | mov eax D$esi-04 | jmp L2<
L3: ALIGN_ON 4 ecx | add ecx 08 | mov eax edx | sub eax D@PEBase | sub eax 01000
    mov D$edi eax, D$edi+4 ecx | add edi ecx
    mov eax D@RLCmem | mov edx edi | sub edx eax
EndP


____________________________________________________________

TITLE ExportRip

;[ExportViewBuffer: D$ ? #040] [AfterExportViewBuffer: ?]
; used RosAsm code
Proc Exports2DummySource:
 ARGUMENTS @pEXE @ExeSz
 cLocal @pExeEnd @currBufptr @ExportMem
 USES EBX ESI EDI
;DBGBP
    mov eax D@pEXE | add eax D@ExeSz | mov D@pExeEnd eax
   ;GetPeHeader SectionTable
    mov eax D@pEXE | add eax D$eax+ExeProps_e_lfanewDis
    mov edi D$eax+OptionalHeader.DataDirectoryExportDis | test edi edi | jle E9>>
    add edi D@pEXE
    mov ebx D$eax+OptionalHeader.DataDirectoryExportSizeDis | test ebx ebx | jle E9>>

      ; Number of Functions:
        mov ecx D$edi+(5*4) | cmp ecx 0 | jle E9>>

push ecx
    mov eax 14 | MUL ecx | lea eax D$eax+ebx*2
    call VAlloc eax | mov D@ExportMem eax, D@currBufptr eax
pop ecx
    test eax eax | je P9>>
    CLD
push ecx edi
    mov edi D@currBufptr
    mov eax 'EXP=' | STOSD
    call Dword2Decimal edi ecx | add edi eax | mov eax CRLF | STOSW | STOSW
    mov D@currBufptr edi
pop edi ecx

      ; Pointer to ExportAdressesTable:
        mov ebx D$edi+(7*4) | On ebx <> 0, add ebx D@pEXE | cmp ebx 0 | jle E9>>
      ; Pointer to ExportNamesTable:
        mov esi D$edi+(8*4) | On esi <> 0, add esi D@pEXE
      ; Pointer to ExportOrdinals:
        mov edx D$edi+(9*4) | On edx <> 0, add edx D@pEXE

        If esi = edx
         mov esi 0, edx 0
        End_If

L0:
        If D$ebx = 0
           pushad
           jmp L5>>
        End_If
; Write the Ordinal:
        mov eax ebx | sub eax D@pEXE | sub eax D$edi+(7*4) | shr eax 2
        pushad
        add eax D$edi+(4*4)
        mov edi D@currBufptr | mov D$edi 'ORD' | add edi 3
        call WriteEax | mov D$edi '::' | add edi 2 | mov D@currBufptr edi
        popad
; Write the Relative Address:
;        pushad
;        mov eax D$ebx
        ;mov edi ExportViewBuffer | call WriteEax | mov B$edi 0
;        popad

     pushad
     cmp edx 0 | je L2>
     mov ecx D$edi+(6*4) | mov edi edx | repne scasw | jne L2>
     sub edi 2 | sub edi edx | shl edi 1 | mov esi D$esi+edi | test esi esi | je L2>
     add esi D@pEXE
     mov edi D@currBufptr | mov B$edi '"' | add edi 1
L1:  lodsb | stosb | test al al | jne L1<
     mov B$edi-1 '"' | mov D@currBufptr edi
L2:  mov edi D@currBufptr | mov eax 0A0D | stosw | mov D$edi 'RET' | add edi 3 | mov eax 0A0D0A0D | stosd
     mov D@currBufptr edi
L5:
     popad | add ebx 4 | sub ecx 1 | jg L0<<

    mov eax D@ExportMem, edx D@currBufptr | sub edx eax | jmp P9>
E9:
    call VFree D@ExportMem | sub eax eax
EndP


[HexaTable: '0123456789ABCDEF']
WriteEax:
    mov ebx eax

L3: If ebx = 0
        mov B$edi '0' | inc edi | ret
    End_If

    push 0-1

L0: mov eax ebx | shr ebx 4 | and eax 0F

    mov al B$HexaTable+eax
    push eax
    cmp ebx 0 | ja L0<
    mov B$edi '0' | inc edi
L0: pop eax | cmp eax 0-1 | je L9>
    mov B$edi al | inc edi | jmp L0<
L9: ret



TITLE cosmocomprso
____________________________________________________________________________________________

Proc makeBigNumFromPrimes:
 ARGUMENTS @nBits
 cLocal @BitSz
 USES ebx esi edi
    mov ebx D@nBits | shr ebx 3 | add ebx 4
    call VAlloc ebx | mov esi eax | test eax eax | je @BM
    call VAlloc ebx | mov edi eax | test eax eax | je @BM

    mov D$esi 3, D@BitSz 32 | mov ebx 3
L0:
    call 'NUMERIKO.FindNextPrimeDwordNumeriko32' ebx | test eax eax | je @BM | mov ebx eax

    mov eax D@BitSz | add eax 32
    call 'AnyBits.AnyBitsMul32Bit' edi eax ebx esi D@BitSz | test eax eax | je @BM
    shl eax 3 | mov D@BitSz eax | xchg esi edi | cmp eax D@nBits | jbe L0<
    ;mov ebx D@BitSz | shr ebx 3
    ;call 'BaseRTL.WriteMem2FileNameA' {"NumMulDUMP1",0} edi ebx
    ;call 'BaseRTL.WriteMem2FileNameA' {"NumMulDUMP2",0} esi ebx
    jmp L0>
@BM:
    call VFree edi | sub edi edi | and D@nBits 0
L0:
    call VFree esi |
    mov eax edi, edx D@nBits
EndP
;
;
Proc Primes32OutFromBits:
 ARGUMENTS @AnyBits @AnyBitsSz
; cLocal @inMem1 @inMemSz1
 USES EBX ESI EDI

and D$JobAskToEnd 0
    sub edi edi
    cmp D$SieveBase0 0 | jne L0>
    call TryLoad4GBrangeSieveFile 0 | mov D$SieveBase0 eax | test eax eax | je @BM
L0:
    mov esi D@AnyBitsSz
    updateBitSize D@AnyBits esi
;    call MakeNumCopy D@inMem D@inMemSz | test eax eax | je @BM
;    mov D@inMem1 eax, D@inMemSz1 edx
    mov ebx D@AnyBits
call SetStartTick
L0:
    test D$ebx 1 | jne L0>
    call 'AnyBits.AnyBitsShift1Right'  D@AnyBits esi | inc edi | jmp L0<
L0:
    mov ebx 3
L2:
    call 'AnyBits.AnyBitsMod32Bit' D@AnyBits esi ebx | test eax eax | je @BM
    test edx edx | jne L1>
    call 'AnyBits.AnyBitsDiv32Bit' D@AnyBits esi ebx ;| test eax eax | je @BM
    inc edi
    updateBitSize D@AnyBits esi
call SetEndTick
    call dumpNumNmods ebx edi
call SetStartTick
    jmp L2<
L1:
cmp D$JobAskToEnd &TRUE | je @BM
;    call 'NUMERIKO.FindNextPrimeDwordNumeriko32' ebx | cmp eax 0 | je @BM
    call 'NUMERIKO.GetNextPrimeFromSieve' D$SieveBase0 ebx | test eax eax | je @BM
    mov ebx eax
    mov D$NextPrimeForMod ebx
    ;cmp ebx 0-5
    jmp L2<
@BM:
call SetEndTick
    call dumpNum64Nmods 1 EBX 0
    call VFree D$SieveBase0 | and D$SieveBase0 0
    mov eax edi
EndP
;
;
Proc Primes64SievedOutFromBits:
 ARGUMENTS @SieveBase @AnyBits @AnyBitsSz
 cLocal @SieveBaseMem @DivCount @p64Hi @p64Lo
 USES EBX ESI EDI

and D$JobAskToEnd 0
    sub edi edi | sub esi esi
    call TryLoad4GBrangeSieveFile D@SieveBase | mov D@SieveBaseMem eax | test eax eax | jne L0>;@BM
    call CreateSieveFor64bit4GbRange D@SieveBase | test eax eax | je @BM
    mov D@SieveBaseMem eax
L0:
    call 'NUMERIKO.GetFirstPrimeFromSieve' D@SieveBaseMem | mov D@p64Lo eax | test eax eax | je @BM
    move D@p64Hi D@SieveBase
    updateBitSize D@AnyBits D@AnyBitsSz
    mov esi D@AnyBits
call SetStartTick
L0:
    test D$esi 1 | jne L0>
    call 'AnyBits.AnyBitsShift1Right'  esi D@AnyBitsSz | inc D@DivCount | jmp L0<
L0:
    lea ebx D@p64Lo
    mov eax D@AnyBitsSz | shr eax 3 | call VAlloc eax | mov edi eax | test eax eax | je @BM
L2:
    mov eax D@AnyBitsSz | shr eax 3 | call 'BaseRTL.CopyMemory' edi esi eax
    call 'AnyBits.AnyBitsModulus' ebx 64 edi D@AnyBitsSz | test eax eax | je @BM
    test edx edx | jne L1>
    call 'AnyBits.AnyBitsDivision'  edi D@AnyBitsSz ebx 64 esi D@AnyBitsSz | test eax eax | je @BM
    updateBitSize edi D@AnyBitsSz
    mov eax D@AnyBitsSz | shr eax 3 | call 'BaseRTL.CopyMemory' esi edi eax
    inc D@DivCount
call SetEndTick
    call dumpNum64Nmods 0 D@p64Lo D@p64Hi
call SetStartTick
    jmp L2<<
L1:
cmp D$JobAskToEnd &TRUE | je @BM
    call 'NUMERIKO.GetNextPrimeFromSieve' D@SieveBaseMem D@p64Lo | test eax eax | je @BM
    mov D@p64Lo eax
    move D$NextPrimeForMod D@p64Lo, D$NextPrimeForMod+4 D@p64Hi
    jmp L2<<
@BM:
call SetEndTick
    call dumpNum64Nmods 1 D@p64Lo D@p64Hi
    call VFree edi | call VFree D@SieveBaseMem
    mov eax D@DivCount
EndP
;
;
;
Proc Primes64NumerikoOutFromBits:
 ARGUMENTS @start64Lo @start64Hi @AnyBits @AnyBitsSz
 cLocal @DivCount
 USES EBX ESI EDI

and D$JobAskToEnd 0
    sub edi edi | mov esi D@AnyBits
    cmp D$szB32P B32Psize | je L0>
    call TryLoadB32primesFile | test eax eax | je P9>>
    mov D$mB32P eax, D$szB32P edx
L0:
    test D$esi 1 | jne L0>
    call 'AnyBits.AnyBitsShift1Right'  esi D@AnyBitsSz | inc D@DivCount | jmp L0<
L0:
call SetStartTick
    updateBitSize D@AnyBits D@AnyBitsSz
    lea ebx D@start64Lo
    mov eax D@AnyBitsSz | shr eax 3 | call VAlloc eax | mov edi eax | test eax eax | je P9>>
    jmp L1>>
L2:
    mov eax D@AnyBitsSz | shr eax 3 | call 'BaseRTL.CopyMemory' edi esi eax
    call 'AnyBits.AnyBitsModulus' ebx 64 edi D@AnyBitsSz | test eax eax | je @BM
    test edx edx | jne L1>
    call 'AnyBits.AnyBitsDivision'  edi D@AnyBitsSz ebx 64 esi D@AnyBitsSz | test eax eax | je @BM
    updateBitSize edi D@AnyBitsSz
    mov eax D@AnyBitsSz | shr eax 3 | call 'BaseRTL.CopyMemory' esi edi eax
    inc D@DivCount
call SetEndTick
    call dumpNum64Nmods 0 D@start64Lo D@start64Hi
    call reportCurrentNumNmods64 1 D@start64Lo D@start64Hi
call SetStartTick
    jmp L2<<
L1:
cmp D$JobAskToEnd &TRUE | je @BM
    call 'NUMERIKO.FindNextPrimeQwordNumeriko64' D$mB32P D@start64Lo D@start64Hi | test eax eax | je @BM
    mov D@start64Lo eax, D@start64Hi edx
    mov D$NextPrimeForMod eax, D$NextPrimeForMod+4 edx
    jmp L2<<
@BM:
call SetEndTick
    call reportCurrentNumNmods64 1 D@start64Lo D@start64Hi
    call dumpNum64Nmods 1 D@start64Lo D@start64Hi
    call VFree edi
    mov eax D@start64Lo, edx D@start64Hi, ecx D@DivCount
EndP
;
;
;
[NextPrimeForMod: D$ 0, 0]
Proc NumberModOnAll32BitPrimes:
 ARGUMENTS @inMem @inMemSz @startPrime
 USES EBX ESI ;EDI

    mov ebx D@startPrime | cmp ebx 3 | jae L0> | mov ebx 3
L0:
    mov esi D@inMemSz | shl esi 3
L0:
    call 'AnyBits.AnyBitsMod32Bit' D@inMem esi ebx | test eax eax | je L0>
    mov D$NextPrimeForMod ebx
    test edx edx | je E0>
    call 'NUMERIKO.FindNextPrimeDword' ebx | cmp eax 0 | je L1> | mov ebx eax
    jmp L0<
L0: mov ebx 0 | jmp E0>
L1: mov ebx 1
E0:
    mov eax ebx
EndP
;
;
Proc NumberModOnAll32BitPrimesNumeriko:
 ARGUMENTS @inMem @inMemSz @mB32P @szB32P @startPrime
 USES EBX ESI EDI

    call 'NUMERIKO.FindNearPrime32FromBit32DiffArray' D@mB32P D@szB32P 1 D@startPrime
    test eax eax | mov ebx eax, edi ecx | je L2>
    mov esi D@inMemSz | shl esi 3
L0:
    call 'AnyBits.AnyBitsMod32Bit' D@inMem esi ebx | test eax eax | je L2>
    mov D$NextPrimeForMod ebx
    test edx edx | je E0>
    mov eax D@mB32P | movzx eax B$eax+edi | shl eax 1 | add eax EBX | jc L1>
    mov ebx eax | inc edi
;    call 'NUMERIKO.GetNextPrime32FromDiffArrayPosition' D@mB32P D@szB32P EDI EBX
;    cmp eax 0 | je L1> | mov ebx eax, edi ecx
    jmp L0<
L2: mov ebx 0 | jmp E0>
L1: mov ebx 1
E0:
    mov eax ebx
EndP
;
;
Proc NumberModOn32BitPrimesFromSieve:
 ARGUMENTS @pAnyBits @nAnyBits @PrimesCount
 USES EBX ESI; EDI

    cmp D$SieveBase0 0 | je E0>
    updateBitSize D@pAnyBits D@nAnyBits
    cmp D@nAnyBits 32 | ja L3>
    mov eax D@pAnyBits, eax D$eax
    call 'NUMERIKO.IsDwordPrimeNumeriko32' eax | cmp eax 1 | mov ebx ecx | je L2> | jmp L1>
L3:
    mov ebx 1
    mov esi D@PrimesCount
L0: sub esi 1 | jl L2>
    call 'NUMERIKO.GetNextPrimeFromSieve' D$SieveBase0 ebx | test eax eax | je E0>
    mov ebx eax
    call 'AnyBits.AnyBitsMod32Bit' D@pAnyBits D@nAnyBits ebx | test eax eax | je E0>
    test edx edx | je L1>
    jmp L0<
E0: or eax 0-1 | sub edx edx | jmp P9> ; error
L1: mov eax 1 | mov edx ebx | jmp P9> ; Divisor in edx
L2: sub eax eax | sub edx edx ; no 0 mod

EndP
;
;
;
[szB32P: 0, mB32P: 0][B32Psize 203280220][B32primes: B$ 'BIT32PRIMES_01',0]
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
E2: call VFree D@mB32P | and D@mB32P 0 | and D@szB32P 0 | jmp L9>
L0: call 'NUMERIKO.FindNextPrimeQword' 0-5 0 | sub eax 0-5 | sbb edx 0 | shr eax 1
    mov edx D@mB32P | add edx D@szB32P | mov B$edx al
L9: mov eax D@mB32P, edx D@szB32P

EndP
;
;
Proc TestNumberOn32BitPrimes:
 cLocal @inMemSz @inMem @myNum
 USES EBX

    call Input32BitNumber | mov ebx eax | test eax eax | je P9>>
    call ChooseAndLoadFileA | test eax eax | je P9>>

    ALIGN_ON 4 edx
    mov D@inMem eax, D@inMemSz edx
DBGBP
;    shl edx 3
;    call 'AnyBits.GetHighestBitPosition' D@inMem edx
    mov D$JobReporterAddr ReportNumberOnPrimesProgress | and D$NextPrimeForMod 0 | and D$NextPrimeForMod+4 0
    cmp D$szB32P B32Psize | je L0>
    call TryLoadB32primesFile | test eax eax | je L1>
    mov D$mB32P eax, D$szB32P edx
L0:
    call NumberModOnAll32BitPrimesNumeriko D@inMem D@inMemSz, D$mB32P D$szB32P, ebx
    mov ebx eax | jmp L2>
L1:
    call NumberModOnAll32BitPrimes  D@inMem D@inMemSz ebx | mov ebx eax
L2:
    cmp ebx 1 ; | mov edi 0
    jne L0>
    call 'User32.MessageBoxA' D$WindowHandle "Has No 32Bit Divisor" "Pass!" &MB_ICONINFORMATION | jmp @BM

L0: cmp ebx 0 ; | mov edi 0
    je L0>
    call Dword2Decimal inputNumText ebx | add eax inputNumText | mov B$eax 0
    call 'User32.MessageBoxA' D$WindowHandle inputNumText "Found 32Bit Divisor!" &MB_ICONINFORMATION | jmp @BM
L0: call 'User32.MessageBoxA' D$WindowHandle "Parameters Error" "Error!" &MB_ICONINFORMATION | jmp @BM

;    call ChooseAndSaveFileA D@inMem D@inMemSz
@BM:
    call VFree D@inMem
EndP
;

Proc PrimesOutFromAnyBits:
 cLocal @inMemSz @inMem
 USES EBX ESI EDI

    call ChooseAndLoadFileA | test eax eax | je P9>>
    ALIGN_ON 4 edx
    mov D@inMem eax, D@inMemSz edx
    call InitLogFile
DBGBP
    mov D$JobReporterAddr ReportNumberOnPrimesProgress | and D$NextPrimeForMod 0 | and D$NextPrimeForMod+4 0
    mov edx D@inMemSz | shl edx 3
    call Primes32OutFromBits D@inMem edx | mov ebx eax
    call Dword2Decimal pReportBuffer ebx | add eax pReportBuffer
    mov W$eax CRLF, D$eax+2 'Try ', D$eax+6 'next', D$eax+10 ' GB?', B$eax+14 0
    call 'User32.MessageBoxA' D$WindowHandle pReportBuffer "Found 32Bit Divisors:" &MB_ICONINFORMATION__&MB_OKCANCEL
    cmp eax &IDCANCEL | je L2>
    sub edi edi
L1: INC EDI
    mov edx D@inMemSz | shl edx 3
    call Primes64SievedOutFromBits EDI D@inMem edx | mov esi eax
    call Dword2Decimal pReportBuffer esi | add eax pReportBuffer
    mov W$eax CRLF, D$eax+2 'Try ', D$eax+6 'next', D$eax+10 ' GB?', B$eax+14 0
    call 'User32.MessageBoxA' D$WindowHandle pReportBuffer "Found 64Bit Divisors:" &MB_ICONINFORMATION__&MB_OKCANCEL
    add ebx esi
    cmp eax &IDCANCEL | jne L1<
L2: and D$JobReporterAddr 0
    test ebx ebx | je @BM
    updateByteSize D@inMem D@inMemSz
    call ChooseAndSaveFileA D@inMem D@inMemSz
@BM:
    call CloseLogFile
    call VFree D@inMem
EndP
;
;
;
Proc Primes64OutFromAnyBits:
 cLocal @inMemSz @inMem
 USES EBX ESI EDI

    call Input64BitNumber | mov esi eax, edi edx | or eax edx | je P9>>
    call ChooseAndLoadFileA | test eax eax | je P9>>
    ALIGN_ON 4 edx
    mov D@inMem eax, D@inMemSz edx
    call InitLogFile
DBGBP
    mov D$JobReporterAddr ReportNumberOnPrimesProgress | and D$NextPrimeForMod 0 | and D$NextPrimeForMod+4 0
L1:
    mov edx D@inMemSz | shl edx 3
    call Primes64NumerikoOutFromBits ESI EDI D@inMem edx | test eax eax | je @BM
    mov esi eax, edi edx, ebx ecx
    call Dword2Decimal pReportBuffer ebx | add eax pReportBuffer
    mov W$eax CRLF, D$eax+2 'Cont', D$eax+6 'inue', D$eax+10 '?'
    call 'User32.MessageBoxA' D$WindowHandle pReportBuffer "Found 64Bit Divisors:" &MB_ICONINFORMATION__&MB_OKCANCEL
    cmp eax &IDCANCEL | jne L1<
L2: and D$JobReporterAddr 0
    test ebx ebx | je @BM
    updateByteSize D@inMem D@inMemSz
    call ChooseAndSaveFileA D@inMem D@inMemSz
@BM:
    call CloseLogFile
    call VFree D@inMem
EndP
;

Proc CreateSieveFor64bit4GbRange:
 ARGUMENTS @Bit64HighDword
 Local  @pArrayBits
 USES EBX ESI EDI
DBGBP
    cmp D$mB32P 0 | jne L0>
    call TryLoadB32primesFile | test eax eax | je P9>
    mov D$mB32P eax, D$szB32P edx
L0:
    call VAlloc 010000000 | test eax eax | je P9>
    mov D@pArrayBits eax
    call 'NUMERIKO.Bit32PrimesSieve64Bit4GbRange' D$mB32P D@pArrayBits D@Bit64HighDword
    mov edx eax, eax D@pArrayBits
EndP


;
Proc ReportNumberOnPrimesProgress:
 USES ESI EDI
 DBGBP
    CLD
    mov edi pReportBuffer
    call QwordPtr2Decimal edi NextPrimeForMod | add edi eax
    mov B$edi 0
    call 'User32.SendMessageA', D$WindowHandle, &WM_SETTEXT, 0, pReportBuffer

EndP
;
;
Proc MakeNumCopy:
 ARGUMENTS @pBits @nBytes
 USES ebx
    call VAlloc D@nBytes | mov ebx eax | test eax eax | je P9>
    call 'BaseRTL.CopyMemory' ebx D@pBits D@nBytes
    mov eax ebx | mov edx D@nBytes
EndP
;
;
Proc CountBits:
 ARGUMENTS @pBits @nBytes
 USES ebx
    mov ebx D@nBytes | shl ebx 3
    mov edx D@pBits
    sub eax eax | sub ecx ecx
L0:
    BT D$edx ecx | adc eax 0 | inc ecx | cmp ebx ecx | ja L0<
EndP




[myNumb32 (3*5*7*11*13*17*19*23*29) ]

; returns EAX:pPoweredNumber EDX:NumberByteSize ECX:PowerCount
; 0 on Error
Proc PowerUpNumber:
  ARGUMENTS @Number @NumberBitSz @HighBit
  cLocal @myNumSz @myNum @Power
  USES EBX ESI EDI

    test D@NumberBitSz 00_11111 | jne @BM | cmp D@NumberBitSz 0 | je @BM
    lea eax D@Number
    call 'AnyBits.GetHighestBitPosition' eax D@NumberBitSz | mov edi eax

    lea ecx D$eax+1 | mov eax D@HighBit | sub edx edx | DIV ecx | mov D@Power eax

    lea eax D@Number
    call 'AnyBits.AnyBitsPower' eax D@NumberBitSz D@Power | test eax eax | je @BM
    shr edx 3 | mov D@myNum eax, D@myNumSz edx
L0:
    mov eax D@myNumSz, edx D@myNum | shl eax 3
    call 'AnyBits.GetEffectiveHighBitSz32' | shr eax 3 | mov D@myNumSz eax
    shl eax 3
    call 'AnyBits.GetHighestBitPosition' D@myNum eax
    mov edx D@HighBit | sub edx eax | cmp edx edi | jle L0>

    mov ebx D@myNumSz | mov eax D@NumberBitSz | shr eax 3 | add ebx eax
    call VAlloc ebx | mov esi eax | test eax eax | je @BM
    mov eax D@myNumSz, edx ebx
    shl eax 3 | shl edx 3 | lea ecx D@Number
    call 'AnyBits.AnyBitsMultiplication' esi edx D@myNum eax ecx D@NumberBitSz | test eax eax | je @BM
    call VFree D@myNum | mov D@myNum esi, D@myNumSz ebx | inc D@Power
    jmp L0<<
L0:
    mov eax D@myNum, edx D@myNumSz, ecx D@Power | jmp P9>
@BM:
    call VFree D@myNum | sub eax eax
EndP
;
;
;

____________________________________________________________________________________________


TITLE FermatLittleTheorem

____________________________________________________________________________________________



Proc Any2NpowBitsVirtualMod32Bit::
 ARGUMENTS @nBits @Bit32
 USES EBX

    sub eax eax
    mov ecx D@Bit32 | test ecx ecx | je P9>
    mov ebx D@nBits | mov edx ebx
    and edx 01F | shr ebx 5
    BTS eax edx
    sub edx edx
    DIV ecx
    test ebx ebx | je L0>
L1:
    sub eax eax
    DIV ecx
    dec ebx | jne L1<

L0: mov eax 1; EDX=Mod32
EndP

Proc Any2FermatBitsVirtualMod32Bit::
 ARGUMENTS @nBits @Bit32
 USES EBX

    sub eax eax
    mov ecx D@Bit32 | test ecx ecx | je P9>
    mov ebx D@nBits | mov edx ebx
    and edx 01F
    BTS eax edx
    sub edx edx | shr ebx 5 | je L3>
    DIV ecx
L1:
    sub ebx 1 | je L2>
    sub eax eax
    DIV ecx
    jmp L1<
L2:
    mov eax 1
    DIV ecx | jmp L0>
L3:
    add eax 1
    DIV ecx

L0: mov eax 1; EDX=Mod32
EndP

Proc Any2Npow1BitsVirtualMod32Bit::
 ARGUMENTS @nBits @Bit32
 USES EBX

    sub eax eax
    mov ecx D@Bit32 | test ecx ecx | je P9>
    mov ebx D@nBits | mov edx ebx
    and edx 01F | shr ebx 5
    BTS eax edx
    sub edx edx
    sub eax 1 | jne L0>
    dec eax | dec ebx
L0: DIV ecx
    test ebx ebx | jle L0>
L1:
    mov eax 0-1
    DIV ecx
    dec ebx | jne L1<
L0:
    mov eax 1; EDX=Mod32
EndP


Proc MersenneTF32:
 Arguments @NMod32 @Mnum
 USES ESI EDI

    mov esi D@NMod32
    BSR ecx D@Mnum
    mov eax 1
L1: sub edi edi
; square
    MUL eax
    BT D@Mnum ecx | jnc L0>
; *2
    shl edx 1 | adc edi 0 ; 65th bit
    shl eax 1 | adc edx 0
    cmp edi 0 | je L0>
    mov edi eax | mov eax edx | mov edx 1
    DIV esi | mov eax edi
L0:
    cmp edx esi | jae L2>
L3: DIV esi | mov eax edx
    sub ecx 1 | jae L1<
    jmp P9>
L2: ; double DIV
    mov edi eax | mov eax edx | sub edx edx
    DIV esi | mov eax edi | jmp L3<

E0: mov eax 0-1
EndP
;

;;
;2^(p-1) (mod p) = 1
Proc FermatLT2B:
 ARGUMENTS @PNum
 cLocal @inMem2P @inSz2P @inMemP @inSzP @NumBase2
 USES EBX
DBGBP

;call SetStartTick
    mov D@NumBase2 2, edx D@PNum
    dec edx

    lea eax D@NumBase2
    call 'AnyBits.AnyBitsPower' eax 32 edx | test eax eax | je @BM
    mov D@inMem2P eax, D@inSz2P edx
;
;    mov ecx D@PNum | dec ecx | BT D$eax ecx
;    edx D@PNum inc edx  | ALIGN_ON 32 edx | mov D@inSz2P edx
;    shr edx 3
;    call VAlloc edx | test eax eax | je @BM
;

    lea eax D@PNum
    call 'AnyBits.AnyBitsModulus' eax 32 D@inMem2P D@inSz2P | test eax eax | je @BM
;call SetEndTickReport
; EDX reminder
    cmp edx 0 | jne L0>
    call 'User32.MessageBoxA' D$WindowHandle "0" "NULL REMINDER!" &MB_ICONWARNING | jmp @BM
L0:
    updateBitSize D@inMem2P D@inSz2P
    cmp D@inSz2P 32 | je L0>
L1:
    call 'User32.MessageBoxA' D$WindowHandle "--" "REMINDER > 1" &MB_ICONWARNING | jmp @BM
L0:
    mov eax D@inMem2P | cmp D$eax 1 | jne L1<
    call 'User32.MessageBoxA' D$WindowHandle "1!" "REMINDER = 1!" &MB_ICONINFORMATION
@BM:
    call VFree D@inMem2P | call VFree D@inMemP

EndP
;;

;;
;2^(p-1) (mod p) = 1
Proc FermatLT2Brpt:
 ARGUMENTS @PNum
 USES EBX
DBGBP

    mov ebx 0-1
;call SetStartTick
    mov eax D@PNum
    lea ecx D$eax-1
    call MersenneTF ecx eax | cmp eax 1 | jne @BM
; EDX reminder
    mov ebx eax
@BM:
    mov eax ebx
EndP
;;

;
;2^(p-1) (mod p) = 1
Proc FermatLT2Brpt:
 ARGUMENTS @PNum
 USES EBX
;DBGBP

    mov ebx 0-1
;call SetStartTick
    mov eax D@PNum
    lea ecx D$eax-1
    call Any2NpowBitsVirtualMod32Bit ecx eax | test eax eax | je @BM

; EDX reminder
    mov ebx edx
@BM:
    mov eax ebx
EndP
;

;;
;2^(p-1) (mod p) = 1
Proc FermatLT2Brpt:
 ARGUMENTS @PNum
 cLocal @inMem2P @inSz2P @NumBase2
 USES EBX
DBGBP

mov ebx 0-1
;call SetStartTick

    mov edx D@PNum | inc edx  | ALIGN_ON 32 edx | mov D@inSz2P edx
    shr edx 3
    call VAlloc edx | test eax eax | je @BM
    mov D@inMem2P eax
    mov ecx D@PNum | dec ecx | BTS D$eax ecx

    call 'AnyBits.AnyBitsMod32Bit' D@inMem2P D@inSz2P D@PNum | test eax eax | je @BM
; EDX reminder
    mov ebx edx | jmp @BM

@BM:
    call VFree D@inMem2P
    mov eax ebx
EndP
;;

;;
;2^(2^(p-1)) (mod (2^p-1)) = 1?
Proc FermatLT2PB:
 ARGUMENTS @PNum
 cLocal @inMem2P @inSz2P @inMemP @inSzP  @inMemPP @inSzPP @NumBase2
 USES EBX ESI EDI
DBGBP

call SetStartTick
    mov D@NumBase2 2, edx D@PNum
    dec edx
    lea eax D@NumBase2
    call 'AnyBits.AnyBitsPower' eax 32 edx | test eax eax | je @BM
    mov D@inMemPP eax, D@inSzPP edx

;    call 'AnyBits.AnyBitsShiftRight' D@inMemPP D@inSzPP 3 | test eax eax | je @BM
    cmp D@inSzPP 32 | ja @BM
    mov eax D@inMemPP, eax D$eax
    add eax 32 | mov D@inSz2P eax
    shr eax 3
    call VAlloc eax | test eax eax | je @BM
    mov D@inMem2P eax

;    call 'AnyBits.AnyBitsShiftLeft' D@inMemPP D@inSzPP 3 | test eax eax | je @BM

    mov ecx D@inMemPP, ecx D$ecx, eax D@inMem2P | BTS D$eax ecx


    mov eax D@PNum | ALIGN_ON 32 eax | mov D@inSzP eax | shr eax 3
    call VAlloc eax | test eax eax | je @BM
    mov D@inMemP eax
    mov ecx D@PNum | BTS D$eax ecx
    call 'AnyBits.AnyBitsSubstractSelf32Bit' D@inMemP D@inSzP 1 | test eax eax | je @BM

    call 'AnyBits.AnyBitsModulus' D@inMemP D@inSzP D@inMem2P D@inSz2P | test eax eax | je @BM
call SetEndTickReport
; EDX reminder
    cmp edx 0 | jne L0>
    call 'User32.MessageBoxA' D$WindowHandle "0" "NULL REMINDER!" &MB_ICONWARNING | jmp @BM
L0:
    updateBitSize D@inMem2P D@inSz2P
    cmp D@inSz2P 32 | je L0>
L1:
    call 'User32.MessageBoxA' D$WindowHandle "--" "REMINDER > 1" &MB_ICONWARNING | jmp @BM
L0:
    mov eax D@inMem2P | cmp D$eax 1 | jne L1<
    call 'User32.MessageBoxA' D$WindowHandle "1!" "REMINDER = 1!" &MB_ICONINFORMATION
@BM:
    call VFree D@inMemPP | call VFree D@inMem2P | call VFree D@inMemP

EndP
;;
;;
;2^(2^(p-1)) (mod (2^p-1)) = 1?
Proc FermatLT2MP:
 ARGUMENTS @PNum
 cLocal @inSzP @inMemP @NumBase2
 USES EBX
DBGBP

call SetStartTick
    MOV ebx 0-1

    mov edx D@PNum | inc edx  | ALIGN_ON 32 edx | mov D@inSzP edx
    shr edx 3
    call VAlloc edx | test eax eax | je @BM
    mov D@inMemP eax
    mov ecx D@PNum ;| dec ecx |
    BTS D$eax ecx
;    mov D@NumBase2 2
;    lea eax D@NumBase2
;    call 'AnyBits.AnyBitsPower' eax 32 D@PNum | test eax eax | je @BM
;    mov D@inMemP eax, D@inSzP edx
    call 'AnyBits.AnyBitsSubstractSelf32Bit' D@inMemP D@inSzP 2 | test eax eax | je @BM
    call 'AnyBits.AnyBitsMod32Bit' D@inMemP D@inSzP D@PNum | test eax eax | je @BM
; EDX reminder
    mov ebx edx
call SetEndTick
    updateBitSize D@inMemP D@inSzP
@BM:
    call VFree D@inMemP
    mov eax ebx
EndP
;;

Proc doFermatLT2p1Rpt:
 cLocal @inMem2P @inSz2P @inSz2Pb
 USES EBX ESI EDI
DBGBP

    cmp D$szB32P B32Psize | je L0>
    call TryLoadB32primesFile | test eax eax | je P9>>
    mov D$mB32P eax, D$szB32P edx
L0:
    mov esi 01965F01 ;2
    call dumpStartTime
    call 'NUMERIKO.FindNearPrime32FromBit32DiffArray' D$mB32P D$szB32P 1 ESI
    test eax eax | je @BM | mov esi eax, edi ecx
jmp L0>
L1:
    call 'NUMERIKO.GetNextPrime32FromDiffArrayPosition' D$mB32P D$szB32P EDI ESI
    cmp eax 0 | je @BM | mov esi eax, edi ecx
L0:
;DBGBP

;;
    mov edx esi | inc edx  | ALIGN_ON 32 edx | mov D@inSz2P edx
    shr edx 3 | ALIGN_ON 01000 edx | cmp D@inSz2Pb edx | jae L3>
    mov D@inSz2Pb edx
    call VFree D@inMem2P
    call VAlloc D@inSz2Pb | test eax eax | je @BM
    mov D@inMem2P eax
L3:
    mov eax D@inMem2P
    mov ecx esi | dec ecx | BTS D$eax ecx
;;
    lea ecx D$esi-1
    call Any2NpowBitsVirtualMod32Bit ecx esi | test eax eax | je @BM
    ;'AnyBits.AnyBitsMod32Bit' D@inMem2P D@inSz2P esi | test eax eax | je @BM
; EDX reminder
;    mov eax D@inMem2P
;    mov ecx esi | dec ecx | BTR D$eax ecx
    cmp edx 1 | je L1<

    push 0, esi | mov ecx esp
    call dumpPrimes ecx eax
    add esp 8
    jmp L1<
@BM:
    call VFree D@inMem2P
    mov eax ebx
    push eax
    call CloseLogFile
    pop eax

EndP
;;
    mov esi 2
L1:
    call 'NUMERIKO.FindNextPrimeDword' esi | test eax eax | je L2>
    mov esi eax
    call dumpStartTime
L0:
;DBGBP
    call FermatLT2Brpt esi | cmp eax 1 | je L1<
    push 0, esi | mov ecx esp
    call dumpPrimes ecx eax
    add esp 8
    jmp L1<
L2:
    push eax
    call CloseLogFile
    pop eax
;;

Proc doFermatNum2Rpt:
 USES EBX ESI EDI
;DBGBP

    call TryLoad4GBrangeSieveFile 0 | mov D$SieveBase0 eax | test eax eax | je P9>>
    call Input32BitNumber | cmp eax 0 | je @BM | mov esi eax
    call dumpStartTime
;    sub esi 1
DBGBP
L0:
;cmp D$JobAskToEnd &TRUE | je L2>
call SetStartTick
;    add esi 1 | jc L2>>
    mov ebx 1
    sub edi edi | BTS edi esi
    cmp esi 4 | ja L1>
    sub eax eax | BTS eax edi | add eax 1 | mov edi eax
L4: add ebx 2 | cmp edi ebx | jbe L2>
    mov eax edi | sub edx edx | DIV ebx | test edx edx | je L3>
    cmp eax ebx | jbe L2> | jmp L4<
L1:
cmp D$JobAskToEnd &TRUE | je L2>
    call 'NUMERIKO.GetNextPrimeFromSieve' D$SieveBase0 EBX | mov ebx eax | cmp eax 0 | je L3>
    call Any2FermatBitsVirtualMod32Bit edi ebx | cmp eax 1 | jne L2>
    test edx edx | jne L1<
L3:
call SetEndTick
    call dumpNumNmods ebx esi
    jmp @BM ;L0<
L2:
call SetEndTick
    call dumpNumNmods 1 esi
@BM: call CloseLogFile
     call VFree D$SieveBase0 | and D$SieveBase0 0
EndP
;************************

Proc doFermatLT2Rpt:
 USES EBX ESI EDI
DBGBP

    call TryLoad4GBrangeSieveFile 0 | mov D$SieveBase0 eax | test eax eax | je P9>>
    call Input32BitNumber | cmp eax 0 | je @BM | mov esi eax
    call dumpStartTime
L0:
;DBGBP
cmp D$JobAskToEnd &TRUE | je L2>
call SetStartTick
    add esi 2 | jc L2>
    call 'NUMERIKO.IsNumberPrimeInSieve' D$SieveBase0 esi | cmp eax 1 | je L0<
    ;mov ebx 0;ecx
    call FermatLT2Brpt esi | cmp eax 1 | jne L0<
    call SetEndTick
    call 'NUMERIKO.IsDwordPrimeNumeriko32' esi
    call dumpNumNmods ecx esi
    jmp L0<
L2:
call SetEndTick
    call dumpNumNmods 1 esi
    call CloseLogFile
@BM: call VFree D$SieveBase0 | and D$SieveBase0 0
EndP
;
;
;
Proc doFermatLT2Rpt64Bits:
; clocal @inMem2P
 USES EBX ESI EDI
;DBGBP

    cmp D$szB32P B32Psize | je L0>
    call TryLoadB32primesFile | test eax eax | je P9>>
    mov D$mB32P eax, D$szB32P edx
L0:
;    call TryLoad4GBrangeSieveFile 0 | mov D$SieveBase0 eax | test eax eax | je P9>>
    call Input64BitNumber | mov ecx edx | or ecx eax | je @BM | mov esi eax, edi edx
    call dumpStartTime
    or esi 1
    sub esi 2 | sbb edi 0 ; | jc L2>
;    call VAlloc 02000 | test eax eax | je @BM
;    mov D@inMem2P eax
DBGBP
L0:
cmp D$JobAskToEnd &TRUE | je L2>
call SetStartTick
    add esi 2 | adc edi 0 | jc L2>
    call 'NUMERIKO.IsQwordPrimeNumeriko64' D$mB32P esi edi | cmp eax 1 | je L0<
    mov ebx ecx

    test edi edi | jne L1>
    call FermatLT2Brpt esi | cmp eax 1 | jne L2> | jmp L3>
L1: call FermatLT2Brpt64 esi edi | cmp eax 1 | jne L2> | cmp edx 0 | jne L2>
L3:
    call SetEndTick
    call dumpNum64Nmods ebx esi edi
    jmp L0<
L2:
call SetEndTick
    call reportCurrentNumNmods64 1 esi edi
    cmp D$JobAskToEnd &TRUE | jne L0<
    call dumpNum64Nmods 1 esi edi
    call dumpEndTime
    call CloseLogFile
@BM: ;call VFree D@inMem2P | call VFree D$SieveBase0 | and D$SieveBase0 0
EndP

;2^(p-1) (mod p) = 1
; P>64
Proc FermatLT2Brpt64:
 ARGUMENTS @NumLo @NumHi
 USES EBX ESI EDI
;DBGBP

    mov ecx 32
    mov esi D@NumLo, edi D@NumHi
    sub esi 1 | sbb edi 0
    mov eax edi | sub edx edx | DIV ecx | mov edi eax
    mov eax esi | DIV ecx | mov esi eax
    sub ebx ebx | BTS ebx edx

    push 0, ebx, 0
    sub esi 1 | sbb edi 0 | jc L2>
L0: sub esi 1 | sbb edi 0 | jc L2>
    mov edx esp
    move D$edx+8 D$edx+4,  D$edx+4 D$edx+0 | and D$edx 0
    cmp D$edx+8 0 | jne L1>
    cmp esi 0 | jne L0< ;| cmp edi 0 | jne L0<
L1: lea eax D@NumLo
    call 'AnyBits.AnyBitsModulus' eax 64 edx 96
    jmp L0<
L2: pop eax, edx, ecx

EndP
;


;;
Proc doFermatLT2MP:
 USES EBX ESI EDI
DBGBP

    mov esi 1
    call dumpStartTime
L0:
;DBGBP
    add esi 2 | jc L2>
    call FermatLT2MP esi | cmp eax 0-1 | je L2> | cmp eax 0 | jne L0<
    call dumpNumNmods eax esi
    jmp L0<
L2:
    call CloseLogFile

EndP
;;


;;
Proc do2P1ModAll32BitPrimes:
; cLocal @inMem2P @inSz2P @inSz2Pb
 USES EBX ESI EDI
DBGBP
    cmp D$szB32P B32Psize | je L0>
    call TryLoadB32primesFile | test eax eax | je P9>>
    mov D$mB32P eax, D$szB32P edx
L0:
    call dumpStartTime
    mov ebx 2
L2:
call SetStartTick
    call 'NUMERIKO.FindNearPrime32FromBit32DiffArray' D$mB32P D$szB32P 1 EBX
    test eax eax | je @BM
    mov ebx eax

    mov esi ebx
L0:
call SetStartTick
;    call 'NUMERIKO.FindNearPrime32FromBit32DiffArray' D$mB32P D$szB32P 1 ESI
;    test eax eax | je @BM | mov esi eax, edi ecx
jmp L0>
L1:
    call 'NUMERIKO.GetNextPrime32FromDiffArrayPosition' D$mB32P D$szB32P EDI ESI
    cmp eax 0 | je L3> | mov esi eax, edi ecx
L0:
;DBGBP
    call Any2Npow1BitsVirtualMod32Bit ebx esi | test eax eax | je @BM
    cmp edx 0 | jne L1<
call SetEndTick
    call dumpNumNmods esi ebx
    jmp L2<<
L3:
call SetEndTick
    call dumpNumNmods 0 ebx
    jmp L2<<

@BM:
    call dumpStartTime
    call CloseLogFile
    pop eax

EndP
;;


TITLE MersennneFT

;
Proc do2P1MTF32BitPrimes:
; cLocal @inMem2P @inSz2P @inSz2Pb
 USES EBX ESI EDI

    call TryLoad4GBrangeSieveFile 0 | mov D$SieveBase0 eax | test eax eax | je P9>>
L0:
    call Input32BitNumber | cmp eax 0 | je @BM | mov ebx eax
    call dumpStartTime
DBGBP

L2:
cmp D$JobAskToEnd &TRUE | je @BM
    call 'NUMERIKO.GetNextPrimeFromSieve' D$SieveBase0 EBX
    test eax eax | je @BM
    mov ebx eax
    mov esi 0
    mov edi ebx | shr edi 1 | add edi 1
call SetStartTick
;jmp L0>
L1:
    and esi 0-2
    add esi ebx | jc L3> | add esi ebx | jc L3>
    BSR eax esi | cmp eax edi | jae L3>
    or esi 1
    mov eax esi | and eax 7 | cmp eax 3 | je L1< | cmp eax 5 | je L1<
L4: call 'NUMERIKO.IsNumberPrimeInSieve' D$SieveBase0 esi | test eax eax | je L1<
L0:
    call MersenneTF32 esi ebx | cmp eax 0-1 | je @BM
    cmp eax 1 | jne L1<

call SetEndTick
    call dumpNumNmods esi ebx
    jmp L2<<
L3:
call SetEndTick
    call dumpNumNmods 0 ebx
    jmp L2<<

@BM:
    call dumpEndTime
    call CloseLogFile
    call VFree D$SieveBase0 | and D$SieveBase0 0
EndP
;
[<16 p2k1: D$ ? #020 p2k1a: ? #020 p2k1b: ? #16 p2k1sq1: ? #4 p2k1sq2: ? #4
 p2k: ? #04 ]
;
Proc do2P1MTF64BitPrimes:
; cLocal @Mnum
 USES EBX ESI EDI


    cmp D$szB32P B32Psize | je L0>
    call TryLoadB32primesFile | test eax eax | je P9>>
    mov D$mB32P eax, D$szB32P edx
L0:
;    call TryLoad4GBrangeSieveFile 0 | mov D$SieveBase0 eax | test eax eax | je P9>>
    call Input32BitNumber | cmp eax 0 | je @BM | or eax 1 | mov ebx eax; D@Mnum eax,
    call dumpStartTime
DBGBP

L2:
cmp D$JobAskToEnd &TRUE | je @BM
    call 'NUMERIKO.FindNextPrimeDwordNumeriko32' ebx | test eax eax | je @BM
    mov ebx eax ; D@Mnum eax,
    CLD
    mov edi p2k1, ecx 4, eax 0 | REP STOSD
;    mov edi p2k1a, ecx 4, eax 0 | REP STOSD
L4:
;    mov edi p2k1sq1, ecx 4, eax 0 | REP STOSD
;    mov edi p2k1sq2, ecx 4, eax 0 | REP STOSD
    mov esi p2k1, edi ebx | shr edi 1 | add edi 1
call SetStartTick
;jmp L0>
L1:
    and D$esi 0-2
    mov eax ebx | add eax ebx | jc @BM
L0: call 'AnyBits.AnyBitsAdditionSelf32Bit' esi 64 eax | jc L3>>
    call 'AnyBits.GetHighestBitPosition' esi 64 | cmp edi eax | jbe L2<
    or D$esi 1
    mov eax D$esi | and eax 7 | cmp eax 3 | je L1< | cmp eax 5 | je L1<

    call 'NUMERIKO.IsQwordPrimeNumeriko64' D$mB32P D$esi D$esi+4 | cmp eax 0 | je L1<
L0:
    call MersenneTFAnyBitsA p2k1sq2 p2k1sq1 128 esi 64 ebx | cmp eax 0 | je @BM
    mov edi eax
    call 'AnyBits.GetHighestBitPosition' edi edx | cmp edx 0-1 | je @BM
    cmp eax 0 | jne L4<<

call SetEndTick
    call dumpNumNmods64 D$esi D$esi+4 ebx
    jmp L2<<
L3:
call SetEndTick
    call dumpNumNmods64 D$esi D$esi+4 ebx
    jmp L2<<

@BM:
    call dumpEndTime
    call CloseLogFile
    call VFree D$SieveBase0 | and D$SieveBase0 0
EndP
;
;
Proc MersenneTFAnyBits:
 Arguments @pNMod @szNMod @Mnum
 cLocal @sq1sz @sq1 @sq2sz @sq2 @sqsz
 USES EBX ESI EDI

    BSR ebx D@Mnum | je E0>>

    call 'AnyBits.GetHighestBitPosition' D@pNMod D@szNMod | cmp edx 0-1 | je E0>>
    ALIGN_UP 32 eax | mov edi eax | shl edi 1 | mov D@sqsz edi | shr edi 3
    call VAlloc edi | mov D@sq1 eax | test eax eax | je E0>>
    call VAlloc edi | mov D@sq2 eax | test eax eax | je E0>>
    mov D@sq1sz 32
    mov esi D@sq1 | mov edi D@sq2
    mov D$esi 1
L1:
; square
    mov eax D@sq1sz | shl eax 1 | mov D@sq2sz eax
    call 'AnyBits.AnyBitsSquare' edi D@sq2sz, esi D@sq1sz | test eax eax | je E0>
    updateBitSize edi D@sq2sz
    xchg esi edi | Exchange D@sq1sz D@sq2sz
    BT D@Mnum ebx | jnc L0>
; x2
    call 'AnyBits.AnyBitsShift1Left' esi D@sq1sz | jnc L0>
    mov eax D@sq1sz | shr eax 3 | mov D$esi+eax 1 | add D@sq1sz 32 ; enlarge
L0:
    call 'AnyBits.AnyBitsModulus' D@pNMod D@szNMod esi D@sq1sz | test eax eax | je E0>
    updateBitSize esi D@sq1sz
    sub ebx 1 | jae L1<
;    mov eax esi, edx D@sq1sz
    jmp L2>
E0: sub esi esi | and D@sq1sz 0
    call VFree esi
L2: call VFree edi
    mov eax esi, edx D@sq1sz, ecx D@sqsz
EndP

Proc MersenneTFAnyBitsA:
 Arguments @sq2 @sq1 @sqsz @pNMod @szNMod @Mnum
 cLocal @sq1sz @sq2sz
 USES EBX ESI EDI

    BSR ebx D@Mnum | je E0>>

    call 'AnyBits.GetHighestBitPosition' D@pNMod D@szNMod | cmp edx 0-1 | je E0>>
    ALIGN_UP 32 eax | shl eax 1 | cmp eax D@sqsz | ja E0>>

    mov D@sq1sz 32
    mov esi D@sq1 | mov edi D@sq2
    mov D$esi 1
L1:
; square
    mov eax D@sq1sz | shl eax 1 | mov D@sq2sz eax
    call 'AnyBits.AnyBitsSquare' edi D@sq2sz, esi D@sq1sz | test eax eax | je E0>
    updateBitSize edi D@sq2sz
    xchg esi edi | Exchange D@sq1sz D@sq2sz
    BT D@Mnum ebx | jnc L0>
; x2
    call 'AnyBits.AnyBitsShift1Left' esi D@sq1sz | jnc L0>
    mov eax D@sq1sz | shr eax 3 | mov D$esi+eax 1 | add D@sq1sz 32 ; enlarge
L0:
    call 'AnyBits.AnyBitsModulus' D@pNMod D@szNMod esi D@sq1sz | test eax eax | je E0>
    updateBitSize esi D@sq1sz
    sub ebx 1 | jae L1<
;    mov eax esi, edx D@sq1sz
    jmp L2>
E0: sub esi esi | and D@sq1sz 0
L2:
    mov eax esi, edx D@sq1sz, ecx D@sqsz
EndP

;
;;
Square        topM_bit mul by 2       mod 47
------------  -------  -------------  ------
1*1 = 1       1  0111  1*2 = 2           2
2*2 = 4       0   111     no             4
4*4 = 16      1    11  16*2 = 32        32
32*32 = 1024  1     1  1024*2 = 2048    27
27*27 = 729   1        729*2 = 1458      1
;;











____________________________________________________________________________________________

;;
Proc do2P1MTFAnyBitFactorFunny0:
 cLocal @m2PSz @m2P @Mexponent @Mexp2kp @p2kSz @p2kSzT
 USES EBX ESI EDI


;    cmp D$szB32P B32Psize | je L0>
;    call TryLoadB32primesFile | test eax eax | je P9>>
;    mov D$mB32P eax, D$szB32P edx
;L0:
    call TryLoad4GBrangeSieveFile 0 | mov D$SieveBase0 eax | test eax eax | je P9>>
    call Input32BitNumber | cmp eax 0 | je @BM | or eax 1 | mov D@Mexponent eax
    call dumpStartTime
DBGBP

    mov eax D@Mexponent ;| cmp eax 64 | jb @BM
    Align_UP 32 eax | mov D@m2PSz eax | shr eax 3
    call VAlloc eax | test eax eax | je @BM
    mov D@m2P eax
    mov eax D@Mexponent | shr eax 1 | add eax 1 | mov D@Mexp2kp eax
    Align_UP 32 eax | mov D@p2kSz eax
    mov ebx 8166887

L2:
cmp D$JobAskToEnd &TRUE | je @BM
call SetStartTick
    sub eax eax
    mov edi p2k, ecx D@p2kSz | shr ecx 5 | REP STOSD
    mov esi p2k
;    move D$esi D@Mexponent
    cmp ebx 3 | jae L0> | add ebx 1 | jmp L4>
L0: call 'NUMERIKO.GetNextPrimeFromSieve' D$SieveBase0 ebx | test eax eax | je @BM
    mov ebx eax
L4:
;jmp L0>
    mov eax D@Mexponent | MUL ebx | mov D$esi eax, D$esi+4 edx | mov D@p2kSzT 64
L1:
    call 'AnyBits.AnyBitsShift1Left' esi D@p2kSzT | jnc L0>
    mov eax D@p2kSzT | shr eax 3 | mov D$esi+eax 1 | add D@p2kSzT 32
L0:
    mov ecx D@Mexp2kp | BT D$esi ecx | jc L2<

    mov eax D$esi | or eax 1
    and eax 7 | cmp eax 1 | je L0> | cmp eax 7 | jne L1<
L0: or D$esi 1

    call NumberModOn32BitPrimesFromSieve esi D@p2kSzT 4057 | cmp eax 0 | je L0> ;01AE0
    and D$esi 0-2 | jmp L1<
L0:
    sub eax eax
    mov edi D@m2P, ecx D@m2PSz | shr ecx 5 | CLD | REP STOSD
    mov edi D@m2P, ecx D@Mexponent | BTS D$EDI ECX

    call 'AnyBits.AnyBitsModulus' esi D@p2kSzT D@m2P D@m2PSz | test eax eax | je @BM
    and D$esi 0-2

    call 'AnyBits.GetHighestBitPosition' D@m2P D@m2PSz | cmp eax 0-1 | je @BM
    cmp eax 0 | jne L3>

L0:
call SetEndTick
    call dumpNumNmods64 D$esi D$esi+4 ebx
    jmp @BM;L2<<
L3:
call SetEndTick
    call reportCurrentNumNmods64 ebx D$edi D$edi+4
    cmp D$JobAskToEnd &TRUE | jne L1<<
    call dumpNumNmods64 D$edi D$edi+4 ebx
;    jmp L2<<

@BM:
    call dumpEndTime
    call CloseLogFile
    call VFree D$SieveBase0 | and D$SieveBase0 0
    call VFree D@m2P
EndP
;;
;
____________________________________________________________________________________________

;
;;
Proc do2P1MTFAnyBitFactorFunny:
 cLocal @m2PSz @m2P @Mexponent @Mexp2kp @p2kSz @mp2k @p2kSzT @p2kSzTa @curpkModLo @curpkModHi
 USES EBX ESI EDI

    call TryLoad4GBrangeSieveFile 0 | mov D$SieveBase0 eax | test eax eax | je P9>>
L0:
    call Input32BitNumber | cmp eax 0 | je @BM1 | mov D@Mexponent eax
    call 'NUMERIKO.IsDwordPrimeNumeriko32' D@Mexponent | cmp eax 1 | jne L0<

    call Input64BitNumber | mov D@curpkModLo eax, D@curpkModHi edx
    sub eax eax
    mov edi p2k, ecx 04 ;D@p2kSz shr ecx 5 |
    CLD | REP STOSD
    move D$p2k D@curpkModLo, D$p2k+4 D@curpkModHi ;| and D@curpkModLo 0 | and D@curpkModHi 0
    call dumpStartTime
DBGBP
;    jmp L0>

;L2:
;cmp D$JobAskToEnd &TRUE | je @BM
;
;    sub eax eax
;    mov edi p2k, ecx 0200;D@p2kSz
;    shr ecx 5 | REP STOSD
;    call 'NUMERIKO.GetNextPrimeFromSieve' D$SieveBase0 D@Mexponent | test eax eax | je @BM
;    mov D@Mexponent eax
;L0:
    mov ebx D@Mexponent
    call VFree D@m2P
    mov eax D@Mexponent ;| cmp eax 64 | jb @BM
    Align_UP 32 eax | mov D@m2PSz eax | shr eax 3
    call VAlloc eax | test eax eax | je @BM1
    mov D@m2P eax
    mov eax D@Mexponent | shr eax 1 | add eax 1 | mov D@Mexp2kp eax
    Align_UP 32 eax | mov D@p2kSz eax | shr eax 3
    call VAlloc eax | test eax eax | je @BM1
    mov D@mp2k eax

    add ebx ebx
    mov D@p2kSzT 64, D@p2kSzTa 64
call SetStartTick
L1:
cmp D$JobAskToEnd &TRUE | je @BM
    mov esi p2k
    and D$esi 0-2
    call 'AnyBits.AnyBitsAdditionSelf32Bit' esi D@p2kSzT ebx | jnc L0>
    mov eax D@p2kSzT | shr eax 3 | mov D$esi+eax 1 | add D@p2kSzT 32 ; enlarge
L0:
    mov ecx D@Mexp2kp | shr ecx 3 | cmp ecx 010 | ja L0> | cmp B$esi+ecx+1 0 | jne @BM;L2<<
    mov ecx D@Mexp2kp | BT D$esi ecx | jc @BM;L2<<
L0:
;    or D$esi 1
;    mov eax D$esi ;| or eax 1
;    and eax 7 | cmp eax 1 | je L0> | cmp eax 7 | jne L1<
;L0:
;    call NumberModOn32BitPrimesFromSieve esi D@p2kSzT 4057 | cmp eax 0 | jne L1< ;01AE0
    sub eax eax
    mov edi D@mp2k, ecx D@p2kSz | shr ecx 5 ;
    REP STOSD
    mov eax D@p2kSzT | mov D@p2kSzTa eax | shr eax 3 | call 'BaseRTL.CopyMemory' D@mp2k p2k eax
    mov esi D@mp2k
    jmp L0>

L4:
    and D$esi 0-2
    call 'AnyBits.AnyBitsShift1Left' esi D@p2kSzTa | jnc L0>
    mov eax D@p2kSzTa | shr eax 3 | mov D$esi+eax 1 | add D@p2kSzTa 32 ; enlarge
L0:
    mov ecx D@Mexp2kp | shr ecx 3 | cmp B$esi+ecx+1 0 | jne L1<<
    mov ecx D@Mexp2kp | BT D$esi ecx | jc L1<<
L0:
    or D$esi 1
    mov eax D$esi ;| or eax 1
    and eax 7 | cmp eax 1 | je L0> | cmp eax 7 | jne L4<
L0:
    call NumberModOn32BitPrimesFromSieve esi D@p2kSzTa 4057 | cmp eax 0 | jne L4< ;01AE0
L0:
    sub eax eax
    mov edi D@m2P, ecx D@m2PSz | shr ecx 5 | CLD | REP STOSD
    mov edi D@m2P, ecx D@Mexponent | BTS D$EDI ECX

    call 'AnyBits.AnyBitsModulus' esi D@p2kSzTa D@m2P D@m2PSz | test eax eax | je @BM

    call 'AnyBits.GetHighestBitPosition' D@m2P D@m2PSz | cmp eax 0-1 | je @BM
    cmp eax 0 | jne L3>

call SetEndTick
    call 'AnyBits.GetHighestBitPosition' D@mp2k D@p2kSzTa | cmp eax 0-1 | je L0>
    Align_UP 32 eax
    call dumpNModsAny D@mp2k eax
L0:
    jmp @BM;L2<<
L3:
call SetEndTick
    mov edi p2k
    call reportCurrentNumNmods64 D@Mexponent D$edi D$edi+4
    jmp L4<<

@BM:
    mov edi p2k
    call dumpNumNmods64 D$edi D$edi+4 D@Mexponent
@BM1:
    call dumpEndTime
    call CloseLogFile
    call VFree D$SieveBase0 | and D$SieveBase0 0
    call VFree D@mp2k | call VFree D@m2P
EndP
;;

;
;
Proc do2P1MTFAnyBitMTFactorFunny:
 cLocal @Mexponent @Mexp2kp @p2kSz @mp2k @p2kSzT @p2kSzTa @sqSz @sq1 @sq2 @curpkModHi @curpkModLo
 USES EBX ESI EDI

L0:
    call Input32BitNumber | cmp eax 0 | je P9>> | mov D@Mexponent eax
    call 'NUMERIKO.IsDwordPrimeNumeriko32' D@Mexponent | cmp eax 1 | jne L0<
    call TryLoad4GBrangeSieveFile 0 | mov D$SieveBase0 eax | test eax eax | je P9>>

    call Input64BitNumber | mov D@curpkModLo eax, D@curpkModHi edx
    sub eax eax
    mov edi p2k, ecx 04 ;D@p2kSz shr ecx 5 |
    CLD | REP STOSD
    move D$p2k D@curpkModLo, D$p2k+4 D@curpkModHi
    call dumpStartTime
DBGBP

    mov ebx D@Mexponent
    mov eax D@Mexponent | shr eax 1 | add eax 1 | mov D@Mexp2kp eax
    Align_UP 32 eax | mov D@p2kSz eax | shr eax 3
    call VAlloc eax | test eax eax | je @BM1
    mov D@mp2k eax

    add ebx ebx
    mov D@p2kSzT 32 | cmp D$p2k+4 0 | je L0> | add D@p2kSzT 32
L0:
call SetStartTick
L1:
cmp D$JobAskToEnd &TRUE | je @BM
    mov esi p2k
    and D$esi 0-2
    call 'AnyBits.AnyBitsAdditionSelf32Bit' esi D@p2kSzT ebx | jnc L0>
    mov eax D@p2kSzT | shr eax 3 | mov D$esi+eax 1 | add D@p2kSzT 32 ; enlarge
L0:
    call 'AnyBits.GetHighestBitPosition' esi D@p2kSzT | cmp edx 0-1 | je @BM
    cmp eax D@Mexp2kp | jae @BM
;L0:
    sub eax eax
    mov edi D@mp2k, ecx D@p2kSz | shr ecx 5 ;
    REP STOSD
    mov eax D@p2kSzT | mov D@p2kSzTa eax | shr eax 3 | call 'BaseRTL.CopyMemory' D@mp2k p2k eax
    mov esi D@mp2k
    jmp L0>

L4:
    and D$esi 0-2
    call 'AnyBits.AnyBitsShift1Left' esi D@p2kSzTa | jnc L0>
    mov eax D@p2kSzTa | shr eax 3 | mov D$esi+eax 1 | add D@p2kSzTa 32 ; enlarge
L0:
    call 'AnyBits.GetHighestBitPosition' esi D@p2kSzTa | cmp edx 0-1 | je @BM
    cmp eax D@Mexp2kp | jae L1<<
    Align_UP 32 eax | shl eax 1 | cmp eax D@sqSz | jbe L0>
    mov D@sqSz eax
    call VFree D@sq2 | call VFree D@sq1
    call VAlloc D@sqSz | mov D@sq1 eax | test eax eax | je @BM
    call VAlloc D@sqSz | mov D@sq2 eax | test eax eax | je @BM
L0:
    or D$esi 1
    mov eax D$esi ;| or eax 1
    and eax 7 | cmp eax 1 | je L0> | cmp eax 7 | jne L4<<
L0:
    call NumberModOn32BitPrimesFromSieve esi D@p2kSzTa 113 | cmp eax 0 | jne L4<< ;01AE0 4057 0D8

    call MersenneTFAnyBitsA D@sq2 D@sq1 D@sqSz esi D@p2kSzTa D@Mexponent | test eax eax | je @BM
    mov edi eax, edx edx
    call 'AnyBits.GetHighestBitPosition' edi edx | cmp edx 0-1 | je @BM
    cmp eax 0 | jne L3>

call SetEndTick
    call 'AnyBits.GetHighestBitPosition' D@mp2k D@p2kSzTa | cmp edx 0-1 | je L0>
    Align_UP 32 eax
    call dumpNModsAny D@mp2k eax
L0:
    jmp @BM
L3:
call SetEndTick
    mov edi p2k
    call reportCurrentNumNmods64 D@Mexponent D$edi D$edi+4
    jmp L4<<

@BM:
    mov edi p2k
    call dumpNumNmods64 D$edi D$edi+4 D@Mexponent
@BM1:
    call dumpEndTime
    call CloseLogFile
    call VFree D@sq2 | call VFree D@sq1 | call VFree D@mp2k
    call VFree D$SieveBase0 | and D$SieveBase0 0
EndP
;


[modfile: B$ '1276dallm',0 modfile1: B$ '1276dallm1',0]
;
;
Proc do2P1MTFAnyBitMTFactorFunnyB:
 cLocal @Mexponent @Mexp2kp @p2kSz @p2k @mp2kSz @mp2k @p2kSzT @p2kSzTa @sqSz @sq1 @sq2
 USES EBX ESI EDI

L0:
    call Input32BitNumber | cmp eax 0 | je P9>> | mov D@Mexponent eax
    call 'NUMERIKO.IsDwordPrimeNumeriko32' D@Mexponent | cmp eax 1 | jne L0<
    call TryLoad4GBrangeSieveFile 0 | mov D$SieveBase0 eax | test eax eax | je P9>>

    call 'BaseRTL.LoadFileNameA2Mem' modfile | SHL edx 3 | ALIGN_ON 32 edx | mov D@p2k eax, D@p2kSz edx
    call dumpStartTime
DBGBP

    mov ebx D@Mexponent | add ebx ebx
    mov eax D@Mexponent | shr eax 1 | add eax 1 | mov D@Mexp2kp eax
    Align_UP 32 eax | mov D@mp2kSz eax | shr eax 3
    call VAlloc eax | test eax eax | je @BM1
    mov D@mp2k eax
    move D@p2kSzT D@p2kSz ;| cmp D$p2k+4 0 | je L0> | add D@p2kSzT 32
;L0:
call SetStartTick
L1:
cmp D$JobAskToEnd &TRUE | je @BM
    mov esi D@p2k
    and D$esi 0-2
    call 'AnyBits.AnyBitsAdditionSelf32Bit' esi D@p2kSzT ebx | jnc L0>
    mov eax D@p2kSzT | shr eax 3 | mov D$esi+eax 1 | add D@p2kSzT 32 ; enlarge
L0:
    call 'AnyBits.GetHighestBitPosition' esi D@p2kSzT | cmp edx 0-1 | je @BM
    cmp eax D@Mexp2kp | jae @BM
;L0:
    sub eax eax
    mov edi D@mp2k, ecx D@mp2kSz | shr ecx 5 ;
    REP STOSD
    mov eax D@p2kSzT | mov D@p2kSzTa eax | shr eax 3 | call 'BaseRTL.CopyMemory' D@mp2k D@p2k eax
    mov esi D@mp2k
    jmp L0>

L4:
cmp D$JobAskToEnd &TRUE | je @BM
    and D$esi 0-2
    call 'AnyBits.AnyBitsShift1Left' esi D@p2kSzTa | jnc L0>
    mov eax D@p2kSzTa | shr eax 3 | mov D$esi+eax 1 | add D@p2kSzTa 32 ; enlarge
L0:
    call 'AnyBits.GetHighestBitPosition' esi D@p2kSzTa | cmp edx 0-1 | je @BM
    cmp eax D@Mexp2kp | jae L1<<
    Align_UP 32 eax | shl eax 1 | cmp eax D@sqSz | jbe L0>
    ALIGN_ON 010000 eax | mov D@sqSz eax
    call VFree D@sq2 | call VFree D@sq1
    call VAlloc D@sqSz | mov D@sq1 eax | test eax eax | je @BM
    call VAlloc D@sqSz | mov D@sq2 eax | test eax eax | je @BM
L0:
    or D$esi 1
    mov eax D$esi ;| or eax 1
    and eax 7 | cmp eax 1 | je L0> | cmp eax 7 | jne L4<<
L0:
    call NumberModOn32BitPrimesFromSieve esi D@p2kSzTa 113 | cmp eax 0 | jne L4<< ;01AE0 4057 0D8

    call MersenneTFAnyBitsA D@sq2 D@sq1 D@sqSz esi D@p2kSzTa D@Mexponent | test eax eax | je @BM
    mov edi eax, edx edx
    call 'AnyBits.GetHighestBitPosition' edi edx | cmp edx 0-1 | je @BM
    cmp eax 0 | jne L3>

call SetEndTick
;    call 'AnyBits.GetHighestBitPosition' D@mp2k D@p2kSzTa | cmp edx 0-1 | je L0>
;    Align_UP 32 eax
    call dumpNModsAny D@mp2k D@p2kSzTa
;L0:
    call dumpNModsAny D@p2k D@p2kSzT
    jmp @BM
L3:
call SetEndTick
    mov edi D@p2k
    call reportCurrentNumNmods64 D@Mexponent D$edi D$edi+4
    jmp L4<<

@BM:
    mov edi D@p2k
    call dumpNumNmods64 D$edi D$edi+4 D@Mexponent
@BM1:
    call dumpEndTime
    call CloseLogFile
    mov eax D@p2kSzT | shr eax 3 | call 'BaseRTL.WriteMem2FileNameA' modfile1 D@p2k eax
    call VFree D@sq2 | call VFree D@sq1 | call VFree D@mp2k | call VFree D@p2k
    call VFree D$SieveBase0 | and D$SieveBase0 0
EndP
;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Proc do2P1MTFAnyBitMTFactorFunnyBL:
 cLocal @Mexponent @Mexp2kp @p2kSz @p2k @mp2kSz @mp2k @p2kSzT @sqSz @sq1 @sq2
 USES EBX ESI EDI

L0:
    call Input32BitNumber | cmp eax 0 | je P9>> | mov D@Mexponent eax
    call 'NUMERIKO.IsDwordPrimeNumeriko32' D@Mexponent | cmp eax 1 | jne L0<
    call TryLoad4GBrangeSieveFile 0 | mov D$SieveBase0 eax | test eax eax | je P9>>
; load current MOD state
    call GetOpenFileName | test eax eax | je L0>
    call 'BaseRTL.LoadFileNameA2Mem' D$pOFileName1 | test eax eax | je P9>>
    SHL edx 3 | ALIGN_ON 32 edx | mov D@p2k eax, D@p2kSz edx
L0: cmp D@p2kSz 0 | jne L0>
    call VFree D@p2k | call VAlloc 8 | mov D@p2k eax, D@p2kSz 64 | test eax eax | je P9>>
L0:
    call dumpStartTime
DBGBP
    mov ebx D@Mexponent | add ebx ebx
    mov eax D@Mexponent | shr eax 1 | add eax 1 | mov D@Mexp2kp eax
    Align_UP 32 eax | mov D@mp2kSz eax | shr eax 3
    call VAlloc eax | test eax eax | je @BM1
    mov D@mp2k eax
    move D@p2kSzT D@p2kSz
    mov eax D@p2kSz | shr eax 3
    call 'BaseRTL.CopyMemory' D@mp2k D@p2k eax
;L0:
call SetStartTick
L1:
cmp D$JobAskToEnd &TRUE | je @BM
    mov esi D@mp2k
    and D$esi 0-2
    call 'AnyBits.AnyBitsAdditionSelf32Bit' esi D@p2kSzT ebx | jnc L0>
    mov eax D@p2kSzT | shr eax 3 | mov D$esi+eax 1 | add D@p2kSzT 32 ; enlarge
L0:
    call 'AnyBits.GetHighestBitPosition' esi D@p2kSzT | cmp edx 0-1 | je @BM
    cmp eax D@Mexp2kp | jae @BM

    Align_UP 32 eax | shl eax 1 | cmp eax D@sqSz | jbe L0>
    ALIGN_ON 010000 eax | mov D@sqSz eax
    call VFree D@sq2 | call VFree D@sq1
    call VAlloc D@sqSz | mov D@sq1 eax | test eax eax | je @BM
    call VAlloc D@sqSz | mov D@sq2 eax | test eax eax | je @BM
L0:
    or D$esi 1
    mov eax D$esi ;| or eax 1
    and eax 7 | cmp eax 1 | je L0> | cmp eax 7 | jne L1<<
L0:
    call NumberModOn32BitPrimesFromSieve esi D@p2kSzT 113 | cmp eax 0 | jne L1<<

    call MersenneTFAnyBitsA D@sq2 D@sq1 D@sqSz esi D@p2kSzT D@Mexponent | test eax eax | je @BM
    mov edi eax, edx edx
    call 'AnyBits.GetHighestBitPosition' edi edx | cmp edx 0-1 | je @BM
    cmp eax 0 | jne L3>

call SetEndTick
    call dumpNModsAny D@mp2k D@p2kSzT
    jmp @BM1
L3:
call SetEndTick
    mov edi D@mp2k
    call reportCurrentNumNmods64 D@Mexponent D$edi D$edi+4
    jmp L1<<

@BM:
    mov edi D@mp2k
    call dumpNumNmods64 D$edi D$edi+4 D@Mexponent
@BM1:
    call dumpEndTime
    call CloseLogFile
    mov eax D@p2kSzT | shr eax 3
    call ChooseAndSaveFileA D@mp2k eax
L0:
    call VFree D@sq2 | call VFree D@sq1 | call VFree D@mp2k | call VFree D@p2k
    call VFree D$SieveBase0 | and D$SieveBase0 0
EndP
;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Proc do2P1MTFAnyBitMTFactorFunnyBL1:
 cLocal @Mexponent @Mexp2kp @pkSz @pk @p2kSz @p2k @mp2kSz @mp2k @p2kSzT @sqSz @sq1 @sq2 @Sieve2pk @c2pkHi @c2pkLo
 USES EBX ESI EDI
    call 'KERNEL32.GetCurrentThread'
    call 'KERNEL32.SetThreadPriority', eax, &THREAD_PRIORITY_ABOVE_NORMAL
L0:
    call Input32BitNumber | cmp eax 0 | je P9>> | mov D@Mexponent eax
    call 'NUMERIKO.IsDwordPrimeNumeriko32' D@Mexponent | cmp eax 1 | jne L0<
; load current K
    call GetOpenFileName | test eax eax | je E0>>
DBGBP
    call 'BaseRTL.LoadFileNameA2Mem' D$pOFileName1 | test eax eax | je E0>>
    SHL edx 3 | ALIGN_ON 32 edx | mov D@pk eax, D@pkSz edx
    AND D$eax 080000000
L0: cmp D@pkSz 64 | jb E0>>

L0: mov eax D@pkSz | add eax 32 | mov D@p2kSz eax | shr eax 3
    call VAlloc eax | mov D@p2k eax | test eax eax | je E0>>

    mov eax D@Mexponent | shr eax 1 | add eax 1 | mov D@Mexp2kp eax
    Align_UP 32 eax | mov D@mp2kSz eax | shr eax 3
    call VAlloc eax | test eax eax | je E0>>
    mov D@mp2k eax
call dumpStartTime
@Rpt:
cmp D$JobAskToEnd &TRUE | je @BM1
    call Create2PKSieveAnyFromBaseSieve D@Mexponent D@pk D@pkSz | test eax eax | je @BM1
;;
    mov eax D@pk
    CLD | mov edi pReportBuffer
    call 'BaseCodecs.Q2H' edi, D$eax, D$eax+4 | add edi eax | mov al '_' | STOSB
    call 'BaseCodecs.D2H' edi, D@MExponent | add edi eax
    mov eax '.2ps' | STOSD | mov B$edi 0
    call 'BaseRTL.LoadFileNameA2Mem' pReportBuffer | test eax eax | je E0>>
;;
    mov D@Sieve2pk eax

    mov eax D@Mexponent | shl eax 1
    call 'AnyBits.AnyBitsMul32Bit' D@p2k D@p2kSz eax D@pk D@pkSz | test eax eax | je E0>>

    mov ebx 0
    mov esi D@mp2k

call SetStartTick
L1:
cmp D$JobAskToEnd &TRUE | je @BM1

    mov eax D@Sieve2pk
    dec ebx
L0: inc ebx | cmp ebx 080000000 | jae @BM
    BT D$eax ebx | jc L0<
    inc ebx
    mov eax D@Mexponent | shl eax 1 | mul ebx
    lea ecx D@c2pkLo
    mov D$ecx eax, D$ecx+4 edx
    mov eax D@p2kSz | add eax 32 | mov D@p2kSzT eax
    call 'AnyBits.AnyBitsAddition' esi D@p2kSzT D@p2k D@p2kSz ecx 64 | test eax eax | je @BM1
L0:
    updateBitSize esi D@p2kSzT
    call 'AnyBits.GetHighestBitPosition' esi D@p2kSzT | cmp edx 0-1 | je @BM1
    cmp eax D@Mexp2kp | jae @BM1

    Align_UP 32 eax | shl eax 1 | cmp eax D@sqSz | jbe L0>
    ALIGN_ON 010000 eax | mov D@sqSz eax
    call VFree D@sq2 | call VFree D@sq1
    call VAlloc D@sqSz | mov D@sq1 eax | test eax eax | je @BM1
    call VAlloc D@sqSz | mov D@sq2 eax | test eax eax | je @BM1
L0:
    or D$esi 1
    call MersenneTFAnyBitsA D@sq2 D@sq1 D@sqSz esi D@p2kSzT D@Mexponent | test eax eax | je @BM1
    mov edi eax, edx edx
    call 'AnyBits.GetHighestBitPosition' edi edx | cmp edx 0-1 | je @BM1
    cmp eax 0 | jne L3>

call SetEndTick
    call dumpNModsAny D@mp2k D@p2kSzT
    jmp @BM1
L3:
call SetEndTick
    mov edi D@mp2k
    call reportCurrentNumNmods64 D@Mexponent D$edi D$edi+4
    jmp L1<<

@BM:
    mov edi D@mp2k
    call dumpNumNmods64 D$edi D$edi+4 D@Mexponent
    call 'AnyBits.AnyBitsAdditionSelf32Bit' D@pk D@pkSz 080000000 | test eax eax | je @BM1
    cmp edx 0-1 | jne L0>
    mov eax D@pk, edx D@pkSz | shr edx 3 | mov D$eax+edx 1 | add D@pkSz 32 | add D@p2kSz 32 ; needs realloc
L0: CLD | mov edi pReportBuffer | mov eax 'next' | STOSD | mov ax 'K.' | STOSW
    call Dword2Decimal edi, D@MExponent | add edi eax | mov B$edi 0
    mov eax D@pkSz | shr eax 3 | call 'BaseRTL.WriteMem2FileNameA' pReportBuffer D@pk eax
    call VFree D@Sieve2pk | and D@Sieve2pk 0
    jmp @Rpt

@BM1:
    call dumpEndTime
    call CloseLogFile
    mov eax D@p2kSzT | shr eax 3
    call ChooseAndSaveFileA D@mp2k eax
E0:
    call VFree D@sq2 | call VFree D@sq1
    call VFree D@mp2k | call VFree D@Sieve2pk | call VFree D@pk
EndP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Proc do2P1MTFAnyBitMTFactorFunnyBL2:
 cLocal @Mexponent @Mexp2kp @pkSz @pk @p2kSz @p2k @mp2kSz @mp2k @p2kSzT @sqSz @sq1 @sq2 @Sieve2pk @c2pkHi @c2pkLo
 USES EBX ESI EDI
    call 'KERNEL32.GetCurrentThread'
    call 'KERNEL32.SetThreadPriority', eax, &THREAD_PRIORITY_ABOVE_NORMAL
L0:
    call Input32BitNumber | cmp eax 0 | je P9>> | mov D@Mexponent eax
    call 'NUMERIKO.IsDwordPrimeNumeriko32' D@Mexponent | cmp eax 1 | jne L0<
; load current K
    call GetOpenFileName | test eax eax | je E0>>
DBGBP
    call 'BaseRTL.LoadFileNameA2Mem' D$pOFileName1 | test eax eax | je E0>>
    SHL edx 3 | ALIGN_ON 32 edx | mov D@pk eax, D@pkSz edx
    AND D$eax 080000000
L0: cmp D@pkSz 64 | jb E0>>

L0: mov eax D@pkSz | add eax 32 | mov D@p2kSz eax | shr eax 3
    call VAlloc eax | mov D@p2k eax | test eax eax | je E0>>

    mov eax D@Mexponent | shr eax 1 | add eax 1 | mov D@Mexp2kp eax
    Align_UP 32 eax | mov D@mp2kSz eax | shr eax 3
    call VAlloc eax | test eax eax | je E0>>
    mov D@mp2k eax
call dumpStartTime
@Rpt:
cmp D$JobAskToEnd &TRUE | je @BM1
    call Create2PKSieveAnyFromBaseSieve D@Mexponent D@pk D@pkSz | test eax eax | je @BM1
;;
    mov eax D@pk
    CLD | mov edi pReportBuffer
    call 'BaseCodecs.Q2H' edi, D$eax, D$eax+4 | add edi eax | mov al '_' | STOSB
    call 'BaseCodecs.D2H' edi, D@MExponent | add edi eax
    mov eax '.2ps' | STOSD | mov B$edi 0
    call 'BaseRTL.LoadFileNameA2Mem' pReportBuffer | test eax eax | je E0>>
;;
    mov D@Sieve2pk eax

    mov eax D@Mexponent | shl eax 1
    call 'AnyBits.AnyBitsMul32Bit' D@p2k D@p2kSz eax D@pk D@pkSz | test eax eax | je E0>>

    mov ebx 0
    mov esi D@mp2k

call SetStartTick
L1:
cmp D$JobAskToEnd &TRUE | je @BM1

    mov eax D@Sieve2pk
    dec ebx
L0: inc ebx | cmp ebx 080000000 | jae @BM
    BT D$eax ebx | jc L0<
    inc ebx
    mov eax D@Mexponent | shl eax 1 | mul ebx
    lea ecx D@c2pkLo
    mov D$ecx eax, D$ecx+4 edx
    mov eax D@p2kSz | add eax 32 | mov D@p2kSzT eax
    call 'AnyBits.AnyBitsAddition' esi D@p2kSzT D@p2k D@p2kSz ecx 64 | test eax eax | je @BM1
L0:
    updateBitSize esi D@p2kSzT
    call 'AnyBits.GetHighestBitPosition' esi D@p2kSzT | cmp edx 0-1 | je @BM1
    cmp eax D@Mexp2kp | jae @BM1

    Align_UP 32 eax | shl eax 1 | cmp eax D@sqSz | jbe L0>
    ALIGN_ON 010000 eax | mov D@sqSz eax
    call VFree D@sq2 | call VFree D@sq1
    call VAlloc D@sqSz | mov D@sq1 eax | test eax eax | je @BM1
    call VAlloc D@sqSz | mov D@sq2 eax | test eax eax | je @BM1
L0:
    or D$esi 1
;    call NumberModOn32BitPrimesFromSieve esi D@p2kSzT 03C6430 | cmp eax 0 | je L0>;jne L1<<
;int 3
;L0:
    call MersenneTFAnyBitsA D@sq2 D@sq1 D@sqSz esi D@p2kSzT D@Mexponent | test eax eax | je @BM1
    mov edi eax, edx edx
    call 'AnyBits.GetHighestBitPosition' edi edx | cmp edx 0-1 | je @BM1
    cmp eax 0 | jne L3>

;    CLD | mov eax 0, ecx D@Mexponent, edi MNumber | ALIGN_UP 32 ECX | shr ecx 5 | REP STOSD
;    mov ecx D@Mexponent, edi MNumber | BTS D$edi ecx
;    call 'AnyBits.AnyBitsModulus' esi D@p2kSzT MNumber (160*8) | test eax eax | je @BM1
;    call 'AnyBits.GetHighestBitPosition' MNumber (160*8) | cmp edx 0-1 | je @BM1
;    cmp eax 0 | jne L3>
call SetEndTick
    call dumpNModsAny D@mp2k D@p2kSzT
    jmp @BM1
L3:
call SetEndTick
    mov edi D@mp2k
    call reportCurrentNumNmods64 D@Mexponent D$edi D$edi+4
    jmp L1<<

@BM:
    mov edi D@mp2k
    call dumpNumNmods64 D$edi D$edi+4 D@Mexponent

    call 'AnyBits.AnyBitsShift1Left' D@pk D@pkSz | jnc L0>
    mov eax D@pk, edx D@pkSz | shr edx 3 | mov D$eax+edx 1 | add D@pkSz 32 | add D@p2kSz 32
L0: CLD | mov edi pReportBuffer | mov eax 'next' | STOSD | mov ax 'R.' | STOSW
    call Dword2Decimal edi, D@MExponent | add edi eax | mov B$edi 0
    mov eax D@pkSz | shr eax 3 | call 'BaseRTL.WriteMem2FileNameA' pReportBuffer D@pk eax
    call VFree D@Sieve2pk | and D@Sieve2pk 0
    jmp @Rpt

@BM1:
    call dumpEndTime
    call CloseLogFile
    mov eax D@p2kSzT | shr eax 3
    call ChooseAndSaveFileA D@mp2k eax
E0:
    call VFree D@sq2 | call VFree D@sq1
    call VFree D@mp2k | call VFree D@Sieve2pk | call VFree D@pk
EndP
;[<16 MNumber: D$ ? # 40]



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
    call VAlloc eax | mov D@MExponentKcopy eax | test eax eax | je E1>>
    mov eax D@MExponentKcopySz | add eax 32 | mov D@MExponentKcopy2Sz eax |  shr eax 3
    call VAlloc eax | mov D@MExponentKcopy2 eax | test eax eax | je E1>>
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
    call VFree D@MExponentKcopy2
    call VFree D@MExponentKcopy
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
    call TryLoadB32primesFile | test eax eax | je P9>>;L1>
    mov D$mB32P eax, D$szB32P edx ;| jmp L0>
;L1:
;    call Create32bitSieveAndBytesDiff | test eax eax | je P9>>
;    call TryLoadB32primesFile | test eax eax | je P9>>
;    mov D$mB32P eax, D$szB32P edx
L0:
    call VAlloc 010000000 | mov D@pArrayBits eax | test eax eax | je E0>>
    CLD | mov edi pReportBuffer
    call 'BaseCodecs.D2H' edi, D@MExponent | add edi eax | mov al '_' | STOSB
    mov eax 'BASE' | STOSD | mov B$edi 0
    call 'BaseRTL.LoadFileNameA2Mem' pReportBuffer | test eax eax | je E0>>
    mov D@BaseKpSieve eax D@BaseKpSieveSz edx

    lea eax D@primecount
    call 'AnyBits.AnyBitsCompare' D@MExponentK D@MExponentKSz eax 32 | cmp eax 3 | jne L1>
    call Sieve2PKBase0 D$mB32P D@pArrayBits D@BaseKpSieve D@BaseKpSieveSz D@MExponent | test eax eax | je E0>
    mov D@primecount eax | jmp L0>
L1:
    call Sieve2PKAnyFromBaseSieve D$mB32P D@pArrayBits D@BaseKpSieve D@BaseKpSieveSz D@MExponentK D@MExponentKsz D@MExponent | test eax eax | je E0>
    mov D@primecount eax
L0:
and D$reportPrevTick 0
call reportCurrentNumNmods64 D@MExponent D@primecount 0
;;
    mov eax D@MExponentK
    CLD | mov edi pReportBuffer
    call 'BaseCodecs.Q2H' edi, D$eax, D$eax+4 | add edi eax | mov al '_' | STOSB
    call 'BaseCodecs.D2H' edi, D@MExponent | add edi eax
    mov eax '.2ps' | STOSD | mov B$edi 0
    call 'BaseRTL.WriteMem2FileNameA' pReportBuffer D@pArrayBits 010000000
;;
L8: call VFree D@BaseKpSieve
    mov eax D@pArrayBits | jmp P9>
E0: call VFree D@BaseKpSieve
    call VFree D@pArrayBits
    mov eax 0
EndP







;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Proc do2P1MTFAnyBitMTFactorFunnyBLXY:
 cLocal @Mexponent @Mexp2kp @p2kSzT @p2kSzTb @MpDp2Sz @MpDp2 @MpDp2cSz @MpDp2c @MpDp2dSz @MpDp2d; @p2kSzTa
 USES EBX ESI EDI

;    call TryLoad4GBrangeSieveFile 0 | mov D$SieveBase0 eax | test eax eax | je P9>>
DBGBP
    mov edi p2k1, ecx p2k1sq1, eax 0 | sub ecx edi | shr ecx 2 | CLD | REP STOSD
L0:
    call Input32BitNumber | cmp eax 0 | je P9>> | cmp eax 11 | jb L0<
    mov D@Mexponent eax | mov ebx eax
    call 'NUMERIKO.IsDwordPrimeNumeriko32' ebx | cmp eax 1 | jne L0<
    Align_UP 32 ebx | mov D@MpDp2Sz ebx, D@MpDp2cSz ebx, D@MpDp2dSz ebx
    shr ebx 3
    call VAlloc ebx | mov D@MpDp2 eax | test eax eax | je @BM1
    mov ecx D@Mexponent | BTS D$EAX ECX
    call VAlloc ebx | mov D@MpDp2c eax | test eax eax | je @BM1
    call VAlloc ebx | mov D@MpDp2d eax | test eax eax | je @BM1

    call 'AnyBits.AnyBitsSubstractSelf32Bit' D@MpDp2 D@MpDp2Sz 2; | jnc L0>
    mov ebx D@Mexponent | add ebx ebx
    call 'AnyBits.AnyBitsDiv32Bit' D@MpDp2 D@MpDp2Sz ebx | test eax eax | je @BM1
    mov D@p2kSzT 32
    mov eax D@Mexponent | shr eax 1 | add eax 1 | mov D@Mexp2kp eax

; load current MOD state
;    call GetOpenFileName | test eax eax | je L0>
;    call 'BaseRTL.LoadFileNameA2Mem' D$pOFileName1 | test eax eax | je P9>>
;    SHL edx 3 | ALIGN_ON 32 edx | mov D@p2k eax, D@p2kSz edx
;L0: cmp D@p2kSz 0 | jne L0>

 ;   mov D$p2k1 67115177
;L0:
;    call 'BaseRTL.LoadFileNameA2Mem' '2p1277-1D2554' | test eax eax | je @BM1

    call dumpStartTime
;L0:
call SetStartTick

; x=(MpDp2 -k) / (p2*k+1)

L1:
cmp D$JobAskToEnd &TRUE | je @BM
    mov esi p2k1
    call 'AnyBits.AnyBitsAdditionSelf32Bit' esi D@p2kSzT 0FFF1 | jnc L0>
    mov eax D@p2kSzT | shr eax 3 | mov D$esi+eax 1 | add D@p2kSzT 32 ; enlarge
L0:
;(MpDp2 -k)
    mov eax D@MpDp2Sz, D@MpDp2cSz eax | shr eax 3
    call 'BaseRTL.CopyMemory' D@MpDp2c D@MpDp2 eax
    call 'AnyBits.AnyBitsSubstractionSelf' esi D@p2kSzT D@MpDp2c D@MpDp2cSz ;| jnc L0>
;(p2*k)+1
    mov eax D@p2kSzT | add eax 32 | mov D@p2kSzTb eax
    call 'AnyBits.AnyBitsMul32Bit' p2k1b D@p2kSzTb ebx p2k1 D@p2kSzT | test eax eax | je @BM
    updateBitSize p2k1b D@p2kSzTb
    call 'AnyBits.AnyBitsAdditionSelf32Bit' p2k1b D@p2kSzTb 1 | jnc L0>
    mov eax D@p2kSzTb | shr eax 3 | mov D$esi+eax 1 | add D@p2kSzTb 32 ; enlarge
L0:
    call 'AnyBits.GetHighestBitPosition' p2k1b D@p2kSzTb | cmp edx 0-1 | je @BM
    cmp eax D@Mexp2kp | jae @BM

    call 'AnyBits.AnyBitsModulus'  p2k1b D@p2kSzTb D@MpDp2c D@MpDp2cSz | test eax eax | je @BM

;    call 'AnyBits.AnyBitsDivision' D@MpDp2d D@MpDp2dSz p2k1b D@p2kSzTb D@MpDp2c D@MpDp2cSz | test eax eax | je @BM
    ;cmp edx 0 | jne L0> | mov D@MpDp2cSz 0
L0:
    updateBitSize D@MpDp2c D@MpDp2cSz
    call 'AnyBits.GetHighestBitPosition' D@MpDp2c D@MpDp2cSz | cmp edx 0-1 | je @BM
    cmp eax 4 | ja L3>
call SetEndTick
    mov eax p2k1b
    call dumpNumNmods D$eax D@Mexponent
    mov eax p2k1, edi D@MpDp2c
    call dumpNumNmods D$eax D$edi
    cmp D$edi 0 | je @BM1
;    call dumpNModsAny D@mp2k D@p2kSzT
    jmp L1<<;@BM1
L3:
call SetEndTick
    mov edi p2k1
    call reportCurrentNumNmods64 D@Mexponent D$edi D$edi+4
    jmp L1<<

@BM:
    mov edi p2k1
    call dumpNumNmods64 D$edi D$edi+4 D@Mexponent
@BM1:
    call dumpEndTime
    call CloseLogFile
;    call GetSaveFileName | test eax eax | je L0>
;    mov eax D@MpDp2dSz | shr eax 3 | call 'BaseRTL.WriteMem2FileNameA' D$pSFileName1 D@MpDp2d eax
L0:
    call VFree D@MpDp2d |
    call VFree D@MpDp2c | call VFree D@MpDp2
;    call VFree D$SieveBase0 | and D$SieveBase0 0
EndP
;
















;;
Proc SearchFFDivizors32:
  USES EBX ESI EDI
;    INT 3
L0: test esp 7 | je L0> | push 0 | jmp L0<
L0: mov esi 057000 | lea ecx D$esi+1 | lea edi D$esi+01000
L2:
    mov eax ecx | and eax 7 | cmp eax 3 | je L3> | cmp eax 5 | je L3>
    mov eax 0-5 | sub edx edx | DIV ecx | mov ebx eax | sub ebx 1 | or ebx 1
L1: mov eax ebx | and eax 7 | cmp eax 3 | je L0> | cmp eax 5 | je L0>
    mov eax ebx
    MUL ecx | cmp eax 0-1 | jne L0>
    push ebx, ecx | jmp L3>
L0: add ebx 2 | jnc L1<
L3: add ecx 2 | cmp ecx edi | jb L2< ;jnc L2<
;    INT 3
;push 0,0,0,0
    call 'BaseCodecs.D2H', fnamehex esi | mov D$fnamehex+8 '.bin'
    mov edx esp, eax ebp | sub eax edx | sub eax 0C
    call 'BaseRTL.WriteMem2FileNameA', fnamehex, edx, eax

EndP
;
[<16 fnamehex: B$ ? #32]
;;


;
Proc OnMTFRptTest:
 cLocal @Bit32a @RepCnt ;@m2P @m2PSz  @Bit32H @Bit32
  USES EBX ESI EDI
    call Input32BitNumber | cmp eax 0 | je P9>> | mov D@Bit32a eax
    mov ESI p2k1
    call Input64BitNumber | mov D$esi eax, D$esi+4 edx
DBGBP
    mov D@RepCnt 10000
    call dumpStartTime
call SetStartTick
  mov eax D@Bit32a | add eax eax | mov D$esi eax | sub D$esi 1
L1:
cmp D$JobAskToEnd &TRUE | jne L0>
    mov D@RepCnt 1 | jmp L4>
L0:

  add D$esi 2 | adc D$esi+4 0 | jc @BM ;| or D$esi 1
;    call VFree D@m2P | and D@m2P 0
    call MersenneTFAnyBitsA p2k1sq2 p2k1sq1 128 esi 64 D@Bit32a | test eax eax | je @BM
    mov edi eax, ebx edx
    call 'AnyBits.GetHighestBitPosition' edi, ebx | cmp edx 0-1 | je @BM;D@m2P D@m2PSz
cmp eax 4 | ja L1<
L4:
call SetEndTick
;cmp edx D@Bit32a | ja L1<
    mov edx edi;D@m2P
    CLD | mov edi pReportBuffer
    call QwordPtr2Decimal edi edx | add edi eax | mov al 020 | STOSB
    mov edx esi
    call QwordPtr2Decimal edi edx | add edi eax | mov eax CRLF | STOSW | mov B$edi 0
    sub edi pReportBuffer
    call AppendToLogBuffer pReportBuffer edi
    call 'User32.SendMessageA', D$EDIT0_handle, &WM_SETTEXT, 0, pReportBuffer
    sub D@RepCnt 1 | jg L1<<
@BM:
    call dumpEndTime
    call CloseLogFile
;    call VFree D@m2P
EndP
;

;;
Proc do2P1Mod32BitPrimes:
; cLocal @inMem2P @inSz2P @inSz2Pb
 USES EBX ESI EDI

    cmp D$szB32P B32Psize | je L0>
    call TryLoadB32primesFile | test eax eax | je P9>>
    mov D$mB32P eax, D$szB32P edx
L0:
    call Input32BitNumber | cmp eax 0 | je P9>> | mov ebx eax
    call dumpStartTime
DBGBP

L2:
cmp D$JobAskToEnd &TRUE | je @BM
    call 'NUMERIKO.FindNearPrime32FromBit32DiffArray' D$mB32P D$szB32P 1 EBX
    test eax eax | je @BM
    mov ebx eax
    mov esi ebx
    mov edi ebx
call SetStartTick
;jmp L0>
L1:
    add edi ebx | jc L3> | test edi 1 | jne L1< | mov esi edi | add esi 1 | jc L3>
    mov eax esi | and eax 7 | cmp eax 3 | je L1< | cmp eax 5 | je L1<
L4: call 'NUMERIKO.IsDwordPrimeNumeriko32' esi | test eax eax | je L1<
L0:
    call Any2Npow1BitsVirtualMod32Bit ebx esi | test eax eax | je @BM
    test edx edx | jne L1<
call SetEndTick
    call dumpNumNmods esi ebx
    jmp L2<<
L3:
call SetEndTick
    call dumpNumNmods 0 ebx
    jmp L2<<

@BM:
    call dumpStartTime
    call CloseLogFile

EndP
;;
;;
Proc do2P1Mod64BitPrimes:
 cLocal @MPrime
 USES EBX ESI EDI

    cmp D$szB32P B32Psize | je L0>
    call TryLoadB32primesFile | test eax eax | je P9>>
    mov D$mB32P eax, D$szB32P edx
L0:
    call dumpStartTime
DBGBP
    mov D@MPrime 2 ;  94137259 ;
L2:
    call 'NUMERIKO.FindNearPrime32FromBit32DiffArray' D$mB32P D$szB32P 1 D@MPrime
    test eax eax | je @BM
    mov D@MPrime eax
    mov ebx eax, esi eax
    mov edi 0
call SetStartTick
jmp L0>
L1:
    add ebx D@MPrime | adc edi 0 | jc L3> | test ebx 1 | jne L1<
    mov esi ebx | add esi 1 | adc edi 0 | jc L3>
L5:
    test edi edi | jne L4>
    call 'NUMERIKO.IsDwordPrimeNumeriko32' esi | test eax eax | je L1<
    call Any2Npow1BitsVirtualMod32Bit D@MPrime esi | test eax eax | je @BM
    cmp edx 0 | jne L1< | jmp L0>

L4: call 'NUMERIKO.IsQwordPrimeNumeriko64' D$mB32P esi edi | test eax eax | je L1<
    call Any2Npow1BitsVirtualMod32Bit D@MPrime esi edi | test eax eax | je @BM
    cmp edx 0 | jne L1< | jmp L0>

L0:
call SetEndTick
    call dumpNumNmods esi ebx
    jmp L2<<
L3:
call SetEndTick
    call dumpNumNmods 0 ebx
    jmp L2<<

@BM:
    call dumpStartTime
    call CloseLogFile

EndP
;;

ALIGN 4
Proc dumpNumNmods:
 ARGUMENTS @nmod @num
  USES ESI EDI

    CLD
    mov esi pReportBuffer, edi esi
;    mov eax 'Num ' | stosd
    call Dword2Decimal edi D@num | add edi eax | mov al 020 | stosb
;    mov D$edi 'mod ' | add edi 4
    call Dword2Decimal edi D@nmod | add edi eax | mov al 020 | stosb
    mov eax D$endTick | sub eax D$curTick
    call Dword2Decimal edi eax | add edi eax | mov eax 'ms' | stosw
    ;call 'BaseRTL.GetCurrentTime2String' EDI | add edi eax
    mov eax 0A0D | stosw
    mov B$edi 0
    sub edi esi
    call AppendToLogBuffer esi edi
call 'User32.SendMessageA', D$EDIT0_handle, &WM_SETTEXT, 0, esi
call GetTimeTick | mov D$reportPrevTick eax
EndP

ALIGN 4
Proc dumpNum64Nmods:
 ARGUMENTS @nmod @num @numHi
  USES ESI EDI

    CLD
    mov esi pReportBuffer, edi esi
;    mov eax 'Num ' | stosd
    lea eax D@num
    call QwordPtr2Decimal edi eax | add edi eax | mov al 020 | stosb
;    mov D$edi 'mod ' | add edi 4
    call Dword2Decimal edi D@nmod | add edi eax | mov al 020 | stosb
    mov eax D$endTick | sub eax D$curTick
    call Dword2Decimal edi eax | add edi eax | mov eax 'ms' | stosw
    ;call 'BaseRTL.GetCurrentTime2String' EDI | add edi eax
    mov eax 0A0D | stosw
    mov B$edi 0
    sub edi esi
    call AppendToLogBuffer esi edi
call 'User32.SendMessageA', D$EDIT0_handle, &WM_SETTEXT, 0, esi
call GetTimeTick | mov D$reportPrevTick eax
EndP


ALIGN 4
Proc dumpNumNmods64:
 ARGUMENTS @nmod @nmodHi @num
  USES ESI EDI

    CLD
    mov esi pReportBuffer, edi esi
;    mov eax 'Num ' | stosd
    call Dword2Decimal edi D@num | add edi eax | mov al 020 | stosb
;    mov D$edi 'mod ' | add edi 4
    lea eax D@nmod
    call QwordPtr2Decimal edi eax | add edi eax | mov al 020 | stosb
    mov eax D$endTick | sub eax D$curTick
    call Dword2Decimal edi eax | add edi eax | mov eax 'ms' | stosw
    ;call 'BaseRTL.GetCurrentTime2String' EDI | add edi eax
    mov eax 0A0D | stosw
    mov B$edi 0
    sub edi esi
    call AppendToLogBuffer esi edi
call 'User32.SendMessageA', D$EDIT0_handle, &WM_SETTEXT, 0, esi
call GetTimeTick | mov D$reportPrevTick eax
EndP


ALIGN 4
Proc dumpNModsAny:
 ARGUMENTS @pNMod @NModSz
  USES ESI EDI

    mov eax D@NModSz | shr eax 2
    call VAlloc eax | test eax eax | je P9> | mov esi eax, edi eax
    call 'BaseCodecs.pAnyBits2HexA' esi D@pNMod D@NModSz | add edi eax
    mov eax 0A0D | stosw
    mov B$edi 0
    sub edi esi
    call AppendToLogBuffer esi edi

EndP


[reportPrevTick: D$ 0]
Proc reportCurrentNumNmods64:
 ARGUMENTS @nmod @num @numHi
  USES ESI EDI

call GetTimeTick | sub eax D$reportPrevTick | cmp eax 2000 | jb P9>
    CLD
    mov esi pReportBuffer, edi esi
    lea eax D@num
    call QwordPtr2Decimal edi eax | add edi eax | mov al 020 | stosb
    call Dword2Decimal edi D@nmod | add edi eax | mov al 020 | stosb
    mov eax D$endTick | sub eax D$curTick
    call Dword2Decimal edi eax | add edi eax | mov eax 'ms' | stosw
    mov eax 0A0D | stosw
    mov B$edi 0
call 'User32.SendMessageA', D$EDIT0_handle, &WM_SETTEXT, 0, esi
call GetTimeTick | mov D$reportPrevTick eax
EndP

[SieveBase0: D$]
Proc TryLoad4GBrangeSieveFile:
 ARGUMENTS @SieveBase

    call 'BaseCodecs.D2H' pReportBuffer, D@SieveBase | mov D$pReportBuffer+8 '.sv'
    call 'BaseRTL.LoadFileNameA2Mem' pReportBuffer

EndP




____________________________________________________________________________________________
TITLE LLtest


;;
S(p-2) is zero in this sequence: S0 = 4, SN = (SN-12 - 2) mod (2P-1).
For example, to prove 127 - 1 is prime:
S0 = 4
S1 = (4 * 4 - 2) mod 127 = 14
S2 = (14 * 14 - 2) mod 127 = 67
S3 = (67 * 67 - 2) mod 127 = 42
S4 = (42 * 42 - 2) mod 127 = 111
S5 = (111 * 111 - 2) mod 127 = 0
;;

[exp2counter: D$ 0 ]
Proc LLTestExponent:
 ARGUMENTS @exponent
 cLocal @inMemHighBit @m2P1Sz @m2P1 @SnSz @Sn ;@Sn1 ;@SnSz1
 USES EBX ESI EDI

    mov eax D@exponent | cmp eax 3 | jb E0>>
    Align_UP 32 eax | mov D@m2P1Sz eax | shr eax 3
    call VAlloc eax | test eax eax | je E0>>
    mov D@m2P1 eax
    mov ecx D@exponent | BTS D$EAX ECX
    sub eax 4
L0: add eax 4 | sub D$eax 1 | jc L0< ; bigSBB
    call 'AnyBits.GetHighestBitPosition' D@m2P1 D@m2P1Sz | cmp eax 0-1 | je E0>>
    mov D@inMemHighBit eax | Align_UP 32 eax | mov D@m2P1Sz eax

;    call VAlloc ebx | test eax eax | je E0>> | mov D@Sn1 eax
    call VAlloc 4 | test eax eax | je E0>> | mov D@Sn eax
    mov D@SnSz 32 | mov D$eax 4
    mov esi D@exponent | sub esi 2 | mov D$exp2counter 0
call SetStartTick
L0: cmp D$JobAskToEnd &TRUE | je E0>>
    inc D$exp2counter
    mov ebx D@SnSz | mov eax ebx | shl ebx 1 | shr eax 2
    call VAlloc eax | test eax eax | je E0>> | mov EDI eax
    call 'AnyBits.AnyBitsSquare' EDI ebx, D@Sn D@SnSz | test eax eax | je E0>> ; AnyBitsSquareM16 AnyBitsSquareK4
    call VFree D@Sn
    mov D@Sn EDI ;D@Sn1
    call 'AnyBits.AnyBitsSubstractSelf32Bit' D@Sn ebx 2
;    cmp edx 0-1 | jne L2> | INT3
;L2:
;    call 'AnyBits.GetHighestBitPosition' D@Sn ebx | cmp eax 0-1 | je E0>
;    cmp eax D@inMemHighBit | jb L2>
    call 'AnyBits.AnyBitsModulusOn2PowN1' D@m2P1 D@m2P1Sz D@Sn ebx | test eax eax | je E0> ;'AnyBits.AnyBitsModulus'
    test edx edx | je L1>
    call 'AnyBits.GetHighestBitPosition' D@Sn ebx | cmp eax 0-1 | je E0>
;L2: cmp eax 0 | jne L2> | inc eax ; for 32 ALIGN need
;    mov edx D@Sn | cmp D$edx 0 | je L1>
L2: Align_UP 32 eax | mov D@SnSz eax
    cmp esi D$exp2counter
    ja L0<<

call SetEndTick
;call errooo
    call dumpPrimes D@Sn D@exponent
    mov ebx 0 | jmp L9>
L1:
call SetEndTick
    cmp esi D$exp2counter | jne E0>
    call dumpPrimes D@Sn D@exponent
    mov ebx 1 | jmp L9>
E0: DBGBP
    mov ebx 0-1 | jmp L9>

L9: call VFree D@Sn | call VFree D@m2P1
    mov eax ebx
EndP
;********************************************************

Proc dumpPrimes:
 ARGUMENTS @Sn @nn
  USES EDI

    CLD
    mov edi pReportBuffer
    mov eax 'Prim' | stosd
    mov eax 'e_' | stosw
    call Dword2Decimal edi D@nn | add edi eax
    mov eax ' RES' | stosd | mov eax '64: ' | stosd
    call 'BaseCodecs.pQword2HexA' edi D@Sn | add edi eax | mov al 020 | stosb
    mov eax D$endTick | sub eax D$curTick
    call Dword2Decimal edi eax | add edi eax | mov eax 'ms' | stosw
    ;call 'BaseRTL.GetCurrentTime2String' EDI | add edi eax
    mov eax 0A0D | stosw
    mov B$edi 0
    sub edi pReportBuffer
    call AppendToLogBuffer pReportBuffer edi
 call 'User32.SendMessageA', D$EDIT0_handle, &WM_SETTEXT, 0, pReportBuffer
EndP

errooo:
pushad
    call 'User32.MessageBoxA' D$WindowHandle inputNumText "__Nooo!!" &MB_ICONWARNING
DBGBP
popad
ret

;;
 Proc LLTestExponent2x:
 ARGUMENTS @exponent
 cLocal @inMemHighBit @m2P1Sz @m2P1 @SnSz @Sn ;@Sn1 ;@SnSz1
 USES EBX ESI EDI

    mov eax D@exponent | cmp eax 3 | jb E0>>
    ALIGN_UP 32 eax | mov D@m2P1Sz eax | shr eax 3
    call VAlloc eax | test eax eax | je E0>>
    mov D@m2P1 eax
    mov ecx D@exponent | BTS D$EAX ECX
    sub eax 4
L0: add eax 4 | sub D$eax 1 | jc L0< ; bigSBB
    call 'AnyBits.GetHighestBitPosition' D@m2P1 D@m2P1Sz | cmp eax 0-1 | je E0>>
    mov D@inMemHighBit eax | ALIGN_UP 32 eax | mov D@m2P1Sz eax

;    call VAlloc ebx | test eax eax | je E0>> | mov D@Sn1 eax
    call VAlloc 4 | test eax eax | je E0>> | mov D@Sn eax
    mov D@SnSz 32 | mov D$eax 4
    mov esi D@exponent | sub esi 2 | mov D$exp2counter 0
L0:
    inc D$exp2counter
    mov ebx D@SnSz | mov eax ebx | shl ebx 1 | shr eax 2
    call VAlloc eax | test eax eax | je E0>> | mov EDI eax
    call 'AnyBits.AnyBitsSquare' EDI ebx, D@Sn D@SnSz | test eax eax | je E0>>



call TestDivSquareback D@Sn D@SnSz  EDI ebx | cmp eax 1 | je L2>
    call 'User32.MessageBoxA' D$WindowHandle inputNumText "Report this ERROR!!" &MB_ICONERROR


L2:
    call VFree D@Sn
    mov D@Sn EDI ;D@Sn1
    call 'AnyBits.AnyBitsSubstractSelf32Bit' D@Sn ebx 2
;    cmp edx 0-1 | jne L2> | INT3
;L2:
;    call 'AnyBits.GetHighestBitPosition' D@Sn ebx | cmp eax 0-1 | je E0>
;    cmp eax D@inMemHighBit | jb L2>
    call 'AnyBits.AnyBitsModulus' D@m2P1 D@m2P1Sz D@Sn ebx | test eax eax | je E0>
    test edx edx | je L1>
    call 'AnyBits.GetHighestBitPosition' D@Sn ebx | cmp eax 0-1 | je E0>
;L2: cmp eax 0 | jne L2> | inc eax ; for 32 ALIGN need
;    mov edx D@Sn | cmp D$edx 0 | je L1>
L2: ALIGN_UP 32 eax | mov D@SnSz eax
    cmp esi D$exp2counter
    ja L0<<

    mov ebx 0 | jmp L9>
L1:
    cmp esi D$exp2counter | jne E0>
    mov ebx 1 | jmp L9>
E0: DBGBP
    mov ebx 0-1 | jmp L9>

L9: call VFree D@Sn | call VFree D@m2P1
    mov eax ebx
EndP


proc TestDivSquareback:
 ARGUMENTS  @Sn @SnSz @Sq  @SqSz
 USES EBX ESI EDI

    mov ebx D@SqSz | shr ebx 3
    call MakeNumCopy  D@Sq ebx | test eax eax | je E0> | mov esi eax
    sub ebx D@SnSz | add ebx 32 | shr ebx 3 |
    call VAlloc ebx | test eax eax | je E0>> | mov EDI eax
    shl ebx 3
    call 'AnyBits.AnyBitsDivision' edi ebx D@Sn D@SnSz esi D@SqSz | test eax eax | je E0>
    test edx edx | jne E0>
    mov ebx 1 | jmp L9>
E0: DBGBP
    mov ebx 0
L9: call VFree edi | call VFree esi
    mov eax ebx
EndP
;;

Proc doLLTestExponent:
 USES EBX

    call Input32BitNumber | mov ebx eax | cmp ebx 0 | je P9>>
    call 'NUMERIKO.IsDwordPrime' ebx | test eax eax | jne L0>
    call 'User32.MessageBoxA' D$WindowHandle "Exponent Not a Prime" "Oops!" &MB_ICONINFORMATION
    sub eax eax | jmp P9>
L0:
DBGBP
    mov D$JobReporterAddr ReportLLTestExponentProgress
    call dumpStartTime
    call LLTestExponent ebx
    push eax
    call CloseLogFile
    pop eax | cmp eax 1 | jne L0>
    call 'User32.MessageBoxA' D$WindowHandle inputNumText "YES! 2P-1!" &MB_ICONINFORMATION
    jmp P9>
L0: cmp eax 0 | jne L0>
    call 'User32.MessageBoxA' D$WindowHandle inputNumText "__Nooo!!" &MB_ICONWARNING
    jmp P9>
L0:
    call 'User32.MessageBoxA' D$WindowHandle inputNumText "Report this ERROR!!" &MB_ICONERROR

EndP


Proc doLLTestExponentRpt:
 USES EBX
DBGBP
    call dumpStartTime
    mov ebx 2
L1:
    call 'NUMERIKO.FindNextPrimeDword' ebx | test eax eax | je L0>
    mov ebx eax
    call LLTestExponent ebx
    push eax
    call Dword2Decimal inputNumText ebx | add eax inputNumText | mov B$eax 0
    pop eax
    cmp eax 0 | je L1<
    cmp eax 0-1 | je L0>
    call 'User32.MessageBoxA' D$WindowHandle inputNumText "YES! 2P-1!" &MB_ICONINFORMATION
    jmp L1<
L0:
    call CloseLogFile

EndP


Proc ReportLLTestExponentProgress:
 USES ESI EDI
 DBGBP
    CLD
    mov edi pReportBuffer
    call Dword2Decimal edi D$exp2counter | add edi eax
    mov eax ' of ' | STOSD
    mov esi inputNumText
L0: LODSB | STOSB | test al al | jne L0<
    dec edi
    call 'User32.SendMessageA', D$WindowHandle, &WM_SETTEXT, 0, pReportBuffer

EndP
____________________________________________________________________________________________

[<01000 pReportBuffer: B$ ? #256 ]













