SelectableMeals = {}
ThisRunFish = {}
hasBeenUsed = false
SelectedFish = nil
SaveIgnores["SelectableMeals"] = true
SaveIgnores["MealText"] = true
OnAnyLoad{ "DeathArea",
function( triggerArgs )

		DeathLoopData["DeathArea"]["ObstacleData"][423399]["OnUsedFunctionName"] = "ShowCuisineScreen"
		DeathLoopData["DeathArea"]["ObstacleData"][423399]["SetupFunctions"] =
		{
			{
			Name = "PlayStatusAnimation",
			Args = { Animation = "StatusIconWantsToTalk", },
			GameStateRequirements =
			{
				RequiredFalseFlags = { "InFlashback", },
			},
			},
		}
		if hasBeenUsed then
		DeathLoopData["DeathArea"]["ObstacleData"][423399]["SetupGameStateRequirements"] ={
			AreIdsNotAlive = {40000}
		}
		else
		--[[TODO: Add more fish:
			,
			Fish_Elysium_Legendary_01,
			Fish_Styx_Common_01,

		]]--
		SelectableMeals = {
				--Tartarus
			"Fish_Tartarus_Common_01",
			"Fish_Tartarus_Rare_01",
			"Fish_Tartarus_Legendary_01",
				--Asphodel
			"Fish_Asphodel_Common_01",
			"Fish_Asphodel_Rare_01",
			"Fish_Asphodel_Legendary_01",
				--Elysium
			"Fish_Elysium_Common_01",
			"Fish_Elysium_Rare_01",
				--Styx
			"Fish_Styx_Rare_01",
			"Fish_Styx_Legendary_01",
				--Surface
			"Fish_Surface_Common_01",
			"Fish_Surface_Rare_01",
			"Fish_Surface_Legendary_01",
				--Chaos
			"Fish_Chaos_Common_01",
			"Fish_Chaos_Rare_01",
			"Fish_Chaos_Legendary_01",
				--Other
			--"StackUpgrade",
			"RoomRewardHealDrop",
			"GemDrop",
		}
		ThisRunFish = {}
		for i = 1, 3 do
		table.insert(ThisRunFish, RemoveRandomValue(SelectableMeals))
		end
		SelectedFish = nil
		DeathLoopData["DeathArea"]["ObstacleData"][423399]["SetupGameStateRequirements"] ={
		}
		CurrentlySelectedMealFish = {}
		end
	end
}
function ShowCuisineScreen(usee)
	local screen = { Components = {} }
	screen.Name = "Cuisine"

	if IsScreenOpen( screen.Name ) then
		return
	end
