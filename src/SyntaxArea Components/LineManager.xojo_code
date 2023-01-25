#tag Class
Protected Class LineManager
	#tag Method, Flags = &h0, Description = 436F6E737472756374732061206E6577206C696E65206D616E61676572206261636B6564206279206073746F72616765602E
		Sub Constructor(storage As ITextStorage)
		  /// Constructs a new line manager backed by `storage`.
		  
		  mStorage = storage
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 5265706C616365732061206368756E6B206F66207465787420286F6620606C656E6774686020636861726163746572732920776974682060736020626567696E6E696E6720617420606F6666736574602E2043616C6C656420696E7465726E616C6C79206279206053796E74617841726561602E
		Sub Replace(offset As Integer, length As Integer, s As String)
		  /// Replaces a chunk of text (of `length` characters) with `s` beginning at `offset`.
		  /// Called internally by `SyntaxArea`.
		  ///
		  /// Doesn't actually store the text (that's handled by `ITextStorage.Replace`).
		  
		  #Pragma Warning "TODO"
		  
		End Sub
	#tag EndMethod


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
