util.AddNetworkString("forp_clothesupdate") 

netstream.Hook("nut_ToggleRadio", function(client, data)
	local index = data[1]
	local On = data[2]
	local item = client:GetItem("radio", index)

	if (item) then
		local data = table.Copy(item.data or {})
		data.On = On

		client:UpdateInv("radio", -1, item.data)
		client:UpdateInv("radio", 1, data)
	end
end)

netstream.Hook("nut_RequestItemRemoval", function(client, data)
	if (!client:IsSuperAdmin()) then
		return
	end

	data.target:UpdateInv(data.itemuid, -1, data.itemdata)

	if (!data.destroy) then
		if (data.Equipped) then
			data.Equipped = false
		end

		client:UpdateInv(data.itemuid, 1, data.itemdata, true)
	end
end)

netstream.Hook("nut_ModifyItem", function(client, data)
	if !client:IsAdmin() then
		return
	end

	local uniqueid, index = data[1], data[2]
	local item = client:GetItem(uniqueid, index)
	local customdata = data[3]

	if (item) then
		local data = table.Copy(item.data or {})
		data.custom = customdata
		client:UpdateInv(uniqueid, -1, item.data, true)
		client:UpdateInv(uniqueid, 1, data, true)
	end
end)

SCHEMA.ClothesTable = SCHEMA.ClothesTable or {}
SCHEMA.GearTable = SCHEMA.GearTable or {}

hook.Add("PlayerSpawn", "SetupClothes", function(client)
	if !(client.spawned) then
		SCHEMA:PushClothesTable(client)
	end

	if client.character:GetData("currency_1") and !client.character:GetData("fixed") then
		for k, v in pairs({"Suit", "Fullhat", "Helmet", "Hat", "Mask", "Glasses"}) do
			client.character:SetData(v, nil)
		end
		client.character:SetData("fixed", true)
	end

	client:setupCurrencies()

	if (client.spawned) then
		for k, target in pairs(player.GetAll()) do
			netstream.Start(target, "nut_drawclothes", {client})
		end
	end

	net.Start("forp_clothesupdate")
	net.WriteInt(CLOTHES_DRAW, 4)
	net.WriteEntity(client)
	net.Broadcast()

	netstream.Start(client, "nut_spawned", false)

	SCHEMA:PushClothesWipeEvent(client)
	SCHEMA.ClothesTable[client] = {}
end)

hook.Add("PlayerLoadout", "GenderCheck", function(client)
	if (!client.character:GetData("Suit")) then
		SCHEMA:PushClothesUpdate(client, "default")
	elseif (type(client.character:GetData("Suit")) == "string") then
		local item = nut.item.Get(client.character:GetData("Suit"))

		SCHEMA:PushClothesUpdate(client, item.ClothesTable)
	end
	
	local inventory = client:GetInventory()
	for itemID, items in pairs(inventory) do
		for k, itemData in pairs(items) do
			local item = nut.item.Get(itemID)
			if item and item.ClothesTable then
				if itemData and itemData.data and itemData.data.Equipped then
					SCHEMA:PushClothesUpdate(client, item.ClothesTable)
				end
			end
		end
	end

	client:SetWalkSpeed(nut.config.walkSpeed)
	client:SetRunSpeed(nut.config.runSpeed)
	client:SetModelScale(1, 1) 
	client.spawned = true
	client:UpdateRobot()
	
	if (!client:IsRobot() and !client:IsMutant() or client:IsGhoul()) then
		if (client.character:GetData("eyecolor")) then
			local gender = client:GetGender()
			local index = 3
	
			if (gender == "female") then
				index = 1
			end
	
			if (!client:IsGhoul()) then
				client:SetSubMaterial(index, "models/lazarus/shared/"..SCHEMA.EyeTable[client.character:GetData("eyecolor")].mat)
			else
				client:SetSubMaterial(0, nil)
				client:SetSubMaterial(1, nil)
				client:SetSubMaterial(2, nil)
				client:SetSubMaterial(3, nil)
			end
		else
			local gender = client:GetGender()
			local index = 3
	
			if (gender == "female") then
				index = 1
			end

			if (!client:IsGhoul()) then
				client:SetSubMaterial(index, "models/lazarus/shared/"..SCHEMA.EyeTable[1].mat)
			else
				client:SetSubMaterial(0, nil)
				client:SetSubMaterial(1, nil)
				client:SetSubMaterial(2, nil)
				client:SetSubMaterial(3, nil)
			end
		end
	
		if (client.character:GetData("facemap")) then
			if (client:GetGender() == "female") then
				local face = (client.character:GetData("facemap") + 1)
				
				if (!client:IsGhoul()) then
					client:SetSubMaterial(0, "models/lazarus/female/"..SCHEMA.FemaleFaces[client:GetRace()][face])
				else
					client:SetSkin(client.character:GetData("facemap") or 0)
				end

			elseif (client:GetGender() == "male") then
				local face = (client.character:GetData("facemap") + 1)
				
				if (!client:IsGhoul()) then
					client:SetSubMaterial(0, "models/lazarus/male/"..SCHEMA.MaleFaces[client:GetRace()][face])
				else
					client:SetSkin(client.character:GetData("facemap") - 1)
				end
			end
		end

		if (client.character:GetData("hair")) then
			client:SetBodygroup(2, client.character:GetData("hair"))
		else
			client:SetBodygroup(2, 1)
		end
	
		if (client.character:GetData("haircolor")) then
			if (!client:IsGhoul()) then
				client:SetColor(SCHEMA.HairTable[client.character:GetData("haircolor")].color)
			else
				client:SetColor(Color(255,255,255,255))
			end
		else
			client:SetColor(Color(255,255,255,255))
		end
	
		if (client.character:GetData("facialhair")) then
			client:SetBodygroup(3, client.character:GetData("facialhair"))
		else
			client:SetBodygroup(3, 0)
		end
	else
		client:SetColor(Color(255,255,255))
		client:SetSubMaterial(0, nil)
		client:SetSubMaterial(1, nil)
		client:SetSubMaterial(3, nil)
		client:SetMaterial(nil)
		client:SetBodyGroups("000000000")
		client:SetSkin(client.character:GetData("facemap"))
	end

	if (string.find(string.lower(client:GetModel()), "dogs")) then
		client:SetViewOffset(Vector(0,0,28))
	elseif (string.find(string.lower(client:GetModel()), "supermutant")) then
		client:SetViewOffset(Vector(0,0,88))
		if (string.find(string.lower(client:GetModel()), "behemoth")) then
			client:SetViewOffset(Vector(0,0,200))
		end
	else
		client:SetViewOffset(Vector(0,0,64))
	end


end)

function SCHEMA:FindSpawnDestination(client, id)
	
	--iterate through all things, find avaliable spawn.
	if not SCHEMA.SpawnIndex[id] then
		--print("SCHEMA.SpawnIndex[" .. id .. "] not set!")
		return nil
	end
	
	local temp = SCHEMA.Spawns[SCHEMA.SpawnIndex[id]][1]
	for k,v in pairs(SCHEMA.Spawns[SCHEMA.SpawnIndex[id]]) do
		local tr = {
			start = v,
			endpos = v,
			mins = Vector(-16, -16, 0),
			maxs = Vector(16, 16, 74), -- give some room over the head
			filter = client
		}
		local traceres = util.TraceHull(tr)
		if not traceres.Hit then
			-- valid spawn
			--print("found valid spawn " .. tostring(v))
			return v + vector_up * 5
		end
	end
	
	--print("no valid spawn found, using " .. tostring(temp))
	return temp + vector_up * 5
end

-- teleport a player to a teleport destination
function SCHEMA:TeleportPlayer(UID, client)
	for _, ent in pairs(ents.FindByClass("forp_teleportdestination")) do
		if ent:GetUID() == UID then
			netstream.Start(client, "nut_Teleporting", false)
			client:ScreenFade(SCREENFADE.OUT, Color(0,0,0), 1, 0.5)
			client:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
			client:EmitSound("doors/latchunlocked1.wav")

			timer.Simple(1, function()
				client:SetPos(ent:GetPos() + Vector(0,0,10))
				client:SetEyeAngles(Angle(0, ent:GetAngles().yaw - 90, 0))
				client:ScreenFade(SCREENFADE.IN, Color(0,0,0), 1, 0.5)

				timer.Simple(0.75, function()
					client:EmitSound("doors/door_wood_close1.wav")
				end)

				timer.Simple(1.5, function()
					netstream.Start(client, "nut_Teleporting", true)
				end)
				
				timer.Simple(10, function()
					client:SetCollisionGroup(COLLISION_GROUP_PLAYER)
				end)
			end)

			return
		end
	end
end

-- Push the entire table to a specific client
function SCHEMA:PushClothesTable(target)
	net.Start("forp_clothesupdate")

	net.WriteInt(CLOTHES_FULLUPDATE, 4)
	net.WriteEntity()
	net.WriteString(von.serialize(SCHEMA.ClothesTable))

	net.Send(target)
end

function SCHEMA:PlayerSpray()
	return false
end 

function SCHEMA:PushClothesPurgeEvent()
	net.Start("forp_clothesupdate")
	net.WriteInt(CLOTHES_PURGE, 4)
	net.Broadcast()
end

function SCHEMA:PushClothesRemoveUpdate(target, clothestable)
	SCHEMA.ClothesTable[target][clothestable.Type] = nil

	net.Start("forp_clothesupdate")
	net.WriteInt(CLOTHES_REMOVE, 4)
	net.WriteEntity(target)
	net.WriteString(von.serialize(clothestable))

	net.Broadcast()
end

-- Updates the clothing for all connected clients and future clients
function SCHEMA:PushClothesUpdate(target, clothestable, svensis)
	local data 

	if clothestable == "default" then
		clothestable = {Type = "Suit", model = nut.config.defaultModel}
	end

	if type(SCHEMA.ClothesTable[target]) != "table" then
		SCHEMA.ClothesTable[target] = {}
	end

	if type(clothestable.model) == "string" then
		if file.Exists(clothestable.model.."arms/", "GAME") then
			local arms = {Type = "Arms", skin = target.character:GetData("facemap", 0), model = clothestable.model.."arms/"}
			SCHEMA.ClothesTable[target]["Arms"] = arms
			
			net.Start("forp_clothesupdate")
			net.WriteInt(CLOTHES_PARTIALUPDATE, 4)
			net.WriteEntity(target)
			net.WriteString(von.serialize(arms))
		
			net.Broadcast()
		end
	elseif type(clothestable.model) == "table" then
		if (clothestable.model.armdir) then
			if file.Exists(clothestable.model.armdir, "GAME") then
				local arms = {Type = "Arms", skin = target.character:GetData("facemap", 0), model = clothestable.model.armdir}
				net.Start("forp_clothesupdate")
				net.WriteInt(CLOTHES_PARTIALUPDATE, 4)
				net.WriteEntity(target)
				net.WriteString(von.serialize(arms))
			
				net.Broadcast()
			end
		end
	end

	
	SCHEMA.ClothesTable[target][clothestable.Type] = clothestable

	net.Start("forp_clothesupdate")
	net.WriteInt(CLOTHES_PARTIALUPDATE, 4)
	net.WriteEntity(target)
	net.WriteString(von.serialize(clothestable))
	if clothestable.Type == "Suit" then
	print"teest"
	if isstring(clothestable.model) == true then
	print"teest2"
		net.WriteString(clothestable.model.."arms/" .. target:GetGender() .. "_arm.mdl")
	else
	print"teest3"

			net.WriteString(clothestable.model.armdir.. target:GetGender() .. "_arm.mdl")
			print(clothestable.model.armdir.. target:GetGender() .. "_arm.mdl")

	end
	else
	net.WriteString("NOPE")
	print"nigga"
	end


	net.Broadcast()

end

function SCHEMA:PushClothesWipeEvent(target)
	local data = {}
	data[1] = CLOTHES_WIPE
	data[2] = target

	for _, client in pairs(player.GetAll()) do
		netstream.Start(client, "nut_clothesupdate", data)
	end

	net.Start("forp_clothesupdate")
	net.WriteInt(CLOTHES_WIPE, 4)
	net.WriteEntity(target)
	net.Broadcast()
end

function SCHEMA:PushClothesDisconnectEvent(target)
	local data = {}
	data[1] = CLOTHES_DISCONNECTUPDATE
	data[2] = target

	for _, client in pairs(player.GetAll()) do
		netstream.Start(client, "nut_clothesupdate", data)
	end

	net.Start("forp_clothesupdate")
	net.WriteInt(CLOTHES_DISCONNECTUPDATE, 4)
	net.WriteEntity(target)
	net.Broadcast()
