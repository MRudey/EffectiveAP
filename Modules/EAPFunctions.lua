-- @Author: Rudey-Everlook
-- @Date:   2020-11-06 17:15:31
-- @Last Modified by:   Rudey-Everlook
-- @Last Modified time: 2020-11-09 18:19:40


--[[
    Basic functions for the addon to work
 ]]


function GetCritVal(itemID)
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


function CalculateMeleeEAP(itemStats, itemID, playerClass)
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


function CalculateRangeEAP(itemStats, itemID, playerClass)
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


function FormatDiff(diff)
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


function GetEquipEAP(invSlot, playerClass)
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
