#tag DesktopWindow
Begin DesktopWindow WinTest
   Backdrop        =   0
   BackgroundColor =   &cFFFFFF
   Composite       =   False
   DefaultLocation =   2
   FullScreen      =   False
   HasBackgroundColor=   False
   HasCloseButton  =   True
   HasFullScreenButton=   False
   HasMaximizeButton=   True
   HasMinimizeButton=   True
   Height          =   720
   ImplicitInstance=   True
   MacProcID       =   0
   MaximumHeight   =   32000
   MaximumWidth    =   32000
   MenuBar         =   1977065471
   MenuBarVisible  =   False
   MinimumHeight   =   64
   MinimumWidth    =   64
   Resizeable      =   True
   Title           =   "SyntaxArea Test"
   Type            =   0
   Visible         =   True
   Width           =   1000
   Begin SyntaxArea Editor
      AutoDeactivate  =   True
      BackgroundColor =   &c1B1C1D00
      BorderColor     =   &c4F4F4F00
      Enabled         =   True
      FontName        =   "System"
      HasBottomBorder =   True
      HasLeftBorder   =   True
      HasRightBorder  =   True
      HasTopBorder    =   True
      Height          =   680
      Index           =   -2147483648
      InitialParent   =   ""
      Left            =   20
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      NeedsFullRedraw =   True
      ReadOnly        =   False
      Scope           =   0
      TabIndex        =   0
      TabPanelIndex   =   0
      TabStop         =   True
      TextColor       =   &cFFFFFF00
      TextSize        =   12
      Tooltip         =   ""
      Top             =   20
      Visible         =   True
      Width           =   960
   End
End
#tag EndDesktopWindow

#tag WindowCode
	#tag Event
		Sub Opening()
		  '#Pragma Warning "TODO: Finish timing"
		  '
		  '// Create a random 5000 character string.
		  'Var tmp(5000) As String
		  'For i As Integer = 0 To 4999
		  'tmp(i) = Chr(System.Random.InRange(65, 122))
		  'Next i
		  'Var startString As String = String.FromArray(tmp, "")
		  '
		  'Const ITERATIONS = 50000
		  'Var index As Integer
		  '
		  '// ================
		  '// Xojo array
		  '// ================
		  'Var a() As String = startString.Split("")
		  'Var xojoStart As Double = System.Microseconds
		  '
		  ''// Insert a random character sequentially to simulate typing.
		  ''index = 0
		  ''For i As Integer = 0 To 4999
		  ''a.AddAt(index, RandomChar)
		  ''index = index + 1
		  ''Next i
		  '
		  ''// Get varying strings of length 5 from the storage.
		  ''For i As Integer = 1 To ITERATIONS
		  ''Var idx As Integer = System.Random.InRange(0, 4900)
		  ''Var s As String = String.FromArray(a).Middle(idx, 5)
		  ''Next i
		  '
		  '// Replace random location 5 character strings with another random 5 character string.
		  'For i As Integer = 1 To ITERATIONS
		  'Var newString As String = RandomChar(5)
		  'Var idx As Integer = System.Random.InRange(0, 4900)
		  '
		  'Next i
		  '
		  ''// Insert at random index.
		  ''For i As Integer = 1 To ITERATIONS
		  ''a.AddAt(System.Random.InRange(0, a.LastIndex), RandomChar)
		  ''Next i
		  '
		  ''// Insert at fixed index (zero).
		  ''For i As Integer = 1 To ITERATIONS
		  ''a.AddAt(0, RandomChar)
		  ''Next i
		  'Var xojoTotal As Integer = (System.Microseconds - xojoStart) / 1000 // Nearest millisecond.
		  '
		  '// ================
		  '// GapBuffer
		  '// ================
		  'Var gb As New GapBuffer
		  'gb.StringValue = startString
		  'Var gbStart As Double = System.Microseconds
		  '
		  ''// Insert a random character sequentially to simulate typing.
		  ''index = 0
		  ''For i As Integer = 0 To 4999
		  ''gb.Insert(index, RandomChar)
		  ''index = index + 1
		  ''Next i
		  '
		  ''// Get varying strings of length 5 from the storage.
		  ''For i As Integer = 1 To ITERATIONS
		  ''Var idx As Integer = System.Random.InRange(0, 4900)
		  ''Var s As String = gb.StringAt(idx, 5)
		  ''Next i
		  '
		  ''// Insert at random index.
		  ''For i As Integer = 1 To ITERATIONS
		  ''gb.Insert(System.Random.InRange(0, 4999), RandomChar)
		  ''Next i
		  '
		  ''// Insert at fixed index (zero).
		  ''For i As Integer = 1 To ITERATIONS
		  ''gb.Insert(0, RandomChar)
		  ''Next i
		  'Var gbTotal As Integer = (System.Microseconds - gbStart) / 1000 // Nearest millisecond.
		  '
		  'Break
		  
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0, Description = 52657475726E7320612072616E646F6D206368617261637465722E
		Function RandomChar() As String
		  /// Returns a random character.
		  
		  Return Chr(System.Random.InRange(48, 122)) // "Normal" ASCII characters.
		  
		End Function
	#tag EndMethod


#tag EndWindowCode

