-- sequential table since some enums need to be parsed first before others
KethoDoc.EnumGroupsIndexed = {
	{"LE_ACTIONBAR_STATE", "NUM_LE_ACTIONBAR_VISUAL_STATES"},
	{"LE_AURORA_STATE", "NUM_LE_AURORA_STATES"},
	{"LE_AUTH", "NUM_LE_AUTHS"},
	{"LE_AUTOCOMPLETE_PRIORITY", "NUM_LE_AUTOCOMPLETE_PRIORITYS"},
	{"LE_BAG_FILTER_FLAG", "NUM_LE_BAG_FILTER_FLAGS"},
	{"LE_BATTLE_PET_ACTION", "NUM_LE_BATTLE_PET_ACTIONS"}, -- 9.1.0 Enum.BattlePetAction
	{"LE_BATTLE_PET", "NUM_LE_BATTLE_PET_OWNERS"}, -- substring, 9.1.0 Enum.BattlePetOwner
	{"LE_CHARACTER_UNDELETE_RESULT", "NUM_LE_CHARACTER_UNDELETE_RESULTS"},
	{"LE_CHARACTER_UPGRADE_RESULT", "NUM_LE_CHARACTER_UPGRADE_RESULTS"},
	--{"LE_CONVERT_RESULT", "NUM_LE_CONVERT_RESULTS"}, -- classic, removed in 1.13.4
	{"LE_DEMON_HUNTER", "NUM_LE_DEMON_HUNTER_CREATION_DISABLED_REASONS"}, -- classic
	{"LE_EXPANSION", "NUM_LE_EXPANSION_LEVELS"},
	{"LE_FOLLOWER_ABILITY_CAST_RESULT", "NUM_LE_FOLLOWER_ABILITY_CAST_RESULTS"}, -- 9.0.1 Enum.FollowerAbilityCastResult
	{"LE_FOLLOWER_MISSION_COMPLETE", "NUM_LE_FOLLOWER_MISSION_COMPLETE_STATES"}, -- 9.0.1 Enum.GarrFollowerMissionCompleteState
	{"LE_FOLLOWER_TYPE", "NUM_LE_FOLLOWER_TYPES"}, -- 9.0.1 Enum.GarrisonFollowerType
	{"LE_FRAME_TUTORIAL_ACCCOUNT", "NUM_LE_FRAME_TUTORIAL_ACCCOUNTS"},
	{"LE_FRAME_TUTORIAL", "NUM_LE_FRAME_TUTORIALS"}, -- substring
	{"LE_GAME_ERR", true}, -- no num
	{"LE_GARRISON_TALENT_AVAILABILITY", "NUM_LE_GARRISON_TALENT_AVAILABILITYS"}, -- 9.0.1 Enum.GarrisonTalentAvailability
	{"LE_GARRISON_TYPE", "NUM_LE_GARRISON_TYPES"}, -- 9.0.1 Enum.GarrisonType
	{"LE_GARR_FOLLOWER_QUALITY", "NUM_LE_GARR_FOLLOWER_QUALITYS"}, -- 9.0.1 Enum.GarrFollowerQuality
	{"LE_INVENTORY_TYPE", "NUM_LE_INVENTORY_TYPES"}, -- added 8.1.5 Enum.InventoryType, removed in 9.0.1
	{"LE_INVITE_CONFIRMATION_RELATION", "NUM_LE_INVITE_CONFIRMATION_RELATIONS"}, -- classic
	{"LE_INVITE_CONFIRMATION", "NUM_LE_INVITE_REQUEST_TYPES"}, -- substring
	{"LE_ITEM_ARMOR", "NUM_LE_ITEM_ARMORS"}, -- 9.1.0 Enum.ItemArmorSubclass
	{"LE_ITEM_BIND", "NUM_LE_ITEM_BIND_TYPES"},
	{"LE_ITEM_CLASS", "NUM_LE_ITEM_CLASSS"}, -- 9.1.0 Enum.ItemClass
	{"LE_ITEM_FILTER_TYPE", "NUM_LE_ITEM_FILTER_TYPES"}, -- 9.0.1 Enum.ItemSlotFilterType
	{"LE_ITEM_GEM", "NUM_LE_ITEM_GEMS"}, -- 9.1.0 Enum.ItemGemSubclass
	{"LE_ITEM_MISCELLANEOUS", "NUM_LE_ITEM_MISCELLANEOUSS"}, -- 9.1.0 Enum.ItemMiscellaneousSubclass
	{"LE_ITEM_QUALITY", "NUM_LE_ITEM_QUALITYS"}, -- added 8.1.5 Enum.ItemQuality, removed in 9.0.1
	{"LE_ITEM_RECIPE", "NUM_LE_ITEM_RECIPES"}, -- 9.1.0 Enum.ItemRecipeSubclass
	{"LE_ITEM_WEAPON", "NUM_LE_ITEM_WEAPONS"}, -- 9.1.0 Enum.ItemWeaponSubclass
	{"LE_LFG_CATEGORY", "NUM_LE_LFG_CATEGORYS"},
	{"LE_LFG_LIST_DISPLAY_TYPE", "NUM_LE_LFG_LIST_DISPLAY_TYPES"},
	{"LE_LFG_LIST_FILTER", "NUM_LE_LFG_LIST_FILTERS"},
	{"LE_LOOT_FILTER", true}, -- no num
	{"LE_MAP_OVERLAY_DISPLAY_LOCATION", "NUM_LE_MAP_OVERLAY_DISPLAY_LOCATIONS"}, -- 9.0.1 Enum.MapOverlayDisplayLocation
	{"LE_MODEL_BLEND", "NUM_LE_MODEL_BLEND_OPERATIONS"},
	{"LE_MODEL_LIGHT", "NUM_LE_MODEL_LIGHT_TYPES"},
	{"LE_MOUNT_JOURNAL", "NUM_LE_MOUNT_JOURNAL_FILTERS"},
	{"LE_NUM", true}, -- no num
	{"LE_PAN", "NUM_LE_CINEMATIC_PAN_TYPES"},
	{"LE_PARTY_CATEGORY", "NUM_LE_PARTY_CATEGORYS"},
	{"LE_PET_BATTLE_STATE", "NUM_LE_PET_BATTLE_STATES"}, -- 9.1.0 Enum.PetBattleState
	{"LE_PET_JOURNAL_FILTER", "NUM_LE_PET_JOURNAL_FILTERS"},
	{"LE_QUEST_FACTION", "NUM_LE_QUEST_FACTIONS"},
	{"LE_QUEST_FREQUENCY", "NUM_LE_QUEST_FREQUENCYS"}, -- 9.0.1 Enum.QuestFrequency
	{"LE_QUEST_TAG_TYPE", "NUM_LE_QUEST_TAG_TYPES"}, -- 9.0.1 Enum.QuestTagType
	{"LE_REALM_RELATION", "NUM_LE_REALM_RELATIONS"},
	{"LE_RELEASE_TYPE", "NUM_LE_RELEASE_TYPES"}, -- 2.5.1
	{"LE_SCENARIO_TYPE", "NUM_LE_SCENARIO_TYPES"},
	{"LE_SCRIPT_BINDING_TYPE", "NUM_LE_SCRIPT_BINDING_TYPES"},
	{"LE_SORT_BY", "NUM_LE_PET_SORT_PARAMETERS"},
	{"LE_SPELL_CONFIRMATION_PROMPT_TYPE", "NUM_LE_SPELL_CONFIRMATION_PROMPT_TYPES"},
	{"LE_SUMMON_REASON", "NUM_LE_SUMMON_REASONS"},
	{"LE_TICKET_STATUS", "NUM_LE_GM_WEB_TICKET_STATUSS"},
	{"LE_TOKEN_CHOICE", "NUM_LE_TOKEN_CHOICES"},
	--{"LE_TOKEN_REDEEM_TYPE", "NUM_LE_TOKEN_REDEEM_TYPES"}, -- no longer has enums
	{"LE_TOKEN_RESULT", "NUM_LE_TOKEN_RESULTS"},
	{"LE_TRACKER_SORTING", "NUM_LE_TRACKER_SORTINGS"},
	{"LE_TRANSMOG_COLLECTION_TYPE", "NUM_LE_TRANSMOG_COLLECTION_TYPES"}, -- 9.0.1 Enum.TransmogCollectionType
	{"LE_TRANSMOG_SEARCH_TYPE", "NUM_LE_TRANSMOG_SEARCH_TYPES"},
	{"LE_TRANSMOG_SET_FILTER", "NUM_LE_TRANSMOG_SET_FILTERS"},
	{"LE_TRANSMOG_TYPE", "NUM_LE_TRANSMOG_TYPES"}, -- 9.0.1 Enum.TransmogType
	{"LE_TWITTER_RESULT", "NUM_LE_TWITTER_RESULTS"},
	{"LE_UNIT_STAT", "NUM_LE_UNIT_STATS"},
	{"LE_VAS_PURCHASE_STATE", "NUM_LE_VAS_PURCHASE_STATES"},
	{"LE_WORLD_ELAPSED_TIMER_TYPE", "NUM_LE_WORLD_ELAPSED_TIMER_TYPES"},
	{"LE_WORLD_QUEST_QUALITY", "NUM_LE_WORLD_QUEST_QUALITYS"}, -- 9.0.1 Enum.WorldQuestQuality
	{"LE_WOW_CONNECTION_STATE", "NUM_LE_WOW_CONNECTION_STATES"},
}

