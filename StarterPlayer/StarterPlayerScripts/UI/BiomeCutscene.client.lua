local TweenService = game:GetService("TweenService")
local DebrisService = game:GetService("Debris")
local bindables = game.ReplicatedStorage:WaitForChild("Bindables")
local soundEffects = game.ReplicatedStorage:WaitForChild("SoundEffects")
local player = game.Players.LocalPlayer
local stage = player:WaitForChild("leaderstats"):WaitForChild("Stage")
local playerGui = player:WaitForChild("PlayerGui")
local screen = playerGui:WaitForChild("UI"):WaitForChild("BiomeCutscene")
local cutsceneInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local function close()
	
	screen.Visible = true

	local cutsceneTween = TweenService:Create(screen, cutsceneInfo, {Size = UDim2.new(0, 0, 0, 0)})
	cutsceneTween:Play()
	cutsceneTween.Completed:Wait()

end

local function open()

	screen.Visible = true

	local cutsceneTween = TweenService:Create(screen, cutsceneInfo, {Size = UDim2.new(3, 0, 3, 0)})
	cutsceneTween:Play()
	cutsceneTween.Completed:Wait()
	
	screen.Visible = false

end

bindables.BiomeCutsceneRequest.Event:Connect(function(duration)
	
	close()
	
	local sound = soundEffects.UnlockBiome:Clone()
	sound.Parent = game.SoundService
	sound:Play()
	DebrisService:AddItem(sound, sound.TimeLength + 1)
	
	task.wait(duration)
	
	if player.Character:FindFirstChild("HumanoidRootPart") then
		player.Character.HumanoidRootPart.CFrame = workspace.Checkpoints[stage.Value + 1].Checkpoint.CFrame + Vector3.new(0, 2, 0)
	end
	
	task.wait(0.1)
	
	open()
	
end)
