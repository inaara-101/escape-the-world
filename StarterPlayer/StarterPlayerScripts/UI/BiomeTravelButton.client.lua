local TweenService = game:GetService("TweenService")
local DebrisService = game:GetService("Debris")
local soundEffects = game.ReplicatedStorage:WaitForChild("SoundEffects")
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local travelButton = playerGui:WaitForChild("UI"):WaitForChild("Left"):WaitForChild("BiomeTravelButton")
local frame = playerGui:WaitForChild("UI"):WaitForChild("BiomeTravel"):WaitForChild("Frame")
local xButton = frame:WaitForChild("XButton")
local animationInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local expanded = UDim2.new(0.461, 0, 0.522, 0)
local collapsed = UDim2.new(0, 0, 0, 0)
local visible = false

frame.Size = collapsed
frame.Parent.Visible = true

travelButton.MouseButton1Click:Connect(function()
	
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
