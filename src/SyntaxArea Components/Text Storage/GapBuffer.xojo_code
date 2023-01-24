#tag Class
Protected Class GapBuffer
Implements ITextStorage
	#tag Method, Flags = &h0, Description = 52657475726E7320746865206368617261637465722061742060696E646578602E20417373756D65732060696E646578602069732076616C69642E
		Function CharacterAt(index As Integer) As String
		  /// Returns the character at `index`. Assumes `index` is valid.
		  
		  If index < GapStart Then
		    // The index is before the gap.
		    Return mData.StringValue(index, 1)
		  Else
		    Return mData.StringValue(index + GapLength, 1)
		  End If
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 4173736572747320746861742060696E646578602069732077697468696E207468652073746F7261676520626F756E64732E2052616973657320616E204F75744F66426F756E6473457863657074696F6E2069662069742069736E27742E
		Private Sub CheckBounds(index As Integer)
		  /// Asserts that `index` is within the storage bounds. Raises an OutOfBoundsException if it isn't.
		  
		  If index < 0 Or index > Length Then
		    Var e As New OutOfBoundsException
		    e.Message = "Tried to access the text storage at an invalid index." + EndOfLine + "Storage length: " + Length.ToString + ", index: " + index.ToString
		    Raise e
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 436F6E737472756374732061206E657720656D70747920676170206275666665722E
		Sub Constructor()
		  /// Constructs a new empty gap buffer. 
		  
		  // Create a new storage structure.
		  
		  mData = New GapBufferData(0)
		  GapStart = 0
		  GapEnd = 0
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 456E73757265732074686572652773206174206C6561737420606D696E52657175697265644C656E677468602073706163657320617661696C61626C6520696E20746865206761702E2052657A696573206053746F72616765602061732072657175697265642E
		Private Sub EnsureStorageSize(minRequiredLength As Integer)
		  /// Ensures there's at least `minRequiredLength` spaces available in the gap. Rezies `Storage` as required.
		  
		  #If Not DebugBuild
		    #Pragma DisableBackgroundTasks
		    #Pragma DisableBoundsChecking
		  #EndIf
		  
		  Var newBuffer As GapBufferData
		  Var delta As Integer
		  If GapLength < minRequiredLength Or GapLength < MIN_GAP_SIZE then
		    // The gap is too small. Resize the storage.
		    delta = Max(minRequiredLength, MAX_GAP_SIZE) - GapLength
		    newBuffer = New GapBufferData(mData.Size + delta)
		    
		  ElseIf GapLength > MAX_GAP_SIZE Then
		    // The gap is too big.
		    delta = Max(minRequiredLength, MIN_GAP_SIZE) - GapLength
		    newBuffer = New GapBufferData(mData.Size + delta)
		    
		  Else
		    // No need to resize the storage buffer.
		    Return
		  end if
		  
		  // Copy the contents of the current storage to the new buffer and update the gap end position.
		  newBuffer.Copy(mData, 0, 0, GapStart)
		  newBuffer.Copy(mData, mGapEnd, newbuffer.Size - (mData.Size - mGapEnd), mData.Size - mGapEnd)
		  mData = newBuffer
		  GapEnd = mGapEnd + delta
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 496E7365727473206073602061742060696E6465786020776974686F7574207265706C6163696E6720616E797468696E672E
		Sub Insert(index As Integer, s As String)
		  /// Inserts `s` at `index` without replacing anything.
		  
		  Replace(index, 0, s)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 546865206E756D626572206F66206368617261637465727320696E2073746F726167652E
		Function Length() As Integer
		  /// The number of characters in storage.
		  
		  Return mData.Size - GapLength
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 4D6F766573207468652067617020746F206120646966666572656E7420706C6163652077697468696E207468652073746F72616765207374727563747572652E
		Private Sub PlaceGap(index As Integer)
		  /// Moves the gap to a different place within the storage structure.
		  
		  #If Not DebugBuild
		    #Pragma DisableBackgroundTasks
		    #Pragma DisableBoundsChecking
		  #EndIf
		  
		  // If the index hasn't changed and there's a gap there's nothing to do.
		  If index = GapStart And GapLength > 0 Then Return
		  
		  Var newBuffer As GapBufferData = mData
		  
		  // Empty?
		  If mData.Size = 0 Then Return
		  
		  // Moving before current gap?
		  If index < gapStart Then
		    Var count As Integer = GapStart - index // The number of items to move.
		    newbuffer.StringValue(index + GapLength, count) = mData.StringValue(index, count) // Move the items.
		    
		    GapStart = GapStart - count
		    GapEnd = mGapEnd - count
		    
		  Else
		    // Moving after the current gap start?
		    Var count As Integer = index - GapStart // The items to move.
		    If count > 0 Then
		      newbuffer.StringValue(GapStart, Count) = mData.StringValue(mGapEnd, count) // Move the items.
		      
		      GapStart = GapStart + count
		      GapEnd = mGapEnd + count
		    End If
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52656D6F76657320606C656E6774686020636861726163746572732066726F6D2073746F7261676520626567696E6E696E672061742060696E646578602E2052657475726E732054727565206966207375636365737366756C206F722046616C7365206966206E6F7468696E67207761732072656D6F7665642E
		Function Remove(index As Integer, length As Integer) As Boolean
		  /// Removes `length` characters from storage beginning at `index`.
		  /// Returns True if successful or False if nothing was removed.
		  
		  // Sanity check.
		  If index < 0 Or index > Self.Length Or Self.Length = 0 Then Return False
		  
		  Replace(index, length, "")
		  
		  Return True
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 5265706C61636520606C656E67746860206368617261637465727320626567696E6E696E672061742060696E646578602077697468206073602E20496620606C656E677468203D203060207468656E206073602077696C6C20626520696E73657274656420776974686F7574207265706C6163696E6720616E797468696E672E
		Sub Replace(index As Integer, length As Integer, s As String)
		  /// Replace `length` characters beginning at `index` with `s`. 
		  /// If `length = 0` then `s` will be inserted without replacing anything.
		  ///
		  /// Part of the ITextStorage interface.
		  
		  // Sanity check.
		  CheckBounds(index)
		  
		  // Put the gap at `index`.
		  PlaceGap(index)
		  
		  // Ensure the encoding is UTF-8.
		  s = s.ConvertEncoding(Encodings.UTF8)
		  
		  // Ensure that the gap is big enough.
		  Var sLength As Integer = s.Length
		  Var minLengthRequired As Integer = sLength
		  EnsureStorageSize(minLengthRequired)
		  
		  // Replace characters by moving them into the gap.
		  GapEnd = mGapEnd + length
		  
		  // Add the text.
		  mData.StringValue(index, sLength) = s
		  GapStart = GapStart + sLength
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 53657473207468652077686F6C652073746F7261676520746F206073602E
		Sub StringValue(Assigns s As String)
		  /// Sets the whole storage to `s`.
		  ///
		  /// Part of the ITextStorage interface.
		  
		  // Text without an encoding cannot be converted because it will cause 
		  // a failure in `MemoryBlock32TextStorage.StringValue`.
		  If s.Encoding = Nil Then
		    Raise New UnsupportedOperationException("Cannot assign string value to text storage because it has no encoding.")
		  End If
		  
		  // Use UTF-8.
		  s = s.ConvertEncoding(Encodings.UTF8)
		  
		  // Set the text.
		  mData.Size = s.Length
		  mData.StringValue(0, s.Length) = s
		  GapStart = s.Length / 2
		  GapEnd = GapStart
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E73206120737472696E67206F6620606C656E67746860206368617261637465727320626567696E6E696E672061742060696E646578602E
		Function StringValue(index As Integer, length As Integer) As String
		  /// Returns a string of `length` characters beginning at `index`.
		  ///
		  /// Part of the ITextStorage interface.
		  
		  #If Not DebugBuild
		    #Pragma DisableBackgroundTasks
		    #Pragma DisableBoundsChecking
		  #EndIf
		  
		  If length <= 0 Or Self.Length = 0 Then Return ""
		  
		  CheckBounds(index)
		  
		  Var delta As Integer = index + length
		  
		  // Is all the text before the gap?
		  If delta < GapStart Then
		    Return mData.StringValue(index, length)
		  End If
		  
		  // Is all the text after the gap?
		  If index > GapStart Then
		    Return mData.StringValue(index + GapLength, length)
		  End If
		  
		  // The text is before and after the gap. Maximum effort.
		  Var result As GapBufferData = New GapBufferData(length)
		  result.Copy(mData, index, 0, GapStart - index)
		  result.Copy(mData, mGapEnd, GapStart - index, delta - GapStart)
		  Return result.StringValue(0, result.Size)
		  
		End Function
	#tag EndMethod


	#tag Note, Name = About
		This text storage class utilises a "gap buffer" for efficient storage:
		https://en.wikipedia.org/wiki/Gap_buffer
		
		It relies on a small helper class (`GapBufferData`) to store the actual text. `GapBufferData` is a thin
		wrapper around a MemoryBlock.
		
		
	#tag EndNote


	#tag ComputedProperty, Flags = &h21
		#tag Getter
			Get
			  Return mGapEnd
			  
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  // Clamp the gap end between 0 and the size of the storage.
			  If value > mData.Size Then
			    mGapEnd = mData.Size
			  ElseIf value < 0 Then
			    mGapEnd = 0
			  Else
			    mGapEnd = value
			  End If
			  
			End Set
		#tag EndSetter
		Private GapEnd As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h21, Description = 546865206C656E677468206F6620746865206761702E
		#tag Getter
			Get
			  Return mGapEnd - GapStart
			End Get
		#tag EndGetter
		Private GapLength As Integer
	#tag EndComputedProperty

	#tag Property, Flags = &h21, Description = 54686520302D626173656420696E646578206F6620746865207374617274206F6620746865206761702E205468652067617020626567696E73206A757374206265666F7265207468652063686172616374657220746F20696E736572742E
		Private GapStart As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 53746F726573207468652061637475616C20746578742E
		Private mData As GapBufferData
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 4261636B732060476170456E64602E
		Private mGapEnd As Integer
	#tag EndProperty


	#tag Constant, Name = MAX_GAP_SIZE, Type = Double, Dynamic = False, Default = \"256", Scope = Private, Description = 546865206D6178696D756D2073697A65207468652067617020697320616C6C6F77656420746F2062652E
	#tag EndConstant

	#tag Constant, Name = MIN_GAP_SIZE, Type = Double, Dynamic = False, Default = \"32", Scope = Private, Description = 546865206D696E696D756D2073697A65207468652067617020697320616C6C6F77656420746F2062652E
	#tag EndConstant


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
