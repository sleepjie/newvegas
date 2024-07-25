function SCHEMA:RegisterItem(ITEM)
	nut.item.PrepareItemTable(ITEM)
	nut.item.Register(ITEM, false)
end

local codex = ""

local headgear = {
	{name = "Eyebot Helmet", 			tier = 5, dt = 2, price = 200, bg = 1, Type = "Fullhat", model = "models/lazarusroleplay/headgear/~_fullhats01.mdl"},
	{name = "Raider Mask", 				tier = 1, dt = 1, price = 50, bg = 2, Type = "Fullhat", model = "models/lazarusroleplay/headgear/~_fullhats01.mdl"},
	{name = "Filtration Mask", 				tier = 2, dt = 1, price = 100, bg = 9, Type = "Fullhat", model = "models/lazarusroleplay/headgear/~_fullhats01.mdl"},
	{name = "Vault Security Helmet", 	tier = 5, dt = 2, price = 250, bg = 3, Type = "Fullhat", model = "models/lazarusroleplay/headgear/~_fullhats01.mdl"},
	{name = "Head Bandages", 			tier = 1, dt = 0, price = 10, bg = 4, Type = "Fullhat", model = "models/lazarusroleplay/headgear/~_fullhats01.mdl"},
	{name = "Friendly Clown Mask", 		tier = 5, dt = 1, price = 15, bg = 5, Type = "Fullhat", model = "models/lazarusroleplay/headgear/~_fullhats01.mdl"},
	{name = "Ghoul Mask", 				tier = 5, dt = 0, price = 20, bg = 6, Type = "Fullhat", model = "models/lazarusroleplay/headgear/~_fullhats01.mdl"},
	{name = "T45d Power Armor Helmet", 	tier = "U", dt = 15, gasmask = true, price = 2150, bg = 7, Type = "Fullhat", model = "models/lazarusroleplay/headgear/~_fullhats01.mdl"},
	{name = "Lobotomite Mask", 			tier = 5, dt = 1, price = 70, bg = 8, Type = "Fullhat", model = "models/lazarusroleplay/headgear/~_fullhats01.mdl"},
	{name = "Miner Helmet", 			tier = 5, dt = 1, price = 40, bg = 9, Type = "Fullhat", model = "models/lazarusroleplay/headgear/~_fullhats01.mdl"},
	{name = "T51b Power Armor Helmet (2)", 	tier = "U", dt = 18, gasmask = true, price = 4300, bg = 5, Type = "Fullhat", model = "models/lazarusroleplay/headgear/helmets01.mdl"},
	{name = "Motorcycle Helmet", 		tier = 2, dt = 4, price = 400, bg = 2, Type = "Fullhat", model = "models/lazarusroleplay/headgear/helmets01.mdl"},
	{name = "T51b Power Armor Helmet", 	tier = "U", dt = 18, gasmask = true, price = 4300, bg = 2, Type = "Fullhat", model = "models/lazarusroleplay/headgear/~_powerarmor01.mdl"},
	{name = "Black T51b Power Armor Helmet", 	tier = "U", dt = 18, gasmask = true, price = 4300, bg = 2, skin = 2, Type = "Fullhat", model = "models/lazarusroleplay/headgear/~_powerarmor01.mdl"},
	{name = "Advanced Power Armor Helmet", 	tier = "U", dt = 20, gasmask = true, price = 5000, bg = 3, Type = "Fullhat", model = "models/lazarusroleplay/headgear/~_powerarmor01.mdl"},

	{name = "NCR Red Beret", 			tier = "U", dt = 3, price = 300, bg = 2, Type = "Hat", model = "models/lazarusroleplay/headgear/hats01.mdl"},
	{name = "NCR Green Beret", 			tier = "U", dt = 3, price = 300, bg = 1, Type = "Hat", model = "models/lazarusroleplay/headgear/hats01.mdl"},
	{name = "Bonnet", 					tier = 1, dt = 0, price = 10, bg = 3, Type = "Hat", model = "models/lazarusroleplay/headgear/hats01.mdl"},
	{name = "Straw Hat", 				tier = 1, dt = 0, price = 10, bg = 4, Type = "Hat", model = "models/lazarusroleplay/headgear/hats01.mdl"},
	{name = "Newsman Fedora", 			tier = 1, dt = 0, price = 10, bg = 5, Type = "Hat", model = "models/lazarusroleplay/headgear/hats01.mdl"},
	{name = "Metalic Helmet", 			tier = 1, dt = 0, price = 20, bg = 7, Type = "Hat", model = "models/lazarusroleplay/headgear/hats01.mdl"},
	{name = "Sombrero", 				tier = 1, dt = 0, price = 15, bg = 8, Type = "Hat", model = "models/lazarusroleplay/headgear/hats01.mdl"},
	{name = "Rider Helmet", 				tier = 1, dt = 0, price = 20, bg = 9, Type = "Hat", model = "models/lazarusroleplay/headgear/hats01.mdl"},
	{name = "Pimp Hat", 				tier = 1, dt = 0, price = 25, bg = 10, Type = "Hat", model = "models/lazarusroleplay/headgear/hats01.mdl"},
	{name = "Park Ranger Hat", 				tier = 1, dt = 0, price = 40, bg = 11, Type = "Hat", model = "models/lazarusroleplay/headgear/hats01.mdl"},

	{name = "Aviators", 				tier = 5, dt = 0, price = 10, bg = 1, Type = "Glasses", model = "models/lazarusroleplay/headgear/~_glasses01.mdl"},
	{name = "Thin Framed Glasses", 		tier = 1, dt = 0, price = 5, bg = 2, Type = "Glasses", model = "models/lazarusroleplay/headgear/~_glasses01.mdl"},
	{name = "Lovely Glasses", 			tier = 1, dt = 0, price = 5, bg = 3, Type = "Glasses", model = "models/lazarusroleplay/headgear/~_glasses01.mdl"},
	{name = "Tortoise Shell Glasses",	tier = 1, dt = 0, price = 10, bg = 4, Type = "Glasses", model = "models/lazarusroleplay/headgear/~_glasses01.mdl"},
	{name = "Thick Framed Glasses", 	tier = 1, dt = 0, price = 12, bg = 5, Type = "Glasses", model = "models/lazarusroleplay/headgear/~_glasses01.mdl"},
	{name = "Hip Glasses", 				tier = 1, dt = 0, price = 7, bg = 6, Type = "Glasses", model = "models/lazarusroleplay/headgear/~_glasses01.mdl"},
	{name = "Biker Goggles", 			tier = 1, dt = 0, price = 15, bg = 7, Type = "Glasses", model = "models/lazarusroleplay/headgear/~_glasses01.mdl"},
	{name = "Lobotomite Goggles", 		tier = 1, dt = 0, price = 20, bg = 8, Type = "Glasses", model = "models/lazarusroleplay/headgear/~_glasses01.mdl"},


	{name = "Bandana (Head)", 			tier = 1, dt = 0, price = 5, bg = 1, Type = "Hat", model = "models/lazarusroleplay/headgear/~_hats01.mdl"},
	{name = "Trilby", 					tier = 1, dt = 0, price = 10, bg = 2, Type = "Hat", model = "models/lazarusroleplay/headgear/~_hats01.mdl"},
	{name = "Fedora", 					tier = 1, dt = 0, price = 10, bg = 3, Type = "Hat", model = "models/lazarusroleplay/headgear/~_hats01.mdl"},
	{name = "Fedora (2)", 				tier = 1, dt = 0, price = 10, bg = 3, skin = 1, Type = "Hat", model = "models/lazarusroleplay/headgear/~_hats01.mdl"},
	{name = "Fedora (3)", 				tier = 1, dt = 0, price = 10, bg = 3, skin = 2, Type = "Hat", model = "models/lazarusroleplay/headgear/~_hats01.mdl"},
	{name = "Boomer Beret", 			tier = 1, dt = 0, price = 20, bg = 4, Type = "Hat", model = "models/lazarusroleplay/headgear/~_hats01.mdl"},
	{name = "Boomer Cap",				tier = 1, dt = 0, price = 25, bg = 5, Type = "Hat", model = "models/lazarusroleplay/headgear/~_hats01.mdl"},
	{name = "Straw Cowboy Hat", 		tier = 1, dt = 0, price = 10, bg = 6, Type = "Hat", model = "models/lazarusroleplay/headgear/~_hats01.mdl"},
	{name = "Hide Cowboy Hat", 			tier = 1, dt = 0, price = 12, bg = 7, Type = "Hat", model = "models/lazarusroleplay/headgear/~_hats01.mdl"},
	{name = "Miner Helmet", 			tier = 1, dt = 0, price = 20, bg = 8, Type = "Hat", model = "models/lazarusroleplay/headgear/~_hats01.mdl"},
	{name = "Ball Cap", 				tier = 1, dt = 0, price = 5, bg = 9, Type = "Hat", model = "models/lazarusroleplay/headgear/~_hats01.mdl"},
	{name = "Birthday Cap", 			tier = 1, dt = 0, price = 2, bg = 10, Type = "Hat", model = "models/lazarusroleplay/headgear/~_hats01.mdl"},
	{name = "Pimp Hat", 				tier = 1, dt = 0, price = 25, bg = 11, Type = "Hat", model = "models/lazarusroleplay/headgear/~_hats01.mdl"},
	{name = "NCR Ranger Hat", 			tier = 1, dt = 1, price = 200, bg = 12, Type = "Hat", model = "models/lazarusroleplay/headgear/~_hats01.mdl"},
	{name = "Fireman Helmet", 			tier = 1, dt = 1, price = 40, bg = 13, Type = "Hat", model = "models/lazarusroleplay/headgear/~_hats01.mdl"},
	{name = "Motorcycle Helmet", 		tier = 1, dt = 1, price = 100, bg = 14, Type = "Helmet", model = "models/lazarusroleplay/headgear/~_hats01.mdl"},
	{name = "Cloth Hood", 				tier = 1, dt = 0, price = 12, bg = 15, Type = "Hat", model = "models/lazarusroleplay/headgear/~_hats01.mdl"},
	{name = "Top Hat",					tier = 1, dt = 0, price = 10, bg = 16, Type = "Hat", model = "models/lazarusroleplay/headgear/~_hats01.mdl"},
	{name = "Roving Trader Hat", 		tier = 1, dt = 0, price = 5, bg = 17, Type = "Hat", model = "models/lazarusroleplay/headgear/~_hats01.mdl"},
	{name = "Doo Rag", 					tier = 1, dt = 0, price = 5, bg = 18, Type = "Hat", model = "models/lazarusroleplay/headgear/~_hats01.mdl"},
	{name = "Stormchaser Helmet", 		tier = 1, dt = 0, price = 5, bg = 19, Type = "Hat", model = "models/lazarusroleplay/headgear/~_hats01.mdl"},
	{name = "Stormchaser Hat", 			tier = 1, dt = 0, price = 5, bg = 20, Type = "Hat", model = "models/lazarusroleplay/headgear/~_hats01.mdl"},
	{name = "Burlap Hood", 				tier = 1, dt = 0, price = 5, bg = 21, Type = "Hat", model = "models/lazarusroleplay/headgear/~_hats01.mdl"},


	{name = "Police Cap", 				tier = 1, dt = 0, price = 10, bg = 1, Type = "Hat", model = "models/lazarusroleplay/headgear/~_hats02.mdl"},
	{name = "Adventurer Cap", 			tier = 1, dt = 0, price = 5, bg = 2, Type = "Hat", model = "models/lazarusroleplay/headgear/~_hats02.mdl"},
	{name = "Combat Helmet", 			tier = 4, dt = 4, price = 500, bg = 3, Type = "Hat", model = "models/lazarusroleplay/headgear/~_hats02.mdl"},
	{name = "Combat Helmet (2)", 			tier = 4, dt = 4, price = 500, bg = 3, skin = 1, Type = "Hat", model = "models/lazarusroleplay/headgear/~_hats02.mdl"},
	{name = "Combat Helmet (3)", 			tier = 4, dt = 4, price = 500, bg = 3, skin = 2, Type = "Hat", model = "models/lazarusroleplay/headgear/~_hats02.mdl"},
	{name = "Combat Helmet (4)", 			tier = 4, dt = 4, price = 500, bg = 3, skin = 3, Type = "Hat", model = "models/lazarusroleplay/headgear/~_hats02.mdl"},
	{name = "Combat Armor Helmet (1)", 	tier = 4, dt = 4, price = 500, bg = 4, skin = 0, Type = "Hat", model = "models/lazarusroleplay/headgear/~_hats02.mdl"},
	{name = "Combat Armor Helmet (2)", 	tier = 4, dt = 4, price = 500, bg = 4, skin = 1, Type = "Hat", model = "models/lazarusroleplay/headgear/~_hats02.mdl"},
	{name = "Combat Armor Helmet (3)", 	tier = 4, dt = 4, price = 500, bg = 4, skin = 2, Type = "Hat", model = "models/lazarusroleplay/headgear/~_hats02.mdl"},
	{name = "Combat Armor Helmet (4)", 	tier = 4, dt = 4, price = 500, bg = 4, skin = 3, Type = "Hat", model = "models/lazarusroleplay/headgear/~_hats02.mdl"},
	{name = "Tribal Helmet", 			tier = 2, dt = 1, price = 40, bg = 5, Type = "Hat", model = "models/lazarusroleplay/headgear/~_hats02.mdl"},
	{name = "Metal Armor Helmet", 		tier = 3, dt = 3, price = 350, bg = 6, Type = "Hat", model = "models/lazarusroleplay/headgear/~_hats02.mdl"},
	{name = "Tribal Hat", 				tier = 2, dt = 0, price = 10, bg = 7, Type = "Hat", model = "models/lazarusroleplay/headgear/~_hats02.mdl"},


	{name = "Respirator", 				tier = 1, dt = 0, gasmask = true, price = 200, bg = 1, Type = "Mask", allowglasses = true, model = "models/lazarusroleplay/headgear/~_masks01.mdl"},
	{name = "Hockeymask", 				tier = 1, dt = 0, price = 30, bg = 2, Type = "Mask", allowglasses = false, model = "models/lazarusroleplay/headgear/~_masks01.mdl"},
	{name = "Surgical Mask",			tier = 1, dt = 0, price = 10, bg = 3, Type = "Mask", allowglasses = true, model = "models/lazarusroleplay/headgear/~_masks01.mdl"},
	{name = "Ultra-Luxe Mask", 			tier = 1, dt = 0, price = 10, bg = 4, Type = "Mask", allowglasses = false, model = "models/lazarusroleplay/headgear/~_masks01.mdl"},
	{name = "Welding Mask", 			tier = 2, dt = 1, price = 40, bg = 5, Type = "Mask", allowglasses = false, model = "models/lazarusroleplay/headgear/~_masks01.mdl"},


	{name = "NCR Goggles Helmet", 		tier = "U", dt = 2, price = 250, bg = 1, Type = "Helmet", model = "models/lazarusroleplay/headgear/factions/ncr/~_hats01.mdl", maleonly = true},
	{name = "NCR Helmet", 				tier = "U", dt = 2, price = 200, bg = 2, Type = "Helmet", model = "models/lazarusroleplay/headgear/factions/ncr/~_hats01.mdl", maleonly = true},
	{name = "NCR MP Helmet", 			tier = "U", dt = 2, price = 200, bg = 2, skin = 1, Type = "Helmet", model = "models/lazarusroleplay/headgear/factions/ncr/~_hats01.mdl", maleonly = true},
	{name = "NCR MP Goggles Helmet",	tier = "U", dt = 2, price = 250, bg = 1, skin = 1, Type = "Helmet", model = "models/lazarusroleplay/headgear/factions/ncr/~_hats01.mdl", maleonly = true},
	{name = "NCR Goggles", 				tier = "U", dt = 0, price = 50, bg = 1, Type = "Glasses", model = "models/lazarusroleplay/headgear/factions/ncr/~_hats01.mdl", maleonly = true},

	{name = "Legate Helmet", 					tier = "U", price = 2000, dt = 6, bg = 10, Type = "Fullhat", model = "models/lazarusroleplay/headgear/factions/legion/~_fullhats01.mdl"},
	{name = "Legion Centurion Helmet", 			tier = "U", price = 1500, dt = 5, bg = 9, Type = "Helmet", model = "models/lazarusroleplay/headgear/factions/legion/~_fullhats01.mdl"},
	{name = "Wolf Hood", 						tier = "U", price = 200, dt = 2, bg = 8, Type = "Fullhat", model = "models/lazarusroleplay/headgear/factions/legion/~_fullhats01.mdl"},
	{name = "Explorer Hood", 					tier = 1,   price = 100,  dt = 1, bg = 7, Type = "Fullhat", model = "models/lazarusroleplay/headgear/factions/legion/~_fullhats01.mdl"},
	{name = "Legion Veteran Decanus Helmet", 	tier = "U", price = 300, dt = 3, bg = 6, Type = "Fullhat", model = "models/lazarusroleplay/headgear/factions/legion/~_fullhats01.mdl"},
	{name = "Legion Prime Decanus Helmet", 		tier = "U", price = 280, dt = 3, bg = 5, Type = "Fullhat", model = "models/lazarusroleplay/headgear/factions/legion/~_fullhats01.mdl"},
	{name = "Legion Recruit Decanus Helmet", 	tier = "U", price = 250, dt = 3, bg = 4, Type = "Fullhat", model = "models/lazarusroleplay/headgear/factions/legion/~_fullhats01.mdl"},
	{name = "Legion Veteran Helmet", 			tier = "U", price = 200, dt = 2, bg = 3, Type = "Fullhat", model = "models/lazarusroleplay/headgear/factions/legion/~_fullhats01.mdl"},
	{name = "Legion Prime Helmet", 				tier = "U", price = 150, dt = 2, bg = 2, Type = "Fullhat", model = "models/lazarusroleplay/headgear/factions/legion/~_fullhats01.mdl"},
	{name = "Legion Recruit Helmet", 			tier = "U", price = 100, dt = 2, bg = 1, Type = "Fullhat", model = "models/lazarusroleplay/headgear/factions/legion/~_fullhats01.mdl"},

	{name = "NCR Officer Hat", 							tier = "U", 	price = 100, 	dt = 0, 	bg = 0, 	Type = "Hat", 		model = "models/thespireroleplay/humans/headgear/ncrhats_~.mdl"},
	{name = "NCR Combat Helmet", 						tier = "U", 	price = 600, 	dt = 5, 	bg = 1, 	Type = "Hat", 		model = "models/thespireroleplay/humans/headgear/ncrhats_~.mdl"},
	{name = "NCR Recon Helmet", 						tier = "U", 	price = 650, 	dt = 5, 	bg = 2, 	Type = "Hat", 		model = "models/thespireroleplay/humans/headgear/ncrhats_~.mdl"},
	{name = "NCR Survivalist Helmet", 					tier = "U", 	price = 1100, 	dt = 7, 	bg = 3, 	Type = "Hat", 		model = "models/thespireroleplay/humans/headgear/ncrhats_~.mdl"},
	{name = "NCR Grunt Helmet", 						tier = "U", 	price = 850, 	dt = 6, 	bg = 4, 	Type = "Fullhat", 	model = "models/thespireroleplay/humans/headgear/ncrhats_~.mdl"},
	{name = "NCR Salvaged Power Armor Helmet (1)", 		tier = "U", 	price = 1650, 	dt = 9, 	bg = 5, 	Type = "Fullhat", 	model = "models/thespireroleplay/humans/headgear/ncrhats_~.mdl"},
	{name = "NCR Salvaged Power Armor Helmet (2)", 		tier = "U", 	price = 1650, 	dt = 9, 	bg = 6, 	Type = "Fullhat", 	model = "models/thespireroleplay/humans/headgear/ncrhats_~.mdl"},
	{name = "NCR Salvaged Power Armor Helmet (3)", 		tier = "U", 	price = 1650, 	dt = 9, 	bg = 7, 	Type = "Fullhat", 	model = "models/thespireroleplay/humans/headgear/ncrhats_~.mdl"},
	{name = "NCR Salvaged Power Armor Helmet (4)", 		tier = "U", 	price = 1650, 	dt = 9, 	bg = 8, 	Type = "Fullhat", 	model = "models/thespireroleplay/humans/headgear/ncrhats_~.mdl"},
	{name = "NCR Salvaged Power Armor Helmet (5)", 		tier = "U", 	price = 1650, 	dt = 9, 	bg = 9, 	Type = "Fullhat", 	model = "models/thespireroleplay/humans/headgear/ncrhats_~.mdl"},
	{name = "NCR Salvaged Power Armor Helmet (6)", 		tier = "U", 	price = 1650, 	dt = 9, 	bg = 10,	Type = "Fullhat", 	model = "models/thespireroleplay/humans/headgear/ncrhats_~.mdl"},
	{name = "NCR Salvaged Power Armor Helmet (7)", 		tier = "U", 	price = 1650, 	dt = 9, 	bg = 11,	Type = "Fullhat", 	model = "models/thespireroleplay/humans/headgear/ncrhats_~.mdl"},
}

