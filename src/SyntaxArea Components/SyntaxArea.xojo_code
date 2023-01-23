#tag Class
Protected Class SyntaxArea
Inherits NSScrollViewCanvas
	#tag Event
		Function FontSizeAtLocation(location As Integer) As Single
		  /// Returns the current text size.
		  ///
		  /// The editor only supports a uniform text size for all tokens.
		  
		  #Pragma Unused location
		  
		  Return mTextSize
		  
		End Function
	#tag EndEvent

	#tag Event
		Function IsEditable() As Boolean
		  /// Returns False if the canvas is read-only or True if it's editable.
		  
		  Return Not mReadOnly
		  
		End Function
	#tag EndEvent

	#tag Event
		Sub Paint(g As Graphics, areas() As Xojo.Rect)
		  #Pragma Unused areas
		  
		  If NeedsFullRedraw Then
		    RedrawEverything(g)
		  Else
		    RedrawDirtyLines(g)
		  End If
		  
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub Constructor()
		  // Calling the overridden superclass constructor.
		  Super.Constructor
		  
		  InvalidLines = New Dictionary
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 44726177732074686520656469746F72277320626F72646572732069662072657175697265642E20417373756D657320606760206973207468652063616E7661732720677261706869637320636F6E746578742E
		Private Sub DrawCanvasBorders(g As Graphics)
		  /// Draws the editor's borders if required. Assumes `g` is the canvas' graphics context.
		  
		  g.DrawingColor = mBorderColor
		  If mHasTopBorder Then
		    g.DrawLine(0, 0, g.Width, 0)
		  End If
		  If mHasBottomBorder Then
		    g.DrawLine(0, g.Height - 1, g.Width, g.Height - 1)
		  End If
		  If mHasLeftBorder Then
		    g.DrawLine(0, 0, 0, g.Height)
		  End If
		  If mHasRightBorder Then
		    g.DrawLine(g.Width - 1, 0, g.Width - 1, g.Height)
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 496D6D6564696174656C7920696E76616C6964617465732074686520656E746972652063616E76617320616E6420726564726177732E
		Sub Redraw()
		  /// Immediately invalidates the entire canvas and redraws.
		  
		  NeedsFullRedraw = True
		  
		  Refresh(True)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52656472617773206F6E6C79207468652076697369626C65206469727479206C696E6573206F6E746F207468652063616E7661732E20417373756D6573207468617420606760206973207468652063616E76617327206772617068696373206F626A6563742066726F6D20746865205061696E74206576656E742E
		Private Sub RedrawDirtyLines(g As Graphics)
		  /// Redraws only the visible dirty lines onto the canvas.
		  /// Assumes that `g` is the canvas' graphics object from the Paint event.
		  
		  #Pragma Warning "TODO"
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 526564726177732074686520656E746972652063616E7661732E20417373756D6573207468617420606760206973207468652063616E76617327206772617068696373206F626A6563742066726F6D20746865205061696E74206576656E742E
		Private Sub RedrawEverything(g As Graphics)
		  /// Redraws the entire canvas.
		  /// Assumes that `g` is the canvas' graphics object from the Paint event.
		  
		  #Pragma Warning "TODO"
		  
		  // Editor background.
		  g.DrawingColor = BackgroundColor
		  g.FillRectangle(0, 0, g.Width, g.Height)
		  
		  DrawCanvasBorders(g)
		  
		  
		End Sub
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0, Description = 54686520656469746F722773206261636B67726F756E6420636F6C6F75722E
		#tag Getter
			Get
			  Return mBackgroundColor
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If mBackgroundColor = value Then Return
			  
			  mBackgroundColor = value
			  
			  Redraw
			  
			End Set
		#tag EndSetter
		BackgroundColor As ColorGroup
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0, Description = 54686520656469746F72277320626F7264657220636F6C6F75722E
		#tag Getter
			Get
			  Return mBorderColor
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If mBorderColor = value Then Return
			  
			  mBorderColor = value
			  
			  Redraw
			  
			End Set
		#tag EndSetter
		BorderColor As ColorGroup
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0, Description = 54686520666F6E742066616D696C79206F662074686520746578742E
		#tag Getter
			Get
			  Return mFontName
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If mFontName = value Then Return
			  
			  mFontName = value
			  
			  Redraw
			  
			End Set
		#tag EndSetter
		FontName As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0, Description = 49662054727565207468656E2074686520656469746F722077696C6C2068617665206120626F74746F6D20626F726465722E
		#tag Getter
			Get
			  Return mHasBottomBorder
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mHasBottomBorder = value
			  
			  Redraw
			End Set
		#tag EndSetter
		HasBottomBorder As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0, Description = 49662054727565207468656E2074686520656469746F722077696C6C20686176652061206C65667420626F726465722E
		#tag Getter
			Get
			  Return mHasLeftBorder
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mHasLeftBorder = value
			  
			  Redraw
			  
			End Set
		#tag EndSetter
		HasLeftBorder As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0, Description = 49662054727565207468656E2074686520656469746F722077696C6C2068617665206120726967687420626F726465722E
		#tag Getter
			Get
			  Return mHasRightBorder
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mHasRightBorder = value
			  
			  Redraw
			  
			End Set
		#tag EndSetter
		HasRightBorder As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0, Description = 49662054727565207468656E2074686520656469746F722077696C6C2068617665206120746F7020626F726465722E
		#tag Getter
			Get
			  Return mHasTopBorder
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mHasTopBorder = value
			  
			  Redraw
			  
			End Set
		#tag EndSetter
		HasTopBorder As Boolean
	#tag EndComputedProperty

	#tag Property, Flags = &h21, Description = 547261636B73207768696368206C696E65732061726520696E76616C696420616E64207265717569726520726564726177696E672E204B6579203D206C696E6520696E6465782C2056616C7565203D20426F6F6C65616E2E
		Private InvalidLines As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 54686520656469746F722773206261636B67726F756E6420636F6C6F75722E204261636B7320604261636B67726F756E64436F6C6F72602E
		Private mBackgroundColor As ColorGroup
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 54686520656469746F72277320626F7264657220636F6C6F75722E204261636B732060426F72646572436F6C6F72602E
		Private mBorderColor As ColorGroup
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 54686520666F6E742066616D696C79206F662074686520746578742E
		Private mFontName As String
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 49662054727565207468656E2074686520656469746F722077696C6C2068617665206120626F74746F6D20626F726465722E204261636B732060486173426F74746F6D426F72646572602E
		Private mHasBottomBorder As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 49662054727565207468656E2074686520656469746F722077696C6C20686176652061206C65667420626F726465722E204261636B7320604861734C656674426F72646572602E
		Private mHasLeftBorder As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 49662054727565207468656E2074686520656469746F722077696C6C2068617665206120726967687420626F726465722E204261636B7320604861735269676874426F72646572602E
		Private mHasRightBorder As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 49662054727565207468656E2074686520656469746F722077696C6C2068617665206120746F7020626F726465722E204261636B732060486173546F70426F72646572602E
		Private mHasTopBorder As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 4261636B696E672073746F726520666F72207468652060526561644F6E6C796020636F6D70757465642070726F70657274792E
		Private mReadOnly As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 5468652064656661756C7420636F6C6F757220746F2075736520666F7220746578742E204261636B73206054657874436F6C6F72602E
		Private mTextColor As ColorGroup
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 54686520746578742073697A652E
		Private mTextSize As Integer
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 49662054727565207468656E2074686520656469746F722077696C6C207265647261772065766572797468696E6720696E20746865206E65787420605061696E7460206576656E742E
		NeedsFullRedraw As Boolean = True
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0, Description = 49662054727565207468656E207468652063616E76617320697320726561642D6F6E6C792028692E652E206E6F74206564697461626C65292E
		#tag Getter
			Get
			  Return mReadOnly
			  
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mReadOnly = value
			  
			End Set
		#tag EndSetter
		ReadOnly As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0, Description = 5468652064656661756C7420636F6C6F757220746F2075736520666F7220746578742E
		#tag Getter
			Get
			  Return mTextColor
			  
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If mTextColor = value Then Return
			  
			  mTextColor = value
			  
			  Redraw
			  
			End Set
		#tag EndSetter
		TextColor As ColorGroup
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0, Description = 54686520746578742073697A652E
		#tag Getter
			Get
			  Return mTextSize
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If mTextSize = value Then Return
			  
			  mTextSize = value
			  
			  Redraw
			  
			End Set
		#tag EndSetter
		TextSize As Integer
	#tag EndComputedProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="Integer"
			EditorType="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue=""
			Type="Integer"
			EditorType="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue=""
			Type="Integer"
			EditorType="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Width"
			Visible=true
			Group="Position"
			InitialValue="100"
			Type="Integer"
			EditorType="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Height"
			Visible=true
			Group="Position"
			InitialValue="100"
			Type="Integer"
			EditorType="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockLeft"
			Visible=true
			Group="Position"
			InitialValue=""
			Type="Boolean"
			EditorType="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockTop"
			Visible=true
			Group="Position"
			InitialValue=""
			Type="Boolean"
			EditorType="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockRight"
			Visible=true
			Group="Position"
			InitialValue=""
			Type="Boolean"
			EditorType="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockBottom"
			Visible=true
			Group="Position"
			InitialValue=""
			Type="Boolean"
			EditorType="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabPanelIndex"
			Visible=false
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabIndex"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabStop"
			Visible=true
			Group="Position"
			InitialValue="True"
			Type="Boolean"
			EditorType="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="InitialParent"
			Visible=false
			Group="Position"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Visible"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			EditorType="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Tooltip"
			Visible=false
			Group="Appearance"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="AutoDeactivate"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			EditorType="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Enabled"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			EditorType="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="BackgroundColor"
			Visible=true
			Group="Appearance"
			InitialValue=""
			Type="ColorGroup"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="BorderColor"
			Visible=true
			Group="Appearance"
			InitialValue=""
			Type="ColorGroup"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="HasBottomBorder"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="HasLeftBorder"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="HasRightBorder"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="HasTopBorder"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="FontName"
			Visible=true
			Group="Appearance"
			InitialValue="System"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TextColor"
			Visible=true
			Group="Appearance"
			InitialValue=""
			Type="ColorGroup"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="TextSize"
			Visible=true
			Group="Appearance"
			InitialValue="12"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ReadOnly"
			Visible=true
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="NeedsFullRedraw"
			Visible=false
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass