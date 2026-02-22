local dataManager = require(game.ServerScriptService:WaitForChild("Core"):WaitForChild("DataManager"))

local codes = {
	
	["SUMMER2025"] = {
		redeem = function(player, profile)
			dataManager:UpdateCoins(player, 10)
		end,
	},
	
}

return codes
