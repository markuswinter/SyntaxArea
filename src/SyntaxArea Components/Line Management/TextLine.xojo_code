#tag Class
Protected Class TextLine
	#tag Method, Flags = &h0
		Sub Constructor()
		  Characters = New GapBuffer
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21, Description = 5468652061637475616C2063686172616374657273206F6E2074686973206C696E652E
		Private Characters As GapBuffer
	#tag EndProperty

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
	#tag EndViewBehavior
End Class
#tag EndClass
