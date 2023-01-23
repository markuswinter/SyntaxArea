#tag Class
Protected Class ArrayStorage
Implements ITextStorage
	#tag Method, Flags = &h0, Description = 52657475726E7320746865206368617261637465722061742060696E646578602E20417373756D65732060696E646578602069732076616C69642E
		Function CharacterAt(index As Integer) As String
		  /// Returns the character at `index`. Assumes `index` is valid.
		  ///
		  /// Part of the ITextStorage interface.
		  
		  Return mStorage(index)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 4173736572747320746861742060696E646578602069732077697468696E207468652073746F7261676520626F756E64732E2052616973657320616E204F75744F66426F756E6473457863657074696F6E2069662069742069736E27742E
		Private Sub CheckBounds(index As Integer)
		  /// Asserts that `index` is within the storage bounds. Raises an OutOfBoundsException if it isn't.
		  
		  If index < 0 Or index > mStorage.LastIndex Then
		    Var e As New OutOfBoundsException
		    e.Message = "Tried to access the text storage at an invalid index." + EndOfLine + "Storage length: " + mStorage.Count.ToString + ", index: " + index.ToString
		    Raise e
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 436F6E7374727563747320616E20656D70747920746578742073746F72652E
		Sub Constructor()
		  /// Constructs an empty text store.
		  
		  mStorage.ResizeTo(-1)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 496E7365727473206073602061742060696E6465786020776974686F7574207265706C6163696E6720616E797468696E672E
		Sub Insert(index As Integer, s As String)
		  /// Inserts `s` at `index` without replacing anything.
		  ///
		  /// Part of the ITextStorage interface.
		  
		  Replace(index, 0, s)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 546865206E756D626572206F66206368617261637465727320696E2073746F726167652E
		Function Length() As Integer
		  /// The number of characters in storage.
		  ///
		  /// Part of the ITextStorage interface.
		  
		  Return mStorage.Count
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52656D6F76657320606C656E6774686020636861726163746572732066726F6D2073746F7261676520626567696E6E696E672061742060696E646578602E2052657475726E732054727565206966207375636365737366756C206F722046616C7365206966206E6F7468696E67207761732072656D6F7665642E
		Function Remove(index As Integer, length As Integer) As Boolean
		  /// Removes `length` characters from storage beginning at `index`.
		  /// Returns True if successful or False if nothing was removed.
		  ///
		  /// Part of the ITextStorage interface.
		  
		  // Sanity check.
		  If index < 0 Or index > mStorage.LastIndex Or mStorage.Count = 0 Then Return False
		  
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
		  
		  // Get the original string.
		  Var original As String = String.FromArray(mStorage, "")
		  
		  // Grab the characters before and after the index, excluding any characters to replace.
		  Var before As String = original.Left(index)
		  Var after As String = original.Middle(index + length)
		  
		  // Concatenate with the string to insert.
		  Var newVal As String = before + s + after
		  
		  // Reconstruct the storage.
		  mStorage = newVal.Split("")
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 53657473207468652077686F6C652073746F7261676520746F206073602E
		Sub StringValue(Assigns s As String)
		  /// Sets the whole storage to `s`.
		  ///
		  /// Part of the ITextStorage interface.
		  
		  mStorage = s.Split("")
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E73206120737472696E67206F6620606C656E67746860206368617261637465727320626567696E6E696E672061742060696E646578602E
		Function StringValue(index As Integer, length As Integer) As String
		  /// Returns a string of `length` characters beginning at `index`.
		  ///
		  /// Part of the ITextStorage interface.
		  
		  // Get the whole string.
		  Var raw As String = StringValue(0, Length)
		  
		  // Return the requested portion.
		  Return raw.Middle(index, length)
		  
		  Exception e As OutOfBoundsException
		    e.Message = "Tried to access the text storage with an invalid index / length combination." + _
		    EndOfLine + "Storage length: " + mStorage.Count.ToString + ", index: " + index.ToString + _ 
		    "requested length: " + length.ToString
		    Raise e
		    
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21, Description = 416E206172726179206F6620636861726163746572732E
		Private mStorage() As String
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
