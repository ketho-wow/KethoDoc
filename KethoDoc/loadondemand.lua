KethoDoc.LoadOnDemand = {}

-- get framexml data before any loadondemand addons load
KethoDoc.initFrames = KethoDoc:GetFrames()
KethoDoc.initFrameXML = KethoDoc:GetFrameXML()

-- this might throw some blizzard errors
function KethoDoc:LoadLodAddons()
	for _, addon in pairs(self.LoadOnDemand[self.branch]) do
		--local name, _, _, _, reason = GetAddOnInfo(addon)
		--Spew("", reason, name)
		UIParentLoadAddOn(addon)
	end
end

local function FilterFlavor(t, flavor)
	for k, v in pairs(t) do
		if v:find(flavor.."$") then
			t[k] = nil
		end
	end
end

local function TrimFlavor(t, flavor)
	for k, v in pairs(t) do
		if v:find(flavor.."$") then
			t[k] = v:gsub(flavor, "")
		end
	end
end

-- 12.0.0
KethoDoc.LoadOnDemand.mainline = {
	-- "Blizzard_AccountSaveUI",
	"Blizzard_AccountStore",
	"Blizzard_AchievementUI_Mainline",
	"Blizzard_AchievementUI_Mists",
	"Blizzard_AdventureMap",
	"Blizzard_AlliedRacesUI",
	"Blizzard_AnimaDiversionUI",
	"Blizzard_APIDocumentation",
	"Blizzard_APIDocumentationGenerated",
	"Blizzard_ArchaeologyUI_Mainline",
	"Blizzard_ArchaeologyUI_Mists",
	"Blizzard_ArdenwealdGardening",
	"Blizzard_ArtifactUI",
	"Blizzard_AuctionHouseUI_Classic",
	"Blizzard_AuctionHouseUI_Mainline",
	"Blizzard_AutoCompletePopupList",
	"Blizzard_AzeriteEssenceUI",
	"Blizzard_AzeriteRespecUI",
	"Blizzard_AzeriteUI",
	"Blizzard_BarberShopUI",
	"Blizzard_BattlefieldMap",
	"Blizzard_BehavioralMessaging",
	"Blizzard_BlackMarketUI",
	"Blizzard_BoostTutorial",
	"Blizzard_Calendar_Mainline",
	"Blizzard_ChallengesUI_Mainline",
	"Blizzard_CharacterCustomize",
	"Blizzard_ChromieTimeUI",
	"Blizzard_ClickBindingUI",
	"Blizzard_Collections_Mainline",
	"Blizzard_Collections_Mists",
	"Blizzard_Collections_Wrath",
	"Blizzard_CombatLog_Mainline",
	"Blizzard_CombatLog_Mists",
	"Blizzard_CombatLogBase",
	"Blizzard_CombatText",
	"Blizzard_Commentator",
	"Blizzard_Contribution",
	"Blizzard_CovenantCallings",
	"Blizzard_CovenantPreviewUI",
	"Blizzard_CovenantRenown",
	"Blizzard_CovenantSanctum",
	"Blizzard_CustomizationUI",
	"Blizzard_DeathRecap",
	"Blizzard_DebugTools",
	"Blizzard_DelvesDifficultyPicker",
	"Blizzard_Dispatcher",
	"Blizzard_EncounterJournal_Mainline",
	"Blizzard_EncounterJournal_Mists",
	"Blizzard_EventTrace",
	"Blizzard_ExpansionTrial",
	"Blizzard_FlightMap",
	"Blizzard_GarrisonTemplates",
	"Blizzard_GarrisonUI_Mainline",
	"Blizzard_GenericShoppingCart",
	"Blizzard_GenericTraitUI",
	"Blizzard_GMChatUI",
	"Blizzard_GuildBankUI",
	"Blizzard_GuildControlUI",
	"Blizzard_HouseEditor",
	"Blizzard_HouseList",
	"Blizzard_HousingBulletinBoard",
	"Blizzard_HousingCharter",
	"Blizzard_HousingControls",
	"Blizzard_HousingCornerstone",
	"Blizzard_HousingCreateNeighborhood",
	"Blizzard_HousingDashboard",
	"Blizzard_HousingHouseFinder",
	"Blizzard_HousingHouseSettings",
	"Blizzard_HousingMarketCart",
	"Blizzard_HousingModelPreview",
	"Blizzard_HybridMinimap",
	"Blizzard_InspectUI",
	"Blizzard_IslandsPartyPoseUI",
	"Blizzard_IslandsQueueUI",
	"Blizzard_ItemInteractionUI",
	"Blizzard_ItemSocketingUI",
	"Blizzard_ItemUpgradeUI_Mainline",
	"Blizzard_ItemUpgradeUI_Mists",
	"Blizzard_Kiosk",
	"Blizzard_LandingSoulbinds",
	"Blizzard_MacroUI",
	"Blizzard_MapCanvas",
	"Blizzard_MatchCelebrationPartyPoseUI",
	"Blizzard_MovePad",
	"Blizzard_NewPlayerExperience",
	"Blizzard_NewPlayerExperienceGuide",
	"Blizzard_ObliterumUI",
	"Blizzard_OrderHallUI",
	"Blizzard_PartyPoseUI",
	"Blizzard_PerksProgram",
	"Blizzard_PlayerChoice",
	"Blizzard_PlayerSpells",
	"Blizzard_PlunderstormBasics",
	"Blizzard_Professions",
	"Blizzard_ProfessionsBook",
	"Blizzard_ProfessionsCustomerOrders",
	"Blizzard_ProfessionsTemplates",
	"Blizzard_PVPUI_Mainline",
	"Blizzard_PVPUI_Mists",
	"Blizzard_RaidUI",
	"Blizzard_ReforgingUI_Classic",
	"Blizzard_RemixArtifactTutorialUI",
	"Blizzard_RemixArtifactUI",
	"Blizzard_RuneforgeUI",
	"Blizzard_ScrappingMachineUI",
	"Blizzard_SelectorUI",
	"Blizzard_Settings",
	"Blizzard_SharedMapDataProviders_Mainline",
	"Blizzard_Soulbinds",
	"Blizzard_SpellSearch",
	"Blizzard_StatusUI",
	"Blizzard_SubscriptionInterstitialUI",
	"Blizzard_TalentUI_Mists",
	"Blizzard_TimeManager_Mainline",
	-- "Blizzard_TimerunningCharacterCreate",
	"Blizzard_TorghastLevelPicker",
	"Blizzard_TrainerUI",
	"Blizzard_TransformTree",
	"Blizzard_Transmog",
	"Blizzard_TransmogShared",
	"Blizzard_WarfrontsPartyPoseUI",
	"Blizzard_WeeklyRewards",
	"Blizzard_WowSurveyUI",
}

