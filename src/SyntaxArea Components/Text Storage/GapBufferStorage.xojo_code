#tag Class
Protected Class GapBufferStorage
	#tag Method, Flags = &h0, Description = 437265617465732061206E6577206D656D6F727920626C6F636B206C6172676520656E6F75676820746F2073746F7265206073697A656020636861726163746572732E
		Sub Constructor(size As Integer)
		  /// Creates a new memory block large enough to store `size` characters.
		  
		  mStorage = New MemoryBlock(size * BYTES_PER_CHAR)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 436F707920606C656E6774686020636861726163746572732066726F6D206066726F6D6020626567696E6E696E67206174206066726F6D496E6465786020746F20746869732073746F72616765207374617274696E6720617420606C6F63616C496E646578602E
		Sub Copy(from As GapBufferStorage, fromIndex As Integer, localIndex As Integer, length As Integer)
		  /// Copy `length` characters from `from` beginning at `fromIndex` to this storage starting at `localIndex`.
		  
		  #If Not DebugBuild
		    #Pragma DisableBackgroundTasks
		    #Pragma DisableBoundsChecking
		  #EndIf
		  
		  // Indexes and length all have to be multiplied by BYTES_PER_CHAR.
		  fromIndex = fromIndex * BYTES_PER_CHAR
		  localIndex = localIndex * BYTES_PER_CHAR
		  length = length * BYTES_PER_CHAR
		  
		  If from.Size = 0 Or length = 0 Then
		    // Nothing to copy.
		    Return
		  End If
		  
		  // Do the copy.
		  mStorage.StringValue(localIndex, Min(length, mStorage.Size - localIndex)) = _
		  from.mStorage.StringValue(fromIndex, Min(length, from.Size * BYTES_PER_CHAR - fromIndex))
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 546865206E756D626572206F66206368617261637465727320696E2073746F726167652E
		Function Size() As Integer
		  /// The number of characters in storage.
		  
		  Return mStorage.Size / BYTES_PER_CHAR
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 526573697A65207468652073746F7261676520746F206163636F6D6F64617465206076616C75656020636861726163746572732E
		Sub Size(Assigns value As Integer)
		  /// Resize the storage to accomodate `value` characters.
		  
		  mStorage.Size = value * BYTES_PER_CHAR
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E732061205554462D3820737472696E67206F6620606C656E67746860206368617261637465727320626567696E6E696E672061742060696E646578602E2052657475726E732022222069662060696E6465786020697320696E76616C69642E
		Function StringValue(index As Integer, length As Integer) As String
		  /// Returns a UTF-8 string of `length` characters beginning at `index`.
		  /// Returns "" if `index` is invalid.
		  
		  If length = 0 Then Return ""
		  If index >= Size Or index < 0 Then Return ""
		  
		  // Compute the correct index and length given that we use 4 bytes for each character.
		  index = index * BYTES_PER_CHAR
		  length = length * BYTES_PER_CHAR
		  
		  // Extract the string from the memory block.
		  Var s As String = mStorage.StringValue(index, Min(length, mStorage.Size - index)).DefineEncoding(Encodings.UTF32)
		  
		  // Enforce UTF-8 encoding.
		  Return s.ConvertEncoding(Encodings.UTF8)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 50757473206120737472696E67206076616C756560206F6620606C656E6774686020636861726163746572732061742060696E646578602E
		Sub StringValue(index As Integer, length As Integer, Assigns value As String)
		  /// Puts a string `value` of `length` characters at `index`.
		  ///
		  /// Assumes that there are 4 bytes per character (i.e. BYTES_PER_CHAR = 4).
		  
		  If length = 0 Then Return
		  
		  // We need to store the data in UTF-32 format (each character occupies 4 bytes).
		  Var newVal As String = value
		  If newVal.Encoding <> Encodings.UTF32 Then
		    newVal = value.ConvertEncoding(Encodings.UTF32)
		  End If
		  
		  // Compute the correct index and length.
		  index = index * BYTES_PER_CHAR
		  length = length * BYTES_PER_CHAR
		  
		  If newVal.Bytes <> length Then
		    Var d As MemoryBlock = newVal
		    If d.UInt32Value(0) = &h0000FEFF Or d.UInt32Value(0) = &hFFFE0000 Then
		      // Remove the byte order mark (BOM).
		      newVal = d.StringValue(4, d.Size - 4)
		    End If
		  End If
		  
		  mStorage.StringValue(index, length) = newVal
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21, Description = 546865206D656D6F727920626C6F636B20746861742061637475616C6C792073746F7265732074686520746578742E
		Private mStorage As MemoryBlock
	#tag EndProperty


	#tag Constant, Name = BYTES_PER_CHAR, Type = Double, Dynamic = False, Default = \"4", Scope = Public, Description = 546865206E756D626572206F66206279746573207573656420746F2073746F72652065616368206368617261637465722E
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
		#tag ViewProperty
			Name="mStorage"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
