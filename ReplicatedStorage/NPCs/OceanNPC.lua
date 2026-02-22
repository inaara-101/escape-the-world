local dataManager = require(game.ServerScriptService:WaitForChild("Core"):WaitForChild("DataManager"))
local configurations = game.ReplicatedStorage:WaitForChild("Configurations")

local dialogue = {
	[1] = {
		id = configurations.NPCs:GetAttribute(script.Name),
		text = "Man, I love swimming. I want to be a fish when I grow up... Oh, HELLO! I didn't see you there. I was just joking about wanting to be a fish, by the way. Heh... Anywho, what are you up to?",
		choices = {
			{
				text = "Why would you want to be a fish?",
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
				text = "Not much. Bye!",
				next = "end"
			}
		}
	},
	[2] = {
		text = "Because they're so adorable, and uh- Wait, no. I said I was joking. Stop messing with me!",
		choices = {
			{
				text = "Riiiight. Okay.",
				next = "end"
			}
		}
	},
	[3] = {
		text = "Perfect! Are you ready to dry off?",
		choices = {
			{
				text = "YES!",
				next = 5
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
	},
	[5] = {
		text = "It looks like the developers are still working on building the next biome for you! Come back during the next update. Until then, be sure to like the game and favorite it to show your support! You can still go back to previous stages in the obby and troll players...",
		choices = {
			{
				text = "Okay.",
				next = "end"
			}
		}
	}
}

return dialogue
