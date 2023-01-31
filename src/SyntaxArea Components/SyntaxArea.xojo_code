#tag Class
Protected Class SyntaxArea
Inherits NSScrollViewCanvas
	#tag Event
		Function DoCommand(command As String) As Boolean
		  /// Handles `command`.
		  ///
		  /// `command` is a `TextInputCanvas` string constant telling us which command we need to handle.
		  
		  // Are we still typing? Most of these commands are considered as "not typing" 
		  // for the purposes of our undo engine.
		  CurrentUndoID = System.Ticks
		  Select Case command
		  Case CmdInsertNewline, CmdInsertTab
		    mLastKeyDownTicks = System.Ticks
		  Else
		    // Act as if we haven't pressed a key for ages.
		    mLastKeyDownTicks = 0
		  End Select
		  
		  Select Case command
		  Case CmdInsertNewline
		    InsertCharacter(EndOfLine.UNIX, Nil) // Standardise the newline to UNIX.
		  End Select
		  
		  // Return True to prevent the event from propagating.
		  Return True
		  
		End Function
	#tag EndEvent

	#tag Event
		Function FontSizeAtLocation(location As Integer) As Single
		  /// Returns the current text size.
		  ///
		  /// The editor only supports a uniform text size for all tokens.
		  
		  #Pragma Unused location
		  
		  Return mTextSize
		  
		End Function
	#tag EndEvent

	#tag Event
		Sub InsertText(text As String, range As TextRange)
		  /// A single character is to be inserted.
		  
		  // Track that the user is typing.
		  mLastKeyDownTicks = System.Ticks
		  
		  // It might seem a little pointless to redirect straight to a method but
		  // later we wil need to do more here.
		  InsertCharacter(text, range)
		  
		End Sub
	#tag EndEvent

	#tag Event
		Function IsEditable() As Boolean
		  /// Returns False if the canvas is read-only or True if it's editable.
		  
		  Return Not mReadOnly
		  
		End Function
	#tag EndEvent

	#tag Event
		Function KeyDown(key As String) As Boolean
		  // Track that the user is typing.
		  mLastKeyDownTicks = System.Ticks
		  
		End Function
	#tag EndEvent

	#tag Event
		Sub MouseDrag(x As Integer, y As Integer)
		  /// The user is dragging the mouse in the editor.
		  
		  #Pragma Warning "TODO"
		  #Pragma Unused x
		  #Pragma Unused y
		  
		  // Mark that we're dragging
		  mDragging = True
		  
		End Sub
	#tag EndEvent

	#tag Event
		Sub Paint(g As Graphics, areas() As Xojo.Rect)
		  #Pragma Unused areas
		  
		  // Editor background.
		  g.DrawingColor = BackgroundColor
		  g.FillRectangle(0, 0, g.Width, g.Height)
		  
		  // Draw the caret.
		  If mCaretVisible Then
		    PaintCaret(g)
		  End If
		  
		  DrawCanvasBorders(g)
		  
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h21, Description = 5365747320746865207669736962696C697479206F66207468652063617265742E2043616C6C6564206D7920606D4361726574426C696E6B657254696D65722E416374696F6E602E
		Private Sub CaretBlinkerTimerAction(sender As Timer)
		  /// Sets the visibility of the caret. Called my `mCaretBlinkerTimer.Action`.
		  
		  #Pragma Unused sender
		  
		  // The caret is hidden if there is selected text or the editor is read-only.
		  If mSelectionLength > 0 Or Self.ReadOnly Then
		    mCaretVisible = False
		  Else
		    If BlinkCaret Then
		      mCaretVisible = Not mCaretVisible
		    Else
		      // Always keep the caret visible.
		      mCaretVisible = True
		    End If
		  End If
		  
		  // Redraw the canvas.
		  Redraw
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 4368616E6765207468652063757272656E742073656C656374696F6E20746F20626567696E206174206073656C53746172746020616E6420657874656E6420666F72206073656C4C656E6774686020636861726163746572732E
		Private Sub ChangeSelection(selStart As Integer, selLength As Integer)
		  /// Change the current selection to begin at `selStart` and extend for `selLength` characters.
		  
		  #Pragma Warning "TODO"
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  // Calling the overridden superclass constructor.
		  Super.Constructor
		  
		  mCaretBlinkerTimer = New Timer
		  AddHandler mCaretBlinkerTimer.Action, AddressOf CaretBlinkerTimerAction
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 44726177732074686520656469746F72277320626F72646572732069662072657175697265642E20417373756D657320606760206973207468652063616E7661732720677261706869637320636F6E746578742E
		Private Sub DrawCanvasBorders(g As Graphics)
		  /// Draws the editor's borders if required. Assumes `g` is the canvas' graphics context.
		  
		  g.DrawingColor = mBorderColor
		  If mHasTopBorder Then
		    g.DrawLine(0, 0, g.Width, 0)
		  End If
		  If mHasBottomBorder Then
		    g.DrawLine(0, g.Height - 1, g.Width, g.Height - 1)
		  End If
		  If mHasLeftBorder Then
		    g.DrawLine(0, 0, 0, g.Height)
		  End If
		  If mHasRightBorder Then
		    g.DrawLine(g.Width - 1, 0, g.Width - 1, g.Height)
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 496E736572747320612073696E676C652063686172616374657220606368617260206174207468652063757272656E7420636172657420706F736974696F6E2E
		Private Sub InsertCharacter(char As String, range As TextRange)
		  /// Inserts a single character `char` at the current caret position.
		  
		  #Pragma Warning "TODO"
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 5061696E74732074686520636172657420746F206067602061742074686520302D62617365642060706F73602E
		Private Sub PaintCaret(g As Graphics)
		  /// Paints the caret to `g`.
		  
		  #Pragma Warning "TODO"
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 496D6D6564696174656C7920696E76616C6964617465732074686520656E746972652063616E76617320616E6420726564726177732E
		Sub Redraw()
		  /// Immediately invalidates the entire canvas and redraws.
		  
		  NeedsFullRedraw = True
		  
		  Refresh(True)
		  
		End Sub
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0, Description = 54686520656469746F722773206261636B67726F756E6420636F6C6F75722E
		#tag Getter
			Get
			  Return mBackgroundColor
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If mBackgroundColor = value Then Return
			  
			  mBackgroundColor = value
			  
			  Redraw
			  
			End Set
		#tag EndSetter
		BackgroundColor As ColorGroup
	#tag EndComputedProperty

	#tag Property, Flags = &h0, Description = 54727565206966207468652063617265742073686F756C6420706572696F646963616C6C7920626C696E6B2E
		BlinkCaret As Boolean = True
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0, Description = 54686520656469746F72277320626F7264657220636F6C6F75722E
		#tag Getter
			Get
			  Return mBorderColor
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If mBorderColor = value Then Return
			  
			  mBorderColor = value
			  
			  Redraw
			  
			End Set
		#tag EndSetter
		BorderColor As ColorGroup
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0, Description = 546865206162736F6C75746520302D626173656420636172657420706F736974696F6E2E
		#tag Getter
			Get
			  Return mCaretPosition
			  
			End Get
		#tag EndGetter
		CaretPosition As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0, Description = 546865204944206F66207468652067726F7570206F6620756E646F20616374696F6E7320746861742061726520636F6E73696465726564206173206F6E6520226576656E742220666F722074686520707572706F736573206F6620756E646F2E
		#tag Getter
			Get
			  Return mCurrentUndoID
			  
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mCurrentUndoID = value
			  
			End Set
		#tag EndSetter
		CurrentUndoID As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0, Description = 54686520666F6E742066616D696C79206F662074686520746578742E
		#tag Getter
			Get
			  Return mFontName
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If mFontName = value Then Return
			  
			  mFontName = value
			  
			  Redraw
			  
			End Set
		#tag EndSetter
		FontName As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0, Description = 49662054727565207468656E2074686520656469746F722077696C6C2068617665206120626F74746F6D20626F726465722E
		#tag Getter
			Get
			  Return mHasBottomBorder
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mHasBottomBorder = value
			  
			  Redraw
			End Set
		#tag EndSetter
		HasBottomBorder As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0, Description = 49662054727565207468656E2074686520656469746F722077696C6C20686176652061206C65667420626F726465722E
		#tag Getter
			Get
			  Return mHasLeftBorder
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mHasLeftBorder = value
			  
			  Redraw
			  
			End Set
		#tag EndSetter
		HasLeftBorder As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0, Description = 49662054727565207468656E2074686520656469746F722077696C6C2068617665206120726967687420626F726465722E
		#tag Getter
			Get
			  Return mHasRightBorder
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mHasRightBorder = value
			  
			  Redraw
			  
			End Set
		#tag EndSetter
		HasRightBorder As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0, Description = 49662054727565207468656E2074686520656469746F722077696C6C2068617665206120746F7020626F726465722E
		#tag Getter
			Get
			  Return mHasTopBorder
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mHasTopBorder = value
			  
			  Redraw
			  
			End Set
		#tag EndSetter
		HasTopBorder As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  If mLines = Nil Then
			    mLines = New LineManager(Self)
			  End If
			  
			  Return mLines
			  
			End Get
		#tag EndGetter
		Lines As LineManager
	#tag EndComputedProperty

	#tag Property, Flags = &h21, Description = 54686520656469746F722773206261636B67726F756E6420636F6C6F75722E204261636B7320604261636B67726F756E64436F6C6F72602E
		Private mBackgroundColor As ColorGroup
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 54686520656469746F72277320626F7264657220636F6C6F75722E204261636B732060426F72646572436F6C6F72602E
		Private mBorderColor As ColorGroup
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mCaretBlinkerTimer As Timer
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 546865206F2D626173656420706F736974696F6E206F66207468652063617265742E2053657420746F20602D316020696620746865206361726574206973206E6F742076697369626C652E
		Private mCaretPosition As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 54727565206966207468652063617265742068617320626C696E6B65642076697369626C652C2046616C7365206966206E6F742E
		Private mCaretVisible As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 4261636B696E67206669656C6420666F7220746865206043757272656E74556E646F49446020636F6D70757465642070726F70657274792E
		Private mCurrentUndoID As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 5472756520696620746865206D6F7573652069732063757272656E746C79206472616767696E672E
		Private mDragging As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 54686520666F6E742066616D696C79206F662074686520746578742E
		Private mFontName As String
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 49662054727565207468656E2074686520656469746F722077696C6C2068617665206120626F74746F6D20626F726465722E204261636B732060486173426F74746F6D426F72646572602E
		Private mHasBottomBorder As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 49662054727565207468656E2074686520656469746F722077696C6C20686176652061206C65667420626F726465722E204261636B7320604861734C656674426F72646572602E
		Private mHasLeftBorder As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 49662054727565207468656E2074686520656469746F722077696C6C2068617665206120726967687420626F726465722E204261636B7320604861735269676874426F72646572602E
		Private mHasRightBorder As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 49662054727565207468656E2074686520656469746F722077696C6C2068617665206120746F7020626F726465722E204261636B732060486173546F70426F72646572602E
		Private mHasTopBorder As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 5468652074696D65206F6620746865206C61737420604B6579446F776E60206576656E742E205573656420746F2064657465726D696E65206966207468652075736572206973207374696C6C20747970696E672E
		Private mLastKeyDownTicks As Double
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 5468697320656469746F722773206C696E65206D616E616765722E
		Private mLines As LineManager
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 4261636B696E672073746F726520666F72207468652060526561644F6E6C796020636F6D70757465642070726F70657274792E
		Private mReadOnly As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 546865206E756D626572206F6620636861726163746572732063757272656E746C792073656C65637465642E
		Private mSelectionLength As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 546865206162736F6C75746520302D626173656420706F736974696F6E20696E207468652074657874206F66207468652063617265742E204261636B7320746865206053656C656374696F6E53746172746020636F6D70757465642070726F70657274792E
		Private mSelectionStart As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 5468652064656661756C7420636F6C6F757220746F2075736520666F7220746578742E204261636B73206054657874436F6C6F72602E
		Private mTextColor As ColorGroup
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 54686520746578742073697A652E
		Private mTextSize As Integer
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 5468652066756C6C2074657874206F662074686520646F63756D656E742E
		Private mTextStorage As ITextStorage
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 49662054727565207468656E2074686520656469746F722077696C6C207265647261772065766572797468696E6720696E20746865206E65787420605061696E7460206576656E742E
		NeedsFullRedraw As Boolean = True
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0, Description = 49662054727565207468656E207468652063616E76617320697320726561642D6F6E6C792028692E652E206E6F74206564697461626C65292E
		#tag Getter
			Get
			  Return mReadOnly
			  
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mReadOnly = value
			  
			End Set
		#tag EndSetter
		ReadOnly As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0, Description = 546865206E756D626572206F6620636861726163746572732063757272656E746C792073656C65637465642E
		#tag Getter
			Get
			  Return mSelectionLength
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  ChangeSelection(mSelectionStart, value)
			  
			  Redraw
			  
			End Set
		#tag EndSetter
		SelectionLength As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0, Description = 546865206162736F6C75746520302D626173656420706F736974696F6E20696E207468652074657874206F66207468652063617265742E
		#tag Getter
			Get
			  Return mSelectionStart
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  ChangeSelection(value, 0)
			  
			  Redraw
			  
			End Set
		#tag EndSetter
		SelectionStart As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0, Description = 5468652064656661756C7420636F6C6F757220746F2075736520666F7220746578742E
		#tag Getter
			Get
			  Return mTextColor
			  
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If mTextColor = value Then Return
			  
			  mTextColor = value
			  
			  Redraw
			  
			End Set
		#tag EndSetter
		TextColor As ColorGroup
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0, Description = 5472756520696620746865726520697320616E7920746578742063757272656E746C792073656C65637465642E
		#tag Getter
			Get
			  Return SelectionLength > 0
			  
			End Get
		#tag EndGetter
		TextSelected As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0, Description = 54686520746578742073697A652E
		#tag Getter
			Get
			  Return mTextSize
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If mTextSize = value Then Return
			  
			  mTextSize = value
			  
			  Redraw
			  
			End Set
		#tag EndSetter
		TextSize As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0, Description = 5468652066756C6C207465787420696E2074686520646F63756D656E742E
		#tag Getter
			Get
			  If mTextStorage = Nil Then
			    mTextStorage = New GapBuffer
			  End If
			  
			  Return mTextStorage
			  
			End Get
		#tag EndGetter
		TextStorage As ITextStorage
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0, Description = 54727565206966207468652075736572206973207374696C6C2074686F7567687420746F20626520747970696E672E
		#tag Getter
			Get
			  /// True if the user is still thought to be typing.
			  ///
			  /// We make this decision based on the time the last key was depressed
			  /// and released as well as an acceptable interval between depressions.
			  
			  If System.Ticks - mLastKeyDownTicks > TYPING_SPEED_TICKS Then
			    Return False
			  End If
			  
			  Return True
			  
			End Get
		#tag EndGetter
		Typing As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h21, Description = 546865206E756D626572206F66207469636B73207468617420726570726573656E747320746865207374617274206F662061206E657720756E646F206576656E7420626C6F636B2E
		#tag Getter
			Get
			  /// The number of ticks that represents the start of a new undo event block.
			  
			  Return mCurrentUndoID + (60 * UNDO_EVENT_BLOCK_SECONDS)
			End Get
		#tag EndGetter
		Private UndoIDThreshold As Integer
	#tag EndComputedProperty


	#tag Constant, Name = TYPING_SPEED_TICKS, Type = Double, Dynamic = False, Default = \"20", Scope = Private, Description = 546865206E756D626572206F66207469636B73206265747765656E206B65797374726F6B657320746F207374696C6C20626520636F6E73696465726564206173206163746976656C7920747970696E672E
	#tag EndConstant

	#tag Constant, Name = UNDO_EVENT_BLOCK_SECONDS, Type = Double, Dynamic = False, Default = \"2", Scope = Private, Description = 546865206E756D626572206F66207365636F6E64732077697468696E20776869636820756E646F61626C6520616374696F6E732077696C6C2062652067726F7570656420746F67657468657220617320612073696E676C6520756E646F61626C6520616374696F6E2E
	#tag EndConstant


	#tag Enum, Name = CaretTypes, Type = Integer, Flags = &h0, Description = 54686520646966666572656E74207479706573206F66206361726574207374796C652E
		VerticalBar
	#tag EndEnum


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="Integer"
			EditorType="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue=""
			Type="Integer"
			EditorType="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue=""
			Type="Integer"
			EditorType="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Width"
			Visible=true
			Group="Position"
			InitialValue="100"
			Type="Integer"
			EditorType="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Height"
			Visible=true
			Group="Position"
			InitialValue="100"
			Type="Integer"
			EditorType="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockLeft"
			Visible=true
			Group="Position"
			InitialValue=""
			Type="Boolean"
			EditorType="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockTop"
			Visible=true
			Group="Position"
			InitialValue=""
			Type="Boolean"
			EditorType="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockRight"
			Visible=true
			Group="Position"
			InitialValue=""
			Type="Boolean"
			EditorType="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockBottom"
			Visible=true
			Group="Position"
			InitialValue=""
			Type="Boolean"
			EditorType="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabPanelIndex"
			Visible=false
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabIndex"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabStop"
			Visible=true
			Group="Position"
			InitialValue="True"
			Type="Boolean"
			EditorType="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="InitialParent"
			Visible=false
			Group="Position"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Visible"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			EditorType="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Tooltip"
			Visible=false
			Group="Appearance"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="AutoDeactivate"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			EditorType="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Enabled"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			EditorType="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="BackgroundColor"
			Visible=true
			Group="Appearance"
			InitialValue=""
			Type="ColorGroup"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="BorderColor"
			Visible=true
			Group="Appearance"
			InitialValue=""
			Type="ColorGroup"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="HasBottomBorder"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="HasLeftBorder"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="HasRightBorder"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="HasTopBorder"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="FontName"
			Visible=true
			Group="Appearance"
			InitialValue="System"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TextColor"
			Visible=true
			Group="Appearance"
			InitialValue=""
			Type="ColorGroup"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="TextSize"
			Visible=true
			Group="Appearance"
			InitialValue="12"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ReadOnly"
			Visible=true
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="NeedsFullRedraw"
			Visible=false
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="CurrentUndoID"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="TextSelected"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Typing"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="SelectionStart"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="SelectionLength"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="CaretPosition"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="BlinkCaret"
			Visible=false
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