codex = codex.."<ul>"

for k, v in pairs(headgear) do
	codex = codex.."<li></b>"..v.name.."<ul>\n"
	codex = codex.."<li><b>Tier: </b>"..v.tier.."</li>\n"
	codex = codex.."<li><b>Category: </b>".."Headgear".."</li>\n"
	codex = codex.."<li><b>Misc Info:</b><ul><li>Type: "..v.Type.."</li><li>Weight: ".."1".."</li>"
	if (v.dt) then
		codex = codex.."<li>DT: "..v.dt.."</li>"
	end
	codex = codex..'</ul></li></ul></ul><br>\n'
end

for _, item in pairs(headgear) do
	local ITEM = {}

	ITEM.name = item.name
	ITEM.uniqueID = item.name
	ITEM.category = "Headgear"
	ITEM.isBag = false
	ITEM.data = {
		Equipped = false
	}
	ITEM.flag = item.tier
	ITEM.ClothesTable = {
		model = {["female"] = string.gsub(item.model, "~", "f"), ["male"] = string.gsub(item.model, "~", "m")},
		Type = item.Type,
		bodygroup = {0, item.bg},
		skin = item.skin or 0
	}
	ITEM.gasmask = item.gasmask or false
	ITEM.dt = item.dt
	ITEM.maleonly = item.maleonly or false
	if (SERVER) then 
		if type(item.tier) == "number" then
			SCHEMA:AddLootcrateItem("clothes", item.name, tonumber(item.tier))
		end
	end

	if (item.allowglasses) then
		ITEM.ClothesTable.usewithglasses = item.allowglasses
	end
	ITEM.model = "models/props_c17/BriefCase001a.mdl"
	math.randomseed(321312213 + _)
	ITEM.usesound = "fosounds/fix/ui_items_clothing_up_0"..math.random(1,3)..".mp3"
	ITEM.takeSound = "fosounds/fix/ui_items_clothing_up_0"..math.random(1,3)..".mp3"
	math.randomseed(321312213 + (_*2))
	ITEM.dropSound = "fosounds/fix/ui_items_clothing_down_0"..math.random(1,3)..".mp3"
	ITEM.price = item.price or math.random(0, 150)
	math.randomseed(os.time())
	ITEM.functions = {}
	ITEM.functions.Wear = {
		run = function(itemTable, client, data)
			if client.character:GetData(itemTable.ClothesTable.Type) then
				return false
			end

			if (itemTable.maleonly) then
				if client:GetGender() == "female" then
					return false
				end
			end
	
			if (SERVER) then
				local CanPushUpdate = true

				if type(SCHEMA.ClothesTable[client]) == "table" then
					for k, v in pairs(SCHEMA.ClothesTable[client]) do
						if (v.blockothers) then
							CanPushUpdate = false
						end
						if (v.Type == "Fullhat") then
							CanPushUpdate = false
						end
						if (itemTable.ClothesTable.Type == "Glasses" and v.Type == "Mask") then
							if (!v.usewithglasses) then
								CanPushUpdate = false 
							end
						end
						if (itemTable.ClothesTable.Type == "Fullhat") then
							if (v.Type == "Mask" or v.Type == "Glasses") then
								if (!itemTable.ClothesTable.usewithglasses) then
									CanPushUpdate = false
								end
							end
						end

						if (itemTable.ClothesTable.Type == "Mask") then
							if (!itemTable.ClothesTable.usewithglasses) then
								if (v.Type == "Glasses") then
									CanPushUpdate = false
								end
							end
						end
					end
				end

				if (CanPushUpdate) then
					SCHEMA:PushClothesUpdate(client, itemTable.ClothesTable)
					
					if (itemTable.ClothesTable.Type == "Hat" or itemTable.ClothesTable.Type == "Helmet" or itemTable.ClothesTable.Type == "Fullhat") then
						if (client:GetGender() == "female") then
							client:SetBodygroup(2, 10)
						else
							client:SetBodygroup(2, 4)
						end
					end

					client.character:SetData(itemTable.ClothesTable.Type, itemTable.uniqueID)
		
					local newData = table.Copy(data)
					newData.Equipped = true
		
					client:UpdateInv(itemTable.uniqueID, 1, newData, true)
					hook.Run("OnClothEquipped", client, itemTable, true)
					client:SendSound(itemTable.usesound)
				else
					return false
				end
			end
		end,
		shouldDisplay = function(itemTable, data, entity)
			return !data.Equipped or data.Equipped == nil
		end
	}
	ITEM.functions.TakeOff = {
		text = "Take Off",
		run = function(itemTable, client, data)
			if (SERVER) then
	
				client.character:SetData(itemTable.ClothesTable.Type, nil, nil, true)
	
				SCHEMA:PushClothesRemoveUpdate(client, itemTable.ClothesTable)				
				client:SetBodygroup(2, client.character:GetData("hair"))

				if type(SCHEMA.ClothesTable[client]) == "table" then
					for k, v in pairs(SCHEMA.ClothesTable[client]) do
						if (v.Type == "Hat" or v.Type == "Helmet" or v.Type == "Fullhat") then
							if (client:GetGender() == "female") then
								client:SetBodygroup(2, 10)
							else
								client:SetBodygroup(2, 4)
							end
						end
					end
				end

				local newData = table.Copy(data)
				newData.Equipped = false
	
				client:UpdateInv(itemTable.uniqueID, 1, newData, true)
				hook.Run("OnClothEquipped", client, itemTable, false)
	
				if itemTable.ClothesTable.Type == "Suit" then
					--print(itemTable.ClothesTable.Type)
					SCHEMA:PushClothesUpdate(client, "default")
				end
	
				return true
			end
		end,
		shouldDisplay = function(itemTable, data, entity)
			return data.Equipped
		end
	}
	
	local size = 16
	local border = 4
	local distance = size + border
	local tick = Material("icon16/tick.png")
	
	function ITEM:PaintIcon(w, h)
		if (self.data.Equipped) then
			surface.SetDrawColor(0, 0, 0, 50)
			surface.DrawRect(w - distance - 1, w - distance - 1, size + 2, size + 2)
	
			surface.SetDrawColor(255, 255, 255)
			surface.SetMaterial(tick)
			surface.DrawTexturedRect(w - distance, w - distance, size, size)
		end
	end
	
	function ITEM:CanTransfer(client, data)
		if (data.Equipped) then
			nut.util.Notify("You must unequip the item before doing that.", client)
		end
	
		return !data.Equipped
	end
	
	function ITEM:GetDropModel()
		return "models/props_c17/suitCase_passenger_physics.mdl"
	end

	SCHEMA:RegisterItem(ITEM)
end

local chems = {
	{name = "Buffout", model = "models/maxib123/buffout.mdl", price = 80, method = "Swallow", usesound = "fosounds/fix/npc_human_eating_mentats.mp3"},
	{name = "Psycho", model = "models/lazarusroleplay/props/psychochem.mdl", price = 55, method = "Inject", usesound = "fosounds/fix/ui_surgery_morphine_02.mp3"},
	{name = "Jet", model = "models/clutter/jet.mdl", price = 25, method = "Inhale", usesound = "fosounds/fix/npc_human_using_jet.mp3"},
	{name = "Rebound", model = "models/lazarusroleplay/props/psychochem.mdl", price = 60, method = "Inject", usesound = "fosounds/fix/ui_surgery_morphine_02.mp3"},
	{name = "Med-X", model = "models/lazarusroleplay/props/surgicalsyringe01.mdl", price = 20, method = "Inject", usesound = "fosounds/fix/ui_surgery_morphine_02.mp3"},
	{name = "Steady", model = "models/fallout new vegas/sunset.mdl", price = 45, method = "Inhale", usesound = "fosounds/fix/npc_human_using_jet.mp3"},
    {name = "Stimpak", model = "models/lazarusroleplay/props/stimpak.mdl", price = 100, method = "Inject", usesound = "fosounds/fix/ui_surgery_morphine_02.mp3"},
	{name = "Mentats", model = "models/llama/mentants.mdl", price = 50, method = "Swallow", usesound = "fosounds/fix/npc_human_eating_mentats.mp3"},
	{name = "Ant Nectar", model = "models/fallout 3/ant_meat.mdl", price = 25, method = "Eat", usesound = "fosounds/fix/npc_human_eating_food_chewy_01.mp3"},
	{name = "Stealth Boy", model = "models/fallout new vegas/stealth_boy.mdl", price = 200, method = "Turn On", usesound = "fosounds/fix/ui_levelup.mp3"},
    {name = "Peyote Cap", model = "models/props_junk/garbage_bag001a.mdl", price = 5, method = "Inject", usesound = "fosounds/fix/npc_human_eating_food_chewy_01.mp3"},
    {name = "Healing Powder", model = "models/lazarusroleplay/props/healingpowder.mdl", price = 20, method = "Inject", usesound = "fosounds/fix/ui_surgery_morphine_02.mp3"}
}

for k, v in pairs(chems) do
	codex = codex.."<li></b>"..v.name.."<ul>\n"
	codex = codex.."<li><b>Tier: </b>".."m".."</li>\n"
	codex = codex.."<li><b>Category: </b>".."Chems".."</li>\n"
	codex = codex..'</ul></ul><br>\n'
end

for _, item in pairs(chems) do
	local ITEM = {}

	if (item.price) then
		item.price = item.price * nut.config.priceMultiplier
	end

	if (SERVER) then
		SCHEMA:AddLootcrateItem("chems", item.name, 1)
	end

	ITEM.name = item.name
	ITEM.uniqueID = item.name
	ITEM.category = "Chems"
	ITEM.model = item.model
	ITEM.price = item.price
	ITEM.weight = 0.1
	ITEM.flag = "m"
	ITEM.functions = {}
	ITEM.functions.Use = {
		text = item.method,
		run = function(itemTable, client, data)
			if (SERVER) then
				if (client:AdministerChem(item.name)) then
					if (item.name == "Buffout") then
						client:SetHealth(math.Clamp(client:Health() + 55, 0, 150))
					end
	
					if (item.name == "Jet" or item.name == "Rebound") then
						client.character:SetVar("stamina", 100)
					end
	
					client:SendSound(item.usesound)
				else
					return false
				end
			end
		end
	}

	SCHEMA:RegisterItem(ITEM)
end

