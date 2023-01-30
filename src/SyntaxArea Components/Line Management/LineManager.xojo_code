#tag Class
Protected Class LineManager
	#tag Method, Flags = &h0
		Sub Constructor(owner As SyntaxArea)
		  If owner = Nil Then
		    Raise New InvalidArgumentException("A line manager must be owned by a valid SyntaxArea.")
		  End If
		  
		  mOwner = New WeakRef(owner)
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21, Description = 546865206C696E657320696E2074686520646F63756D656E742E
		Private mLines() As TextLine
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 54686520656469746F722074686174206F776E732074686973206C696E65206D616E616765722E
		Private mOwner As WeakRef
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0, Description = 41207765616B207265666572656E636520746F2074686520656469746F722074686174206F776E732074686973206C696E65206D616E616765722E
		#tag Getter
			Get
			  If mOwner = Nil Then
			    Return Nil
			  Else
			    Return SyntaxArea(mOwner.Value)
			  End If
			  
			End Get
		#tag EndGetter
		Owner As SyntaxArea
	#tag EndComputedProperty


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