end

hook.Add("PlayerDisconnected", "DeloadClothes", function(client)
	SCHEMA.ClothesTable[client] = nil
	SCHEMA.GearTable[client] = nil
	SCHEMA:PushClothesDisconnectEvent(client)
end)

netstream.Hook("nut_RequestItemTransfer", function(client, data)
	local maxWeight = client:GetBagByMeta(data.receiverBag).maxWeight

	data.targetBag = client:GetInventoryByBag(data.targetBag)
	data.receiverBag = client:GetInventoryByBag(data.receiverBag)

	if (data.targetItemData.Equipped) then
		return
	end
	
	if (data.targetBag == data.receiverBag) then
		return
	end

	local itemTable = nut.item.Get(data.targetUniqueID)

	if (itemTable.isBag) then
		return
	end

	local weight = client:GetInvWeight(data.receiverBag)

	if weight + itemTable:GetWeight(data.targetItemData) > maxWeight then
		return
	end

	if (data.targetBag and data.receiverBag) then
		if (client:HasItem(data.targetUniqueID, data.targetBag)) then
			client:UpdateInv(data.targetUniqueID, -1, data.targetItemData, true, false, false, data.targetBag)
			client:UpdateInv(data.targetUniqueID, 1, data.targetItemData, true, false, false, data.receiverBag)
		end
	end
end)

netstream.Hook("nut_PatDown", function(client)
	local data = {}
		data.start = client:GetShootPos()
		data.endpos = data.start + client:GetAimVector()*96
		data.filter = client
	local trace = util.TraceLine(data)
	local target = trace.Entity

	if (target:GetNetVar("player")) then
		target = target:GetNetVar("player")
	end
	
	if (IsValid(target) and target:IsPlayer()) then
		local i = 0

		target:SetMainBar("You are being patted down by "..client:Name()..".", 5)
		client:SetMainBar("You are patting down "..target:Name()..".", 5)

		local uniqueID = "nut_PattingDown"..target:UniqueID()

		timer.Create(uniqueID, 0.25, 20, function()
			i = i + 1

			if (!IsValid(client) or client:GetEyeTraceNoCursor().Entity != target or target:GetPos():Distance(client:GetPos()) > 128) then
				if (IsValid(target)) then
					target:SetMainBar()				
				end

				if (IsValid(client)) then
					client:SetMainBar()
				end

				timer.Remove(uniqueID)

				return
			end

			if (i == 20) then
				local invdata = {}
				invdata.target = target
				invdata.inventory = target:GetInventory()

				netstream.Start(client, "InspectInventory", invdata)
			end
		end)
	end
end)

netstream.Hook("nut_UnZipTie", function(client)
	local data = {}
		data.start = client:GetShootPos()
		data.endpos = data.start + client:GetAimVector()*96
		data.filter = client
	local trace = util.TraceLine(data)
	local target = trace.Entity

	if (target:IsPlayer() and target:GetNetVar("tied")) then
		if (target:GetNutVar("beingTied") or target:GetNutVar("beingUnTied")) then
			nut.util.Notify("You can not untie this player right now.", client)

			return false
		end

		local i = 0

		target:SetMainBar("You are being untied by "..client:Name()..".", 5)
		target:SetNutVar("beingUnTied", true)
		client:SetMainBar("You are untieing "..target:Name()..".", 5)

		local uniqueID = "nut_UnTieing"..target:UniqueID()

		timer.Create(uniqueID, 0.25, 20, function()
			i = i + 1

			if (!IsValid(client) or client:GetEyeTraceNoCursor().Entity != target or target:GetPos():Distance(client:GetPos()) > 128) then
				if (IsValid(target)) then
					target:SetMainBar()
					target:SetNutVar("beingUnTied", false)
				end

				if (IsValid(client)) then
					client:SetMainBar()
				end

				timer.Remove(uniqueID)

				return
			end

			if (i == 20) then
				target:SetNetVar("tied", false)

				local weapons = target:GetNutVar("tiedWeapons", {})

				for k, v in pairs(weapons) do
					target:Give(v)
				end

				target:SetNutVar("tiedWeapons", nil)
				target:SetNutVar("beingUnTied", false)

				client:UpdateInv("ziptie")
			end
		end)
	end
end)

