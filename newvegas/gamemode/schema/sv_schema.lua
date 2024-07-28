function SCHEMA:GetGameDescription()
	return "falloutrp"
end

SCHEMA.RegisterKey("Tier 1 Armor", function(client)
	client:GiveFlag("1")
	client:GiveFlag("a")
end, 10)

SCHEMA.RegisterKey("Tier 2 Armor", function(client)
	client:GiveFlag("1")
	client:GiveFlag("2")
	client:GiveFlag("a")
end, 10)

SCHEMA.RegisterKey("Tier 1 Weapon", function(client)
	client:GiveFlag("1")
	client:GiveFlag("w")
end, 5)

SCHEMA.RegisterKey("Tier 2 Weapon", function(client)
	client:GiveFlag("1")
	client:GiveFlag("2")
	client:GiveFlag("w")
end, 10)

SCHEMA.RegisterKey("Tier 2 Weapon", function(client)
	client:GiveFlag("1")
	client:GiveFlag("2")
	client:GiveFlag("w")
end, 10)

SCHEMA.RegisterKey("Energy Weapons", function(client)
	client:GiveFlag("1")
	client:GiveFlag("2")
	client:GiveFlag("3")
	client:GiveFlag("z")
end, 5)

SCHEMA.RegisterKey("Misc Trader", function(client)
	client:GiveFlag("1")
end, 10)

SCHEMA.RegisterKey("Special Ammo", function(client)
	client:GiveFlag("M")
end, 5)

SCHEMA.RegisterKey("Drugs", function(client)
	client:GiveFlag("m")
end, 10)

SCHEMA.RegisterKey("Melee", function(client)
	client:GiveFlag("x")
end, 2)

SCHEMA.RegisterKey("Starting Caps", function(client)
	client:GiveMoney(3000)
end, 15)

SCHEMA.RegisterKey("Legion_Recruit", function(client)
	client:GiveMoney(250)
	client:UpdateInv("Legion Recruit Armor", 1)
	client:UpdateInv("Legion Recruit Helmet", 1)
	client:UpdateInv("Machete", 1)
	client:GiveFlag("L")
	client:SetRank("Recruit Legionary")
end, 50)

SCHEMA.RegisterKey("Legion_Prime", function(client)
	client:GiveMoney(500)
	client:UpdateInv("Legion Prime Armor", 1)
	client:UpdateInv("Legion Prime Helmet", 1)
	client:UpdateInv("Machete", 1)
	client:GiveFlag("L")
	client:SetRank("Prime Legionary")
end, 30)

SCHEMA.RegisterKey("Legion_Veteran", function(client)
	client:GiveMoney(750)
	client:UpdateInv("Legion Veteran Armor", 1)
	client:UpdateInv("Legion Veteran Helmet", 1)
	client:UpdateInv("Machete", 1)
	client:GiveFlag("L")
	client:SetRank("Veteran Legionary")
end, 20)

SCHEMA.RegisterKey("NCR_Private", function(client)
	client:GiveMoney(500)
	client:UpdateInv("NCR Trooper Uniform", 1)

	local helmet
	if (tobool(math.random(0,1))) then
		helmet = "NCR Goggles Helmet"
	else
		helmet = "NCR Helmet"
	end
	client:UpdateInv(helmet, 1)

	client:UpdateInv("Service Rifle", 1)
	client:GiveFlag("R")
	client:SetRank("Pvt. ")
end, 50)

