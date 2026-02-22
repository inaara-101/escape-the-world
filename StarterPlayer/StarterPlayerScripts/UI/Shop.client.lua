local CollectionService = game:GetService("CollectionService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local DebrisService = game:GetService("Debris")
local remoteEvents = game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Events")
local remoteFunctions = game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Functions")
local soundEffects = game.ReplicatedStorage:WaitForChild("SoundEffects")
local configurations = game.ReplicatedStorage:WaitForChild("Configurations")
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local shopButton = playerGui:WaitForChild("UI"):WaitForChild("Left"):WaitForChild("ShopButton")
local shop = playerGui:WaitForChild("UI"):WaitForChild("Shop"):WaitForChild("Frame")
local xButton = shop:WaitForChild("XButton")
local coinsButton = shop:WaitForChild("CoinsButton")
local passesButton = shop:WaitForChild("PassesButton")
local productsButton = shop:WaitForChild("ProductsButton")
local activePage = shop:WaitForChild("ActivePage")
local coinsPage = shop:WaitForChild("CoinsPage")
local passesPage = shop:WaitForChild("PassesPage")
local productsPage = shop:WaitForChild("ProductsPage")
local effect = shopButton:WaitForChild("Effect")
local speed = effect:WaitForChild("Speed")
local animationInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local teeterInfo = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
local expanded = UDim2.new(0.571, 0, 0.668, 0)
local collapsed = UDim2.new(0, 0, 0, 0)
local visible = false
local stageData

repeat task.wait() until player:WaitForChild("leaderstats"):WaitForChild("Stage").Value ~= nil

stageData = player.leaderstats.Stage.Value

remoteEvents.SendStageData.OnClientEvent:Connect(function(data)
	stageData = data
end)

shop.Size = collapsed
shop.Parent.Visible = true

RunService.RenderStepped:Connect(function(dt)
	effect.Rotation = effect.Rotation + speed.Value * dt
end)

activePage:GetPropertyChangedSignal("Value"):Connect(function()
	for _, page in pairs(shop:GetChildren()) do
		if table.find(CollectionService:GetTags(page), "Page") then
			page.Visible = (page.Name == activePage.Value)
		end
	end
end)

activePage.Value = "PassesPage"

shopButton.MouseButton1Click:Connect(function()
	
	local sound = soundEffects.UIButtonPress:Clone()
	sound.Parent = game.SoundService
	sound:Play()
	DebrisService:AddItem(sound, sound.TimeLength + 1)
	
	local target = visible and collapsed or expanded
	local expandTween = TweenService:Create(shop, animationInfo, {Size = target})
	
	expandTween:Play()
	
	visible = not visible
	
end)

xButton.MouseButton1Click:Connect(function()
	
	local sound = soundEffects.UIButtonPress:Clone()
	sound.Parent = game.SoundService
	sound:Play()
	DebrisService:AddItem(sound, sound.TimeLength + 1)
	
	local target = collapsed
	local collapseTween = TweenService:Create(shop, animationInfo, {Size = target})
	
	collapseTween:Play()
	
	visible = false
	
end)

task.spawn(function()
	while true do
		TweenService:Create(coinsPage.BestValue, teeterInfo, {Rotation = coinsPage.BestValue.Rotation + 10}):Play()
		task.wait(0.5)
		TweenService:Create(coinsPage.BestValue, teeterInfo, {Rotation = coinsPage.BestValue.Rotation - 10}):Play()
		task.wait(0.5)
	end
end)

coinsButton.MouseButton1Click:Connect(function()
	
	local sound = soundEffects.UIButtonPress:Clone()
	sound.Parent = game.SoundService
	sound:Play()
	DebrisService:AddItem(sound, sound.TimeLength + 1)
	
	activePage.Value = "CoinsPage"
	
end)

passesButton.MouseButton1Click:Connect(function()
	
	local sound = soundEffects.UIButtonPress:Clone()
	sound.Parent = game.SoundService
	sound:Play()
	DebrisService:AddItem(sound, sound.TimeLength + 1)
	
	activePage.Value = "PassesPage"
	
end)

productsButton.MouseButton1Click:Connect(function()
	
	local sound = soundEffects.UIButtonPress:Clone()
	sound.Parent = game.SoundService
	sound:Play()
	DebrisService:AddItem(sound, sound.TimeLength + 1)
	
	activePage.Value = "ProductsPage"
	
end)

remoteEvents.CoinsBought.OnClientEvent:Connect(function()
	local sound = soundEffects.BoughtCoins:Clone()
	sound.Parent = game.SoundService
	sound:Play()
	DebrisService:AddItem(sound, sound.TimeLength + 1)
end)

for _, imageLabel in pairs(coinsPage:GetChildren()) do
	if imageLabel:IsA("ImageLabel") and imageLabel:FindFirstChild("BuyButton") then
		
		local buyButton = imageLabel.BuyButton
		local name, price, description, icon = remoteFunctions.GetDeveloperProductInformation:InvokeServer(imageLabel.id.Value)
		
		imageLabel.NameText.Text = name
		buyButton.ButtonText.Text = price
		
		buyButton.MouseButton1Click:Connect(function()
			
			local sound = soundEffects.UIButtonPress:Clone()
			sound.Parent = game.SoundService
			sound:Play()
			DebrisService:AddItem(sound, sound.TimeLength + 1)
			
			remoteEvents.DeveloperProductPurchaseRequest:FireServer(imageLabel.Name)
			
		end)
		
	end
end

for _, imageLabel in pairs(passesPage:GetChildren()) do
	if imageLabel:IsA("ImageLabel") and imageLabel:FindFirstChild("BuyButton") then
		
		local buyButton = imageLabel.BuyButton
		local name, price, description, icon = remoteFunctions.GetGamepassInformation:InvokeServer(imageLabel.id.Value)

		imageLabel.NameText.Text = name
		buyButton.ButtonText.Text = price
		imageLabel.DescriptionText.Text = description
		imageLabel.Icon.Image = icon

		buyButton.MouseButton1Click:Connect(function()
			if buyButton.ButtonText.Text ~= "OWNED" then
				
				local sound = soundEffects.UIButtonPress:Clone()
				sound.Parent = game.SoundService
				sound:Play()
				DebrisService:AddItem(sound, sound.TimeLength + 1)
				
				remoteEvents.GamepassPurchaseRequest:FireServer(imageLabel.Name)
				
			end
		end)
		
	end
end

for _, imageLabel in pairs(productsPage:GetChildren()) do
	if imageLabel:IsA("ImageLabel") and imageLabel:FindFirstChild("BuyButton") then
		
		local buyButton = imageLabel.BuyButton
		local name, price, description, icon = remoteFunctions.GetDeveloperProductInformation:InvokeServer(imageLabel.id.Value)
		
		imageLabel.NameText.Text = string.upper(name)
		buyButton.ButtonText.Text = price
		imageLabel.Icon.Image = icon
		
		buyButton.MouseButton1Click:Connect(function()
			
			local sound = soundEffects.UIButtonPress:Clone()
			sound.Parent = game.SoundService
			sound:Play()
			DebrisService:AddItem(sound, sound.TimeLength + 1)
			
			if imageLabel.Name == "SkipStage" or imageLabel.Name == "SkipToEnd" then
				if stageData == configurations.BiomeEnd:GetAttribute(configurations.LastBiome:GetAttribute("LastBiome")) then
					game.StarterGui:SetCore("SendNotification", {Title = "Can't Buy", Text = "You're already at the end of the obby!", Icon = "rbxassetid://131995891560028"})
					return
				end
			end
			
			remoteEvents.DeveloperProductPurchaseRequest:FireServer(imageLabel.Name)
			
		end)
		
	end
end
