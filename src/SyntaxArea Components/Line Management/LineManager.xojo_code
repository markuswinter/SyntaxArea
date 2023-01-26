#tag Class
Protected Class LineManager
	#tag Method, Flags = &h21, Description = 41646A7573747320746865207374617274206F666673657473206F66206576657279206C696E652066726F6D20302D6261736564206066697273744C696E65602028696E636C757369766529206F6E776172647320627920616464696E67206064656C7461602E
		Private Sub AdjustLineStarts(firstLine As Integer, delta As Integer)
		  /// Adjusts the start offsets of every line from 0-based `firstLine` (inclusive) onwards by adding `delta`.
		  
		  #If Not DebugBuild
		    #Pragma DisableBackgroundTasks
		    #Pragma DisableBoundsChecking
		  #EndIf
		  
		  Var linesLastIndex As Integer = mLines.LastIndex
		  
		  If firstLine > linesLastIndex Then Return
		  
		  Var line As TextLine
		  For i As Integer = firstLine To linesLastIndex
		    line = mLines(i)
		    line.Start = line.Start + delta
		  Next i
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 436F6E737472756374732061206E6577206C696E65206D616E61676572206261636B6564206279206073746F72616765602E
		Sub Constructor(storage As ITextStorage)
		  /// Constructs a new line manager backed by `storage`.
		  
		  mStorage = storage
		  
		  // We *always* have at least one line.
		  mLines.Add(New TextLine(0, 0))
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52657475726E732074686520302D6261736564206C696E65206E756D62657220666F722074686520676976656E20302D626173656420606F66667365746020696E20606D53746F72616765602E
		Private Function LineNumberForOffset(offset As Integer) As Integer
		  /// Returns the 0-based line number for the given 0-based `offset` in `mStorage`.
		  ///
		  /// We'll use a binary search to the find the correct line.
		  
		  #If Not DebugBuild
		    #Pragma DisableBackgroundTasks
		    #Pragma DisableBoundsChecking
		  #EndIf
		  
		  // Easy checks.
		  If mLines.Count = 1 Then Return 0
		  If offset = mLines(mLines.LastIndex).Finish + 1 Then Return mLines.LastIndex
		  
		  // Bounds check.
		  If offset < 0 Or offset > mLines.LastIndex + 1 Then
		    Raise New OutOfBoundsException("`offset` is out of range.")
		  End If
		  
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
		  
		  If mLines(low).Start > offset Then
		    Return low - 1
		  Else
		    Return low
		  End If
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 5265706C616365732061206368756E6B206F66207465787420286F6620606C656E6774686020636861726163746572732920776974682060736020626567696E6E696E6720617420606F6666736574602E2043616C6C656420696E7465726E616C6C79206279206053796E74617841726561602E
		Sub Replace(offset As Integer, length As Integer, s As String)
		  /// Replaces a chunk of text (of `length` characters) with `s` beginning at `offset`.
		  /// Called internally by `SyntaxArea`.
		  ///
		  /// Doesn't actually store the text (that's handled by `ITextStorage.Replace`).
		  
		  #Pragma Warning "TODO"
		  
		  // Get the line number for `offset`. This is the line the replacement begins.
		  Var lineNumber As Integer = LineNumberForOffset(offset)
		  
		  // Grab a reference to the line the replacement begins on.
		  Var line As TextLine = mLines(lineNumber)
		  
		  // Quick check for the insertion of a single simple character without a selection
		  // as this is by far the commonest action and will not cause the creation or
		  // removal of any new lines.
		  // ASCII <= 31 are special characters like newlines and tabs.
		  If length = 0 And s.Length = 1 And s.Asc > 31 Then
		    line.Length = line.Length + 1
		    AdjustLineStarts(lineNumber + 1, 1)
		    Return
		  End If
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21, Description = 546865206C696E6573206265696E67206D616E616765642E
		Private mLines() As TextLine
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 54686520746578742073746F726167652074686973206C696E65206D616E616765722073686F756C64207573652E
		Private mStorage As ITextStorage
	#tag EndProperty


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
