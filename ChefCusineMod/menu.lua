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
		SelectableMeals = 	{
		"Fish_Tartarus_Common_01", 
		"Fish_Elysium_Common_01", 
		"Fish_Surface_Common_01", 
		"StackUpgrade",
		"RoomRewardHealDrop",
	}
		ThisRunFish = {}
		for i = 1, 3 do
		table.insert(ThisRunFish, RemoveRandomValue(SelectableMeals))
		end
		SelectedFish = nil
		DeathLoopData["DeathArea"]["ObstacleData"][423399]["SetupGameStateRequirements"] ={
		}
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
if not HeroHasTrait(button.Boon) then
	local isLegendary = false
	local isDuo = false
	local isConsumable = false
	if IsWeaponTrait(button.Boon) then
		RemoveSameSlotWeapon(button.Boon)
	end
	AddTraitToHero({ TraitData = GetProcessedTraitData({ Unit = CurrentRun.Hero, TraitName = button.Boon .."_Trait", Rarity = "Legendary" }) })
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



