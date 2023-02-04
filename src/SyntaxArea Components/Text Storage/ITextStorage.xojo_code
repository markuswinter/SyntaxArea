#tag Interface
Protected Interface ITextStorage
	#tag Method, Flags = &h0, Description = 52657475726E7320746865206368617261637465722061742060696E646578602E20417373756D65732060696E646578602069732076616C69642E
		Function CharacterAt(index As Integer) As String
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 496E7365727473206073602061742060696E6465786020776974686F7574207265706C6163696E6720616E797468696E672E
		Sub Insert(index As Integer, s As String)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 546865206E756D626572206F66206368617261637465727320696E2073746F726167652E
		Function Length() As Integer
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E7320746865206F6666736574206F662074686520656E64206F662074686520776F726420616674657220606361726574506F73602E
		Function NextWordEnd(caretPos As Integer) As Integer
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E7320746865206F6666736574206F6620746865207374617274206F662074686520776F7264206265666F726520606361726574506F73602E
		Function PreviousWordStart(caretPos As Integer) As Integer
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52656D6F76657320606C656E6774686020636861726163746572732066726F6D2073746F7261676520626567696E6E696E672061742060696E646578602E2052657475726E732054727565206966207375636365737366756C206F722046616C7365206966206E6F7468696E67207761732072656D6F7665642E
		Function Remove(index As Integer, length As Integer) As Boolean
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 5265706C61636520606C656E67746860206368617261637465727320626567696E6E696E672061742060696E646578602077697468206073602E20496620606C656E677468203D203060207468656E206073602077696C6C20626520696E73657274656420776974686F7574207265706C6163696E6720616E797468696E672E
		Sub Replace(index As Integer, length As Integer, s As String)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 53657473207468652077686F6C652073746F7261676520746F206073602E
		Sub StringValue(Assigns s As String)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E73206120737472696E67206F6620606C656E67746860206368617261637465727320626567696E6E696E672061742060696E646578602E
		Function StringValue(index As Integer, length As Integer) As String
		  
		End Function
	#tag EndMethod


	#tag Note, Name = About
		Represents a class that is able to store and manipulate characters of text.
		
	#tag EndNote


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