KethoDoc.EnumBitGroups = {
	CalendarEventBits = true,
	CurrencyFlags = true,
	Damageclass = true,
	UIMapFlag = true,
}

-- these dont exist anymore except the NUM_LE enum
NUM_LE_TOKEN_REDEEM_TYPES = nil
--LE_TOKEN_REDEEM_TYPE_GAME_TIME = 1
--LE_TOKEN_REDEEM_TYPE_BALANCE = 2

-- deprecated in 9.1.0
if KethoDoc.tocVersion >= 90100 then
	LE_ITEM_CLASS_CONSUMABLE = nil
	LE_ITEM_CLASS_CONTAINER = nil
	LE_ITEM_CLASS_WEAPON = nil
	LE_ITEM_CLASS_GEM = nil
	LE_ITEM_CLASS_ARMOR = nil
	LE_ITEM_CLASS_REAGENT = nil
	LE_ITEM_CLASS_PROJECTILE = nil
	LE_ITEM_CLASS_TRADEGOODS = nil
	LE_ITEM_CLASS_ITEM_ENHANCEMENT = nil
	LE_ITEM_CLASS_RECIPE = nil
	LE_ITEM_CLASS_QUIVER = nil
	LE_ITEM_CLASS_QUESTITEM = nil
	LE_ITEM_CLASS_KEY = nil
	LE_ITEM_CLASS_MISCELLANEOUS = nil
	LE_ITEM_CLASS_GLYPH = nil
	LE_ITEM_CLASS_BATTLEPET = nil
	LE_ITEM_CLASS_WOW_TOKEN = nil

	LE_ITEM_WEAPON_AXE1H = nil
	LE_ITEM_WEAPON_AXE2H = nil
	LE_ITEM_WEAPON_BOWS = nil
	LE_ITEM_WEAPON_GUNS = nil
	LE_ITEM_WEAPON_MACE1H = nil
	LE_ITEM_WEAPON_MACE2H = nil
	LE_ITEM_WEAPON_POLEARM = nil
	LE_ITEM_WEAPON_SWORD1H = nil
	LE_ITEM_WEAPON_SWORD2H = nil
	LE_ITEM_WEAPON_WARGLAIVE = nil
	LE_ITEM_WEAPON_STAFF = nil
	LE_ITEM_WEAPON_BEARCLAW = nil
	LE_ITEM_WEAPON_CATCLAW = nil
	LE_ITEM_WEAPON_UNARMED = nil
	LE_ITEM_WEAPON_GENERIC = nil
	LE_ITEM_WEAPON_DAGGER = nil
	LE_ITEM_WEAPON_THROWN = nil
	LE_ITEM_WEAPON_OBSOLETE3 = nil
	LE_ITEM_WEAPON_CROSSBOW = nil
	LE_ITEM_WEAPON_WAND = nil
	LE_ITEM_WEAPON_FISHINGPOLE = nil

	LE_ITEM_ARMOR_GENERIC = nil
	LE_ITEM_ARMOR_CLOTH = nil
	LE_ITEM_ARMOR_LEATHER = nil
	LE_ITEM_ARMOR_MAIL = nil
	LE_ITEM_ARMOR_PLATE = nil
	LE_ITEM_ARMOR_COSMETIC = nil
	LE_ITEM_ARMOR_SHIELD = nil
	LE_ITEM_ARMOR_LIBRAM = nil
	LE_ITEM_ARMOR_IDOL = nil
	LE_ITEM_ARMOR_TOTEM = nil
	LE_ITEM_ARMOR_SIGIL = nil
	LE_ITEM_ARMOR_RELIC = nil

	LE_ITEM_GEM_INTELLECT = nil
	LE_ITEM_GEM_AGILITY = nil
	LE_ITEM_GEM_STRENGTH = nil
	LE_ITEM_GEM_STAMINA = nil
	LE_ITEM_GEM_SPIRIT = nil
	LE_ITEM_GEM_CRITICALSTRIKE = nil
	LE_ITEM_GEM_MASTERY = nil
	LE_ITEM_GEM_HASTE = nil
	LE_ITEM_GEM_VERSATILITY = nil
	LE_ITEM_GEM_MULTIPLESTATS = nil
	LE_ITEM_GEM_ARTIFACTRELIC = nil

	LE_ITEM_RECIPE_BOOK = nil
	LE_ITEM_RECIPE_LEATHERWORKING = nil
	LE_ITEM_RECIPE_TAILORING = nil
	LE_ITEM_RECIPE_ENGINEERING = nil
	LE_ITEM_RECIPE_BLACKSMITHING = nil
	LE_ITEM_RECIPE_COOKING = nil
	LE_ITEM_RECIPE_ALCHEMY = nil
	LE_ITEM_RECIPE_FIRST_AID = nil
	LE_ITEM_RECIPE_ENCHANTING = nil
	LE_ITEM_RECIPE_FISHING = nil
	LE_ITEM_RECIPE_JEWELCRAFTING = nil
	LE_ITEM_RECIPE_INSCRIPTION = nil

	LE_ITEM_MISCELLANEOUS_JUNK = nil
	LE_ITEM_MISCELLANEOUS_REAGENT = nil
	LE_ITEM_MISCELLANEOUS_COMPANION_PET = nil
	LE_ITEM_MISCELLANEOUS_HOLIDAY = nil
	LE_ITEM_MISCELLANEOUS_OTHER = nil
	LE_ITEM_MISCELLANEOUS_MOUNT = nil
	LE_ITEM_MISCELLANEOUS_MOUNT_EQUIPMENT = nil

	LE_BATTLE_PET_WEATHER = nil
	LE_BATTLE_PET_ALLY = nil
	LE_BATTLE_PET_ENEMY = nil

	LE_BATTLE_PET_ACTION_NONE = nil
	LE_BATTLE_PET_ACTION_ABILITY = nil
	LE_BATTLE_PET_ACTION_SWITCH_PET = nil
	LE_BATTLE_PET_ACTION_TRAP = nil
	LE_BATTLE_PET_ACTION_SKIP = nil

	LE_PET_BATTLE_STATE_CREATED = nil
	LE_PET_BATTLE_STATE_WAITING_PRE_BATTLE = nil
	LE_PET_BATTLE_STATE_ROUND_IN_PROGRESS = nil
	LE_PET_BATTLE_STATE_WAITING_FOR_FRONT_PETS = nil
	LE_PET_BATTLE_STATE_CREATED_FAILED = nil
	LE_PET_BATTLE_STATE_FINAL_ROUND = nil
	LE_PET_BATTLE_STATE_FINISHED = nil

	LE_TRANSMOG_SEARCH_TYPE_ITEMS = nil
	LE_TRANSMOG_SEARCH_TYPE_BASE_SETS = nil
	LE_TRANSMOG_SEARCH_TYPE_USABLE_SETS = nil
end
