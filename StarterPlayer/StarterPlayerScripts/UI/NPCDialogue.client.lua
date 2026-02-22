local RunService = game:GetService("RunService")
local DebrisService = game:GetService("Debris")
local remoteEvents = game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Events")
local bindables = game.ReplicatedStorage:WaitForChild("Bindables")
local soundEffects = game.ReplicatedStorage:WaitForChild("SoundEffects")
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local npcDialogue = playerGui:WaitForChild("UI"):WaitForChild("NPCDialogue")
local npcBox = npcDialogue:WaitForChild("NPCBox")
local npcHeadshot = npcBox:WaitForChild("NPCHeadshot")
local npcName = npcBox:WaitForChild("NPCName")
local npcTextContainer = npcBox:WaitForChild("TextContainer")
local choicesList = npcDialogue:WaitForChild("Choices")
local template = choicesList:WaitForChild("Template")
local typingSpeed = 0.02
local activationDistance = 22
local isTyping = false
local skippedTyping = false
local npc = nil

local function typewrite(label, text)
	
	isTyping = true
	skippedTyping = false
	
	label.Text = ""
	
	for i = 1, #text do
		
		if skippedTyping then
			label.Text = text
			break
		end
		
		label.Text = string.sub(text, 1, i)
		
		local sound = soundEffects.Typewriter:Clone()
		sound.Parent = game.SoundService
		sound:Play()
		DebrisService:AddItem(sound, 1)
		
		task.wait(typingSpeed)
		
	end
	
	isTyping = false
	
end

local function loadHeadshot(image, id)
	
	local content, isReady = game.Players:GetUserThumbnailAsync(id, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
	
	if isReady then
		image.Image = content
	end
	
end

local function clearChoices()
	for _, child in choicesList:GetChildren() do
		if child:IsA("ImageButton") and child.Name ~= "Template" then
			child:Destroy()
		end
	end
end

npcTextContainer.InputBegan:Connect(function(input)
	if isTyping and input.UserInputType == Enum.UserInputType.MouseButton1 then
		skippedTyping = true
	end
end)

remoteEvents.StartNPCDialogue.OnClientEvent:Connect(function(entry, signal)
	
	if signal == "cutscene" then
		bindables.BiomeCutsceneRequest:Fire(1)
		return
	elseif signal == "end" or not entry then
		npcDialogue.Visible = false
		clearChoices()
		return		
	end
	
	npcDialogue.Visible = true
	
	local target = entry.target
	
	if typeof(target) == "Instance" and target:IsA("BasePart") then
		npc = target
	end
	
	clearChoices()
	
	if entry.name then
		npcName.Text = entry.name
	end
	
	if entry.id then
		loadHeadshot(npcHeadshot, entry.id)
	end
	
	typewrite(npcTextContainer, entry.text)
	
	for _, choice in ipairs(entry.choices or {}) do
		
		local button = template:Clone()
		button.Name = "Choice"
		button.ChoiceText.Text = choice.text
		button.Visible = true
		button.Parent = choicesList
		
		button.MouseButton1Click:Connect(function()
			
			local sound = soundEffects.UIButtonPress:Clone()
			sound.Parent = game.SoundService
			sound:Play()
			DebrisService:AddItem(sound, sound.TimeLength + 1)
			
			clearChoices()
			npcDialogue.Visible = false
			remoteEvents.NPCDialogueChoiceMade:FireServer(choice.next, entry.index)
			
		end)
		
	end
	
end)

RunService.RenderStepped:Connect(function()
	
	if not npc or not npc:IsDescendantOf(workspace) then
		return
	end
	
	if not npcDialogue.Visible then
		return
	end
	
	local character = player.Character
	
	if not character or not character:FindFirstChild("HumanoidRootPart") then
		return
	end
	
	local hrp = character.HumanoidRootPart
	local distance = (hrp.Position - npc.Position).Magnitude
	
	if distance > activationDistance then
		npcDialogue.Visible = false
		clearChoices()
		npc = nil
		remoteEvents.NPCDialogueChoiceMade:FireServer("end", 0)
	end
	
end)
