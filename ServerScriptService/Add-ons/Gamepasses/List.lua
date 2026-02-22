local list = {}

local dataManager = require(game.ServerScriptService:WaitForChild("Core"):WaitForChild("DataManager"))
local configurations = game.ReplicatedStorage:WaitForChild("Configurations")

list.Names = {
	Invincibility = "1386998947",
}

function list:GetGamepassId(name)
	return list.Names[name]
end

list.Functions = {
	
	-- Invincibility
	["1386998947"] = function(player)
		dataManager:UpdateInvincibility(player, true)
	end,
	
}

return list
