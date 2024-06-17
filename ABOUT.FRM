VERSION 2.00
Begin Form frmAbout 
   BorderStyle     =   3  'Fixed Double
   Caption         =   "About View1MB"
   ClientHeight    =   2085
   ClientLeft      =   1095
   ClientTop       =   1485
   ClientWidth     =   5430
   ControlBox      =   0   'False
   Height          =   2490
   Left            =   1035
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2085
   ScaleWidth      =   5430
   Top             =   1140
   Width           =   5550
   Begin CommandButton cmdOK 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   405
      Left            =   2010
      TabIndex        =   0
      Top             =   1320
      Width           =   1245
   End
   Begin Label Label1 
      Alignment       =   2  'Center
      Caption         =   "First Published in PC Magazine, March 28, 1995, US Edition"
      Height          =   285
      Index           =   1
      Left            =   60
      TabIndex        =   2
      Top             =   540
      Width           =   5325
   End
   Begin Label Label1 
      Alignment       =   2  'Center
      Caption         =   "View1MB Version 1.0 Copyright (c) 1995 John McSorley."
      Height          =   285
      Index           =   0
      Left            =   60
      TabIndex        =   1
      Top             =   150
      Width           =   5325
   End
End
Option Explicit

'View1MB Version 1.0 Copyright (c) 1995 John McSorley.
'First Published in PC Magazine, March 28, 1995, US Edition

Sub cmdOK_Click ()
    Unload Me
End Sub

Sub Form_Click ()
    Unload Me
End Sub

Sub Form_Load ()
    'Center form on screen
    Me.Top = (Screen.Height / 2) - (Me.Height / 2)
    Me.Left = (Screen.Width / 2) - (Me.Width / 2)


End Sub

Sub Label1_Click (Index As Integer)
    Unload Me
End Sub

