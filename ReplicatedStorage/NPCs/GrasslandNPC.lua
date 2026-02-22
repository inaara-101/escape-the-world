local dataManager = require(game.ServerScriptService:WaitForChild("Core"):WaitForChild("DataManager"))
local configurations = game.ReplicatedStorage:WaitForChild("Configurations")

local dialogue = {
	[1] = {
		id = configurations.NPCs:GetAttribute(script.Name),
		text = "Greetings, fellow traveler. What brings you here?",
		choices = {
			{
				text = "Just exploring.",
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
		text = "Have fun! Just don't fall into the water. The currents are deadly.",
		choices = {
			{
				text = "Thanks for the warning.",
				next = "end"
			}
		}
	},
	[3] = {
		text = "That's great! Let's leave this greenery behind, shall we?",
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
