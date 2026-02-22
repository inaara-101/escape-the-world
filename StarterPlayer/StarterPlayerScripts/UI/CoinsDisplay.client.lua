local TweenService = game:GetService("TweenService")
local DebrisService = game:GetService("Debris")
local numberFormatter = require(game.ReplicatedStorage:WaitForChild("Library"):WaitForChild("NumberFormatter"))
local remoteEvents = game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Events")
local soundEffects = game.ReplicatedStorage:WaitForChild("SoundEffects")
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local coinsDisplay = playerGui:WaitForChild("UI"):WaitForChild("Right"):WaitForChild("CoinsDisplay")
local shop = playerGui:WaitForChild("UI"):WaitForChild("Shop"):WaitForChild("Frame")
local animationInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local expanded = UDim2.new(0.571, 0, 0.668, 0)

remoteEvents.UpdateCoins.OnClientEvent:Connect(function(amount)
	coinsDisplay.Display.Text = numberFormatter(amount, "Suffix")
end)

coinsDisplay.MoreCoins.MouseButton1Click:Connect(function()
	
	local sound = soundEffects.UIButtonPress:Clone()
	sound.Parent = game.SoundService
	sound:Play()
	DebrisService:AddItem(sound, sound.TimeLength + 1)
	
	shop.ActivePage.Value = "CoinsPage"
	
	local target = expanded
	local expandTween = TweenService:Create(shop, animationInfo, {Size = target})

	expandTween:Play()
	
end)
