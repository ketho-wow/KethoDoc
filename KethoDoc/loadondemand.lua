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

-- 10.1.5
KethoDoc.LoadOnDemand.mainline = {
	-- "Blizzard_AccountSaveUI",
	"Blizzard_AchievementUI",
	"Blizzard_AdventureMap",
	"Blizzard_AlliedRacesUI",
	"Blizzard_AnimaDiversionUI",
	"Blizzard_APIDocumentation",
	"Blizzard_APIDocumentationGenerated",
	"Blizzard_ArchaeologyUI",
	"Blizzard_ArdenwealdGardening",
	"Blizzard_ArtifactUI",
	"Blizzard_AuctionHouseShared",
	"Blizzard_AuctionHouseUI",
	"Blizzard_AzeriteEssenceUI",
	"Blizzard_AzeriteRespecUI",
	"Blizzard_AzeriteUI",
	"Blizzard_BarberShopUI",
	"Blizzard_BattlefieldMap",
	"Blizzard_BehavioralMessaging",
	"Blizzard_BlackMarketUI",
	"Blizzard_BoostTutorial",
	"Blizzard_Calendar",
	"Blizzard_ChallengesUI",
	"Blizzard_CharacterCustomize",
	"Blizzard_ChromieTimeUI",
	"Blizzard_ClassTalentUI",
	"Blizzard_ClassTrial",
	"Blizzard_ClickBindingUI",
	"Blizzard_Collections",
	"Blizzard_CombatLog",
	"Blizzard_CombatText",
	"Blizzard_Commentator",
	"Blizzard_Communities",
	"Blizzard_Contribution",
	"Blizzard_CovenantCallings",
	"Blizzard_CovenantPreviewUI",
	"Blizzard_CovenantRenown",
	"Blizzard_CovenantSanctum",
	"Blizzard_DeathRecap",
	"Blizzard_DebugTools",
	"Blizzard_EncounterJournal",
	"Blizzard_EventTrace",
	"Blizzard_ExpansionLandingPage",
	"Blizzard_ExpansionTrial",
	"Blizzard_FlightMap",
	"Blizzard_GarrisonTemplates",
	"Blizzard_GarrisonUI",
	"Blizzard_GenericTraitUI",
	"Blizzard_GMChatUI",
	"Blizzard_GuildBankUI",
	"Blizzard_GuildControlUI",
	"Blizzard_HybridMinimap",
	"Blizzard_InspectUI",
	"Blizzard_IslandsPartyPoseUI",
	"Blizzard_IslandsQueueUI",
	"Blizzard_ItemInteractionUI",
	"Blizzard_ItemSocketingUI",
	"Blizzard_ItemUpgradeUI",
	"Blizzard_Kiosk",
	"Blizzard_LandingSoulbinds",
	"Blizzard_MacroUI",
	-- "Blizzard_MacroUI_TBC",
	-- "Blizzard_MacroUI_Vanilla",
	-- "Blizzard_MacroUI_Wrath",
	"Blizzard_MajorFactions",
	"Blizzard_MapCanvas",
	"Blizzard_MovePad",
	"Blizzard_NewPlayerExperience",
	"Blizzard_NewPlayerExperienceGuide",
	"Blizzard_ObliterumUI",
	"Blizzard_OrderHallUI",
	"Blizzard_PartyPoseUI",
	"Blizzard_PerksProgram",
	"Blizzard_PlayerChoice",
	"Blizzard_Professions",
	"Blizzard_ProfessionsCustomerOrders",
	"Blizzard_ProfessionsTemplates",
	"Blizzard_PVPUI",
	"Blizzard_RaidUI",
	"Blizzard_RuneforgeUI",
	"Blizzard_ScrappingMachineUI",
	"Blizzard_SelectorUI",
	"Blizzard_Settings",
	"Blizzard_SharedMapDataProviders",
	"Blizzard_Soulbinds",
	"Blizzard_SubscriptionInterstitialUI",
	"Blizzard_TalentUI",
	"Blizzard_TimeManager",
	"Blizzard_TorghastLevelPicker",
	"Blizzard_TrainerUI",
	"Blizzard_VoidStorageUI",
	"Blizzard_WarfrontsPartyPoseUI",
	"Blizzard_WeeklyRewards",
}

