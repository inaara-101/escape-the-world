local gamepasses = {}

local MarketplaceService = game:GetService("MarketplaceService")
local dataManager = require(game.ServerScriptService:WaitForChild("Core"):WaitForChild("DataManager"))
local list = require(script.List)

function gamepasses:PromptPurchase(player, name)
	
	local profile = dataManager.Profiles[player]
	
	if not profile then
		return
	end
	
	local id = list:GetGamepassId(name)
	
	if id == nil then
		return
	end
	
	local ownsGamepass = profile.Data.Gamepasses[id].owned
	
	if ownsGamepass == false then
		
		local success, result = pcall(function()
			ownsGamepass = MarketplaceService:UserOwnsGamePassAsync(player.UserId, tonumber(id))
		end)
		
		if not success then
			warn("There was an error while checking if a player owns a gamepass. " .. result)
			return
		end
		
		if ownsGamepass == false then
			MarketplaceService:PromptGamePassPurchase(player, tonumber(id))
		else
			gamepasses:UpdateGamepassOwnership(player)
		end
		
	end
	
end

function gamepasses:PromptPurchaseFinished(player, id, purchased)
	
	if purchased == false then
		return
	end
	
	id = tostring(id)
	
	local profile = dataManager.Profiles[player]
	
	if not profile then
		return
	end
	
	profile.Data.Gamepasses[id].owned = true
	
	local awardFunction = list.Functions[id]
	
	if awardFunction then
		awardFunction(player)
		profile.Data.Gamepasses[id].awarded = true
	else
		warn("A gamepass (" .. id .. ") was purchased by " .. player.Name .. " (" .. player.UserId .. "), but no function was found.")
	end
	
end

function gamepasses:UpdateGamepassOwnership(player)
	
	local profile = dataManager.Profiles[player]
	
	if not profile then
		return
	end
	
	for id, awardFunction in list.Functions do
		
		local ownsGamepass = profile.Data.Gamepasses[id].owned
		
		if ownsGamepass == false then
			
			local success, result = pcall(function()
				ownsGamepass = MarketplaceService:UserOwnsGamePassAsync(player.UserId, tonumber(id))
			end)

			if not success then
				warn("There was an error while checking if a player owns a gamepass. " .. result)
				continue
			end
			
			if ownsGamepass == true then
				profile.Data.Gamepasses[id].owned = true
				awardFunction(player)
				profile.Data.Gamepasses[id].awarded = true
			end
			
		end
		
	end
	
end

MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(...)
	gamepasses:PromptPurchaseFinished(...)
end)

return gamepasses