local food = {
	{name = "Animal Bits", price = 3, heal = 5, weight = 0.1, model = "models/fallout 3/animal_bits.mdl", usesound = "fosounds/fix/npc_human_eating_food_chewy_01.mp3", givebottlecap = false},
	{name = "Ant Meat", price = 5, heal = 10, weight = 0.25, model = "models/fallout 3/ant_meat.mdl", usesound = "fosounds/fix/npc_human_eating_food_crunchy_01.mp3", givebottlecap = false},
	{name = "Fresh Apple", price = 5, heal = 6, weight = 0.1, model = "models/fallout 3/apple_1.mdl", usesound = "fosounds/fix/npc_human_eating_food_crunchy_02.mp3", givebottlecap = false},
	{name = "Pork N Beans", price = 4, heal = 8, weight = 0.2, model = "models/fallout 3/beans.mdl", usesound = "fosounds/fix/npc_human_eating_food_chewy_02.mp3", givebottlecap = false},
	{name = "Fresh Carrot", price = 5, heal = 6, weight = 0.1, model = "models/fallout 3/carrot.mdl", usesound = "fosounds/fix/npc_human_eating_food_crunchy_03.mp3", givebottlecap = false},
	{name = "Potato Chips", price = 3, heal = 5, weight = 0.1, model = "models/fallout 3/chips.mdl", usesound = "fosounds/fix/npc_human_eating_food_crunchy_01.mp3", givebottlecap = false},
	{name = "Cram", price = 5, heal = 5, weight = 0.1, model = "models/fallout 3/cram.mdl", usesound = "fosounds/fix/npc_human_eating_food_chewy_01.mp3", givebottlecap = false},
	{name = "Dandy Boy Apples", price = 6, heal = 8, weight = 0.2, model = "models/fallout 3/dandy_apples.mdl", usesound = "fosounds/fix/npc_human_eating_food_chewy_01.mp3", givebottlecap = false},
	{name = "Bubblegum", price = 2, heal = 1, weight = 0.1, model = "models/fallout 3/gum.mdl", usesound = "fosounds/fix/npc_human_eating_food_chewy_02.mp3", givebottlecap = false},
	{name = "Radioactive Gumdrops", price = 2, heal = 1, weight = 0.1, model = "models/fallout 3/gum_2.mdl", usesound = "fosounds/fix/npc_human_eating_food_chewy_02.mp3", givebottlecap = false},
	{name = "Human Meat", price = 6, heal = 8, weight = 0.2, model = "models/fallout 3/human_meat.mdl", usesound = "fosounds/fix/npc_human_eating_food_chewy_01.mp3", givebottlecap = false},
	{name = "Insta Mash", price = 6, heal = 8, weight = 0.1, model = "models/fallout 3/insta_mash.mdl", usesound = "fosounds/fix/npc_human_eating_food_chewy_02.mp3", givebottlecap = false},
	{name = "Brahmin Meat", price = 10, heal = 9, weight = 0.2, model = "models/fallout 3/meat.mdl", usesound = "fosounds/fix/npc_human_eating_food_chewy_01.mp3", givebottlecap = false},
	{name = "Mole Rat Meat", price = 8, heal = 7, weight = 0.2, model = "models/fallout 3/mole_meat.mdl", usesound = "fosounds/fix/npc_human_eating_food_chewy_02.mp3", givebottlecap = false},
	{name = "Fresh Pear", price = 5, heal = 6, weight = 0.1, model = "models/fallout 3/pear.mdl", usesound = "fosounds/fix/npc_human_eating_food_chewy_01.mp3", givebottlecap = false},
	{name = "Fresh Potato", price = 4, heal = 6, weight = 0.1, model = "models/fallout 3/potato.mdl", usesound = "fosounds/fix/npc_human_eating_food_chewy_01.mp3", givebottlecap = false},
	{name = "Brahmin Steak", price = 15, heal = 12, weight = 0.2, model = "models/fallout 3/steak.mdl", usesound = "fosounds/fix/npc_human_eating_food_chewy_02.mp3", givebottlecap = false},
	{name = "Radroach Meat", price = 6, heal = 5, weight = 0.2, model = "models/fallout 3/radroach_meat.mdl", usesound = "fosounds/fix/npc_human_eating_food_crunchy_01.mp3", givebottlecap = false},
	{name = "Purified Water", price = 15, heal = 10, weight = 0.2, model = "models/fallout 3/water.mdl", usesound = "fosounds/fix/npc_humandrinking_soda_01.mp3", givebottlecap = false},
	{name = "Sunset Sarsaparilla", price = 10, heal = 8, weight = 0.1, model = "models/fallout new vegas/sunset.mdl", usesound = "fosounds/fix/npc_human_drinking_nukacola.mp3", givebottlecap = true},
	{name = "Nuka Cola", price = 18, heal = 12, weight = 0.15, model = "models/maxib123/nukacola.mdl", usesound = "fosounds/fix/npc_human_drinking_nukacola.mp3", givebottlecap = true},
    {name = "Vodka", price = 15, heal = 10, weight = 0.2, model = "models/fallout 3/vodka.mdl", usesound = "fosounds/fix/npc_humandrinking_soda_01.mp3", givebottlecap = false},
	{name = "Dirty Water", price = 5, heal = 2, weight = 0.15, model = "models/fallout 3/water.mdl", usesound = "fosounds/fix/npc_humandrinking_soda_01.mp3", givebottlecap = false},
	{name = "Wine", price = 12, heal = 9, weight = 0.2, model = "models/fallout 3/wine.mdl", usesound = "fosounds/fix/npc_humandrinking_soda_01.mp3", givebottlecap = false},
	{name = "Absinthe", price = 18, heal = 11, weight = 0.2, model = "models/lazarusroleplay/props/absinthebottlefilled.mdl", usesound = "fosounds/fix/npc_humandrinking_soda_01.mp3", givebottlecap = false},
	{name = "Whiskey", price = 15, heal = 10, weight = 0.2, model = "models/fallout 3/water.mdl", usesound = "models/maxib123/whiskey.mdl", givebottlecap = false},
	{name = "Bighorner Meat", price = 25, heal = 15, weight = 1, model = "models/fallout 3/ant_meat.mdl", usesound = "fosounds/fix/npc_human_eating_food_chewy_01.mp3", givebottlecap = false}
}

for k, v in pairs(chems) do
	codex = codex.."<li></b>"..v.name.."<ul>\n"
	codex = codex.."<li><b>Tier: </b>".."1".."</li>\n"
	codex = codex.."<li><b>Category: </b>".."Consumables".."</li>\n"
	codex = codex..'</ul></ul><br>\n'
end

for _, item in pairs(food) do
	local ITEM = {}

	if (item.price) then
		item.price = item.price * nut.config.priceMultiplier
	end

	if (SERVER) then
		SCHEMA:AddLootcrateItem("food", item.name, 1)
	end

	ITEM.name = item.name
	ITEM.uniqueID = item.name
	ITEM.category = "Consumables"
	ITEM.model = item.model
	ITEM.price = item.price
	ITEM.flag = 1
	ITEM.functions = {}
	ITEM.functions.Use = {
		text = item.method,
		run = function(itemTable, client, data)
			if (SERVER) then
				client:SetHealth(math.Clamp(client:Health() + item.heal, 0, 100))
				client:SendSound(item.usesound)

				if (item.givebottlecap) then
					timer.Simple(0.25, function()
						client:SendSound("fosounds/fix/ui_items_bottlecaps_up_0"..math.random(1,4)..".mp3")
						client:GiveMoney(1)
						client:Notify("You have received 1 bottle cap.")
					end)
				end
			end
		end
	}

	SCHEMA:RegisterItem(ITEM)
end

local medical = {
	{name = "Splint", model = "models/fallout new vegas/doctor_bag.mdl", cures = "splint", uses = 1, cost = 10},
	{name = "Bandages", model = "models/props_junk/garbage_newspaper001a.mdl", cures = "bandage", uses = 2, cost = 10},
	{name = "Suture Needle", model = "models/lazarusroleplay/props/surgicalforceps01.mdl", cures = "suture", uses = 1, cost = 50},
	{name = "Burn Cream", model = "models/lazarusroleplay/props/radx.mdl", cures = "burncream", uses = 5, cost = 30},
	{name = "Tweezers", model = "models/lazarusroleplay/props/surgicaltweasers01.mdl", cures = "tweezers", uses = nil, cost = 10},
	{name = "Painkillers", model = "models/lazarusroleplay/props/radx.mdl", cures = "painkillers", uses = 10, cost = 30},
	{name = "Doctors Bag", model = "models/fallout new vegas/doctor_bag.mdl", cures = "docbag", uses = 1, cost = 150}
}

for k, v in pairs(chems) do
	codex = codex.."<li></b>"..v.name.."<ul>\n"
	codex = codex.."<li><b>Tier: </b>".."m".."</li>\n"
	codex = codex.."<li><b>Category: </b>".."Medical Supplies".."</li>\n"
	codex = codex..'</ul></ul><br>\n'
end

for _, item in pairs(medical) do
	local ITEM = {}

	if (item.cost) then
		item.cost = item.cost * nut.config.priceMultiplier
	end

	if (SERVER) then
		SCHEMA:AddLootcrateItem("chems", item.name, 2)
	end

	ITEM.name = item.name or "error"
	ITEM.uniqueID = item.name
	ITEM.category = "Medical"
	ITEM.weight = item.weight or 0.1
	if (item.uses) then
		ITEM.data = {
			uses = item.uses
		}
	end
	ITEM.flag = "m"
	ITEM.cure = item.cures or "splint"
	ITEM.model = item.dropmodel or item.model or "models/props_c17/BriefCase001a.mdl"
	ITEM.price = item.cost or 0
	ITEM.functions = {}
	ITEM.functions.TreatSelf = {
		text = "Heal Yourself",
		run = function(itemTable, client, data)
			if (SERVER) then
				if (client:GetMedicalConditions()) then
					local data = {}
					data.conditions = client:GetMedicalConditions()
					data.cure = itemTable.cure
					data.name = itemTable.name
					data.uniqueID = itemTable.uniqueID
					netstream.Start(client, "nut_SendSelfTreatmentInfo", data)
				end
			end

			return false
		end
	}

	ITEM.functions.TreatForward = {
		text = "Heal Target",
		run = function(itemTable, client, data)
			if (SERVER) then
				local trdata = {}
					trdata.start = client:GetShootPos()
					trdata.endpos = trdata.start + client:GetAimVector()*96
					trdata.filter = client
				local trace = util.TraceLine(trdata)
				local target = trace.Entity

				if (target:GetMedicalConditions()) then
					local data = {}
					data.conditions = target:GetMedicalConditions()
					data.cure = itemTable.cure
					data.name = itemTable.name
					data.uniqueID = itemTable.uniqueID
					netstream.Start(client, "nut_SendTreatmentInfo", data)
				end
			end

			return false
		end,
		shouldDisplay = function(itemTable, data, entity)
			local client = LocalPlayer()
			local trdata = {}
				trdata.start = client:GetShootPos()
				trdata.endpos = trdata.start + client:GetAimVector()*96
				trdata.filter = client
			local trace = util.TraceLine(trdata)
			local target = trace.Entity

			return trace.Hit and target:IsPlayer()
		end
	}

	function ITEM:GetDesc(data)
		local data = data or {business = true}

		--if (data.business) then
		--	return "This is a medical item."
		--end

		--if (data.uses and data.uses != 1) then
		--	return data.uses.." Uses remaining"
		--elseif (data.uses and data.uses == 1) then
			return "This item has a single use remaining"
		--else
		--	return "This item has infinite uses"
		--end
	end

	SCHEMA:RegisterItem(ITEM)
end