TrimFlavor(KethoDoc.LoadOnDemand.mainline, "_Mainline")
FilterFlavor(KethoDoc.LoadOnDemand.mainline, "_Classic")
FilterFlavor(KethoDoc.LoadOnDemand.mainline, "_Wrath")
FilterFlavor(KethoDoc.LoadOnDemand.mainline, "_Cata")
FilterFlavor(KethoDoc.LoadOnDemand.mainline, "_Mists")

KethoDoc.LoadOnDemand.mainline_ptr = KethoDoc.LoadOnDemand.mainline

-- TrimFlavor(KethoDoc.LoadOnDemand.mainline_ptr, "_Mainline")
-- FilterFlavor(KethoDoc.LoadOnDemand.mainline_ptr, "_Classic")
-- FilterFlavor(KethoDoc.LoadOnDemand.mainline_ptr, "_Wrath")
-- FilterFlavor(KethoDoc.LoadOnDemand.mainline_ptr, "_Cata")
-- FilterFlavor(KethoDoc.LoadOnDemand.mainline_ptr, "_Mists")

KethoDoc.LoadOnDemand.mainline_beta = KethoDoc.LoadOnDemand.mainline

-- TrimFlavor(KethoDoc.LoadOnDemand.mainline_beta, "_Mainline")
-- FilterFlavor(KethoDoc.LoadOnDemand.mainline_beta, "_Classic")
-- FilterFlavor(KethoDoc.LoadOnDemand.mainline_beta, "_Wrath")
-- FilterFlavor(KethoDoc.LoadOnDemand.mainline_beta, "_Cata")
-- FilterFlavor(KethoDoc.LoadOnDemand.mainline_beta, "_Mists")

