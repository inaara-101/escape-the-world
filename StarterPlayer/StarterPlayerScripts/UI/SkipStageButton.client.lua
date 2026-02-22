local DebrisService = game:GetService("Debris")
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local button = playerGui:WaitForChild("UI"):WaitForChild("Top"):WaitForChild("Frame"):WaitForChild("SkipStageButton")
local remoteEvents = game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Events")
local soundEffects = game.ReplicatedStorage:WaitForChild("SoundEffects")
local configurations = game.ReplicatedStorage:WaitForChild("Configurations")
local stageData

repeat task.wait() until player:WaitForChild("leaderstats"):WaitForChild("Stage").Value ~= nil

stageData = player.leaderstats.Stage.Value

remoteEvents.SendStageData.OnClientEvent:Connect(function(data)
	stageData = data
end)

button.MouseButton1Click:Connect(function()
	
	for name, value in ipairs(configurations.NPCLocations:GetAttributes()) do
		if stageData == value then
			return
		end
	end

	if stageData == configurations.BiomeEnd:GetAttribute(configurations.LastBiome:GetAttribute("LastBiome")) then
		game.StarterGui:SetCore("SendNotification", {Title = "Can't Buy", Text = "You're already at the end of the obby!", Icon = "rbxassetid://131995891560028"})
		return
	end
	
	local sound = soundEffects.UIButtonPress:Clone()
	sound.Parent = game.SoundService
	sound:Play()
	DebrisService:AddItem(sound, sound.TimeLength + 1)
	
	if player.Character then
		if player.Character:FindFirstChild("HumanoidRootPart") then
			remoteEvents.DeveloperProductPurchaseRequest:FireServer("SkipStage")
		end
	end
	
end)
