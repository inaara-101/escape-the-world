local MarketplaceService = game:GetService("MarketplaceService")
local dataManager = require(game.ServerScriptService:WaitForChild("Core"):WaitForChild("DataManager"))
local remoteFunctions = game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Functions")

task.wait(3)

remoteFunctions.GetGamepassInformation.OnServerInvoke = function(player, id)
	
	local profile = dataManager.Profiles[player]
	
	if not profile then
		return
	end
	
	local info = MarketplaceService:GetProductInfo(tonumber(id), Enum.InfoType.GamePass)
	local owned = profile.Data.Gamepasses[id].owned
	local name, price, description, icon
	
	name = info.Name
	description = info.Description
	icon = "rbxassetid://" .. info.IconImageAssetId
	
	if owned then
		price = "OWNED"
	else
		price = info.PriceInRobux .. " R$"
	end
	
	return name, price, description, icon
	
end

remoteFunctions.GetDeveloperProductInformation.OnServerInvoke = function(player, id)
	
	local profile = dataManager.Profiles[player]
	
	if not profile then
		return
	end
	
	local info = MarketplaceService:GetProductInfo(tonumber(id), Enum.InfoType.Product)
	local name, price, description, icon
	
	name = info.Name
	price = info.PriceInRobux .. " R$"
	description = info.Description
	icon = "rbxassetid://" .. info.IconImageAssetId
	
	return name, price, description, icon
	
end
