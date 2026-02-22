local dataManager = require(game.ServerScriptService:WaitForChild("Core"):WaitForChild("DataManager"))
local configurations = game.ReplicatedStorage:WaitForChild("Configurations")

local dialogue = {
	[1] = {
		id = configurations.NPCs:GetAttribute(script.Name),
		text = "Why, hello there. You've survived the pits and depths of the Underworld. Where are you headed?",
		choices = {
			{
				text = "What is this place?",
				next = 2
			},
			{
				text = "I'm ready to unlock the next biome!",
				next = 3,
				fail = 4,
				condition = function(player)
					return true
				end,
			},
			{
				text = "Away from you. Bye!",
				next = "end"
			}
		}
	},
	[2] = {
		text = "I'm pretty sure the developers wanted this to be a ROBLOX version of hell.",
		choices = {
			{
				text = "Interesting...",
				next = "end"
			}
		}
	},
	[3] = {
		text = "Good. Want to get out of here?",
		choices = {
			{
				text = "YES!",
				next = "cutscene"
			},
			{
				text = "No.",
				next = "end"
			}
		}
	},
	[4] = {
		text = "There was an error while trying to unlock the next biome. Try again later.",
		choices = {
			{
				text = "Okay.",
				next = "end"
			}
		}
	}
}

return dialogue
