local UserInputService = game:GetService("UserInputService")
local MarketplaceService = game:GetService("MarketplaceService")
local TweenService = game:GetService("TweenService")
local DebrisService = game:GetService("Debris")
local remoteEvents = game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Events")
local soundEffects = game.ReplicatedStorage:WaitForChild("SoundEffects")
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local settingsButton = playerGui:WaitForChild("UI"):WaitForChild("BottomRight"):WaitForChild("SettingsButton")
local settingsFrame = playerGui:WaitForChild("UI"):WaitForChild("Settings"):WaitForChild("Frame")
local xButton = settingsFrame:WaitForChild("XButton")
local options = settingsFrame:WaitForChild("Options")
local musicVolumeSlider = options:WaitForChild("MusicVolume"):WaitForChild("Slider")
local musicVolumeHandle = musicVolumeSlider:WaitForChild("SliderButton")
local sfxVolumeSlider = options:WaitForChild("SFXVolume"):WaitForChild("Slider")
local sfxVolumeHandle = sfxVolumeSlider:WaitForChild("SliderButton")
local sfxVolume = player:WaitForChild("SFXVolume")
local hidePlayersON = options:WaitForChild("HidePlayers"):WaitForChild("OnButton")
local hidePlayersOFF = options:WaitForChild("HidePlayers"):WaitForChild("OffButton")
local graphicsQualityLOW = options:WaitForChild("GraphicsQuality"):WaitForChild("LowButton")
local graphicsQualityHIGH = options:WaitForChild("GraphicsQuality"):WaitForChild("HighButton")
local graphicsQuality = player:WaitForChild("GraphicsQuality")
local invincibilityON = options:WaitForChild("Invincibility"):WaitForChild("OnButton")
local invincibilityOFF = options:WaitForChild("Invincibility"):WaitForChild("OffButton")
local codeTextBox = options:WaitForChild("Codes"):WaitForChild("TextBox")
local enterButton = options:WaitForChild("Codes"):WaitForChild("EnterButton")
local animationInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local expanded = UDim2.new(0.461, 0, 0.522, 0)
local collapsed = UDim2.new(0, 0, 0, 0)
local purpleImage = "rbxassetid://100958220633950"
local purpleStroke = Color3.fromRGB(91, 27, 93)
local greyImage = "rbxassetid://99765721747476"
local greyStroke = Color3.fromRGB(67, 67, 67)
local redImage = "rbxassetid://94785397505773"
local redStroke = Color3.fromRGB(93, 27, 27)
local greenImage = "rbxassetid://79063184211327"
local greenStroke = Color3.fromRGB(28, 93, 52)
local musicVolumeDragging = false
local sfxVolumeDragging = false
local playersHidden = false
local visible = false
local debounce = false

local function updateMusicVolume(x)
	
	local minimumX = musicVolumeSlider.AbsolutePosition.X
	local maximumX = minimumX + musicVolumeSlider.AbsoluteSize.X
	local percent = math.clamp((x - minimumX) / (maximumX - minimumX), 0, 1)
	
	musicVolumeHandle.Position = UDim2.new(percent, -musicVolumeHandle.Size.X.Offset / 2, 0.5, -musicVolumeSlider.Size.Y.Offset / 2)
	remoteEvents.UpdateMusicVolume:FireServer(percent)
	
end

local function updateSFXVolume(x)
	
	local minimumX = sfxVolumeSlider.AbsolutePosition.X
	local maximumX = minimumX + sfxVolumeSlider.AbsoluteSize.X
	local percent = math.clamp((x - minimumX) / (maximumX - minimumX), 0, 1)
	
	sfxVolumeHandle.Position = UDim2.new(percent, -sfxVolumeHandle.Size.X.Offset / 2, 0.5, -sfxVolumeSlider.Size.Y.Offset / 2)
	remoteEvents.UpdateSFXVolume:FireServer(percent)
	
end

local function togglePlayerVisibility()
	
	playersHidden = not playersHidden
	
	if playersHidden then
		hidePlayersOFF.Visible = false
		hidePlayersON.Visible = true
	else
		hidePlayersOFF.Visible = true
		hidePlayersON.Visible = false
	end
	
	for _, otherPlayer in game.Players:GetPlayers() do
		if otherPlayer ~= player and otherPlayer.Character then
			for _, part in otherPlayer.Character:GetDescendants() do
				if part:IsA("BasePart") or part:IsA("Decal") then
					part.LocalTransparencyModifier = playersHidden and 1 or 0
				end
			end
		end
	end
	
