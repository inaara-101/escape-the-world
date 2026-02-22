local TweenService = game:GetService("TweenService")

local function tween(object, seconds, goal)
	local tween = TweenService:Create(object, TweenInfo.new(seconds), goal)
	tween:Play()
end

for _, v in workspace:GetDescendants() do
	if v.Name == "FallingPart" then
		
		local texture = v.Texture
		local originalCFrame = v.CFrame
		
		v:SetAttribute("Triggered", false)
		
		v.Touched:Connect(function(hit)
			
			if v:GetAttribute("Triggered") == true then
				return
			end
			
			if hit.Parent:FindFirstChild("Humanoid") then
				
				v:SetAttribute("Triggered", true)
				
				task.wait(0.3)
				
				v.Anchored = false
				tween(v, 1.5, {Transparency = 1})
				tween(texture, 1.5, {Transparency = 1})
				
				task.wait(4.5)
				
				v.Anchored = true
				v.CFrame = originalCFrame
				v.Velocity = Vector3.zero
				v.RotVelocity = Vector3.zero
				v.Transparency = 1
				texture.Transparency = 1
				tween(v, 1.5, {Transparency = 0})
				tween(texture, 1.5, {Transparency = 0.92})
				v:SetAttribute("Triggered", false)
				
			end
			
		end)
		
	end
end
