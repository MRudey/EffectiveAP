-- @Author: Rudey-Everlook
-- @Date:   2020-11-06 17:14:17
-- @Last Modified by:   Rudey-Everlook
-- @Last Modified time: 2020-11-09 18:18:59

--[[
    Contains all class related data such as the individual weighting factors and
    which classes are actually using the addon.
 ]]

-- Weighting factors for melee combat
mfac = {
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
rngfac = {
    Hunter = {agi = 2, rcrit = 30 },
    Rogue = {agi = 2, rcrit = 30},
    Warrior = {agi = 2, rcrit = 30}
}

-- Tables to look up which class can do what
melee_classes = {
    'Druid','DruidBear','DruidCat','Hunter','Paladin','Rogue','Shaman','Warrior'
}
ranged_classes = {'Hunter','Rogue','Warrior'}
