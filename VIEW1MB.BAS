Option Explicit

Type GLOBALENTRYtype
    dwSize As Long
    dwAddress As Long
    dwBlockSize As Long
    hBlock As Integer
    wcLock As Integer
    wcPageLock As Integer
    wFlags As Integer
    wHeapPresent As Integer
    hOwner As Integer
    wType As Integer
    wData As Integer
    dwNext As Long
    dwNextAlt As Long
End Type

Type MODULEENTRYtype
    dwSize As Long
    szModule As String * 10
    hModule As Integer
    wcUsage As Integer
    szExePath As String * 256
    wNext As Integer
End Type


Type TASKENTRYtype
    dwSize As Long
    hTask As Integer
    hTaskParent As Integer
    hInst As Integer
    hModule As Integer
    wSS As Integer
    wSP As Integer
    wStackTop As Integer
    wStackMinimum As Integer
    wStackBottom As Integer
    wcEvents As Integer
    hQueue As Integer
    szModule As String * 10
    wPSPOffset As Integer
    hNext As Integer
End Type


'/* GlobalFirst()/GlobalNext() flags */
Const GLOBAL_ALL = 0
Const GLOBAL_LRU = 1
Const GLOBAL_FREE = 2

'/* GLOBALENTRY.wType entries */
Const GT_UNKNOWN = 0
Const GT_DGROUP = 1
Const GT_DATA = 2
Const GT_CODE = 3
Const GT_TASK = 4
Const GT_RESOURCE = 5
Const GT_MODULE = 6
Const GT_FREE = 7
Const GT_INTERNAL = 8
Const GT_SENTINEL = 9
Const GT_BURGERMASTER = 10

'/* If GLOBALENTRY.wType==GT_RESOURCE, the following is GLOBALENTRY.wData: */
Const GD_USERDEFINED = 0
Const GD_CURSORCOMPONENT = 1
Const GD_BITMAP = 2
Const GD_ICONCOMPONENT = 3
Const GD_MENU = 4
Const GD_DIALOG = 5
Const GD_STRING = 6
Const GD_FONTDIR = 7
Const GD_FONT = 8
Const GD_ACCELERATORS = 9
Const GD_RCDATA = 10
Const GD_ERRTABLE = 11
Const GD_CURSOR = 12
Const GD_ICON = 14
Const GD_NAMETABLE = 15
Const GD_MAX_RESOURCE = 15


'/* LOCALENTRY.wHeapType flags */
Const NORMAL_HEAP = 0
Const USER_HEAP = 1
Const GDI_HEAP = 2

'/* LOCALENTRY.wFlags */
Const LF_FIXED = 1
Const LF_FREE = 2
Const LF_MOVEABLE = 4

Dim lmLastFixed As Long
Dim lmTotFree As Long


Declare Function GlobalFirst Lib "ToolHelp.DLL" (lpge As GLOBALENTRYtype, ByVal wFlags As Integer) As Integer
Declare Function GlobalNext Lib "ToolHelp.DLL" (lpge As GLOBALENTRYtype, ByVal wFlags As Integer) As Integer

Declare Function ModuleFirst Lib "ToolHelp.DLL" (lpModule As MODULEENTRYtype) As Integer
Declare Function ModuleNext Lib "ToolHelp.DLL" (lpModule As MODULEENTRYtype) As Integer
Declare Function ModuleFindHandle Lib "ToolHelp.DLL" (lpModule As MODULEENTRYtype, ByVal hModule As Integer) As Integer
Declare Function ModuleFindName Lib "ToolHelp.DLL" (lpModule As MODULEENTRYtype, lpstrName As String) As Integer

Declare Function TaskFindHandle Lib "ToolHelp.DLL" (lpTask As TASKENTRYtype, ByVal hTask As Integer) As Integer

Declare Function TaskFirst Lib "ToolHelp.DLL" (lpTask As TASKENTRYtype) As Integer

'Adds Current global Entry to used list box
'and adds item to free list if need be.
'
Sub AddBlock2List (tpGE As GLOBALENTRYtype)
    Dim i_Fixed As Integer
    Dim l_FreeLen As Long
    Dim s_typ As String

    'Check if block is used
    If tpGE.wType <> GT_FREE Then

        'Don't handle sentinel blocks
        If tpGE.hBlock = 0 Then
            Exit Sub
        Else
            
            'Check for fixed memory block
            i_Fixed = (tpGE.hBlock And 1) Or tpGE.wcLock Or tpGE.wcPageLock
        
            If i_Fixed > 0 Then

                'See if there is free block between this and last one
                If tpGE.dwAddress > lmLastFixed And lmLastFixed <> 0 Then
                    'Calculate free block size
                    l_FreeLen = tpGE.dwAddress - lmLastFixed
                    'Add it to free list
                    frmView1MB!lstFree.AddItem Hex$(lmLastFixed) & " " & Format$(Hex$(l_FreeLen), "@@@@") & " bytes"
                    'compute running total of free blocks
                    lmTotFree = lmTotFree + l_FreeLen
                End If

                'save for next block check
                lmLastFixed = tpGE.dwAddress + tpGE.dwBlockSize

                'determine type Fixed or Locked
                s_typ = IIf((tpGE.hBlock And 1) > 0, "Fixed", "Locked")

                'Add it to used list
                frmView1MB!lstUsed.AddItem Hex$(tpGE.dwAddress) & " " & Format$(Hex$(tpGE.dwBlockSize), "@@@@") & " bytes (" & GetModuleName(tpGE.hOwner) & " " & BlkType(tpGE.wType) & " " & s_typ & ")"

                frmView1MB!lstUsed.ItemData(frmView1MB!lstUsed.NewIndex) = tpGE.dwBlockSize

            End If
        End If

    End If

                    



