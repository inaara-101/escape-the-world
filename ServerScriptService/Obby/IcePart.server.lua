for _, v in workspace:GetDescendants() do
	if v.Name == "IcePart" then
		v.CustomPhysicalProperties = PhysicalProperties.new(0.919, 0, 0.15, v.Power.Value, 1)
	end
end