OnScreenOpened({ Flag = screen.Name, PersistCombatUI = true })
	FreezePlayerUnit()
	EnableShopGamepadCursor()
	SetConfigOption({ Name = "FreeFormSelectWrapY", Value = false })
	SetConfigOption({ Name = "FreeFormSelectStepDistance", Value = 8 })
	SetConfigOption({ Name = "FreeFormSelectSuccessDistanceStep", Value = 8 })
	SetConfigOption({ Name = "FreeFormSelectRepeatDelay", Value = 0.6 })
	SetConfigOption({ Name = "FreeFormSelectRepeatInterval", Value = 0.1 })
	SetConfigOption({ Name = "FreeFormSelecSearchFromId", Value = 0 })

	PlaySound({ Name = "/SFX/Menu Sounds/ContractorMenuOpen" })
	local components = screen.Components
	
	components.ShopBackgroundDim2 = CreateScreenComponent({ Name = "rectangle01", Group = "Combat_UI_World" })
	components.ShopBackground = CreateScreenComponent({ Name = "WellShopBackground", Group = "Combat_UI_World" })
	components.ShopBackgroundDim = CreateScreenComponent({ Name = "rectangle01", Group = "Combat_UI_World" })
	
	components.CloseButton = CreateScreenComponent({ Name = "ButtonClose", Group = "Combat_UI_Backing", Scale = 0.7 })
	Attach({ Id = components.CloseButton.Id, DestinationId = components.ShopBackground.Id, OffsetX = 0, OffsetY = 440 })
	components.CloseButton.OnPressedFunctionName = "CloseCuisineScreen"
	components.CloseButton.ControlHotkey = "Cancel"
	
	SetAlpha({ Id = components.ShopBackground.Id, Fraction = 1, Duration = 0 })
	SetScale({ Id = components.ShopBackgroundDim.Id, Fraction = 4 })
	SetColor({ Id = components.ShopBackgroundDim.Id, Color = {1, 1, 0, 0} })
	
	components.fishingTurnInButton = 
		CreateScreenComponent({ 
			Name = "BoonSlot1", 
			Group = "Combat_UI_World", 
			Scale = 0.3, 
		})
	components.fishingTurnInButton.usee = usee
	components.fishingTurnInButton.OnPressedFunctionName = "CuisineTurnInFish"
	components.fishingTurnInButton.X = 0
	components.fishingTurnInButton.Y = 0
	Attach({ Id = components.fishingTurnInButton.Id, DestinationId = components.ShopBackground.Id, OffsetX = 600, OffsetY = 0 })
	CreateTextBox({ Id = components.fishingTurnInButton.Id, Text = "Turn In Fish",
		FontSize = 22, OffsetX = 0, OffsetY = 0, Width = 720, Color = color, Font = "AlegreyaSansSCLight",
		ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2}, Justification = "Center"
	})
	
	components.recipeScreenButton = 
	CreateScreenComponent({ 
		Name = "BoonSlot1", 
		Group = "Combat_UI_World", 
		Scale = 0.3, 
	})
	components.recipeScreenButton.usee = usee
	components.recipeScreenButton.OnPressedFunctionName = "CuisineOpenRecipeMenu"
	components.recipeScreenButton.oldScreen = screen
	components.recipeScreenButton.X = 0
	components.recipeScreenButton.Y = 0
	Attach({ Id = components.recipeScreenButton.Id, DestinationId = components.ShopBackground.Id, OffsetX = -600, OffsetY = 0 })
	CreateTextBox({ Id = components.recipeScreenButton.Id, Text = "Cook a Custom Meal",
	FontSize = 22, OffsetX = 0, OffsetY = 0, Width = 720, Color = color, Font = "AlegreyaSansSCLight",
	ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2}, Justification = "Center"
	})
	wait(0.25)

	-- Title
	CreateTextBox({ Id = components.ShopBackground.Id, Text = "Meal Selector", FontSize = 32, OffsetX = 0, OffsetY = -445, Color = Color.White, Font = "SpectralSCLightTitling", ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 3}, Justification = "Center" })
	local flavorTextOptions = { "Salivating", "A Wonderful Aroma", "1 Dish is Not Nearly Enough", "The Prince Realizes How Lucky he is to Taste This Food Forever"}
	local flavorText = GetRandomValue( flavorTextOptions )
	CreateTextBox({ Id = components.ShopBackground.Id, Text = flavorText,FontSize = 14, OffsetX = 0, OffsetY = 380, Width = 840, Color = Color.Gray, Font = "AlegreyaSansSCBold", ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2}, Justification = "Center" })

	-- Flavor Text

	CreateTextBox(MergeTables({ Id = components.ShopBackground.Id, Text = "One of the many meals that the Chef has made. There are many mouths,but,you may take one.",
			FontSize = 16,
			OffsetY = -385, Width = 840,
			Color = {0.698, 0.702, 0.514, 1.0},
			Font = "AlegreyaSansSCRegular",
			ShadowBlur = 0, ShadowColor = {0,0,0,0}, ShadowOffset={0, 3},
			Justification = "Center",
		}, LocalizationData.SellTraitScripts.FlavorText))
	CreateCuisineButtons(screen, usee)
		
	screen.KeepOpen = true
	thread( HandleWASDInput, screen )
	HandleScreenInput( screen )

end
function CloseCuisineScreen( screen, button )
	DisableShopGamepadCursor()
	SetConfigOption({ Name = "FreeFormSelectStepDistance", Value = 16 })
	SetConfigOption({ Name = "FreeFormSelectSuccessDistanceStep", Value = 8 })
	SetConfigOption({ Name = "FreeFormSelectRepeatDelay", Value = 0.0 })

	PlaySound({ Name = "/SFX/Menu Sounds/ContractorMenuClose" })
	CloseScreen( GetAllIds( screen.Components ) )

	UnfreezePlayerUnit()
	screen.KeepOpen = false
	OnScreenClosed({ Flag = screen.Name })

