local remoteEvents = game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Events")

remoteEvents.QuickRespawnRequest.OnServerEvent:Connect(function(player)
	if player:GetAttribute("CurrentlyBeingTrolled") == false then
		player:LoadCharacter()
	end
end)
