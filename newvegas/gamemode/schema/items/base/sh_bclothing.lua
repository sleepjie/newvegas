BASE.name = "Base Bonemerge Clothes"
BASE.uniqueID = "base_bcloth"
BASE.category = "Clothing"
BASE.isBag = false
BASE.data = {
	Equipped = false,
	items = {}
}
BASE.ClothesTable = {
	model = "models/thespireroleplay/humans/group001/",
	skin = 0,
	Type = "clothing",
	bodygroup = {0, 0}
}
BASE.model = "models/props_c17/BriefCase001a.mdl"
BASE.CarryWeight = 5 -- How many kilos can the item carry?
BASE.functions = {}
BASE.functions.Wear = {
	run = function(itemTable, client, data)
		if client.character:GetData(itemTable.ClothesTable.Type) then
			
			return false
		end

		if (SERVER) then
			SCHEMA:PushClothesUpdate(client, itemTable.ClothesTable)

			client.character:SetData(itemTable.ClothesTable.Type, itemTable.uniqueID)

			local newData = table.Copy(data)
			newData.Equipped = true

			client:UpdateInv(itemTable.uniqueID, 1, newData, true)
			hook.Run("OnClothEquipped", client, itemTable, true)
			client:SendSound(itemTable.usesound)
		end
	end,
	shouldDisplay = function(itemTable, data, entity)
		return !data.Equipped or data.Equipped == nil
	end
}
BASE.functions.TakeOff = {
	text = "Take Off",
	run = function(itemTable, client, data)
		if (SERVER) then

			client.character:SetData(itemTable.ClothesTable.Type, nil, nil, true)

			SCHEMA:PushClothesRemoveUpdate(client, itemTable.ClothesTable)

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

function BASE:PaintIcon(w, h)
	if (self.data.Equipped) then
		surface.SetDrawColor(0, 0, 0, 50)
		surface.DrawRect(w - distance - 1, w - distance - 1, size + 2, size + 2)

		surface.SetDrawColor(255, 255, 255)
		surface.SetMaterial(tick)
		surface.DrawTexturedRect(w - distance, w - distance, size, size)
	end
end

function BASE:CanTransfer(client, data)
	if (data.Equipped) then
		nut.util.Notify("You must unequip the item before doing that.", client)
	end

	return !data.Equipped
end

function BASE:GetDropModel()
	return "models/props_c17/suitCase_passenger_physics.mdl"
end