end
function CreateCuisineButtons(screen, usee)
	
	local itemLocationStartY = 340
	local itemLocationYSpacer = 220
	local itemLocationMaxY = itemLocationStartY + 4 * itemLocationYSpacer

	local itemLocationStartX = 1920/2
	local itemLocationXSpacer = 820
	local itemLocationMaxX = itemLocationStartX + 1 * itemLocationXSpacer

	local itemLocationTextBoxOffset = 380

	local itemLocationX = itemLocationStartX
	local itemLocationY = itemLocationStartY

	local components = screen.Components

	local numButtons = 3
	if numButtons == nil then
		numButtons = 0
		for i, groupData in pairs( StoreData.WorldShop.GroupsOf ) do
			numButtons = numButtons + groupData.Offers
		end
	end

	local firstUseable = false
	for itemIndex = 1, numButtons do
		local curFish = ThisRunFish[itemIndex]
		local purchaseButtonKey = "PurchaseButton"..itemIndex
		components[purchaseButtonKey] = CreateScreenComponent({ Name = "MarketSlot", Group = "Combat_Menu", Scale = 1, X = itemLocationX, Y = itemLocationY })
		SetInteractProperty({ DestinationId = components[purchaseButtonKey].Id, Property = "TooltipOffsetX", Value = 665 })
		
		SetScaleY({ Id = components[purchaseButtonKey].Id , Fraction = 2 })
		SetScaleX({ Id = components[purchaseButtonKey].Id , Fraction = 1.05 })
		components[purchaseButtonKey].usee = usee
		components[purchaseButtonKey].Boon = curFish
		components[purchaseButtonKey].OnPressedFunctionName = "GiveFishBoon"
			
		local iconKey = "Icon"..itemIndex
		components[iconKey] = CreateScreenComponent({ Name = "BlankObstacle", X = itemLocationX, Y = itemLocationY, Group = "Combat_Menu" })

		local itemBackingKey = "Backing"..itemIndex
		components[itemBackingKey] = CreateScreenComponent({ Name = "BlankObstacle", Group = "Combat_Menu", X = itemLocationX, Y = itemLocationY })

		local purchaseButtonTitleKey = "PurchaseButtonTitle"..itemIndex
		components[purchaseButtonTitleKey] = CreateScreenComponent({ Name = "BlankObstacle", Group = "Combat_Menu", Scale = 1, X = itemLocationX, Y = itemLocationY })
				CreateTextBoxWithFormat(MergeTables({
					Id = curFish .. "_Trait",
					OffsetX = -260,
					OffsetY = 0,
					Width = 665,
					Justification = "Left",
					VerticalJustification = "Top",
					LineSpacingBottom = 8,
					UseDescription = true,
					Format = "BaseFormat",
					VariableAutoFormat = "BoldFormatGraft",
					TextSymbolScale = 0.8,
				}, LocalizationData.TraitTrayScripts.DetailsBacking ))

		CreateTextBox(MergeTables({ Id = components[itemBackingKey].Id, Text = curFish .. "_Trait",
			FontSize = 25,
			OffsetX = -275, OffsetY = -50,
			Width = 720,
			Color = {0.988, 0.792, 0.247, 1},
			Font = "AlegreyaSansSCBold",
			ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2},
			Justification = "Left",
		},LocalizationData.SellTraitScripts.FlavorText))

		
		components[purchaseButtonTitleKey .. "Icon"] = CreateScreenComponent({ Name = "BlankObstacle", Group = "Combat_Menu", Scale = 1 })
		if curFish == "StackUpgrade" then
		SetAnimation({ Name = "Tilesets\\Gameplay\\Gameplay_StackUpgrade_01", DestinationId = components[purchaseButtonTitleKey .. "Icon"].Id, Scale = 0.7 })
		elseif curFish == "RoomRewardHealDrop" then
		SetAnimation({ Name = "Tilesets\\Gameplay\\Gameplay_HealthItem_02", DestinationId = components[purchaseButtonTitleKey .. "Icon"].Id, Scale = 0.7 })
		elseif curFish == "GemDrop" then
		SetAnimation({ Name = "Tilesets\\Gameplay\\Gameplay_Gemstones_01", DestinationId = components[purchaseButtonTitleKey .. "Icon"].Id, Scale = 0.7 })
		else
		SetAnimation({ Name = curFish, DestinationId = components[purchaseButtonTitleKey .. "Icon"].Id, Scale = 0.2 })
		end
		Attach({ Id = components[purchaseButtonTitleKey .. "Icon"].Id, DestinationId = components[purchaseButtonTitleKey].Id, OffsetX = -375, OffsetY = 0})
		
		components[purchaseButtonKey.."Frame"] = CreateScreenComponent({ Name = "BoonInfoTraitFrame", Group = "Combat_Menu_TraitTray", X = itemLocationX - 375, Y = itemLocationY, Scale = 0.8 })
		SetScale({ Id = components[purchaseButtonKey.."Frame"].Id, Fraction = 0.85 })
				CreateTextBoxWithFormat({ Id = components[purchaseButtonKey].Id, Text = curFish .. "_Trait",
					FontSize = 20,
					OffsetX = -275, OffsetY = -25,
					Width = 720,
					Color = Color.White,
					Justification = "Left",
					VerticalJustification = "Top",
					UseDescription = true,
					Format = "MarketScreenDescriptionFormat",
				})
		itemLocationX = itemLocationX + itemLocationXSpacer
		if itemLocationX >= itemLocationMaxX then
			itemLocationX = itemLocationStartX
			itemLocationY = itemLocationY + itemLocationYSpacer
			local increment = 0

		end
	end