end

local function toggleGraphicsQuality(newSetting)
	
	remoteEvents.UpdateGraphicsQuality:FireServer(newSetting)
	
	if newSetting == "Low" then
		
		game.Lighting.GlobalShadows = false
		game.Lighting.FogEnd = 500
		game.Lighting.Brightness = 1
		
		for _, effect in game.Lighting:GetChildren() do
			if effect:IsA("PostEffect") then
				effect.Enabled = false
			end
		end
		
		graphicsQualityLOW.Image = purpleImage
		graphicsQualityLOW.ButtonText.UIStroke.Color = purpleStroke
		graphicsQualityHIGH.Image = greyImage
		graphicsQualityHIGH.ButtonText.UIStroke.Color = greyStroke
		
	elseif newSetting == "High" then
		
		game.Lighting.GlobalShadows = true
		game.Lighting.FogEnd = 100000
		game.Lighting.Brightness = 3.75
		
		for _, effect in game.Lighting:GetChildren() do
			if effect:IsA("PostEffect") then
				effect.Enabled = true
			end
		end
		
		graphicsQualityHIGH.Image = purpleImage
		graphicsQualityHIGH.ButtonText.UIStroke.Color = purpleStroke
		graphicsQualityLOW.Image = greyImage
		graphicsQualityLOW.ButtonText.UIStroke.Color = greyStroke
		
	end
	
end

settingsFrame.Size = collapsed
settingsFrame.Parent.Visible = true

settingsButton.MouseButton1Click:Connect(function()

	local sound = soundEffects.UIButtonPress:Clone()
	sound.Parent = game.SoundService
	sound:Play()
	DebrisService:AddItem(sound, sound.TimeLength + 1)

	local target = visible and collapsed or expanded
	local expandTween = TweenService:Create(settingsFrame, animationInfo, {Size = target})

	expandTween:Play()

	visible = not visible

end)

xButton.MouseButton1Click:Connect(function()

	local sound = soundEffects.UIButtonPress:Clone()
	sound.Parent = game.SoundService
	sound:Play()
	DebrisService:AddItem(sound, sound.TimeLength + 1)

	local target = collapsed
	local collapseTween = TweenService:Create(settingsFrame, animationInfo, {Size = target})

	collapseTween:Play()

	visible = false

end)

musicVolumeHandle.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		musicVolumeDragging = true
	end
end)

musicVolumeHandle.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		musicVolumeDragging = false
	end
end)

sfxVolumeHandle.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		sfxVolumeDragging = true
	end
end)

sfxVolumeHandle.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		sfxVolumeDragging = false
	end
end)

UserInputService.InputChanged:Connect(function(input)
	
	if musicVolumeDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		updateMusicVolume(input.Position.X)
	end
	
	if sfxVolumeDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		updateSFXVolume(input.Position.X)
	end
	
end)

remoteEvents.UpdateMusicVolume.OnClientEvent:Connect(function(volume)
	musicVolumeHandle.Position = UDim2.new(volume, -musicVolumeHandle.Size.X.Offset / 2, 0.5, -musicVolumeSlider.Size.Y.Offset / 2)
end)

remoteEvents.UpdateSFXVolume.OnClientEvent:Connect(function(volume)
	sfxVolumeHandle.Position = UDim2.new(volume, -sfxVolumeHandle.Size.X.Offset / 2, 0.5, -sfxVolumeHandle.Size.Y.Offset / 2)
end)

game.SoundService.ChildAdded:Connect(function(child)
	if child.Name ~= "Music" then
		child.Volume = sfxVolume.Value
	end
end)

hidePlayersOFF.MouseButton1Click:Connect(function()
	
	local sound = soundEffects.UIButtonPress:Clone()
	sound.Parent = game.SoundService
	sound:Play()
	DebrisService:AddItem(sound, sound.TimeLength + 1)
	
	togglePlayerVisibility()
	
end)