local clothes = {
	{name = "Leather Armor, Reinforced", dropsound = "fosounds/fix/ui_items_clothing_down_02.mp3", takesound = "fosounds/fix/ui_items_clothing_up_02.mp3", tier = 2, capacity = 10, dt = 4, reduction = 0.30, isBag = true, price = 640, 
	dropmodel = "models/thespireroleplay/items/clothes/group052.mdl", ct = {model = "models/thespireroleplay/humans/group017/", Type = "Suit"}, weight = 5},

	{name = "Scribe Robes", dropsound = "fosounds/fix/ui_items_clothing_down_03.mp3", takesound = "fosounds/fix/ui_items_clothing_up_02.mp3", tier = "U", capacity = 4, dt = 0, reduction = 0.20, isBag = true, price = 700,
	dropmodel = "models/thespireroleplay/items/clothes/group001.mdl", ct = {model = "models/thespireroleplay/humans/group102/", Type = "Suit"}, weight = 2},

	{name = "Lightweight Leather Armor", dropsound = "fosounds/fix/ui_items_clothing_down_02.mp3", takesound = "fosounds/fix/ui_items_clothing_up_02.mp3", tier = 2, capacity = 10, dt = 2, reduction = 0.25, isBag = true, price = 300, 
	dropmodel = "models/thespireroleplay/items/clothes/group052.mdl", ct = {model = "models/thespireroleplay/humans/group112/", Type = "Suit"}, weight = 3, maleonly = true},

	{name = "T-45d Power Armor", dropsound = "fosounds/fix/ui_items_clothing_down_03.mp3", takesound = "fosounds/fix/ui_items_clothing_up_03.mp3", tier = "U", capacity = 20, dt = 24, reduction = 0.70, isBag = true, price = 8150, 
	dropmodel = "models/thespireroleplay/items/clothes/group056.mdl", ct = {model = "models/thespireroleplay/humans/group056/", Type = "Suit"}, weight = 8}, 

	{name = "T-45d Tribal Power Armor", dropsound = "fosounds/fix/ui_items_clothing_down_03.mp3", takesound = "fosounds/fix/ui_items_clothing_up_03.mp3", tier = "U", capacity = 20, dt = 18, reduction = 0.60, isBag = true, price = 7150, 
	dropmodel = "models/thespireroleplay/items/clothes/group056.mdl", ct = {model = "models/lazarusroleplay/thespireroleplay/humans/group114/", Type = "Suit"}, weight = 8}, 

	{name = "Recon Armor", dropsound = "fosounds/fix/ui_items_clothing_down_03.mp3", takesound = "fosounds/fix/ui_items_clothing_up_03.mp3", tier = "U", capacity = 20, dt = 8, reduction = 0.50, isBag = true, price = 1450, 
	dropmodel = "models/thespireroleplay/items/clothes/group056.mdl", ct = {model = {male = "models/thespireroleplay/humans/group113/male.mdl", female = "models/thespireroleplay/humans/group113/female.mdl", armdir = "models/thespireroleplay/humans/group056/arms/"}, Type = "Suit"}, weight = 8}, 

	{name = "MP-47/A Prototype Medic Power Armor", dropsound = "fosounds/fix/ui_items_clothing_down_03.mp3", takesound = "fosounds/fix/ui_items_clothing_up_03.mp3", tier = "U", capacity = 20, dt = 16, medicsuit = true, voiceset = "gutsy", reduction = 0.70, isBag = true, price = 12500, 
	dropmodel = "models/thespireroleplay/items/clothes/group056.mdl", ct = {model = "models/thespireroleplay/humans/group056/", Type = "Suit"}, weight = 8}, 

	{name = "MP-47/B Prototype Medic Power Armor", dropsound = "fosounds/fix/ui_items_clothing_down_03.mp3", takesound = "fosounds/fix/ui_items_clothing_up_03.mp3", tier = "U", capacity = 20, dt = 16, medicsuit = true, voiceset = "stealthsuit", reduction = 0.70, isBag = true, price = 15500, 
	dropmodel = "models/thespireroleplay/items/clothes/group056.mdl", ct = {model = "models/thespireroleplay/humans/group056/", Type = "Suit"}, weight = 8}, 

	{name = "NCR Salvaged Power Armor", dropsound = "fosounds/fix/ui_items_clothing_down_02.mp3", takesound = "fosounds/fix/ui_items_clothing_up_02.mp3", tier = "U", capacity = 12, dt = 14, reduction = 0.65, isBag = true, price = 6150, 
	dropmodel = "models/thespireroleplay/items/clothes/group056.mdl", ct = {model = "models/thespireroleplay/humans/group111/", Type = "Suit"}, weight = 8}, 

	{name = "Salvaged Power Armor", dropsound = "fosounds/fix/ui_items_clothing_down_02.mp3", takesound = "fosounds/fix/ui_items_clothing_up_02.mp3", tier = "U", capacity = 12, dt = 14, reduction = 0.65, isBag = true, price = 6000, 
	dropmodel = "models/thespireroleplay/items/clothes/group056.mdl", ct = {model = "models/thespireroleplay/humans/group111/", Type = "Suit", skin = 8}, weight = 8},

	{name = "Salvaged MP-47/A Power Armor", dropsound = "fosounds/fix/ui_items_clothing_down_02.mp3", takesound = "fosounds/fix/ui_items_clothing_up_02.mp3", tier = "U", capacity = 12, dt = 16, medicsuit = true, voiceset = "gutsy", reduction = 0.60, isBag = true, price = 8250, 
	dropmodel = "models/thespireroleplay/items/clothes/group056.mdl", ct = {model = "models/thespireroleplay/humans/group111/", Type = "Suit", skin = 8}, weight = 8},

	{name = "Salvaged MP-47/B Power Armor", dropsound = "fosounds/fix/ui_items_clothing_down_02.mp3", takesound = "fosounds/fix/ui_items_clothing_up_02.mp3", tier = "U", capacity = 12, dt = 16, medicsuit = true, voiceset = "stealthsuit", reduction = 0.60, isBag = true, price = 10500, 
	dropmodel = "models/thespireroleplay/items/clothes/group056.mdl", ct = {model = "models/thespireroleplay/humans/group111/", Type = "Suit", skin = 8}, weight = 8},

	{name = "Legion Veteran Armor", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = "U", capacity = 8, dt = 5, reduction = 0.35, isBag = true, price = 850, 
	dropmodel = "models/thespireroleplay/items/clothes/group057.mdl", ct = {model = "models/thespireroleplay/humans/group110/", Type = "Suit"}, weight = 3.5},

	{name = "Legion Recruit Armor", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = "L", capacity = 6, dt = 3, reduction = 0.25, isBag = true, price = 450, 
	dropmodel = "models/thespireroleplay/items/clothes/group057.mdl", ct = {model = "models/thespireroleplay/humans/group109/", Type = "Suit"}, weight = 4},

	{name = "Legion Prime Armor", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = "U", capacity = 6, dt = 4, reduction = 0.35, isBag = true, price = 650, 
	dropmodel = "models/thespireroleplay/items/clothes/group057.mdl", ct = {model = "models/thespireroleplay/humans/group057/", Type = "Suit"}, weight = 6},
	
	{name = "Legion Praetorian Armor", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = "U", capacity = 8, dt = 6, reduction = 0.4, isBag = true, price = 1050, 
	dropmodel = "models/thespireroleplay/items/clothes/group057.mdl", ct = {model = "models/thespireroleplay/humans/group108/", Type = "Suit"}, weight = 1},

	{name = "Legate Armor", dropsound = "fosounds/fix/ui_items_clothing_down_03.mp3", takesound = "fosounds/fix/ui_items_clothing_up_03.mp3", tier = "U", capacity = 20, dt = 10, reduction = 0.65, isBag = true, price = 5000, 
	dropmodel = "models/thespireroleplay/items/clothes/group107.mdl", ct = {model = "models/thespireroleplay/humans/group107/", Type = "Suit"}, weight = 6, maleonly = true},

	{name = "Legion Centurion Armor", dropsound = "fosounds/fix/ui_items_clothing_down_02.mp3", takesound = "fosounds/fix/ui_items_clothing_up_02.mp3", tier = "U", capacity = 12, dt = 10, reduction = 0.60, isBag = true, price = 4000, 
	dropmodel = "models/thespireroleplay/items/clothes/group106.mdl", ct = {model = "models/thespireroleplay/humans/group106/", Type = "Suit"}, weight = 6},

	{name = "Caesars Armor", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = "U", capacity = 5, dt = 5, reduction = 0.50, isBag = true, price = 3000, 
	dropmodel = "models/thespireroleplay/items/clothes/group105.mdl", ct = {model = "models/thespireroleplay/humans/group105/", Type = "Suit"}, weight = 4, maleonly = true},

	{name = "Roving Trader Outfit", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = 1, capacity = 15, dt = 0, reduction = 0.10, isBag = true, price = 50, 
	dropmodel = "models/thespireroleplay/items/clothes/group104.mdl", ct = {model = "models/thespireroleplay/humans/group104/", Type = "Suit"}, weight = 1},

	{name = "Rancher Outfit", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = 1, capacity = 5, dt = 0, reduction = 0.10, isBag = true, price = 40, 
	dropmodel = "models/thespireroleplay/items/clothes/group103.mdl", ct = {model = "models/thespireroleplay/humans/group103/", Type = "Suit"}, weight = 2},

	{name = "Elder Robes", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = "U", capacity = 20, dt = 0, reduction = 0.20, isBag = true, price = 500, 
	dropmodel = "models/thespireroleplay/items/clothes/group102.mdl", ct = {model = "models/thespireroleplay/humans/group102/", Type = "Suit", skin = 1}, weight = 3},

	{name = "Wastelander Robes", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = 1, capacity = 5, dt = 0, reduction = 0.15, isBag = true, price = 50, 
	dropmodel = "models/thespireroleplay/items/clothes/group102.mdl", ct = {model = "models/thespireroleplay/humans/group102/", Type = "Suit", skin = 2}, weight = 1},

	{name = "Memphis Kid Outfit (1)", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = 1, capacity = 5, dt = 0, reduction = 0.10, isBag = true, price = 20, 
	dropmodel = "models/thespireroleplay/items/clothes/group101.mdl", ct = {model = "models/thespireroleplay/humans/group101/", Type = "Suit"}, weight = 1},

	{name = "Memphis Kid Outfit (2)", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = 1, capacity = 5, dt = 0, reduction = 0.10, isBag = true, price = 20, 
	dropmodel = "models/thespireroleplay/items/clothes/group101.mdl", ct = {model = "models/thespireroleplay/humans/group101/", Type = "Suit", skin = 1}, weight = 1},

	{name = "Memphis Kid Outfit (3)", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = 1, capacity = 5, dt = 0, reduction = 0.10, isBag = true, price = 20, 
	dropmodel = "models/thespireroleplay/items/clothes/group101.mdl", ct = {model = "models/thespireroleplay/humans/group101/", Type = "Suit", skin = 2}, weight = 1},

	{name = "Memphis Kid Outfit (4)", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = 1, capacity = 5, dt = 0, reduction = 0.10, isBag = true, price = 20, 
	dropmodel = "models/thespireroleplay/items/clothes/group101.mdl", ct = {model = "models/thespireroleplay/humans/group101/", Type = "Suit", skin = 3}, weight = 1},

	{name = "Merc Adventurer Outfit", dropsound = "fosounds/fix/ui_items_clothing_down_02.mp3", takesound = "fosounds/fix/ui_items_clothing_up_02.mp3", tier = 2, capacity = 5, dt = 2, reduction = 0.15, isBag = true, price = 180, 
	dropmodel = "models/thespireroleplay/items/clothes/group061.mdl", ct = {model = "models/thespireroleplay/humans/group061/", Type = "Suit"}, weight = 1},

	{name = "Lightweight Merc Adventurer Outfit", dropsound = "fosounds/fix/ui_items_clothing_down_02.mp3", takesound = "fosounds/fix/ui_items_clothing_up_02.mp3", tier = 1, capacity = 10, dt = 1, reduction = 0.25, isBag = true, price = 90, 
	dropmodel = "models/thespireroleplay/items/clothes/group061.mdl", ct = {model = "models/thespireroleplay/humans/group061/", Type = "Suit", bodygroup = {1, 1}}, weight = 2},

	{name = "Merc Veteran Outfit", dropsound = "fosounds/fix/ui_items_clothing_down_02.mp3", takesound = "fosounds/fix/ui_items_clothing_up_02.mp3", tier = 2, capacity = 8, dt = 3, reduction = 0.30, isBag = true, price = 380, 
	dropmodel = "models/thespireroleplay/items/clothes/group060.mdl", ct = {model = "models/thespireroleplay/humans/group060/", Type = "Suit"}, weight = 3},

	{name = "Wasteland Legend Outfit", dropsound = "fosounds/fix/ui_items_clothing_down_02.mp3", takesound = "fosounds/fix/ui_items_clothing_up_02.mp3", tier = "U", capacity = 15, dt = 3, reduction = 0.20, isBag = true, price = 400, 
	dropmodel = "models/thespireroleplay/items/clothes/group060.mdl", ct = {model = "models/thespireroleplay/humans/group060/", Type = "Suit", bodygroup = {1, 1}}, weight = 1},

	{name = "Pre-War Casualwear", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = 1, capacity = 6, dt = 0, reduction = 0.10, isBag = true, price = 40, 
	dropmodel = "models/thespireroleplay/items/clothes/group059.mdl", ct = {model = "models/thespireroleplay/humans/group059/", Type = "Suit"}, weight = 1},

	{name = "Pre-War Relaxedwear", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = 1, capacity = 6, dt = 0, reduction = 0.10, isBag = true, price = 40, 
	dropmodel = "models/thespireroleplay/items/clothes/group059.mdl", ct = {model = "models/thespireroleplay/humans/group059/", Type = "Suit", skin = 1}, weight = 1},

	{name = "Farm Hand Outfit (1)", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = 1, capacity = 2, dt = 0, reduction = 0.10, isBag = true, price = 15, 
	dropmodel = "models/thespireroleplay/items/clothes/group058.mdl", ct = {model = "models/thespireroleplay/humans/group058/", Type = "Suit"}, weight = 1},

	{name = "Farm Hand Outfit (2)", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = 1, capacity = 2, dt = 0, reduction = 0.10, isBag = true, price = 15, 
	dropmodel = "models/thespireroleplay/items/clothes/group058.mdl", ct = {model = "models/thespireroleplay/humans/group058/", Type = "Suit", skin = 1}, weight = 1},

	{name = "Farm Hand Outfit (3)", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = 1, capacity = 2, dt = 0, reduction = 0.10, isBag = true, price = 15, 
	dropmodel = "models/thespireroleplay/items/clothes/group058.mdl", ct = {model = "models/thespireroleplay/humans/group058/", Type = "Suit", skin = 2}, weight = 1},

	{name = "Farm Hand Outfit (4)", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = 1, capacity = 2, dt = 0, reduction = 0.10, isBag = true, price = 15, 
	dropmodel = "models/thespireroleplay/items/clothes/group058.mdl", ct = {model = "models/thespireroleplay/humans/group058/", Type = "Suit", skin = 3}, weight = 1},

	{name = "Farm Hand Outfit (5)", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = 1, capacity = 2, dt = 0, reduction = 0.10, isBag = true, price = 15, 
	dropmodel = "models/thespireroleplay/items/clothes/group058.mdl", ct = {model = "models/thespireroleplay/humans/group058/", Type = "Suit", skin = 4}, weight = 1},

	{name = "Farm Hand Outfit (6)", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = 1, capacity = 2, dt = 0, dt = 0, reduction = 0.10, isBag = true, price = 15, 
	dropmodel = "models/thespireroleplay/items/clothes/group058.mdl", ct = {model = "models/thespireroleplay/humans/group058/", Type = "Suit", skin = 5}, weight = 1},

	{name = "Farm Hand Outfit (7)", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = 1, capacity = 2, dt = 0, reduction = 0.10, isBag = true, price = 15, 
	dropmodel = "models/thespireroleplay/items/clothes/group058.mdl", ct = {model = "models/thespireroleplay/humans/group058/", Type = "Suit", skin = 6}, weight = 1},

	{name = "Farm Hand Outfit (8)", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = 1, capacity = 2, dt = 0, reduction = 0.10, isBag = true, price = 15, 
	dropmodel = "models/thespireroleplay/items/clothes/group058.mdl", ct = {model = "models/thespireroleplay/humans/group058/", Type = "Suit", skin = 7}, weight = 1},

	{name = "Farm Hand Outfit (9)", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = 1, capacity = 2, dt = 0, reduction = 0.10, isBag = true, price = 15, 
	dropmodel = "models/thespireroleplay/items/clothes/group058.mdl", ct = {model = "models/thespireroleplay/humans/group058/", Type = "Suit", skin = 8}, weight = 1},

	{name = "Farm Hand Outfit (10)", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = 1, capacity = 2, dt = 0, reduction = 0.10, isBag = true, price = 15, 
	dropmodel = "models/thespireroleplay/items/clothes/group058.mdl", ct = {model = "models/thespireroleplay/humans/group058/", Type = "Suit", skin = 9}, weight = 1},

	{name = "Farm Hand Outfit (11)", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = 1, capacity = 2, dt = 0, reduction = 0.10, isBag = true, price = 15, 
	dropmodel = "models/thespireroleplay/items/clothes/group058.mdl", ct = {model = "models/thespireroleplay/humans/group058/", Type = "Suit", skin = 10}, weight = 1},

	{name = "Farm Hand Outfit (12)", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = 1, capacity = 2, dt = 0, reduction = 0.10, isBag = true, price = 15, 
	dropmodel = "models/thespireroleplay/items/clothes/group058.mdl", ct = {model = "models/thespireroleplay/humans/group058/", Type = "Suit", skin = 11}, weight = 1},

	{name = "Farm Hand Outfit (13)", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = 1, capacity = 2, dt = 0, reduction = 0.10, isBag = true, price = 15, 
	dropmodel = "models/thespireroleplay/items/clothes/group058.mdl", ct = {model = "models/thespireroleplay/humans/group058/", Type = "Suit", skin = 12}, weight = 1},

	{name = "Farm Hand Outfit (14)", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = 1, capacity = 2, dt = 0, reduction = 0.10, isBag = true, price = 15, 
	dropmodel = "models/thespireroleplay/items/clothes/group058.mdl", ct = {model = "models/thespireroleplay/humans/group058/", Type = "Suit", skin = 13}, weight = 1},

	{name = "NCR Trooper Uniform", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = 5, capacity = 12, dt = 5, reduction = 0.35, isBag = true, price = 550, 
	dropmodel = "models/thespireroleplay/items/clothes/group055.mdl", ct = {model = "models/thespireroleplay/humans/group055/", Type = "Suit"}, weight = 3},

	{name = "NCR Ranger Outfit", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = "U", capacity = 10, dt = 7, reduction = 0.55, isBag = true, price = 1750, 
	dropmodel = "models/thespireroleplay/items/clothes/group054.mdl", ct = {model = "models/thespireroleplay/humans/group054/", Type = "Suit"}, weight = 4},

	{name = "Combat Armor, Reinforced (1)", dropsound = "fosounds/fix/ui_items_clothing_down_02.mp3", takesound = "fosounds/fix/ui_items_clothing_up_02.mp3", tier = "U", capacity = 12, dt = 7, reduction = 0.55, isBag = true, price = 1500, 
	dropmodel = "models/thespireroleplay/items/clothes/group053.mdl", ct = {model = "models/thespireroleplay/humans/group053/", Type = "Suit"}, weight = 6},

	{name = "Combat Armor, Reinforced (2)", dropsound = "fosounds/fix/ui_items_clothing_down_02.mp3", takesound = "fosounds/fix/ui_items_clothing_up_02.mp3", tier = "U", capacity = 12, dt = 7, reduction = 0.55, isBag = true, price = 1500, 
	dropmodel = "models/thespireroleplay/items/clothes/group053.mdl", ct = {model = "models/thespireroleplay/humans/group053/", Type = "Suit", skin = 1}, weight = 6},

	{name = "Combat Armor, Reinforced (3)", dropsound = "fosounds/fix/ui_items_clothing_down_02.mp3", takesound = "fosounds/fix/ui_items_clothing_up_02.mp3", tier = "U", capacity = 12, dt = 7, reduction = 0.55, isBag = true, price = 1500, 
	dropmodel = "models/thespireroleplay/items/clothes/group053.mdl", ct = {model = "models/thespireroleplay/humans/group053/", Type = "Suit", skin = 2}, weight = 6},

	{name = "Combat Armor, Reinforced (4)", dropsound = "fosounds/fix/ui_items_clothing_down_02.mp3", takesound = "fosounds/fix/ui_items_clothing_up_02.mp3", tier = "U", capacity = 12, dt = 7, reduction = 0.55, isBag = true, price = 1500, 
	dropmodel = "models/thespireroleplay/items/clothes/group053.mdl", ct = {model = "models/thespireroleplay/humans/group053/", Type = "Suit", skin = 3}, weight = 6},

	{name = "Leather Armor", dropsound = "fosounds/fix/ui_items_clothing_down_02.mp3", takesound = "fosounds/fix/ui_items_clothing_up_02.mp3", tier = 1, capacity = 6, dt = 3, reduction = 0.25, isBag = true, price = 440, 
	dropmodel = "models/thespireroleplay/items/clothes/group052.mdl", ct = {model = "models/thespireroleplay/humans/group052/", Type = "Suit"}, weight = 3},

	{name = "Kings Jacket", dropsound = "fosounds/fix/ui_items_clothing_down_02.mp3", takesound = "fosounds/fix/ui_items_clothing_up_02.mp3", tier = 5, capacity = 6, dt = 0, reduction = 0.1, isBag = true, price = 40, 
	dropmodel = "models/thespireroleplay/items/clothes/group051.mdl", ct = {model = "models/thespireroleplay/humans/group051/", Type = "Suit"}, weight = 2},

	{name = "Leather Jacket", dropsound = "fosounds/fix/ui_items_clothing_down_02.mp3", takesound = "fosounds/fix/ui_items_clothing_up_02.mp3", tier = 1, capacity = 2, dt = 0, reduction = 0.15, isBag = true, price = 40, 
	dropmodel = "models/thespireroleplay/items/clothes/group051.mdl", ct = {model = "models/thespireroleplay/humans/group051/", Type = "Suit", skin = 1}, weight = 1},

	{name = "Merc Troublemaker Outfit", dropsound = "fosounds/fix/ui_items_clothing_down_02.mp3", takesound = "fosounds/fix/ui_items_clothing_up_02.mp3", tier = 1, capacity = 6, dt = 2, reduction = 0.25, isBag = true, price = 180, 
	dropmodel = "models/thespireroleplay/items/clothes/group021.mdl", ct = {model = "models/thespireroleplay/humans/group021/", Type = "Suit"}, weight = 1},

	{name = "Merc Grunt Outfit", dropsound = "fosounds/fix/ui_items_clothing_down_02.mp3", takesound = "fosounds/fix/ui_items_clothing_up_02.mp3", tier = 1, capacity = 4, dt = 1, reduction = 0.20, isBag = true, price = 90, 
	dropmodel = "models/thespireroleplay/items/clothes/group020.mdl", ct = {model = "models/thespireroleplay/humans/group020/", Type = "Suit"}, weight = 1},

	{name = "Wasteland Doctor Fatigues", dropsound = "fosounds/fix/ui_items_clothing_down_02.mp3", takesound = "fosounds/fix/ui_items_clothing_up_02.mp3", tier = 1, capacity = 4, dt = 0, reduction = 0.1, isBag = true, price = 25, 
	dropmodel = "models/thespireroleplay/items/clothes/group020.mdl", ct = {model = "models/thespireroleplay/humans/group020/", Type = "Suit", skin = 1}, weight = 1},

	{name = "Wasteland Surgeon Outfit", dropsound = "fosounds/fix/ui_items_clothing_down_02.mp3", takesound = "fosounds/fix/ui_items_clothing_up_02.mp3", tier = 1, capacity = 4, dt = 0, reduction = 0.25, isBag = true, price = 40, 
	dropmodel = "models/thespireroleplay/items/clothes/group020.mdl", ct = {model = "models/thespireroleplay/humans/group020/", Type = "Suit", skin = 2}, weight = 1},

	{name = "Merc Elite Outfit", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = 3, capacity = 6, dt = 3, reduction = 0.30, isBag = true, price = 580, 
	dropmodel = "models/thespireroleplay/items/clothes/group016.mdl", ct = {model = "models/thespireroleplay/humans/group016/", Type = "Suit"}, weight = 2},

	{name = "Wasteland Wanderer Outfit (2)", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = 1, capacity = 6, dt = 0, reduction = 0.05, isBag = true, price = 10, 
	dropmodel = "models/thespireroleplay/items/clothes/group015.mdl", ct = {model = "models/thespireroleplay/humans/group015/", Type = "Suit"}, weight = 1},

	{name = "Gambler Suit (1)", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = 1, capacity = 4, dt = 0, reduction = 0.10, isBag = true, price = 20, 
	dropmodel = "models/thespireroleplay/items/clothes/group014.mdl", ct = {model = "models/thespireroleplay/humans/group014/", Type = "Suit"}, weight = 2},

	{name = "Gambler Suit (2)", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = 1, capacity = 4, dt = 0, reduction = 0.10, isBag = true, price = 20, 
	dropmodel = "models/thespireroleplay/items/clothes/group014.mdl", ct = {model = "models/thespireroleplay/humans/group014/", Type = "Suit", skin = 1}, weight = 2},

	{name = "Gambler Suit (3)", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = 1, capacity = 4, dt = 0, reduction = 0.10, isBag = true, price = 20, 
	dropmodel = "models/thespireroleplay/items/clothes/group014.mdl", ct = {model = "models/thespireroleplay/humans/group014/", Type = "Suit", skin = 2}, weight = 2},

	{name = "Gambler Suit (4)", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = 1, capacity = 4, dt = 0, reduction = 0.10, isBag = true, price = 20, 
	dropmodel = "models/thespireroleplay/items/clothes/group014.mdl", ct = {model = "models/thespireroleplay/humans/group014/", Type = "Suit", skin = 3}, weight = 2},

	{name = "Gambler Suit (5)", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = 1, capacity = 4, dt = 0, reduction = 0.10, isBag = true, price = 20, 
	dropmodel = "models/thespireroleplay/items/clothes/group014.mdl", ct = {model = "models/thespireroleplay/humans/group014/", Type = "Suit", skin = 4}, weight = 2},

	{name = "Gambler Suit (6)", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = 1, capacity = 4, dt = 0, reduction = 0.10, isBag = true, price = 20, 
	dropmodel = "models/thespireroleplay/items/clothes/group014.mdl", ct = {model = "models/thespireroleplay/humans/group014/", Type = "Suit", skin = 5}, weight = 2},

	{name = "Ranch Hand Outfit (1)", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = 1, capacity = 3, dt = 0, reduction = 0.10, isBag = true, price = 15, 
	dropmodel = "models/thespireroleplay/items/clothes/group013.mdl", ct = {model = "models/thespireroleplay/humans/group013/", Type = "Suit"}, weight = 1},

	{name = "Ranch Hand Outfit (2)", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = 1, capacity = 3, dt = 0, reduction = 0.10, isBag = true, price = 15, 
	dropmodel = "models/thespireroleplay/items/clothes/group013.mdl", ct = {model = "models/thespireroleplay/humans/group013/", Type = "Suit", skin = 1}, weight = 1},

	{name = "Ranch Hand Outfit (3)", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = 1, capacity = 3, dt = 0, reduction = 0.10, isBag = true, price = 15, 
	dropmodel = "models/thespireroleplay/items/clothes/group013.mdl", ct = {model = "models/thespireroleplay/humans/group013/", Type = "Suit", skin = 2}, weight = 1},

	{name = "Combat Armor (1)", dropsound = "fosounds/fix/ui_items_clothing_down_02.mp3", takesound = "fosounds/fix/ui_items_clothing_up_02.mp3", tier = 4, capacity = 12, dt = 6, reduction = 0.50, isBag = true, price = 1000, 
	dropmodel = "models/thespireroleplay/items/clothes/group012.mdl", ct = {model = "models/thespireroleplay/humans/group012/", Type = "Suit"}, weight = 6},

	{name = "Combat Armor (2)", dropsound = "fosounds/fix/ui_items_clothing_down_02.mp3", takesound = "fosounds/fix/ui_items_clothing_up_02.mp3", tier = 4, capacity = 12, dt = 6, reduction = 0.50, isBag = true, price = 1000, 
	dropmodel = "models/thespireroleplay/items/clothes/group012.mdl", ct = {model = "models/thespireroleplay/humans/group012/", Type = "Suit", skin = 1}, weight = 6},

	{name = "Combat Armor (3)", dropsound = "fosounds/fix/ui_items_clothing_down_02.mp3", takesound = "fosounds/fix/ui_items_clothing_up_02.mp3", tier = 4, capacity = 12, dt = 6, reduction = 0.50, isBag = true, price = 1000, 
	dropmodel = "models/thespireroleplay/items/clothes/group012.mdl", ct = {model = "models/thespireroleplay/humans/group012/", Type = "Suit", skin = 2}, weight = 6},

	{name = "Combat Armor (4)", dropsound = "fosounds/fix/ui_items_clothing_down_02.mp3", takesound = "fosounds/fix/ui_items_clothing_up_02.mp3", tier = 4, capacity = 12, dt = 6, reduction = 0.50, isBag = true, price = 1000, 
	dropmodel = "models/thespireroleplay/items/clothes/group012.mdl", ct = {model = "models/thespireroleplay/humans/group012/", Type = "Suit", skin = 3}, weight = 6},

	{name = "Combat Armor (5)", dropsound = "fosounds/fix/ui_items_clothing_down_02.mp3", takesound = "fosounds/fix/ui_items_clothing_up_02.mp3", tier = 4, capacity = 12, dt = 6, reduction = 0.50, isBag = true, price = 1000, 
	dropmodel = "models/thespireroleplay/items/clothes/group012.mdl", ct = {model = "models/thespireroleplay/humans/group012/", Type = "Suit", skin = 4}, weight = 6},

	{name = "Combat Armor (6)", dropsound = "fosounds/fix/ui_items_clothing_down_02.mp3", takesound = "fosounds/fix/ui_items_clothing_up_02.mp3", tier = 4, capacity = 12, dt = 6, reduction = 0.50, isBag = true, price = 1000, 
	dropmodel = "models/thespireroleplay/items/clothes/group012.mdl", ct = {model = "models/thespireroleplay/humans/group012/", Type = "Suit", skin = 5}, weight = 6},

	{name = "Combat Armor (7)", dropsound = "fosounds/fix/ui_items_clothing_down_02.mp3", takesound = "fosounds/fix/ui_items_clothing_up_02.mp3", tier = 4, capacity = 12, dt = 6, reduction = 0.50, isBag = true, price = 1000, 
	dropmodel = "models/thespireroleplay/items/clothes/group012.mdl", ct = {model = "models/thespireroleplay/humans/group012/", Type = "Suit", skin = 6}, weight = 6},

	{name = "Combat Armor (8)", dropsound = "fosounds/fix/ui_items_clothing_down_02.mp3", takesound = "fosounds/fix/ui_items_clothing_up_02.mp3", tier = 4, capacity = 12, dt = 6, reduction = 0.50, isBag = true, price = 1000, 
	dropmodel = "models/thespireroleplay/items/clothes/group012.mdl", ct = {model = "models/thespireroleplay/humans/group012/", Type = "Suit", skin = 7}, weight = 6},

	{name = "Combat Armor (9)", dropsound = "fosounds/fix/ui_items_clothing_down_02.mp3", takesound = "fosounds/fix/ui_items_clothing_up_02.mp3", tier = 4, capacity = 12, dt = 6, reduction = 0.50, isBag = true, price = 1000, 
	dropmodel = "models/thespireroleplay/items/clothes/group012.mdl", ct = {model = "models/thespireroleplay/humans/group012/", Type = "Suit", skin = 8}, weight = 6},

	{name = "Combat Armor (10)", dropsound = "fosounds/fix/ui_items_clothing_down_02.mp3", takesound = "fosounds/fix/ui_items_clothing_up_02.mp3", tier = 4, capacity = 12, dt = 6, reduction = 0.50, isBag = true, price = 1000, 
	dropmodel = "models/thespireroleplay/items/clothes/group012.mdl", ct = {model = "models/thespireroleplay/humans/group012/", Type = "Suit", skin = 9}, weight = 6},

	{name = "Combat Armor (11)", dropsound = "fosounds/fix/ui_items_clothing_down_02.mp3", takesound = "fosounds/fix/ui_items_clothing_up_02.mp3", tier = 4, capacity = 12, dt = 6, reduction = 0.50, isBag = true, price = 1000, 
	dropmodel = "models/thespireroleplay/items/clothes/group012.mdl", ct = {model = "models/thespireroleplay/humans/group012/", Type = "Suit", skin = 10}, weight = 6},

	{name = "Combat Armor (12)", dropsound = "fosounds/fix/ui_items_clothing_down_02.mp3", takesound = "fosounds/fix/ui_items_clothing_up_02.mp3", tier = 4, capacity = 12, dt = 6, reduction = 0.50, isBag = true, price = 1000, 
	dropmodel = "models/thespireroleplay/items/clothes/group012.mdl", ct = {model = "models/thespireroleplay/humans/group012/", Type = "Suit", skin = 11}, weight = 6},

	{name = "Metal Armor (1)", dropsound = "fosounds/fix/ui_items_clothing_down_02.mp3", takesound = "fosounds/fix/ui_items_clothing_up_02.mp3", tier = 3, capacity = 8, dt = 5, reduction = 0.45, isBag = true, price = 800, 
	dropmodel = "models/thespireroleplay/items/clothes/group011.mdl", ct = {model = "models/thespireroleplay/humans/group011/", Type = "Suit"}, weight = 4},

	{name = "Metal Armor (2)", dropsound = "fosounds/fix/ui_items_clothing_down_02.mp3", takesound = "fosounds/fix/ui_items_clothing_up_02.mp3", tier = 3, capacity = 2, dt = 5, reduction = 0.45, isBag = true, price = 800, 
	dropmodel = "models/thespireroleplay/items/clothes/group011.mdl", ct = {model = "models/thespireroleplay/humans/group011/", Type = "Suit", skin = 1}, weight = 4},

	{name = "Vault 101 Jumpsuit", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = "U", capacity = 10, dt = 2, reduction = 0.20, isBag = true, price = 200, 
	dropmodel = "models/thespireroleplay/items/clothes/group010.mdl", ct = {model = "models/thespireroleplay/humans/group010/", Type = "Suit"}, weight = 2},

	{name = "Vault 106 Jumpsuit", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = "U", capacity = 10, dt = 2, reduction = 0.20, isBag = true, price = 200, 
	dropmodel = "models/thespireroleplay/items/clothes/group010.mdl", ct = {model = "models/thespireroleplay/humans/group010/", Type = "Suit", skin = 1}, weight = 2},

	{name = "Vault 112 Jumpsuit", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = "U", capacity = 10, dt = 2, reduction = 0.20, isBag = true, price = 200, 
	dropmodel = "models/thespireroleplay/items/clothes/group010.mdl", ct = {model = "models/thespireroleplay/humans/group010/", Type = "Suit", skin = 2}, weight = 2},

	{name = "Vault 92 Jumpsuit", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = "U", capacity = 10, dt = 2, reduction = 0.20, isBag = true, price = 200, 
	dropmodel = "models/thespireroleplay/items/clothes/group010.mdl", ct = {model = "models/thespireroleplay/humans/group010/", Type = "Suit", skin = 3}, weight = 2},

	{name = "Vault 77 Jumpsuit", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = "U", capacity = 10, dt = 2, reduction = 0.20, isBag = true, price = 200, 
	dropmodel = "models/thespireroleplay/items/clothes/group010.mdl", ct = {model = "models/thespireroleplay/humans/group010/", Type = "Suit", skin = 4}, weight = 2},

	{name = "Vault 21 Jumpsuit", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = "U", capacity = 10, dt = 2, reduction = 0.20, isBag = true, price = 200, 
	dropmodel = "models/thespireroleplay/items/clothes/group010.mdl", ct = {model = "models/thespireroleplay/humans/group010/", Type = "Suit", skin = 5}, weight = 2},

	{name = "Vault 19 Jumpsuit", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = "U", capacity = 10, dt = 2, reduction = 0.20, isBag = true, price = 200, 
	dropmodel = "models/thespireroleplay/items/clothes/group010.mdl", ct = {model = "models/thespireroleplay/humans/group010/", Type = "Suit", skin = 6}, weight = 2},

	{name = "Vault 11 Jumpsuit", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = "U", capacity = 10, dt = 2, reduction = 0.20, isBag = true, price = 200, 
	dropmodel = "models/thespireroleplay/items/clothes/group010.mdl", ct = {model = "models/thespireroleplay/humans/group010/", Type = "Suit", skin = 7}, weight = 2},

	{name = "Vault 3 Jumpsuit", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = "U", capacity = 10, dt = 2, reduction = 0.20, isBag = true, price = 200, 
	dropmodel = "models/thespireroleplay/items/clothes/group010.mdl", ct = {model = "models/thespireroleplay/humans/group010/", Type = "Suit", skin = 8}, weight = 2},

	{name = "Radiation Suit", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = 2, capacity = 2, dt = 2, reduction = 0.2, isBag = true, price = 1000, 
	dropmodel = "models/thespireroleplay/items/clothes/group009.mdl", ct = {model = {male = "models/thespireroleplay/humans/group009/male.mdl", female = "models/thespireroleplay/humans/group009/male.mdl", armdir = "models/thespireroleplay/humans/group009/arms/", blockothers = true}, Type = "Suit"}, weight = 1},

	{name = "Advanced Radiation Suit", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = "U", capacity = 2, dt = 4, reduction = 0.25, isBag = true, price = 2000, 
	dropmodel = "models/thespireroleplay/items/clothes/group009.mdl", ct = {model = {male = "models/thespireroleplay/humans/group009/male.mdl", female = "models/thespireroleplay/humans/group009/male.mdl", armdir = "models/thespireroleplay/humans/group009/arms/", blockothers = true}, Type = "Suit", skin = 1}, weight = 1},

	{name = "Elite Riot Gear", dropsound = "fosounds/fix/ui_items_clothing_down_03.mp3", takesound = "fosounds/fix/ui_items_clothing_up_03.mp3", tier = "U", capacity = 10, dt = 10, reduction = 0.60, isBag = true, price = 4000, 
	dropmodel = "models/thespireroleplay/items/clothes/group008.mdl", ct = {model = {male = "models/thespireroleplay/humans/group008/male.mdl", female = "models/thespireroleplay/humans/group008/male.mdl", armdir = "models/thespireroleplay/humans/group008/arms/"}, Type = "Suit"}, weight = 4},

	{name = "Followers Doctor Coat", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = 5, capacity = 2, dt = 0, reduction = 0.10, isBag = true, price = 40, 
	dropmodel = "models/thespireroleplay/items/clothes/group007.mdl", ct = {model = "models/thespireroleplay/humans/group007/", Type = "Suit"}, weight = 1},

	{name = "Followers Lab Coat", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = 5, capacity = 2, dt = 0, reduction = 0.10, isBag = true, price = 40, 
	dropmodel = "models/thespireroleplay/items/clothes/group007.mdl", ct = {model = "models/thespireroleplay/humans/group007/", Type = "Suit", skin = 1}, weight = 1},

	{name = "Dirty Lab Coat", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = 1, capacity = 6, dt = 0, reduction = 0.10, isBag = true, price = 30, 
	dropmodel = "models/thespireroleplay/items/clothes/group007.mdl", ct = {model = "models/thespireroleplay/humans/group007/", Type = "Suit", skin = 2}, weight = 2},

	{name = "Clean Vault Lab Coat", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = 5, capacity = 8, dt = 0, reduction = 0.20, isBag = true, price = 60, 
	dropmodel = "models/thespireroleplay/items/clothes/group007.mdl", ct = {model = "models/thespireroleplay/humans/group007/", Type = "Suit", skin = 3}, weight = 2},

	{name = "Green Jumpsuit", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = 2, capacity = 5, dt = 0, reduction = 0.15, isBag = true, price = 20, 
	dropmodel = "models/thespireroleplay/items/clothes/group006.mdl", ct = {model = "models/thespireroleplay/humans/group006/", Type = "Suit"}, weight = 2},

	{name = "White Jumpsuit", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = 2, capacity = 5, dt = 0, reduction = 0.15, isBag = true, price = 20, 
	dropmodel = "models/thespireroleplay/items/clothes/group006.mdl", ct = {model = "models/thespireroleplay/humans/group006/", Type = "Suit", skin = 1}, weight = 1},

	{name = "NCR Engineer Jumpsuit", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = "U", capacity = 2, dt = 0, reduction = 0.15, isBag = true, price = 30, 
	dropmodel = "models/thespireroleplay/items/clothes/group006.mdl", ct = {model = "models/thespireroleplay/humans/group006/", Type = "Suit", skin = 2}, weight = 1},

	{name = "Petro Chico Jumpsuit", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = 2, capacity = 5, dt = 0, reduction = 0.15, isBag = true, price = 20, 
	dropmodel = "models/thespireroleplay/items/clothes/group006.mdl", ct = {model = "models/thespireroleplay/humans/group006/", Type = "Suit", skin = 3}, weight = 1},

	{name = "Red Jumpsuit", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = 2, capacity = 5, dt = 0, reduction = 0.15, isBag = true, price = 20, 
	dropmodel = "models/thespireroleplay/items/clothes/group006.mdl", ct = {model = "models/thespireroleplay/humans/group006/", Type = "Suit", skin = 4}, weight = 1},

	{name = "Red Racer", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = 2, capacity = 5, dt = 0, reduction = 0.15, isBag = true, price = 800, 
	dropmodel = "models/thespireroleplay/items/clothes/group006.mdl", ct = {model = "models/thespireroleplay/humans/group006/", Type = "Suit", skin = 5}, weight = 1},

	{name = "Repconn Jumpsuit", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = 2, capacity = 5, dt = 0, reduction = 0.15, isBag = true, price = 40, 
	dropmodel = "models/thespireroleplay/items/clothes/group006.mdl", ct = {model = "models/thespireroleplay/humans/group006/", Type = "Suit", skin = 6}, weight = 1},

	{name = "Robco Jumpsuit", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = 1, capacity = 5, dt = 0, reduction = 0.15, isBag = true, price = 20, 
	dropmodel = "models/thespireroleplay/items/clothes/group006.mdl", ct = {model = "models/thespireroleplay/humans/group006/", Type = "Suit", skin = 7}, weight = 1},

	{name = "Assasin Suit", dropsound = "fosounds/fix/ui_items_clothing_down_02.mp3", takesound = "fosounds/fix/ui_items_clothing_up_02.mp3", tier = "U", capacity = 10, dt = 5, reduction = 0.35, isBag = true, price = 650, 
	dropmodel = "models/thespireroleplay/items/clothes/group005.mdl", ct = {model = "models/thespireroleplay/humans/group005/", Type = "Suit"}, weight = 3},

	{name = "Stealth Suit", dropsound = "fosounds/fix/ui_items_clothing_down_02.mp3", takesound = "fosounds/fix/ui_items_clothing_up_02.mp3", tier = "U", capacity = 10, dt = 6, reduction = 0.40, isBag = true, price = 1800, 
	dropmodel = "models/thespireroleplay/items/clothes/group005.mdl", ct = {model = "models/thespireroleplay/humans/group005/", Type = "Suit", skin = 1}, weight = 3},

	{name = "Stealth Suit Mark II", dropsound = "fosounds/fix/ui_items_clothing_down_02.mp3", takesound = "fosounds/fix/ui_items_clothing_up_02.mp3", tier = "U", medicsuit = true, voiceset = "stealthsuit", capacity = 10, dt = 8, reduction = 0.40, isBag = true, price = 4800, 
	dropmodel = "models/thespireroleplay/items/clothes/group005.mdl", ct = {model = "models/thespireroleplay/humans/group005/", Type = "Suit", skin = 1}, weight = 3},

	{name = "Wasteland Wanderer Outfit (1)", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = 2, capacity = 8, dt = 2, reduction = 0.20, isBag = true, price = 130, 
	dropmodel = "models/thespireroleplay/items/clothes/group004.mdl", ct = {model = "models/thespireroleplay/humans/group004/", Type = "Suit"}, weight = 1},

	{name = "Wasteland Explorer Outfit", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = 2, capacity = 8, dt = 0, reduction = 0.20, isBag = true, price = 40, 
	dropmodel = "models/thespireroleplay/items/clothes/group004.mdl", ct = {model = "models/thespireroleplay/humans/group004/", Type = "Suit", skin = 1}, weight = 1},

	{name = "Wasteland Explorer Outfit", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = 2, capacity = 8, dt = 0, reduction = 0.20, isBag = true, price = 40, 
	dropmodel = "models/thespireroleplay/items/clothes/group004.mdl", ct = {model = "models/thespireroleplay/humans/group004/", Type = "Suit", skin = 1}, weight = 2},

	{name = "Vaquero Outfit", dropsound = "fosounds/fix/ui_items_clothing_down_02.mp3", takesound = "fosounds/fix/ui_items_clothing_up_02.mp3", tier = 5, capacity = 9, dt = 2, reduction = 0.25, isBag = true, price = 180, 
	dropmodel = "models/thespireroleplay/items/clothes/group003.mdl", ct = {model = "models/thespireroleplay/humans/group003/", Type = "Suit"}, weight = 3, maleonly = true},

	{name = "SLC Police Outfit", dropsound = "fosounds/fix/ui_items_clothing_down_02.mp3", takesound = "fosounds/fix/ui_items_clothing_up_02.mp3", tier = "U", capacity = 10, dt = 6, reduction = 0.40, isBag = true, price = 1100, 
	dropmodel = "models/thespireroleplay/items/clothes/group002.mdl", ct = {model = "models/thespireroleplay/humans/group002/", Type = "Suit"}, weight = 4},

	{name = "Pimp Suit", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = 5, capacity = 6, dt = 0, reduction = 0.20, isBag = true, price = 100, 
	dropmodel = "models/thespireroleplay/items/clothes/group001.mdl", ct = {model = "models/thespireroleplay/humans/group001/", Type = "Suit"}, weight = 1},

	{name = "NCR Trooper Uniform (2)", dropsound = "fosounds/fix/ui_items_clothing_down_02.mp3", takesound = "fosounds/fix/ui_items_clothing_up_02.mp3", tier = "U", capacity = 10, dt = 4, reduction = 0.25, isBag = true, price = 700, maleonly = true,
	dropmodel = "models/thespireroleplay/items/clothes/group055.mdl", ct = {model = {male = "models/thespireroleplay/humans/group028/male.mdl", female = "models/thespireroleplay/humans/group028/female.mdl", armdir = "models/thespireroleplay/humans/group055/arms/"}, Type = "Suit"}, weight = 2}, 

	{name = "NCR Trooper Uniform (3)", dropsound = "fosounds/fix/ui_items_clothing_down_02.mp3", takesound = "fosounds/fix/ui_items_clothing_up_02.mp3", tier = "U", capacity = 10, dt = 4, reduction = 0.25, isBag = true, price = 700, maleonly = true,
	dropmodel = "models/thespireroleplay/items/clothes/group055.mdl", ct = {model = {male = "models/thespireroleplay/humans/group029/male.mdl", female = "models/thespireroleplay/humans/group028/female.mdl", armdir = "models/thespireroleplay/humans/group055/arms/"}, Type = "Suit"}, weight = 2}, 

	{name = "NCR Trooper Uniform (4)", dropsound = "fosounds/fix/ui_items_clothing_down_02.mp3", takesound = "fosounds/fix/ui_items_clothing_up_02.mp3", tier = "U", capacity = 10, dt = 4, reduction = 0.25, isBag = true, price = 700, maleonly = true,
	dropmodel = "models/thespireroleplay/items/clothes/group055.mdl", ct = {model = {male = "models/thespireroleplay/humans/group030/male.mdl", female = "models/thespireroleplay/humans/group028/female.mdl", armdir = "models/thespireroleplay/humans/group055/arms/"}, Type = "Suit"}, weight = 2}, 

	{name = "NCR Trooper Uniform (5)", dropsound = "fosounds/fix/ui_items_clothing_down_02.mp3", takesound = "fosounds/fix/ui_items_clothing_up_02.mp3", tier = "U", capacity = 10, dt = 4, reduction = 0.25, isBag = true, price = 700, maleonly = true,
	dropmodel = "models/thespireroleplay/items/clothes/group055.mdl", ct = {model = {male = "models/thespireroleplay/humans/group031/male.mdl", female = "models/thespireroleplay/humans/group028/female.mdl", armdir = "models/thespireroleplay/humans/group055/arms/"}, Type = "Suit"}, weight = 2}, 

	{name = "NCR Facewrap Uniform (1)", dropsound = "fosounds/fix/ui_items_clothing_down_02.mp3", takesound = "fosounds/fix/ui_items_clothing_up_02.mp3", tier = "U", capacity = 10, dt = 4, reduction = 0.25, isBag = true, price = 700, maleonly = true,
	dropmodel = "models/thespireroleplay/items/clothes/group055.mdl", ct = {model = {male = "models/thespireroleplay/humans/group032/male.mdl", female = "models/thespireroleplay/humans/group028/female.mdl", armdir = "models/thespireroleplay/humans/group055/arms/"}, Type = "Suit"}, weight = 2}, 

	{name = "NCR Facewrap Uniform (2)", dropsound = "fosounds/fix/ui_items_clothing_down_02.mp3", takesound = "fosounds/fix/ui_items_clothing_up_02.mp3", tier = "U", capacity = 10, dt = 4, reduction = 0.25, isBag = true, price = 700, maleonly = true,
	dropmodel = "models/thespireroleplay/items/clothes/group055.mdl", ct = {model = {male = "models/thespireroleplay/humans/group033/male.mdl", female = "models/thespireroleplay/humans/group028/female.mdl", armdir = "models/thespireroleplay/humans/group055/arms/"}, Type = "Suit"}, weight = 2}, 

	{name = "NCR Recon Uniform (1)", dropsound = "fosounds/fix/ui_items_clothing_down_02.mp3", takesound = "fosounds/fix/ui_items_clothing_up_02.mp3", tier = "U", capacity = 10, dt = 6, reduction = 0.25, isBag = true, price = 1200, maleonly = true,
	dropmodel = "models/thespireroleplay/items/clothes/group055.mdl", ct = {model = {male = "models/thespireroleplay/humans/group034/male.mdl", female = "models/thespireroleplay/humans/group028/female.mdl", armdir = "models/thespireroleplay/humans/group055/arms/"}, Type = "Suit"}, weight = 2}, 

	{name = "NCR Recon Uniform (2)", dropsound = "fosounds/fix/ui_items_clothing_down_02.mp3", takesound = "fosounds/fix/ui_items_clothing_up_02.mp3", tier = "U", capacity = 10, dt = 6, reduction = 0.25, isBag = true, price = 1200, maleonly = true,
	dropmodel = "models/thespireroleplay/items/clothes/group055.mdl", ct = {model = {male = "models/thespireroleplay/humans/group035/male.mdl", female = "models/thespireroleplay/humans/group028/female.mdl", armdir = "models/thespireroleplay/humans/group055/arms/"}, Type = "Suit"}, weight = 2}, 

	{name = "NCR Shirt Uniform (1)", dropsound = "fosounds/fix/ui_items_clothing_down_02.mp3", takesound = "fosounds/fix/ui_items_clothing_up_02.mp3", tier = "U", capacity = 10, dt = 0, reduction = 0.25, isBag = true, price = 70, maleonly = true,
	dropmodel = "models/thespireroleplay/items/clothes/group055.mdl", ct = {model = {male = "models/thespireroleplay/humans/group036/male.mdl", female = "models/thespireroleplay/humans/group028/female.mdl", armdir = "models/thespireroleplay/humans/group020/arms/"}, Type = "Suit"}, weight = 2}, 

	{name = "NCR Shirt Uniform (2)", dropsound = "fosounds/fix/ui_items_clothing_down_02.mp3", takesound = "fosounds/fix/ui_items_clothing_up_02.mp3", tier = "U", capacity = 10, dt = 0, reduction = 0.25, isBag = true, price = 70, maleonly = true,
	dropmodel = "models/thespireroleplay/items/clothes/group055.mdl", ct = {model = {male = "models/thespireroleplay/humans/group037/male.mdl", female = "models/thespireroleplay/humans/group028/female.mdl", armdir = "models/thespireroleplay/humans/group020/arms/"}, Type = "Suit"}, weight = 2}, 

	{name = "NCR Uniform", dropsound = "fosounds/fix/ui_items_clothing_down_02.mp3", takesound = "fosounds/fix/ui_items_clothing_up_02.mp3", tier = "U", capacity = 10, dt = 4, reduction = 0.25, isBag = true, price = 700, maleonly = true,
	dropmodel = "models/thespireroleplay/items/clothes/group055.mdl", ct = {model = {male = "models/thespireroleplay/humans/group038/male.mdl", female = "models/thespireroleplay/humans/group028/female.mdl", armdir = "models/thespireroleplay/humans/group055/arms/"}, Type = "Suit"}, weight = 2}, 

	{name = "Shoulder Mantle", dropsound = "fosounds/fix/ui_items_clothing_down_02.mp3", takesound = "fosounds/fix/ui_items_clothing_up_02.mp3", tier = 2, capacity = 10, dt = 1, reduction = 0.25, isBag = false, price = 120, 
	dropmodel = "models/props_c17/SuitCase001a.mdl", ct = {model = {male = "models/thespireroleplay/humans/gear/mantle_m.mdl", female = "models/thespireroleplay/humans/gear/mantle_m.mdl"}, Type = "Mantle"}, weight = 1}, 

	{name = "Bandolier", dropsound = "fosounds/fix/ui_items_clothing_down_02.mp3", takesound = "fosounds/fix/ui_items_clothing_up_02.mp3", tier = 2, capacity = 15, dt = 1, reduction = 0.10, isBag = true, price = 150, 
	dropmodel = "models/props_c17/SuitCase001a.mdl", ct = {model = {male = "models/thespireroleplay/humans/gear/bandolier_m.mdl", female = "models/thespireroleplay/humans/gear/bandolier_m.mdl"}, Type = "Bandolier"}, weight = 2}, 
	
	{name = "Slave Outfit", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = 5, capacity = 0, dt = 0, reduction = 0.20, isBag = false, price = 5, 
	dropmodel = "models/thespireroleplay/items/clothes/group058.mdl", ct = {model = "models/thespireroleplay/humans/group120/", Type = "Suit"}, weight = 2},

        {name = "Slave Outfit (2)", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = 5, capacity = 0, skin = 1, dt = 0, reduction = 0.20, isBag = false, price = 5,
        dropmodel = "models/thespireroleplay/items/clothes/group058.mdl", ct = {model = "models/thespireroleplay/humans/group120/", Type = "Suit", skin = 1}, weight = 2},

	{name = "Khan Outfit (1)", dropsound = "fosounds/fix/ui_items_clothing_down_02.mp3", takesound = "fosounds/fix/ui_items_clothing_up_02.mp3", tier = "U", capacity = 8, dt = 2, reduction = 0.25, isBag = true, price = 300,
 
	dropmodel = "models/thespireroleplay/items/clothes/group058.mdl", ct = {model = "models/thespireroleplay/humans/group116/", Type = "Suit"}, weight = 2},
	
	{name = "Khan Outfit (2)", dropsound = "fosounds/fix/ui_items_clothing_down_02.mp3", takesound = "fosounds/fix/ui_items_clothing_up_02.mp3", tier = "U", capacity = 8, dt = 2, reduction = 0.25, isBag = true, price = 300,
 
	dropmodel = "models/thespireroleplay/items/clothes/group058.mdl", ct = {model = "models/thespireroleplay/humans/group117/", Type = "Suit"}, weight = 2},
	
        {name = "Sierra Madre Security Armor", dropsound = "fosounds/fix/ui_items_clothing_down_02.mp3", takesound = "fosounds/fix/ui_items_clothing_up_02.mp3", tier = "U", capacity = 10, dt = 4, reduction = 0.3, isBag = true, price = 750,
        dropmodel = "models/thespireroleplay/items/clothes/group012.mdl", ct = {model = "models/thespireroleplay/humans/group118/", Type = "Suit"}, weight = 6},
 
        {name = "Reinforced Sierra Madre Security Armor", dropsound = "fosounds/fix/ui_items_clothing_down_02.mp3", takesound = "fosounds/fix/ui_items_clothing_up_02.mp3", tier = "U", skin = 1, capacity = 10, dt = 5, reduction = 0.3, isBag = true, price = 900,
        dropmodel = "models/thespireroleplay/items/clothes/group012.mdl", ct = {model = "models/thespireroleplay/humans/group118/", Type = "Suit", skin = 1}, weight = 6},
 
        {name = "Vault 34 Security Outfit", dropsound = "fosounds/fix/ui_items_clothing_down_02.mp3", takesound = "fosounds/fix/ui_items_clothing_up_02.mp3", tier = "U", skin = 2, capacity = 10, dt = 4, reduction = 0.3, isBag = true, price = 750,
        dropmodel = "models/thespireroleplay/items/clothes/group012.mdl", ct = {model = "models/thespireroleplay/humans/group118/", Type = "Suit", skin = 2}, weight = 6},
 
        {name = "Reinforced Vault 34 Security Outfit", dropsound = "fosounds/fix/ui_items_clothing_down_02.mp3", takesound = "fosounds/fix/ui_items_clothing_up_02.mp3", tier = "U", skin = 2, capacity = 10, dt = 5, reduction = 0.3, isBag = true, price = 900,
        dropmodel = "models/thespireroleplay/items/clothes/group012.mdl", ct = {model = "models/thespireroleplay/humans/group118/", Type = "Suit", skin = 3}, weight = 6},

         {name = "Lab Technician Outfit", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = 2, capacity = 8, dt = 0, reduction = 0.2, isBag = true, price = 20,
        dropmodel = "models/thespireroleplay/items/clothes/group007.mdl", ct = {model = "models/thespireroleplay/humans/group121/", Type = "Suit"}, weight = 2},
 
        {name = "Dirty Lab Technician Outfit", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = 2, skin = 1, capacity = 8, dt = 0, reduction = 0.2, isBag = true, price = 20,
        dropmodel = "models/thespireroleplay/items/clothes/group007.mdl", ct = {model = "models/thespireroleplay/humans/group121/", Type = "Suit", skin = 1}, weight = 2},
 
        {name = "Lab Technician Outfit (2)", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = 2, capacity = 8, dt = 0, skin = 2, reduction = 0.2, isBag = true, price = 20,
        dropmodel = "models/thespireroleplay/items/clothes/group007.mdl", ct = {model = "models/thespireroleplay/humans/group121/", Type = "Suit", skin = 2}, weight = 2},
 
        {name = "Lab Technician Outfit (3)", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = 2, capacity = 8, dt = 0, skin = 3, reduction = 0.2, isBag = true, price = 20,
        dropmodel = "models/thespireroleplay/items/clothes/group007.mdl", ct = {model = "models/thespireroleplay/humans/group121/", Type = "Suit", skin = 3}, weight = 2},

  {name = "Pre-War Businesswear (1)", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = 1, capacity = 5, dt = 0, reduction = 0.10, isBag = true, price = 20,
        dropmodel = "models/thespireroleplay/items/clothes/group014.mdl", ct = {model = "models/thespireroleplay/humans/group027/", Type = "Suit"}, weight = 2},
 
  {name = "Pre-War Businesswear (2)", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = 1, capacity = 5, dt = 0, reduction = 0.10, isBag = true, price = 20,
        dropmodel = "models/thespireroleplay/items/clothes/group014.mdl", ct = {model = "models/thespireroleplay/humans/group027/", Type = "Suit", skin = 2}, weight = 2},

  {name = "NCR Businesswear", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = "U", capacity = 5, dt = 0, reduction = 0.90, isBag = true, price = 20,
        dropmodel = "models/thespireroleplay/items/clothes/group014.mdl", ct = {model = "models/thespireroleplay/humans/group027/", Type = "Suit", skin = 1}, weight = 2},
 
        {name = "NCR Veteran Ranger Armor", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = "U", capacity = 10, dt = 10, reduction = 0.70, isBag = true, price = 4000,
        dropmodel = "models/thespireroleplay/items/clothes/group008.mdl", ct = {model = "models/thespireroleplay/humans/group025/", Type = "Suit"}, weight = 10},
 
{name = "Combat Armor, Reinforced Mk2 (1)", dropsound = "fosounds/fix/ui_items_clothing_down_02.mp3", takesound = "fosounds/fix/ui_items_clothing_up_02.mp3", tier = "U", capacity = 12, dt = 9, reduction = 0.70, isBag = true, price = 3000,
        dropmodel = "models/thespireroleplay/items/clothes/group053.mdl", ct = {model = "models/thespireroleplay/humans/group024/", Type = "Suit"}, weight = 6},
 
        {name = "Combat Armor, Reinforced Mk2 (2)", dropsound = "fosounds/fix/ui_items_clothing_down_02.mp3", takesound = "fosounds/fix/ui_items_clothing_up_02.mp3", tier = "U", capacity = 12, dt = 9, reduction = 0.70, isBag = true, price = 3000,
        dropmodel = "models/thespireroleplay/items/clothes/group053.mdl", ct = {model = "models/thespireroleplay/humans/group024/", Type = "Suit", skin = 1}, weight = 6},
 
        {name = "Combat Armor, Reinforced Mk2 (3)", dropsound = "fosounds/fix/ui_items_clothing_down_02.mp3", takesound = "fosounds/fix/ui_items_clothing_up_02.mp3", tier = "U", capacity = 12, dt = 9, reduction = 0.70, isBag = true, price = 3000,
        dropmodel = "models/thespireroleplay/items/clothes/group053.mdl", ct = {model = "models/thespireroleplay/humans/group024/", Type = "Suit", skin = 2}, weight = 6},
 
        {name = "Combat Armor, Reinforced Mk2 (4)", dropsound = "fosounds/fix/ui_items_clothing_down_02.mp3", takesound = "fosounds/fix/ui_items_clothing_up_02.mp3", tier = "U", capacity = 12, dt = 9, reduction = 0.70, isBag = true, price = 3000,
        dropmodel = "models/thespireroleplay/items/clothes/group053.mdl", ct = {model = "models/thespireroleplay/humans/group024/", Type = "Suit", skin = 3}, weight = 6},
 
{name = "Combat Armor, Reinforced Mk2 (5)", dropsound = "fosounds/fix/ui_items_clothing_down_02.mp3", takesound = "fosounds/fix/ui_items_clothing_up_02.mp3", tier = "U", capacity = 12, dt = 9, reduction = 0.70, isBag = true, price = 3000,
        dropmodel = "models/thespireroleplay/items/clothes/group053.mdl", ct = {model = "models/thespireroleplay/humans/group024/", Type = "Suit", skin = 4}, weight = 6},
 
        {name = "Combat Armor, Reinforced Mk2 (6)", dropsound = "fosounds/fix/ui_items_clothing_down_02.mp3", takesound = "fosounds/fix/ui_items_clothing_up_02.mp3", tier = "U", capacity = 12, dt = 9, reduction = 0.70, isBag = true, price = 3000,
        dropmodel = "models/thespireroleplay/items/clothes/group053.mdl", ct = {model = "models/thespireroleplay/humans/group024/", Type = "Suit", skin = 5}, weight = 6},
 
        {name = "Combat Armor, Reinforced Mk2 (7)", dropsound = "fosounds/fix/ui_items_clothing_down_02.mp3", takesound = "fosounds/fix/ui_items_clothing_up_02.mp3", tier = "U", capacity = 12, dt = 9, reduction = 0.70, isBag = true, price = 3000,
        dropmodel = "models/thespireroleplay/items/clothes/group053.mdl", ct = {model = "models/thespireroleplay/humans/group024/", Type = "Suit", skin = 6}, weight = 6},
 
        {name = "Combat Armor, Reinforced Mk2 (8)", dropsound = "fosounds/fix/ui_items_clothing_down_02.mp3", takesound = "fosounds/fix/ui_items_clothing_up_02.mp3", tier = "U", capacity = 12, dt = 9, reduction = 0.70, isBag = true, price = 3000,
        dropmodel = "models/thespireroleplay/items/clothes/group053.mdl", ct = {model = "models/thespireroleplay/humans/group024/", Type = "Suit", skin = 7}, weight = 6},
 
        {name = "Combat Armor, Reinforced Mk2 (9)", dropsound = "fosounds/fix/ui_items_clothing_down_02.mp3", takesound = "fosounds/fix/ui_items_clothing_up_02.mp3", tier = "U", capacity = 12, dt = 9, reduction = 0.70, isBag = true, price = 3000,
        dropmodel = "models/thespireroleplay/items/clothes/group053.mdl", ct = {model = "models/thespireroleplay/humans/group024/", Type = "Suit", skin = 8}, weight = 6},
 
  {name = "Brahmin-skin Outfit", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = 1, capacity = 5, dt = 0, reduction = 0.15, isBag = true, price = 10,
        dropmodel = "models/thespireroleplay/items/clothes/group004.mdl", ct = {model = "models/thespireroleplay/humans/group023/", Type = "Suit"}, weight = 2},
 
  {name = "Wasteland Outfit", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = 1, capacity = 5, dt = 0, reduction = 0.15, isBag = true, price = 10,
        dropmodel = "models/thespireroleplay/items/clothes/group004.mdl", ct = {model = "models/thespireroleplay/humans/group022/", Type = "Suit"}, weight = 2},
 
         {name = "Pre-War Outfit", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = 1, capacity = 8, dt = 0, reduction = 0.10, isBag = true, price = 20,
        dropmodel = "models/thespireroleplay/items/clothes/group014.mdl", ct = {model = "models/thespireroleplay/humans/group026/", Type = "Suit"}, weight = 2},
 
        {name = "Pre-War Outfit (2)", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = 1, skin = 1, capacity = 8, dt = 0, reduction = 0.10, isBag = true, price = 20,
        dropmodel = "models/thespireroleplay/items/clothes/group014.mdl", ct = {model = "models/thespireroleplay/humans/group026/", Type = "Suit", skin = 1}, weight = 2},
 
        {name = "Pre-War Outfit (3)", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = 1, capacity = 8, dt = 0, skin = 2, reduction = 0.10, isBag = true, price = 20,
        dropmodel = "models/thespireroleplay/items/clothes/group014.mdl", ct = {model = "models/thespireroleplay/humans/group026/", Type = "Suit", skin = 2}, weight = 2},
 
        {name = "Pre-War Outfit (4)", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = 1, capacity = 8, dt = 0, skin = 3, reduction = 0.10, isBag = true, price = 20,
        dropmodel = "models/thespireroleplay/items/clothes/group014.mdl", ct = {model = "models/thespireroleplay/humans/group026/", Type = "Suit", skin = 3}, weight = 2},

	{name = "Scientist Outfit", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = 3, capacity = 8, dt = 0, reduction = 0.10, isBag = true, price = 30, 
	dropmodel = "models/thespireroleplay/items/clothes/group007.mdl", ct = {model = "models/thespireroleplay/humans/group119/", Type = "Suit"}, weight = 2},

	{name = "Green Scientist Outfit", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = 3, capacity = 8, dt = 0, reduction = 0.10, isBag = true, price = 30, 
	dropmodel = "models/thespireroleplay/items/clothes/group007.mdl", ct = {model = "models/thespireroleplay/humans/group119/", Type = "Suit", skin = 1}, weight = 2},

	{name = "Red Scientist Outfit", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = 3, capacity = 8, dt = 0, reduction = 0.10, isBag = true, price = 30, 
	dropmodel = "models/thespireroleplay/items/clothes/group007.mdl", ct = {model = "models/thespireroleplay/humans/group119/", Type = "Suit", skin = 2}, weight = 2},

	{name = "White Scientist Outfit", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = 3, capacity = 8, dt = 0, reduction = 0.10, isBag = true, price = 30, 
	dropmodel = "models/thespireroleplay/items/clothes/group007.mdl", ct = {model = "models/thespireroleplay/humans/group119/", Type = "Suit", skin = 3}, weight = 2},

	{name = "T-51b Power Armor", dropsound = "fosounds/fix/ui_items_clothing_down_03.mp3", takesound = "fosounds/fix/ui_items_clothing_up_03.mp3", tier = "U", capacity = 26, dt = 30, reduction = 0.75, isBag = true, price = 10250, 
	dropmodel = "models/thespireroleplay/items/clothes/group056.mdl", ct = {model = "models/lazarusroleplay/thespireroleplay/humans/group113/", Type = "Suit"}, weight = 10}, 

{name = "T-51b Power Armor (2)", dropsound = "fosounds/fix/ui_items_clothing_down_03.mp3", takesound = "fosounds/fix/ui_items_clothing_up_03.mp3", tier = "U", capacity = 26, dt = 30, reduction = 0.75, isBag = true, price = 10250, 
	dropmodel = "models/thespireroleplay/items/clothes/group056.mdl", ct = {model = "models/lazarusroleplay/thespireroleplay/humans/group113/", Type = "Suit", skin = 1}, weight = 10}, 

{name = "Black T-51b Power Armor", dropsound = "fosounds/fix/ui_items_clothing_down_03.mp3", takesound = "fosounds/fix/ui_items_clothing_up_03.mp3", tier = "U", capacity = 26, dt = 30, reduction = 0.75, isBag = true, price = 10250, 
	dropmodel = "models/thespireroleplay/items/clothes/group056.mdl", ct = {model = "models/lazarusroleplay/thespireroleplay/humans/group113/", Type = "Suit", skin = 2}, weight = 10}, 

		{name = "Advanced Power Armor", dropsound = "fosounds/fix/ui_items_clothing_down_03.mp3", takesound = "fosounds/fix/ui_items_clothing_up_03.mp3", tier = "U", capacity = 30, dt = 36, reduction = 0.80, isBag = true, price = 16500, 
	dropmodel = "models/thespireroleplay/items/clothes/group056.mdl", ct = {model = "models/lazarusroleplay/thespireroleplay/humans/group115/", Type = "Suit"}, weight = 10}, 

	    {name = "Merc Charmer Outfit", dropsound = "fosounds/fix/ui_items_clothing_down_01.mp3", takesound = "fosounds/fix/ui_items_clothing_up_01.mp3", tier = 2, capacity = 6, dt = 5, reduction = 0.25, isBag = true, price = 900,
        dropmodel = "models/thespireroleplay/items/clothes/group018.mdl", ct = {model = "models/thespireroleplay/humans/group019/group018/", Type = "Suit"}, weight = 2},
}


