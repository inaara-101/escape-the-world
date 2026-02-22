local remoteEvents = game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Events")
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local label = playerGui:WaitForChild("UI"):WaitForChild("BottomLeft"):WaitForChild("FriendBoost")

remoteEvents.UpdateFriendBoost.OnClientEvent:Connect(function(friendBoost)
	if friendBoost == 1 then
		label.Text = "Friend Boost: N/A"
	else
		label.Text = "Friend Boost: " .. friendBoost .. "x"
	end
end)
