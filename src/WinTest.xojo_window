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
   Width           =   1200
   Begin SyntaxArea Editor
      AutoDeactivate  =   True
      BackgroundColor =   &c17171700
      BlinkCaret      =   True
      BorderColor     =   &c4F4F4F00
      CaretColor      =   &cC2000000
      CaretPosition   =   0
      CaretType       =   ""
      ColumnsPerIndent=   2
      CurrentLineHighlightColor=   &c1C1D1E00
      CurrentUndoID   =   0
      DisplayLineNumbers=   True
      Enabled         =   True
      FirstVisibleLine=   0
      FontName        =   "Source Code Pro"
      FontSize        =   14
      HasBottomBorder =   True
      HasLeftBorder   =   True
      HasRightBorder  =   True
      HasTopBorder    =   True
      Height          =   680
      HighlightCurrentLine=   True
      Index           =   -2147483648
      InitialParent   =   ""
      Left            =   20
      LineNumberFontSize=   12
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      LongestLineChanged=   False
      NeedsFullRedraw =   True
      ReadOnly        =   False
      Scope           =   0
      ScrollPosX      =   0
      SelectionLength =   0
      SelectionStart  =   0
      TabIndex        =   0
      TabPanelIndex   =   0
      TabStop         =   True
      TextColor       =   &cFFFFFF00
      TextSelected    =   False
      Tooltip         =   ""
      Top             =   20
      Typing          =   False
      VerticalLinePadding=   2
      Visible         =   True
      Width           =   799
      WordWrap        =   False
   End
   Begin DesktopListBox DebugListbox
      AllowAutoDeactivate=   True
      AllowAutoHideScrollbars=   True
      AllowExpandableRows=   False
      AllowFocusRing  =   True
      AllowResizableColumns=   False
      AllowRowDragging=   False
      AllowRowReordering=   False
      Bold            =   False
      ColumnCount     =   4
      ColumnWidths    =   ""
      DefaultRowHeight=   -1
      DropIndicatorVisible=   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      GridLineStyle   =   0
      HasBorder       =   True
      HasHeader       =   True
      HasHorizontalScrollbar=   False
      HasVerticalScrollbar=   True
      HeadingIndex    =   -1
      Height          =   680
      Index           =   -2147483648
      InitialValue    =   "Index	Start	Length	Finish"
      Italic          =   False
      Left            =   831
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   True
      LockTop         =   True
      RequiresSelection=   False
      RowSelectionType=   0
      Scope           =   0
      TabIndex        =   1
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   20
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   349
      _ScrollWidth    =   -1
   End
   Begin Timer DebugTimer
      Enabled         =   True
      Index           =   -2147483648
      LockedInPosition=   False
      Period          =   200
      RunMode         =   2
      Scope           =   0
      TabPanelIndex   =   0
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

#tag Events DebugTimer
	#tag Event
		Sub Action()
		  DebugListbox.RemoveAllRows
		  
		  For i As Integer = 0 To Editor.Lines.mLines.LastIndex
		    Var line As TextLine = Editor.Lines.mLines(i)
		    DebugListbox.AddRow(i.ToString, line.Start.ToString, line.Length.ToString, line.Finish.ToString)
		  Next i
		  
		End Sub
	#tag EndEvent
#tag EndEvents
