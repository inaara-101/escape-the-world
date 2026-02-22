local developerProducts = {}

local MarketplaceService = game:GetService("MarketplaceService")
local dataManager = require(game.ServerScriptService:WaitForChild("Core"):WaitForChild("DataManager"))
local remoteEvents = game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Events")
local configurations = game.ReplicatedStorage:WaitForChild("Configurations")
local functions = require(script.Functions)
local maxCache = 100

developerProducts.Names = {
	SkipStage = "3347120371",
	SkipAFriend = "3380530095",
	SkipToEnd = "3381468314",
	ServerNuke = "3353002968",
	GlobalNuke = "3375550982",
	Coins100 = "3367495151",
	Coins250 = "3367495309",
	Coins500 = "3367495473",
	Coins1000 = "3367496051",
	Coins2500 = "3367497368",
	Coins5000 = "3367497643",
	PlayerRagdoll = "3379496742",
	ServerRagdoll = "3379497128",
	PlayerKick = "3380054687",
	ServerKick = "3380055106",
	PlayerFreeze = "3380216589",
	ServerFreeze = "3380217726",
	PlayerNoJump = "3380290688",
	ServerNoJump = "3380292215",
	PlayerKill = "3380309356",
	ServerKill = "3380310530",
	PlayerEarthquake = "3380328137",
	ServerEarthquake = "3380328754",
	PlayerFling = "3380366213",
	ServerFling = "3380366615",
	PlayerJumpscare = "3380393523",
	ServerJumpscare = "3380395311"
}

function developerProducts:GetDeveloperProductId(name)
	return developerProducts.Names[name]
end

function developerProducts:RequestPurchase(player, name)
	
	local id = tonumber(developerProducts:GetDeveloperProductId(name))
	
	if id == nil then
		return
	end
	
	if functions[id] == nil then
		warn("A developer product (" .. id .. ") was purchased by " .. player.Name .. " (" .. player.UserId .. "), but no function was found.")
		return
	end
	
	MarketplaceService:PromptProductPurchase(player, id)
	
end

local function checkPurchaseAsync(profile, id, grantFunction) : Enum.ProductPurchaseDecision

	if profile:IsActive() then
		
		local cache = profile.Data.PurchaseIdCache
		
		if not cache then
			cache = {}
			profile.Data.PurchaseIdCache = cache
		end
		
		if not table.find(cache, id) then
			
			local success, result = pcall(grantFunction)
			
			if not success then
				warn("Failed to grant developer product purchase (" .. id .. ") to " .. profile.Key .. ": " .. result)
				return Enum.ProductPurchaseDecision.NotProcessedYet
			end
			
			while #cache >= maxCache do
				table.remove(cache, 1)
			end
			
			table.insert(cache, id)
			
		end
		
		local function isPurchaseSaved()
			local savedCache = profile.LastSavedData.PurchaseIdCache
			return if savedCache ~= nil then table.find(savedCache, id) ~= nil else false
		end
		
		if isPurchaseSaved() then
			return Enum.ProductPurchaseDecision.PurchaseGranted
		end
		
		while profile:IsActive() do
			
			local dataCopy = profile.LastSavedData
			
			profile:Save()
			
			if profile.LastSavedData == dataCopy then
				profile.OnAfterSave:Wait()
			end
			
			if isPurchaseSaved() then
				return Enum.ProductPurchaseDecision.PurchaseGranted
			end
			
			if profile:IsActive() then
				task.wait(10)
			end
			
		end
		
	end
	
	return Enum.ProductPurchaseDecision.NotProcessedYet

end

local function processReceipt(receiptInfo)
	
	local player = game.Players:GetPlayerByUserId(receiptInfo.PlayerId)
	
	if player then
		
		local profile = dataManager.Profiles[player]
		
		while profile == nil and player.Parent == game.Players do
			task.wait()
			profile = dataManager.Profiles[player]
		end
		
		if profile then
			if functions[receiptInfo.ProductId] == nil then
				warn("A developer product (" .. receiptInfo.ProductId .. ") was purchased by " .. player.Name .. " (" .. player.UserId .. "), but no function was found.")
				return Enum.ProductPurchaseDecision.NotProcessedYet
			end
		end
		
		local decision = checkPurchaseAsync(profile, receiptInfo.PurchaseId, function()
			functions[receiptInfo.ProductId](receiptInfo, player, profile)
		end)
		
		return decision
		
	end
	
	return Enum.ProductPurchaseDecision.NotProcessedYet
	
end

remoteEvents.DeveloperProductPurchaseRequest.OnServerEvent:Connect(function(player, name)
	developerProducts:RequestPurchase(player, name)
end)

MarketplaceService.ProcessReceipt = processReceipt

return developerProducts
