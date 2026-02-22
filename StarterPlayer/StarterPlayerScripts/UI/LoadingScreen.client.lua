local ContentProviderService = game:GetService("ContentProvider")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local loadingScreen = playerGui:WaitForChild("UI"):WaitForChild("LoadingScreen")
local map = loadingScreen:WaitForChild("Map")
local teeterInfo = TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
local tasks = {"Loading assets", "Rendering biomes", "Fetching data", "Loading user interface", "Finalizing", "Finalizing"}
local dots = {".", "..", "..."}
local dotIndex = 1
local currentPercent = 0
local running = true

loadingScreen.Visible = true

game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)

map.HeaderText.Rotation = -4
TweenService:Create(map.HeaderText, teeterInfo, {Rotation = 4}):Play()

RunService.RenderStepped:Connect(function(dt)
	map.LoadingWheel.Rotation = map.LoadingWheel.Rotation - map.LoadingWheel.Speed.Value * dt
end)

task.spawn(function()
	while running do
		
		map.LoadingText.Text = string.format("Loading%s", dots[dotIndex])
		dotIndex += 1
		
		if dotIndex > #dots then
			dotIndex = 1
		end
		
		task.wait(0.3)
		
	end
end)

for i, currentTask in ipairs(tasks) do
	task.wait(0.9)
end

running = false
map.LoadingText.Text = "Complete!"
task.wait(0.5)
loadingScreen:TweenPosition(UDim2.new(0, 0, -1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 1.5)
game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, true)
task.wait(5)
loadingScreen:Destroy()
script:Destroy()
