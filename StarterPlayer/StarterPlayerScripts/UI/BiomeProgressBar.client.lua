local remoteEvents = game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Events")
local configurations = game.ReplicatedStorage:WaitForChild("Configurations")
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local progressBar = playerGui:WaitForChild("UI"):WaitForChild("Top"):WaitForChild("Frame"):WaitForChild("BiomeProgressBar")
local fill = progressBar:WaitForChild("Container"):WaitForChild("Fill")
local currentIcon = progressBar:WaitForChild("CurrentIcon")
local nextIcon = progressBar:WaitForChild("NextIcon")
local currentBiome = player:WaitForChild("CurrentBiome")
local currentStage

repeat task.wait() until player:WaitForChild("leaderstats"):WaitForChild("Stage").Value ~= 0

currentStage = player.leaderstats.Stage.Value

local function updateProgressBar(stage)
	
	currentStage = stage

	local progress = currentStage - configurations.BiomeStart:GetAttribute(currentBiome.Value)
	local total = configurations.BiomeLength:GetAttribute(currentBiome.Value)
	local percent = math.clamp(progress / total, 0, 1)
	local nextBiome = nil
	local nextStage = math.huge

	for name, value in pairs(configurations.BiomeEnd:GetAttributes()) do
		if name ~= currentBiome.Value and value > currentStage and value < nextStage then
			nextBiome = name
			nextStage = value
		end
	end

	currentIcon.Image = configurations.BiomeIcons:GetAttribute(currentBiome.Value) or ""
	nextIcon.Image = nextBiome and configurations.BiomeIcons:GetAttribute(nextBiome) or ""
	fill:TweenSize(UDim2.new(percent, 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.25, true)
	
end

updateProgressBar(currentStage)
remoteEvents.SendStageData.OnClientEvent:Connect(updateProgressBar)
