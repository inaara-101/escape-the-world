for _, v in workspace:GetDescendants() do
	if v:IsA("BasePart") and v.Name == "DamagePart" then
		v.Touched:Connect(function(hit)
			if hit then
				if hit.Parent then
					if hit.Parent:FindFirstChild("Humanoid") then

						local player = game.Players:GetPlayerFromCharacter(hit.Parent)

						if player:FindFirstChild("Invincibility").Value == true then
							return
						end

						if hit.Parent:FindFirstChild("Humanoid") then
							hit.Parent.Humanoid.Health -= 10
						end

					end	
				end
			end
		end)
	end
end