for k, v in pairs(clothes) do
	codex = codex.."<li></b>"..v.name.."<ul>\n"
	codex = codex.."<li><b>Tier: </b>"..v.tier.."</li>\n"
	codex = codex.."<li><b>Misc Info:</b><ul><li>Type: "..v.ct.Type.."</li><li>Weight: "..v.weight.."</li>"
	if (v.dt) then
		codex = codex.."<li>DT: "..v.dt.."</li>"
	end
	codex = codex..'</ul></li></ul></ul><br>\n'
end


for _, item in pairs(clothes) do
	local ITEM = {}

	if (item.price) then
		item.price = item.price * nut.config.priceMultiplier
	end

	local abundance = item.tier
	if (abundance == "U" or abundance == "L" or abundance == "R") then
		abundance = 6
	end
	if (SERVER) then
		if (abundance != 6) then
			SCHEMA:AddLootcrateItem("clothes", item.name, abundance)
		end
	end

	ITEM.name = item.name or "error"
	ITEM.uniqueID = item.name
	ITEM.category = item.category or "Clothing"
	ITEM.isBag = item.isBag or false
	ITEM.capacity = item.capacity or 5
	ITEM.reduction = item.reduction or 0.80
	ITEM.weight = item.weight or 1
	ITEM.voiceset = item.voiceset or false
	ITEM.medicsuit = item.medicsuit or false
	ITEM.maleonly = item.maleonly or false
	ITEM.flag = item.tier.."a"
	ITEM.dt = item.dt
	ITEM.data = {
		Equipped = false
	}
	if (item.isBag) then
		ITEM.data.items = {}
	end
	ITEM.ClothesTable = {
		model = item.ct.model or "models/thespireroleplay/humans/group001/",
		skin = item.ct.skin or 0,
		Type = item.ct.Type or "clothing",
		bodygroup = item.ct.bodygroup or nil,
		T51b = item.IsT51 or nil
	}
	ITEM.dropSound = item.dropsound
	ITEM.takeSound = item.takesound
	ITEM.skin = item.ct.skin or item.skin or 0
	ITEM.price = item.price or 0
	ITEM.model = item.dropmodel or item.model or "models/props_c17/BriefCase001a.mdl"
	ITEM.functions = {}
	ITEM.functions.Wear = {
		run = function(itemTable, client, data)
			if client.character:GetData(itemTable.ClothesTable.Type) then
				return false
			end
	
			if (SERVER) then
				if (data.inBag) then
					return false
				end

				if (itemTable.maleonly) then
					if client:GetGender() == "female" then
						return false
					end
				end

				if (itemTable.voiceset) then
					client.character:SetData("voiceset", itemTable.voiceset)
					client:SendSound(table.Random(SCHEMA.Voicesets[itemTable.voiceset]["equip"]))
				end

				SCHEMA:PushClothesUpdate(client, itemTable.ClothesTable)
				
				client:SendSound(itemTable.takeSound or "fosounds/fix/ui_items_generic_up_0"..math.random(1,4)..".mp3")
				client.character:SetData(itemTable.ClothesTable.Type, itemTable.uniqueID)
	
				local newData = table.Copy(data)
				newData.Equipped = true
	
				client:UpdateInv(itemTable.uniqueID, 1, newData, true)
				hook.Run("OnClothEquipped", client, itemTable, true)
			end
		end,
		shouldDisplay = function(itemTable, data, entity)
			return data and !data.Equipped
		end
	}
	ITEM.functions.TakeOff = {
		text = "Take Off",
		run = function(itemTable, client, data)
			if (SERVER) then
				
				client:SendSound(itemTable.dropSound or "fosounds/fix/ui_items_generic_down.mp3")
				client.character:SetData(itemTable.ClothesTable.Type, nil, nil, true)
		
				SCHEMA:PushClothesRemoveUpdate(client, itemTable.ClothesTable)
	
				local newData = table.Copy(data)
				newData.Equipped = false
	
				client:UpdateInv(itemTable.uniqueID, 1, newData, true)
				hook.Run("OnClothEquipped", client, itemTable, false)
	
				if (itemTable.ClothesTable.Type == "Suit") then
					SCHEMA:PushClothesUpdate(client, "default")
				end
	
				if (itemTable.voiceset) then
					client.character:SetData("voiceset", false)
					client:SendSound(table.Random(SCHEMA.Voicesets[itemTable.voiceset]["unequip"]))
				end


				return true
			end
		end,
		shouldDisplay = function(itemTable, data, entity)
			return data and data.Equipped or false
		end
	}
	
	local size = 16
	local border = 4
	local distance = size + border
	local tick = Material("icon16/tick.png")
	
	function ITEM:PaintIcon(w, h)
		if (self.data and self.data.Equipped) then
			surface.SetDrawColor(0, 0, 0, 50)
			surface.DrawRect(w - distance - 1, w - distance - 1, size + 2, size + 2)
	
			surface.SetDrawColor(255, 255, 255)
			surface.SetMaterial(tick)
			surface.DrawTexturedRect(w - distance, w - distance, size, size)
		end
	end
	
	function ITEM:CanTransfer(client, data)
		if (data.Equipped) then
			nut.util.Notify("You must unequip the item before doing that.", client)
		end
	
		return !data.Equipped
	end
	
	function ITEM:GetDropModel()
		return item.dropmodel or "models/props_c17/suitCase_passenger_physics.mdl"
	end

	function ITEM:GetWeight(data)
		local data = data or {}
		data.items = data.items or {}

		local weight, inventory = 0, data.items

		for itemID, items in pairs(inventory) do
			local itemTable = nut.item.Get(itemID)
			for k, item in pairs(items) do
				weight = weight + itemTable:GetWeight(item.data)
			end
		end

		if (data.Equipped) then
			weight = ((self.weight/2) + weight) * self.reduction
		else
			weight = (self.weight + weight)
		end

		return weight
	end

	SCHEMA:RegisterItem(ITEM)
