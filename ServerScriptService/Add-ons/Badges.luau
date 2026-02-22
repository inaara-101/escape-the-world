local BadgeService = game:GetService("BadgeService")
local dataManager = require(game.ServerScriptService:WaitForChild("Core"):WaitForChild("DataManager"))
local configurations = game.ReplicatedStorage:WaitForChild("Configurations")
local welcomeW = 3147101742100844
local welcomeO = 2443246770871699
local welcomeR = 1485349111938767
local welcomeL = 4020544392429978
local welcomeD = 4169443748501152
local metOwner = 3407553416231392
local completedGrassland = 364283455525563
local completedCave = 2547058461853605
local completedDesert = 1294786873005671
local completedArctic = 2551341724137303
local completedUnderworld = 700883814985583
local completedOcean = 2438472175916975
local die100Times = 1799545246917624
local loginStreak7 = 577852267922491
local trollerTrouble = 998344190744889

game.Players.PlayerAdded:Connect(function(player)
	
	task.wait()
	
	local profile = dataManager.Profiles[player]
	
	if not profile then
		return
	end
	
	local stage = player:WaitForChild("leaderstats"):WaitForChild("Stage")
	local deaths = player:WaitForChild("Deaths")
	local loginStreak = player:WaitForChild("LoginStreak")
	local trollsBought = player:WaitForChild("TrollsBought")
	
	if not BadgeService:UserHasBadgeAsync(player.UserId, welcomeD) then
		BadgeService:AwardBadge(player.UserId, welcomeD)	
	end
	
	if not BadgeService:UserHasBadgeAsync(player.UserId, welcomeL) then
		BadgeService:AwardBadge(player.UserId, welcomeL)
	end
	
	if not BadgeService:UserHasBadgeAsync(player.UserId, welcomeR) then
		BadgeService:AwardBadge(player.UserId, welcomeR)
	end
	
	if not BadgeService:UserHasBadgeAsync(player.UserId, welcomeO) then
		BadgeService:AwardBadge(player.UserId, welcomeO)
	end
	
	if not BadgeService:UserHasBadgeAsync(player.UserId, welcomeW) then
		BadgeService:AwardBadge(player.UserId, welcomeW)
	end
	
	if player.UserId == 1571187305 or player.UserId == 953263210 then
		for _, otherPlayer in game.Players:GetPlayers() do
			if player ~= otherPlayer and not BadgeService:UserHasBadgeAsync(otherPlayer.UserId, metOwner) then
				BadgeService:AwardBadge(otherPlayer.UserId, metOwner)
			end
		end
	end
	
	stage:GetPropertyChangedSignal("Value"):Connect(function()
		
		task.wait()
		
		if stage.Value ~= profile.Data.Stage then
			return
		end
		
		if profile.Data.Stage == configurations.BiomeStart:GetAttribute("Cave") then
			if not BadgeService:UserHasBadgeAsync(player.UserId, completedGrassland) then
				BadgeService:AwardBadge(player.UserId, completedGrassland)
			end
		elseif profile.Data.Stage == configurations.BiomeStart:GetAttribute("Desert") then
			if not BadgeService:UserHasBadgeAsync(player.UserId, completedCave) then
				BadgeService:AwardBadge(player.UserId, completedCave)
			end
		elseif profile.Data.Stage == configurations.BiomeStart:GetAttribute("Arctic") then
			if not BadgeService:UserHasBadgeAsync(player.UserId, completedDesert) then
				BadgeService:AwardBadge(player.UserId, completedDesert)
			end
		elseif profile.Data.Stage == configurations.BiomeStart:GetAttribute("Underworld") then
			if not BadgeService:UserHasBadgeAsync(player.UserId, completedArctic) then
				BadgeService:AwardBadge(player.UserId, completedArctic)
			end
		elseif profile.Data.Stage == configurations.BiomeStart:GetAttribute("Ocean") then
			if not BadgeService:UserHasBadgeAsync(player.UserId, completedUnderworld) then
				BadgeService:AwardBadge(player.UserId, completedUnderworld)
			end
		elseif profile.Data.Stage == configurations.BiomeEnd:GetAttribute("Ocean") then
			if not BadgeService:UserHasBadgeAsync(player.UserId, completedOcean) then
				BadgeService:AwardBadge(player.UserId, completedOcean)
			end
		end
		
	end)
	
	deaths:GetPropertyChangedSignal("Value"):Connect(function()
		if profile.Data.Deaths >= 100 then
			if not BadgeService:UserHasBadgeAsync(player.UserId, die100Times) then
				BadgeService:AwardBadge(player.UserId, die100Times)
			end
		end
	end)
	
	loginStreak:GetPropertyChangedSignal("Value"):Connect(function()
		if profile.Data.LoginStreak >= 7 then
			if not BadgeService:UserHasBadgeAsync(player.UserId, loginStreak7) then
				BadgeService:AwardBadge(player.UserId, loginStreak7)
			end
		end
	end)
	
	trollsBought:GetPropertyChangedSignal("Value"):Connect(function()
		if profile.Data.TrollsBought >= 1 then
			if not BadgeService:UserHasBadgeAsync(player.UserId, trollerTrouble) then
				BadgeService:AwardBadge(player.UserId, trollerTrouble)
			end
		end
	end)
	
end)
