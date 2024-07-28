ITEM.name = "Flashlight"
ITEM.uniqueID = "flashlight"
ITEM.model = Model("models/Items/AR2_Grenade.mdl")
ITEM.desc = "A flashlight that has shines dimly.\n%battery% Battery Remaining"
ITEM.flag = "1"
ITEM.data = { 
	battery = 100, 
	Equipped = false 
}
ITEM.functions = {}
ITEM.functions.Equip = {
	run = function(itemTable, client, data)
		if (SERVER) then
			local newData = table.Copy(data)
			newData.Equipped = true
			client:UpdateInv(itemTable.uniqueID, 1, newData)
		end
	end,

	shouldDisplay = function(itemTable, data, entity)
		return !data.Equipped or data.Equipped == nil
	end
}

ITEM.functions.Unequip = {
	run = function(itemTable, client, data)
		if (SERVER) then
			local newData = table.Copy(data)
			newData.Equipped = false
			client:UpdateInv(itemTable.uniqueID, 1, newData)

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

if (SERVER) then
	ITEM:Hook("Drop", function(itemTable, client)
		if (client:FlashlightIsOn()) then
			client:Flashlight(false)
		end
	end)
end