end

timer.Simple(1, function()
	for _, swep in pairs(weapons.GetList()) do	
		if (swep.Tier and swep.PrintName) then

			local abundance = tonumber(swep.Tier)
			if (swep.Tier == "U") then
				abundance = 6
			end

			local tier = swep.Tier
			if (swep.IsMelee) then
				tier = swep.Tier.."x"
			elseif (swep.IsEnergy) then
				tier = swep.Tier.."z"
			else
				tier = swep.Tier.."w"
			end

			if (SERVER) then 
				if (abundance != 6) then
					SCHEMA:AddLootcrateItem("weapons", swep.PrintName, abundance)
				end
			end

			ITEM = {}
			ITEM.name = swep.PrintName
			ITEM.uniqueID = swep.PrintName
			ITEM.category = string.gsub(swep.Category, "Lazarus Roleplay:", "")
			ITEM.model = swep.WorldModel
			ITEM.class = swep.ClassName
			ITEM.type = swep.HoldType
			ITEM.IsEnergy = swep.IsEnergy or false
			ITEM.IsMelee = swep.IsMelee or false
			ITEM.weight = tonumber(swep.Weight) or 1
			ITEM.cooldown = swep.cooldown or 86400
			ITEM.defaultStock = swep.defaultStock or 3
			ITEM.price = tonumber(swep.Price)
			ITEM.flag = tier
			ITEM.data = {
				Equipped = false
			}
			ITEM.functions = {}
			ITEM.functions.Equip = {
				run = function(itemTable, client, data)
					if (SERVER) then
						if (client:HasWeapon(itemTable.class)) then
							nut.util.Notify("You already has this weapon equipped.", client)
			
							return false
						end
			
						if (nut.config.noMultipleWepSlots and IsValid(client:GetNutVar(itemTable.type))) then
							nut.util.Notify("You already have a weapon in the "..itemTable.type.." slot.", client)
			
							return false
						end
			
						local weapon = client:Give(itemTable.class)
			
						if (IsValid(weapon)) then
							client:SetNutVar(itemTable.type, weapon)
							client:SelectWeapon(itemTable.class)
						end
			
						local newData = table.Copy(data)
						newData.Equipped = true
			
						client:UpdateInv(itemTable.uniqueID, 1, newData, true)
						hook.Run("OnWeaponEquipped", client, itemTable, true)
					end
			
					timer.Simple(0.2, function()
						local wep = client:GetActiveWeapon()
						if (wep:GetClass() == itemTable.class) then
							if (data.custom and data.custom.lunchboxmod) then
								for k, v in pairs(data.custom.lunchboxmod) do
									--print(k)
									--print(wep[k])
									if type(v) == "table" then
										for k2, v2 in pairs(v) do
											wep[k][k2] = v2
										end
									else
										wep[k] = v
									end
								end
							end
						end
					end)
			
					if (CLIENT) then
						timer.Simple(0.2, function()
							local wep = client:GetActiveWeapon()
							if (wep:GetClass() == itemTable.class) then
								wep.PrintName = data and data.custom and data.custom.name or itemTable.name
								wep.Instructions = data and data.custom and data.custom.desc or itemTable.desc
								wep.DisplayColor = data and data.custom and data.custom.color or nil
							end
						end)
					end
				end,
				shouldDisplay = function(itemTable, data, entity)
					return !data.Equipped or data.Equipped == nil
				end
			}
			ITEM.functions.Unequip = {
				run = function(itemTable, client, data)
					if (SERVER) then
						if (client:HasWeapon(itemTable.class)) then
							client:SetNutVar(itemTable.type, nil)
							client:StripWeapon(itemTable.class)
						end
			
						local newData = table.Copy(data)
						newData.Equipped = false
			
						client:UpdateInv(itemTable.uniqueID, 1, newData, true)
						hook.Run("OnWeaponEquipped", client, itemTable, false)
						return true
					end
				end,
				shouldDisplay = function(itemTable, data, entity)
					return data.Equipped == true
				end
			}
			
			local size = 16
			local border = 4
			local distance = size + border
			local tick = Material("icon16/tick.png")
			
			function ITEM:PaintIcon(w, h)
				if (self.data.Equipped) then
					surface.SetDrawColor(0, 0, 0, 50)
					surface.DrawRect(w - distance - 1, w - distance - 1, size + 2, size + 2)
			
					surface.SetDrawColor(255, 255, 255)
					surface.SetMaterial(tick)
					surface.DrawTexturedRect(w - distance, w - distance, size, size)
				end
			end
			
			function ITEM:CanTransfer(client, data)
				if (data.Equipped) then
					nut.util.Notify("You must unequip the item before doing that.", client)
				end
			
				return !data.Equipped
			end
	
			SCHEMA:RegisterItem(ITEM)
		end
	end
end)

