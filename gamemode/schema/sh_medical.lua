local MedicalEnums = {}
MedicalEnums[1] = "Head"
MedicalEnums[2] = "Chest"
MedicalEnums[3] = "Stomach"
MedicalEnums[4] = "Left Arm"
MedicalEnums[5] = "Right Arm"
MedicalEnums[6] = "Left Leg"
MedicalEnums[7] = "Right Leg"

local defaultdata = {}
defaultdata[1] = {health = 100, conditions = {}}
defaultdata[2] = {health = 100, conditions = {}}
defaultdata[3] = {health = 100, conditions = {}}
defaultdata[4] = {health = 100, conditions = {}}
defaultdata[5] = {health = 100, conditions = {}}
defaultdata[6] = {health = 100, conditions = {}}
defaultdata[7] = {health = 100, conditions = {}}

local MedicalConditions = {}

function SCHEMA:GetMedicalEnums()
	return MedicalEnums
end

function SCHEMA:CanCure(uniqueID, cure)
	return (MedicalConditions[uniqueID].treatment == cure)
end

function SCHEMA:RegisterMedicalCondition(uniqueID, sTreatment, sName, tValidEnums)
	MedicalConditions[uniqueID] = {name = sName, treatment = sTreatment, validenums = tValidEnums}
end

function SCHEMA:GetMedicalCondition(uniqueID)
	return MedicalConditions[uniqueID]
end

local playerMeta = FindMetaTable("Player")

function playerMeta:GetDR(damage) -- multiplier for damage n shit yo
	local damage = damage or 0
	local olddamage = damage
	local DT, DR = 0, 0
	for itemID, data in pairs(self:GetEquippedItems()) do
		local itemTable = nut.item.Get(itemID)
		if (itemTable) then
			DT = DT + (data.dt or itemTable.dt or 0)
			DR = DR + (data.dr or itemTable.reduction or 0)
		end
	end

	DR = DR * 100

	damage = damage * ((100 - math.min(DR, 85)) / 100)
	damage = math.max(damage - DT, damage * 0.2)

	--print(damage, olddamage, damage/olddamage)

	return damage/olddamage
end

function playerMeta:GetHitgroups()
	return von.deserialize(self:GetNetVar("MedicalData", von.serialize(defaultdata)))
end

function playerMeta:GetHitgroup(hitgroup)
	return von.deserialize(self:GetNetVar("MedicalData", von.serialize(defaultdata)))[hitgroup]
end

function playerMeta:HasMedicalCondition(uniqueID)
	for _, v in pairs(self:GetHitgroups()) do
		for condition, __ in pairs(v.conditions) do
			if condition == uniqueID then
				return true
			end
		end
	end

	return false
end

function playerMeta:GetMedicalConditions()
	local data = {}

	for k, v in pairs(self:GetHitgroups()) do
		local count = 0
		for l, b in pairs(v.conditions) do
			count = count + 1
		end

		if count != 0 then
			data[k] = v.conditions
		end
	end

	if (data != {}) then
		return data
	else
		return false
	end
end

