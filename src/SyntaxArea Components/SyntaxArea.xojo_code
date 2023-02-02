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
		    
		    // =========================================
		    // MOVING THE CARET
		    // =========================================
		  Case CmdMoveLeft, CmdMoveBackward
		    ChangeSelection(mSelectionStart - 1, 0, True)
		    
		  Case CmdMoveRight, CmdMoveForward
		    MoveCaretRight
		  End Select
		  
		  // Return True to prevent the event from propagating.
		  Return True
		  
		End Function
	#tag EndEvent

	#tag Event
		Function FontSizeAtLocation(location As Integer) As Single
		  /// Returns the current font size.
		  ///
		  /// The editor only supports a uniform text size for all tokens.
		  
		  #Pragma Unused location
		  
		  Return mFontSize
		  
		End Function
	#tag EndEvent

	#tag Event
		Sub InsertText(text As String, range As TextRange)
		  /// A single character is to be inserted.
		  
		  // Track that the user is typing.
		  mLastKeyDownTicks = System.Ticks
		  
		  // It might seem a little pointless to redirect straight to a method but
		  // later we will need to do more here.
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

	#tag Event , Description = 546865207363726F6C6C207669657720626F756E647320686173206368616E6765642E
		Sub NSScrollViewBoundsChanged(bounds As CGRect)
		  /// The user has scrolled with the mouse / trackpad on macOS.
		  ///
		  /// bounds.Origin.X is the horizontal scroll offset (same as NSScrollViewCanvas.ScrollX_)
		  /// bounds.Origin.Y is the vertical scroll offset (same as NSScrollViewCanvas.ScrollY_)
		  /// bounds.RectSize contains the width and height of the document window.
		  ///
		  /// Note: This replaces the `MouseWheel` event on macOS.
		  
		  #Pragma Unused bounds
		  
		  // =================================
		  // VERTICAL SCROLLING
		  // =================================
		  If ScrollY_ > 0 Then
		    // In order to see all of the lowest most line to be visible, we need to increase `ScrollY_` a bit.
		    Var y As Integer = ScrollY_ + (mLineHeight * 2)
		    mFirstVisibleLine = Floor(y / mLineHeight)
		    mFirstVisibleLine = Clamp(mFirstVisibleLine, 0, Lines.LineCount - 1)
		    NeedsFullRedraw = True
		  Else
		    mFirstVisibleLine = 0
		    NeedsFullRedraw = True
		  End If
		  mScrollPosY = ScrollY_
		  
		  // =================================
		  // HORIZONTAL SCROLLING
		  // =================================
		  If ScrollX_ >= 0 Then
		    ScrollPosX = ScrollX_
		  End If
		  
		  Refresh
		End Sub
	#tag EndEvent

	#tag Event
		Sub Paint(g As Graphics, areas() As Xojo.Rect)
		  #Pragma Unused areas
		  
		  // Cache this graphics context.
		  mPaintGraphics = g
		  
		  // Update the width of the document.
		  #Pragma Warning "OPTIMISE: This doesn't need calling on each refresh"
		  ComputeDocumentWidth(g)
		  
		  // On macOS we need to update the document size to get fancy scrollbars.
		  #If TargetMacOS
		    SetDocumentSize(mDocumentWidth, Lines.LineCount * mLineHeight)
		  #EndIf
		  
		  // Editor background.
		  g.DrawingColor = BackgroundColor
		  g.FillRectangle(0, 0, g.Width, g.Height)
		  
		  // Compute and cache the width of the line numbers in the gutter and
		  // the width of an individual line number character.
		  #Pragma Warning "OPTIMISE: This doesn't need calling on each refresh"
		  ComputeLineNumberWidth(g)
		  
		  // Compute and then cache gutter width.
		  mGutterWidth = GutterWidth(mLineNumWidth)
		  
		  // Compute and then cache the current line height.
		  #Pragma Warning "OPTIMISE: This only needs updating when the font name or size changes"
		  mLineHeight = LineHeight(g)
		  
		  // Compute and cache the last visible line index.
		  mLastVisibleLineIndex = LastVisibleLineIndex
		  
		  // Ensure the correct font name and size are set.
		  g.FontName = FontName
		  g.FontSize = FontSize
		  
		  // Iterate over the visible lines and draw every line.
		  Var lineStartY As Double = 0
		  For i As Integer = mFirstVisibleLine To mLastVisibleLineIndex
		    Var line As TextLine = Lines.LineAtIndex(i)
		    line.Draw(g, -mScrollPosX + mGutterWidth + LINE_CONTENTS_LEFT_PADDING, lineStartY, mLineHeight, mGutterWidth)
		    lineStartY = lineStartY + mLineHeight
		  Next i
		  
		  // Draw the caret.
		  If mCaretVisible Then PaintCaret(g)
		  
		  // Draw the optional editor borders.
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

	#tag Method, Flags = &h21, Description = 4368616E6765207468652063757272656E742073656C656374696F6E20746F20626567696E206174206073656C53746172746020616E6420657874656E6420666F72206073656C4C656E6774686020636861726163746572732E20446F6573202A2A6E6F742A2A20696D6D6564696174656C79207265647261772062757420646F657320666C616720666F7220726564726177696E672E
		Private Sub ChangeSelection(selStart As Integer, selLength As Integer, redrawImmediately As Boolean)
		  /// Change the current selection to begin at `selStart` and extend for `selLength` characters.
		  /// Does **not** immediately redraw but does flag for redrawing.
		  
		  mSelectionStart = Clamp(selStart, 0, TextStorage.Length)
		  mSelectionLength = Clamp(selLength, 0, TextStorage.Length - mSelectionStart)
		  
		  mCurrentLine = Lines.LineAtOffset(mSelectionStart)
		  
		  If redrawImmediately Then
		    Redraw
		  Else
		    NeedsFullRedraw = True
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52657475726E7320746865207061737365642076616C756520636C616D706564206265747765656E20606D696E696D756D6020616E6420606D6178696D756D602E
		Private Function Clamp(value As Double, minimum As Double, maximum As Double) As Double
		  /// Returns the passed value clamped between `minimum` and `maximum`.
		  
		  If value > maximum Then Return maximum
		  If value < minimum Then Return minimum
		  Return value
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 436F6D707574657320746865207769647468206F662074686520646F63756D656E74206261736564206F6E2074686520656469746F7227732047726170686963732060676020616E64207365747320606D446F63756D656E7457696474686020746F20746861742076616C75652E205768656E2060576F7264577261706020697320547275652074686973206973207468652063616E7661732077696474682C206F746865727769736520697427732074686520776964746820726571756972656420746F20646973706C617920746865206C6F6E67657374206C696E6520776974686F7574207363726F6C6C696E672E2057696C6C20616C77617973206265206174206C656173742061732077696465206173207468652063616E766173272063757272656E742077696474682E
		Private Sub ComputeDocumentWidth(g As Graphics)
		  /// Computes the width of the document based on the editor's Graphics `g` and sets `mDocumentWidth` to that value.
		  /// When `WordWrap` is True this is the canvas width, otherwise it's the width required to display
		  /// the longest line without scrolling.
		  /// Will always be at least as wide as the canvas' current width.
		  
		  // If word wrapping is enabled then the document width is just the width of the editor's canvas.
		  If WordWrap Then
		    mDocumentWidth = g.Width
		    Return
		  End If
		  
		  // Get the longest line.
		  Var longestLine As TextLine = Lines.LongestLine
		  
		  // Determine the width to the end of the longest line.
		  Var w As Double = longestLine.WidthToColumn(longestLine.Length, g)
		  
		  // Add in the gutter width and any padding.
		  w = w + GutterWidth(mLineNumWidth) + RIGHT_SCROLL_PADDING
		  
		  // Cache the width.
		  mDocumentWidth = Max(w, g.Width)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 436F6D7075746520746865207769647468206F662074686520626F756E64696E6720626F7820666F7220746865206C696E65206E756D62657220737472696E6720616E642073746F72657320697420696E20606D4C696E654E756D5769647468602E20416C736F207570646174657320606D4C696E654E756D436861725769647468602E206067602069732074686520677261706869637320636F6E746578742077652772652064726177696E6720746F2E
		Private Sub ComputeLineNumberWidth(g As Graphics)
		  /// Compute the width of the bounding box for the line number string and stores it in `mLineNumWidth`.
		  /// Also updates `mLineNumCharWidth`.
		  /// `g` is the graphics context we're drawing to.
		  
		  // Cache the width of a line number character. Assumes we're using a monospace font.
		  g.FontName = FontName
		  g.FontSize = LineNumberFontSize
		  mLineNumCharWidth = g.TextWidth("0")
		  
		  If DisplayLineNumbers Then
		    // Make sure we compute the width of a minimum of two characters, 
		    // otherwise the gutter resizes when you get to 9 lines.
		    // +10 is a fudge to make the TextShape drawn by the line align better.
		    mLineNumWidth = _
		    (Max(Lines.LineCount.ToString.Length, 2) * mLineNumCharWidth) + 10
		  Else
		    mLineNumWidth = MIN_LINE_NUMBER_WIDTH
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  // Calling the overridden superclass constructor.
		  Super.Constructor
		  
		  mCaretBlinkerTimer = New Timer
		  mCaretBlinkerTimer.RunMode = Timer.RunModes.Multiple
		  mCaretBlinkerTimer.Period = CaretBlinkPeriod
		  AddHandler mCaretBlinkerTimer.Action, AddressOf CaretBlinkerTimerAction
		  
		  mCurrentLine = Lines.LineAtIndex(0)
		  
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

	#tag Method, Flags = &h21, Description = 436F6D707574657320616E642072657475726E732074686520776964746820696E20706978656C73206F662074686520677574746572207573696E67207468652070617373656420606C696E654E756D6265725769647468602E
		Private Function GutterWidth(lineNumberWidth As Double) As Double
		  /// Computes and returns the width in pixels of the gutter using the passed `lineNumberWidth`.
		  ///
		  /// Gutter structure:
		  ///
		  /// ```no-highlight
		  /// ________________
		  /// |           |  |
		  /// |           |  |
		  /// ----------------
		  ///   ↑          ↑  
		  ///  LNW         BG
		  /// ```
		  ///
		  // _LNW (Line number width)_: The width of the rectangle containing the line number.
		  ///
		  /// _BG (Block gutter min width)_: The minimal width of the gutter containing 
		  ///                                the block indicators. This is variable but must be a minimal width.
		  
		  Return lineNumberWidth + BLOCK_GUTTER_MIN_WIDTH
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 496E73657274732061202A2A73696E676C652A2A2063686172616374657220606368617260206174207468652063757272656E7420636172657420706F736974696F6E2E20417373756D65732074686174206966206063686172602069732061206E65776C696E65207468656E20697473206265656E207374616E646172646973656420746F20554E49582E
		Private Sub InsertCharacter(char As String, range As TextRange)
		  /// Inserts a **single** character `char` at the current caret position.
		  /// Assumes that if `char` is a newline then its been standardised to UNIX.
		  
		  If Not Typing Or System.Ticks > UndoIDThreshold Then
		    CurrentUndoID = System.Ticks
		  End If
		  
		  If TargetMacOS And range <> Nil And Not TextSelected Then
		    // The user has pressed and held down a character and has selected a special character from the 
		    // popup to insert. Replace the character *before* the caret with `char`.
		    #Pragma Warning "TODO"
		  Else
		    If TextSelected Then
		      // Replace the selection and update the caret position.
		      #Pragma Warning "TODO"
		    Else
		      // Insert the character at the current caret position.
		      TextStorage.Insert(mSelectionStart, char)
		      Lines.Insert(mSelectionStart, char)
		      // Advance the caret.
		      SelectionStart = SelectionStart + 1
		    End If
		  End If
		  
		  Redraw
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 54686520302D6261736564206C696E65206E756D626572206F6620746865206C6173742076697369626C65206C696E652E
		Function LastVisibleLineIndex() As Integer
		  /// The 0-based line number of the last visible line. 
		  ///
		  /// The line may be only partially visible.
		  /// Relies on the cached value of the current line height.
		  
		  Return Min(mFirstVisibleLine + MaxVisibleLines(mLineHeight), Lines.LineCount - 1)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52657475726E7320746865206865696768742028696E20706978656C7329206F662061206C696E6520676976656E2074686520677261706869637320636F6E74657874206067602E
		Private Function LineHeight(g As Graphics) As Double
		  /// Returns the height (in pixels) of a line given the graphics context `g`.
		  
		  Const TEXT_DESCENT_FUDGE = 1
		  
		  // We compute line height based on the source code font size and family.
		  // Since we can't guarantee where this method is called from, we'll
		  // cache the current value of these properties in `g`, temporarily set the
		  // graphics font properties to the source code font family and size and then
		  // restore the original properties.
		  
		  Var tmpFontSize As Integer = g.FontSize
		  Var tmpFontName As String = g.FontName
		  
		  // Set.
		  g.FontSize = FontSize
		  g.FontName = FontName
		  
		  // Compute.
		  Var lh As Double = g.TextHeight + (2 * VerticalLinePadding) + TEXT_DESCENT_FUDGE
		  
		  // Restore.
		  g.FontSize = tmpFontSize
		  g.FontName = tmpFontName
		  
		  Return lh
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 546865206D6178696D756D206E756D626572206F66206C696E65732074686174206172652076697369626C6520696E207468652063616E7661732E
		Private Function MaxVisibleLines(lineHeight As Double) As Integer
		  /// The maximum number of lines that are visible in the canvas. 
		  ///
		  /// This will never be more than the maximum number of lines in existence.
		  
		  mMaxVisibleLines = Min(Me.Height / lineHeight, Lines.LineCount)
		  
		  Return mMaxVisibleLines
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 4D6F76657320746865206361726574206F6E6520706F736974696F6E20746F207468652072696768742E
		Private Sub MoveCaretRight()
		  /// Moves the caret one position to the right.
		  
		  If TextSelected Then
		    // Move the caret to the selection's end location and clear the selection.
		    ChangeSelection(SelectionEnd, 0, True)
		  Else
		    ChangeSelection(mSelectionStart + 1, 0, True)
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 5061696E74732074686520636172657420746F206067602061742074686520302D62617365642060706F73602E
		Private Sub PaintCaret(g As Graphics)
		  /// Paints the caret to `g`.
		  
		  #Pragma Warning "TODO"
		  
		  // Don't draw the caret if we're dragging.
		  If mDragging Then Return
		  
		  // Compute the x, y coordinates at the current caret position.
		  Var x, y As Double = 0
		  XYAtOffset(mSelectionStart, x, y)
		  
		  // Adjust y to account for the vertical line padding.
		  y = y + VerticalLinePadding
		  
		  // Draw it.
		  g.DrawingColor = CaretColor
		  Select Case CaretType
		  Case CaretTypes.VerticalBar
		    g.DrawLine(x, y, x, y + g.TextHeight)
		  End Select
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 496D6D6564696174656C7920696E76616C6964617465732074686520656E746972652063616E76617320616E6420726564726177732E
		Sub Redraw()
		  /// Immediately invalidates the entire canvas and redraws.
		  
		  NeedsFullRedraw = True
		  
		  Refresh(True)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 436F6D70757465732028427952656629207468652063616E76617320782C207920636F6F7264696E61746573206174207468652063757272656E7420302D6261736564206F66667365742E
		Private Sub XYAtOffset(offset As Integer, ByRef x As Double, ByRef y As Double)
		  /// Computes (ByRef) the canvas x, y coordinates at the current 0-based offset.
		  ///
		  /// Assumes that `mPaintGraphics` has the current editor font name and size set.
		  
		  Var line As TextLine = Lines.LineAtOffset(offset)
		  
		  Var g As Graphics = mPaintGraphics
		  If g = Nil Then
		    Var p As Picture
		    If Self.Window <> Nil Then
		      p = Self.Window.BitmapForCaching(1, 1)
		    Else
		      p = New Picture(1, 1)
		    End If
		    g = p.Graphics
		  End If
		  
		  // X
		  Var tempX As Integer = mGutterWidth + LINE_CONTENTS_LEFT_PADDING + _
		  line.IndentWidth(g.TextWidth("_"))
		  x = tempX + line.WidthToOffset(offset, g)
		  
		  // Y
		  y = (line.Index - mFirstVisibleLine) * mLineHeight
		  
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

	#tag ComputedProperty, Flags = &h0, Description = 54686520696E74657276616C2028696E206D7329206265747765656E20636172657420626C696E6B732E
		#tag Getter
			Get
			  If mCaretBlinkerTimer <> Nil Then
			    Return mCaretBlinkerTimer.Period
			  Else
			    Return 0
			  End If
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If mCaretBlinkerTimer <> Nil Then
			    mCaretBlinkerTimer.Period = Max(value, 1)
			  End If
			  
			End Set
		#tag EndSetter
		CaretBlinkPeriod As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0, Description = 54686520636172657420636F6C6F75722E
		#tag Getter
			Get
			  Return mCaretColor
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mCaretColor = value
			  Me.Redraw
			End Set
		#tag EndSetter
		CaretColor As ColorGroup
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0, Description = 546865206162736F6C75746520302D626173656420636172657420706F736974696F6E2E
		#tag Getter
			Get
			  Return mCaretPosition
			  
			End Get
		#tag EndGetter
		CaretPosition As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0, Description = 5468652074797065206F66206361726574207468652063616E7661732073686F756C64207573652E
		#tag Getter
			Get
			  Return mCaretType
			  
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mCaretType = value
			  Me.Refresh
			  
			End Set
		#tag EndSetter
		CaretType As CaretTypes
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0, Description = 546865206E756D626572206F6620636F6C756D6E732065616368206C6576656C206F6620696E64656E746174696F6E206973206571756976616C656E7420746F2E
		#tag Getter
			Get
			  Return mColumnsPerIndent
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  // Clamp above 0.
			  mColumnsPerIndent = Max(0, value)
			  
			End Set
		#tag EndSetter
		ColumnsPerIndent As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0, Description = 546865206C696E652074686174207468652063617265742069732063757272656E746C79206F6E2E
		#tag Getter
			Get
			  Return mCurrentLine
			  
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mCurrentLine = value
			  
			End Set
		#tag EndSetter
		CurrentLine As TextLine
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0, Description = 54686520636F6C6F757220746F2075736520746F20686967686C69676874207468652063757272656E74206C696E652028696620656E61626C6564292E
		#tag Getter
			Get
			  Return mCurrentLineHighlightColor
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mCurrentLineHighlightColor = value
			  NeedsFullRedraw = True
			  
			End Set
		#tag EndSetter
		CurrentLineHighlightColor As ColorGroup
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

	#tag ComputedProperty, Flags = &h0, Description = 54727565206966206C696E65206E756D626572732073686F756C6420626520646973706C617965642E
		#tag Getter
			Get
			  Return mDisplayLineNumbers
			  
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mDisplayLineNumbers = value
			  NeedsFullRedraw = True
			  Refresh
			  
			End Set
		#tag EndSetter
		DisplayLineNumbers As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0, Description = 54686520696E646578206F6620746865206C696E652076697369626C652061742074686520746F70206F66207468652063616E7661732E20416C746572656420627920766572746963616C207363726F6C6C696E672E20302D62617365642E
		#tag Getter
			Get
			  Return mFirstVisibleLine
			  
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mFirstVisibleLine = Clamp(value, 0, Lines.LineCount - 1)
			  NeedsFullRedraw = True
			  
			End Set
		#tag EndSetter
		FirstVisibleLine As Integer
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

	#tag ComputedProperty, Flags = &h0, Description = 54686520666F6E742073697A652E
		#tag Getter
			Get
			  Return mFontSize
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If mFontSize = value Then Return
			  
			  mFontSize = value
			  
			  Redraw
			  
			End Set
		#tag EndSetter
		FontSize As Integer
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

	#tag ComputedProperty, Flags = &h0, Description = 49662054727565207468656E20746865206C696E65207468652063617265742069732063757272656E746C79206F6E2077696C6C20626520686967686C6967687465642E
		#tag Getter
			Get
			  Return mHighlightCurrentLine
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mHighlightCurrentLine = value
			  NeedsFullRedraw = True
			  
			End Set
		#tag EndSetter
		HighlightCurrentLine As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0, Description = 546865206C696E65206E756D62657220666F6E742073697A652E204D757374206265206C657373207468616E2060466F6E7453697A65602E
		#tag Getter
			Get
			  Return mLineNumberFontSize
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mLineNumberFontSize = value
			  NeedsFullRedraw = True
			  Refresh
			  
			End Set
		#tag EndSetter
		LineNumberFontSize As Integer
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

	#tag Property, Flags = &h0, Description = 49662054727565207468656E2074686520746865726520686173206265656E2061206368616E676520696E20746865206C656E677468206F6620746865206C6F6E67657374206C696E652E20546869732069732073657420696E7465726E616C6C792062792074686520656469746F722773206C696E65206D616E616765722E
		LongestLineChanged As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 54686520656469746F722773206261636B67726F756E6420636F6C6F75722E204261636B7320604261636B67726F756E64436F6C6F72602E
		Private mBackgroundColor As ColorGroup
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 54686520656469746F72277320626F7264657220636F6C6F75722E204261636B732060426F72646572436F6C6F72602E
		Private mBorderColor As ColorGroup
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mCaretBlinkerTimer As Timer
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 54686520636F6C6F7572206F66207468652063617265742E204261636B732074686520604361726574436F6C6F726020636F6D70757465642070726F70657274792E
		Private mCaretColor As ColorGroup
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 546865206F2D626173656420706F736974696F6E206F66207468652063617265742E2053657420746F20602D316020696620746865206361726574206973206E6F742076697369626C652E
		Private mCaretPosition As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 546865206361726574207374796C652E204261636B696E67206669656C6420666F722074686520604361726574547970656020636F6D70757465642070726F70657274792E
		Private mCaretType As CaretTypes
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 54727565206966207468652063617265742068617320626C696E6B65642076697369626C652C2046616C7365206966206E6F742E
		Private mCaretVisible As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 546865206E756D626572206F6620636F6C756D6E732065616368206C6576656C206F6620696E64656E746174696F6E206973206571756976616C656E7420746F2E204261636B73207468652060436F6C756D6E73506572496E64656E746020636F6D70757465642070726F70657274792E
		Private mColumnsPerIndent As Integer
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 546865206C696E652074686174207468652063617265742069732063757272656E746C79206F6E2E204261636B696E67206669656C6420666F7220746865206043757272656E744C696E656020636F6D70757465642070726F70657274792E
		Private mCurrentLine As TextLine
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 54686520636F6C6F757220746F2075736520746F20686967686C69676874207468652063757272656E74206C696E652028696620656E61626C6564292E204261636B732074686520636F6D7075746564206043757272656E744C696E65486967686C69676874436F6C6F72602070726F70657274792E
		Private mCurrentLineHighlightColor As ColorGroup
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 4261636B696E67206669656C6420666F7220746865206043757272656E74556E646F49446020636F6D70757465642070726F70657274792E
		Private mCurrentUndoID As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 4261636B696E67206669656C6420666F72207468652060446973706C61794C696E654E756D626572736020636F6D70757465642070726F70657274792E
		Private mDisplayLineNumbers As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 436163686564207769647468206F66207468652077686F6C6520646F63756D656E742E205768656E20576F72645772617020697320656E61626C65642074686973206973207468652063616E7661732077696474682C206F746865727769736520697427732074686520776964746820726571756972656420746F20646973706C617920746865206C6F6E67657374206C696E6520776974686F7574207363726F6C6C696E672E
		Private mDocumentWidth As Double
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 5472756520696620746865206D6F7573652069732063757272656E746C79206472616767696E672E
		Private mDragging As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 4261636B696E67206669656C6420666F72207468652060466972737456697369626C654C696E656020636F6D70757465642070726F70657274792E20302D62617365642E
		Private mFirstVisibleLine As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 54686520666F6E742066616D696C79206F662074686520746578742E
		Private mFontName As String
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 54686520666F6E742073697A652E
		Private mFontSize As Integer
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 416E20696E7465726E616C206361636865206F66207468652067757474657220776964746820696E20706978656C732E20436F6D707574656420696E2074686520605061696E7460206576656E742E
		Private mGutterWidth As Double
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

	#tag Property, Flags = &h21, Description = 49662054727565207468656E20746865206C696E65207468652063617265742069732063757272656E746C79206F6E2077696C6C20626520686967686C6967687465642E204261636B696E67206669656C6420666F72207468652060486967686C6967687443757272656E744C696E656020636F6D70757465642070726F70657274792E
		Private mHighlightCurrentLine As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 5468652074696D65206F6620746865206C61737420604B6579446F776E60206576656E742E205573656420746F2064657465726D696E65206966207468652075736572206973207374696C6C20747970696E672E
		Private mLastKeyDownTicks As Double
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 43616368656420302D626173656420696E646578206F6620746865206C6173742076697369626C65206C696E652E2043616368656420696E2074686520605061696E7460206576656E742E
		Private mLastVisibleLineIndex As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 496E7465726E616C206361636865206F66207468652063757272656E74206C696E65206865696768742E
		Private mLineHeight As Double
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 4261636B696E67206669656C6420666F722074686520636F6D707574656420604C696E654E756D626572466F6E7453697A65602E
		Private mLineNumberFontSize As Integer
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 4361636865642076616C7565206F6620746865207769647468206F662061206C696E65206E756D626572206368617261637465722E20436F6D707574656420696E2060436F6D707574654C696E654E756D62657257696474682829602E
		Private mLineNumCharWidth As Double
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 496E7465726E616C206361636865206F6620746865206C696E65206E756D62657220776964746820696E20746865206775747465722E
		Private mLineNumWidth As Double
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 5468697320656469746F722773206C696E65206D616E616765722E
		Private mLines As LineManager
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 41206361636865206F6620746865206C6173742076616C75652072657475726E65642062792074686520604D617856697369626C654C696E657360206D6574686F642E204974277320746865206D6178696D756D206E756D626572206F66206C696E65732076697369626C6520696E207468652063616E7661732E2049742077696C6C206E65766572206265206D6F7265207468616E20746865206E756D626572206F66206C696E657320696E206578697374656E63652E
		Private mMaxVisibleLines As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 496E7465726E616C206361636865206F662074686520477261706869637320636F6E746578742066726F6D20746865206C61737420605061696E7460206576656E742E
		Private mPaintGraphics As Graphics
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 4261636B696E672073746F726520666F72207468652060526561644F6E6C796020636F6D70757465642070726F70657274792E
		Private mReadOnly As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 54686520686F72697A6F6E74616C207363726F6C6C206F66667365742E203020697320626173656C696E652E20506F73697469766520696E64696361746573207363726F6C6C696E6720746F207468652072696768742E204261636B696E67206669656C6420666F722074686520605363726F6C6C506F73586020636F6D70757465642070726F70657274792E
		Private mScrollPosX As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 546865205920636F6F7264696E617465207468652063616E766173206C617374207363726F6C6C656420746F2E
		Private mScrollPosY As Integer
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

	#tag Property, Flags = &h21, Description = 5468652066756C6C2074657874206F662074686520646F63756D656E742E
		Private mTextStorage As ITextStorage
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 4261636B696E67206669656C6420666F72207468652060566572746963616C4C696E6550616464696E676020636F6D70757465642070726F70657274792E
		Private mVerticalLinePadding As Integer
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 49662054727565207468656E2074686520656469746F722077696C6C2077726170206C696E657320746F20666974207468652063757272656E7420656469746F722077696474682E204261636B732074686520636F6D70757465642060576F726457726170602070726F70657274792E
		Private mWordWrap As Boolean = False
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

	#tag ComputedProperty, Flags = &h0, Description = 54686520686F72697A6F6E74616C207363726F6C6C206F66667365742E203020697320626173656C696E652E20506F73697469766520696E64696361746573207363726F6C6C696E6720746F207468652072696768742E
		#tag Getter
			Get
			  Return mScrollPosX
			  
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  /// Update how much the canvas is horizontally scrolled.
			  
			  // Compute the maximum allowed X scroll position.
			  Var maxScrollPosX As Integer = Max(mDocumentWidth - Self.Width, 0)
			  
			  // Set the value of ScrollPosX, not exceeding the maximum value.
			  mScrollPosX = Clamp(value, 0, maxScrollPosX)
			  
			End Set
		#tag EndSetter
		ScrollPosX As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0, Description = 546865206162736F6C75746520302D626173656420706F736974696F6E206F662074686520656E64206F66207468652073656C656374656420746578742E204966207468657265206973206E6F2073656C656374656420746578742074686973206973207468652073616D65206173206053656C656374696F6E5374617274602E
		#tag Getter
			Get
			  Return mSelectionStart + mSelectionLength
			  
			End Get
		#tag EndGetter
		SelectionEnd As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0, Description = 546865206E756D626572206F6620636861726163746572732063757272656E746C792073656C65637465642E
		#tag Getter
			Get
			  Return mSelectionLength
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  ChangeSelection(mSelectionStart, value, True)
			  
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
			  ChangeSelection(value, 0, True)
			  
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

	#tag ComputedProperty, Flags = &h0, Description = 546865206E756D626572206F6620706978656C7320746F207061642061206C696E65206F6E2069747320746F7020616E6420626F74746F6D2065646765732E
		#tag Getter
			Get
			  Return mVerticalLinePadding
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mVerticalLinePadding = value
			  NeedsFullRedraw = True
			  Refresh
			  
			End Set
		#tag EndSetter
		VerticalLinePadding As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0, Description = 49662054727565207468656E2074686520656469746F722077696C6C2077726170206C696E657320746F20666974207468652063757272656E7420656469746F722077696474682E
		#tag Getter
			Get
			  Return mWordWrap
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  #Pragma Warning "TODO: Ensure lines are updated"
			  
			  mWordWrap = value
			  
			  Redraw
			  
			End Set
		#tag EndSetter
		WordWrap As Boolean
	#tag EndComputedProperty


	#tag Constant, Name = BLOCK_GUTTER_MIN_WIDTH, Type = Double, Dynamic = False, Default = \"18", Scope = Public, Description = 546865206D696E696D616C207769647468206F66207468652067757474657220636F6E7461696E696E672074686520626C6F636B20696E64696361746F72732E
	#tag EndConstant

	#tag Constant, Name = LINE_CONTENTS_LEFT_PADDING, Type = Double, Dynamic = False, Default = \"5", Scope = Public, Description = 5468652070616464696E67206265747765656E2074686520726967687420677574746572206564676520616E6420746865206C696E6520636F6E74656E74732E
	#tag EndConstant

	#tag Constant, Name = MIN_LINE_NUMBER_WIDTH, Type = Double, Dynamic = False, Default = \"20", Scope = Private, Description = 4966206C696E65206E756D6265727320617265202A6E6F742A20647261776E2C207468697320697320746865206D696E696D756D207769647468206F6620746865206C696E65206E756D6265722073656374696F6E206F6620746865206775747465722E
	#tag EndConstant

	#tag Constant, Name = RIGHT_SCROLL_PADDING, Type = Double, Dynamic = False, Default = \"40", Scope = Private, Description = 467564676520666163746F7220666F722070616464696E6720746865207269676874206F66206C696E6573207768656E20686F72697A6F6E74616C207363726F6C6C696E672E
	#tag EndConstant

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
			Name="FontSize"
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
			Visible=true
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="WordWrap"
			Visible=true
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="FirstVisibleLine"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ScrollPosX"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LineNumberFontSize"
			Visible=true
			Group="Behavior"
			InitialValue="12"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="DisplayLineNumbers"
			Visible=true
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="VerticalLinePadding"
			Visible=true
			Group="Behavior"
			InitialValue="2"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LongestLineChanged"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ColumnsPerIndent"
			Visible=true
			Group="Behavior"
			InitialValue="2"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="HighlightCurrentLine"
			Visible=true
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="CurrentLineHighlightColor"
			Visible=true
			Group="Behavior"
			InitialValue=""
			Type="ColorGroup"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="CaretType"
			Visible=true
			Group="Behavior"
			InitialValue=""
			Type="CaretTypes"
			EditorType="Enum"
			#tag EnumValues
				"0 - VerticalBar"
			#tag EndEnumValues
		#tag EndViewProperty
		#tag ViewProperty
			Name="CaretColor"
			Visible=true
			Group="Behavior"
			InitialValue=""
			Type="ColorGroup"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="CaretBlinkPeriod"
			Visible=true
			Group="Behavior"
			InitialValue="500"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
