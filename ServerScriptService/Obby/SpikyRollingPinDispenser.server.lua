local DebrisService = game:GetService("Debris")

for _, v in workspace:GetDescendants() do
	if v.Name == "SpikyRollingPinDispenser" then
		
		local dispenser = v.DispenserPart
		local template = game.ReplicatedStorage:WaitForChild("Obby"):WaitForChild("SpikyRollingPin")
		local speed = v.Speed 
		local lifespan = v.Lifespan
		local interval = v.Interval
		local direction = dispenser.CFrame.LookVector
		
		dispenser.Touched:Connect(function(hit)
			if hit.Parent then
				if hit.Parent:FindFirstChild("Humanoid") then
					if dispenser.BrickColor == BrickColor.new("Really red") then
						hit.Parent.Humanoid.Health = 0
					end
				end
			end
		end)
		
		task.spawn(function()
			
			while true do
			
				local rollingPin = template:Clone()
				rollingPin:SetPrimaryPartCFrame(dispenser.CFrame + Vector3.new(0, 0.5, 0))
				rollingPin.PrimaryPart.Velocity = Vector3.zero
				rollingPin.PrimaryPart.RotVelocity = Vector3.zero
				rollingPin.PrimaryPart.AssemblyLinearVelocity = direction.Unit * speed.Value
				rollingPin.Parent = workspace
				
				dispenser.BrickColor = BrickColor.new("Really red")
				
				task.wait(0.5)
				
				dispenser.BrickColor = BrickColor.new("Lime green")
				
				DebrisService:AddItem(rollingPin, lifespan.Value)
				
				task.wait(interval.Value)
				
			end	
			
		end)
		
	end
end
