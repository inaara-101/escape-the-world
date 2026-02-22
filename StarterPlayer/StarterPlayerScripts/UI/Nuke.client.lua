local TweenService = game:GetService("TweenService")
local DebrisService = game:GetService("Debris")
local remoteEvents = game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Events")
local remoteFunctions = game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Functions")
local soundEffects = game.ReplicatedStorage:WaitForChild("SoundEffects")
local values = game.ReplicatedStorage:WaitForChild("Values")
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local camera = workspace.CurrentCamera
local nukeButton = playerGui:WaitForChild("UI"):WaitForChild("Top"):WaitForChild("Frame"):WaitForChild("NukeButton")
local nukeFrame = playerGui:WaitForChild("UI"):WaitForChild("Nuke"):WaitForChild("Frame")
local xButton = nukeFrame:WaitForChild("XButton")
local serverNuke = nukeFrame:WaitForChild("Options"):WaitForChild("ServerNuke")
local globalNuke = nukeFrame:WaitForChild("Options"):WaitForChild("GlobalNuke")
local animationInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local label = playerGui:WaitForChild("UI"):WaitForChild("Nuke"):WaitForChild("Notification")
local expanded = UDim2.new(0.461, 0, 0.522, 0)
local collapsed = UDim2.new(0, 0, 0, 0)
local visible = false

label.Text = ""
label.Visible = false
nukeFrame.Parent.Visible = true	
nukeButton.Visible = not values.Nuke.Value
nukeFrame.Size = collapsed

values.Nuke:GetPropertyChangedSignal("Value"):Connect(function()
	nukeButton.Visible = not values.Nuke.Value
end)

nukeButton.MouseButton1Click:Connect(function()
	if values.Nuke.Value == false then
		
		local sound = soundEffects.UIButtonPress:Clone()
		sound.Parent = game.SoundService
		sound:Play()
		DebrisService:AddItem(sound, sound.TimeLength + 1)

		local target = visible and collapsed or expanded
		local expandTween = TweenService:Create(nukeFrame, animationInfo, {Size = target})

		expandTween:Play()

		visible = not visible
		
	end
end)

xButton.MouseButton1Click:Connect(function()

	local sound = soundEffects.UIButtonPress:Clone()
	sound.Parent = game.SoundService
	sound:Play()
	DebrisService:AddItem(sound, sound.TimeLength + 1)

	local target = collapsed
	local collapseTween = TweenService:Create(nukeFrame, animationInfo, {Size = target})

	collapseTween:Play()

	visible = false

end)

remoteEvents.TriggerNuke.OnClientEvent:Connect(function(instructions, text)
	
	if instructions == "notification" then
		
		label.Visible = true
		
		for i = 1, string.len(text) do
			label.Text = string.sub(text, 1, i)
			task.wait(0.05)
		end
		
		task.wait(5)
		
		for i = string.len(text), 0, -1 do
			label.Text = string.sub(text, 1, i)
			task.wait(0.05)
		end
		
		label.Visible = false
		
	elseif instructions == "shake camera" then
		
		while player.Character.Humanoid.Health > 0 do
			
			local x = Random.new():NextNumber(-0.25, 0.25)
			local y = Random.new():NextNumber(-0.25, 0.25)
			local z = Random.new():NextNumber(-0.25, 0.25)
			
			player.Character.Humanoid.CameraOffset = Vector3.new(x, y, z)
			camera.CFrame *= CFrame.Angles(x / 5, y / 5, z / 5)
			
			task.wait()
			
		end
		
	elseif instructions == "lighting effect" then
		
		local cc = Instance.new("ColorCorrectionEffect")
		cc.Parent = game.Lighting
		
		local ccInfo = TweenInfo.new(1, Enum.EasingStyle.Linear)
		local ccTween = TweenService:Create(cc, ccInfo, {Brightness = 1, Contrast = 1, TintColor = Color3.fromRGB(255, 170, 0)})
		ccTween:Play()
		
		task.wait(game.Players.RespawnTime - 1)
		
		cc:Destroy()
		
	end
	
end)

for _, imageLabel in pairs(nukeFrame.Options:GetChildren()) do
	if imageLabel:IsA("ImageLabel") and imageLabel:FindFirstChild("BuyButton") then
		
		local buyButton = imageLabel.BuyButton
		local name, price, description, icon = remoteFunctions.GetDeveloperProductInformation:InvokeServer(imageLabel.id.Value)

		imageLabel.NameText.Text = string.upper(name)
		buyButton.ButtonText.Text = price
		imageLabel.Icon.Image = icon

		buyButton.MouseButton1Click:Connect(function()

			local sound = soundEffects.UIButtonPress:Clone()
			sound.Parent = game.SoundService
			sound:Play()
			DebrisService:AddItem(sound, sound.TimeLength + 1)

			remoteEvents.DeveloperProductPurchaseRequest:FireServer(imageLabel.Name)
			
			local target = collapsed
			local collapseTween = TweenService:Create(nukeFrame, animationInfo, {Size = target})

			collapseTween:Play()

			visible = false

		end)
		
	end
end
