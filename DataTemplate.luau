local dataTemplate = {
	
	Stage = 1,
	
	Coins = 0,
	
	CurrentBiome = "Grassland",
	
	Deaths = 0,
	
	TimePlayed = 0,
	
	LoginStreak = 0,
	LastLoginDate = 0,
	
	FreeSkips = 0,
	FreeSkipTimeLeft = 0,
	LastFreeSkipTimerUpdate = 0,

	MusicVolume = 0.4,
	SFXVolume = 0.5,
	
	GraphicsQuality = "High",
	
	Invincibility = false,
	
	Gamepasses = {
		["1386998947"] = {owned = false, awarded = false}, -- Invincibility
	},
	
	RedeemedCodes = {},
	
	TrollsBought = 0
	
}

return dataTemplate
