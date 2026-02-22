local TweenService = game:GetService("TweenService")
local DebrisService = game:GetService("Debris")
local configurations = game.ReplicatedStorage:WaitForChild("Configurations")
local remoteEvents = game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Events")
local soundEffects = game.ReplicatedStorage:WaitForChild("SoundEffects")
local templates = game.ReplicatedStorage:WaitForChild("Templates")
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local currentBiome = player:WaitForChild("CurrentBiome")
local frame = playerGui:WaitForChild("UI"):WaitForChild("BiomeTravel"):WaitForChild("Frame")
local scrollingFrame = frame:WaitForChild("ScrollingFrame")
local animationInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local collapseTween = TweenService:Create(frame, animationInfo, {Size = UDim2.new(0, 0, 0, 0)})
local sortedBiomes = {}
local currentStage

repeat task.wait() until player:WaitForChild("leaderstats"):WaitForChild("Stage").Value ~= 0

currentStage = player.leaderstats.Stage.Value

remoteEvents.SendStageData.OnClientEvent:Connect(function(newStage)
	currentStage = newStage
end)

for name, value in pairs(configurations.BiomeStart:GetAttributes()) do
	table.insert(sortedBiomes, {Name = name, Value = value})
end

table.sort(sortedBiomes, function(a, b)
	return a.Value < b.Value
end)

for _, biome in ipairs(sortedBiomes) do
	if currentStage >= biome.Value then
		
		local entry = templates.BiomeTravel:Clone()
		entry.Name = biome.Name
		entry.LayoutOrder = biome.Value
		entry.Biome.Text = biome.Name
		entry.Parent = scrollingFrame
		
		entry.GoButton.MouseButton1Click:Connect(function()
			
			local sound = soundEffects.UIButtonPress:Clone()
			sound.Parent = game.SoundService
			sound:Play()
			DebrisService:AddItem(sound, sound.TimeLength + 1)
			
			remoteEvents.BiomeTravelRequest:FireServer(biome.Value)
			
		end)
		
	end
end

remoteEvents.BiomeTravelConfirm.OnClientEvent:Connect(function(newStage, position)
	currentStage = newStage
	collapseTween:Play()
end)

currentBiome:GetPropertyChangedSignal("Value"):Connect(function()
	
	if currentStage >= configurations.BiomeStart:GetAttribute(currentBiome.Value) then
	
		local entry = templates.BiomeTravel:Clone()
		entry.Name = currentBiome.Name
		entry.LayoutOrder = configurations.BiomeStart:GetAttribute(currentBiome.Value)
		entry.Biome.Text = currentBiome.Name
		entry.Parent = scrollingFrame

		entry.GoButton.MouseButton1Click:Connect(function()

			local sound = soundEffects.UIButtonPress:Clone()
			sound.Parent = game.SoundService
			sound:Play()
			DebrisService:AddItem(sound, sound.TimeLength + 1)

			remoteEvents.BiomeTravelRequest:FireServer(currentBiome.Value)

		end)
		
	end	
	
end)
