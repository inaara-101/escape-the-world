local TweenService = game:GetService("TweenService")
local tweenInfo = TweenInfo.new(40, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1, false, 0)

for _, v in workspace:GetDescendants() do
	if v.Name == "LavaPart" then
		for _, vv in v:GetChildren() do
			
			if vv:IsA("MeshPart") then
				
				vv.CanCollide = false
				
				if vv.Name == "Layer2" then
					vv.CanCollide = true
				end
				
				vv.Touched:Connect(function(hit)
					if hit and hit.Parent then
						if hit.Parent:FindFirstChild("Humanoid") then
							hit.Parent.Humanoid.Health = 0
						end
					end
				end)
				
			end
			
			if vv.Name == "Layer3" then
				for _, vvv in vv:GetChildren() do
					if vvv:IsA("Texture") then
						task.spawn(function()
						
							local tween1 = TweenService:Create(vvv, tweenInfo, {OffsetStudsU = 100})
							local tween2 = TweenService:Create(vvv, tweenInfo, {OffsetStudsV = 100})
							
							tween1:Play()
							tween2:Play()
						
						end)
					end
				end
			end 
			
		end
	end
end
