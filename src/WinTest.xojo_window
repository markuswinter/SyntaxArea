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
		  #Pragma Warning "TODO: Finish timing"
		  
		  // Create a random 5000 character string to store.
		  Var tmp(5000) As String
		  For i As Integer = 0 To 4999
		    tmp(i) = Chr(System.Random.InRange(65, 122))
		  Next i
		  Var test As String = String.FromArray(tmp, "")
		  
		  Const ITERATIONS = 2000
		  Var watch As New StopWatch
		  
		  // ===================
		  // Array storage
		  // ===================
		  Var a As New ArrayStorage
		  
		  // 1. Fixed insertion at index 0.
		  a.StringValue = test
		  watch.Start
		  For i As Integer = 1 To ITERATIONS
		    a.Insert(0, RandomString)
		  Next i
		  watch.Stop
		  Var aFixedInsertion As Integer = watch.ElapsedMilliseconds
		  
		  // 2. Replace random words.
		  a.StringValue = test
		  watch.Start
		  For i As Integer = 1 To ITERATIONS
		    a.Replace(System.Random.InRange(0, 1000), 5, RandomString(5))
		  Next i
		  watch.Stop
		  Var aRandomReplace As Integer = watch.ElapsedMilliseconds
		  
		  // 3. Delete the last character repeatedly.
		  a.StringValue = test
		  watch.Start
		  For i As Integer = ITERATIONS DownTo 1
		    Call a.Remove(ITERATIONS, 1)
		  Next i
		  watch.Stop
		  Var aRemoveLastChar As Integer = watch.ElapsedMilliseconds
		  
		  // ===================
		  // Gap buffer storage
		  // ===================
		  Var gb As New GapBuffer
		  
		  // 1. Fixed insertion at index 0.
		  gb.StringValue = test
		  watch.Start
		  For i As Integer = 1 To ITERATIONS
		    gb.Insert(0, RandomString)
		  Next i
		  watch.Stop
		  Var gbFixedInsertion As Integer = watch.ElapsedMilliseconds
		  
		  // 2. Replace random words.
		  gb.StringValue = test
		  watch.Start
		  For i As Integer = 1 To ITERATIONS
		    gb.Replace(System.Random.InRange(0, 1000), 5, RandomString(5))
		  Next i
		  watch.Stop
		  Var gbRandomReplace As Integer = watch.ElapsedMilliseconds
		  
		  // 3. Delete the last character repeatedly.
		  gb.StringValue = test
		  watch.Start
		  For i As Integer = ITERATIONS DownTo 1
		    Call gb.Remove(ITERATIONS, 1)
		  Next i
		  watch.Stop
		  Var gbRemoveLastChar As Integer = watch.ElapsedMilliseconds
		  
		  Break
		  
		End Sub
	#tag EndEvent


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

