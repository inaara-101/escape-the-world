local remoteEvents = game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Events")
local configurations = game.ReplicatedStorage:WaitForChild("Configurations")
local dialogues = game.ReplicatedStorage:WaitForChild("NPCs")
local activeInteractions = {}

local function getDialogue(id)
	
	local module = dialogues:FindFirstChild(id)
	
	if module and module:IsA("ModuleScript") then
		return require(module)
	end
	
	return nil
	
end

local function filterChoices(entry, player)
	
	local filtered = {}
	
	for _, choice in ipairs(entry.choices or {}) do
		
		local conditionMet = true
		
		if choice.condition then
			conditionMet = choice.condition(player)
		end
		
		if conditionMet or choice.fail then
			table.insert(filtered, {
				text = choice.text,
				next = choice.next
			})
		end
		
	end
	
	return filtered
	
end

local function sendEntry(player, entry, index)
	
	local interaction = activeInteractions[player.UserId]
	local name = nil
	local id = nil
	
	if index == 1 and entry.id then
		
		id = entry.id
		
		local success, result = pcall(function()
			return game.Players:GetNameFromUserIdAsync(id)
		end)
		
		if success then
			name = result

		end
		
	end
	
	remoteEvents.StartNPCDialogue:FireClient(player, {
		name = name,
		id = id,
		text = entry.text,
		index = index,
		choices = filterChoices(entry, player),
		target = interaction.npc.PrimaryPart or interaction.npc
	})
	
end

local function startDialogue(player, npc)
	
	if activeInteractions[player.UserId] then
		return
	end
	
	local id = npc:FindFirstChild("DialogueId")
	
	if not id then
		return
	end
	
	id.Value = npc.Name
	
	local dialogue = getDialogue(id.Value)
	
	if not dialogue then
		return
	end
	
	activeInteractions[player.UserId] = {
		dialogue = dialogue,
		npc = npc
	}
	
	sendEntry(player, dialogue[1], 1)
	
end

remoteEvents.NPCDialogueChoiceMade.OnServerEvent:Connect(function(player, chosenNext, currentIndex)
	
	if chosenNext == "end" then
		activeInteractions[player.UserId] = nil
		return
	end
	
	local session = activeInteractions[player.UserId]
	
	if not session then
		return
	end
	
	local dialogue = session.dialogue
	local currentEntry = dialogue[currentIndex]
	
	if not currentEntry then
		return
	end
	
	local selection
	
	for _, choice in ipairs(currentEntry.choices or {}) do
		if choice.next == chosenNext then
			selection = choice
			break
		end
	end
	
	if not selection then
		activeInteractions[player.UserId] = nil
		return
	end
	
	local conditionMet = true
	
	if selection.condition then
		conditionMet = selection.condition(player)
	end
	
	local correspondingNext
	
	if conditionMet then
		correspondingNext = selection.next
	else
		correspondingNext = selection.fail or "end"
	end
	
	if correspondingNext == "end" then
		activeInteractions[player.UserId] = nil
		remoteEvents.StartNPCDialogue:FireClient(player, nil, "end")
	elseif correspondingNext == "cutscene" then
		activeInteractions[player.UserId] = nil
		remoteEvents.StartNPCDialogue:FireClient(player, nil, "cutscene")
	else
		sendEntry(player, dialogue[correspondingNext], correspondingNext)
	end
	
end)

for _, model in workspace:GetDescendants() do
	if model then
		if model:FindFirstChild("DialogueId") then 
			
			local prompt = Instance.new("ProximityPrompt")
			prompt.ActionText = "Talk"
			prompt.KeyboardKeyCode = Enum.KeyCode.F
			prompt.MaxActivationDistance = 12
			prompt.RequiresLineOfSight = false
			prompt.Parent = model.HumanoidRootPart

			if prompt.Parent then
				
				local parent = prompt.Parent
				local npc = parent and parent.Parent

				if npc and npc:FindFirstChild("DialogueId") then

					for name, value in pairs(configurations.NPCs:GetAttributes()) do

						if npc.Name == name then
							prompt.ObjectText = game.Players:GetNameFromUserIdAsync(value)
						end

						configurations.NPCs:GetAttributeChangedSignal(name):Connect(function(new)
							if npc.Name == name then
								prompt.ObjectText = game.Players:GetNameFromUserIdAsync(new)
							end
						end)

					end


					prompt.Triggered:Connect(function(player)
						startDialogue(player, npc)
					end)

				end
				
			end
		end
	end
end