end
function GiveFishBoon(screen, button)
	SelectedFish = button.Boon
	hasBeenUsed = true
	if SelectedFish ~= "Fish_Asphodel_Common_01" then
		AddTraitToHero({ TraitData = GetProcessedTraitData({ Unit = CurrentRun.Hero, TraitName = button.Boon .."_Trait", Rarity = "Legendary" }) })
	else
		AddTraitToHero({ TraitData = GetProcessedTraitData({ Unit = CurrentRun.Hero, TraitName = button.Boon .."_Trait_Base", Rarity = "Legendary" }) })
		for i = 1, 100 do
			AddTraitToHero({ TraitData = GetProcessedTraitData({ Unit = CurrentRun.Hero, TraitName = button.Boon .."_Trait_Add", Rarity = "Legendary" }) })
		end
	end
	local partner = button.usee
	partner.NextInteractLines = nil
	StopStatusAnimation( partner, StatusAnimations.WantsToTalk )
	RefreshUseButton( partner.ObjectId, partner )
	UseableOff({ Id = partner.ObjectId })
	CuisineTurnInFish(screen, button)
end
function CuisineTurnInFish( screen, button )
	local usee = button.usee
	
	CloseCuisineScreen(screen,button)
	wait(0.16)
	
	if not GameState.CaughtFish then
		return
	end

	FreezePlayerUnit( "Fishing" )
	thread( MarkObjectiveComplete, "FishPrompt" )

	PlayInteractAnimation( usee.ObjectId )

	StopStatusAnimation( usee )

	thread( PlayVoiceLines, HeroVoiceLines.FishTransactionStartVoiceLines, true )
	SetAnimation({ DestinationId = usee.ObjectId, Name = "ChefGhostChopOnion2_Start" })

	local earnedResources = {}
	local offsetY = 0
	for fishName, fishNum in pairs( GameState.CaughtFish ) do
		if fishNum > 1 then
			thread( InCombatTextArgs, { TargetId= CurrentRun.Hero.ObjectId, Text = "Fishing_TurnIn_Plural", SkipRise = false, SkipFlash = false, Duration = 1.5, OffsetY = offsetY, LuaKey = "TempTextData", LuaValue = { Name = fishName, Amount = fishNum }})
		else
			thread( InCombatTextArgs, { TargetId= CurrentRun.Hero.ObjectId, Text = "Fishing_TurnIn", SkipRise = false, SkipFlash = false, Duration = 1.5, OffsetY = offsetY, LuaKey = "TempTextData", LuaValue = { Name = fishName, Amount = fishNum }})
		end
		offsetY = offsetY - 60
		PlaySound({ Name = "/Leftovers/SFX/BallLandWet" })
		wait(0.75)
		for i = 1, fishNum do
			local fishData = FishingData.FishValues[fishName]
			if fishData and fishData.Award then
				local reward = GetRandomValue( fishData.Award )
				for resourceName, resourceAmount in pairs( reward ) do
					IncrementTableValue( earnedResources, resourceName, resourceAmount )
				end
			end
		end
	end
	wait(0.75)
	for resourceName, resourceAmount in pairs( earnedResources ) do
		AddResource( resourceName, resourceAmount, "Fishing" )
		PlaySound({ Name = "/SFX/Menu Sounds/SellTraitShopConfirm" })
		wait(0.75)
	end

	thread( PlayVoiceLines, HeroVoiceLines.FishTransactionEndVoiceLines, true )

	GameState.CaughtFish = {}
	UnfreezePlayerUnit("Fishing")