netstream.Hook("nut_ZipTie", function(client)
	if (!client:HasItem("ziptie")) then
		return
	else
		client:UpdateInv("ziptie", -1)
	end

	local data = {}
		data.start = client:GetShootPos()
		data.endpos = data.start + client:GetAimVector()*96
		data.filter = client
	local trace = util.TraceLine(data)
	local target = trace.Entity

	if (target:GetNetVar("player")) then
		target = target:GetNetVar("player")
	end
	
	if (IsValid(target) and target:IsPlayer()) then
		if (target:GetNutVar("beingTied") or target:GetNutVar("beingUnTied")) then
			nut.util.Notify("You can not tie this player right now.", client)

			return false
		end

		local i = 0

		target:SetMainBar("You are being tied by "..client:Name()..".", 5)
		target:SetNutVar("beingTied", true)
		client:SetMainBar("You are tieing "..target:Name()..".", 5)

		local uniqueID = "nut_Tieing"..target:UniqueID()

		timer.Create(uniqueID, 0.25, 20, function()
			i = i + 1

			if (!IsValid(client) or client:GetEyeTraceNoCursor().Entity != target or target:GetPos():Distance(client:GetPos()) > 128) then
				if (IsValid(target)) then
					target:SetMainBar()
					target:SetNutVar("beingTied", false)
				end

				if (IsValid(client)) then
					client:SetMainBar()
					client:UpdateInv("ziptie")
				end

				timer.Remove(uniqueID)

				return
			end

			if (i == 20) then
				target:SetNetVar("tied", true)

				local weapons = {}

				for k, v in pairs(target:GetWeapons()) do
					weapons[#weapons + 1] = v:GetClass()
				end

				target:SetNutVar("tiedWeapons", weapons)
				target:StripWeapons()
				target:SetNutVar("beingTied", false)
			end
		end)
	end
end)

netstream.Hook("nut_ThrowNade", function(client, nadeid)
	local nadeinfo = client:HasItemRecursive(nadeid)
	PrintTable(nadeinfo)
	PrintTable(client:GetBagByMeta(nadeinfo.meta))
	if (nadeinfo) then
		if (nadeinfo.meta != "default") then
			client:UpdateInv(nadeinfo.uniqueID, -1, {}, true, false, false, client:GetInventoryByBag(nadeinfo.meta))
		else
			client:UpdateInv(nadeinfo.uniqueID, -1, {})
		end
	end

	local itemTable = nut.item.Get(nadeid)
	local grd = ents.Create( itemTable.throwent )
	grd:SetPos( client:EyePos() + client:GetAimVector() * 50 )
	grd:Spawn()

	local phys = grd:GetPhysicsObject()
	phys:SetVelocity( client:GetAimVector() * itemTable.throwforce * math.Rand( .8, 1 ) )
	phys:AddAngleVelocity( client:GetAimVector() * itemTable.throwforce  )
end)

netstream.Hook("nut_CheckCondition", function(client)
	local data = {}
		data.start = client:GetShootPos()
		data.endpos = data.start + client:GetAimVector()*96
		data.filter = client
	local trace = util.TraceLine(data)
	local target = trace.Entity

	if (target and target:IsPlayer()) then
		local info = {}
		info.target = target
		info.medinfo = target:GetHitgroups()
		netstream.Start(client, "nut_OpenCondition", info)
	end
end)

netstream.Hook("nut_RequestDesc", function(client)
	client:StringRequest("Change Description", "Entire your desired description.", function(text2)
		text = text2
		if (!text) then
			nut.util.Notify("You provided an invalid description.", client)
			
			return
		end

		if (#text < nut.config.descMinChars) then
			nut.util.Notify("Your description needs to be at least "..nut.config.descMinChars.." character(s).", client)
			return
		end
		
		local description = client.character:GetVar("description", "")
		
		if (string.lower(description) == string.lower(text)) then
			nut.util.Notify("You need to provide a different description.", client)
			
			return
		end
		
		client.character:SetVar("description", text)
		nut.util.Notify("You have changed your character's description.", client)
	end, nil, client.character:GetVar("description", ""))
end)


local doorinfo = {
	[1] = {pos = Vector("-5034.302734 7069.440430 3420.219971"), angs = Angle("-3.214 -78.057 0.307"), uid = "scraphouse1", Type = "Door", dest = "Scrap House"},
	[2] = {pos = Vector("-5031.855957 7035.423828 6316.427246"), angs = Angle("-0.309 -179.447 0.033"), uid = "scraphouse1a", Type = "Door", dest = "The Mojave Wasteland"},
	[3] = {pos = Vector("4941.588379 7098.993652 -2764.403564"), angs = Angle("0.000 89.950 0.185"), uid = "helioscollection", Type = "Door", dest = "HELIOS Solar Collection Tower"},
	[4] = {pos = Vector("-10619.257813 12577.838867 6300.423340"), angs = Angle("-0.000 90.000 0.000"), uid = "exfreesidebld1", Type = "Door", dest = "The Mojave Wasteland"},
	[5] = {pos = Vector("-10046.288086 13131.856445 3420.503662"), angs = Angle("-0.680 -90.014 -0.004"), uid = "entfreesidebld1", Type = "Door", dest = "Office Building"},
	[6] = {pos = Vector("5642.168945 6188.649902 -1233.908081"), angs = Angle("-0.000 0.741 0.000"), uid = "helioscollectionexit", Type = "Door", dest = "The Mojave Wasteland"},
	[7] = {pos = Vector("-4864.134277 6282.450195 3416.552490"), angs = Angle("-0.045 68.465 -0.591"), uid = "scraphouse2", Type = "Door", dest = "Scrap House"},
	[8] = {pos = Vector("-10094.763672 13131.879883 3420.273682"), angs = Angle("-0.696 -89.988 0.082"), uid = "entfreesidebld1", Type = "Door", dest = "Office Building"},
	[9] = {pos = Vector("8177.385742 11956.752930 3400.475098"), angs = Angle("-0.019 -0.097 89.907"), uid = "10001", Type = "Door", dest = "Nipton Town Hall"},
	[10] = {pos = Vector("-6108.123535 6943.663574 6316.296875"), angs = Angle("-0.001 90.000 -0.010"), uid = "scraphouse2a", Type = "Door", dest = "The Mojave Wasteland"},
	[11] = {pos = Vector("10946.057617 -10109.187500 4193.208008"), angs = Angle("1.873 0.020 -90.216"), uid = "ncroutpost1", Type = "Door", dest = "Mojave Outpost Office"},
	[12] = {pos = Vector("6291.022949 10320.507813 6449.935059"), angs = Angle("0.014 179.961 90.472"), uid = "10002", Type = "Door", dest = "The Mojave Wasteland"},
	[13] = {pos = Vector("11091.996094 8406.458008 3157.494873"), angs = Angle("0.105 89.900 -0.178"), uid = "americanville1", Type = "Door", dest = "Americanville House"},
	[14] = {pos = Vector("-11962.451172 12127.618164 3390.047852"), angs = Angle("-0.000 -1.760 90.000"), uid = "GR", Type = "Door", dest = "Gun Runners HQ"},
	[15] = {pos = Vector("-4784.192871 4910.283203 13366.940430"), angs = Angle("-0.000 180.000 -90.000"), uid = "bob", Type = "Door", dest = "Freeside"},
	[16] = {pos = Vector("5164.706543 10319.539063 6499.884766"), angs = Angle("-0.005 179.951 -90.016"), uid = "10003", Type = "Door", dest = "The Mojave Wasteland"},
	[17] = {pos = Vector("10042.927734 -11267.531250 7284.219238"), angs = Angle("0.070 90.168 -0.298"), uid = "ncroutpost1a", Type = "Door", dest = "The Mojave Wasteland"},
	[18] = {pos = Vector("8868.415039 6800.219727 -2696.953125"), angs = Angle("-0.002 0.005 0.097"), uid = "heliosinterior1", Type = "Door", dest = "HELIOS One"},
	[19] = {pos = Vector("6923.176758 11956.074219 3386.486328"), angs = Angle("-2.573 0.001 89.352"), uid = "10004", Type = "Door", dest = "Nipton Town Hall"},
	[20] = {pos = Vector("-3031.169189 7797.477051 6325.617188"), angs = Angle("-0.001 -0.004 0.061"), uid = "americanville1a", Type = "Door", dest = "The Mojave Wasteland"},
	[21] = {pos = Vector("8118.367676 7080.788574 -2697.028320"), angs = Angle("-0.009 89.992 0.120"), uid = "heliosinterior1", Type = "Door", dest = "HELIOS One"},
	[22] = {pos = Vector("6666.614258 5370.000488 -2696.878418"), angs = Angle("-0.000 179.956 0.037"), uid = "heliosinterior2", Type = "Door", dest = "HELIOS One"},
	[23] = {pos = Vector("-13303.967773 9141.942383 6515.989258"), angs = Angle("0.019 90.000 0.006"), uid = "Gun", Type = "Door", dest = "The Mojave Wasteland"},
	[24] = {pos = Vector("9015.736328 11553.744141 3418.499756"), angs = Angle("-6.407 89.926 -0.087"), uid = "10006", Type = "Door", dest = "Nipton House"},
	[25] = {pos = Vector("-1617.423218 5368.573730 2080.840820"), angs = Angle("-0.028 -90.023 -0.766"), uid = "heliosexterior1", Type = "Door", dest = "The Mojave Wasteland"},
	[26] = {pos = Vector("8857.463867 10333.268555 6262.504395"), angs = Angle("-0.049 -180.000 -0.001"), uid = "10005", Type = "Door", dest = "The Mojave Wasteland"},
	[27] = {pos = Vector("-1573.021118 2844.585449 1692.316162"), angs = Angle("-0.018 89.957 0.051"), uid = "heliosexterior2", Type = "Door", dest = "The Mojave Wasteland"},
	[28] = {pos = Vector("11604.484375 -9016.336914 4193.969727"), angs = Angle("-0.002 92.023 -89.116"), uid = "ncroutpost2", Type = "Door", dest = "Mojave Outpost Office"},
	[29] = {pos = Vector("9991.951172 11423.122070 3424.658447"), angs = Angle("1.950 1.196 0.008"), uid = "10007", Type = "Door", dest = "Nipton General Store"},
	[30] = {pos = Vector("8872.169922 8908.275391 6292.009766"), angs = Angle("-0.221 90.472 0.021"), uid = "10008", Type = "Door", dest = "The Mojave Wasteland"},
	[31] = {pos = Vector("11003.944336 -9310.491211 6516.161621"), angs = Angle("0.032 89.939 -0.100"), uid = "ncroutpost2a", Type = "Door", dest = "The Mojave Wasteland"},
	[32] = {pos = Vector("10549.726563 11567.769531 3414.387207"), angs = Angle("-0.135 -179.226 -0.021"), uid = "10012", Type = "Door", dest = "Nipton House"},
	[33] = {pos = Vector("11692.331055 8865.973633 3158.574951"), angs = Angle("0.057 -92.228 -0.126"), uid = "americanville3a", Type = "Door", dest = "Americanville House"},
	[34] = {pos = Vector("-2060.282715 -2519.605957 -3091.391846"), angs = Angle("0.002 -178.463 0.073"), uid = "hiddenvalleybunkerinterior", Type = "Door", dest = "Hidden Valley Bunker"},
	[35] = {pos = Vector("-4916.199707 7618.923340 6325.700684"), angs = Angle("0.000 -0.045 -0.005"), uid = "americanville3", Type = "Door", dest = "The Mojave Wasteland"},
	[36] = {pos = Vector("7618.495605 10876.849609 6288.074707"), angs = Angle("0.000 0.000 0.000"), uid = "10011", Type = "Door", dest = "The Mojave Wasteland"},
	[37] = {pos = Vector("-10260.626953 11669.221680 3411.505859"), angs = Angle("-0.000 90.000 0.000"), uid = "OB", Type = "Door", dest = "Office Building"},
	[38] = {pos = Vector("-10206.881836 11669.162109 3405.387207"), angs = Angle("0.000 90.000 -0.000"), uid = "OB", Type = "Door", dest = "Office Building"},
	[39] = {pos = Vector("11760.650391 7052.247070 3172.507080"), angs = Angle("-0.000 180.000 0.000"), uid = "americanville4a", Type = "Door", dest = "Americanville House"},
	[40] = {pos = Vector("-5784.910645 6761.792969 7559.553223"), angs = Angle("0.000 180.000 0.000"), uid = "1b", Type = "Door", dest = "The Atomic Wrangler"},
	[41] = {pos = Vector("10586.240234 12715.208008 3414.172607"), angs = Angle("-6.421 179.930 -0.006"), uid = "10013", Type = "Door", dest = "Nipton House"},
	[42] = {pos = Vector("-2408.177490 7079.564453 6297.054199"), angs = Angle("0.002 89.990 -0.046"), uid = "americanville4", Type = "Door", dest = "The Mojave Wasteland"},
	[43] = {pos = Vector("-12985.565430 11617.412109 6515.883301"), angs = Angle("0.004 89.998 0.170"), uid = "office", Type = "Door", dest = "The Mojave Wasteland"},
	[44] = {pos = Vector("9315.955078 10751.977539 6293.575684"), angs = Angle("-4.608 -0.104 -0.049"), uid = "10014", Type = "Door", dest = "The Mojave Wasteland"},
	[45] = {pos = Vector("-5166.481445 7182.871094 14135.526367"), angs = Angle("0.141 90.748 0.103"), uid = "1a", Type = "Door", dest = "Freeside"},
	[46] = {pos = Vector("-5581.780273 2334.080322 3158.499512"), angs = Angle("0.016 90.000 -0.000"), uid = "storage1", Type = "Door", dest = "Storage Complex"},
	[47] = {pos = Vector("-4013.930664 8878.421875 -9551.147461"), angs = Angle("0.000 -0.000 0.000"), uid = "hiddenvalleybunkerexterior", Type = "Door", dest = "The Mojave Wasteland"},
	[48] = {pos = Vector("9460.524414 9315.458008 6797.978027"), angs = Angle("0.000 -0.000 0.000"), uid = "10015", Type = "Door", dest = "The Mojave Wasteland"},
	[49] = {pos = Vector("-7005.782227 2438.475342 6515.960449"), angs = Angle("-0.023 -90.049 -0.036"), uid = "storage1a", Type = "Door", dest = "The Mojave Wasteland"},
	[50] = {pos = Vector("9887.711914 12453.771484 3414.747070"), angs = Angle("-4.579 -0.429 -0.526"), uid = "10016", Type = "Door", dest = "Nipton House"},
	[51] = {pos = Vector("8996.182617 12289.929688 3409.990967"), angs = Angle("-12.921 -89.998 -0.565"), uid = "10017", Type = "Door", dest = "Nipton House"},
	[52] = {pos = Vector("7979.774414 9565.666016 6277.473145"), angs = Angle("-3.551 -89.899 0.007"), uid = "10018", Type = "Door", dest = "The Mojave Wasteland"},
	[53] = {pos = Vector("7891.150879 10054.439453 6506.328125"), angs = Angle("0.029 89.979 0.041"), uid = "10019", Type = "Door", dest = "The Mojave Wasteland"},
	[54] = {pos = Vector("9634.677734 10865.540039 3413.099854"), angs = Angle("-0.000 90.000 0.000"), uid = "10020", Type = "Door", dest = "Nipton House"},
	[55] = {pos = Vector("-7121.011719 2187.310547 3160.392334"), angs = Angle("-0.551 -0.008 0.747"), uid = "storage2", Type = "Door", dest = "Storage Complex"},
	[56] = {pos = Vector("8733.564453 13086.531250 3414.343994"), angs = Angle("-4.542 179.537 -0.006"), uid = "10021", Type = "Door", dest = "Nipton House"},
	[57] = {pos = Vector("-8567.578125 3910.424805 6515.975586"), angs = Angle("-0.028 -90.023 0.009"), uid = "storage2a", Type = "Door", dest = "The Mojave Wasteland"},
	[58] = {pos = Vector("-3325.645752 7689.384277 7575.650391"), angs = Angle("-0.000 90.000 -90.000"), uid = "freesidebuilding1a", Type = "Door", dest = "Freeside Liquor"},
	[59] = {pos = Vector("8494.859375 8713.438477 6280.561035"), angs = Angle("0.004 -89.841 -0.006"), uid = "10022", Type = "Door", dest = "The Mojave Wasteland"},
	[60] = {pos = Vector("-12746.789063 5915.417480 -2968.221924"), angs = Angle("2.228 179.955 -89.419"), uid = "tunnel1b", Type = "Tunnel", dest = "The Mojave Wasteland"},
	[61] = {pos = Vector("-12750.492188 5914.290039 -2919.310059"), angs = Angle("3.422 180.000 -88.711"), uid = "tunnel1a", Type = "Tunnel", dest = "The Mojave Wasteland"},
	[62] = {pos = Vector("-12749.646484 6285.413086 -2926.670166"), angs = Angle("3.234 179.931 -90.959"), uid = "tunnel1c", Type = "Tunnel", dest = "The Mojave Wasteland"},
	[63] = {pos = Vector("-12746.776367 6286.024414 -2976.212646"), angs = Angle("3.315 -180.000 -89.687"), uid = "tunnel1d", Type = "Tunnel", dest = "The Mojave Wasteland"},
	[64] = {pos = Vector("-4318.539063 7182.178223 13107.983398"), angs = Angle("-0.000 90.000 0.000"), uid = "freesidebuilding1b", Type = "Door", dest = "Freeside"},
	[65] = {pos = Vector("-4632.915527 7685.464844 7526.054688"), angs = Angle("-0.000 90.000 90.000"), uid = "freesidebuilding2a", Type = "Door", dest = "Freeside Travel Service"},
	[66] = {pos = Vector("-7275.340332 7188.977051 13614.461914"), angs = Angle("0.000 90.000 -0.000"), uid = "freesidebuilding2b", Type = "Door", dest = "Freeside"},
	[67] = {pos = Vector("7681.009766 7377.910156 3452.731934"), angs = Angle("3.313 -9.533 -89.800"), uid = "tunnel2a", Type = "Tunnel", dest = "The Mojave Wasteland"},
	[68] = {pos = Vector("7674.726563 7376.949707 3403.625977"), angs = Angle("3.271 -6.226 -87.985"), uid = "tunnel2b", Type = "Tunnel", dest = "The Mojave Wasteland"},
	[69] = {pos = Vector("7618.319336 7019.199219 3447.558105"), angs = Angle("3.582 -7.987 -90.921"), uid = "tunnel2c", Type = "Tunnel", dest = "The Mojave Wasteland"},
	[70] = {pos = Vector("7617.319336 7017.334961 3399.329834"), angs = Angle("3.518 -9.493 -89.724"), uid = "tunnel2d", Type = "Tunnel", dest = "The Mojave Wasteland"},
	[71] = {pos = Vector("-8625.652344 13728.207031 3392.953125"), angs = Angle("0.000 89.208 90.000"), uid = "freesidemaingatea", Type = "Door", dest = "Freeside Main Gate"},
	[72] = {pos = Vector("-8740.983398 13724.246094 3450.429199"), angs = Angle("0.000 -90.000 0.000"), uid = "freesidemaingatea", Type = "Gate", dest = "Freeside"},
	[73] = {pos = Vector("-7271.817871 12356.390625 3360.400391"), angs = Angle("-87.726 15.408 66.915"), uid = "freesidemaingatea", Type = "Gate", dest = "Freeside"},
	[74] = {pos = Vector("-8626.178711 13731.031250 3444.080078"), angs = Angle("-0.000 90.000 90.000"), uid = "freesidemaingatea", Type = "Gate", dest = "Freeside"},
	[75] = {pos = Vector("6178.012695 9954.929688 3516.995850"), angs = Angle("4.120 166.401 -93.203"), uid = "tunnel6a", Type = "Tunnel", dest = "The Mojave Wasteland"},
	[76] = {pos = Vector("6179.236816 9961.346680 3466.910400"), angs = Angle("3.315 162.968 -90.117"), uid = "tunnel6b", Type = "Tunnel", dest = "The Mojave Wasteland"},
	[77] = {pos = Vector("6281.676758 10306.446289 3521.375732"), angs = Angle("3.312 163.084 -88.167"), uid = "tunnel6c", Type = "Tunnel", dest = "The Mojave Wasteland"},
	[78] = {pos = Vector("6284.385742 10305.315430 3470.276123"), angs = Angle("3.268 163.003 -87.995"), uid = "tunnel6d", Type = "Tunnel", dest = "The Mojave Wasteland"},
	[79] = {pos = Vector("-7750.118652 8063.562012 7559.770020"), angs = Angle("0.000 -0.000 -0.000"), uid = "freesidemaingateb", Type = "Gate", dest = "The Mojave Wasteland"},
	[80] = {pos = Vector("-7752.891602 8107.637695 7558.312500"), angs = Angle("0.000 0.264 0.000"), uid = "freesidemaingateb", Type = "Gate", dest = "The Mojave Wasteland"},
	[81] = {pos = Vector("-7751.323730 8154.611328 7558.312500"), angs = Angle("0.000 -1.188 0.000"), uid = "freesidemaingateb", Type = "Gate", dest = "The Mojave Wasteland"},
	[82] = {pos = Vector("-7750.487793 8194.703125 7558.312500"), angs = Angle("0.000 2.112 0.000"), uid = "freesidemaingateb", Type = "Gate", dest = "The Mojave Wasteland"},
	[83] = {pos = Vector("-7753.398926 8238.501953 7558.312500"), angs = Angle("0.000 0.924 0.000"), uid = "freesidemaingateb", Type = "Gate", dest = "The Mojave Wasteland"},
	[84] = {pos = Vector("-7753.984375 8283.019531 7558.312500"), angs = Angle("0.000 -0.924 0.000"), uid = "freesidemaingateb", Type = "Gate", dest = "The Mojave Wasteland"},
	[85] = {pos = Vector("-2702.962646 7449.871582 7563.833496"), angs = Angle("-0.138 -0.057 -0.191"), uid = "freesidebuilding3a", Type = "Door", dest = "Freeside Storefront"},
	[86] = {pos = Vector("-3107.601563 7225.778809 13062.368164"), angs = Angle("0.001 65.884 -0.013"), uid = "DefaultUID", Type = "Door", dest = "The Mojave Wasteland"},
	[87] = {pos = Vector("-3084.457520 7220.628906 13281.146484"), angs = Angle("-0.000 90.000 0.000"), uid = "freesidebuilding3b", Type = "Door", dest = "Freeside"},
	[88] = {pos = Vector("6744.927734 -14031.568359 -2559.219482"), angs = Angle("2.182 -89.978 -89.515"), uid = "tunnel5c", Type = "Tunnel", dest = "The Mojave Wasteland"},
	[89] = {pos = Vector("6744.928223 -14029.680664 -2607.489014"), angs = Angle("3.233 -90.012 -89.525"), uid = "tunnel5d", Type = "Tunnel", dest = "The Mojave Wasteland"},
	[90] = {pos = Vector("-2080.020752 7376.139160 7558.408203"), angs = Angle("0.038 179.475 -0.124"), uid = "freesidepawnshop", Type = "Door", dest = "Freeside Pawn"},
	[91] = {pos = Vector("-3086.397705 8824.806641 14742.523438"), angs = Angle("0.000 90.000 0.000"), uid = "freesidepawnshop_e", Type = "Ladder", dest = "Freeside"},
	[92] = {pos = Vector("7111.989258 -14032.528320 -2562.143555"), angs = Angle("3.348 -90.014 -90.851"), uid = "tunnel5a", Type = "Tunnel", dest = "The Mojave Wasteland"},
	[93] = {pos = Vector("7110.189453 -14029.641602 -2610.382324"), angs = Angle("3.254 -89.949 -90.862"), uid = "tunnel5b", Type = "Tunnel", dest = "The Mojave Wasteland"},
	[94] = {pos = Vector("-2701.508057 6823.550781 7558.254395"), angs = Angle("4.323 -0.084 0.005"), uid = "sharkclub", Type = "Door", dest = "Freeside Bar"},
	[95] = {pos = Vector("-2663.743896 6670.752930 13294.285156"), angs = Angle("-0.714 179.716 -0.031"), uid = "sharkclub_e", Type = "Door", dest = "Freeside"},
	[96] = {pos = Vector("-6408.712891 7597.976563 7557.578613"), angs = Angle("-0.000 45.000 -0.000"), uid = "headnbreakfastfreeside", Type = "Door", dest = "Head 'N Breakfast"},
	[97] = {pos = Vector("-6256.723633 7626.075195 13310.694336"), angs = Angle("-0.000 179.850 0.000"), uid = "headnbreakfastfreeside_e", Type = "Door", dest = "Freeside"},
	[98] = {pos = Vector("-5411.622559 10074.163086 7574.458008"), angs = Angle("-0.000 90.000 0.000"), uid = "panuci", Type = "Door", dest = "The Mojave Wasteland"},
	[99] = {pos = Vector("-5545.175293 10036.370117 13468.461914"), angs = Angle("-0.000 -90.000 0.000"), uid = "panuci_e", Type = "Door", dest = "The Mojave Wasteland"},
	[100] = {pos = Vector("5891.796875 4621.381348 -9583.251953"), angs = Angle("0.102 -29.061 0.142"), uid = "hoovergas", Type = "Door", dest = "Poseidon Energy Gas Station"},
	[101] = {pos = Vector("5938.842285 6235.987793 -7903.880371"), angs = Angle("-0.000 180.000 -0.000"), uid = "hoovergas_e", Type = "Door", dest = "The Mojave Wasteland"},
	[102] = {pos = Vector("-8206.465820 -9593.473633 3547.172852"), angs = Angle("-0.000 90.000 -0.000"), uid = "nvairport", Type = "Door", dest = "The Mojave Wasteland"},
	[103] = {pos = Vector("-8954.171875 -10412.191406 6516.426270"), angs = Angle("0.000 90.440 0.000"), uid = "nvairport_e", Type = "Door", dest = "The Mojave Wasteland"},
	[104] = {pos = Vector("-8230.938477 -10669.694336 3546.144043"), angs = Angle("-0.000 -90.000 0.000"), uid = "nvairport2", Type = "Door", dest = "The Mojave Wasteland"},
	[105] = {pos = Vector("-8570.623047 -10594.983398 7284.017090"), angs = Angle("0.265 89.588 -0.160"), uid = "nvairport2_e", Type = "Door", dest = "The Mojave Wasteland"},
	[106] = {pos = Vector("-4866.352051 8708.744141 7559.684082"), angs = Angle("0.000 -90.000 0.000"), uid = "genericfreesideplace1", Type = "Door", dest = "Freeside Storefront"},
	[107] = {pos = Vector("-1295.479736 8313.000977 7558.312500"), angs = Angle("0.000 -178.800 0.000"), uid = "freesidestripa", Type = "Gate", dest = "The Strip"},
	[108] = {pos = Vector("-1295.765259 8266.951172 7558.312500"), angs = Angle("0.000 -178.008 0.000"), uid = "freesidestripa", Type = "Gate", dest = "The Strip"},
	[109] = {pos = Vector("-1294.530762 8217.831055 7558.312500"), angs = Angle("0.000 -179.328 0.000"), uid = "freesidestripa", Type = "Gate", dest = "The Strip"},
	[110] = {pos = Vector("-1295.231201 8169.733887 7558.312500"), angs = Angle("0.000 -179.460 0.000"), uid = "freesidestripa", Type = "Gate", dest = "The Strip"},
	[111] = {pos = Vector("-4929.102051 8738.055664 13303.651367"), angs = Angle("0.000 90.000 0.000"), uid = "genericfreesideplace1_e", Type = "Door", dest = "Freeside"},
	[112] = {pos = Vector("-1295.979370 8123.577637 7558.312500"), angs = Angle("0.000 -179.724 0.000"), uid = "freesidestripa", Type = "Gate", dest = "The Strip"},
	[113] = {pos = Vector("-1294.392700 8082.535645 7558.312500"), angs = Angle("0.000 -179.724 0.000"), uid = "freesidestripa", Type = "Gate", dest = "The Strip"},
	[114] = {pos = Vector("-4505.354004 8963.907227 7550.495605"), angs = Angle("0.000 -45.000 -0.000"), uid = "genericfreesideplace2", Type = "Door", dest = "The Mojave Wasteland"},
	[115] = {pos = Vector("-5596.250000 8620.158203 13313.072266"), angs = Angle("-0.000 0.000 0.000"), uid = "genericfreesideplace2_e", Type = "Door", dest = "The Mojave Wasteland"},
	[116] = {pos = Vector("-3752.866455 10663.257813 13365.281250"), angs = Angle("-0.001 90.668 -0.014"), uid = "genericfreesideplace3_e", Type = "Door", dest = "The Mojave Wasteland"},
	[117] = {pos = Vector("833.432312 7723.349121 7552.596191"), angs = Angle("0.000 -1.554 0.000"), uid = "freesidestripb", Type = "Gate", dest = "Freeside"},
	[118] = {pos = Vector("836.207214 7771.285156 7554.405273"), angs = Angle("0.000 -0.498 0.000"), uid = "freesidestripb", Type = "Gate", dest = "Freeside"},
	[119] = {pos = Vector("840.178772 7815.968750 7556.091309"), angs = Angle("0.000 1.218 0.000"), uid = "freesidestripb", Type = "Gate", dest = "Freeside"},
	[120] = {pos = Vector("841.291382 7862.007324 7555.991211"), angs = Angle("0.000 0.954 0.000"), uid = "freesidestripb", Type = "Gate", dest = "Freeside"},
	[121] = {pos = Vector("838.730713 7905.132324 7554.638672"), angs = Angle("0.000 0.954 0.000"), uid = "freesidestripb", Type = "Gate", dest = "Freeside"},
	[122] = {pos = Vector("-11049.192383 624.762268 -5818.141113"), angs = Angle("0.000 -89.993 -0.001"), uid = "shack1", Type = "Door", dest = "The Mojave Wasteland"},
	[123] = {pos = Vector("-12021.399414 774.882874 -5817.671875"), angs = Angle("0.000 -99.894 -0.001"), uid = "shack2", Type = "Door", dest = "The Mojave Wasteland"},
	[124] = {pos = Vector("-12804.160156 1220.590332 -5817.671875"), angs = Angle("0.000 -125.194 -0.001"), uid = "shack3", Type = "Door", dest = "The Mojave Wasteland"},
	[125] = {pos = Vector("-13144.870117 2235.312988 -5817.671875"), angs = Angle("0.000 -174.694 -0.001"), uid = "shack4", Type = "Door", dest = "The Mojave Wasteland"},
	[126] = {pos = Vector("-12555.556641 12933.778320 3458.334473"), angs = Angle("0.000 -0.000 -90.000"), uid = "westfreesideentrance", Type = "Door", dest = "The Mojave Wasteland"},
	[127] = {pos = Vector("-12587.966797 3390.334961 -5817.671875"), angs = Angle("0.000 149.446 -0.001"), uid = "shack5", Type = "Door", dest = "The Mojave Wasteland"},
	[128] = {pos = Vector("-11375.750000 3455.915283 -2767.233643"), angs = Angle("0.000 -59.554 -0.001"), uid = "shack5a", Type = "Door", dest = "Wasteland Shack"},
	[129] = {pos = Vector("-4685.561035 11631.585938 7588.377930"), angs = Angle("-0.000 1.650 -89.999"), uid = "westfreesideentrance_e", Type = "Door", dest = "The Mojave Wasteland"},
	[130] = {pos = Vector("-11671.346680 3020.857178 -2767.231934"), angs = Angle("0.000 -32.273 -0.001"), uid = "shack4a", Type = "Door", dest = "Wasteland Shack"},
	[131] = {pos = Vector("-11614.512695 2484.669678 -2766.692383"), angs = Angle("0.000 48.027 -0.001"), uid = "shack3a", Type = "Door", dest = "Wasteland Shack"},
	[132] = {pos = Vector("-11139.591797 2246.694336 -2766.692383"), angs = Angle("0.000 71.567 -0.001"), uid = "shack2a", Type = "Door", dest = "Wasteland Shack"},
	[133] = {pos = Vector("-10844.621094 2180.980225 -2766.692383"), angs = Angle("0.000 83.667 -0.001"), uid = "shack1a", Type = "Door", dest = "Wasteland Shack"},
	[134] = {pos = Vector("-10766.400391 -4404.858398 -2734.866455"), angs = Angle("5.477 -174.893 0.338"), uid = "icarus3a", Type = "Door", dest = "Wasteland Cabin"},
	[135] = {pos = Vector("-10821.223633 -5152.510742 -2728.667480"), angs = Angle("4.050 168.456 3.418"), uid = "icarus4", Type = "Door", dest = "Wasteland Cabin"},
	[136] = {pos = Vector("-12918.076172 -14262.240234 -4187.445313"), angs = Angle("6.103971 -41.839966 0.000000"), uid = "thefortship", Type = "Boat", dest = "Fortification Hill"},
	[137] = {pos = Vector("-6949.154297 13.121736 11212.015625"), angs = Angle("-0.000 -90.000 0.000"), uid = "thefortship_e", Type = "Door", dest = "The Mojave Wasteland"},
	[138] = {pos = Vector("-11328.696289 -5108.817871 -2723.961426"), angs = Angle("0.708 -21.030 0.110"), uid = "icarus1", Type = "Door", dest = "Wasteland Cabin"},
	[139] = {pos = Vector("-6223.903809 -5158.408691 14149.582031"), angs = Angle("-0.086 33.852 -89.086"), uid = "thetopsentrance_e", Type = "Door", dest = "The Strip"},
	[140] = {pos = Vector("-6284.445313 -4946.883789 14152.086914"), angs = Angle("0.000 -0.660 -90.000"), uid = "thetopsentrance_e", Type = "Door", dest = "The Strip"},
	[141] = {pos = Vector("-6224.697754 -4742.899902 14146.119141"), angs = Angle("-0.137 -36.189 -90.288"), uid = "thetopsentrance_e", Type = "Door", dest = "The Strip"},
	[142] = {pos = Vector("-6056.306152 -4599.362793 14150.356445"), angs = Angle("0.011 112.670 -89.919"), uid = "thetopsentrance_e", Type = "Door", dest = "The Strip"},
	[143] = {pos = Vector("3317.622803 6739.761230 7574.305176"), angs = Angle("0.017 -90.061 -90.575"), uid = "gomorrahentrance", Type = "Door", dest = "Gomorrah Casino"},
	[144] = {pos = Vector("3436.574463 6741.379395 7574.747070"), angs = Angle("0.106 -91.118 -90.114"), uid = "gomorrahentrance", Type = "Door", dest = "Gomorrah Casino"},
	[145] = {pos = Vector("8353.970703 6945.158203 7581.475098"), angs = Angle("0.000 -124.429 -89.999"), uid = "thetopsentrance", Type = "Door", dest = "The Tops"},
	[146] = {pos = Vector("7623.420898 6728.884766 7576.562500"), angs = Angle("-0.001 -23.415 -89.827"), uid = "thetopsentrance", Type = "Door", dest = "The Tops"},
	[147] = {pos = Vector("7806.022949 6943.130859 7583.843262"), angs = Angle("-0.095 -56.979 -89.918"), uid = "thetopsentrance", Type = "Door", dest = "The Tops"},
	[148] = {pos = Vector("8079.390137 7025.630859 7579.857422"), angs = Angle("-0.000 88.287 -90.000"), uid = "thetopsentrance", Type = "Door", dest = "The Tops"},
	[149] = {pos = Vector("-6050.598145 -5297.882813 14152.159180"), angs = Angle("-0.051 -112.337 -89.892"), uid = "thetopsentrance_e", Type = "Door", dest = "The Strip"},
	[150] = {pos = Vector("-123.529282 -10752.721680 9962.818359"), angs = Angle("0.053 90.024 -90.004"), uid = "gomorrahentrance_e", Type = "Door", dest = "The Mojave Wasteland"},
	[151] = {pos = Vector("-385.418884 -10749.548828 9963.846680"), angs = Angle("0.042 91.160 -89.989"), uid = "gomorrahentrance_e", Type = "Door", dest = "The Mojave Wasteland"},
	[152] = {pos = Vector("7056.919434 9146.372070 7566.293457"), angs = Angle("0.000 45.000 -90.000"), uid = "theultraluxe", Type = "Door", dest = "The Mojave Wasteland"},
	[153] = {pos = Vector("6979.755859 9217.802734 7567.905273"), angs = Angle("0.022 40.849 -90.160"), uid = "theultraluxe", Type = "Door", dest = "The Mojave Wasteland"},
	[154] = {pos = Vector("6901.857422 9284.580078 7570.096680"), angs = Angle("0.000 48.070 -90.000"), uid = "theultraluxe", Type = "Door", dest = "The Mojave Wasteland"},
	[155] = {pos = Vector("7133.067383 9068.722656 7568.535156"), angs = Angle("0.000 47.531 -90.000"), uid = "theultraluxe", Type = "Door", dest = "The Mojave Wasteland"},
	[156] = {pos = Vector("7215.968262 9000.617188 7567.929688"), angs = Angle("-0.185 51.142 -90.011"), uid = "theultraluxe", Type = "Door", dest = "The Mojave Wasteland"},
	[157] = {pos = Vector("-2752.379395 8735.692383 13282.403320"), angs = Angle("0.005 179.978 0.389"), uid = "freesidebuilding3b", Type = "Door", dest = "Freeside"},
	[158] = {pos = Vector("-2392.830322 -4557.116699 6418.364258"), angs = Angle("0.000 84.955 -90.000"), uid = "theultraluxe_e", Type = "Door", dest = "The Mojave Wasteland"},
	[159] = {pos = Vector("-2293.306396 -4576.810547 6370.269043"), angs = Angle("-0.298 67.520 92.982"), uid = "theultraluxe_e", Type = "Door", dest = "The Mojave Wasteland"},
	[160] = {pos = Vector("-2900.920654 -4579.550293 6417.681641"), angs = Angle("-0.000 -61.812 -89.590"), uid = "theultraluxe_e", Type = "Door", dest = "The Mojave Wasteland"},
	[161] = {pos = Vector("-2795.312256 -4539.229004 6418.983887"), angs = Angle("0.374 104.892 -90.842"), uid = "theultraluxe_e", Type = "Door", dest = "The Mojave Wasteland"},
	[162] = {pos = Vector("-7073.537598 10145.962891 7609.604004"), angs = Angle("1.166 -0.005 0.466"), uid = "followershack", Type = "Door", dest = "Old Mormon Fort Cabin"},
	[163] = {pos = Vector("-7489.695313 10904.779297 13479.041016"), angs = Angle("0.000 -0.617 0.000"), uid = "followershack_e", Type = "Door", dest = "The Mojave Wasteland"},
	[164] = {pos = Vector("-7558.900879 9711.994141 7609.249512"), angs = Angle("-1.059 -90.063 0.104"), uid = "followershack", Type = "Door", dest = "Old Mormon Fort Cabin"},
	[165] = {pos = Vector("232.099213 7265.778809 1715.658325"), angs = Angle("-0.000 0.059 0.003"), uid = "icarus2a", Type = "Door", dest = "The Mojave Wasteland"},
	[166] = {pos = Vector("-5551.621582 11918.514648 7568.149414"), angs = Angle("-3.108 -89.927 -0.777"), uid = "genericfreesidebuilding9", Type = "Door", dest = "The Mojave Wasteland"},
	[167] = {pos = Vector("-5009.421875 10637.884766 14132.711914"), angs = Angle("0.000 90.000 0.000"), uid = "genericfreesidebuilding9_e", Type = "Door", dest = "The Mojave Wasteland"},
	[168] = {pos = Vector("-5695.736816 11306.692383 7553.479980"), angs = Angle("0.000 135.000 0.000"), uid = "genericfreesidebuilding99", Type = "Door", dest = "The Mojave Wasteland"},
	[169] = {pos = Vector("-3736.333008 12794.427734 13619.820313"), angs = Angle("-0.058 90.063 -0.001"), uid = "genericfreesidebuilding99_e", Type = "Door", dest = "The Mojave Wasteland"},
	[170] = {pos = Vector("-6301.027832 6540.886719 7576.235840"), angs = Angle("0.000 0.000 -0.000"), uid = "freesidebuilding3a", Type = "Door", dest = "Freeside Hotel"},
	[171] = {pos = Vector("-3394.390869 8565.491211 6320.753906"), angs = Angle("-0.841 -179.841 0.014"), uid = "slaverbar_e", Type = "Door", dest = "The Mojave Wasteland"},
	[172] = {pos = Vector("-10812.762695 9213.005859 3435.602783"), angs = Angle("-0.000 90.000 -90.000"), uid = "slaverbar", Type = "Door", dest = "Bar"},
	[173] = {pos = Vector("-11542.883789 -4495.104492 -2723.581055"), angs = Angle("0.708 67.850 0.110"), uid = "icarus2", Type = "Door", dest = "Wasteland Cabin"},
	[174] = {pos = Vector("650.137817 6172.576172 1754.475830"), angs = Angle("0.708 1.620 0.110"), uid = "icarus3", Type = "Door", dest = "The Mojave Wasteland"},
	[175] = {pos = Vector("2176.387451 6058.816895 1754.475830"), angs = Angle("0.708 1.902 0.110"), uid = "icarus4a", Type = "Door", dest = "The Mojave Wasteland"},
	[176] = {pos = Vector("-12775.810547 10227.715820 3195.429688"), angs = Angle("3.260 179.917 -90.411"), uid = "freesidetunnel9_e", Type = "Tunnel", dest = "The Mojave Wasteland"},
	[177] = {pos = Vector("-12775.227539 10692.096680 3192.069824"), angs = Angle("1.799 179.993 -89.962"), uid = "freesidetunnel9_e", Type = "Tunnel", dest = "The Mojave Wasteland"},
	[178] = {pos = Vector("-1342.349731 2110.801270 -2989.186523"), angs = Angle("1.243 93.349 4.080"), uid = "hiddenvalleyclimb1", Type = "Ascend", dest = "Hidden Valley"},
	[179] = {pos = Vector("-1385.535278 1480.466064 -2772.161621"), angs = Angle("2.012 -176.233 -0.835"), uid = "hiddenvalleyclimb2", Type = "Descend", dest = "The Mojave Wasteland"},
	[180] = {pos = Vector("-2935.589600 8764.773438 7561.393066"), angs = Angle("0.079 -87.637 -0.063"), uid = "genericfreesidebuilding666", Type = "Door", dest = "The Mojave Wasteland"},
	[181] = {pos = Vector("-5637.386230 8776.888672 7558.563965"), angs = Angle("0.483 -135.002 0.167"), uid = "jeff", Type = "Door", dest = "The Kings"},
	[182] = {pos = Vector("7317.627930 -1617.457275 1973.684692"), angs = Angle("0.577 179.638 -0.181"), uid = "wastelandshack1", Type = "Door", dest = "The Mojave Wasteland"},
	[183] = {pos = Vector("7000.989258 -2490.962891 3164.047363"), angs = Angle("2.767 99.361 -0.010"), uid = "wastelandshack1a", Type = "Door", dest = "Poseidon Energy Gas Station"},
	[184] = {pos = Vector("-3833.811523 7635.183105 7561.618164"), angs = Angle("0.000 135.000 -0.000"), uid = "freesidesilvera", Type = "Door", dest = "The Silver Rush"},
	[185] = {pos = Vector("-3793.857666 7660.639648 13446.004883"), angs = Angle("0.011 -88.140 -0.008"), uid = "freesidesilverb", Type = "Door", dest = "Freeside"},
	[186] = {pos = Vector("-9434.457031 7178.191895 13412.022461"), angs = Angle("-0.000 90.000 0.000"), uid = "freesidesilverb", Type = "Door", dest = "Freeside"},
	[187] = {pos = Vector("-4426.381348 6833.006348 7564.630859"), angs = Angle("1.120 2.316 -0.068"), uid = "verygenericfreesidebuilding", Type = "Door", dest = "The Mojave Wasteland"},
	[188] = {pos = Vector("-8802.583984 7180.188477 14643.681641"), angs = Angle("6.232 -88.303 0.163"), uid = "verygenericfreesidebuilding_e", Type = "Door", dest = "The Mojave Wasteland"},
	[189] = {pos = Vector("642.499878 7717.657227 1724.130127"), angs = Angle("-0.000 -87.501 0.003"), uid = "icarus1a", Type = "Door", dest = "The Mojave Wasteland"},
	[190] = {pos = Vector("12584.302734 -5020.665527 -5043.817383"), angs = Angle("-0.000 135.000 0.000"), uid = "randomwoodenshack2_e", Type = "Door", dest = "The Mojave Wasteland"},
	[191] = {pos = Vector("-7198.248535 -11638.106445 -4013.675049"), angs = Angle("3.368 -145.221 0.006"), uid = "DefaultUID", Type = "Door", dest = "Cottonwood Cabin"},
	[192] = {pos = Vector("11980.366211 -5037.868164 -5042.026367"), angs = Angle("-0.000 46.760 0.000"), uid = "randomwoodenshack1_e", Type = "Door", dest = "The Mojave Wasteland"},
	[193] = {pos = Vector("-7274.636230 -12255.026367 -4008.724609"), angs = Angle("5.645 97.379 0.470"), uid = "cottonwoodinterior1", Type = "Door", dest = "Cottonwood Cabin"},
	[194] = {pos = Vector("-7883.819336 -12271.544922 -4001.023438"), angs = Angle("0.000 90.000 -0.000"), uid = "cottonwoodinterior2", Type = "Door", dest = "Cottonwood Cabin"},
	[195] = {pos = Vector("-8337.492188 -11556.544922 -4011.604980"), angs = Angle("4.547 -84.923 0.049"), uid = "cottonwoodinterior5", Type = "Door", dest = "Cottonwood Cabin"},
	[196] = {pos = Vector("-9140.867188 -12728.751953 -4005.137695"), angs = Angle("4.264 5.122 0.496"), uid = "cottonwoodinterior3", Type = "Door", dest = "Cottonwood Cabin"},
	[197] = {pos = Vector("-9624.375977 -12291.471680 -4005.774902"), angs = Angle("3.690 96.600 1.986"), uid = "cottonwoodinterior3", Type = "Door", dest = "Cottonwood Cabin"},
	[198] = {pos = Vector("11371.031250 -4128.471680 -2409.659912"), angs = Angle("3.423 174.438 0.275"), uid = "randomwoodenshack1", Type = "Door", dest = "The Mojave Wasteland"},
	[199] = {pos = Vector("-9168.552734 -11375.196289 -4003.687988"), angs = Angle("4.071 -24.009 0.056"), uid = "cottonwoodinterior4", Type = "Door", dest = "Cottonwood Cabin"},
	[200] = {pos = Vector("-8185.757324 -8605.600586 -3752.757080"), angs = Angle("4.070 -26.855 0.011"), uid = "cottonwoodinterior6", Type = "Door", dest = "Cottonwood Cabin"},
	[201] = {pos = Vector("-6647.734863 -9830.019531 -3749.701660"), angs = Angle("3.324 -134.563 0.829"), uid = "cottonwoodinterior8", Type = "Door", dest = "Cottonwood Cabin"},
	[202] = {pos = Vector("11758.826172 -4648.881348 -2409.804443"), angs = Angle("4.883 -97.012 0.789"), uid = "randomwoodenshack2", Type = "Door", dest = "The Mojave Wasteland"},
	[203] = {pos = Vector("-6612.984863 -9180.583984 -3748.783936"), angs = Angle("3.408 135.020 -0.998"), uid = "cottonwoodinterior7", Type = "Door", dest = "The Mojave Wasteland"},
	[204] = {pos = Vector("-7898.440430 -11070.045898 -4011.219971"), angs = Angle("2.198 5.952 0.173"), uid = "cottonwoodinterior5", Type = "Door", dest = "Cottonwood Cabin"},
	[205] = {pos = Vector("9851.174805 -6620.556152 -2412.768799"), angs = Angle("3.326 67.548 -0.043"), uid = "randomwoodenshack3", Type = "Door", dest = "The Mojave Wasteland"},
	[206] = {pos = Vector("11429.167969 -5982.663574 -4801.503906"), angs = Angle("-2.368 -132.689 -0.108"), uid = "randomwoodenshack3_e", Type = "Door", dest = "The Mojave Wasteland"},
	[207] = {pos = Vector("152.678406 -6775.987305 1224.717651"), angs = Angle("-0.007 -0.016 0.048"), uid = "cottonwoodexterior1", Type = "Door", dest = "The Mojave Wasteland"},
	[208] = {pos = Vector("1684.175781 -5837.206543 1741.576050"), angs = Angle("-0.020 -179.989 -0.029"), uid = "cottonwoodexterior2", Type = "Door", dest = "The Mojave Wasteland"},
}	

local destinfo = {
	[0] = {pos = Vector("-4994.548340 7018.240723 3366.882568"), angs = Angle("-0.002 -0.056 90.000"), uid = "scraphouse1a"},
	[1] = {pos = Vector("-5072.003418 7013.141602 6263.058594"), angs = Angle("-0.011 -89.807 90.012"), uid = "scraphouse1"},
	[2] = {pos = Vector("-10039.666016 13053.979492 3366.482666"), angs = Angle("-0.224 0.015 89.993"), uid = "exfreesidebld1"},
	[3] = {pos = Vector("5672.333008 6195.515137 -1285.214233"), angs = Angle("-9.601 10.634 89.358"), uid = "helioscollection"},
	[4] = {pos = Vector("-4867.625000 6334.087891 3363.595947"), angs = Angle("0.431 150.882 88.424"), uid = "scraphouse2a"},
	[5] = {pos = Vector("4916.212891 7137.045410 -2817.530273"), angs = Angle("1.422 -66.540 90.620"), uid = "helioscollectionexit"},
	[6] = {pos = Vector("-10655.830078 12653.784180 6246.090820"), angs = Angle("-0.002 36.368 90.115"), uid = "entfreesidebld1"},
	[7] = {pos = Vector("-6132.154297 6986.416992 6262.431152"), angs = Angle("0.303 178.833 90.240"), uid = "scraphouse2"},
	[8] = {pos = Vector("6258.423340 10319.834961 6425.107910"), angs = Angle("-0.041 -87.777 90.038"), uid = "10001"},
	[9] = {pos = Vector("10895.329102 -10100.349609 4128.523926"), angs = Angle("-0.028 -141.861 89.878"), uid = "ncroutpost1a"},
	[10] = {pos = Vector("8209.936523 11952.956055 3379.454102"), angs = Angle("0.066 101.962 90.158"), uid = "10002"},
	[11] = {pos = Vector("-4820.453125 4914.924316 13305.168945"), angs = Angle("0.001 39.527 89.999"), uid = "jeff"},
	[12] = {pos = Vector("11068.837891 8443.847656 3103.241699"), angs = Angle("-0.641 -57.846 89.768"), uid = "americanville1a"},
	[13] = {pos = Vector("5197.977051 10319.502930 6425.206055"), angs = Angle("-0.014 90.000 90.094"), uid = "10004"},
	[14] = {pos = Vector("-5651.255371 8735.834961 7504.504883"), angs = Angle("-0.005 -150.992 89.981"), uid = "bob"},
	[15] = {pos = Vector("10021.055664 -11234.262695 7229.957520"), angs = Angle("-0.011 57.120 90.021"), uid = "ncroutpost1"},
	[16] = {pos = Vector("-11879.934570 12117.360352 3366.426758"), angs = Angle("-0.004 84.144 89.952"), uid = "Gun"},
	[17] = {pos = Vector("6896.813965 11959.983398 3360.511230"), angs = Angle("0.003 -87.922 90.005"), uid = "10003"},
	[18] = {pos = Vector("-2982.285400 7818.619629 6271.666992"), angs = Angle("0.025 93.282 90.015"), uid = "americanville1"},
	[19] = {pos = Vector("6624.407715 5346.309570 -2741.364258"), angs = Angle("0.000 -90.001 90.000"), uid = "heliosexterior2"},
	[20] = {pos = Vector("8908.730469 6826.122070 -2750.916992"), angs = Angle("-0.004 90.139 89.997"), uid = "heliosexterior1"},
	[21] = {pos = Vector("8996.520508 11581.484375 3362.037354"), angs = Angle("3.127 -177.783 90.753"), uid = "10005"},
	[22] = {pos = Vector("-13341.423828 9250.828125 6461.926270"), angs = Angle("0.016 -179.848 90.041"), uid = "GR"},
	[23] = {pos = Vector("-1594.533936 5328.591309 2022.879150"), angs = Angle("0.000 -0.001 90.000"), uid = "heliosinterior1"},
	[24] = {pos = Vector("8836.523438 10312.528320 6222.348633"), angs = Angle("-0.022 -89.496 90.001"), uid = "10006"},
	[25] = {pos = Vector("-1596.734619 2881.312988 1638.286011"), angs = Angle("-0.000 -180.000 90.000"), uid = "heliosinterior2"},
	[26] = {pos = Vector("11604.912109 -9065.077148 4128.453613"), angs = Angle("0.284 -90.173 90.186"), uid = "ncroutpost2a"},
	[27] = {pos = Vector("10029.374023 11449.096680 3360.658447"), angs = Angle("0.464 89.874 91.064"), uid = "10008"},
	[28] = {pos = Vector("8848.182617 8931.985352 6238.066406"), angs = Angle("0.386 -178.611 89.788"), uid = "10007"},
	[29] = {pos = Vector("10983.778320 -9269.968750 6462.034180"), angs = Angle("0.017 -177.373 90.008"), uid = "ncroutpost2"},
	[30] = {pos = Vector("11717.072266 8809.522461 3104.568604"), angs = Angle("0.078 0.803 90.131"), uid = "americanville3"},
	[31] = {pos = Vector("10522.815430 11543.700195 3360.499512"), angs = Angle("-0.000 -90.000 90.000"), uid = "10011"},
	[32] = {pos = Vector("-2077.918457 -2543.144043 -3145.352539"), angs = Angle("0.000 -90.000 90.000"), uid = "hiddenvalleybunkerexterior"},
	[33] = {pos = Vector("-4866.799805 7642.208008 6271.610840"), angs = Angle("-0.023 91.207 90.005"), uid = "americanville3a"},
	[34] = {pos = Vector("7641.810059 10896.677734 6246.322266"), angs = Angle("0.027 83.508 90.032"), uid = "10012"},
	[35] = {pos = Vector("11730.273438 7026.949707 3122.528809"), angs = Angle("0.000 -0.440 90.000"), uid = "americanville4"},
	[36] = {pos = Vector("-13010.855469 11690.167969 6461.972168"), angs = Angle("-0.093 177.063 89.858"), uid = "OB"},
	[37] = {pos = Vector("10560.914063 12693.079102 3360.519043"), angs = Angle("-0.120 -89.863 89.765"), uid = "10014"},
	[38] = {pos = Vector("-2427.591797 7111.694824 6262.427246"), angs = Angle("-0.119 60.061 89.815"), uid = "americanville4a"},
	[39] = {pos = Vector("-5190.074219 7219.414551 14078.080078"), angs = Angle("0.080 45.278 89.835"), uid = "1b"},
	[40] = {pos = Vector("9340.900391 10773.903320 6239.706055"), angs = Angle("-0.020 90.376 89.984"), uid = "10013"},
	[41] = {pos = Vector("-10271.321289 11735.054688 3366.544434"), angs = Angle("0.336 -163.809 89.791"), uid = "office"},
	[42] = {pos = Vector("-5603.732422 2374.577637 3104.490479"), angs = Angle("-0.000 0.000 90.000"), uid = "storage1a"},
	[43] = {pos = Vector("-5829.934570 6740.039551 7504.561035"), angs = Angle("0.076 -135.191 90.063"), uid = "1a"},
	[44] = {pos = Vector("9486.978516 9338.190430 6758.299805"), angs = Angle("-0.009 90.441 89.999"), uid = "10016"},
	[45] = {pos = Vector("-3988.536865 8906.027344 -9590.710938"), angs = Angle("0.198 -80.237 90.146"), uid = "hiddenvalleybunkerinterior"},
	[46] = {pos = Vector("-6980.567383 2401.319336 6462.113770"), angs = Angle("0.000 57.864 90.000"), uid = "storage1"},
	[47] = {pos = Vector("9912.217773 12476.266602 3360.518066"), angs = Angle("-0.004 92.064 90.004"), uid = "10015"},
	[48] = {pos = Vector("9025.704102 12249.866211 3360.665039"), angs = Angle("0.138 1.506 89.327"), uid = "10018"},
	[49] = {pos = Vector("8001.405273 9538.629883 6223.789063"), angs = Angle("0.000 2.390 90.001"), uid = "10017"},
	[50] = {pos = Vector("7869.607422 10072.664063 6452.392090"), angs = Angle("-0.019 -179.022 89.625"), uid = "10020"},
	[51] = {pos = Vector("9613.978516 10900.697266 3360.460938"), angs = Angle("-0.019 -179.073 90.001"), uid = "10019"},
	[52] = {pos = Vector("-7067.929199 2207.299072 3106.374268"), angs = Angle("0.351 3.833 90.871"), uid = "storage2a"},
	[53] = {pos = Vector("8707.497070 13066.622070 3360.490967"), angs = Angle("-0.000 -90.000 90.000"), uid = "10022"},
	[54] = {pos = Vector("-8547.239258 3879.678223 6462.008789"), angs = Angle("0.175 -90.280 90.328"), uid = "storage2"},
	[55] = {pos = Vector("8520.996094 8688.388672 6238.422363"), angs = Angle("-0.218 0.564 89.767"), uid = "10021"},
	[56] = {pos = Vector("-4334.599121 7208.614258 13054.066406"), angs = Angle("0.386 90.542 89.788"), uid = "freesidebuilding1a"},
	[57] = {pos = Vector("-3313.030273 7727.836426 7504.535645"), angs = Angle("0.075 89.755 90.075"), uid = "freesidebuilding1b"},
	[58] = {pos = Vector("-12669.970703 6251.449707 -3022.866455"), angs = Angle("-0.000 90.000 90.000"), uid = "tunnel2c"},
	[59] = {pos = Vector("-12678.074219 5944.416016 -3024.399170"), angs = Angle("-0.000 90.000 90.000"), uid = "tunnel2b"},
	[60] = {pos = Vector("-12671.858398 5873.814453 -3026.697266"), angs = Angle("-0.000 90.000 90.000"), uid = "tunnel2a"},
	[61] = {pos = Vector("-4634.183594 7711.500488 7504.506348"), angs = Angle("-0.014 134.765 89.920"), uid = "freesidebuilding2b"},
	[62] = {pos = Vector("-12671.980469 6310.320801 -3027.547607"), angs = Angle("0.000 90.000 90.000"), uid = "tunnel2d"},
	[63] = {pos = Vector("-7292.660645 7230.525391 13566.089844"), angs = Angle("0.194 142.511 89.893"), uid = "freesidebuilding2a"},
	[64] = {pos = Vector("7559.896973 7058.145996 3346.279785"), angs = Angle("-1.339 -94.806 89.121"), uid = "tunnel1c"},
	[65] = {pos = Vector("7552.150879 7010.746582 3344.671143"), angs = Angle("3.366 -93.735 91.440"), uid = "tunnel1d"},
	[66] = {pos = Vector("7595.701172 7423.429688 3345.196533"), angs = Angle("-0.883 -94.787 89.839"), uid = "tunnel1a"},
	[67] = {pos = Vector("7585.438965 7358.261719 3345.448975"), angs = Angle("2.024 -93.744 90.393"), uid = "tunnel1b"},
	[68] = {pos = Vector("-7657.793945 8181.045410 7504.432617"), angs = Angle("-0.064 12.253 90.406"), uid = "freesidemaingatea"},
	[69] = {pos = Vector("6237.751953 9875.625000 3396.327881"), angs = Angle("0.038 -19.000 90.882"), uid = "tunnel5a"},
	[70] = {pos = Vector("6262.803711 9969.184570 3397.532715"), angs = Angle("0.699 139.808 92.036"), uid = "tunnel5b"},
	[71] = {pos = Vector("6340.480469 10219.487305 3397.723145"), angs = Angle("-0.103 -22.014 92.669"), uid = "tunnel5c"},
	[72] = {pos = Vector("-8635.084961 13633.216797 3387.702393"), angs = Angle("-0.000 0.000 90.000"), uid = "freesidemaingateb"},
	[73] = {pos = Vector("6363.440918 10305.971680 3396.530762"), angs = Angle("-0.488 -80.352 88.899"), uid = "tunnel5d"},
	[74] = {pos = Vector("-2663.351807 7471.372559 7504.431641"), angs = Angle("-0.003 -5.665 89.996"), uid = "freesidebuilding3b"},
	[75] = {pos = Vector("-3104.441895 7264.846680 13228.478516"), angs = Angle("0.313 -140.275 90.191"), uid = "freesidebuilding3a"},
	[76] = {pos = Vector("-2127.232178 7353.664063 7504.379883"), angs = Angle("-0.007 -88.596 89.705"), uid = "freesidepawnshop_e"},
	[77] = {pos = Vector("6779.205566 -13930.890625 -2666.953369"), angs = Angle("-0.001 -0.076 90.000"), uid = "tunnel6c"},
	[78] = {pos = Vector("6716.928223 -13934.583008 -2669.345215"), angs = Angle("-0.000 134.984 90.000"), uid = "tunnel6d"},
	[79] = {pos = Vector("7063.463379 -13934.756836 -2668.959717"), angs = Angle("0.000 179.992 90.000"), uid = "tunnel6b"},
	[80] = {pos = Vector("-3103.526855 8874.213867 14688.589844"), angs = Angle("-0.000 175.329 90.000"), uid = "freesidepawnshop"},
	[81] = {pos = Vector("7134.800781 -13940.417969 -2668.493408"), angs = Angle("-0.000 179.824 90.000"), uid = "tunnel6a"},
	[82] = {pos = Vector("-2632.751709 6844.266602 7504.454102"), angs = Angle("-0.000 90.000 90.000"), uid = "sharkclub_e"},
	[83] = {pos = Vector("-2706.976563 6648.979980 13240.419922"), angs = Angle("-0.003 -90.263 89.998"), uid = "sharkclub"},
	[84] = {pos = Vector("-6388.949219 7645.615723 7504.358887"), angs = Angle("0.182 133.527 90.150"), uid = "headnbreakfastfreeside_e"},
	[85] = {pos = Vector("-6306.729492 7603.984375 13256.410156"), angs = Angle("-0.002 -87.877 90.012"), uid = "headnbreakfastfreeside"},
	[86] = {pos = Vector("-5434.545898 10134.080078 7504.575684"), angs = Angle("-0.117 -178.853 89.918"), uid = "panuci_e"},
	[87] = {pos = Vector("-5522.207520 9976.290039 13412.470703"), angs = Angle("-0.078 7.713 90.101"), uid = "panuci"},
	[88] = {pos = Vector("5935.635254 4620.176270 -9637.185547"), angs = Angle("0.031 58.012 90.024"), uid = "hoovergas_e"},
	[89] = {pos = Vector("5900.340332 6213.281738 -7952.233887"), angs = Angle("-0.002 -85.832 90.128"), uid = "hoovergas"},
	[90] = {pos = Vector("-8227.659180 -9542.530273 3490.763672"), angs = Angle("0.017 176.700 89.998"), uid = "nvairport_e"},
	[91] = {pos = Vector("-8976.862305 -10366.283203 6461.944824"), angs = Angle("-0.030 173.955 90.012"), uid = "nvairport"},
	[92] = {pos = Vector("-8208.262695 -10717.330078 3491.186035"), angs = Angle("0.179 -0.988 89.762"), uid = "nvairport2_e"},
	[93] = {pos = Vector("-8590.136719 -10549.519531 7229.941406"), angs = Angle("-0.033 -179.817 89.948"), uid = "nvairport2"},
	[94] = {pos = Vector("-4842.742676 8655.987305 7504.429688"), angs = Angle("0.104 0.026 89.991"), uid = "genericfreesideplace1_e"},
	[95] = {pos = Vector("-4949.458008 8783.498047 13248.505859"), angs = Angle("-0.071 177.004 90.072"), uid = "genericfreesideplace1"},
	[96] = {pos = Vector("-4450.822266 8942.515625 7504.439453"), angs = Angle("0.002 46.538 90.027"), uid = "genericfreesideplace2_e"},
	[97] = {pos = Vector("-1360.987305 8193.446289 7504.557617"), angs = Angle("0.185 90.141 90.069"), uid = "freesidestripb"},
	[98] = {pos = Vector("-5548.484863 8643.252930 13256.353516"), angs = Angle("-0.003 90.212 89.647"), uid = "genericfreesideplace2"},
	[99] = {pos = Vector("-3775.284668 10709.642578 13309.923828"), angs = Angle("0.014 177.732 89.976"), uid = "genericfreesideplace3"},
	[100] = {pos = Vector("928.808044 7837.001953 7500.264648"), angs = Angle("-0.194 0.059 92.211"), uid = "freesidestripa"},
	[101] = {pos = Vector("-11026.543945 582.861877 -5872.103027"), angs = Angle("-0.028 -0.048 90.037"), uid = "shack1a"},
	[102] = {pos = Vector("-12008.805664 728.176941 -5870.230957"), angs = Angle("-0.021 -2.825 89.969"), uid = "shack2a"},
	[103] = {pos = Vector("-12808.792969 1171.565430 -5872.013184"), angs = Angle("0.000 -45.000 90.000"), uid = "shack3a"},
	[104] = {pos = Vector("-13190.061523 2207.492676 -5871.958496"), angs = Angle("0.100 -89.900 89.610"), uid = "shack4a"},
	[105] = {pos = Vector("-12644.462891 3396.282715 -5871.972168"), angs = Angle("0.005 -128.708 89.999"), uid = "shack5a"},
	[106] = {pos = Vector("-12499.038086 12934.330078 3376.969482"), angs = Angle("-2.246 89.907 90.121"), uid = "westfreesideentrance_e"},
	[107] = {pos = Vector("-11334.291992 3426.855225 -2821.639648"), angs = Angle("0.241 19.958 90.030"), uid = "shack5"},
	[108] = {pos = Vector("-4763.566895 11626.434570 7502.683105"), angs = Angle("-2.257 -88.543 90.086"), uid = "westfreesideentrance"},
	[109] = {pos = Vector("-11623.928711 3017.838867 -2821.624756"), angs = Angle("-0.093 56.572 90.019"), uid = "shack4"},
	[110] = {pos = Vector("-11603.547852 2530.901367 -2821.085205"), angs = Angle("-0.093 136.872 90.019"), uid = "shack3"},
	[111] = {pos = Vector("-11148.003906 2293.457520 -2821.085205"), angs = Angle("-0.093 160.412 90.019"), uid = "shack2"},
	[112] = {pos = Vector("-10862.648438 2224.941162 -2821.085205"), angs = Angle("-0.093 172.512 90.019"), uid = "shack1"},
	[113] = {pos = Vector("-11031.483398 -13492.358398 -4216.499512"), angs = Angle("1.274 22.778 89.867"), uid = "thefortship_e"},
	[114] = {pos = Vector("-6935.447754 -90.113899 11135.187500"), angs = Angle("-0.637 2.073 90.130"), uid = "thefortship"},
	[115] = {pos = Vector("-11283.767578 -5103.261719 -2778.523926"), angs = Angle("0.010 66.939 90.026"), uid = "icarus1a"},
	[116] = {pos = Vector("-10855.879883 -5171.283203 -2781.966797"), angs = Angle("0.010 -106.061 90.026"), uid = "icarus4a"},
	[117] = {pos = Vector("-10797.737305 -4434.598633 -2788.086914"), angs = Angle("0.010 -86.701 90.026"), uid = "icarus3"},
	[118] = {pos = Vector("-6001.053711 -4922.560547 14085.098633"), angs = Angle("-0.018 54.899 89.991"), uid = "thetopsentrance"},
	[119] = {pos = Vector("3378.315918 6817.553711 7496.470215"), angs = Angle("-0.066 178.415 89.957"), uid = "gomorrahentrance_e"},
	[120] = {pos = Vector("8007.206543 7149.705566 7514.279785"), angs = Angle("-3.869 -152.453 85.742"), uid = "thetopsentrance_e"},
	[121] = {pos = Vector("-2803.553223 8717.244141 13228.519531"), angs = Angle("0.043 179.146 90.071"), uid = "freesidebuilding3a"},
	[122] = {pos = Vector("6981.282715 9097.986328 7496.445313"), angs = Angle("-0.039 -45.301 89.965"), uid = "theultraluxe_e"},
	[123] = {pos = Vector("-2303.920898 -4634.472168 6346.145020"), angs = Angle("-0.094 6.783 90.135"), uid = "theultraluxe"},
	[124] = {pos = Vector("-6241.030762 6556.726074 7504.564453"), angs = Angle("-0.223 0.127 89.851"), uid = "freesidebuilding3b"},
	[125] = {pos = Vector("-6970.004883 10164.311523 7504.546875"), angs = Angle("0.075 89.670 90.127"), uid = "followershack_e"},
	[126] = {pos = Vector("-7421.733398 10924.063477 13426.425781"), angs = Angle("0.086 91.409 89.959"), uid = "followershack"},
	[127] = {pos = Vector("272.394989 7286.404297 1670.236816"), angs = Angle("-0.086 85.869 89.985"), uid = "icarus2"},
	[128] = {pos = Vector("-5536.399902 11848.672852 7504.572754"), angs = Angle("0.124 1.623 89.923"), uid = "genericfreesidebuilding9_e"},
	[129] = {pos = Vector("-5030.642090 10688.625000 14077.997070"), angs = Angle("-0.122 -177.945 89.734"), uid = "genericfreesidebuilding9"},
	[130] = {pos = Vector("-5748.977051 11334.731445 7504.512207"), angs = Angle("-0.015 -135.676 90.047"), uid = "genericfreesidebuilding99_e"},
	[131] = {pos = Vector("-3757.287598 12845.345703 13566.047852"), angs = Angle("0.130 -164.508 90.177"), uid = "genericfreesidebuilding99"},
	[132] = {pos = Vector("-3442.699707 8544.753906 6266.832520"), angs = Angle("-0.059 -91.803 90.004"), uid = "slaverbar"},
	[133] = {pos = Vector("-11547.561523 -4450.075195 -2778.143555"), angs = Angle("0.010 155.819 90.026"), uid = "icarus2a"},
	[134] = {pos = Vector("-10808.648438 9132.485352 3371.297363"), angs = Angle("0.190 6.093 88.214"), uid = "slaverbar_e"},
	[135] = {pos = Vector("-8618.051758 8999.892578 3390.351563"), angs = Angle("0.000 -180.000 90.000"), uid = "freesidetunnel9_e"},
	[136] = {pos = Vector("689.461853 6195.007324 1699.913330"), angs = Angle("0.010 89.589 90.026"), uid = "icarus3a"},
	[137] = {pos = Vector("-121.623886 -10674.713867 9891.812500"), angs = Angle("2.601 -169.080 92.815"), uid = "gomorrahentrance"},
	[138] = {pos = Vector("2215.600586 6081.441406 1699.913330"), angs = Angle("0.010 89.871 90.026"), uid = "icarus4"},
	[139] = {pos = Vector("-12680.294922 10316.076172 3116.130127"), angs = Angle("2.109 78.873 89.584"), uid = "freesidetunnel9"},
	[140] = {pos = Vector("-1410.748535 1456.485229 -2823.646484"), angs = Angle("-4.539 75.350 104.299"), uid = "hiddenvalleyclimb1"},
	[141] = {pos = Vector("-1368.111816 2141.281006 -3043.366943"), angs = Angle("2.944 11.241 87.871"), uid = "hiddenvalleyclimb2"},
	[142] = {pos = Vector("-8456.265625 8999.461914 3392.495850"), angs = Angle("0.328 -13.152 89.899"), uid = "Freesidetunnel100"},
	[143] = {pos = Vector("-2911.889648 8690.567383 7504.506348"), angs = Angle("0.262 3.098 90.023"), uid = "genericfreesidebuilding666_e"},
	[144] = {pos = Vector("7255.138184 -1640.208984 1919.643066"), angs = Angle("-0.000 -90.000 90.000"), uid = "wastelandshack1a"},
	[145] = {pos = Vector("-12567.259766 10465.665039 3111.704102"), angs = Angle("-1.622 46.207 91.656"), uid = "freesidetunnel2"},
	[146] = {pos = Vector("6974.151855 -2440.729980 3110.243896"), angs = Angle("-0.003 -167.979 89.938"), uid = "wastelandshack1"},
	[147] = {pos = Vector("-3880.090332 7651.114258 7504.553223"), angs = Angle("-0.186 18.378 89.795"), uid = "freesidesilverb"},
	[148] = {pos = Vector("-3763.124512 7603.583984 13398.565430"), angs = Angle("-0.005 122.349 90.066"), uid = "freesidesilvera"},
	[149] = {pos = Vector("-4348.432617 6854.285156 75	04.455078"), angs = Angle("-0.034 90.202 89.883"), uid = "verygenericfreesidebuilding_e"},
	[150] = {pos = Vector("-8778.731445 7224.674805 14590.029297"), angs = Angle("-0.032 -174.615 89.946"), uid = "verygenericfreesidebuilding"},
	[151] = {pos = Vector("667.263245 7664.582520 1670.251343"), angs = Angle("0.003 -0.996 89.963"), uid = "icarus1"},
	[152] = {pos = Vector("-7237.200684 -11695.839844 -4101.524902"), angs = Angle("0.168 99.202 90.055"), uid = "DefaultUID"},
	[153] = {pos = Vector("-7304.248535 -12202.361328 -4101.461914"), angs = Angle("0.250 -9.510 89.966"), uid = "DefaultUID"},
	[154] = {pos = Vector("12531.333984 -5002.848145 -5080.177734"), angs = Angle("0.000 -135.000 90.000"), uid = "randomwoodenshack2"},
	[155] = {pos = Vector("-7915.807129 -12213.281250 -4101.436035"), angs = Angle("0.213 -43.149 89.883"), uid = "DefaultUID"},
	[156] = {pos = Vector("11988.400391 -4987.268066 -5080.263672"), angs = Angle("-0.000 135.000 90.000"), uid = "randomwoodenshack1"},
	[157] = {pos = Vector("-8306.943359 -11628.992188 -4101.440430"), angs = Angle("-0.202 -126.173 89.824"), uid = "DefaultUID"},
	[158] = {pos = Vector("11272.957031 -4142.746582 -2501.739502"), angs = Angle("1.974 -81.204 88.693"), uid = "randomwoodenshack1_e"},
	[159] = {pos = Vector("-9048.818359 -12686.423828 -4101.453125"), angs = Angle("0.189 -79.411 89.791"), uid = "DefaultUID"},
	[160] = {pos = Vector("-9099.503906 -11375.084961 -4101.473145"), angs = Angle("-0.109 -133.328 89.665"), uid = "DefaultUID"},
	[161] = {pos = Vector("11768.933594 -4749.783691 -2502.471680"), angs = Angle("-0.006 1.060 90.312"), uid = "randomwoodenshack2_e"},
	[162] = {pos = Vector("-6701.907227 -9914.771484 -3845.426514"), angs = Angle("-0.135 138.630 89.904"), uid = "DefaultUID"},
	[163] = {pos = Vector("9863.696289 -6507.306152 -2502.604248"), angs = Angle("-0.296 158.559 90.112"), uid = "randomwoodenshack3_e"},
	[164] = {pos = Vector("11391.190430 -6043.780762 -4855.604004"), angs = Angle("0.010 -45.405 90.001"), uid = "randomwoodenshack3"},
	[165] = {pos = Vector("174.918457 -6753.845215 1170.909668"), angs = Angle("0.209 -101.716 89.921"), uid = "cottonwoodinterior1"},
	[166] = {pos = Vector("1638.468262 -5854.023926 1687.703247"), angs = Angle("-0.053 168.216 89.853"), uid = "cottonwoodinterior2"},
}





concommand.Add("doorsfix", function( ply, cmd, args )

ply:SetPos(Vector(-5581.780273, 2334.080322, 3158.499512))

timer.Simple(0.5, function()
	for k, v in pairs(doorinfo) do
	print"rip"
		local teleport = ents.Create("forp_teleport")
		teleport:SetPos(v.pos)
		teleport:SetAngles(v.angs)
		teleport:Spawn()
	--	teleport:SetNoDraw(true)
		teleport:SetColor( Color( 0, 255, 0, 0 ) ) 
		teleport:SetRenderMode( RENDERMODE_TRANSCOLOR )
	
		local phys = teleport:GetPhysicsObject()
		if (phys and phys:IsValid()) then
			phys:EnableMotion(false)
		end
	
		teleport:SetType(v.Type)
		teleport:SetDestination(v.dest)
		teleport:SetUID(v.uid)
	end
	
	for k, v in pairs(destinfo) do
		local teleport = ents.Create("forp_teleportdestination")
		teleport:SetPos(v.pos)
		teleport:SetAngles(v.angs)
		teleport:Spawn()
--		teleport:SetNoDraw(true)
		teleport:SetColor( Color( 0, 255, 0, 0 ) ) 
		teleport:SetRenderMode( RENDERMODE_TRANSCOLOR )
	
		local phys = teleport:GetPhysicsObject()
		if (phys and phys:IsValid()) then
			phys:EnableMotion(false)
		end
	
		teleport:SetUID(v.uid)		
	end
end)


end)

hook.Add("InitPostEntity", "SpawnTeleports", function()
timer.Simple(0.5, function()
	for k, v in pairs(doorinfo) do
	print"rip"
		local teleport = ents.Create("forp_teleport")
		teleport:SetPos(v.pos)
		teleport:SetAngles(v.angs)
		teleport:Spawn()
	--	teleport:SetNoDraw(true)
		teleport:SetColor( Color( 0, 255, 0, 0 ) ) 
		teleport:SetRenderMode( RENDERMODE_TRANSCOLOR )
	
		local phys = teleport:GetPhysicsObject()
		if (phys and phys:IsValid()) then
			phys:EnableMotion(false)
		end
	
		teleport:SetType(v.Type)
		teleport:SetDestination(v.dest)
		teleport:SetUID(v.uid)
	end
	
	for k, v in pairs(destinfo) do
		local teleport = ents.Create("forp_teleportdestination")
		teleport:SetPos(v.pos)
		teleport:SetAngles(v.angs)
		teleport:Spawn()
--		teleport:SetNoDraw(true)
		teleport:SetColor( Color( 0, 255, 0, 0 ) ) 
		teleport:SetRenderMode( RENDERMODE_TRANSCOLOR )
	
		local phys = teleport:GetPhysicsObject()
		if (phys and phys:IsValid()) then
			phys:EnableMotion(false)
		end
	
		teleport:SetUID(v.uid)		
	end
end)

	local fogeditor = ents.Create("edit_fog")
	fogeditor:SetPos(Vector("2217.377930 4657.501465 -288.683014"))
	fogeditor:Spawn()

	local phys = fogeditor:GetPhysicsObject()
	if (phys and phys:IsValid()) then
		phys:EnableMotion(false)
	end
end)

local playerMeta = FindMetaTable("Player")

function playerMeta:SendSound(sound)
	netstream.Start(self, "nut_sendsound", sound)
end

function playerMeta:SendNotification(message, messagetwo, messagethree, sound, image, pos)
	local data = {}
	data.message = message
	data.messagetwo = messagetwo
	data.messagethree = messagethree
	data.sound = sound
	data.image = image
	data.pos = pos or 0
	netstream.Start(self, "nut_fnotify", data)
end

function playerMeta:FNotify(text, image, sound)
	netstream.Start(self, "nut_fnotify", sound)
end

function playerMeta:UpdateInv(class, quantity, data, forced, noSave, noSend, Inventory)
	local inventory = Inventory or self.character:GetVar("inv")

	if (!self.character) then
		return false
	end

	local itemTable = nut.item.Get(class)

	if (!itemTable) then
		ErrorNoHalt("Attempt to give invalid item '"..class.."'\n")

		if (IsValid(self)) then
			nut.util.Notify("Attempt to give invalid item '"..class.."'!", self)
		end

		return false
	end

	quantity = quantity or 1

	if (!self:HasInvSpace(itemTable, quantity, forced, Inventory)) then
		return false
	end

	if (itemTable.data) then
		local oldData = data or {}

		data = table.Copy(itemTable.data)
		data = table.Merge(data, oldData)
	end

	inventory[class] = inventory[class] or {}
	inventory = nut.util.StackInv(inventory, class, quantity, data)

	if (!noSave) then
		-- Limit on how often items should save.
		local shouldSave = false

		if (self:GetNutVar("nextItemSave", 0) < CurTime()) then
			shouldSave = true
			self:SetNutVar("nextItemSave", CurTime() + 120)
		end

		if (shouldSave) then
			nut.char.Save(self)
		end
	end

	-- Stop the inventory from networking to the client.
	if (!noSend) then
		self.character:Send("inv", self)
	end

	return true
end

local ranks = {
	["operator"] = true,
	["owner"] = true,
	["admin"] = true,
	["superadmin"] = true,
	["user"] = true,
}
hook.Add("PrePACConfigApply", "PACRankRestrict", function(ply)
	if not ranks[ply:GetUserGroup()] then
              return false,"Insufficient rank to use PAC."
        end
end)