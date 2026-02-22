local dataManager = require(game.ServerScriptService:WaitForChild("Core"):WaitForChild("DataManager"))
local configurations = game.ReplicatedStorage:WaitForChild("Configurations")

local dialogue = {
	[1] = {
		id = configurations.NPCs:GetAttribute(script.Name),
		text = "Whew! It sure is HOT here. You alright?",
		choices = {
			{
				text = "No... I need water... Please...",
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
				text = "Yup. Bye!",
				next = "end"
			}
		}
	},
	[2] = {
		text = "Sorry, mate. My water canteen is empty...",
		choices = {
			{
				text = ":(",
				next = "end"
			}
		}
	},
	[3] = {
		text = "Thank goodness! Let's put an end to this burning madness, shall we?",
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