if (SERVER) then
	hook.Add("EntityTakeDamage", "MedicalDamage", function(client, damageinfo)
		if (client:IsPlayer()) then
			if (damageinfo:IsFallDamage()) then
				if (math.random(1, 3) > 2) then
					client:ApplyHitgroupDamage(6, damageinfo:GetDamage()*2, "fracture")
				end
	
				if (math.random(1, 3) > 2) then
					client:ApplyHitgroupDamage(7, damageinfo:GetDamage()*2, "fracture")
				end
	
				client:ApplyHitgroupDamage(6, damageinfo:GetDamage()*2)
				client:ApplyHitgroupDamage(7, damageinfo:GetDamage()*2)
					
			elseif (damageinfo:GetDamageType() == DMG_BURN) then
				for i = 1, 7 do
					local rand = math.random(0, 3)
					if (client:GetHitgroup(i).health < 75) then
						client:ApplyHitgroupDamage(i, damageinfo:GetDamage()*rand, "burned2")
					else
						client:ApplyHitgroupDamage(i, damageinfo:GetDamage()*rand, "burned")
						client:RemoveHitgroupDamage(i, 0, "burned2")
					end
				end
			end
			local medicsuit = false
			for k, v in pairs(client:GetEquippedItems()) do
				local itemTable = nut.item.Get(k)
				if (itemTable) then
					if (itemTable.medicsuit) then
						medicsuit = true
					end
				end
			end

			local treated = 0
			if (medicsuit) then
				if (client:Health() < 70) then
					treated = 1
					for _, inv in pairs(client:GetInventoryBags()) do
						for itemID, items in pairs(inv.bag) do
							local itemTable = nut.item.Get(itemID)
							for __, item in pairs(items) do
								local itemTable = nut.item.Get(itemID)
								if (itemID == "Stimpak") then
									if (client:Health() < 70) then
										client:AdministerChem("Stimpak")
										treated = 2
										client:UpdateInv(itemID, -1, item.data, true, false, false, inv.bag)
									end
								end
							end
						end
					end
				end
			end

			if !client.combattime or client.combattime < CurTime() then
				if (client.character:GetData("voiceset")) then
					client:SendSound(table.Random(SCHEMA.Voicesets[client.character:GetData("voiceset")]["entercombat"]))
				end
			end
			client.combattime = CurTime() + 120

			if (medicsuit and (treated == 1)) then
				if !client.nextva or client.nextva < CurTime() then
					if (client.character:GetData("voiceset")) then
						client:SendSound(table.Random(SCHEMA.Voicesets[client.character:GetData("voiceset")]["injectmedsfail"]))
					end
					client.nextva = CurTime() + 10
				end
			elseif (medicsuit and (treated == 2)) then
				if !client.nextva or client.nextva < CurTime() then
					if (client.character:GetData("voiceset")) then
						client:SendSound(table.Random(SCHEMA.Voicesets[client.character:GetData("voiceset")]["injectmeds"]))
					end
					client.nextva = CurTime() + 10
				end
			end

			damageinfo:ScaleDamage(client:GetDR(damageinfo:GetDamage()))
		end
	end)

	hook.Add("ScalePlayerDamage", "MedicalDamagePlayer", function(client, hitgroup, damageinfo)
		if (damageinfo:IsExplosionDamage()) then
			for i = 1, 3 do
				local rand = math.random(1, 7)
				client:ApplyHitgroupDamage(rand, damageinfo:GetDamage()*2, "burned")
			end
			client:ApplyHitgroupDamage(2, damageinfo:GetDamage()*2, "burned")

			for i = 1, 3 do
				local rand = math.random(1, 7)
				client:ApplyHitgroupDamage(rand, damageinfo:GetDamage(), "bleeding")
				client:ApplyHitgroupDamage(rand, 0, "shrapnel")
			end
			client:ApplyHitgroupDamage(2, damageinfo:GetDamage(), "bleeding")
			client:ApplyHitgroupDamage(2, 0, "shrapnel")
		elseif (damageinfo:GetAttacker():IsPlayer() and damageinfo:GetAttacker():GetActiveWeapon():GetClass() == "nut_fists") then
			if (hitgroup == 1) then
				client:ApplyHitgroupDamage(hitgroup, damageinfo:GetDamage()*3, "bruise")
				if client:GetHitgroup(hitgroup).health < 50 then
					client:ApplyHitgroupDamage(hitgroup, damageinfo:GetDamage(), "nosebreak")
				end
			elseif (hitgroup == 4 or hitgroup == 5) then
				client:ApplyHitgroupDamage(hitgroup, damageinfo:GetDamage()*2, "bruise")
				if client:GetHitgroup(hitgroup).health < 50 then
					client:ApplyHitgroupDamage(hitgroup, damageinfo:GetDamage(), "fracture")
				end
			else
				client:ApplyHitgroupDamage(hitgroup, damageinfo:GetDamage()*3, "bruise")
			end
		elseif (damageinfo:GetAttacker():IsPlayer() and damageinfo:GetAttacker():GetActiveWeapon():GetClass() == "weapon_crowbar") then -- change this to machette/knife type melee
			if (hitgroup == 1) then
				client:ApplyHitgroupDamage(hitgroup, damageinfo:GetDamage()*3, "bruise")
				if client:GetHitgroup(hitgroup).health < 50 then
					client:ApplyHitgroupDamage(hitgroup, damageinfo:GetDamage(), "nosebreak")
				end
			elseif (hitgroup == 4 or hitgroup == 5) then
				client:ApplyHitgroupDamage(hitgroup, damageinfo:GetDamage()*2, "bruise")
				if client:GetHitgroup(hitgroup).health < 50 then
					client:ApplyHitgroupDamage(hitgroup, damageinfo:GetDamage(), "lacerations")
				end
			else
				client:ApplyHitgroupDamage(hitgroup, damageinfo:GetDamage()*3, "bruise")
			end
		elseif (damageinfo:IsBulletDamage()) then
			if (damageinfo:GetAttacker():IsPlayer() and damageinfo:GetAttacker():GetActiveWeapon():GetClass() == "weapon_ar2") then -- do laser too btw
				client:ApplyHitgroupDamage(hitgroup, damageinfo:GetDamage()*3, "plasma")
			else
				client:ApplyHitgroupDamage(hitgroup, damageinfo:GetDamage(), "gunshot")
				client:ApplyHitgroupDamage(hitgroup, damageinfo:GetDamage(), "bleeding")
	
				rand = math.random(1, 50)
				if (rand > 50) then
					client:ApplyHitgroupDamage(hitgroup, damageinfo:GetDamage(), "fracture")
				end
			end
		end
	end)

	function playerMeta:SetupHitgroups()
		self:SetNetVar("MedicalData", von.serialize(defaultdata))
	end

	function playerMeta:ApplyHitgroupDamage(hitgroup, damage, condition)
		if (!hitgroup or !damage or !condition) then
			return
		end

		hitgroup = math.Clamp(hitgroup, 1, 7)
		
		local damage = math.floor(damage)
		local data = self:GetHitgroups()
		local conditions = data.conditions
		local hitgroup = hitgroup or 3
		if (condition) then
			if (!data[hitgroup].conditions) then
				data[hitgroup].conditions = {}
			end
			data[hitgroup].conditions[condition] = true
		end

		data[hitgroup].health = math.Clamp(data[hitgroup].health - damage, 0, 100)

		self:SetNetVar("MedicalData", von.serialize(data))
		self:CrippleLimbs()
	end

	function playerMeta:CrippleLimbs()
		for k, v in pairs(self:GetHitgroups()) do
			if (v.health == 0) then
				v.conditions["crippled"] = true
			end
		end
	end

	function playerMeta:HealAllLimbs()
		self:SetNetVar("MedicalData", nil)
		self:SetNetVar("MedicalData", von.serialize(defaultdata))
		self:RemoveBuff("leghurt")
	end

	function playerMeta:RemoveHitgroupDamage(hitgroup, damage, condition)
		local data = von.deserialize(self:GetNetVar("MedicalData", von.serialize(defaultdata)))

		if (condition) then
			data[hitgroup].conditions[condition] = nil
		end

		data[hitgroup].health = math.Clamp(data[hitgroup].health + damage, 0, 100)
		self:SetNetVar("MedicalData", von.serialize(data))
	end
end