-----------------------------------------
-- ID: 4456
-- Item: Boiled Crab
-- Food Effect: 30Min, All Races
-----------------------------------------
-- Vitality 2
-- defense % 27
-- defense % 50
-----------------------------------------
require("scripts/globals/status")
require("scripts/globals/msg")
-----------------------------------------

function onItemCheck(target)
    local result = 0
    if target:hasStatusEffect(dsp.effect.FOOD) or target:hasStatusEffect(dsp.effect.FIELD_SUPPORT_FOOD) then
        result = dsp.msg.basic.IS_FULL
    end
    return result
end

function onItemUse(target)
    target:addStatusEffect(dsp.effect.FOOD,0,0,1800,4456)
end

function onEffectGain(target,effect)
    target:addMod(dsp.mod.VIT, 2)
    target:addMod(dsp.mod.FOOD_DEFP, 27)
    target:addMod(dsp.mod.FOOD_DEF_CAP, 50)
end

function onEffectLose(target, effect)
    target:delMod(dsp.mod.VIT, 2)
    target:delMod(dsp.mod.FOOD_DEFP, 27)
    target:delMod(dsp.mod.FOOD_DEF_CAP, 50)
end
