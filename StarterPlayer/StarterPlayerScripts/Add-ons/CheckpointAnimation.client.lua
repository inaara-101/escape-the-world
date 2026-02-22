local TweenService = game:GetService("TweenService")
local DebrisService = game:GetService("Debris")
local remoteEvents = game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Events")
local soundEffects = game.ReplicatedStorage:WaitForChild("SoundEffects")
local configurations = game.ReplicatedStorage:WaitForChild("Configurations")
local player = game.Players.LocalPlayer

remoteEvents.UpdateStage.OnClientEvent:Connect(function(stage)
	
	local checkpoint = workspace.Checkpoints:FindFirstChild(tostring(stage)).Checkpoint
	local spinInfo = TweenInfo.new(1, Enum.EasingStyle.Circular)
	local fadeInfo = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
	local spinTween = TweenService:Create(checkpoint, spinInfo, {CFrame = checkpoint.CFrame * CFrame.Angles(0, math.rad(180), 0)})
	local fadeTween = TweenService:Create(checkpoint, fadeInfo, {Color = Color3.fromRGB(180, 255, 180)})
	local matched = false
	
	local particles = Instance.new("ParticleEmitter")
	particles.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),   
		ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)), 
		ColorSequenceKeypoint.new(0.66, Color3.fromRGB(0, 0, 255)), 
		ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 0))  
	}
	particles.LightEmission = 0.7
	particles.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.5), NumberSequenceKeypoint.new(1, 0)})
	particles.Transparency = NumberSequence.new(0)
	particles.Lifetime = NumberRange.new(2)
	particles.Rate = 0
	particles.Speed = NumberRange.new(3, 5)
	particles.Rotation = NumberRange.new(0, 360)
	particles.RotSpeed = NumberRange.new(100)
	particles.VelocitySpread = 180
	particles.Parent = checkpoint
	
	checkpoint.BrickColor = BrickColor.new("Sea green")

	spinTween:Play()
	fadeTween:Play()
	
	for name, value in pairs(configurations.BiomeEnd:GetAttributes()) do
		if stage == value + 1 then
			
			local biomeSound = soundEffects.NewBiome:Clone()
			biomeSound.Parent = game.SoundService
			biomeSound:Play()
			DebrisService:AddItem(biomeSound, biomeSound.TimeLength + 1)
			
			task.wait(1.8)
			
			local confettiSound = soundEffects.Confetti:Clone()
			confettiSound.Parent = game.SoundService
			confettiSound:Play()
			DebrisService:AddItem(confettiSound, confettiSound.TimeLength + 1)
			
			matched = true
			
			break
			
		end
	end
	
	if not matched then
		local checkpointSound = soundEffects.Checkpoint:Clone()
		checkpointSound.Parent = game.SoundService
		checkpointSound:Play()
		DebrisService:AddItem(checkpointSound, checkpointSound.TimeLength + 1)
	end

	spinTween.Completed:Connect(function()
		fadeTween:Cancel()
		checkpoint.Color = Color3.fromRGB(91, 93, 105)
	end)

	particles:Emit(400)
	task.wait(3)
	particles.Enabled = false
	task.wait(5)
	particles:Destroy()
	
end)
