for _, v in workspace:GetDescendants() do
	if v.Name == "ConveyorPart" then
		v.AssemblyLinearVelocity = Vector3.new(0, 0, v.Speed.Value)
	end
end
