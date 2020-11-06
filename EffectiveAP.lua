-- @Author: Rudey-Everlook
-- @Date:   2020-11-06 16:04:57
-- @Last Modified by:   Rudey-Everlook
-- @Last Modified time: 2020-11-06 17:08:55

--[[

MAIN File for EffectiveAP Addon

]]

-- Weighting factors for melee combat
local mfac = {
    Druid = {agi = 0, str = 2, crit = 30, agicrit = 0},
    DruidBear = {agi = 0, str = 2, crit = 30, agicrit = 0},
    DruidCat = {agi = 1, str = 2, crit = 30, agicrit = 0},
    Hunter = {agi = 1, str = 1, crit = 30, agicrit = 53},
    Paladin = {agi = 0, str = 2, crit = 30, agicrit = 0},
    Rogue = {agi = 2, str = 1, crit = 30, agicrit = 29},
    Shaman = {agi = 2, str = 1, crit = 30, agicrit = 0},
    Warrior = {agi = 0, str = 2, crit = 30, agicrit = 2 }
}

-- Weighting factors for ranged combat
local rngfac = {
    Hunter = {agi = 2, rcrit = 30 },
    Rogue = {agi = 2, rcrit = 30},
    Warrior = {agi = 2, rcrit = 30}
}

-- Tables to look up which class can do what
local melee_classes = {
    'Druid','DruidBear','DruidCat','Hunter','Paladin','Rogue','Shaman','Warrior'
}
local ranged_classes = {'Hunter','Rogue','Warrior'}

-- Table containing all itemIDs which have +1 crit
local crit_items_1 = {
    867, 1680, 2244, 3854, 7719, 7927, 7935, 7937, 8347, 11931, 12548, 12584,
    12639, 12774, 12783, 12929, 12936, 12940, 12963, 13036, 13098, 13162,
    13217, 13359, 13400, 13404, 13957, 13959, 13962, 14615, 15058, 15062,
    15063, 15411, 15860, 16345, 16417, 16421, 16425, 16426, 16430, 16433,
    16450, 16451, 16452, 16453, 16454, 16455, 16456, 16463, 16465, 16466,
    16467, 16471, 16473, 16474, 16475, 16477, 16478, 16484, 16504, 16505,
    16513, 16521, 16522, 16525, 16527, 16541, 16542, 16548, 16549, 16550,
    16552, 16560, 16561, 16563, 16564, 16565, 16566, 16567, 16571, 16574,
    16577, 16578, 16579, 16820, 16822, 16827, 16845, 16846, 16847, 16851,
    16905, 16908, 16909, 16910, 16936, 16938, 16939, 16940, 16942, 17072,
    17076, 18204, 18205, 18238, 18324, 18366, 18380, 18393, 18404, 18420,
    18421, 18505, 18520, 18524, 18530, 18713, 18725, 18805, 18821, 18823,
    18827, 18828, 18830, 18831, 18832, 18838, 18840, 18843, 18844, 18847,
    18848, 18865, 18866, 18867, 18868, 18869, 18871, 18876, 18877, 19137,
    19143, 19157, 19167, 19325, 19365, 19380, 19692, 19823, 19825, 19856,
    19859, 19865, 19869, 19887, 19896, 19898, 19900, 19904, 19984, 20041,
    20042, 20043, 20045, 20083, 20088, 20089, 20106, 20115, 20124, 20134,
    20150, 20151, 20153, 20177, 20190, 20193, 20204, 20205, 20257, 20259,
    20488, 20521, 20551, 20556, 20665, 20668, 20671, 21182, 21242, 21244,
    21278, 21316, 21317, 21353, 21356, 21357, 21360, 21362, 21364, 21366,
    21368, 21370, 21374, 21387, 21389, 21390, 21393, 21463, 21581, 21586,
    21599, 21623, 21650, 21664, 21673, 21677, 21715, 21803, 21809, 21814,
    21998, 21999, 22005, 22060, 22089, 22090, 22191, 22194, 22195, 22322,
    22326, 22384, 22385, 22436, 22437, 22439, 22441, 22442, 22477, 22479,
    22480, 22481, 22482, 22483, 22651, 22656, 22659, 22672, 22673, 22676,
    22690, 22714, 22715, 22740, 22748, 22749, 22753, 22802, 22808, 22811,
    22812, 22816, 22864, 22872, 22876, 22877, 22879, 22880, 22936, 22954,
    23000, 23014, 23023, 23038, 23044, 23045, 23219, 23242, 23243, 23244,
    23252, 23257, 23258, 23259, 23274, 23284, 23294, 23298, 23299, 23300,
    23307, 23312, 23313, 23314, 23315, 23456, 23467, 23557, 23667
}

