player.FindByUserID = function(uid)
	for k, v in pairs(player.GetAll()) do
		if (v:UserID() == uid) then
			return v
		end
	end

	return nil
end

local playerMeta = FindMetaTable("Player")

function playerMeta:IsGhoul()
	return self:GetModel() == "models/lazarusroleplay/heads/ghoul_default.mdl"
end

function playerMeta:GetEquippedItems()
	local returnval = {}

	for _, inv in pairs(self:GetInventoryBags()) do
		for itemID, items in pairs(inv.bag) do
			for __, item in pairs(items) do
				if (item.data.Equipped) then
					returnval[itemID] = item.data
				end
			end
		end
	end

	return returnval
end

function playerMeta:HasItemEquipped(ItemID, Data, Inventory)
	local inventory = Inventory or self:GetInventory()

	for itemID, items in pairs(inventory) do
		if itemID == ItemID then
			for k, item in pairs(items) do
				if (!Data) then
					if (item.data.Equipped) then
						return true
					end
				elseif (item.data == Data) then
					if (item.data.Equipped) then
						return true
					end
				end
			end
		end
	end

	return false
end

function playerMeta:Notify(notification)
	if (notification) then
		nut.util.Notify(notification, self)
	end
end

function playerMeta:SetEyeMaterial(eyemat)
	local index, material = 3, nut.util.getMaterial("models/lazarus/shared/"..eyemat)
	if (self:GetGender() == "female") then
		index = 1
	end
end

SCHEMA.SkinTones = {}
SCHEMA.SkinTones["models/lazarusroleplay/heads/male_african.mdl"] = 3
SCHEMA.SkinTones["models/lazarusroleplay/heads/male_asian.mdl"] = 7
SCHEMA.SkinTones["models/lazarusroleplay/heads/male_caucasian.mdl"] = 1
SCHEMA.SkinTones["models/lazarusroleplay/heads/male_hispanic.mdl"] = 5
SCHEMA.SkinTones["models/lazarusroleplay/heads/female_african.mdl"] = 3
SCHEMA.SkinTones["models/lazarusroleplay/heads/female_asian.mdl"] = 7
SCHEMA.SkinTones["models/lazarusroleplay/heads/female_caucasian.mdl"] = 1
SCHEMA.SkinTones["models/lazarusroleplay/heads/female_hispanic.mdl"] = 5

SCHEMA.MutantModels = {}

SCHEMA.MutantModels["models/thespireroleplay/Fallout/Dogs/coyote.mdl"] = true
SCHEMA.MutantModels["models/thespireroleplay/Fallout/Dogs/dog.mdl"] = true
SCHEMA.MutantModels["models/thespireroleplay/Fallout/Dogs/mongrel.mdl"] = true
SCHEMA.MutantModels["models/thespireroleplay/Fallout/Dogs/rex.mdl"] = true
SCHEMA.MutantModels["models/thespireroleplay/Fallout/Dogs/rex_military.mdl"] = true
SCHEMA.MutantModels["models/thespireroleplay/Fallout/Dogs/rex_police.mdl"] = true
SCHEMA.MutantModels["models/thespireroleplay/Fallout/Dogs/vicious.mdl"] = true
SCHEMA.MutantModels["models/thespireroleplay/Fallout/Dogs/coyote.mdl"] = true
SCHEMA.MutantModels["models/fallout/supermutant.mdl"] = true
SCHEMA.MutantModels["models/fallout/supermutant_behemoth.mdl"] = true
SCHEMA.MutantModels["models/fallout/supermutant_heavy.mdl"] = true
SCHEMA.MutantModels["models/fallout/supermutant_light.mdl"] = true
SCHEMA.MutantModels["models/fallout/supermutant_medium.mdl"] = true
SCHEMA.MutantModels["models/fallout/supermutant_nightkin.mdl"] = true

function playerMeta:GetSkinTone()
	if SCHEMA.SkinTones[self:GetModel()] then
		return SCHEMA.SkinTones[self:GetModel()]
	elseif self.character then
		if self.character:GetData("facemap") then
			return self.character:GetData("facemap") - 1
		else
			return 0
		end
	else
		return 0
	end
end

