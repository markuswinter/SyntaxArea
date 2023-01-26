#tag Class
Protected Class TextLine
	#tag Method, Flags = &h0, Description = 44656661756C7420636F6E7374727563746F722E2053657473206053746172746020616E6420604C656E6774686020746F206030602E
		Sub Constructor()
		  /// Default constructor. Sets `Start` and `Length` to `0`.
		  
		  Start = 0
		  Length = 0
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 436F6E737472756374732061206E65772074657874206C696E6520626567696E6E696E672061742060737461727460206F6620606C656E677468602E
		Sub Constructor(start As Integer, length As Integer)
		  /// Constructs a new text line beginning at `start` of `length`.
		  
		  Self.Start = start
		  Self.Length = length
		  
		End Sub
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0, Description = 546865206F666673657420696E20746865207465787473746F72616765206F6620746865206C61737420636861726163746572206F662074686973206C696E652E205468697320636861726163746572206D61792062652061206E65776C696E652063686172616374657220287374616E646172646973656420746F20554E4958292E20436F6D70757465642066726F6D206053746172746020616E6420604C656E677468602E
		#tag Getter
			Get
			  Return Start + Length
			  
			End Get
		#tag EndGetter
		Finish As Integer
	#tag EndComputedProperty

	#tag Property, Flags = &h0, Description = 546865206E756D626572206F662063686172616374657273206F6E2074686973206C696E652E20546865206C61737420636861726163746572205F6D61795F2062652061206E65776C696E652063686172616374657220287374616E646172646973656420746F20554E4958292E20
		Length As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865206F666673657420696E2074686520746578742073746F72616765206F662074686520666972737420636861726163746572206F662074686973206C696E652E
		Start As Integer = 0
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
		#tag ViewProperty
			Name="Start"
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
			Name="Length"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