-- Table containing all itemIDs which have +2 crit
local crit_items_2 = {
    9413, 11726, 11735, 11921, 11926, 12587, 12640, 12757, 13944, 13965, 15056,
    15057, 16419, 16431, 16435, 16479, 16508, 16515, 16543, 16821, 18538,
    18715, 18817, 19323, 19358, 19690, 19834, 19875, 19945, 19998, 20487,
    20627, 20696, 21495, 21651, 22438, 22476, 22478, 22691, 22798, 22815,
    22873, 22874, 22875, 23053, 23068, 23071, 23226, 23251, 23292, 23293,
    23301, 23306, 23668
}

local invslots = {
    INVTYPE_HEAD = 1,
    INVTYPE_NECK = 2,
    INVTYPE_SHOULDER = 3,
    INVTYPE_BODY = 4,
    INVTYPE_CHEST = 5,
    INVTYPE_ROBE = 5,
    INVTYPE_WAIST = 6,
    INVTYPE_LEGS = 7,
    INVTYPE_FEET = 8,
    INVTYPE_WRIST = 9,
    INVTYPE_HAND = 10,
    INVTYPE_FINGER = 20,
    INVTYPE_TRINKET = 21,
    INVTYPE_CLOAK = 15,
    INVTYPE_WEAPON = 22,
    INVTYPE_SHIELD = 17,
    INVTYPE_2HWEAPON = 16,
    INVTYPE_WEAPONMAINHAND = 16,
    INVTYPE_WEAPONOFFHAND = 17,
    INVTYPE_HOLDABLE = 17,
    INVTYPE_RANGED = 18,
    INVTYPE_THROWN = 18,
    INVTYPE_RANGEDRIGHT = 18,
    INVTYPE_RELIC = 18,
    INVTYPE_TABARD = 19
}

local function contains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

local function GetCritVal(itemID)
    if contains(crit_items_1, itemID) then
        crit = 1
    else
        if contains(crit_items_2, itemID) then
            crit = 2
        else
            crit = 0
        end
    end
    return crit
end

local function CalculateMeleeEAP(itemStats, itemID, playerClass)
    -- Calculates the EAP from the items stats with the respective mutlipliers
    -- per class
    agi = (itemStats['ITEM_MOD_AGILITY_SHORT'] or 0) * mfac[playerClass]['agi']
    str = (itemStats['ITEM_MOD_STRENGTH_SHORT'] or 0) * mfac[playerClass]['str']
    ap = (itemStats['ITEM_MOD_ATTACK_POWER_SHORT'] or -1) + 1
    crit = GetCritVal(itemID) * mfac[playerClass]['crit']
    map = (itemStats['ITEM_MOD_MELEE_ATTACK_POWER_SHORT'] or -1) + 1
    bonus_crit = ((itemStats['ITEM_MOD_AGILITY_SHORT'] or 0) / mfac[playerClass]['agicrit']) * mfac[playerClass]['crit']
    eap = (agi + str + ap + crit + map)
    eap_str = math.ceil(eap)
    return eap_str
end

local function CalculateRangeEAP(itemStats, itemID, playerClass)
    -- Calculates the EAP from the items stats with the respective mutlipliers
    -- per class

    agi = (itemStats['ITEM_MOD_AGILITY_SHORT'] or 0) * rngfac[playerClass]['agi']
    ap = (itemStats['ITEM_MOD_ATTACK_POWER_SHORT'] or -1) + 1
    rap = (itemStats['ITEM_MOD_RANGED_ATTACK_POWER'] or -1) + 1
    crit = GetCritVal(itemID) * rngfac[playerClass]['rcrit']
    eap = (agi + rap + ap + crit)
    eap_str = math.ceil(eap)
    return eap_str
end


local function FormatDiff(diff)
    RED     = "|cffff2020";
    GREEN   = "|cff20ff20";
    GRAY    = "|cff808080";
    YELLOW    = "|cffffff00";
    LIGHTYELLOW = "|cffffff9a";
    ORANGE    = "|cffff7f3f";

    if diff == 0 then
        return ' '
    elseif diff > 5 then
        return (GREEN..'+'..tostring(diff)..'|r')
    elseif diff > 0 then
        return (YELLOW..'+'..tostring(diff)..'|r')
    elseif diff < -5 then
        return (RED..tostring(diff)..'|r')
    elseif diff < 0 then
        return (ORANGE..tostring(diff)..'|r')
    end
end


local function GetEquipEAP(invSlot, playerClass)
    local equipItemLink = GetInventoryItemLink('player', invSlot)
    local equipItemID = (GetInventoryItemID('player', invSlot) or -1)

    if (equipItemID > 0) then
        equipItemStats = GetItemStats(equipItemLink)
        other_eap = CalculateMeleeEAP(equipItemStats, equipItemID, playerClass)
        other_reap = CalculateRangeEAP(equipItemStats, equipItemID, playerClass)
    else
        other_eap = 0
        other_reap = 0
    end

    return other_eap, other_reap