if (SERVER) then
	hook.Add("PlayerSpawn", "nut_WeaponITEM", function(client)
		timer.Simple(0.1, function()
			if (!IsValid(client) or !client.character) then
				return
			end

			for class, items in pairs(client:GetInventory()) do
				local itemTable = nut.item.Get(class)

				if (itemTable and itemTable.class) then
					for k, v in pairs(items) do
						if (v.data.Equipped) then
							local weapon = client:Give(itemTable.class)
							
							client:SetNutVar(itemTable.type, weapon)
						end
					end
				end
			end
		end)
	end)
end

local craftingsupplies ={	
	{name = "Empty Abstinthe Bottle", model = "models/lazarusroleplay/props/absinthebottleempty.mdl", price = 5},
	{name = "Duct Tape", model = "models/lazarusroleplay/props/ductape.mdl", price = 10},
	{name = "Empty Bottle", model = "models/lazarusroleplay/props/antivenombark.mdl", price = 5},
	{name = "Pressure Cooker", model = "models/lazarusroleplay/props/pressurecooker01.mdl", price = 7},
	{name = "Toolbox", model = "models/lazarusroleplay/props/repairkit.mdl", price = 90},
	{name = "Scrap Electronics", model = "models/lazarusroleplay/props/scrapelectronics.mdl", price = 20},
	{name = "Toaster", model = "models/lazarusroleplay/props/toasteraged.mdl", price = 8},
	{name = "Steam Guage Assembly", model = "models/lazarusroleplay/props/railway_rifle.mdl", price = 15},
	{name = "Radscorpion Poison Gland", model = "models/lazarusroleplay/props/nvbarkscorpiongland.mdl", price = 40},
	{name = "Cazador Poison Gland", model = "models/lazarusroleplay/props/nvbarkscorpiongland.mdl", price = 70},
	{name = "Yeast", model = "models/lazarusroleplay/props/oasissack01.mdl", price = 15},
	{name = "Brocflower", model = "models/lazarusroleplay/props/brocflowersingle02.mdl", price = 8},
	{name = "Xander Root", model = "models/lazarusroleplay/props/xanderrootnew01.mdl", price = 10},
	{name = "Pinyon Nuts", model = "models/lazarusroleplay/props/pinyonnuts.mdl", price = 6},
	{name = "White Horsenettle Berries", model = "models/lazarusroleplay/props/whitehorsenettleberries.mdl", price = 7},
	{name = "Jar of Gunpowder", model = "models/props_lab/jar01a.mdl", price = 15},
	{name = "Scrap Metal", model = "models/lazarusroleplay/props/spareparts.mdl", price = 10},
	{name = "Broken Stealthboy", model = "models/fallout new vegas/doctor_bag.mdl", price = 100},
	{name = "Broken Slave Collar", model = "models/maxib123/slavecollar.mdl", price = 70},
	{name = "Toy Bot", model = "models/mosi/fallout4/props/junk/toyrobot01.mdl", price = 4},
	{name = "Ballistic Fiber", model = "models/mosi/fallout4/props/junk/components/ballisticfiber.mdl", price = 30},
	{name = "Circuitry", model = "models/mosi/fallout4/props/junk/components/circuitry.mdl", price = 25},
	{name = "Steel", model = "models/mosi/fallout4/props/junk/components/steel.mdl", price = 30},
	{name = "Sensor Module", model = "models/mosi/fallout4/props/junk/sensormodule.mdl", price = 15},
	{name = "Nuclear Material", model = "models/mosi/fallout4/props/junk/components/nuclear.mdl", price = 30},
	{name = "Toy Gutsy", model = "models/mosi/fallout4/props/junk/toygutsy.mdl", price = 100},
	{name = "Trigger Kit", model = "models/mosi/fallout4/props/junk/bobbypinbox.mdl", price = 50},
    {name = "Scrap Wood", model = "models/Gibs/wood_gib01b.mdl", price = 6},
 	{name = "Broken Telephone", model = "models/props_trainstation/payphone_reciever001a.mdl", price = 4},
    {name = "Car Tire", model = "models/props_vehicles/carparts_tire01a.mdl", price = 10},
    {name = "Desk Lamp", model = "models/props_lab/desklamp01.mdl", price = 7},
    {name = "Empty Soda", model = "models/props_junk/PopCan01a.mdl", price = 3},
    {name = "A Can of Paint", model = "models/props_junk/metal_paintcan001a.mdl", price = 5},
    {name = "A Metal Bucket", model = "models/props_junk/MetalBucket01a.mdl", price = 10},
    {name = "A Clock", model = "models/props_junk/Shoe001a.mdl", price = 4},
    {name = "A Metal Pot", model = "models/props_c17/metalPot001a.mdl", price = 9},
    {name = "A Metal Pan", model = "models/props_c17/metalPot002a.mdl", price = 8},
    {name = "A Screwdriver", model = "models/props_c17/TrapPropeller_Lever.mdl", price = 15},
    {name = "A Wrench", model = "models/props_junk/Shoe001a.mdl", price = 20},
    {name = "A Shoe", model = "models/props_junk/Shoe001a.mdl", price = 3},
    {name = "A Saw Blade", model = "models/props_junk/sawblade001a.mdl", price = 18},
    {name = "Empty Syringe", model = "models/lazarusroleplay/props/surgicalsyringe01.mdl", price = 4},
    {name = "A Pack of Cigarettes", model = "models/llama/cigpack.mdl", price = 6},
    {name = "Per-War Money", model = "models/llama/prewarmoney.mdl", price = 10},
    {name = "A Blowtorch", model = "models/mosi/fallout4/props/junk/blowtorch.mdl", price = 50},
	{name = "Mantis Claw", model = "models/halokiller38/fallout/weapons/melee/mantisgauntlet.mdl", price = 10},
    {name = "Blowtorch Fuel", model = "models/mosi/fallout4/props/junk/coolant.mdl", price = 10}
}

