local remoteEvents = game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Events")
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local label = playerGui:WaitForChild("UI"):WaitForChild("BottomLeft"):WaitForChild("LoginStreak")

remoteEvents.UpdateLoginStreak.OnClientEvent:Connect(function(loginStreak)
	label.Text = "Login Streak: " .. loginStreak .. "d"
end)