timer.Simple(2, function()
	SCHEMA.RegisterKey("JohnnyKey", function(client)
		client:GiveMoney(10000)
		client:UpdateInv("NCR Trooper Uniform", 1)
		client:UpdateInv("bclothing_srk", 1)
		client:UpdateInv("Stormchaser Helmet", 1)
	
		local itemTable = nut.item.Get("M16A2")
	
		itemTable.data.custom = {}
		itemTable.data.custom.lunchboxmod = {}
		itemTable.data.custom.name = "8th Intl. M16A2-S"
		itemTable.data.custom.quality = SCHEMA.Quality[5].name
		itemTable.data.custom.color = SCHEMA.Quality[5].color
		itemTable.data.custom.lunchboxmod.Primary = {}
		itemTable.data.custom.lunchboxmod.Primary.Sound = "fosounds/fix/rifle_sil.mp3"
		itemTable.data.custom.lunchboxmod.Primary.ClipSize = 35
		itemTable.data.custom.lunchboxmod.Primary.Damage = 25
		itemTable.data.custom.lunchboxmod.Sound = {}
		itemTable.data.custom.lunchboxmod.Sound["Deploy"] = "fosounds/weapons/l4d2/smg_deploy_1.wav"
		itemTable.data.custom.lunchboxmod.Sound["ClipIn"] = "fosounds/weapons/l4d2/smg_clip_in_1.wav"
		itemTable.data.custom.lunchboxmod.Sound["ClipOut"] = "fosounds/weapons/l4d2/smg_clip_out_1.wav"
		itemTable.data.custom.lunchboxmod.Sound["ClipLocked"] = "fosounds/weapons/l4d2/smg_clip_locked_1.wav"
		itemTable.data.custom.lunchboxmod.Sound["BoltBack"] = "fosounds/weapons/l4d2/smg_slideback_1.wav"
		itemTable.data.custom.lunchboxmod.Sound["BoltForward"] = "fosounds/weapons/l4d2/smg_slideforward_1.wav"
		itemTable.data.custom.lunchboxmod.Sound["Empty"] = "fosounds/weapons/clipempty_rifle.wav"

		itemTable.data.custom.lunchboxmod.IsEnergyWeapon = true
		itemTable.data.custom.lunchboxmod.EnergyMuzzle = ""
		itemTable.data.custom.lunchboxmod.EnergyTracer = ""

		itemTable.data.custom.lunchboxmod.AttVM = "0~1"
		itemTable.data.custom.lunchboxmod.AttWM = "0~1"
		itemTable.data.custom.lunchboxmod.MagBG = "2"

		client:UpdateInv(itemTable.uniqueID, 1, itemTable.data)
		client:GiveFlag("R")
		client:SetRank("Cpl. ")
	end, 10)

	SCHEMA.RegisterKey("NCR_Corporal", function(client)
		client:GiveMoney(500)
		client:UpdateInv("NCR Trooper Uniform", 1)
	
		local helmet
		if (tobool(math.random(0,1))) then
			helmet = "NCR Goggles Helmet"
		else
			helmet = "NCR Helmet"
		end
		client:UpdateInv(helmet, 1)
	
		client:UpdateInv("CAR-15", 1)
		client:GiveFlag("R")
		client:SetRank("Cpl. ")
	end, 50)
end)

SCHEMA.RegisterKey("kurisiltoygun", function(client)
	local itemTable = nut.item.Get("Alien Blaster")

	itemTable.data.custom = {}
	itemTable.data.custom.lunchboxmod = {}
	itemTable.data.custom.name = "Toy Gun"
	itemTable.data.custom.quality = SCHEMA.Quality[4].name
	itemTable.data.custom.color = SCHEMA.Quality[4].color
	itemTable.data.custom.lunchboxmod.Primary = {}
	itemTable.data.custom.lunchboxmod.Primary.ClipSize = 0
	itemTable.data.custom.lunchboxmod.Primary.Damage = 0


	client:UpdateInv(itemTable.uniqueID, 1, itemTable.data)
end, 10)

	SCHEMA.RegisterKey("NCR_Corporal", function(client)
		client:GiveMoney(500)
		client:UpdateInv("NCR Trooper Uniform", 1)
	
		local helmet
		if (tobool(math.random(0,1))) then
			helmet = "NCR Goggles Helmet"
		else
			helmet = "NCR Helmet"
		end
		client:UpdateInv(helmet, 1)
	
		client:UpdateInv("CAR-15", 1)
		client:GiveFlag("R")
		client:SetRank("Cpl. ")
	end, 1)