codex = codex.."</ul>"

for k, v in pairs(craftingsupplies) do
	ITEM = {}
	ITEM.name = v.name
	ITEM.uniqueID = v.name
	ITEM.model = v.model or "models/Items/BoxSRounds.mdl"
	ITEM.category = "Crafting Supplies"
	ITEM.flag = "2"
	ITEM.price = v.price

	if (SERVER) then 
		SCHEMA:AddLootcrateItem("crafting", v.name, 1)
	end

	SCHEMA:RegisterItem(ITEM)
end

if (SERVER) then
	hook.Add("PlayerSpawn", "nut_WeaponITEM", function(client)
		timer.Simple(0.1, function()
			if (!IsValid(client) or !client.character) then
				return
			end

			for class, items in pairs(client:GetInventory()) do
				local itemTable = nut.item.Get(class)

				if (itemTable and itemTable.class) then
					for k, v in pairs(items) do
						if (v.data.Equipped) then
							local weapon = client:Give(itemTable.class)
							
							client:SetNutVar(itemTable.type, weapon)
						end
					end
				end
			end
		end)
	end)
end

if (CLIENT) then
	hook.Add("BuildHelpOptions", "nut_itemcodex", function(data)
		data:AddHelp("Item Codex", function()

			return codex
		end, "icon16/flag_orange.png")
	end)
end