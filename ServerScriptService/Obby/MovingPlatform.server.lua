for _, v in workspace:GetDescendants() do
	if v.Name == "MovingPart" then
		
		v.Anchored = false
		
		task.spawn(function()
		
			local startPosition = v.Parent.Start.Position
			local endPosition = v.Parent.End.Position
			
			v.AlignPosition.MaxVelocity = v.Speed.Value
			v.AlignPosition.Attachment0 = v.Attachment
			v.AlignPosition.Position = startPosition
			
			task.wait(5)

			while true do
				
				v.AlignPosition.Position = endPosition
				v.AlignOrientation.CFrame = CFrame.lookAt(v.Position, endPosition) * CFrame.Angles(0, math.rad(180), 0)
				
				repeat task.wait() until (v.Position - endPosition).Magnitude <= 5
				task.wait(2)
				
				v.AlignPosition.Position = startPosition
				v.AlignOrientation.CFrame = CFrame.lookAt(v.Position, startPosition) * CFrame.Angles(0, math.rad(180), 0)
				
				repeat task.wait() until (v.Position - startPosition).Magnitude <= 5
				task.wait(2)
				
			end
		
		end)
	end
end
