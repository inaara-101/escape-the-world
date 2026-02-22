local dataManager = require(game.ServerScriptService:WaitForChild("Core"):WaitForChild("DataManager"))
local configurations = game.ReplicatedStorage:WaitForChild("Configurations")

local dialogue = {
	[1] = {
		id = configurations.NPCs:GetAttribute(script.Name),
		text = "Hey! I've been up on this rock taking a break. My legs hurt from all the hiking I did through this cave. What about you?",
		choices = {
			{
				text = "Not much. Still exploring.",
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
				text = "Nothing. Bye!",
				next = "end"
			}
		}
	},
	[2] = {
		text = "Okay, I'll be here if you need me. By the way, that orange stuff below us is NOT orange juice... I learned the hard way...",
		choices = {
			{
				text = "Yeah, I figured...",
				next = "end"
			}
		}
	},
	[3] = {
		text = "Really? Awesome! Are you ready to get out of this dangerous cave?",
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