End Sub

Function BlkType (ipBlkType As Integer) As String


    Select Case ipBlkType
        Case GT_UNKNOWN
            BlkType = "Uknown"
        Case GT_DGROUP
            BlkType = "DGroup"
        Case GT_DATA
            BlkType = "Data"
        Case GT_CODE
            BlkType = "Code"
        Case GT_TASK
            BlkType = "Task"
        Case GT_RESOURCE
            BlkType = "Resource"
        Case GT_MODULE
            BlkType = "Module"
        Case GT_FREE
            BlkType = "Free"
        Case GT_INTERNAL
            BlkType = "Internal"
        Case GT_SENTINEL
            BlkType = "Sentinel"
        Case GT_BURGERMASTER
            BlkType = "Burgermaster"
    End Select


End Function

Function DispFirstTask () As String
    Dim t_me As MODULEENTRYtype
    Dim t_te As TASKENTRYtype
    Dim i_hOwner As Integer
    
    Dim i_ret As Integer

    
    
    t_te.dwSize = 39

    i_ret = TaskFirst(t_te)

    If i_ret > 0 Then
        DispFirstTask = t_te.szModule
        Exit Function
    End If
    

End Function

Function GetModuleName (hOwner As Integer) As String
    Dim t_me As MODULEENTRYtype
    Dim t_te As TASKENTRYtype
    Dim i_hOwner As Integer
    Dim i_Null As Integer
    
    Dim i_ret As Integer

    
    
    t_te.dwSize = 40
    i_hOwner = hOwner

    i_ret = TaskFindHandle(t_te, i_hOwner)

    If i_ret > 0 Then
        i_Null = InStr(t_te.szModule, Chr$(0))
        If i_Null <> 0 Then
            GetModuleName = Left$(t_te.szModule, i_Null - 1)
        Else
            GetModuleName = Trim$(t_te.szModule)
        End If
        Exit Function
    End If
    
    t_me.dwSize = 276

    i_ret = ModuleFindHandle(t_me, i_hOwner)
    
    If i_ret > 0 Then
        i_Null = InStr(t_me.szModule, Chr$(0))
        If i_Null <> 0 Then
            GetModuleName = Left$(t_me.szModule, i_Null - 1)
        Else
            GetModuleName = Trim$(t_me.szModule)
        End If
        Exit Function
    End If

    GetModuleName = ""


End Function

'Walk Global Heap
Sub WalkIt ()
    Dim t_ge As GLOBALENTRYtype
    Dim i_ret As Integer
    Dim i As Integer
    Dim i_Done As Integer
    Dim l_lastBelow1MB As Long

    'initialize
    lmTotFree = 0
    l_lastBelow1MB = 0

    'Clear list boxes
    frmView1MB!lstUsed.Clear
    frmView1MB!lstFree.Clear
    
    'Have to tell ToolHelp how big sturcture is
    'Boy do I miss 'C' type function sizeof()
    t_ge.dwSize = 36
    
    'Get first entry on Gloabl Heap type All
    i_ret = GlobalFirst(t_ge, GLOBAL_ALL)

    'success?
    If i_ret > 0 Then
        Call AddBlock2List(t_ge)
    End If


    i_Done = False

    While i_Done = False
    
        t_ge.dwSize = 36
        
        'Get Next entry on Heap
        i_ret = GlobalNext(t_ge, GLOBAL_ALL)

        'Are we below 1MB?
        'VB long is signed so negative indicates above 1MB
        If t_ge.dwAddress >= &H100000 Or t_ge.dwAddress < 0 Then
            i_Done = True
            
            'Create a phony entry to calculate last free block
            t_ge.dwAddress = l_lastBelow1MB
            t_ge.hBlock = &HFFFF  'A pseudo FIXED handle
            t_ge.wType = GT_SENTINEL
            'Add to list boxes
            Call AddBlock2List(t_ge)
            
        Else
        
            'Failure? or end of Heap?
            If i_ret = 0 Then
                'no more blocks or other failure
                i_Done = True
            Else
                'Add to list boxes
                Call AddBlock2List(t_ge)
            
            End If
        
            'calculate address
            l_lastBelow1MB = t_ge.dwAddress + t_ge.dwBlockSize
        
        End If

    Wend

    'We are done so display accumalated total of free below 1MB
    frmView1MB!lblTotFree = "Total Free: " & Hex$(lmTotFree) & "H (" & Trim$(Str$(lmTotFree)) & ") bytes"

End Sub