-- 10.1.7
KethoDoc.LoadOnDemand.mainline_ptr = {
	-- "Blizzard_AccountSaveUI",
	"Blizzard_AchievementUI",
	"Blizzard_AdventureMap",
	"Blizzard_AlliedRacesUI",
	"Blizzard_AnimaDiversionUI",
	"Blizzard_APIDocumentation",
	"Blizzard_APIDocumentationGenerated",
	"Blizzard_ArchaeologyUI",
	"Blizzard_ArdenwealdGardening",
	"Blizzard_ArtifactUI",
	"Blizzard_AuctionHouseShared",
	"Blizzard_AuctionHouseUI",
	"Blizzard_AzeriteEssenceUI",
	"Blizzard_AzeriteRespecUI",
	"Blizzard_AzeriteUI",
	"Blizzard_BarberShopUI",
	"Blizzard_BattlefieldMap",
	"Blizzard_BehavioralMessaging",
	"Blizzard_BlackMarketUI",
	"Blizzard_BoostTutorial",
	"Blizzard_Calendar",
	"Blizzard_ChallengesUI",
	"Blizzard_CharacterCustomize",
	"Blizzard_ChromieTimeUI",
	"Blizzard_ClassTalentUI",
	"Blizzard_ClassTrial",
	"Blizzard_ClickBindingUI",
	"Blizzard_Collections",
	"Blizzard_CombatLog",
	"Blizzard_CombatText",
	"Blizzard_Commentator",
	"Blizzard_Communities",
	"Blizzard_Contribution",
	"Blizzard_CovenantCallings",
	"Blizzard_CovenantPreviewUI",
	"Blizzard_CovenantRenown",
	"Blizzard_CovenantSanctum",
	"Blizzard_DeathRecap",
	"Blizzard_DebugTools",
	"Blizzard_EncounterJournal",
	"Blizzard_EventTrace",
	"Blizzard_ExpansionLandingPage",
	"Blizzard_ExpansionTrial",
	"Blizzard_FlightMap",
	"Blizzard_GarrisonTemplates",
	"Blizzard_GarrisonUI",
	"Blizzard_GenericTraitUI",
	"Blizzard_GMChatUI",
	"Blizzard_GuildBankUI",
	"Blizzard_GuildControlUI",
	"Blizzard_HybridMinimap",
	"Blizzard_InspectUI",
	"Blizzard_IslandsPartyPoseUI",
	"Blizzard_IslandsQueueUI",
	"Blizzard_ItemInteractionUI",
	"Blizzard_ItemSocketingUI",
	"Blizzard_ItemUpgradeUI",
	"Blizzard_Kiosk",
	"Blizzard_LandingSoulbinds",
	"Blizzard_MacroUI",
	-- "Blizzard_MacroUI_TBC",
	-- "Blizzard_MacroUI_Vanilla",
	-- "Blizzard_MacroUI_Wrath",
	"Blizzard_MajorFactions",
	"Blizzard_MapCanvas",
	"Blizzard_MovePad",
	"Blizzard_NewPlayerExperience",
	"Blizzard_NewPlayerExperienceGuide",
	"Blizzard_ObliterumUI",
	"Blizzard_OrderHallUI",
	"Blizzard_PartyPoseUI",
	"Blizzard_PerksProgram",
	"Blizzard_PingUI",
	"Blizzard_PlayerChoice",
	"Blizzard_Professions",
	"Blizzard_ProfessionsCustomerOrders",
	"Blizzard_ProfessionsTemplates",
	"Blizzard_PVPUI",
	"Blizzard_RadialWheel",
	"Blizzard_RaidUI",
	"Blizzard_RuneforgeUI",
	"Blizzard_ScrappingMachineUI",
	"Blizzard_SelectorUI",
	"Blizzard_Settings",
	"Blizzard_SharedMapDataProviders",
	"Blizzard_Soulbinds",
	"Blizzard_SubscriptionInterstitialUI",
	"Blizzard_TalentUI",
	"Blizzard_TimeManager",
	"Blizzard_TorghastLevelPicker",
	"Blizzard_TrainerUI",
	"Blizzard_VoidStorageUI",
	"Blizzard_WarfrontsPartyPoseUI",
	"Blizzard_WeeklyRewards",
}

