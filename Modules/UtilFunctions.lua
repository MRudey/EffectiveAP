-- @Author: Rudey-Everlook
-- @Date:   2020-11-06 17:16:44
-- @Last Modified by:   Rudey-Everlook
-- @Last Modified time: 2020-11-09 18:19:45


--[[
    Utility functions that are not related to WoW API
 ]]

function contains(table, element)
    -- Looks if element is present in table
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end
