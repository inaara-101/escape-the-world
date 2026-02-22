local dataManager = require(game.ServerScriptService:WaitForChild("Core"):WaitForChild("DataManager"))
local codes = require(game.ServerScriptService:WaitForChild("Add-ons"):WaitForChild("Codes"))
local remoteEvents = game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Events")

remoteEvents.RedeemCode.OnServerEvent:Connect(function(player, code)
	
	local profile = dataManager.Profiles[player]
	
	if not profile then
		return
	end
	
	code = string.upper(code)
	
	local data = codes[code]
	
	if not data then
		remoteEvents.RedeemCode:FireClient(player, false, "INVALID")
		return
	end
	
	profile.Data.RedeemedCodes = profile.Data.RedeemedCodes or {}
	
	if table.find(profile.Data.RedeemedCodes, code) then
		remoteEvents.RedeemCode:FireClient(player, false, "ALREADY REDEEMED")
		return
	end
	
	local success, result = pcall(function()
		data.redeem(player, profile)
	end)
	
	if not success then
		warn("There was an error while redeeming code '" .. code .. "' for " .. player.Name .. "(" .. player.UserId .. ").", result)
		remoteEvents.RedeemCode:FireClient(player, false, "ERROR")
		return
	end
	
	table.insert(profile.Data.RedeemedCodes, code)
	remoteEvents.RedeemCode:FireClient(player, true, "SUCCESS")
	
end)
