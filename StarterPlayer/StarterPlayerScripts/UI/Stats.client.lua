local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local DebrisService = game:GetService("Debris")
local remoteEvents = game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Events")
local soundEffects = game.ReplicatedStorage:WaitForChild("SoundEffects")
local configurations = game.ReplicatedStorage:WaitForChild("Configurations")
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local statsButton = playerGui:WaitForChild("UI"):WaitForChild("BottomRight"):WaitForChild("StatsButton")
local stats = playerGui:WaitForChild("UI"):WaitForChild("Stats"):WaitForChild("Frame")
local xButton = stats:WaitForChild("XButton") 
local statsContainer = stats:WaitForChild("Container")
local characterViewport = statsContainer:WaitForChild("CharacterViewport")
local statsList = statsContainer:WaitForChild("List")
local stage = player:WaitForChild("leaderstats"):WaitForChild("Stage")
local timePlayed = player:WaitForChild("TimePlayed")
local trollsBought = player:WaitForChild("TrollsBought")
local animationInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local expanded = UDim2.new(0.461, 0, 0.522, 0)
local collapsed = UDim2.new(0, 0, 0, 0)
local visible = false

local function formatTime(seconds)
	local hours = math.floor(seconds / 3600)
	local minutes = math.floor((seconds % 3600) / 60)
	return string.format("%dh %dm", hours, minutes)
end

local function updateProgressBar(progress)
	
	local total = nil
	
	for name, value in pairs(configurations.BiomeEnd:GetAttributes()) do
		if total == nil or value > total then
			total = value
		end
	end
	
	local percent = math.clamp(progress / total, 0, 1)
	
	statsList.ObbyProgressBar.Bar.Fill:TweenSize(UDim2.new(percent, 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.25, true)
	statsList.ObbyProgressBar.BarText.Text = math.floor(percent * 100) .. "% Complete"
	
end

stats.Size = collapsed
stats.Parent.Visible = true

statsButton.MouseButton1Click:Connect(function()
	
	local sound = soundEffects.UIButtonPress:Clone()
	sound.Parent = game.SoundService
	sound:Play()
	DebrisService:AddItem(sound, sound.TimeLength + 1)
	
	local target = visible and collapsed or expanded
	local expandTween = TweenService:Create(stats, animationInfo, {Size = target})
	
	expandTween:Play()
	
	visible = not visible
	
end)

xButton.MouseButton1Click:Connect(function()
	
	local sound = soundEffects.UIButtonPress:Clone()
	sound.Parent = game.SoundService
	sound:Play()
	DebrisService:AddItem(sound, sound.TimeLength + 1)
	
	local target = collapsed
	local collapseTween = TweenService:Create(stats, animationInfo, {Size = target})
	
	collapseTween:Play()
	
	visible = false
	
end)

local content, isReady = game.Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
characterViewport.Headshot.Image = content
characterViewport.Username.Text = player.Name

remoteEvents.UpdateTimePlayed.OnClientEvent:Connect(function(s)
	statsList.TimePlayed.StatText.Text = formatTime(s)
end)

timePlayed:GetPropertyChangedSignal("Value"):Connect(function()
	statsList.TimePlayed.StatText.Text = formatTime(timePlayed.Value)
end)

statsList.StagesCompleted.StatText.Text = tostring(stage.Value - 1)

remoteEvents.SendStageData.OnClientEvent:Connect(function(profileStage)
	statsList.StagesCompleted.StatText.Text = tostring(profileStage - 1)
end)

remoteEvents.UpdateTrollsBought.OnClientEvent:Connect(function(amount)
	statsList.TrollsBought.StatText.Text = tostring(amount)
end)

trollsBought:GetPropertyChangedSignal("Value"):Connect(function()
	statsList.TrollsBought.StatText.Text = tostring(trollsBought.Value)
end)

updateProgressBar(stage.Value)
remoteEvents.SendStageData.OnClientEvent:Connect(updateProgressBar)
