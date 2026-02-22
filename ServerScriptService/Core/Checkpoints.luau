local dataManager = require(game.ServerScriptService:WaitForChild("Core"):WaitForChild("DataManager"))
local configurations = game.ReplicatedStorage:WaitForChild("Configurations")

for _, v in workspace.Checkpoints:GetChildren() do

	local stage = tonumber(v.Name)

	if stage <= configurations.BiomeEnd:GetAttribute("Grassland") then
		v:SetAttribute("Biome", "Grassland")
	elseif stage <= configurations.BiomeEnd:GetAttribute("Cave") then
		v:SetAttribute("Biome", "Cave")
	elseif stage <= configurations.BiomeEnd:GetAttribute("Desert") then
		v:SetAttribute("Biome", "Desert")
	elseif stage <= configurations.BiomeEnd:GetAttribute("Arctic") then
		v:SetAttribute("Biome", "Arctic")
	elseif stage <= configurations.BiomeEnd:GetAttribute("Underworld") then
		v:SetAttribute("Biome", "Underworld")
	elseif stage <= configurations.BiomeEnd:GetAttribute("Ocean") then
		v:SetAttribute("Biome", "Ocean")	
	end

end

for _, v in workspace.Checkpoints:GetDescendants() do
	if v:IsA("BasePart") then
		v.Touched:Connect(function(hit)
			if hit.Parent:FindFirstChild("Humanoid") then
				
				local player = game.Players:GetPlayerFromCharacter(hit.Parent)
				
				if player then
					
					local profile = dataManager.Profiles[player]
					local stage = player.leaderstats.Stage
					
					if not profile then
						return
					end
					
					if tonumber(v.Parent.Name) ~= stage.Value then
						local newStage = tonumber(v.Parent.Name)
						dataManager:UpdateStage(player, newStage)
					end
					
					local currentBiome = player:FindFirstChild("CurrentBiome")
					local checkpointBiome = v.Parent:GetAttribute("Biome")

					dataManager:UpdateBiome(player, checkpointBiome)
	
				end
				
			end
		end)
	end
end
