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
	#tag Method, Flags = &h0, Description = 52657475726E7320612072616E646F6D20737472696E67206F6620606C656E677468602E
		Function RandomString(length As Integer = 1) As String
		  /// Returns a random string of `length`.
		  
		  If length = 1 Then
		    Return Chr(System.Random.InRange(48, 122))
		    
		  ElseIf length > 1 Then
		    Var s() As String
		    For i As Integer = 1 To length
		      s.Add(Chr(System.Random.InRange(48, 122)))
		    Next i
		    
		    Return String.FromArray(s, "")
		    
		  Else
		    Raise New InvalidArgumentException("length must be > 1.")
		  End If
		  
		End Function
	#tag EndMethod


#tag EndWindowCode

