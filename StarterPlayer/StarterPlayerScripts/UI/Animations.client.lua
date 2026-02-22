local TweenService = game:GetService("TweenService")
local remoteEvents = game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Events")
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local boundaries = playerGui:WaitForChild("UI"):WaitForChild("Animations")
local template = boundaries:WaitForChild("Template")

local function animate(amount, icon, sign)
	
	local animation = template:Clone()
	animation.Change.Text = sign .. amount
	animation.Icon.Image = icon
	animation.Visible = true
	animation.Parent = boundaries

	local randomX = math.random(0, boundaries.AbsoluteSize.X - animation.AbsoluteSize.X)
	local randomY = math.random(0, boundaries.AbsoluteSize.Y - animation.AbsoluteSize.Y)

	animation.Position = UDim2.new(0, randomX, 0, randomY)

	local popInfo = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	local fadeInfo = TweenInfo.new(0.5)
	local popTween = TweenService:Create(animation, popInfo, {Position = animation.Position - UDim2.new(0, 0, 0, 50)})
	local fadeTween1 = TweenService:Create(animation, fadeInfo, {BackgroundTransparency = 1})
	local fadeTween2 = TweenService:Create(animation.Change, fadeInfo, {TextTransparency = 1})
	local fadeTween3 = TweenService:Create(animation.Icon, fadeInfo, {ImageTransparency = 1})
	local fadeTween4 = TweenService:Create(animation.Change.UIStroke, fadeInfo, {Transparency = 1})

	popTween:Play()

	task.wait(1)

	fadeTween1:Play()
	fadeTween2:Play()
	fadeTween3:Play()
	fadeTween4:Play()

	fadeTween1.Completed:Wait()
	animation:Destroy()
	
end

remoteEvents.KeyCollected.OnClientEvent:Connect(function(amount, icon)
	animate(amount, icon, "+")
end)

remoteEvents.CoinsCollected.OnClientEvent:Connect(function(amount, icon)
	animate(amount, icon, "+")
end)

remoteEvents.CoinsUsed.OnClientEvent:Connect(function(amount, icon)
	animate(amount, icon, "-")
end)
