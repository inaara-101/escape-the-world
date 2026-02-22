local MessagingService = game:GetService("MessagingService")
local MemoryStoreService = game:GetService("MemoryStoreService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local DebrisService = game:GetService("Debris")
local lock = MemoryStoreService:GetSortedMap("NukeLock")
local dataManager = require(game.ServerScriptService:WaitForChild("Core"):WaitForChild("DataManager"))
local remoteEvents = game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Events")
local soundEffects = game.ReplicatedStorage:WaitForChild("SoundEffects")
local configurations = game.ReplicatedStorage:WaitForChild("Configurations")
local templates = game.ReplicatedStorage:WaitForChild("Templates")
local values = game.ReplicatedStorage:WaitForChild("Values")

local function triggerNuke(username, nukeType, nukeDescription)
	
	if values.Nuke.Value == true then
		warn("The '" .. nukeType .. "' developer product was purchased but not granted as a nuke is already in progress.")
		return
	end
	
	local success, locked = pcall(function()
		return lock:GetAsync("active")
	end)

	if not success then
		warn("There was an error while trying to check the status of the global nuke lock.", locked)
		return
	end
	
	if locked then
		warn("Ignored a nuke request as one is already in progress.")
		return
	end
	
	local success, result = pcall(function()
		lock:SetAsync("active", true, 30)
	end)

	if not success then
		warn("Failed to set nuke lock. Aborting...")
		return
	end

	values.Nuke.Value = true

	remoteEvents.TriggerNuke:FireAllClients("notification", username .. " has launched a " .. nukeDescription .. "!")

	local alarmSound = soundEffects.Alarm:Clone()
	alarmSound.Looped = true
	alarmSound.Parent = workspace
	alarmSound:Play()

	task.wait(4)

	for _, baseplate in workspace.BiomeBaseplates:GetChildren() do

		task.spawn(function()

			local model = templates.Nuke:Clone()
			local nukeSound = soundEffects.Nuke:Clone()
			nukeSound.Looped = true
			nukeSound.Parent = model
			nukeSound:Play()
			model.Size *= 5
			model.Position = baseplate.Position + Vector3.new(0, model.Size.Y * 3, 0)
			model.Anchored = true
			model.Parent = workspace

			local nukeInfo = TweenInfo.new(8, Enum.EasingStyle.Linear)
			local nukeTween = TweenService:Create(model, nukeInfo, {Position = baseplate.Position + Vector3.new(0, model.Size.Y / 2 + 7, 0)})
			nukeTween:Play()
			nukeTween.Completed:Wait()
			model:Destroy()

			local effect = templates.Explosion:Clone()
			effect.Anchored = true
			effect.CanCollide = false
			effect.Size = Vector3.new(0, 0, 0)
			effect.Position = baseplate.Position
			effect.Parent = workspace

			local explosionSound = soundEffects.Explosion:Clone()
			explosionSound.Parent = effect
			explosionSound:Play()

			local explosionInfo = TweenInfo.new(explosionSound.TimeLength, Enum.EasingStyle.Linear)
			local explosionTween = TweenService:Create(effect, explosionInfo, {Size = Vector3.new(baseplate.Size.X, baseplate.Size.X, baseplate.Size.X)})
			explosionTween:Play()

			for _, otherPlayer in game.Players:GetPlayers() do

				local character = otherPlayer.Character

				if character then

					local distance = (character.HumanoidRootPart.Position - effect.Position).Magnitude

					task.spawn(function()

						local timeWaited = 0

						repeat 
							task.wait(0.2) 
							timeWaited += 0.2
						until effect.Size.X / 2 >= distance - 30 or timeWaited >= explosionSound.TimeLength - 0.5

						remoteEvents.TriggerNuke:FireClient(otherPlayer, "lighting effect")
						task.wait(1)
						character.Humanoid.Health = 0

					end)

				end

			end

			explosionSound.Ended:Wait()
			effect:Destroy()

		end)

	end

	remoteEvents.TriggerNuke:FireAllClients("shake camera")

	local oldRespawnTime = game.Players.RespawnTime
	game.Players.RespawnTime = soundEffects.Explosion.TimeLength

	task.delay(soundEffects.Explosion.TimeLength + 5, function()
		
		game.Players.RespawnTime = oldRespawnTime
		alarmSound:Destroy()
		values.Nuke.Value = false
		
		pcall(function()
			lock:RemoveAsync("active")
		end)
		
	end)
	
end

local function ragdoll(target, duration)

	local character = target.Character

	if not character then
		return
	end

	local humanoid = character:FindFirstChild("Humanoid")
	local hrp = character:FindFirstChild("HumanoidRootPart")

	if not humanoid or not hrp then
		return
	end
	
	if target:GetAttribute("CurrentlyBeingTrolled") == true then
		repeat task.wait() until target:GetAttribute("CurrentlyBeingTrolled") == false
	end
	
	target:SetAttribute("CurrentlyBeingTrolled", true)

	local originalJoints = {}

	for _, joint in pairs(character:GetDescendants()) do
		if joint:IsA("Motor6D") then

			table.insert(originalJoints, {
				Part0 = joint.Part0,
				Part1 = joint.Part1,
				Name = joint.Name,
				C0 = joint.C0,
				C1 = joint.C1,
				Parent = joint.Parent
			})

			local socket = Instance.new("BallSocketConstraint")
			local attachment0 = Instance.new("Attachment")
			local attachment1 = Instance.new("Attachment")
			
			attachment0.Parent = joint.Part0
			attachment1.Parent = joint.Part1
			socket.Parent = joint.Parent
			socket.Attachment0 = attachment0
			socket.Attachment1 = attachment1
			attachment0.CFrame = joint.C0
			attachment1.CFrame = joint.C1
			socket.LimitsEnabled = true
			socket.TwistLimitsEnabled = true

			joint:Destroy()

		end
	end

	humanoid.PlatformStand = true
	
	if hrp then
		hrp.Anchored = false
	end

	task.delay(duration, function()

		for _, constraint in pairs(character:GetDescendants()) do
			if constraint:IsA("BallSocketConstraint") or constraint:IsA("Attachment") then
				constraint:Destroy()
			end
		end

		for _, info in ipairs(originalJoints) do
			local joint = Instance.new("Motor6D")
			joint.Part0 = info.Part0
			joint.Part1 = info.Part1
			joint.C0 = info.C0
			joint.C1 = info.C1
			joint.Name = info.Name
			joint.Parent = info.Parent
		end

		humanoid.PlatformStand = false
		target:SetAttribute("CurrentlyBeingTrolled", false)

	end)

end

local function freeze(target, duration)
	
	local character = target.Character

	if not character then
		return
	end

	local humanoid = character:FindFirstChild("Humanoid")
	local hrp = character:FindFirstChild("HumanoidRootPart")

	if not humanoid or not hrp then
		return
	end
	
	if target:GetAttribute("CurrentlyBeingTrolled") == true then
		repeat task.wait() until target:GetAttribute("CurrentlyBeingTrolled") == false
	end
	
	target:SetAttribute("CurrentlyBeingTrolled", true)
	
	local ice = templates.IceBlock:Clone()
	ice.CFrame = hrp.CFrame
	ice.Anchored = false
	ice.Parent = character
	
	local weld = Instance.new("WeldConstraint")
	weld.Part0 = hrp
	weld.Part1 = ice
	weld.Parent = ice
	
	local screen = templates.Frozen:Clone()
	screen.Parent = target.PlayerGui.UI
	
	humanoid.WalkSpeed = 0
	humanoid.JumpHeight = 0
	
	local connection = RunService.Heartbeat:Connect(function()
		hrp.CFrame = hrp.CFrame * CFrame.new((math.random(-1, 1) * 0.05), 0, (math.random(-1, 1) * 0.05))
		ice.CFrame = hrp.CFrame
	end)
	
	task.wait(duration)
	
	character.IceBlock:Destroy()
	target.PlayerGui.UI.Frozen:Destroy()
	humanoid.WalkSpeed = 16
	humanoid.JumpHeight = 7.2
	connection:Disconnect()
	
	target:SetAttribute("CurrentlyBeingTrolled", false)
	
end

local function noJump(target, duration)
	
	local character = target.Character

	if not character then
		return
	end

	local humanoid = character:FindFirstChild("Humanoid")

	if not humanoid then
		return
	end

	if target:GetAttribute("CurrentlyBeingTrolled") == true then
		repeat task.wait() until target:GetAttribute("CurrentlyBeingTrolled") == false
	end

	target:SetAttribute("CurrentlyBeingTrolled", true)
	humanoid.JumpHeight = 0
	
	task.wait(duration)
	
	target:SetAttribute("CurrentlyBeingTrolled", false)
	humanoid.JumpHeight = 7.2
	
end

local function kill(target)

	local character = target.Character

	if not character then
		return
	end

	local humanoid = character:FindFirstChild("Humanoid")

	if not humanoid then
		return
	end

	humanoid.Health = 0
	target:SetAttribute("CurrentlyBeingTrolled", true)
	
	task.wait(game.Players.RespawnTime)
	target:SetAttribute("CurrentlyBeingTrolled", false)

end

local function earthquake(target, duration)
	
	local character = target.Character

	if not character then
		return
	end

	local humanoid = character:FindFirstChild("Humanoid")

	if not humanoid then
		return
	end

	if target:GetAttribute("CurrentlyBeingTrolled") == true then
		repeat task.wait() until target:GetAttribute("CurrentlyBeingTrolled") == false
	end

	target:SetAttribute("CurrentlyBeingTrolled", true)
	
	remoteEvents.TriggerEarthquake:FireClient(target, duration)
	task.wait(duration)

	target:SetAttribute("CurrentlyBeingTrolled", false)
	
end

local function fling(target)
	
	local character = target.Character

	if not character then
		return
	end

	local humanoid = character:FindFirstChild("Humanoid")
	local hrp = character:FindFirstChild("HumanoidRootPart")

	if not humanoid or not hrp then
		return
	end

	if target:GetAttribute("CurrentlyBeingTrolled") == true then
		repeat task.wait() until target:GetAttribute("CurrentlyBeingTrolled") == false
	end

	target:SetAttribute("CurrentlyBeingTrolled", true)
	
	local fling = Instance.new("BodyAngularVelocity")
	fling.AngularVelocity = Vector3.new(50, 50, 50)
	fling.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
	fling.P = 1e5
	fling.Parent = hrp

	local linear = Instance.new("BodyVelocity")
	linear.Velocity = Vector3.new(math.random(-100, 100), 150, math.random(-100, 100))
	linear.MaxForce = Vector3.new(1e5, 1e5, 1e5)
	linear.Parent = hrp
	
	DebrisService:AddItem(fling, 6)
	DebrisService:AddItem(linear, 3)

	target:SetAttribute("CurrentlyBeingTrolled", false)
	
end

local function jumpscare(target)
	
	target:SetAttribute("CurrentlyBeingTrolled", true)
	
	local jumpscare = templates.Jumpscare:Clone()
	jumpscare.Parent = target.PlayerGui.UI
	
	task.wait(3)
	
	jumpscare:Destroy()
	
	target:SetAttribute("CurrentlyBeingTrolled", false)

end

MessagingService:SubscribeAsync("GlobalNuke", function(message)
	local username = message.Data or "Someone"
	triggerNuke(username, "Global Nuke", "GLOBAL nuke")
end)

return {
		
	-- Skip Stage
	[3347120371] = function(receiptInfo, player, profile)
		dataManager:UpdateStage(player, profile.Data.Stage + 1)
		task.wait()
		player.Character.HumanoidRootPart.CFrame = workspace.Checkpoints[player.leaderstats.Stage.Value].Checkpoint.CFrame + Vector3.new(0, 2, 0)
	end,
	
	-- Skip A Friend
	[3380530095] = function(receiptInfo, player, profile)
		
		local playerGui = player.PlayerGui
		local target = game.Players:FindFirstChild(playerGui.UI.Spectate.Username.Text)
		
		dataManager:UpdateStage(target, profile.Data.Stage + 1)
		task.wait()
		target.Character.HumanoidRootPart.CFrame = workspace.Checkpoints[target.leaderstats.Stage.Value].Checkpoint.CFrame + Vector3.new(0, 2, 0)
		
	end,
	
	-- Skip To End
	[3381468314] = function(receiptInfo, player, profile)
		dataManager:UpdateStage(player, configurations.BiomeEnd:GetAttribute(configurations.LastBiome:GetAttribute("LastBiome")))
		task.wait()
		player.Character.HumanoidRootPart.CFrame = workspace.Checkpoints[player.leaderstats.Stage.Value].Checkpoint.CFrame + Vector3.new(0, 2, 0)
	end,
	
	-- Server Nuke
	[3353002968] = function(receiptInfo, player, profile)
		local username = game.Players:GetNameFromUserIdAsync(receiptInfo.PlayerId)
		triggerNuke(username, "Server Nuke", "server nuke")
	end,
	
	-- Global Nuke
	[3375550982] = function(receiptInfo, player, profile)
		local username = game.Players:GetNameFromUserIdAsync(receiptInfo.PlayerId)
		MessagingService:PublishAsync("GlobalNuke", username)
	end,
	
	-- 100 Coins
	[3367495151] = function(receiptInfo, player, profile)
		dataManager:UpdateCoins(player, 100, true)
		remoteEvents.CoinsBought:FireClient(player)
	end,
	
	-- 250 Coins
	[3367495309] = function(receiptInfo, player, profile)
		dataManager:UpdateCoins(player, 250, true)
		remoteEvents.CoinsBought:FireClient(player)
	end,
	
	-- 500 Coins
	[3367495473] = function(receiptInfo, player, profile)
		dataManager:UpdateCoins(player, 500, true)
		remoteEvents.CoinsBought:FireClient(player)
	end,
	
	-- 1,000 Coins
	[3367496051] = function(receiptInfo, player, profile)
		dataManager:UpdateCoins(player, 1000, true)
		remoteEvents.CoinsBought:FireClient(player)
	end,
	
	-- 2,500 Coins
	[3367497368] = function(receiptInfo, player, profile)
		dataManager:UpdateCoins(player, 2500, true)
		remoteEvents.CoinsBought:FireClient(player)
	end,
	
	-- 5,000 Coins
	[3367497643] = function(receiptInfo, player, profile)
		dataManager:UpdateCoins(player, 5000, true)
		remoteEvents.CoinsBought:FireClient(player)
	end,
	
	-- Ragdoll [PLAYER]
	[3379496742] = function(receiptInfo, player, profile)
		
		local playerGui = player.PlayerGui
		local target = game.Players:FindFirstChild(playerGui.UI.Spectate.Username.Text)

		if target then
			remoteEvents.Trolled:FireClient(target, "player", player.Name, "a ragdoll for 20 seconds")
			ragdoll(target, 20)
		end
		
		dataManager:UpdateTrollsBought(player, 1)
		
	end,
	
	-- Ragdoll [SERVER]
	[3379497128] = function(receiptInfo, player, profile)
		
		for _, otherPlayer in pairs(game.Players:GetPlayers()) do
			if otherPlayer and otherPlayer ~= player then
				remoteEvents.Trolled:FireClient(otherPlayer, "server", player.Name, "a ragdoll for 20 seconds")
				ragdoll(otherPlayer, 20)
			end
		end
		
		dataManager:UpdateTrollsBought(player, 1)
		
	end,
	
	-- Kick [PLAYER]
	[3380054687] = function(receiptInfo, player, profile)
		
		local playerGui = player.PlayerGui
		local target = game.Players:FindFirstChild(playerGui.UI.Spectate.Username.Text)
		
		if target then
			remoteEvents.Trolled:FireClient(target, "player", player.Name, "a kick from the server")
			task.wait(0.2)
			target:Kick("HAHA TROLLED! You have just been kicked by " .. player.Name .. "! U mad bro?")
		end
		
		dataManager:UpdateTrollsBought(player, 1)
		
	end,
	
	-- Kick [SERVER]
	[3380055106] = function(receiptInfo, player, profile)
		
		for _, otherPlayer in pairs(game.Players:GetPlayers()) do
			if otherPlayer then
				remoteEvents.Trolled:FireClient(otherPlayer, "server", player.Name, "a kick from the server")
				task.wait(0.2)
				otherPlayer:Kick("HAHA TROLLED! The entire server has just been kicked by " .. player.Name .. "! U mad bro?")
			end
		end
		
		dataManager:UpdateTrollsBought(player, 1)
		
	end,
	
	-- Freeze [PLAYER]
	[3380216589] = function(receiptInfo, player, profile)
		
		local playerGui = player.PlayerGui
		local target = game.Players:FindFirstChild(playerGui.UI.Spectate.Username.Text)
		
		if target then
			remoteEvents.Trolled:FireClient(target, "player", player.Name, "a freeze for 20 seconds")
			freeze(target, 20)
		end
		
		dataManager:UpdateTrollsBought(player, 1)
		
	end,
	
	-- Freeze [SERVER]
	[3380217726] = function(receiptInfo, player, profile)
		
		for _, otherPlayer in pairs(game.Players:GetPlayers()) do
			if otherPlayer and otherPlayer ~= player then
				remoteEvents.Trolled:FireClient(otherPlayer, "server", player.Name, "a freeze for 20 seconds")
				freeze(otherPlayer, 20)
			end
		end
		
		dataManager:UpdateTrollsBought(player, 1)
		
	end,
	
	-- No Jump [PLAYER]
	[3380290688] = function(receiptInfo, player, profile)
		
		local playerGui = player.PlayerGui
		local target = game.Players:FindFirstChild(playerGui.UI.Spectate.Username.Text)

		if target then
			remoteEvents.Trolled:FireClient(target, "player", player.Name, "a no jump for 20 seconds")
			noJump(target, 20)
		end

		dataManager:UpdateTrollsBought(player, 1)
		
	end,
	
	-- No Jump [SERVER]
	[3380292215] = function(receiptInfo, player, profile)
		
		for _, otherPlayer in pairs(game.Players:GetPlayers()) do
			if otherPlayer and otherPlayer ~= player then
				remoteEvents.Trolled:FireClient(otherPlayer, "server", player.Name, "a no jump for 20 seconds")
				noJump(otherPlayer, 20)
			end
		end

		dataManager:UpdateTrollsBought(player, 1)
		
	end,
	
	-- Kill [PLAYER]
	[3380309356] = function(receiptInfo, player, profile)
		
		local playerGui = player.PlayerGui
		local target = game.Players:FindFirstChild(playerGui.UI.Spectate.Username.Text)

		if target then
			remoteEvents.Trolled:FireClient(target, "player", player.Name, "a kill")
			kill(target)
		end

		dataManager:UpdateTrollsBought(player, 1)
		
	end,
	
	-- Kill [SERVER]
	[3380310530] = function(receiptInfo, player, profile)
		
		for _, otherPlayer in pairs(game.Players:GetPlayers()) do
			if otherPlayer and otherPlayer ~= player then
				remoteEvents.Trolled:FireClient(otherPlayer, "server", player.Name, "a kill")
				kill(otherPlayer)
			end
		end

		dataManager:UpdateTrollsBought(player, 1)
		
	end,
	
	-- Earthquake [PLAYER]
	[3380328137] = function(receiptInfo, player, profile)
		
		local playerGui = player.PlayerGui
		local target = game.Players:FindFirstChild(playerGui.UI.Spectate.Username.Text)

		if target then
			remoteEvents.Trolled:FireClient(target, "player", player.Name, "an earthquake for 20 seconds")
			earthquake(target, 20)
		end

		dataManager:UpdateTrollsBought(player, 1)
		
	end,
	
	-- Earthquake [SERVER]
	[3380328754] = function(receiptInfo, player, profile)
		
		for _, otherPlayer in pairs(game.Players:GetPlayers()) do
			if otherPlayer and otherPlayer ~= player then
				remoteEvents.Trolled:FireClient(otherPlayer, "server", player.Name, "an earthquake for 20 seconds")
				earthquake(otherPlayer, 20)
			end
		end

		dataManager:UpdateTrollsBought(player, 1)
		
	end,
	
	-- Fling [PLAYER]
	[3380366213] = function(receiptInfo, player, profile)
		
		local playerGui = player.PlayerGui
		local target = game.Players:FindFirstChild(playerGui.UI.Spectate.Username.Text)

		if target then
			remoteEvents.Trolled:FireClient(target, "player", player.Name, "a fling")
			fling(target)
		end

		dataManager:UpdateTrollsBought(player, 1)
		
	end,
	
	-- Fling [SERVER]
	[3380366615] = function(receiptInfo, player, profile)
		
		for _, otherPlayer in pairs(game.Players:GetPlayers()) do
			if otherPlayer and otherPlayer ~= player then
				remoteEvents.Trolled:FireClient(otherPlayer, "server", player.Name, "a fling")
				fling(otherPlayer)
			end
		end

		dataManager:UpdateTrollsBought(player, 1)
		
	end,
	
	-- Jumpscare [PLAYER]
	[3380393523] = function(receiptInfo, player, profile)
		
		local playerGui = player.PlayerGui
		local target = game.Players:FindFirstChild(playerGui.UI.Spectate.Username.Text)

		if target then
			remoteEvents.Trolled:FireClient(target, "player", player.Name, "a jumpscare")
			jumpscare(target)
		end

		dataManager:UpdateTrollsBought(player, 1)
		
	end,
	
	-- Jumpscare [SERVER]
	[3380395311] = function(receiptInfo, player, profile)
		
		for _, otherPlayer in pairs(game.Players:GetPlayers()) do
			if otherPlayer and otherPlayer ~= player then
				remoteEvents.Trolled:FireClient(otherPlayer, "server", player.Name, "a jumpscare")
				jumpscare(otherPlayer)
			end
		end

		dataManager:UpdateTrollsBought(player, 1)
		
	end,
		
}