end
function CuisineOpenRecipeMenu(screen, button)
	CloseCuisineScreen(screen, button)
	local screen = { Components = {} }
	screen.Name = "Recipe"

	if IsScreenOpen( screen.Name ) then
		return
	end
OnScreenOpened({ Flag = screen.Name, PersistCombatUI = true })
	FreezePlayerUnit()
	EnableShopGamepadCursor()
	SetConfigOption({ Name = "FreeFormSelectWrapY", Value = false })
	SetConfigOption({ Name = "FreeFormSelectStepDistance", Value = 8 })
	SetConfigOption({ Name = "FreeFormSelectSuccessDistanceStep", Value = 8 })
	SetConfigOption({ Name = "FreeFormSelectRepeatDelay", Value = 0.6 })
	SetConfigOption({ Name = "FreeFormSelectRepeatInterval", Value = 0.1 })
	SetConfigOption({ Name = "FreeFormSelecSearchFromId", Value = 0 })

	PlaySound({ Name = "/SFX/Menu Sounds/ContractorMenuOpen" })
	local components = screen.Components
	
	components.ShopBackground = CreateScreenComponent({ Name = "SellShopBackground", Group = "Combat_UI_World"})
	components.ShopBackgroundDim = CreateScreenComponent({ Name = "rectangle01", Group = "Combat_UI_World" })
	
	components.CloseButton = CreateScreenComponent({ Name = "ButtonClose", Group = "Combat_UI_Backing", Scale = 0.7 })
	Attach({ Id = components.CloseButton.Id, DestinationId = components.ShopBackground.Id, OffsetX = 0, OffsetY = 440 })
	components.CloseButton.OnPressedFunctionName = "CloseCuisineScreen"
	components.CloseButton.ControlHotkey = "Cancel"
	
	components.cookMealButton = 
	CreateScreenComponent({ 
		Name = "BoonSlot1", 
		Group = "Combat_UI_World", 
		Scale = 0.3, 
	})
	components.cookMealButton.usee = button.usee
	components.cookMealButton.OnPressedFunctionName = "CuisineCookMealButton"
	components.cookMealButton.X = 0
	components.cookMealButton.Y = 0
	Attach({ Id = components.cookMealButton.Id, DestinationId = components.ShopBackground.Id, OffsetX = 350, OffsetY = 440 })
	CreateTextBox({ Id = components.cookMealButton.Id, Text = "Cook the Meal",
	FontSize = 22, OffsetX = 0, OffsetY = 0, Width = 720, Color = color, Font = "AlegreyaSansSCLight",
	ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2}, Justification = "Center"
	})

	SetAlpha({ Id = components.ShopBackground.Id, Fraction = 1, Duration = 0 })
	SetScale({ Id = components.ShopBackground.Id, Fraction = 2 })
	SetScale({ Id = components.ShopBackgroundDim.Id, Fraction = 4 })
	SetColor({ Id = components.ShopBackgroundDim.Id, Color = {1, 1, 0, 0} })

	wait(0.25)

	-- Title
	CreateTextBox({ Id = components.ShopBackground.Id, Text = "Recipe Selector", FontSize = 32, OffsetX = 0, OffsetY = -445, Color = Color.White, Font = "SpectralSCLightTitling", ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 3}, Justification = "Center" })

	CreateTextBox({ Id = components.ShopBackground.Id, Text = "The chef has allowed Zagreus into his kitchen, to experiment and cook.",FontSize = 14, OffsetX = 0, OffsetY = 380, Width = 840, Color = Color.Gray, Font = "AlegreyaSansSCBold", ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2}, Justification = "Center" })
	
	CreateTextBox(MergeTables({ Id = components.ShopBackground.Id, Text = "Make a recipe. Recipes will show with (Amount of selected fish) + (Amount of other fish) needed to make the meal",
			FontSize = 16,
			OffsetY = -385, Width = 840,
			Color = {0.698, 0.702, 0.514, 1.0},
			Font = "AlegreyaSansSCRegular",
			ShadowBlur = 0, ShadowColor = {0,0,0,0}, ShadowOffset={0, 3},
			Justification = "Center",
		}, LocalizationData.SellTraitScripts.FlavorText))

	CreateRecipeButtons(screen)
	screen.KeepOpen = true
	thread( HandleWASDInput, screen )
	HandleScreenInput( screen )

