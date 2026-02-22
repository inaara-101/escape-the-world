local DebrisService = game:GetService("Debris")

for _, v in workspace:GetDescendants() do
	if v.Name == "RollingPinDispenser" then
		
		local dispenser = v.DispenserPart
		local template = game.ReplicatedStorage:WaitForChild("Obby"):WaitForChild("RollingPin")
		local speed = v.Speed 
		local lifespan = v.Lifespan
		local interval = v.Interval
		local direction = dispenser.CFrame.LookVector
		
		dispenser.Touched:Connect(function(hit)
			if hit and hit.Parent then
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
				rollingPin.CFrame = dispenser.CFrame + Vector3.new(0, 0.5, 0)
				rollingPin.Velocity = Vector3.zero
				rollingPin.RotVelocity = Vector3.zero
				rollingPin.AssemblyLinearVelocity = direction.Unit * speed.Value
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
