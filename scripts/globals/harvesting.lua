-------------------------------------------------
--	Author: Ezekyel
--	Harvesting functions
--  Info from: 
--      http://wiki.ffxiclopedia.org/wiki/Harvesting
-------------------------------------------------

require("scripts/globals/settings");
require("scripts/globals/status");

-------------------------------------------------
-- npcid and drop by zone
-------------------------------------------------

-- Zone, {npcid,npcid,npcid,..}
npcid = {51,{16986709,16986710,16986711,16986712,16986713,16986714},
		 52,{16990600,16990601,16990602,16990603,16990604,16990605},
		 89,{},
		 95,{17167156,17167157,17167158,17167159,17167160,17167161},
		 115,{17248804,17248805,17248806,17248807,17248808,17248809},
		 123,{17281619,17281620,17281621},
		 124,{17285669,17285670,17285671},
		 145,{17371602,17371603,17371604,17371605,17371606,17371607}};
-- Zone, {itemid,drop rate,itemid,drop rate,..}
drop = {51,{0x05F2,0.1880,0x08BC,0.3410,0x08F7,0.4700,0x0874,0.5990,0x1124,0.6930,0x08DE,0.7750,0x0A55,0.8460,0x086C,0.9170,0x0735,0.9760,0x05F4,1.0000},
		52,{0x05F2,0.1520,0x08F7,0.3080,0x0874,0.4530,0x08BC,0.5650,0x086C,0.6720,0x08DE,0.7720,0x1124,0.8310,0x0735,0.8970,0x05F4,0.9410,0x03B7,0.9730,0x0A55,1.0000},
		89,{0x0341,0.2320,0x0735,0.4310,0x023D,0.5850,0x086B,0.6850,0x023C,0.7850,0x1613,0.8980,0x023F,1.0000},
		95,{0x05F2,0.1670,0x0341,0.3260,0x0342,0.4900,0x1613,0.5800,0x0735,0.6610,0x0343,0.7480,0x023D,0.8050,0x07BD,0.8610,0x05F4,0.9020,0x07BE,0.9350,0x023C,0.9620,0x023F,1.0000},
		115,{0x0341,0.1760,0x05F2,0.2840,0x0342,0.3960,0x0735,0.5050,0x0A99,0.6070,0x0343,0.6970,0x07BD,0.7470,0x11C1,0.8020,0x027B,0.8630,0x03B7,0.9010,0x023D,0.9390,0x023C,0.9620,0x0347,0.9810,0x023F,0.9920,0x05F4,1.0000},
		123,{0x1115,0.4000,0x1117,0.6000,0x1116,0.8000,0x115F,0.8700,0x1160,0.9400,0x1122,0.9700,0x07BF,1.0000},
		124,{0x1115,0.4000,0x1117,0.6000,0x1116,0.8000,0x115F,0.8700,0x1162,0.9400,0x1161,0.9700,0x07BF,1.0000},
		145,{0x0735,0.1410,0x05F2,0.2820,0x0A99,0.4230,0x0343,0.5430,0x0342,0.6480,0x0341,0.7320,0x027B,0.7940,0x11C1,0.8440,0x07BE,0.8870,0x03B7,0.9260,0x023F,0.9480,0x023C,0.9650,0x05F4,0.9760,0x0347,0.9930,0x023D,1.0000}};
-- Define array of Colored Rocks, Do not reorder this array or rocks.
rocks = {0x0301,0x0302,0x0303,0x0304,0x0305,0x0306,0x0308,0x0307};

function startHarvesting(player,zone,npc,trade,csid)
	
	math.randomseed(os.time());
	
	if(trade:hasItemQty(1020,1) and trade:getItemCount() == 1) then
		
		broke = sickleBreak(player,trade);
		item = getItem(player,zone);
		
		if(player:getFreeSlotsCount() == 0) then
			full = 1;
		else
			full = 0;
		end
		
		player:startEvent(csid,item,broke,full);
		
		if(item ~= 0 and full == 0) then
			player:addItem(item);
			SetServerVariable("[HARVESTING]Zone "..zone,GetServerVariable("[HARVESTING]Zone "..zone) + 1);
		end
		
		if(GetServerVariable("[HARVESTING]Zone "..zone) >= 3) then
			getNewPositionNPC(player,npc,zone);
		end
	else
		player:messageSpecial(HARVESTING_IS_POSSIBLE_HERE,1020);
	end
	
end

-----------------------------------
-- Determine if Pickaxe breaks
-----------------------------------

function sickleBreak(player,trade)
	
	local broke = 0;
	sicklebreak = math.random();
	sicklebreak = math.random();
	sicklebreak = math.random();
	
	--------------------
	-- Begin Gear Bonus
	--------------------
	Body = player:getEquipID(SLOT_BODY);
	Legs = player:getEquipID(SLOT_LEGS);
	Feet = player:getEquipID(SLOT_FEET);
	
	if(Body == 14374 or Body == 14375) then
		sicklebreak = sicklebreak + 0.073;
	end
	if(Legs == 14297 or Legs == 14298) then
		sicklebreak = sicklebreak + 0.073;
	end
	if(Feet == 14176 or Feet == 14177) then
		sicklebreak = sicklebreak + 0.073;
	end
	
	if(sicklebreak < HARVESTING_BREAK_CHANCE) then
		broke = 1;
		player:tradeComplete();
	end
	
	return broke;
	
end

-----------------------------------
-- Get an item
-----------------------------------

function getItem(player,zone)	
	
	Rate = math.random();
	Rate = math.random();
	Rate = math.random();
	
	for zon = 1, table.getn(drop), 2 do
		if(drop[zon] == zone) then
			for itemlist = 1, table.getn(drop[zon + 1]), 2 do
				if(Rate <= drop[zon + 1][itemlist + 1]) then
					item = drop[zon + 1][itemlist];		
					break;			
				end
			end
			break;
		end
	end
	
	--------------------
	-- Determine chance of no item mined
	-- Default rate is 50%
	--------------------
	
	Rate = math.random();
	Rate = math.random();
	Rate = math.random();
	
	if(Rate <= (1 - HARVESTING_RATE)) then
		item = 0;
	end
	
	return item;
	
end

-----------------------------------------
-- After 3 items he change the position
-----------------------------------------

function getNewPositionNPC(player,npc,zone)
	
	local newnpcid = npc:getID();
	
	for u = 1, table.getn(npcid), 2 do
		if(npcid[u] == zone) then
			nbNPC = table.getn(npcid[u + 1]);
			while newnpcid == npc:getID() do
				newnpcid = math.random(1,nbNPC);
				newnpcid = npcid[u + 1][newnpcid];
			end
			break;
		end
	end
	
	npc:setStatus(2);
	GetNPCByID(newnpcid):setStatus(0);
	SetServerVariable("[HARVESTING]Zone "..zone,0);
	
end