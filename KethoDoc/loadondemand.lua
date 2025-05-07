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

-- 11.1.5
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
	"Blizzard_AzeriteEssenceUI",
	"Blizzard_AzeriteRespecUI",
	"Blizzard_AzeriteUI",
	"Blizzard_BarberShopUI",
	"Blizzard_BattlefieldMap",
	"Blizzard_BehavioralMessaging",
	"Blizzard_BlackMarketUI",
	"Blizzard_BoostTutorial",
	"Blizzard_Calendar_Mainline",
	"Blizzard_ChallengesUI",
	"Blizzard_CharacterCustomize",
	"Blizzard_ChromieTimeUI",
	"Blizzard_ClickBindingUI",
	"Blizzard_Collections_Mainline",
	"Blizzard_Collections_Mists",
	"Blizzard_Collections_Wrath",
	"Blizzard_CombatLog_Mainline",
	"Blizzard_CombatLog_Mists",
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
	"Blizzard_DelvesDashboardUI",
	"Blizzard_DelvesDifficultyPicker",
	"Blizzard_Dispatcher",
	"Blizzard_EncounterJournal_Mainline",
	"Blizzard_EncounterJournal_Mists",
	"Blizzard_EventTrace",
	"Blizzard_ExpansionTrial",
	"Blizzard_FlightMap",
	"Blizzard_GarrisonTemplates",
	"Blizzard_GarrisonUI_Mainline",
	"Blizzard_GenericTraitUI",
	"Blizzard_GMChatUI",
	"Blizzard_GuildBankUI",
	"Blizzard_GuildControlUI",
	"Blizzard_HybridMinimap",
	"Blizzard_InspectUI",
	"Blizzard_InspectUI_Cata",
	"Blizzard_InspectUI_Mists",
	"Blizzard_IslandsPartyPoseUI",
	"Blizzard_IslandsQueueUI",
	"Blizzard_ItemInteractionUI",
	"Blizzard_ItemSocketingUI",
	"Blizzard_ItemUpgradeUI",
	"Blizzard_Kiosk",
	"Blizzard_LandingSoulbinds",
	"Blizzard_MacroUI",
	"Blizzard_MajorFactions",
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
	"Blizzard_PVPUI",
	"Blizzard_RaidUI",
	"Blizzard_ReforgingUI_Classic",
	"Blizzard_RuneforgeUI",
	"Blizzard_ScrappingMachineUI",
	"Blizzard_SelectorUI",
	"Blizzard_Settings",
	"Blizzard_SharedMapDataProviders_Mainline",
	"Blizzard_Soulbinds",
	"Blizzard_SpellSearch",
	"Blizzard_SubscriptionInterstitialUI",
	"Blizzard_TalentUI_Mists",
	"Blizzard_TimeManager_Mainline",
	-- "Blizzard_TimerunningCharacterCreate",
	"Blizzard_TorghastLevelPicker",
	"Blizzard_TrainerUI",
	"Blizzard_TransformTree",
	"Blizzard_VoidStorageUI",
	"Blizzard_WarfrontsPartyPoseUI",
	"Blizzard_WeeklyRewards",
}

TrimFlavor(KethoDoc.LoadOnDemand.mainline, "_Mainline")
FilterFlavor(KethoDoc.LoadOnDemand.mainline, "_Classic")
FilterFlavor(KethoDoc.LoadOnDemand.mainline, "_Wrath")
FilterFlavor(KethoDoc.LoadOnDemand.mainline, "_Cata")

KethoDoc.LoadOnDemand.mainline_ptr = KethoDoc.LoadOnDemand.mainline

TrimFlavor(KethoDoc.LoadOnDemand.mainline_ptr, "_Mainline")
FilterFlavor(KethoDoc.LoadOnDemand.mainline_ptr, "_Classic")
FilterFlavor(KethoDoc.LoadOnDemand.mainline_ptr, "_Wrath")
FilterFlavor(KethoDoc.LoadOnDemand.mainline_ptr, "_Cata")
FilterFlavor(KethoDoc.LoadOnDemand.mainline_ptr, "_Mists")

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
	"Blizzard_AuctionUI_Classic",
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

-- apparently I never dumped Blizzard_AuctionUI, Blizzard_Calendar and more
-- Blizzard_AuctionUI should normally no longer be loaded in 1.15.6 so not sure whether to ignore it
KethoDoc.LoadOnDemand.cata = {
	-- "Blizzard_AccountSaveUI",
	"Blizzard_AchievementUI_Cata",
	"Blizzard_AchievementUI_Classic",
	"Blizzard_APIDocumentation",
	"Blizzard_APIDocumentationGenerated",
	"Blizzard_ArchaeologyUI_Cata",
	"Blizzard_ArenaUI",
	"Blizzard_AuctionHouseUI_Classic",
	"Blizzard_AuctionHouseUI_Mainline",
	"Blizzard_AuctionUI_Classic",
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

TrimFlavor(KethoDoc.LoadOnDemand.cata, "_Cata")
TrimFlavor(KethoDoc.LoadOnDemand.cata, "_Classic")
FilterFlavor(KethoDoc.LoadOnDemand.cata, "_Mainline")
FilterFlavor(KethoDoc.LoadOnDemand.cata, "_Vanilla")
FilterFlavor(KethoDoc.LoadOnDemand.cata, "_TBC")
FilterFlavor(KethoDoc.LoadOnDemand.cata, "_Wrath")

KethoDoc.LoadOnDemand.mists_beta = {
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
	"Blizzard_BarberShopUI",
	"Blizzard_BattlefieldMap",
	"Blizzard_BehavioralMessaging",
	"Blizzard_BindingUI",
	"Blizzard_BlackMarketUI",
	"Blizzard_Calendar_Classic",
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
	"Blizzard_GuildControlUI",
	"Blizzard_InspectUI_Cata",
	"Blizzard_InspectUI_Classic",
	"Blizzard_InspectUI_Mists",
	"Blizzard_InspectUI_Vanilla",
	"Blizzard_ItemSocketingUI",
	"Blizzard_Kiosk",
	"Blizzard_MacroUI_Classic",
	"Blizzard_MapCanvas",
	"Blizzard_MovePad",
	"Blizzard_RaidUI",
	"Blizzard_ReforgingUI_Classic",
	"Blizzard_SharedMapDataProviders_Cata",
	"Blizzard_SharedMapDataProviders_Classic",
	"Blizzard_SharedMapDataProviders_Mists",
	"Blizzard_SharedMapDataProviders_Wrath",
	"Blizzard_SpellSearch",
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
}

TrimFlavor(KethoDoc.LoadOnDemand.mists_beta, "_Mists")
TrimFlavor(KethoDoc.LoadOnDemand.mists_beta, "_Classic")
FilterFlavor(KethoDoc.LoadOnDemand.mists_beta, "_Mainline")
FilterFlavor(KethoDoc.LoadOnDemand.mists_beta, "_Vanilla")
FilterFlavor(KethoDoc.LoadOnDemand.mists_beta, "_TBC")
FilterFlavor(KethoDoc.LoadOnDemand.mists_beta, "_Wrath")
FilterFlavor(KethoDoc.LoadOnDemand.mists_beta, "_Cata")
