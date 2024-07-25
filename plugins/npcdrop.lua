local PLUGIN = PLUGIN
PLUGIN.name = "NPC Item Drop"
PLUGIN.author = "Halokiller38"
PLUGIN.desc = "This plugin makes it when you kill a zombie it drops a random item from the junk category."

-- If you would like to make it so it drops a different category of items, then change the word junk in (v.category == "junk") then
-- to whatever name of the category you want to have NPCs to drop. If you want it to drop multiple different categories add me and I can help you.
-- Thank you for using my plugin!

function PLUGIN:OnNPCKilled(entity)
	local class = entity:GetClass()
	local items = {}
	
	for k, v in pairs( nut.item.GetAll() ) do
		if (v.category == "Junk") then
			items[k] = v
		end;
	end;
	
	local RandomItem = table.Random(items)
	if (class == "vj_fallout_scorps") then
		nut.item.Spawn(entity:GetPos() + Vector(0, 0, 8), nil, "Radscorpion Poison Gland")
	end
end
	if (class == "npc_cazadore" or class == "npc_cazadoresmall") then
		nut.item.Spawn(entity:GetPos() + Vector(0, 0, 8), nil, "Cazador Poison Gland")
	end
	if (class == "npc_mantis" or class == "npc_mantissmall") then
		nut.item.Spawn(entity:GetPos() + Vector(0, 0, 8), nil, "Mantis Claw")
	end
	if (class == "npc_vj_fallout_bighorner") then
		nut.item.Spawn(entity:GetPos() + Vector(0, 0, 8), nil, "Bighorner Meat")
	end
