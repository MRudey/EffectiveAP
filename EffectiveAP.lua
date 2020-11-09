-- @Author: Rudey-Everlook
-- @Date:   2020-11-06 16:04:57
-- @Last Modified by:   Rudey-Everlook
-- @Last Modified time: 2020-11-09 18:18:17

--[[

MAIN File for EffectiveAP Addon

]]

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