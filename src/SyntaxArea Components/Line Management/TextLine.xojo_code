#tag Class
Protected Class TextLine
	#tag Method, Flags = &h0, Description = 436F6E737472756374732061206E65772074657874206C696E6520626567696E6E696E67206174206F66667365742060737461727460206F6620606C656E6774686020636861726163746572732E
		Sub Constructor(start As Integer, length As Integer, owner As LineManager, indexInOwner As Integer)
		  /// Constructs a new text line beginning at offset `start` of `length` characters.
		  
		  Self.Start = start
		  Self.Length = length
		  mOwner = New WeakRef(owner)
		  Self.Index = indexInOwner
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 44726177732074686973206C696E6520746F206067602E20417373756D65732060676020616C7265616479206861732074686520636F727265637420666F6E74206E616D6520616E642073697A65207365742E
		Sub Draw(g As Graphics, topLeftX As Double, topLeftY As Double, lineH As Double, gutterWidth As Double)
		  /// Draws this line to `g`.
		  /// Assumes `g` already has the correct font name and size set.
		  ///
		  /// - `topLeftX` is the X coord of the top left corner of the line. Already adjusted for scrolling.
		  /// - `topLeftY` is the Y coord of the top left corner of the line.
		  /// - `lineH` is the height of the line.
		  /// - `gutterWidth` is the width of the gutter.
		  ///
		  /// A line includes the gutter, any spacing for indentation and the line 
		  /// contents itself.
		  
		  #Pragma Warning "TODO"
		  
		  // Grab a reference to this line's canvas.
		  Var editor As SyntaxArea = Owner.Editor
		  
		  // Cache the top left Y coordinate.
		  mTopLeftY = topLeftY
		  
		  // Compute the x, y coords of the start of the text.
		  mTextStartX = topLeftX + WidthToColumn(0, g)
		  mTextStartY = topLeftY + (g.FontAscent + (lineH - g.TextHeight)/2)
		  
		  // ===================================
		  // BACKGROUND
		  // ===================================
		  If editor.HighlightCurrentLine And Self.Index = editor.CurrentLine.Index Then
		    // Fill this line's background with the appropriate colour.
		    g.DrawingColor = editor.CurrentLineHighlightColor
		  Else
		    // This line's background will be filled with the editor's background colour.
		    g.DrawingColor = editor.BackgroundColor
		  End If
		  g.FillRectangle(topLeftX, topLeftY, g.Width, lineH)
		  
		  // ===================================
		  // LINE TEXT
		  // ===================================
		  g.DrawingColor = editor.TextColor
		  Var s As String = Contents
		  g.DrawText(s, mTextStartX, mTextStartY)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E7320746865207769647468206F662074686520696E64656E746174696F6E206174207468652066726F6E74206F662074686973206C696E652E
		Function IndentWidth(charWidth As Double) As Double
		  /// Returns the width of the indentation at the front of this line.
		  ///
		  /// `charWidth` is the current width of a character in the editor.
		  
		  Return (IndentLevel * charWidth * Owner.ColumnsPerIndent)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 546865207769647468206F662074686973206C696E6520757020746F2060636F6C756D6E602E20446F6573202A6E6F742A207365742074686520677261706869637320666F6E74206E616D65206F722073697A652E
		Function WidthToColumn(column As Integer, g As Graphics, ignoreIdentation As Boolean = False) As Double
		  /// The width of this line up to `column`.
		  /// Does *not* set the graphics font name or size.
		  ///
		  /// Does not include the gutter width.
		  /// Does not factor in padding around the text or the gutter.
		  
		  // Width of a single character.
		  Var charWidth As Double = g.TextWidth("_")
		  
		  // Beginning of the line?
		  If column = 0 Then
		    If ignoreIdentation Then
		      Return 0
		    Else
		      Return IndentWidth(charWidth)
		    End If
		  End If
		  
		  If column > Length Then
		    // Return the width of the entire line.
		    If ignoreIdentation Then
		      Return g.TextWidth(Contents)
		    Else
		      Return g.TextWidth(Contents) + IndentWidth(charWidth)
		    End If
		    
		  Else
		    // Get the width of the characters up to the requested column.
		    Var s As String = Owner.Storage.StringValue(Start, column)
		    
		    // Add in the indentation width if requested.
		    If ignoreIdentation Then
		      Return g.TextWidth(s)
		    Else
		      Return g.TextWidth(s) + IndentWidth(charWidth)
		    End If
		  End If
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E7320746865207769647468206F66207468652074657874206F662074686973206C696E6520757020616E6420696E636C7564696E67207468652063686172616374657220617420606F66667365746020696E2074686520746578742073746F7261676520666F7220636F6E74657874206067602E
		Function WidthToOffset(offset As Integer, g As Graphics) As Double
		  /// Returns the width of the text of this line up and including the character 
		  /// at `offset` in the text storage for context `g`.
		  ///
		  /// `offset` is the 0-based offset in the text storage, **not** the column of the 
		  /// character in this line.
		  /// Assumes the `g` has the correct font size and family set.
		  
		  // Beginning of the line?
		  If offset = Start Then Return 0
		  
		  // Get the characters from the start of this line up to the computed offset.
		  Var chars As String = Owner.Storage.StringValue(Start, offset - Start)
		  
		  // Compute the width of this string.
		  Return g.TextWidth(chars)
		  
		End Function
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0, Description = 546865206C656E677468206F662074686973206C696E6520696E20636F6C756D6E732E204120636F6D62696E6174696F6E206F6620746865206E756D626572206F66206368617261637465727320616E642074686520616D6F756E74206F6620696E64656E746174696F6E2E
		#tag Getter
			Get
			  Return (IndentLevel * Owner.ColumnsPerIndent) + Length
			  
			End Get
		#tag EndGetter
		ColumnLength As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0, Description = 54686520636F6D707574656420636F6E74656E7473206F662074686973206C696E652E
		#tag Getter
			Get
			  Return Owner.Storage.StringValue(Start, Length)
			  
			End Get
		#tag EndGetter
		Contents As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0, Description = 546865206F666673657420696E2074686520646F63756D656E74206F6620746865206C61737420636861726163746572206F662074686973206C696E652E
		#tag Getter
			Get
			  Return Start + Length
			  
			End Get
		#tag EndGetter
		Finish As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0, Description = 54686973206C696E652773206C6576656C206F6620696E64656E746174696F6E202830203D206E6F20696E64656E746174696F6E292E20436C616D70656420746F203E3D20302E
		#tag Getter
			Get
			  Return mIndentLevel
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  // Clamp the indentation level above 0.
			  mIndentLevel = Max(value, 0)
			  
			End Set
		#tag EndSetter
		IndentLevel As Integer
	#tag EndComputedProperty

	#tag Property, Flags = &h0, Description = 54686520696E646578206F662074686973206C696E6520696E20697473206C696E65206D616E616765722E204D616E6167656420696E7465726E616C6C792E20546869732073686F756C6420626520636F6E7369646572656420726561642D6F6E6C7920627920656E642075736572732E
		Index As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865206E756D626572206F662063686172616374657273206F6E2074686973206C696E652E
		Length As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 4261636B696E67206669656C6420666F72207468652060496E64656E744C6576656C6020636F6D70757465642070726F70657274792E
		Private mIndentLevel As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 546865206C696E65206D616E616765722074686174206F776E7320746869732074657874206C696E652E
		Private mOwner As WeakRef
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 546865205820636F6F7264696E617465206F6620746865207374617274206F662074686973206C696E652773207465787420636F6D707574656420647572696E6720697473206C61737420647261772E20496E636C7564657320696E64656E746174696F6E2E2041646A757374656420666F72207363726F6C6C696E672E204261636B696E67206669656C6420666F72207468652060546578745374617274586020636F6D70757465642070726F70657274792E
		Private mTextStartX As Double
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 546865205920636F6F7264696E617465206F6620746865207374617274206F662074686973206C696E652773207465787420636F6D707574656420647572696E6720697473206C61737420647261772E204261636B696E67206669656C6420666F722074686520636F6D7075746564206054657874537461727459602070726F70657274792E
		Private mTextStartY As Double
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 54686520746F70206C656674205920636F6F7264696E61746520746861742074686973206C696E6520697320647261776E2061742E
		Private mTopLeftY As Double
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0, Description = 41207765616B207265666572656E636520746F20746865206C696E65206D616E616765722074686174206F776E7320746869732074657874206C696E652E
		#tag Getter
			Get
			  If mOwner = Nil Then
			    Return Nil
			  Else
			    Return LineManager(mOwner.Value)
			  End If
			  
			End Get
		#tag EndGetter
		Owner As LineManager
	#tag EndComputedProperty

	#tag Property, Flags = &h0, Description = 54686520302D6261736564206F666673657420696E2074686520646F63756D656E74206F662074686520666972737420636861726163746572206F662074686973206C696E652E
		Start As Integer = 0
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0, Description = 546865205820636F6F7264696E617465206F6620746865207374617274206F662074686973206C696E652773207465787420636F6D707574656420647572696E6720697473206C61737420647261772E20496E636C7564657320696E64656E746174696F6E2E2041646A757374656420666F72207363726F6C6C696E672E
		#tag Getter
			Get
			  Return mTextStartX
			  
			End Get
		#tag EndGetter
		TextStartX As Double
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0, Description = 546865205920636F6F7264696E617465206F6620746865207374617274206F662074686973206C696E652773207465787420636F6D707574656420647572696E6720697473206C61737420647261772E
		#tag Getter
			Get
			  Return mTextStartY
			  
			End Get
		#tag EndGetter
		TextStartY As Double
	#tag EndComputedProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Start"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Length"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Finish"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ColumnLength"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="IndentLevel"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Contents"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="TextStartY"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