end


local function OnTooltipSetItem(self)
    -- Get the name of the item.
    local itemName, itemLink = self:GetItem()
    local playerClass = UnitClass('player')
	if not itemName then
        return;
    end

    -- Only run for melee or ranged classes
    if not contains(melee_classes, playerClass) or not contains(ranged_classes, playerClass) then
        return;
    end

	-- Get the ID of the item.
    local itemID = select(1, GetItemInfoInstant(itemName))


    -- If for some reason we did not get the ID above, we try another way here.
    if itemID == nil then
        -- Extract ID from link: GetItemInfoInstant unreliable with AH items (uncached on client?)
        itemID = tonumber( string.match( itemLink, 'item:?(%d+):' ) )
        if itemID == nil then
            -- The item link doesn't contain the item ID field
            return
        end
    end

    local itemStats = GetItemStats(itemLink)
    local itemEquipLoc = select(9, GetItemInfo(itemID))
    local invSlot = (invslots[itemEquipLoc] or -1)

    local eap = CalculateMeleeEAP(itemStats, itemID, playerClass)
    local eap_str = '|cffff7f3fMEAP: '..tostring(eap)..'|r'
    local reap = CalculateRangeEAP(itemStats, itemID, playerClass)
    local reap_str = '|cffff7f3fREAP: '..tostring(reap)..'|r'

    if invSlot < 20 and invSlot>=0 then
        other_eap, other_reap = GetEquipEAP(invSlot, playerClass)
        diff = eap - other_eap
        diff_str = ' '..FormatDiff(diff)
        rdiff = reap - other_reap
        rdiff_str = ' '..FormatDiff(rdiff)
    elseif invSlot == 20 then
        other_eap, other_reap = GetEquipEAP(11, playerClass)
        diff = eap - other_eap
        diff_str1 = FormatDiff(diff)
        rdiff = reap - other_reap
        rdiff_str1 = FormatDiff(rdiff)
        other_eap, other_reap = GetEquipEAP(12, playerClass)
        diff = eap - other_eap
        diff_str2 = FormatDiff(diff)
        rdiff = reap - other_reap
        rdiff_str2 = FormatDiff(rdiff)
        diff_str = ' ('..diff_str1..'/'..diff_str2..')'
        rdiff_str = ' ('..rdiff_str1..'/'..rdiff_str2..')'
    elseif invSlot == 21 then
        other_eap, other_reap = GetEquipEAP(13, playerClass)
        diff = eap - other_eap
        diff_str1 = FormatDiff(diff)
        rdiff = reap - other_reap
        rdiff_str1 = FormatDiff(rdiff)
        other_eap, other_reap = GetEquipEAP(14, playerClass)
        diff = eap - other_eap
        diff_str2 = FormatDiff(diff)
        rdiff = reap - other_reap
        rdiff_str2 = FormatDiff(rdiff)
        diff_str = ' ('..diff_str1..'/'..diff_str2..')'
        rdiff_str = ' ('..rdiff_str1..'/'..rdiff_str2..')'
    elseif invSlot == 22 then
        other_eap, other_reap = GetEquipEAP(16, playerClass)
        diff = eap - other_eap
        diff_str1 = FormatDiff(diff)
        rdiff = reap - other_reap
        rdiff_str1 = FormatDiff(rdiff)
        other_eap, other_reap = GetEquipEAP(17, playerClass)
        diff = eap - other_eap
        diff_str2 = FormatDiff(diff)
        rdiff = reap - other_reap
        rdiff_str2 = FormatDiff(rdiff)
        diff_str = ' ('..diff_str1..'/'..diff_str2..')'
        rdiff_str = ' ('..rdiff_str1..'/'..rdiff_str2..')'
    end

    if contains(melee_classes, playerClass) then
        self:AddLine(eap_str..diff_str)
    end
    if contains(ranged_classes, playerClass) then
        self:AddLine(reap_str..rdiff_str)
    end
end


GameTooltip:HookScript('OnTooltipSetItem', OnTooltipSetItem)
ItemRefTooltip:HookScript('OnTooltipSetItem', OnTooltipSetItem)
ItemRefShoppingTooltip1:HookScript('OnTooltipSetItem', OnTooltipSetItem)
ItemRefShoppingTooltip2:HookScript('OnTooltipSetItem', OnTooltipSetItem)
ShoppingTooltip1:HookScript('OnTooltipSetItem', OnTooltipSetItem)
ShoppingTooltip2:HookScript('OnTooltipSetItem', OnTooltipSetItem)