end
FishData = {}

MealRecipes = {
    ["King's Yellow Shake"] = {
		{Name = "Fish_Tartarus_Legendary_01", Cost = 1},
		{Name = "Fish_Tartarus_Rare_01", Cost = 5},
		"BetterShrinePoints_Trait",
    },
    ["Cthulu Buffet"] = {
        {Name = "Fish_Tartarus_Legendary_01", Cost = 1},
		{Name = "Fish_Chaos_Rare_01", Cost = 1},
		"BetterChaosGates_Trait",
    },
}

--to
FishCombinations = {
}

SaveIgnores["FishData"] = true
SaveIgnores["FishCombinations"] = true
SaveIgnores["MealRecipes"] = true
function ChefDecompressFishCombos()
	for k,v in pairs(MealRecipes) do
		if FishCombinations[v[1].Name] == nil then
			FishCombinations[v[1].Name] = {}
		end
		FishCombinations[v[1].Name][v[2].Name] = {ParentAmount = v[1].Cost, Amount = v[2].Cost, Meal = k, Boon = v[3]}
		if FishCombinations[v[2].Name] == nil then
			FishCombinations[v[2].Name] = {}
		end
		FishCombinations[v[2].Name][v[1].Name] = {ParentAmount = v[2].Cost, Amount = v[1].Cost, Meal = k, Boon = v[3]}
	end
end

function CreateRecipeButtons(screen)
	ChefDecompressFishCombos()
	local itemLocationStartY = -200
	local itemLocationYSpacer = 125

	local itemLocationStartX = -675
	local itemLocationXSpacer = 455
	local itemLocationMaxX = 875

	local itemLocationX = itemLocationStartX
	local itemLocationY = itemLocationStartY

	local components = screen.Components

	for k,v in pairs(GameState.TotalCaughtFish) do
		local itemBackingKey = "Backing"..k
		components[itemBackingKey] = CreateScreenComponent({ Name = "BlankObstacle", Group = "Combat_Menu", X = itemLocationX, Y = itemLocationY })
		Attach({ Id = components[itemBackingKey].Id, DestinationId = components.ShopBackground.Id, OffsetX = itemLocationX, OffsetY = itemLocationY })

		local purchaseButtonKey = "PurchaseButton".. k
		components[purchaseButtonKey] = CreateScreenComponent({ Name = "MarketSlot", Group = "Combat_Menu", Scale = 1 * 0.5, X = itemLocationX, Y = itemLocationY })
		components[purchaseButtonKey].OnPressedFunctionName = "ChefFishSelected"
		components[purchaseButtonKey].FishName = k

		SetScaleY({ Id = components[purchaseButtonKey].Id , Fraction = 2.5 })
		--SetScaleX({ Id = components[purchaseButtonKey].Id , Fraction = 1.05 })
		Attach({ Id = components[purchaseButtonKey].Id, DestinationId = components.ShopBackground.Id, OffsetX = itemLocationX, OffsetY = itemLocationY })

		local iconKey = "Icon"..k
		components[iconKey] = CreateScreenComponent({ Name = "BlankObstacle", X = itemLocationX, Y = itemLocationY, Group = "Combat_Menu" })
		SetAnimation({ Name = k, DestinationId = components[iconKey].Id, Scale = 0.2 })
		Attach({ Id = components[iconKey].Id, DestinationId = components.ShopBackground.Id, OffsetX = itemLocationX - 175, OffsetY = itemLocationY })

		components[itemBackingKey .. "FishName"] = CreateTextBox({ Id = components[itemBackingKey].Id, Text = k,
			FontSize = 25,
			OffsetX = -130, OffsetY = -25,
			Width = 720,
			Color = {0.988, 0.792, 0.247, 1},
			Font = "AlegreyaSansSCBold",
			ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2},
			Justification = "Left",
		})
		components[itemBackingKey .. "StorageName"] = CreateTextBox({ Id = components[itemBackingKey].Id, Text = "In Storage: ",
			FontSize = 20,
			OffsetX = -130, OffsetY = 0,
			Width = 720,
			Color = Color.White,
			Font = "AlegreyaSansSCBold",
			ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2},
			Justification = "Left",
		})
		components[itemBackingKey .. "StorageAmount"] = CreateTextBox({ Id = components[itemBackingKey].Id, Text = v,
			FontSize = 20,
			OffsetX = 10, OffsetY = 0,
			Width = 720,
			Color = {0,1,0,1},
			Font = "AlegreyaSansSCBold",
			ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2},
			Justification = "Left",
		})
		Attach({ Id = components[itemBackingKey].Id, DestinationId = components.ShopBackground.Id, OffsetX = itemLocationX, OffsetY = itemLocationY })
		FishData[k] = {
			Name = k,
			Amount = v,
			Position = {X = itemLocationX, Y = itemLocationY}
		}
		itemLocationX = itemLocationX + itemLocationXSpacer
		if itemLocationX >= itemLocationMaxX then
			itemLocationX = itemLocationStartX
			itemLocationY = itemLocationY + itemLocationYSpacer
		end
	end