-- 3.4.2
KethoDoc.LoadOnDemand.wrath = {
	-- "Blizzard_AccountSaveUI",
	"Blizzard_AchievementUI",
	"Blizzard_APIDocumentation",
	"Blizzard_APIDocumentationGenerated",
	"Blizzard_ArenaUI",
	"Blizzard_AuctionUI",
	"Blizzard_BarberShopUI",
	"Blizzard_BattlefieldMap",
	"Blizzard_BehavioralMessaging",
	"Blizzard_BindingUI",
	"Blizzard_Calendar",
	"Blizzard_CombatLog",
	-- "Blizzard_CombatLog_Wrath",
	"Blizzard_CombatText",
	"Blizzard_Commentator",
	"Blizzard_Communities",
	"Blizzard_CraftUI",
	-- "Blizzard_CraftUI_TBC",
	-- "Blizzard_CraftUI_Vanilla",
	-- "Blizzard_CraftUI_Wrath",
	"Blizzard_DebugTools",
	"Blizzard_EventTrace",
	"Blizzard_GlyphUI",
	"Blizzard_GMChatUI",
	"Blizzard_GuildBankUI",
	-- "Blizzard_GuildBankUI_TBC",
	-- "Blizzard_GuildBankUI_Wrath",
	"Blizzard_InspectUI",
	-- "Blizzard_InspectUI_TBC",
	-- "Blizzard_InspectUI_Vanilla",
	-- "Blizzard_InspectUI_Wrath",
	"Blizzard_ItemSocketingUI",
	"Blizzard_Kiosk",
	"Blizzard_LookingForGroupUI",
	"Blizzard_MacroUI",
	-- "Blizzard_MacroUI_TBC",
	-- "Blizzard_MacroUI_Vanilla",
	-- "Blizzard_MacroUI_Wrath",
	"Blizzard_MapCanvas",
	"Blizzard_MovePad",
	"Blizzard_RaidUI",
	-- "Blizzard_RaidUI_Wrath",
	"Blizzard_SharedMapDataProviders",
	-- "Blizzard_SharedMapDataProviders_Wrath",
	"Blizzard_TalentUI",
	-- "Blizzard_TalentUI_TBC",
	-- "Blizzard_TalentUI_Vanilla",
	-- "Blizzard_TalentUI_Wrath",
	"Blizzard_TimeManager",
	"Blizzard_TradeSkillUI",
	-- "Blizzard_TradeSkillUI_TBC",
	-- "Blizzard_TradeSkillUI_Vanilla",
	-- "Blizzard_TradeSkillUI_Wrath",
	"Blizzard_TrainerUI",
}
KethoDoc.LoadOnDemand.wrath_ptr = KethoDoc.LoadOnDemand.wrath

