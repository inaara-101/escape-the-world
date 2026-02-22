local TweenService = game:GetService("TweenService")
local player = game.Players.LocalPlayer

for _, v in workspace:GetDescendants() do
	if string.sub(v.Name, 1, 6) == "Button" and v.Name ~= "Button" and v:IsA("Model") then

		v:SetAttribute("Triggered", false)

		for _, vv in workspace:GetDescendants() do
			if vv.Name == v.Name and vv:IsA("Folder") then
				v.Button.ClickArea.Touched:Connect(function(hit)
					if hit.Parent == player.Character then

						if v:GetAttribute("Triggered") then
							return
						end
						
						v:SetAttribute("Triggered", true)

						local label = player.PlayerGui.ButtonGui.TimeRemaining
						local stroke = label.UIStroke
						local labelTween1 = TweenService:Create(label, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {TextTransparency = 0})
						local strokeTween1 = TweenService:Create(stroke, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Transparency = 0})
						local labelTween2 = TweenService:Create(label, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {TextTransparency = 1})
						local strokeTween2 = TweenService:Create(stroke, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Transparency = 1})

						v.Sound:Play()

						v.Button.ClickArea.BrickColor = BrickColor.new("Shamrock")
						v.Button.ClickArea.Material = Enum.Material.Neon

						for _, vvv in vv:GetDescendants() do
							if vvv:IsA("BasePart") then
								local tween = TweenService:Create(vvv, TweenInfo.new(1), {Transparency = 1})
								tween:Play()
								vvv.CanCollide = false
							end
						end

						labelTween1:Play()
						strokeTween1:Play()

						for i = v.Interval.Value, 0, -1 do
							label.Text = tostring(i)
							task.wait(1)
						end

						v.Button.ClickArea.BrickColor = BrickColor.new("Institutional white")
						v.Button.ClickArea.Material = Enum.Material.SmoothPlastic

						for _, vvv in vv:GetDescendants() do
							if vvv:IsA("BasePart") then
								local tween = TweenService:Create(vvv, TweenInfo.new(1), {Transparency = 0})
								tween:Play()
								vvv.CanCollide = true
							end
						end

						labelTween2:Play()
						strokeTween2:Play()

						v:SetAttribute("Triggered", false)

					end
				end)
			end
		end
	end
end
