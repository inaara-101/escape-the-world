local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")
local DebrisService = game:GetService("Debris")
local remoteEvents = game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Events")
local remoteFunctions = game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Functions")
local soundEffects = game.ReplicatedStorage:WaitForChild("SoundEffects")
local configurations = game.ReplicatedStorage:WaitForChild("Configurations")
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local freeSkips = player:WaitForChild("FreeSkips")
local freeskipsButton = playerGui:WaitForChild("UI"):WaitForChild("Top"):WaitForChild("Frame"):WaitForChild("FreeSkipsButton")
local frame = playerGui:WaitForChild("UI"):WaitForChild("FreeSkips"):WaitForChild("Frame")
local xButton = frame:WaitForChild("XButton")
local useButton = frame:WaitForChild("UseButton")
local timeBar = frame:WaitForChild("TimeLeftBar")
local fill = timeBar:WaitForChild("Fill")
local label = timeBar:WaitForChild("BarText")
local lockEffect = timeBar:WaitForChild("LockEffect")
local verifyButton = lockEffect:WaitForChild("VerifyButton")
local animationInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local expanded = UDim2.new(0.461, 0, 0.522, 0)
local collapsed = UDim2.new(0, 0, 0, 0)
local visible = false
local group = 36007084
local timer = 1800
local timeLeft = 1800
local lastSent = 0
local stageData 

repeat task.wait() until player:WaitForChild("leaderstats"):WaitForChild("Stage").Value ~= nil

stageData = player.leaderstats.Stage.Value

frame.Size = collapsed
frame.Parent.Visible = true

freeskipsButton.MouseButton1Click:Connect(function()

	local sound = soundEffects.UIButtonPress:Clone()
	sound.Parent = game.SoundService
	sound:Play()
	DebrisService:AddItem(sound, sound.TimeLength + 1)

	local target = visible and collapsed or expanded
	local expandTween = TweenService:Create(frame, animationInfo, {Size = target})

	expandTween:Play()

	visible = not visible

end)

xButton.MouseButton1Click:Connect(function()

	local sound = soundEffects.UIButtonPress:Clone()
	sound.Parent = game.SoundService
	sound:Play()
	DebrisService:AddItem(sound, sound.TimeLength + 1)

	local target = collapsed
	local collapseTween = TweenService:Create(frame, animationInfo, {Size = target})

	collapseTween:Play()

	visible = false

end)

frame:GetPropertyChangedSignal("Size"):Connect(function()
	if frame.Size == expanded then
		visible = true
	elseif frame.Size == collapsed then
		visible = false
	end
end)

local function formatTime(seconds)
	
	local m = math.floor(seconds / 60)
	local s = seconds % 60
	
	return string.format("%dm %ds", m, s)
	
end

local function startTimer(remaining)

	local endTick = tick() + remaining
	
	local function updateTimer()
		
		local newRemaining = math.max(0, endTick - tick())
		local ratio = newRemaining / 1800
		
		timeLeft = newRemaining
		
		fill:TweenSize(UDim2.new(ratio, 0, 1, 0))
		label.Text = "Next Skip Available: " .. formatTime(math.floor(newRemaining))
		
		if tick() - lastSent >= 1 then
			remoteEvents.UpdateFreeSkipTimeLeft:FireServer(math.floor(newRemaining))
			lastSent = tick()
		end
		
		if newRemaining <= 0 then

			RunService:UnbindFromRenderStep("FreeSkipTimer")

			task.wait(0.2)

			local success, newResult = pcall(function()
				return remoteFunctions.GetFreeSkipTimeLeft:InvokeServer()
			end)

			if success and type(newResult) == "number" and newResult > 0 then
				startTimer(newResult)
			else
				startTimer(60)
			end
			
		end
		
	end

	RunService:BindToRenderStep("FreeSkipTimer", Enum.RenderPriority.Last.Value, updateTimer)
	
end

if player:IsInGroup(group) then
	lockEffect.Visible = false
end

verifyButton.MouseButton1Click:Connect(function()
	
	local sound = soundEffects.UIButtonPress:Clone()
	sound.Parent = game.SoundService
	sound:Play()
	DebrisService:AddItem(sound, sound.TimeLength + 1)
	
	TeleportService:Teleport(game.PlaceId, player)
	verifyButton.ButtonText.Text = "..."
	
	TeleportService.TeleportInitFailed:Connect(function()
		verifyButton.ButtonText.Text = "FAILED"
		task.wait(3)
		verifyButton.ButtonText.Text = "VERIFY"
	end)
	
end)

remoteEvents.UpdateFreeSkips.OnClientEvent:Connect(function(amount)
	useButton.ButtonText.Text = "Use (" .. amount .. ")"
end)

useButton.MouseButton1Click:Connect(function()
	if freeSkips.Value > 0 then
		
		for name, value in ipairs(configurations.NPCLocations:GetAttributes()) do
			if stageData == value then
				return
			end
		end

		if stageData == configurations.BiomeEnd:GetAttribute(configurations.LastBiome:GetAttribute("LastBiome")) then
			return
		end
	
		local sound = soundEffects.UIButtonPress:Clone()
		sound.Parent = game.SoundService
		sound:Play()
		DebrisService:AddItem(sound, sound.TimeLength + 1)

		local target = collapsed
		local collapseTween = TweenService:Create(frame, animationInfo, {Size = target})

		collapseTween:Play()

		visible = false
		
		if player.Character then
			if player.Character:FindFirstChild("HumanoidRootPart") then
				remoteEvents.FreeSkipUsed:FireServer()
			end
		end
	
	end
end)

local success, result = pcall(function()
	return remoteFunctions.GetFreeSkipTimeLeft:InvokeServer()
end)

if success and type(result) == "number" and result > 0 then
	timer = result
else
	timer = 1800
end

startTimer(timer)
