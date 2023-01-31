#tag Class
Protected Class TextLine
	#tag Method, Flags = &h0, Description = 436F6E737472756374732061206E65772074657874206C696E6520626567696E6E696E67206174206F66667365742060737461727460206F6620606C656E6774686020636861726163746572732E
		Sub Constructor(start As Integer, length As Integer)
		  /// Constructs a new text line beginning at offset `start` of `length` characters.
		  
		  Self.Start = start
		  Self.Length = length
		  
		End Sub
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0, Description = 546865206F666673657420696E2074686520646F63756D656E74206F6620746865206C61737420636861726163746572206F662074686973206C696E652E
		#tag Getter
			Get
			  Return Start + Length
			  
			End Get
		#tag EndGetter
		Finish As Integer
	#tag EndComputedProperty

	#tag Property, Flags = &h0, Description = 546865206E756D626572206F662063686172616374657273206F6E2074686973206C696E652E
		Length As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54686520302D6261736564206F666673657420696E2074686520646F63756D656E74206F662074686520666972737420636861726163746572206F662074686973206C696E652E
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
	#tag EndViewBehavior
End Class
#tag EndClass
