local TweenService = game:GetService("TweenService")
local DebrisService = game:GetService("Debris")
local remoteEvents = game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Events")
local remoteFunctions = game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Functions")
local soundEffects = game.ReplicatedStorage:WaitForChild("SoundEffects")
local configurations = game.ReplicatedStorage:WaitForChild("Configurations")
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local spectateButton = playerGui:WaitForChild("UI"):WaitForChild("Left"):WaitForChild("SpectateButton")
local trollsButton = playerGui:WaitForChild("UI"):WaitForChild("Right"):WaitForChild("TrollsButton")
local frame = playerGui:WaitForChild("UI"):WaitForChild("Spectate")
local previousButton = frame:WaitForChild("Previous")
local nextButton = frame:WaitForChild("Next")
local label = frame:WaitForChild("Username")
local skipFriendButton = frame:WaitForChild("SkipAFriendButton")
local camera = workspace.CurrentCamera
local animationInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local expanded = UDim2.new(0.106, 0, 0.064, 0)
local collapsed = UDim2.new(0, 0, 0, 0)
local visible = false
local visible2 = false
local spectateIndex = nil
local players = {}

frame.Size = collapsed
frame.Visible = true
label.Text = "No one"

local function updatePlayers()

	players = {}

	for _, v in game.Players:GetPlayers() do
		if v ~= player and v.Character and v.Character:FindFirstChild("Humanoid") then
			table.insert(players, v)
		end
	end

end

local function spectate(index)

	updatePlayers()

	if #players == 0 then
		camera.CameraSubject = player.Character and player.Character:FindFirstChild("Humanoid")
		label.Text = "No one"
		return
	end

	spectateIndex = ((index - 1) % #players) + 1

	local target = players[spectateIndex]

	if target.Character and target.Character:FindFirstChild("Humanoid") then
		camera.CameraSubject = target.Character.Humanoid
		label.Text = target.Name
	end

	target.CharacterAdded:Connect(function(character)

		task.wait(0.1)

		local humanoid = character:FindFirstChild("Humanoid")

		if humanoid and spectateIndex then
			camera.CameraSubject = humanoid
		end

	end)

end

local function stopSpectating()

	spectateIndex = nil

	if player.Character and player.Character:FindFirstChild("Humanoid") then
		camera.CameraSubject = player.Character.Humanoid
	end

	label.Text = "No one"

end

previousButton.MouseButton1Click:Connect(function()
	
	local sound = soundEffects.UIButtonPress:Clone()
	sound.Parent = game.SoundService
	sound:Play()
	DebrisService:AddItem(sound, sound.TimeLength + 1)
	
	spectate((spectateIndex or 2) - 1)
	
end)

nextButton.MouseButton1Click:Connect(function()
	
	local sound = soundEffects.UIButtonPress:Clone()
	sound.Parent = game.SoundService
	sound:Play()
	DebrisService:AddItem(sound, sound.TimeLength + 1)
	
	spectate((spectateIndex or 0) + 1)
	
end)

spectateButton.MouseButton1Click:Connect(function()
	
	frame.HeaderText.Text = "Spectating:"
	
	local sound = soundEffects.UIButtonPress:Clone()
	sound.Parent = game.SoundService
	sound:Play()
	DebrisService:AddItem(sound, sound.TimeLength + 1)
	
	local target = visible and collapsed or expanded
	local expandTween = TweenService:Create(frame, animationInfo, {Size = target})
	
	if visible == true then
		stopSpectating()
	else
		spectate(1)
	end

	expandTween:Play()
	
	visible = not visible
	visible2 = false
	
end)

trollsButton.MouseButton1Click:Connect(function()
	
	frame.HeaderText.Text = "Trolling:"

	local target = visible2 and collapsed or expanded
	local expandTween = TweenService:Create(frame, animationInfo, {Size = target})

	if visible2 == true then
		stopSpectating()
	else
		spectate(1)
	end

	expandTween:Play()

	visible2 = not visible2
	visible = false

end)

skipFriendButton.MouseButton1Click:Connect(function()

	for name, value in ipairs(configurations.NPCLocations:GetAttributes()) do
		if stageData == value then
			return
		end
	end
	
	local targetData = remoteFunctions.GetPlayerProfileData:InvokeServer(player, label.Text)

	if targetData.Stage == configurations.BiomeEnd:GetAttribute(configurations.LastBiome:GetAttribute("LastBiome")) then
		game.StarterGui:SetCore("SendNotification", {Title = "Can't Buy", Text = "This player has already beaten the obby!", Icon = "rbxassetid://131995891560028"})
		return
	end

	local sound = soundEffects.UIButtonPress:Clone()
	sound.Parent = game.SoundService
	sound:Play()
	DebrisService:AddItem(sound, sound.TimeLength + 1)

	if player.Character then
		if player.Character:FindFirstChild("HumanoidRootPart") then
			remoteEvents.DeveloperProductPurchaseRequest:FireServer("SkipAFriend")
		end
	end

end)
