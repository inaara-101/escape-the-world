local remoteEvents = game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Events")
local checkpoints = workspace:WaitForChild("Checkpoints")
local player = game.Players.LocalPlayer
local stage = player:WaitForChild("leaderstats"):WaitForChild("Stage")
local playerGui = player:WaitForChild("PlayerGui")
local stageSelector = playerGui:WaitForChild("UI"):WaitForChild("Top"):WaitForChild("Frame"):WaitForChild("StageSelector")
local left1 = stageSelector:WaitForChild("Left1")
local left10 = stageSelector:WaitForChild("Left10")
local right1 = stageSelector:WaitForChild("Right1")
local right10 = stageSelector:WaitForChild("Right10")
local text = stageSelector:WaitForChild("StageNumber")
local debounce = false
local stageData
local currentStage

local function updateVisibility()
	left1.Visible = currentStage > 1
	left10.Visible = currentStage > 10
	right1.Visible = currentStage < stageData
	right10.Visible = currentStage <= stageData - 10
end

remoteEvents.SendStageData.OnClientEvent:Connect(function(maxStage)
	
	stageData = maxStage
	repeat task.wait() until stage.Value ~= nil
	
	currentStage = stage.Value 
	text.Text = "STAGE " .. currentStage
	updateVisibility()
	
end)

remoteEvents.StageSelectorConfirm.OnClientEvent:Connect(function(newStage)
	currentStage = newStage
	text.Text = "STAGE " .. currentStage
	updateVisibility()
	task.wait(0.2)
	debounce = false
end)

remoteEvents.BiomeTravelConfirm.OnClientEvent:Connect(function(newStage)
	currentStage = newStage
	text.Text = "STAGE " .. currentStage
	updateVisibility()
	debounce = false
end)

left1.MouseButton1Click:Connect(function()
	
	if debounce == true or currentStage <= 1 then
		return
	end
	
	debounce = true
	remoteEvents.StageSelectorRequest:FireServer(currentStage - 1)
	
end)

left10.MouseButton1Click:Connect(function()
	
	if debounce == true or currentStage <= 10 then
		return
	end
	
	debounce = true
	remoteEvents.StageSelectorRequest:FireServer(currentStage - 10)
	
end)

right1.MouseButton1Click:Connect(function()
	
	if debounce == true or currentStage >= stageData then
		return
	end
	
	debounce = true
	remoteEvents.StageSelectorRequest:FireServer(currentStage + 1)
	
end)

right10.MouseButton1Click:Connect(function()
	
	if debounce == true or currentStage > stageData - 10 then
		return
	end
	
	debounce = true
	remoteEvents.StageSelectorRequest:FireServer(currentStage + 10)
	
end)
