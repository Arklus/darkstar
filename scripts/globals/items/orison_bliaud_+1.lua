-----------------------------------------
--	ID: 12605
--	Equip: orison_bliaud_+1
--  Adds "Refresh" Effect +1 every 3 sec
-----------------------------------------

require("scripts/globals/status");

-----------------------------------------
-- OnItemCheck
-----------------------------------------

function onItemCheck(target)
	if (target:getEquipID(SLOT_BODY) == 11186) then
		target:addStatusEffectEx(EFFECT_AUTO_REFRESH,0,1,3,0,11186);
	else
		target:delStatusEffect(EFFECT_AUTO_REFRESH,11186);
	end
end;

-----------------------------------
-- onEffectGain Action
-----------------------------------

function onEffectGain(target,effect)
end;

-----------------------------------
-- onEffectTick Action
-----------------------------------

function onEffectTick(target,effect)
	target:addMP(effect:getPower());
end;

-----------------------------------
-- onEffectLose Action
-----------------------------------

function onEffectLose(target,effect)
end;