hidePlayersON.MouseButton1Click:Connect(function()
	
	local sound = soundEffects.UIButtonPress:Clone()
	sound.Parent = game.SoundService
	sound:Play()
	DebrisService:AddItem(sound, sound.TimeLength + 1)
	
	togglePlayerVisibility()
	
end)

graphicsQualityLOW.MouseButton1Click:Connect(function()
	if graphicsQuality.Value ~= "Low" then
		
		local sound = soundEffects.UIButtonPress:Clone()
		sound.Parent = game.SoundService
		sound:Play()
		DebrisService:AddItem(sound, sound.TimeLength + 1)
		
		toggleGraphicsQuality("Low")
		
	end
end)

graphicsQualityHIGH.MouseButton1Click:Connect(function()
	if graphicsQuality.Value ~= "High" then

		local sound = soundEffects.UIButtonPress:Clone()
		sound.Parent = game.SoundService
		sound:Play()
		DebrisService:AddItem(sound, sound.TimeLength + 1)

		toggleGraphicsQuality("High")

	end
end)

remoteEvents.UpdateGraphicsQuality.OnClientEvent:Connect(toggleGraphicsQuality)

invincibilityOFF.MouseButton1Click:Connect(function()
	
	local sound = soundEffects.UIButtonPress:Clone()
	sound.Parent = game.SoundService
	sound:Play()
	DebrisService:AddItem(sound, sound.TimeLength + 1)
	
	if MarketplaceService:UserOwnsGamePassAsync(player.UserId, 1386998947) then
		remoteEvents.UpdateInvincibility:FireServer(true)
		invincibilityOFF.Visible = false
		invincibilityON.Visible = true
	else
		remoteEvents.GamepassPurchaseRequest:FireServer("Invincibility")
	end
	
end)

invincibilityON.MouseButton1Click:Connect(function()
	
	local sound = soundEffects.UIButtonPress:Clone()
	sound.Parent = game.SoundService
	sound:Play()
	DebrisService:AddItem(sound, sound.TimeLength + 1)
	
	remoteEvents.UpdateInvincibility:FireServer(false)
	invincibilityON.Visible = false
	invincibilityOFF.Visible = true
	
end)

remoteEvents.UpdateInvincibility.OnClientEvent:Connect(function(newSetting)
	if newSetting == true then
		invincibilityOFF.Visible = false
		invincibilityON.Visible = true
	else
		invincibilityOFF.Visible = true
		invincibilityON.Visible = false
	end
end)

enterButton.MouseButton1Click:Connect(function()
	
	if debounce == true then
		return
	end
	
	local code = codeTextBox.Text
	remoteEvents.RedeemCode:FireServer(code)
	debounce = true
	
end)

remoteEvents.RedeemCode.OnClientEvent:Connect(function(success, message)
	
	enterButton.ButtonText.Text = message
	
	if message == "SUCCESS" then
				
		local sound = soundEffects.CodeRedeemSuccess:Clone()
		sound.Parent = game.SoundService
		sound:Play()
		DebrisService:AddItem(sound, sound.TimeLength + 1)
		
	elseif message == "ALREADY REDEEMED" then
		
		enterButton.Image = redImage
		enterButton.ButtonText.UIStroke.Color = redStroke
		
		local sound = soundEffects.CodeRedeemFailure:Clone()
		sound.Parent = game.SoundService
		sound:Play()
		DebrisService:AddItem(sound, sound.TimeLength + 1)
		
	elseif message == "INVALID" then
		
		enterButton.Image = redImage
		enterButton.ButtonText.UIStroke.Color = redStroke

		local sound = soundEffects.CodeRedeemFailure:Clone()
		sound.Parent = game.SoundService
		sound:Play()
		DebrisService:AddItem(sound, sound.TimeLength + 1)
		
	elseif message == "ERROR" then
		
		enterButton.Image = redImage
		enterButton.ButtonText.UIStroke.Color = redStroke

		local sound = soundEffects.CodeRedeemFailure:Clone()
		sound.Parent = game.SoundService
		sound:Play()
		DebrisService:AddItem(sound, sound.TimeLength + 1)

	end
	
	task.wait(2)
	
	enterButton.ButtonText.Text = "ENTER"
	enterButton.Image = greenImage
	enterButton.ButtonText.UIStroke.Color = greenStroke
	codeTextBox.Text = ""
	debounce = false
	
end)