-- 1.15.7
KethoDoc.LoadOnDemand.vanilla = {
	-- "Blizzard_AccountSaveUI",
	"Blizzard_AchievementUI_Cata",
	"Blizzard_AchievementUI_Classic",
	"Blizzard_APIDocumentation",
	"Blizzard_APIDocumentationGenerated",
	"Blizzard_ArchaeologyUI_Cata",
	"Blizzard_ArenaUI",
	"Blizzard_AuctionHouseUI_Classic",
	"Blizzard_AuctionHouseUI_Mainline",
	"Blizzard_AuctionUI_Classic", -- not sure if this is deprecated
	"Blizzard_BarberShopUI",
	"Blizzard_BattlefieldMap",
	"Blizzard_BehavioralMessaging",
	"Blizzard_BindingUI",
	"Blizzard_Calendar_Classic",
	"Blizzard_Collections_Cata",
	"Blizzard_Collections_Wrath",
	"Blizzard_CombatLog_Cata",
	"Blizzard_CombatLog_Classic",
	"Blizzard_CombatLog_Wrath",
	"Blizzard_CombatText",
	"Blizzard_Commentator",
	"Blizzard_CraftUI_Classic",
	"Blizzard_CraftUI_Vanilla",
	"Blizzard_CustomizationUI",
	"Blizzard_DebugTools",
	"Blizzard_Dispatcher",
	"Blizzard_EncounterJournal_Cata",
	"Blizzard_EngravingUI",
	"Blizzard_EventTrace",
	"Blizzard_FontStyles_Shared",
	"Blizzard_GlyphUI_Cata",
	"Blizzard_GlyphUI_Wrath",
	"Blizzard_GMChatUI",
	"Blizzard_GroupFinder_VanillaStyle",
	"Blizzard_GuildBankUI_Classic",
	"Blizzard_GuildControlUI",
	"Blizzard_InspectUI_Cata",
	"Blizzard_InspectUI_Classic",
	"Blizzard_InspectUI_Vanilla",
	"Blizzard_ItemSocketingUI",
	"Blizzard_Kiosk",
	"Blizzard_MacroUI_Classic",
	"Blizzard_MapCanvas",
	"Blizzard_MovePad",
	"Blizzard_RaidUI",
	"Blizzard_RaidUI_Cata",
	"Blizzard_RaidUI_Wrath",
	"Blizzard_ReforgingUI_Classic",
	"Blizzard_SharedMapDataProviders_Cata",
	"Blizzard_SharedMapDataProviders_Classic",
	"Blizzard_SharedMapDataProviders_Wrath",
	"Blizzard_SpellSearch",
	"Blizzard_TalentUI_Cata",
	"Blizzard_TalentUI_TBC",
	"Blizzard_TalentUI_Vanilla",
	"Blizzard_TalentUI_Wrath",
	"Blizzard_TimeManager_Classic",
	"Blizzard_TradeSkillUI_Cata",
	"Blizzard_TradeSkillUI_TBC",
	"Blizzard_TradeSkillUI_Vanilla",
	"Blizzard_TradeSkillUI_Wrath",
	"Blizzard_TrainerUI",
}

-- VanillaStyle suffix should not be trimmed apparently
TrimFlavor(KethoDoc.LoadOnDemand.vanilla, "_Vanilla")
TrimFlavor(KethoDoc.LoadOnDemand.vanilla, "_Classic")
FilterFlavor(KethoDoc.LoadOnDemand.vanilla, "_TBC")
FilterFlavor(KethoDoc.LoadOnDemand.vanilla, "_Wrath")
FilterFlavor(KethoDoc.LoadOnDemand.vanilla, "_Cata")