end
CurrentlySelectedMealFish = {}
CreatedCheckMarksIds = {}
SaveIgnores["CreatedCheckMarksIds"] = true
SaveIgnores["CurrentlySelectedMealFish"] = true
function ChefFishSelected(screen, button)
	local components = screen.Components
	local FishName = button.FishName
	if CurrentlySelectedMealFish == nil or #CurrentlySelectedMealFish == 0 then
		table.insert(CurrentlySelectedMealFish, FishName)
		for k,v in pairs(components) do
			if string.match(k, "RecipeText") then
				Destroy({Id = v.Id})
			end
		end
		ChefCreateRecipeText(screen, false)
		ChefCreateRecipeChecks(screen)
	elseif  CurrentlySelectedMealFish ~= nil and not Contains(CurrentlySelectedMealFish, FishName) and #CurrentlySelectedMealFish == 1 then
		local compatibleFish = {}
		for k,v in pairs(FishCombinations[CurrentlySelectedMealFish[1]]) do
			table.insert(compatibleFish, k)
		end
		if Contains(compatibleFish, FishName) then
			table.insert(CurrentlySelectedMealFish, FishName)
			for k,v in pairs(components) do
				if string.match(k, "RecipeText") then
					Destroy({Id = v.Id})
				end
			end
			ChefCreateRecipeText(screen, true)
			ChefCreateRecipeChecks(screen)
		end
	elseif CurrentlySelectedMealFish ~= nil and Contains(CurrentlySelectedMealFish, FishName) and CurrentlySelectedMealFish ~= 2 then
		for i = 1, #CurrentlySelectedMealFish do
			if CurrentlySelectedMealFish[i] == FishName then
				table.remove(CurrentlySelectedMealFish, i)
			end
		end
		for i = 1, #CreatedCheckMarksIds do
			if CreatedCheckMarksIds[i] == FishName then
				table.remove(CreatedCheckMarksIds, i)
			end
		end
		for k,v in pairs(components) do
			if string.match(k, "RecipeText") then
				Destroy({Id = v.Id})
			end
		end
		ChefCreateRecipeText(screen, false)
		ChefCreateRecipeChecks(screen)

	end
end

