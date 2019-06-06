
local KD = KethoDoc
KD.LoadOnDemand = {}

function KD:LoadLodAddons()
	-- load all Blizzard LoD addons
	for _, addon in pairs(self.LoadOnDemand[self.branch]) do
		UIParentLoadAddOn(addon)
	end
end

KD.LoadOnDemand.live = { -- 8.1.5 (29981)
	"Blizzard_AchievementUI",
	"Blizzard_AdventureMap",
	"Blizzard_AlliedRacesUI",
	"Blizzard_APIDocumentation",
	"Blizzard_ArchaeologyUI",
	"Blizzard_ArenaUI",
	"Blizzard_ArtifactUI",
	"Blizzard_AuctionUI",
	"Blizzard_AzeriteRespecUI",
	"Blizzard_AzeriteUI",
	"Blizzard_BarberShopUI",
	"Blizzard_BattlefieldMap",
	"Blizzard_BindingUI",
	"Blizzard_BlackMarketUI",
	"Blizzard_BoostTutorial",
	"Blizzard_Calendar",
	"Blizzard_ChallengesUI",
	"Blizzard_ClassTrial",
	"Blizzard_Collections",
	"Blizzard_CombatLog",
	"Blizzard_CombatText",
	"Blizzard_Commentator",
	"Blizzard_Communities",
	"Blizzard_Contribution",
	"Blizzard_DeathRecap",
	"Blizzard_DebugTools",
	"Blizzard_EncounterJournal",
	"Blizzard_FlightMap",
	"Blizzard_GarrisonTemplates",
	"Blizzard_GarrisonUI",
	"Blizzard_GMChatUI",
	"Blizzard_GMSurveyUI",
	"Blizzard_GuildBankUI",
	"Blizzard_GuildControlUI",
	"Blizzard_GuildRecruitmentUI",
	"Blizzard_GuildUI",
	"Blizzard_InspectUI",
	"Blizzard_IslandsPartyPoseUI",
	"Blizzard_IslandsQueueUI",
	"Blizzard_ItemSocketingUI",
	-- Message: ...ns\Blizzard_ItemUpgradeUI\Blizzard_ItemUpgradeUI.lua line 27:
	--  attempt to index global 'ItemUpgradeFrameTopTileStreaks' (a nil value)
	"Blizzard_ItemUpgradeUI",
	"Blizzard_LookingForGuildUI",
	"Blizzard_MacroUI",
	"Blizzard_MapCanvas",
	"Blizzard_MovePad",
	"Blizzard_ObliterumUI",
	"Blizzard_OrderHallUI",
	"Blizzard_PartyPoseUI",
	"Blizzard_PVPUI",
	"Blizzard_QuestChoice",
	"Blizzard_RaidUI",
	"Blizzard_ScrappingMachineUI",
	"Blizzard_SharedMapDataProviders",
	"Blizzard_SocialUI",
	"Blizzard_TalentUI",
	"Blizzard_TalkingHeadUI",
	"Blizzard_TimeManager",
	"Blizzard_TradeSkillUI",
	"Blizzard_TrainerUI",
	"Blizzard_Tutorial",
	"Blizzard_TutorialTemplates",
	"Blizzard_VoidStorageUI",
	"Blizzard_WarboardUI",
	"Blizzard_WarfrontsPartyPoseUI",
}

KD.LoadOnDemand.ptr = { -- ptr 8.2.0 (30495)
	"Blizzard_AzeriteEssenceUI",
}

for _, v in pairs(KD.LoadOnDemand.live) do
	tinsert(KD.LoadOnDemand.ptr, v)
end

KD.LoadOnDemand.classic = { -- 1.13.2 (30550)
	"Blizzard_APIDocumentation",
	"Blizzard_AuctionUI",
	"Blizzard_BattlefieldMap",
	"Blizzard_BindingUI",
	"Blizzard_CombatLog",
	"Blizzard_CombatText",
	"Blizzard_Commentator",
	"Blizzard_Communities",
	"Blizzard_CraftUI",
	"Blizzard_DebugTools",
	"Blizzard_FlightMap",
	"Blizzard_GMChatUI",
	"Blizzard_GMSurveyUI",
	"Blizzard_InspectUI",
	"Blizzard_MacroUI",
	"Blizzard_MapCanvas",
	"Blizzard_MovePad",
	"Blizzard_RaidUI",
	"Blizzard_SharedMapDataProviders",
	"Blizzard_SocialUI",
	"Blizzard_TalentUI",
	"Blizzard_TradeSkillUI",
	"Blizzard_TrainerUI",
}
