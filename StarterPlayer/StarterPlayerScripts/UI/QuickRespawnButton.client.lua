local DebrisService = game:GetService("Debris")
local remoteEvents = game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Events")
local soundEffects = game.ReplicatedStorage:WaitForChild("SoundEffects")
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local button = playerGui:WaitForChild("UI"):WaitForChild("BottomLeft"):WaitForChild("QuickRespawnButton")

button.MouseButton1Click:Connect(function()
	if player.Character then
		if player.Character:FindFirstChild("Humanoid") then
		
			local sound = soundEffects.UIButtonPress:Clone()
			sound.Parent = game.SoundService
			sound:Play()
			DebrisService:AddItem(sound, sound.TimeLength + 1)
			
			remoteEvents.QuickRespawnRequest:FireServer()
				
		end
	end
end)