function playerMeta:GetRace()
	local race = "caucasian"

	if (SCHEMA.SkinTones[self:GetModel()]) and (SCHEMA.SkinTones[self:GetModel()] == 3) then
		race = "african"
	elseif (SCHEMA.SkinTones[self:GetModel()]) and (SCHEMA.SkinTones[self:GetModel()] == 7) then
		race = "asian"
	elseif (SCHEMA.SkinTones[self:GetModel()]) and (SCHEMA.SkinTones[self:GetModel()] == 1) then
		race = "caucasian"
	elseif (SCHEMA.SkinTones[self:GetModel()]) and (SCHEMA.SkinTones[self:GetModel()] == 5) then
		race = "hispanic"
	end

	return race
end

function playerMeta:IsMutant()
	if (!self:IsRobot()) then
		if !SCHEMA.SkinTones[self:GetModel()] then
			return true
		end
	end
end

function playerMeta:GetInventoryBags()
	local character = self.character
	local inventory = self:GetInventory() or {}
	local bags = {}
	table.insert(bags, {meta = "default", maxWeight = nut.config.defaultInvWeight, bag = inventory})

	for itemID, items in pairs(inventory) do
		local itemTable = nut.item.Get(itemID)
		for _, item in pairs(items) do
			local data = item and item.data or {}
			if (itemTable and itemTable.isBag and data.Equipped) then
				table.insert(bags, {meta = itemTable.uniqueID, maxWeight = itemTable.capacity, bag = item.data.items})
			end
		end
	end

	return bags
end

function playerMeta:GetInventoryByBag(bagMeta)
	local character = self.character
	local bags = self:GetInventoryBags()
	for _, Bag in pairs(bags) do
		if (Bag.meta == bagMeta) then 
			return Bag.bag
		end
	end

	return false
end

function playerMeta:GetBagByMeta(bagMeta)
	local character = self.character
	local bags = self:GetInventoryBags()
	for _, Bag in pairs(bags) do
		if (Bag.meta == bagMeta) then 
			return Bag
		end
	end

	return false
end

function playerMeta:HasInvSpace(itemTable, quantity, forced, noMessage, Inventory)
	local weight, maxWeight = self:GetInvWeight(Inventory)
	quantity = quantity or 1

	-- Cannot add more items.
	if (!forced and quantity > 0 and weight + itemTable.weight > maxWeight) then
		if (!noMessage) then
			nut.util.Notify(nut.lang.Get("no_invspace"), self)
		end

		return false
	end

	return true
end

function playerMeta:HasItem(class, quantity, Inventory)
	local amt = 0

	if (type(quantity) != "number") then
		Inventory = quantity
		quantity = nil
	end

	for k, v in pairs(self:GetItemsByClass(class, Inventory)) do
		amt = amt + v.quantity
	end
	return amt >= (quantity or 1)
end

function playerMeta:HasItemRecursive(uid)
	local found = false

	for k, v in pairs(self:GetInventoryBags()) do
		for k2, v2 in pairs(v.bag) do
			if (!found) then
				local itemTable = nut.item.Get(k2)
				if (itemTable.uniqueID == uid) then
					found = {uniqueID = itemTable.uniqueID, meta = v.meta}
				end
			end
		end
	end

	return found
end

function playerMeta:GetItemsByClass(class, Inventory)
	local inventory = Inventory or self:GetInventory()
	return inventory[class] or {}
end

function playerMeta:GetInvWeight(inventory)
	local weight, maxWeight = 0, nut.config.defaultInvWeight

	for uniqueID, items in pairs(inventory or self:GetInventory()) do
		local itemTable = nut.item.Get(uniqueID)
		if (itemTable) then
			local quantity = 0
			local itemweight = 0
			for k, item in pairs(items) do
				quantity = quantity + (item.quantity or 0)

				itemweight = itemTable:GetWeight(item.data)
			end
			local addition = math.abs(itemweight) * quantity
			if (itemweight < 0) then
				maxWeight = maxWeight + addition
			else
				weight = weight + addition
			end
		end
	end
	return weight, maxWeight
end

function GM:PlayerNoClip(client)
	local res = client:HasFlag("x") or client:IsAdmin()
	return res
end