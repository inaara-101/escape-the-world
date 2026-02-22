local player = game.Players.LocalPlayer

local function touchingPlayer(part)
	for _, v in part:GetTouchingParts() do
		if v.Parent == player.Character then
			return true
		end
	end
end

for _, v in workspace:GetDescendants() do
	if v.Name == "ElevatorPart" then
		
		v.CanCollide = false
		
		v.Touched:Connect(function(hit)
			if hit.Parent == player.Character then
				
				local hrp = player.Character:FindFirstChild("HumanoidRootPart")
				
				if hrp then
					
					local elevatorVelocity = Instance.new("BodyVelocity")
					elevatorVelocity.Velocity = Vector3.new(0, v.Speed.Value, 0)
					elevatorVelocity.MaxForce = Vector3.new(0, 1000000, 0)
					elevatorVelocity.Parent = hrp
					
					while touchingPlayer(v) do
						task.wait()
					end
					
					elevatorVelocity:Destroy()
					
				end
				
			end
		end)
		
	end
end
