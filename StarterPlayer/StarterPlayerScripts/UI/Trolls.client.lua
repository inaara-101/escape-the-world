local TweenService = game:GetService("TweenService")
local DebrisService = game:GetService("Debris")
local remoteEvents = game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Events")
local remoteFunctions = game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Functions")
local soundEffects = game.ReplicatedStorage:WaitForChild("SoundEffects")
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local spectateButton = playerGui:WaitForChild("UI"):WaitForChild("Left"):WaitForChild("SpectateButton")
local trollsButton = playerGui:WaitForChild("UI"):WaitForChild("Right"):WaitForChild("TrollsButton")
local trollsFrame = playerGui:WaitForChild("UI"):WaitForChild("Trolls"):WaitForChild("Frame")
local notification = playerGui:WaitForChild("UI"):WaitForChild("Trolls"):WaitForChild("Notification")
local modeFrame = trollsFrame:WaitForChild("Mode")
local trollList = trollsFrame:WaitForChild("List")
local camera = workspace.CurrentCamera
local animationInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local expanded = UDim2.new(0.164, 0, 0.45, 0)
local collapsed = UDim2.new(0, 0, 0, 0)
local visible = false

trollsFrame.Size = collapsed
trollsFrame.Parent.Visible = true
modeFrame.CurrentMode.Value = "Player"
modeFrame.ModeText.Text = "(" .. string.upper(modeFrame.CurrentMode.Value) .. ")"

remoteEvents.Trolled.OnClientEvent:Connect(function(trollType, troller, troll)
	
	local oldMusicVolume = game.SoundService.Music.Volume
	
	if troll ~= "a jumpscare" and troll ~= "a freeze for 20 seconds" then
		local sound1 = soundEffects.Troll:Clone()
		sound1.Parent = game.SoundService
		sound1:Play()
		DebrisService:AddItem(sound1, sound1.TimeLength + 1)
	elseif troll == "a jumpscare" then
		
		game.SoundService.Music.Volume = 0
		
		local sound2 = soundEffects.Jumpscare:Clone()
		sound2.Parent = game.SoundService
		sound2:Play()
		DebrisService:AddItem(sound2, sound2.TimeLength + 1)
		
		task.delay(sound2.TimeLength, function()
			TweenService:Create(game.SoundService.Music, TweenInfo.new(4, Enum.EasingStyle.Linear), {Volume = oldMusicVolume}):Play()
		end)
		
	elseif troll == "a freeze for 20 seconds" then
		local sound3 = soundEffects.Freeze:Clone()
		sound3.Parent = game.SoundService
		sound3:Play()
		DebrisService:AddItem(sound3, sound3.TimeLength + 1)
	end
	
	if trollType == "player" then
		notification.Text = troller .. " just trolled you with " .. troll .. "!"
	elseif trollType == "server" then	
		notification.Text = troller .. " just trolled the entire server with " .. troll .. "!"
	end

	task.wait(0.5)
	notification.Visible = true
	task.wait(5)
	notification.Visible = false
	
end)

remoteEvents.TriggerEarthquake.OnClientEvent:Connect(function(duration)
	
	local s = tick()
	local humanoid = player.Character.Humanoid
	
	if not humanoid then
		return
	end
	
	while humanoid.Health > 0 and tick() - s < duration do
		
		local x = Random.new():NextNumber(-0.25, 0.25)
		local y = Random.new():NextNumber(-0.25, 0.25)
		local z = Random.new():NextNumber(-0.25, 0.25)

		humanoid.CameraOffset = Vector3.new(x, y, z)
		camera.CFrame *= CFrame.Angles(x / 5, y / 5, z / 5)

		task.wait()
		
	end
	
	humanoid.CameraOffset = Vector3.new(0, 0, 0)
	
end)

trollsButton.MouseButton1Click:Connect(function()

	local sound = soundEffects.UIButtonPress:Clone()
	sound.Parent = game.SoundService
	sound:Play()
	DebrisService:AddItem(sound, sound.TimeLength + 1)

	local target = visible and collapsed or expanded
	local expandTween = TweenService:Create(trollsFrame, animationInfo, {Size = target})

	expandTween:Play()

	visible = not visible

end)

trollsFrame:GetPropertyChangedSignal("Size"):Connect(function()
	if trollsFrame.Size == expanded then
		visible = true
	elseif trollsFrame.Size == collapsed then
		visible = false
	end
end)

spectateButton.MouseButton1Click:Connect(function()

	local target = collapsed
	local collapseTween = TweenService:Create(trollsFrame, animationInfo, {Size = target})

	collapseTween:Play()

	visible = false

end)

modeFrame.PlayerModeButton.MouseButton1Click:Connect(function()
	
	if modeFrame.CurrentMode.Value == "Player" then
		return
	end
	
	local sound = soundEffects.Switch:Clone()
	sound.Parent = game.SoundService
	sound:Play()
	DebrisService:AddItem(sound, sound.TimeLength + 1)
	
	modeFrame.CurrentMode.Value = "Player"
	
end)

modeFrame.ServerModeButton.MouseButton1Click:Connect(function()
	
	if modeFrame.CurrentMode.Value == "Server" then
		return
	end
	
	local sound = soundEffects.Switch:Clone()
	sound.Parent = game.SoundService
	sound:Play()
	DebrisService:AddItem(sound, sound.TimeLength + 1)
	
	modeFrame.CurrentMode.Value = "Server"
	
end)

modeFrame.CurrentMode:GetPropertyChangedSignal("Value"):Connect(function()
	modeFrame.ModeText.Text = "(" .. string.upper(modeFrame.CurrentMode.Value) .. ")"
end)

for _, imageButton in pairs(trollList:GetChildren()) do
	if imageButton:IsA("ImageButton") then
		
		if imageButton.ButtonText.Text == "Troll Name" then
			imageButton.ButtonText.Text = imageButton.Name
		end
		
		imageButton.MouseButton1Click:Connect(function()

			local sound = soundEffects.UIButtonPress:Clone()
			sound.Parent = game.SoundService
			sound:Play()
			DebrisService:AddItem(sound, sound.TimeLength + 1)

			remoteEvents.DeveloperProductPurchaseRequest:FireServer(modeFrame.CurrentMode.Value .. imageButton.Name)

		end)
		
	end
end