-- classic_era_ptr 1.15.8
KethoDoc.LoadOnDemand.vanilla_ptr = {
	-- "Blizzard_AccountSaveUI",
	"Blizzard_AchievementUI_Cata",
	-- "Blizzard_AchievementUI_Classic", -- wrong game type
	"Blizzard_AchievementUI_Mists",
	"Blizzard_APIDocumentation",
	"Blizzard_APIDocumentationGenerated",
	"Blizzard_ArchaeologyUI_Cata",
	"Blizzard_ArchaeologyUI_Mists",
	"Blizzard_ArenaUI",
	-- "Blizzard_AuctionHouseUI_Classic", -- wrong game type
	"Blizzard_AuctionHouseUI_Mainline",
	"Blizzard_AuctionUI_Classic",
	"Blizzard_AutoCompletePopupList",
	"Blizzard_BarberShopUI",
	"Blizzard_BattlefieldMap",
	"Blizzard_BehavioralMessaging",
	"Blizzard_BindingUI",
	"Blizzard_BlackMarketUI",
	"Blizzard_Calendar_Classic",
	"Blizzard_ChallengesUI_Mists",
	"Blizzard_Collections_Cata",
	"Blizzard_Collections_Mainline",
	"Blizzard_Collections_Mists",
	"Blizzard_Collections_Wrath",
	"Blizzard_CombatLog_Cata",
	"Blizzard_CombatLog_Classic",
	"Blizzard_CombatLog_Mists",
	"Blizzard_CombatLog_Wrath",
	"Blizzard_CombatText",
	"Blizzard_Commentator",
	"Blizzard_CraftUI_Classic",
	"Blizzard_CraftUI_Vanilla",
	"Blizzard_CustomizationUI",
	"Blizzard_DebugTools",
	"Blizzard_Dispatcher",
	"Blizzard_EncounterJournal_Cata",
	"Blizzard_EncounterJournal_Mists",
	"Blizzard_EngravingUI",
	"Blizzard_EventTrace",
	"Blizzard_GlyphUI_Cata",
	"Blizzard_GlyphUI_Mists",
	"Blizzard_GlyphUI_Wrath",
	"Blizzard_GMChatUI",
	"Blizzard_GroupFinder_VanillaStyle",
	-- "Blizzard_GuildBankUI_Classic", -- wrong game type
	"Blizzard_GuildBankUI_Mists",
	"Blizzard_GuildControlUI",
	"Blizzard_InspectUI_Classic",
	"Blizzard_ItemSocketingUI",
	"Blizzard_ItemUpgradeUI_Mainline",
	"Blizzard_ItemUpgradeUI_Mists",
	"Blizzard_Kiosk",
	"Blizzard_MacroUI_Classic",
	"Blizzard_MapCanvas",
	"Blizzard_MovePad",
	"Blizzard_PVPUI_Mainline",
	"Blizzard_PVPUI_Mists",
	-- "Blizzard_QuestChoice", -- wrong game type
	"Blizzard_RaidUI",
	"Blizzard_ReforgingUI_Classic",
	-- "Blizzard_RemixArtifactTutorialUI", -- wrong game type
	"Blizzard_SharedMapDataProviders_Cata",
	"Blizzard_SharedMapDataProviders_Classic",
	"Blizzard_SharedMapDataProviders_Mists",
	"Blizzard_SharedMapDataProviders_Wrath",
	"Blizzard_SpellSearch",
	"Blizzard_StatusUI",
	"Blizzard_TalentUI_Cata",
	"Blizzard_TalentUI_Mists",
	"Blizzard_TalentUI_TBC",
	"Blizzard_TalentUI_Vanilla",
	"Blizzard_TalentUI_Wrath",
	"Blizzard_TimeManager_Classic",
	"Blizzard_TradeSkillUI_Cata",
	"Blizzard_TradeSkillUI_Mists",
	"Blizzard_TradeSkillUI_TBC",
	"Blizzard_TradeSkillUI_Vanilla",
	"Blizzard_TradeSkillUI_Wrath",
	"Blizzard_TrainerUI",
	"Blizzard_WowSurveyUI",
}

TrimFlavor(KethoDoc.LoadOnDemand.vanilla_ptr, "_Vanilla")
TrimFlavor(KethoDoc.LoadOnDemand.vanilla_ptr, "_Classic")
FilterFlavor(KethoDoc.LoadOnDemand.vanilla_ptr, "_Mainline")
FilterFlavor(KethoDoc.LoadOnDemand.vanilla_ptr, "_TBC")
FilterFlavor(KethoDoc.LoadOnDemand.vanilla_ptr, "_Wrath")
FilterFlavor(KethoDoc.LoadOnDemand.vanilla_ptr, "_Cata")
FilterFlavor(KethoDoc.LoadOnDemand.vanilla_ptr, "_Mists")

