for _, v in workspace:GetDescendants() do
	
	if v.Name == "SwingPart" then
		v.Anchored = false
	end
	
	if v.Name == "SwingBase" then
		v.RopeConstraint.Attachment0 = v.Attachment0
		v.RopeConstraint.Attachment1 = v.Parent.SwingPart.Attachment1
		v.Parent.SwingPart.SpringConstraint1.Attachment0 = v.Parent.SwingPart.Attachment01
		v.Parent.SwingPart.SpringConstraint1.Attachment1 = v.Attachment11
		v.Parent.SwingPart.SpringConstraint2.Attachment0 = v.Parent.SwingPart.Attachment02
		v.Parent.SwingPart.SpringConstraint2.Attachment1 = v.Attachment12
		v.Parent.SwingPart.SpringConstraint3.Attachment0 = v.Parent.SwingPart.Attachment03
		v.Parent.SwingPart.SpringConstraint3.Attachment1 = v.Attachment13
		v.Parent.SwingPart.SpringConstraint4.Attachment0 = v.Parent.SwingPart.Attachment04
		v.Parent.SwingPart.SpringConstraint4.Attachment1 = v.Attachment14
	end
	
end