function ChefCreateRecipeText(screen, showOnlyOneRecipe) 
	local components = screen.Components
	for i = 1, #CurrentlySelectedMealFish do
		local CurCombination = FishCombinations[CurrentlySelectedMealFish[i]]
		if CurCombination ~= nil then
				for k,v in pairs(CurCombination) do
					if showOnlyOneRecipe then
						if  Contains(CurrentlySelectedMealFish, k) then
							local itemLocationX = FishData[k].Position.X
							local itemLocationY = FishData[k].Position.Y
							
							local itemBackingKey = "Backing" ..k .. "RecipeText"
							components[itemBackingKey] = CreateScreenComponent({ Name = "BlankObstacle", Group = "Combat_Menu", X = itemLocationX, Y = itemLocationY })
							Attach({ Id = components[itemBackingKey].Id, DestinationId = components.ShopBackground.Id, OffsetX = itemLocationX, OffsetY = itemLocationY })
							
							CreateTextBox({ Id = components[itemBackingKey].Id, Text = "("..v.ParentAmount..") + ("..v.Amount.."): ".. v.Meal,
							FontSize = 20,
							OffsetX = -120, OffsetY = 30,
							Width = 720,
							Color = Color.White,
							Font = "AlegreyaSansSCBold",
							ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2},
							Justification = "Left",
							})
						end
					else
						local itemLocationX = FishData[k].Position.X
						local itemLocationY = FishData[k].Position.Y
						
						local itemBackingKey = "Backing" ..k .. "RecipeText"
						components[itemBackingKey] = CreateScreenComponent({ Name = "BlankObstacle", Group = "Combat_Menu", X = itemLocationX, Y = itemLocationY })
						Attach({ Id = components[itemBackingKey].Id, DestinationId = components.ShopBackground.Id, OffsetX = itemLocationX, OffsetY = itemLocationY })
						
						CreateTextBox({ Id = components[itemBackingKey].Id, Text = "("..v.ParentAmount..") + ("..v.Amount.."): ".. v.Meal,
						FontSize = 20,
						OffsetX = -120, OffsetY = 30,
						Width = 720,
						Color = Color.White,
						Font = "AlegreyaSansSCBold",
						ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2},
						Justification = "Left",
						})
					end

			end
		end
	end
end

function ChefCreateRecipeChecks(screen)
	local components = screen.Components
	for i = 1, #CurrentlySelectedMealFish do
		local FishName = CurrentlySelectedMealFish[i]
		local itemLocationX = FishData[FishName].Position.X
		local itemLocationY = FishData[FishName].Position.Y
		local itemBackingKeyBaseItem = "Backing" .. FishName .. "RecipeTextBaseItem"
		components[itemBackingKeyBaseItem] = CreateScreenComponent({ Name = "BlankObstacle", Group = "Combat_Menu", X = itemLocationX, Y = itemLocationY })
		Attach({ Id = components[itemBackingKeyBaseItem].Id, DestinationId = components.ShopBackground.Id, OffsetX = itemLocationX, OffsetY = itemLocationY })
		components["Backing" .. FishName .. "RecipeTextCheckMarkIcon"] = CreateScreenComponent({ Name = "ButtonConfirm", Group = "Combat_UI_Backing_CheckMark", Scale = 0.525 })
		Attach({ Id = components["Backing" .. FishName .. "RecipeTextCheckMarkIcon"].Id, DestinationId = components[itemBackingKeyBaseItem].Id, OffsetX = 150, OffsetY = -20 })
	end
end
function CuisineCookMealButton(screen,button)
	MealData = FishCombinations[CurrentlySelectedMealFish[1]][CurrentlySelectedMealFish[2]]
	if CurrentlySelectedMealFish ~= nil and #CurrentlySelectedMealFish == 2 and GameState.TotalCaughtFish[CurrentlySelectedMealFish[1]] >= MealData.ParentAmount and GameState.TotalCaughtFish[CurrentlySelectedMealFish[2]] >= MealData.Amount then
		CuisineTurnInFish(screen, button)
		AddTraitToHero({ TraitData = GetProcessedTraitData({ Unit = CurrentRun.Hero, TraitName = MealData.Boon, Rarity = "Legendary" }) })
		SelectedFish = MealData.Boon:gsub("_Trait", "")
		GameState.TotalCaughtFish[CurrentlySelectedMealFish[1]] = GameState.TotalCaughtFish[CurrentlySelectedMealFish[1]] - MealData.ParentAmount
		GameState.TotalCaughtFish[CurrentlySelectedMealFish[2]] = GameState.TotalCaughtFish[CurrentlySelectedMealFish[1]] - MealData.Amount
		thread( InCombatText, CurrentRun.Hero.ObjectId, MealData.Boon, 1.8, { ShadowScale = 0.8 } )
		hasBeenUsed = true
		local partner = button.usee
		partner.NextInteractLines = nil
		StopStatusAnimation( partner, StatusAnimations.WantsToTalk )
		RefreshUseButton( partner.ObjectId, partner )
		UseableOff({ Id = partner.ObjectId })
	end
end