KethoDoc.LoadOnDemand.tbc = {
	-- "Blizzard_AccountSaveUI",
	"Blizzard_AchievementUI_Cata",
	"Blizzard_AchievementUI_Classic",
	"Blizzard_AchievementUI_Mists",
	"Blizzard_APIDocumentation",
	"Blizzard_APIDocumentationGenerated",
	"Blizzard_ArchaeologyUI_Cata",
	"Blizzard_ArchaeologyUI_Mists",
	"Blizzard_ArenaUI",
	"Blizzard_AuctionHouseUI_Classic",
	"Blizzard_AuctionHouseUI_Mainline",
	"Blizzard_AuctionUI_Classic",
	"Blizzard_AutoCompletePopupList",
	"Blizzard_BarberShopUI",
	"Blizzard_BattlefieldMap",
	"Blizzard_BehavioralMessaging",
	"Blizzard_BindingUI",
	"Blizzard_BlackMarketUI",
	"Blizzard_Calendar_Classic",
	"Blizzard_ChallengesUI_Mists",
	"Blizzard_Collections_Cata",
	"Blizzard_Collections_Mainline",
	"Blizzard_Collections_Mists",
	"Blizzard_Collections_Wrath",
	"Blizzard_CombatLog_Cata",
	"Blizzard_CombatLog_Classic",
	"Blizzard_CombatLog_Mists",
	"Blizzard_CombatLog_Wrath",
	"Blizzard_CombatText",
	"Blizzard_Commentator",
	"Blizzard_CraftUI_Classic",
	"Blizzard_CraftUI_Vanilla",
	"Blizzard_CustomizationUI",
	"Blizzard_DebugTools",
	"Blizzard_Dispatcher",
	"Blizzard_EncounterJournal_Cata",
	"Blizzard_EncounterJournal_Mists",
	"Blizzard_EngravingUI",
	"Blizzard_EventTrace",
	"Blizzard_GlyphUI_Cata",
	"Blizzard_GlyphUI_Mists",
	"Blizzard_GlyphUI_Wrath",
	"Blizzard_GMChatUI",
	"Blizzard_GroupFinder_VanillaStyle",
	"Blizzard_GuildBankUI_Classic",
	"Blizzard_GuildBankUI_Mists",
	"Blizzard_GuildControlUI",
	-- "Blizzard_HousingModelPreview", -- wrong game type
	"Blizzard_InspectUI_Classic",
	"Blizzard_ItemSocketingUI",
	"Blizzard_ItemUpgradeUI_Mainline",
	"Blizzard_ItemUpgradeUI_Mists",
	"Blizzard_Kiosk",
	"Blizzard_MacroUI_Classic",
	"Blizzard_MapCanvas",
	"Blizzard_MovePad",
	"Blizzard_PVPUI_Mainline",
	"Blizzard_PVPUI_Mists",
	-- "Blizzard_QuestChoice", -- wrong game type
	"Blizzard_RaidUI",
	"Blizzard_ReforgingUI_Classic",
	-- "Blizzard_RemixArtifactTutorialUI", -- wrong game type
	"Blizzard_SharedMapDataProviders_Cata",
	"Blizzard_SharedMapDataProviders_Classic",
	"Blizzard_SharedMapDataProviders_Mists",
	"Blizzard_SharedMapDataProviders_Wrath",
	"Blizzard_SpellSearch",
	"Blizzard_StatusUI",
	"Blizzard_TalentUI_Cata",
	"Blizzard_TalentUI_Mists",
	"Blizzard_TalentUI_TBC",
	"Blizzard_TalentUI_Vanilla",
	"Blizzard_TalentUI_Wrath",
	"Blizzard_TimeManager_Classic",
	"Blizzard_TradeSkillUI_Cata",
	"Blizzard_TradeSkillUI_Mists",
	"Blizzard_TradeSkillUI_TBC",
	"Blizzard_TradeSkillUI_Vanilla",
	"Blizzard_TradeSkillUI_Wrath",
	"Blizzard_TrainerUI",
	"Blizzard_WowSurveyUI",
}

TrimFlavor(KethoDoc.LoadOnDemand.tbc, "_Vanilla")
TrimFlavor(KethoDoc.LoadOnDemand.tbc, "_Classic")
TrimFlavor(KethoDoc.LoadOnDemand.tbc, "_TBC")
FilterFlavor(KethoDoc.LoadOnDemand.tbc, "_Mainline")
FilterFlavor(KethoDoc.LoadOnDemand.tbc, "_Wrath")
FilterFlavor(KethoDoc.LoadOnDemand.tbc, "_Cata")
FilterFlavor(KethoDoc.LoadOnDemand.tbc, "_Mists")

