#tag Interface
Protected Interface ITextStorage
	#tag Method, Flags = &h0, Description = 436F707920606C656E6774686020636861726163746572732066726F6D206066726F6D6020626567696E6E696E67206174206066726F6D496E6465786020746F20746869732073746F72616765207374617274696E6720617420606C6F63616C496E646578602E
		Sub Copy(from As ITextStorage, fromIndex As Integer, localIndex As Integer, length As Integer)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 546865206E756D626572206F66206368617261637465727320696E2073746F726167652E
		Function Size() As Integer
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 526573697A65207468652073746F7261676520746F206163636F6D6F64617465206076616C75656020636861726163746572732E
		Sub Size(Assigns value As Integer)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E7320606C656E67746860206368617261637465727320626567696E6E696E672061742060696E646578602E
		Function StringValue(index As Integer, length As Integer) As String
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 50757473206120737472696E67206076616C756560206F6620606C656E6774686020636861726163746572732061742060696E646578602E
		Sub StringValue(index As Integer, length As Integer, Assigns value As String)
		  
		End Sub
	#tag EndMethod


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
End Interface
#tag EndInterface
