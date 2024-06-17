VERSION 2.00
Begin Form frmView1MB 
   BorderStyle     =   3  'Fixed Double
   Caption         =   "View Low Memory"
   ClientHeight    =   2490
   ClientLeft      =   1095
   ClientTop       =   1485
   ClientWidth     =   8400
   Height          =   2895
   Left            =   1035
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   ScaleHeight     =   2490
   ScaleWidth      =   8400
   Top             =   1140
   Width           =   8520
   Begin CommandButton cmdAdd 
      Caption         =   "&Add"
      Height          =   405
      Left            =   5610
      TabIndex        =   6
      Top             =   1980
      Width           =   1245
   End
   Begin CommandButton cmdRefresh 
      Caption         =   "&Refresh"
      Height          =   405
      Left            =   6960
      TabIndex        =   4
      Top             =   1980
      Width           =   1335
   End
   Begin ListBox lstUsed 
      FontBold        =   0   'False
      FontItalic      =   0   'False
      FontName        =   "Fixedsys"
      FontSize        =   9
      FontStrikethru  =   0   'False
      FontUnderline   =   0   'False
      Height          =   1605
      Left            =   2940
      MultiSelect     =   2  'Extended
      TabIndex        =   1
      Top             =   300
      Width           =   5355
   End
   Begin ListBox lstFree 
      FontBold        =   0   'False
      FontItalic      =   0   'False
      FontName        =   "Fixedsys"
      FontSize        =   9
      FontStrikethru  =   0   'False
      FontUnderline   =   0   'False
      Height          =   1605
      Left            =   90
      TabIndex        =   0
      Top             =   300
      Width           =   2565
   End
   Begin Label lblTotFree 
      AutoSize        =   -1  'True
      Caption         =   "Total Free: "
      Height          =   195
      Left            =   90
      TabIndex        =   5
      Top             =   1980
      Width           =   1005
   End
   Begin Label Label1 
      Caption         =   "Used Blocks "
      Height          =   225
      Index           =   1
      Left            =   2940
      TabIndex        =   3
      Top             =   60
      Width           =   1245
   End
   Begin Label Label1 
      Caption         =   "Free Blocks"
      Height          =   225
      Index           =   0
      Left            =   90
      TabIndex        =   2
      Top             =   60
      Width           =   1245
   End
End
Option Explicit

Sub cmdAdd_Click ()
    Dim i As Integer
    Dim l_SubTot As Long

    If frmView1MB!lstUsed.SelCount <= 0 Then
        MsgBox "You must first select items from Used Blocks list"
        Exit Sub
    End If
    
    For i = 0 To frmView1MB!lstUsed.ListCount - 1
        If frmView1MB!lstUsed.Selected(i) Then
            l_SubTot = l_SubTot + frmView1MB!lstUsed.ItemData(i)
        End If
    Next i

    MsgBox "Selected items:" & Str$(frmView1MB!lstUsed.SelCount) & " total used:" & Str$(l_SubTot) & " bytes"
        
End Sub

Sub cmdRefresh_Click ()
    
    'Call procedure to walk heap via ToolHelp Functions
    Call WalkIt

End Sub

Sub Form_Load ()
    Call WalkIt
End Sub