-- 5.5.3
KethoDoc.LoadOnDemand.mists = {
	-- "Blizzard_AccountSaveUI",
	"Blizzard_AchievementUI_Cata",
	"Blizzard_AchievementUI_Classic",
	"Blizzard_AchievementUI_Mists",
	"Blizzard_APIDocumentation",
	"Blizzard_APIDocumentationGenerated",
	"Blizzard_ArchaeologyUI_Cata",
	"Blizzard_ArchaeologyUI_Mists",
	"Blizzard_ArenaUI",
	"Blizzard_AuctionHouseUI_Classic",
	"Blizzard_AuctionHouseUI_Mainline",
	"Blizzard_AuctionUI_Classic",
	"Blizzard_AutoCompletePopupList",
	"Blizzard_BarberShopUI",
	"Blizzard_BattlefieldMap",
	"Blizzard_BehavioralMessaging",
	"Blizzard_BindingUI",
	"Blizzard_BlackMarketUI",
	"Blizzard_Calendar_Classic",
	"Blizzard_ChallengesUI_Mists",
	"Blizzard_Collections_Cata",
	"Blizzard_Collections_Mainline",
	"Blizzard_Collections_Mists",
	"Blizzard_Collections_Wrath",
	"Blizzard_CombatLog_Cata",
	"Blizzard_CombatLog_Classic",
	"Blizzard_CombatLog_Mists",
	"Blizzard_CombatLog_Wrath",
	"Blizzard_CombatText",
	"Blizzard_Commentator",
	-- "Blizzard_CraftUI_Classic",
	"Blizzard_CraftUI_Vanilla",
	"Blizzard_CustomizationUI",
	"Blizzard_DebugTools",
	"Blizzard_Dispatcher",
	"Blizzard_EncounterJournal_Cata",
	"Blizzard_EncounterJournal_Mists",
	"Blizzard_EngravingUI",
	"Blizzard_EventTrace",
	"Blizzard_GlyphUI_Cata",
	"Blizzard_GlyphUI_Mists",
	"Blizzard_GlyphUI_Wrath",
	"Blizzard_GMChatUI",
	"Blizzard_GroupFinder_VanillaStyle",
	"Blizzard_GuildBankUI_Classic",
	"Blizzard_GuildBankUI_Mists",
	"Blizzard_GuildControlUI",
	"Blizzard_InspectUI_Classic",
	"Blizzard_ItemSocketingUI",
	"Blizzard_ItemUpgradeUI_Mainline",
	"Blizzard_ItemUpgradeUI_Mists",
	"Blizzard_Kiosk",
	"Blizzard_MacroUI_Classic",
	"Blizzard_MapCanvas",
	"Blizzard_MovePad",
	"Blizzard_PVPUI_Mainline",
	"Blizzard_PVPUI_Mists",
	"Blizzard_QuestChoice",
	"Blizzard_RaidUI",
	"Blizzard_ReforgingUI_Classic",
	-- "Blizzard_RemixArtifactTutorialUI",
	"Blizzard_SharedMapDataProviders_Cata",
	"Blizzard_SharedMapDataProviders_Classic",
	"Blizzard_SharedMapDataProviders_Mists",
	"Blizzard_SharedMapDataProviders_Wrath",
	"Blizzard_SpellSearch",
	"Blizzard_StatusUI",
	"Blizzard_TalentUI_Cata",
	"Blizzard_TalentUI_Mists",
	"Blizzard_TalentUI_TBC",
	"Blizzard_TalentUI_Vanilla",
	"Blizzard_TalentUI_Wrath",
	"Blizzard_TimeManager_Classic",
	"Blizzard_TradeSkillUI_Cata",
	"Blizzard_TradeSkillUI_Mists",
	"Blizzard_TradeSkillUI_TBC",
	"Blizzard_TradeSkillUI_Vanilla",
	"Blizzard_TradeSkillUI_Wrath",
	"Blizzard_TrainerUI",
	"Blizzard_WowSurveyUI",
}

TrimFlavor(KethoDoc.LoadOnDemand.mists, "_Mists")
TrimFlavor(KethoDoc.LoadOnDemand.mists, "_Classic")
FilterFlavor(KethoDoc.LoadOnDemand.mists, "_Mainline")
FilterFlavor(KethoDoc.LoadOnDemand.mists, "_Vanilla")
FilterFlavor(KethoDoc.LoadOnDemand.mists, "_TBC")
FilterFlavor(KethoDoc.LoadOnDemand.mists, "_Wrath")
FilterFlavor(KethoDoc.LoadOnDemand.mists, "_Cata")

KethoDoc.LoadOnDemand.mists_ptr = KethoDoc.LoadOnDemand.mists