-- 1.14.1
KethoDoc.LoadOnDemand.vanilla = {
	"Blizzard_APIDocumentation",
	"Blizzard_ArenaUI",
	"Blizzard_AuctionUI",
	-- "Blizzard_AuctionUI_TBC",
	-- "Blizzard_AuctionUI_Vanilla",
	"Blizzard_BattlefieldMap",
	-- "Blizzard_BattlefieldMap_TBC",
	-- "Blizzard_BattlefieldMap_Vanilla",
	"Blizzard_BehavioralMessaging",
	"Blizzard_BindingUI",
	"Blizzard_CombatLog",
	-- "Blizzard_CombatLog_TBC",
	-- "Blizzard_CombatLog_Vanilla",
	"Blizzard_CombatText",
	"Blizzard_Commentator",
	"Blizzard_Communities",
	-- "Blizzard_Communities_TBC",
	-- "Blizzard_Communities_Vanilla",
	"Blizzard_CraftUI",
	-- "Blizzard_CraftUI_TBC",
	-- "Blizzard_CraftUI_Vanilla",
	"Blizzard_DebugTools",
	"Blizzard_EventTrace",
	"Blizzard_GMChatUI",
	-- "Blizzard_GMChatUI_TBC",
	-- "Blizzard_GMChatUI_Vanilla",
	"Blizzard_GMSurveyUI",
	-- "Blizzard_GMSurveyUI_Vanilla",
	-- "Blizzard_GuildBankUI", -- it appears possible to load this in vanilla
	-- "Blizzard_GuildBankUI_TBC",
	"Blizzard_InspectUI",
	-- "Blizzard_InspectUI_TBC",
	-- "Blizzard_InspectUI_Vanilla",
	"Blizzard_ItemSocketingUI",
	"Blizzard_Kiosk",
	"Blizzard_LookingForGroupUI",
	"Blizzard_MacroUI",
	"Blizzard_MapCanvas",
	-- "Blizzard_MapCanvas_TBC",
	-- "Blizzard_MapCanvas_Vanilla",
	"Blizzard_MovePad",
	"Blizzard_RaidUI",
	-- "Blizzard_RaidUI_TBC",
	-- "Blizzard_RaidUI_Vanilla",
	"Blizzard_SharedMapDataProviders",
	"Blizzard_SharedMapDataProviders",
	-- "Blizzard_SharedMapDataProviders_TBC",
	-- "Blizzard_SharedMapDataProviders_Vanilla",
	"Blizzard_SocialUI",
	"Blizzard_TalentUI",
	"Blizzard_TalentUI",
	-- "Blizzard_TalentUI_TBC",
	-- "Blizzard_TalentUI_Vanilla",
	"Blizzard_TimeManager",
	"Blizzard_TradeSkillUI",
	-- "Blizzard_TradeSkillUI_TBC",
	-- "Blizzard_TradeSkillUI_Vanilla",
	"Blizzard_TrainerUI",
}

-- 1.14.4
KethoDoc.LoadOnDemand.vanilla_ptr = {
	-- "Blizzard_AccountSaveUI",
	"Blizzard_AchievementUI",
	"Blizzard_APIDocumentation",
	"Blizzard_APIDocumentationGenerated",
	"Blizzard_ArenaUI",
	"Blizzard_AuctionUI",
	"Blizzard_BarberShopUI",
	"Blizzard_BattlefieldMap",
	"Blizzard_BehavioralMessaging",
	"Blizzard_BindingUI",
	"Blizzard_Calendar",
	"Blizzard_CombatLog",
	-- "Blizzard_CombatLog_Wrath",
	"Blizzard_CombatText",
	"Blizzard_Commentator",
	"Blizzard_Communities",
	"Blizzard_CraftUI",
	-- "Blizzard_CraftUI_TBC",
	-- "Blizzard_CraftUI_Vanilla",
	-- "Blizzard_CraftUI_Wrath",
	"Blizzard_DebugTools",
	"Blizzard_EventTrace",
	"Blizzard_GlyphUI",
	"Blizzard_GMChatUI",
	-- "Blizzard_GuildBankUI_TBC",
	-- "Blizzard_GuildBankUI_Wrath",
	"Blizzard_InspectUI",
	-- "Blizzard_InspectUI_TBC",
	-- "Blizzard_InspectUI_Vanilla",
	"Blizzard_InspectUI_Wrath",
	"Blizzard_ItemSocketingUI",
	"Blizzard_Kiosk",
	"Blizzard_LookingForGroupUI",
	"Blizzard_MacroUI",
	-- "Blizzard_MacroUI_TBC",
	-- "Blizzard_MacroUI_Vanilla",
	-- "Blizzard_MacroUI_Wrath",
	"Blizzard_MapCanvas",
	"Blizzard_MovePad",
	"Blizzard_RaidUI",
	-- "Blizzard_RaidUI_Wrath",
	"Blizzard_SharedMapDataProviders",
	-- "Blizzard_SharedMapDataProviders_Wrath",
	"Blizzard_TalentUI",
	-- "Blizzard_TalentUI_TBC",
	-- "Blizzard_TalentUI_Vanilla",
	-- "Blizzard_TalentUI_Wrath",
	"Blizzard_TimeManager",
	"Blizzard_TradeSkillUI",
	-- "Blizzard_TradeSkillUI_TBC",
	-- "Blizzard_TradeSkillUI_Vanilla",
	-- "Blizzard_TradeSkillUI_Wrath",
	"Blizzard_TrainerUI",
}
