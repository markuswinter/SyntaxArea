#tag Class
Protected Class LineManager
	#tag Method, Flags = &h0
		Sub Constructor(owner As SyntaxArea)
		  If owner = Nil Then
		    Raise New InvalidArgumentException("A line manager must be owned by a valid SyntaxArea.")
		  End If
		  
		  mOwner = New WeakRef(owner)
		  
		  // The line manager must always have at least one line.
		  mLines.Add(New TextLine(0, 0, Self))
		  
		  mLongestLine = mLines(0)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 41646A7573747320746865207374617274206F6666736574206F66206576657279206C696E652066726F6D206066697273744C696E65496E646578602028696E636C75736976652920756E74696C2074686520656E64206F662074686520646F63756D656E74206279206064656C7461602E
		Private Sub FixStartOffsets(firstLineIndex As Integer, delta As Integer)
		  /// Adjusts the start offset of every line from `firstLineIndex` (inclusive) until the end of the document by `delta`.
		  
		  Var linesLastIndex As Integer = mLines.LastIndex
		  For i As Integer = firstLineIndex To linesLastIndex
		    mLines(i).Start = mLines(i).Start + delta
		  Next i
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 496E73657274732060736020617420606F6666736574602E20417373756D657320616E79206E65776C696E65206368617261637465727320696E206073602068617665206265656E207374616E646172646973656420746F20554E49582E
		Sub Insert(offset As Integer, s As String)
		  /// Inserts `s` at `offset`.
		  /// Assumes any newline characters in `s` have been standardised to UNIX.
		  
		  // Get the index of the line containing `offset`.
		  Var originalLineIndex As Integer = LineIndexForOffset(offset)
		  Var line As TextLine = mLines(originalLineIndex)
		  
		  // Cache the length of the current longest line in case we modify it.
		  Var longestLineLength As Integer = mLongestLine.ColumnLength
		  
		  // Cache the length of the string.
		  Var sLength As Integer = s.Length
		  
		  If sLength = 1 And s = EndOfLine.UNIX Then
		    // Common case: Insert a single newline at `offset` by breaking the line at `offset`
		    // and inserting a new line with the characters following the break.
		    Var newLineLength As Integer = line.Finish - offset
		    line.Length = offset - line.Start
		    mLines.AddAt(originalLineIndex + 1, New TextLine(offset + 1, newLineLength, Self))
		    If Owner.WordWrap Then
		      #Pragma Warning "TODO: Recompute lines"
		    Else
		      FixStartOffsets(originalLineIndex + 2, newLineLength)
		    End If
		    
		  ElseIf Not s.Contains(EndOfLine.UNIX) Then
		    // Insert text only on this line. 
		    // We just need to increase the length of the affected line and fix the offsets of subsequent lines.
		    line.Length = line.Length + sLength
		    If Owner.WordWrap Then
		      #Pragma Warning "TODO: Recompute lines"
		    Else
		      FixStartOffsets(originalLineIndex + 1, sLength)
		    End If
		  Else
		    // Maximum effort. The string contains at least one new line.
		    // Split the string into parts based on newlines.
		    #Pragma Warning "TODO"
		    Break
		  End If
		  
		  // Has the longest line changed?
		  If line.ColumnLength > longestLineLength Then
		    mLongestLine = line
		    Owner.LongestLineChanged = True
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E7320746865206C696E652061742074686520302D62617365642060696E64657860206F72204E696C2E
		Function LineAt(index As Integer) As TextLine
		  /// Returns the line at the 0-based `index` or Nil.
		  
		  If index < 0 Or index > mLines.LastIndex Then
		    Return Nil
		  Else
		    Return mLines(index)
		  End If
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52657475726E732074686520302D626173656420696E64657820696E20606D4C696E657360206F6620746865206C696E6520636F6E7461696E696E6720606F6666736574602E
		Private Function LineIndexForOffset(offset As Integer) As Integer
		  /// Returns the 0-based index in `mLines` of the line containing `offset`.
		  
		  // If there's only one line then we return that.
		  If mLines.Count = 1 Then Return 0
		  
		  // Binary search.
		  Var low As Integer = 0
		  Var high As Integer = mLines.LastIndex
		  Var mid As Integer
		  Var line As TextLine
		  While low < high
		    mid = (high + low) / 2
		    line = mLines(mid)
		    If line.Start = offset Then
		      low = mid
		      Exit
		    ElseIf line.Start > offset Then
		      high = mid - 1
		    Else
		      low = mid + 1
		    End If
		  Wend
		  
		  If mLines(low).Start > offset Then Return low - 1
		  Return low
		  
		End Function
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0, Description = 546865206E756D626572206F6620636F6C756D6E732065616368206C6576656C206F6620696E64656E746174696F6E206973206571756976616C656E7420746F2E
		#tag Getter
			Get
			  Return Owner.ColumnsPerIndent
			End Get
		#tag EndGetter
		ColumnsPerIndent As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0, Description = 546865206E756D626572206F66206C696E657320696E2074686520656469746F722E
		#tag Getter
			Get
			  Return mLines.Count
			  
			End Get
		#tag EndGetter
		LineCount As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0, Description = 5468652063757272656E74206C6F6E67657374206C696E652E20496E7465726E616C6C792063616368656420736F206E6F7420657870656E7369766520746F2063616C6C2E
		#tag Getter
			Get
			  Return mLongestLine
			  
			End Get
		#tag EndGetter
		LongestLine As TextLine
	#tag EndComputedProperty

	#tag Property, Flags = &h0, Description = 546865206C696E657320696E2074686520646F63756D656E742E
		mLines() As TextLine
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 4261636B696E67206669656C6420666F722074686520604C6F6E676573744C696E65602070726F70657274792E
		Private mLongestLine As TextLine
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 54686520656469746F722074686174206F776E732074686973206C696E65206D616E616765722E
		Private mOwner As WeakRef
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0, Description = 41207765616B207265666572656E636520746F2074686520656469746F722074686174206F776E732074686973206C696E65206D616E616765722E
		#tag Getter
			Get
			  If mOwner = Nil Then
			    Return Nil
			  Else
			    Return SyntaxArea(mOwner.Value)
			  End If
			  
			End Get
		#tag EndGetter
		Owner As SyntaxArea
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0, Description = 4120636F6D7075746564207265666572656E636520746F20746865206F776E6572277320746578742073746F726167652E
		#tag Getter
			Get
			  Return Owner.TextStorage
			End Get
		#tag EndGetter
		Storage As ITextStorage
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
	#tag EndViewBehavior
End Class
#tag EndClass
