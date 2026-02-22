local PhysicsService = game:GetService("PhysicsService")
local originalCollisionGroupName = "Players"
local previousCollisionGroups = {}

local function setCollisionGroup(part)
	if part:IsA("BasePart") then
		previousCollisionGroups[part] = part.CollisionGroup
		PhysicsService:SetPartCollisionGroup(part, originalCollisionGroupName)
	end
end

local function setCollisionGroupRecursive(part)
	
	setCollisionGroup(part)
	
	for _, child in part:GetChildren() do
		setCollisionGroupRecursive(child)
	end
	
end

local function resetCollisionGroup(part)
	
	local previousCollisionGroupName = previousCollisionGroups[part]
	
	if not previousCollisionGroupName then
		return
	end
	
	PhysicsService:SetPartCollisionGroup(part, previousCollisionGroupName)
	previousCollisionGroups[part] = nil
	
end

PhysicsService:RegisterCollisionGroup(originalCollisionGroupName)
PhysicsService:CollisionGroupSetCollidable(originalCollisionGroupName, originalCollisionGroupName, false)

game.Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		setCollisionGroupRecursive(character)
		character.DescendantAdded:Connect(setCollisionGroup)
		character.DescendantRemoving:Connect(resetCollisionGroup)
	end)
end)
