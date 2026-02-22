local dataManager = require(game.ServerScriptService:WaitForChild("Core"):WaitForChild("DataManager"))
local configurations = game.ReplicatedStorage:WaitForChild("Configurations")

local dialogue = {
	[1] = {
		id = configurations.NPCs:GetAttribute(script.Name),
		text = "Brrr... It's s-so cold. I can't f-feel my legs. C-can I help you?",
		choices = {
			{
				text = "Um, are you okay?",
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
				text = "Nope. Bye!",
				next = "end"
			}
		}
	},
	[2] = {
		text = "No, I'm c-clearly struggling.",
		choices = {
			{
				text = ":(",
				next = "end"
			}
		}
	},
	[3] = {
		text = "Phew! One m-more second, and I ought to f-freeze to d-death. You coming?",
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
