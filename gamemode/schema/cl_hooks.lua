nut.setting.Register({
	name = "Toggle Color Correction",
	var = "colorcorrection",
	type = "checker",
	category = "Fallout Settings"
})

nut.setting.Register({
	name = "Toggle High Visibility Chat",
	var = "highvischat",
	type = "checker",
	category = "Chatbox Settings"
})

nut.setting.Register({
	name = "Toggle Lazarus Style Chat",
	var = "lazzychat",
	type = "checker",
	category = "Chatbox Settings"
})

nut.setting.Register({
	name = "Toggle Mask Overlay",
	var = "maskoverlay",
	type = "checker",
	category = "Fallout Settings"
})

nut.setting.Register({
	name = "Draw Fallout HUD",
	var = "drawHUD",
	type = "checker",
	category = "Fallout Settings"
})

SCHEMA.ClothesTable = SCHEMA.ClothesTable or {}
SCHEMA.BodiesTable = SCHEMA.BodiesTable or {}

netstream.Hook("nut_spawned", function()
	LocalPlayer().CurrentBag = nil
end)

netstream.Hook("screamer", function(data)
	hook.Add("HUDPaint", "screamer", function()
		local rand = math.random(0,1)
		
		if (rand == 0) then
			surface.SetDrawColor(0,0,0,255)
		else
			surface.SetDrawColor(255,255,255,255)
		end

		surface.DrawRect(0,0,ScrW(),ScrH())
	end)

	for i = 1, 50 do
		timer.Simple(i/10, function()
			for i = 1, 6 do
				surface.PlaySound("npc/stalker/go_alert2a.wav")
			end
		end)
	end

	timer.Simple(5, function() 
		hook.Remove("HUDPaint", "screamer")
	end)
end)

netstream.Hook("InspectInventory", function(data)
	PrintTable(data)
	LocalPlayer().InspectInventory = data.inventory
	LocalPlayer().InspectTarget = data.target
	vgui.Create("nut_InspectInventory")
end)

netstream.Hook("nut_sendsound", function(sound)
	surface.PlaySound(sound)
end)

function SCHEMA:UpdateInspectInv(class, quantity, data)
	local itemTable = nut.item.Get(class)

	quantity = quantity or 1

	if (itemTable.data) then
		local oldData = data or {}

		data = table.Copy(itemTable.data)
		data = table.Merge(data, oldData)
	end

	local inventory = LocalPlayer().InspectInventory
	inventory[class] = inventory[class] or {}
	inventory = nut.util.StackInv(inventory, class, quantity, data)

	return true
end

net.Receive("forp_clothesupdate", function()
	local data = {}
	data[1] = net.ReadInt(4)
	data[2] = net.ReadEntity()
	data[3] = net.ReadString()
	data[4] = net.ReadString()


	if (data[1] == CLOTHES_FULLUPDATE) then
		SCHEMA.ClothesTable = von.deserialize(data[3])
		timer.Simple(0.5, function()
			SCHEMA:PurgeClothes()
		end)
	elseif (data[1] == CLOTHES_PARTIALUPDATE) then
		if type(SCHEMA.ClothesTable[data[2]]) != "table" then
			SCHEMA.ClothesTable[data[2]] = {}
		end

		if (data[2] and IsValid(data[2])) then
			SCHEMA.ClothesTable[data[2]][von.deserialize(data[3]).Type] = von.deserialize(data[3])
			SCHEMA:UpdateClothes(data[2])
		end
	elseif (data[1] == CLOTHES_DISCONNECTUPDATE) then
		if (data[2] and IsValid(data[2])) then
			SCHEMA.ClothesTable[data[2]] = nil
			SCHEMA:PurgeClothes()
		end
		timer.Simple(0.1, function()
			SCHEMA:PurgeClothes()
		end)
	elseif (data[1] == CLOTHES_PURGE) then
		SCHEMA:PurgeClothes()
	elseif (data[1] == CLOTHES_REMOVE) then
		if (data[2] and IsValid(data[2])) then
			SCHEMA.ClothesTable[data[2]][von.deserialize(data[3]).Type] = nil
		end
		SCHEMA:PurgeClothes()
	elseif (data[1] == CLOTHES_WIPE) then
		if (data[2] and IsValid(data[2])) then
			SCHEMA.ClothesTable[data[2]] = {}
		end
	elseif (data[1] == CLOTHES_DRAW) then
		local client = data[2]
		if (data[2] and IsValid(data[2])) then
			local clothestable = SCHEMA.ClothesTable[client]
		
			if SCHEMA.BodiesTable[client] then
				SCHEMA.BodiesTable[client] = nil
			end
		end
		SCHEMA:UpdateClothes(client)
		SCHEMA:PurgeClothes()
	end


	if data[4] ~= "NOPE" then
		if isstring(data[4]) or istable(data[4]) then
		SCHEMA:UpdateBodies(data[2], data[4])
		end
	end
	

	
end)

--function SCHEMA:GetClothesModel(client, clothesTable)
--	if type(clothesTable.model) == "table" then
--		return clothesTable.model[client:GetGender()]
--	elseif (clothesTable.Type == "Arms") then
--		return clothesTable.model..client:GetGender().."_arm"..".mdl"
--	else
--		return clothesTable.model..client:GetGender()..".mdl"
--	end
--end

--hook.Add("BuildHelpOptions", "nut_Credits", function(data)
--	data:AddHelp("Credits", function()
--		local html = ""
--
--		for k, v in SortedPairs(nut.flag.buffer) do
--			local color = "<font color=\"red\">&#10008;"
--
--			if (LocalPlayer():HasFlag(k)) then
--				color = "<font color=\"green\">&#10004;"
--			end
--
--			html = html.."<p><b>"..color.."&nbsp;</font>"..k.."</b><br /><hi><i>Description:</i> "..v.desc or nut.lang.Get("no_desc").."</p>"
--		end
--
--		return html
--
--	end, "icon16/flag_red.png")
--end)

function SCHEMA:GetClothesModel(client, clothesTable)
	if type(clothesTable.model) == "table" then
		return clothesTable.model[client:GetGender()]
	elseif ((client:IsGhoul()) and (clothesTable.Type == "Arms")) then
		return clothesTable.model.."ghoul_arm"..".mdl"
	elseif (clothesTable.Type == "Arms") then
		return clothesTable.model..client:GetGender().."_arm"..".mdl"
	else
		return clothesTable.model..client:GetGender()..".mdl"
	end
end

function SCHEMA:PurgeClothes(target)
	for k, v in pairs(ents.FindByClass("class C_PhysPropClientside")) do -- yeah, thanks garry really appreciate this one
		if (v.clothing) then
			v:Remove() -- this turns C_PhysPropClientside into a [NULL ENTITY], but not immediately??
			v = nil
		end
	end
	collectgarbage() -- start a garbage collection cycle
	
	for _, client in pairs(player.GetAll()) do
		if IsValid(client) and SCHEMA.ClothesTable[client] then
			if client != target and client:Alive() and !client:IsRagdolled() and !client:IsRobot() and !client:IsMutant() or client:IsGhoul() and !client:GetNetVar("noclipping") and !client:GetNetVar("stealth") then
				for k, v in pairs(SCHEMA.ClothesTable[client]) do
					v.entity = ents.CreateClientProp()
					if IsValid(v.entity) then -- check to make sure v.entity is exists before manipulating it
						v.entity:SetModel(SCHEMA:GetClothesModel(client, v))
						if (v.bodygroup) then
							v.entity:SetBodygroup(v.bodygroup[1], v.bodygroup[2])
						end
						if (v.skin) then
							v.entity:SetSkin(v.skin)
						end
						--if (v.Type == "Arms") then
						--	v.entity:SetSkin(client:GetSkinTone())
						--end
						if (v.Type == "Arms") then
							local arms = client:GetSkinTone()
							v.entity:SetSkin(arms)
						end

						if (v.T51b) then
							v.entity:SetBodygroup(2, 2)
							v.entity:SetBodygroup(3, 2)
							v.entity:SetBodygroup(4, 2)
							v.entity:SetBodygroup(5, 1)
							v.entity:SetBodygroup(6, 1)
							v.entity:SetBodygroup(7, 1)
							v.entity:SetBodygroup(8, 2)
							v.entity:SetBodygroup(9, 2)
						end
						v.entity:SetPos(client:GetPos())
						v.entity:SetParent(client)
						v.entity:AddEffects(bit.bor(EF_BONEMERGE,EF_BONEMERGE_FASTCULL,EF_PARENT_ANIMATES))
						v.entity.clothing = true
						v.entity:Spawn()
					end
				end
			end
			if !client:Alive() and !client:IsRobot() and !client:IsMutant() and SCHEMA.BodiesTable[client] and SCHEMA.ClothesTable[client] then
				if (SCHEMA.BodiesTable[client]) then
					local ragdoll = SCHEMA.BodiesTable[client]
					if ragdoll and IsValid(ragdoll) then
						for k, v in pairs(SCHEMA.ClothesTable[client]) do
							v.deathentity = ents.CreateClientProp()
							if IsValid(v.deathentity) then -- check to make sure v.deathentity is valid before manipulating it
								v.deathentity:SetModel(SCHEMA:GetClothesModel(client, v))
								if (v.bodygroup) then
									v.deathentity:SetBodygroup(v.bodygroup[1], v.bodygroup[2])
								end
								if (v.skin) then
									v.deathentity:SetSkin(v.skin)
								end
								if (v.Type == "Arms") then
									v.deathentity:SetSkin(client:GetSkinTone())
								end
								if (v.T51b) then
									v.deathentity:SetBodygroup(2, 2)
									v.deathentity:SetBodygroup(3, 2)
									v.deathentity:SetBodygroup(4, 2)
									v.deathentity:SetBodygroup(5, 1)
									v.deathentity:SetBodygroup(6, 1)
									v.deathentity:SetBodygroup(7, 1)
									v.deathentity:SetBodygroup(8, 2)
									v.deathentity:SetBodygroup(9, 2)
								end
								v.deathentity:SetPos(ragdoll:GetPos())
								v.deathentity:SetParent(ragdoll)
								v.deathentity:AddEffects(bit.bor(EF_BONEMERGE,EF_BONEMERGE_FASTCULL,EF_PARENT_ANIMATES))
								v.deathentity.clothing = true
								v.deathentity:Spawn()
							end
						end
					end
				end
			end
		end
	end
end

function SCHEMA:RemoveBodies(client)

	for k, v in pairs(ents.FindByClass("class C_PhysPropClientside")) do 
		if v:GetNWString("bodyid") == "body"..client:SteamID64() then 
			v:Remove()
		end
	end

end


function SCHEMA:UpdateBodies(client, body)

if string.len(body) < 5 then return end

    -- client:ChatPrint(client:GetNWString("BodyPath").."arms/"..client:GetGender().."_arm.mdl")
    entity = ents.CreateClientProp()
    entity:SetNWString("bodyid", "body" .. client:SteamID64())
    entity:SetModel(body)
    entity:SetSkin(client:GetSkinTone())
    entity:SetPos(client:GetPos())
    entity:SetParent(client)
    SCHEMA:RemoveBodies(client)
    entity = ents.CreateClientProp()
    entity:SetNWString("bodyid", "body" .. client:SteamID64())


    if not client:IsGhoul() then
        entity:SetModel(body)
		print(body)
        -- elseif client:GetRace() == "african" then
        -- client:SetSkin(3)
        -- elseif client:GetRace() == "asian" then
        -- client:SetSkin(7)
        -- elseif client:GetRace() == "hispanic" then
        -- client:SetSkin(4)
        -- end
    else
        entity:SetModel(body .. "arms/ghoul_arm.mdl")
    end


    entity:SetSkin(client:GetSkinTone())
    entity:SetPos(client:GetPos())
    entity:SetParent(client)
    entity:AddEffects(bit.bor(EF_BONEMERGE, EF_BONEMERGE_FASTCULL, EF_PARENT_ANIMATES))
    entity.body = true
    entity:Spawn()
	
end

function SCHEMA:UpdateClothes(client)
	SCHEMA:PurgeClothes(client)

	if (!LocalPlayer()) then
		return
	end

	if (!client or !IsValid(client)) then
		return
	end

	if client:IsRobot() or client:IsMutant() then
		return 
	end

	local model = string.lower(client:GetModel())

	if (client and IsValid(client) and SCHEMA.ClothesTable[client]) then
		for k, v in pairs(SCHEMA.ClothesTable[client]) do
			v.entity = ents.CreateClientProp()
			if IsValid(v.entity) then
				v.entity:SetModel(SCHEMA:GetClothesModel(client, v))
				if (v.bodygroup) then
					v.entity:SetBodygroup(v.bodygroup[1], v.bodygroup[2])
				end
				if (v.skin) then
					v.entity:SetSkin(v.skin)
				end
				if (v.Type == "Arms") then
					v.entity:SetSkin(client:GetSkinTone())
				end
				v.entity:SetPos(client:GetPos())
				v.entity:SetParent(client)
				v.entity:AddEffects(bit.bor(EF_BONEMERGE,EF_BONEMERGE_FASTCULL,EF_PARENT_ANIMATES))
				v.entity.clothing = true
				v.entity:Spawn()
			end
		end
	end
end

dormantplayers = dormantplayers or {}

hook.Add("Think", "FixDormantIssue", function()
	if SCHEMA.ClothesTable then
		for client, clothing in pairs(SCHEMA.ClothesTable) do
			if client != LocalPlayer() then
				if client:IsValid() then
					if !client:IsDormant() and dormantplayers[client] then
						for k, v in pairs(SCHEMA.ClothesTable[client]) do
							if v.entity and v.entity:IsValid() then
								v.entity:SetPos(client:GetPos())
								v.entity:SetParent(client)
								v.entity:AddEffects(bit.bor(EF_BONEMERGE,EF_BONEMERGE_FASTCULL,EF_PARENT_ANIMATES))
							end
						end
						dormantplayers[client] = false
					else
						dormantplayers[client] = true
					end
				end
			end
		end
	end
end)

function SCHEMA:OnEntityCreated(ragdoll)
	if (ragdoll and ragdoll:IsValid() and ragdoll:GetClass() == "class C_HL2MPRagdoll") then
		local client = ragdoll:GetRagdollOwner()
		self:CreateEntityRagdoll(client, ragdoll)
	end
end

-- currently only applies on local player.
-- should store cloth data on char or player.
function SCHEMA:CreateEntityRagdoll(client, ragdoll)
	if (!LocalPlayer()) then
		return
	end

	if (client and IsValid(client) and ragdoll and client:IsValid() and !client:IsRobot() and !client:IsMutant() and ragdoll:IsValid() and client.character and SCHEMA.ClothesTable[client]) then
		SCHEMA:PurgeClothes(client)
		local clothestable = SCHEMA.ClothesTable[client]
		for k, v in pairs(SCHEMA.ClothesTable[client]) do
			v.deathentity = ents.CreateClientProp()
			v.deathentity:SetModel(SCHEMA:GetClothesModel(client, v))
			if v.bodygroup then
				v.deathentity:SetBodygroup(v.bodygroup[1], v.bodygroup[2])
			end
			if (v.skin) then
				v.deathentity:SetSkin(v.skin)
			end
			if (v.Type == "Arms") then
				v.deathentity:SetSkin(client:GetSkinTone())
			end

			if (v.T51b) then
				v.deathentity:SetBodygroup(2, 2)
				v.deathentity:SetBodygroup(3, 2)
				v.deathentity:SetBodygroup(4, 2)
				v.deathentity:SetBodygroup(5, 1)
				v.deathentity:SetBodygroup(6, 1)
				v.deathentity:SetBodygroup(7, 1)
				v.deathentity:SetBodygroup(8, 2)
				v.deathentity:SetBodygroup(9, 2)
			end

			v.deathentity:SetPos(ragdoll:GetPos())
			v.deathentity:SetParent(ragdoll)
			v.deathentity:AddEffects(bit.bor(EF_BONEMERGE,EF_BONEMERGE_FASTCULL,EF_PARENT_ANIMATES))
			v.deathentity.clothing = true
			v.deathentity:Spawn()
		end
		SCHEMA.BodiesTable[client] = ragdoll
	end
end

function SCHEMA:HUDShouldPaintBar()
	return !nut.config.drawHUD
end

function SCHEMA:ForceDermaSkin()
	return "nutscript"
end 

local sunglasses = false
local powerarmor = false

-- Add a little bloom to simulate extra brightness outside.
function SCHEMA:RenderScreenspaceEffects()
	local color = {}
	color["$pp_colour_addr"] = 0
	color["$pp_colour_addg"] = 0
	color["$pp_colour_addb"] = 0.15
	color["$pp_colour_brightness"] = -0.1
	color["$pp_colour_contrast"] = 1
	color["$pp_colour_colour"] = 1.1
	color["$pp_colour_mulr"] = 0.15
	color["$pp_colour_mulg"] = 0.3
	color["$pp_colour_mulb"] = 0.45

	if (sunglasses) then
		if (nut.config.colorcorrection) then
			DrawColorModify(color)
			DrawBloom(0, 0, 2, 2, 1, 1, 1, 1, 1) 
		end
	else
		if (nut.config.colorcorrection) then
			DrawBloom(0.45, 0.5, 9, 9, 1, 1, 1, 1, 1) 
		end
	end
end

local vignette = vignette or Material("nutscript/vignette.png")

hook.Add("HUDPaint", "Sunglasses", function()
	if (nut.config.drawVignette and sunglasses or powerarmor) then

		for i = 1, 3 do 
			surface.SetDrawColor(255, 255, 255, 200)
			surface.SetMaterial(vignette)
			surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
		end
	end
end)

surface.CreateFont("RadioFreqFont", {
	font = "Tahoma",
	size = 96,
	weight = 500
})

surface.CreateFont("RadioFreqFontBlank", {
	font = "Arial",
	size = 96,
	weight = 500
})

function SCHEMA:SetRadioMenu(data, index)
	local radioFrame = vgui.Create("DFrame")
	radioFrame:SetSize(280,150)
	radioFrame:Center()
	radioFrame:SetTitle("Handheld Radio")
	radioFrame:MakePopup()
	radioFrame:ShowCloseButton(false)
	--print(data.Freq)
	local freq = data.Freq or "000.0"
	freq = string.Explode("", freq)

	local on = data.On or "off"
	local tempfreq = {}
	tempfreq[1] = tonumber(freq[1])
	tempfreq[2] = tonumber(freq[2])
	tempfreq[3] = tonumber(freq[3])
	tempfreq[4] = tonumber(freq[5])

	local closeButton = vgui.Create("DButton", radioFrame)
	closeButton:SetPos(216,4)
	closeButton:SetSize(60,20)
	closeButton:SetText("Close")
	closeButton.DoClick = function()
		local newfreq = tempfreq[1]..tempfreq[2]..tempfreq[3].."."..tempfreq[4]

		netstream.Start("nut_ToggleRadio", {index, on})
		netstream.Start("nut_RadioFreq", {index, newfreq})
		radioFrame:Remove()
		surface.PlaySound("forp/ui_menu_ok.wav")
	end

	local toggleButton = vgui.Create("DButton", radioFrame)
	toggleButton:SetPos(132,4)
	toggleButton:SetSize(60,20)
	toggleButton:SetText("Toggle")
	toggleButton.DoClick = function()
		if on == "on" then
			on = "off"
		else
			on = "on"
		end
		surface.PlaySound("forp/ui_menu_ok.wav")
	end

	local togglePanel = vgui.Create("DPanel", radioFrame)
	togglePanel:SetPos(196,4)
	togglePanel:SetSize(16,20)
	togglePanel:SetText("Toggle")
	togglePanel.Paint = function(p, w, h)

		surface.SetDrawColor(45, 45, 45, 240)
		surface.DrawOutlinedRect(0,0,w,h,1)

		if on == "on" then
			surface.SetDrawColor(110,255,110,255)
		else
			surface.SetDrawColor(255,110,110,255)
		end

		surface.DrawRect(1,1,w-2,h-2)
	end

	local freqDigitOne = vgui.Create("DButton", radioFrame)
	freqDigitOne:SetPos(4, 44)
	freqDigitOne:SetSize(60, 86)
	freqDigitOne:SetText(freq[1])
	freqDigitOne:SetFont("RadioFreqFont")
	freqDigitOne:SetContentAlignment(5)
	--freqDigitOne.Paint = function(p, w, h)
	--end

	local freqDigitTwo = vgui.Create("DButton", radioFrame)
	freqDigitTwo:SetPos(68, 44)
	freqDigitTwo:SetSize(60, 86)
	freqDigitTwo:SetText(freq[2])
	freqDigitTwo:SetContentAlignment(5)
	freqDigitTwo:SetFont("RadioFreqFont")
	--freqDigitTwo.Paint = function(p, w, h)
	--end

	local freqDigitThree = vgui.Create("DButton", radioFrame)
	freqDigitThree:SetPos(132, 44)
	freqDigitThree:SetSize(60, 86)
	freqDigitThree:SetText(freq[3])
	freqDigitThree:SetContentAlignment(5)
	freqDigitThree:SetFont("RadioFreqFont")
	--freqDigitThree.Paint = function(p, w, h)
	--end

	local freqDigitBlank = vgui.Create("DButton", radioFrame)
	freqDigitBlank:SetPos(192, 44)
	freqDigitBlank:SetSize(20, 86)
	freqDigitBlank:SetText(".")
	freqDigitBlank:SetContentAlignment(5)
	freqDigitBlank:SetFont("RadioFreqFontBlank")
	freqDigitBlank.Paint = function(p, w, h)
	end

	local freqDigitFour = vgui.Create("DButton", radioFrame)
	freqDigitFour:SetPos(216, 44)
	freqDigitFour:SetSize(60, 86)
	freqDigitFour:SetText(freq[5])
	freqDigitFour:SetContentAlignment(5)
	freqDigitFour:SetFont("RadioFreqFont")
	--freqDigitFour.Paint = function(p, w, h)
	--end

	local freqButtonOnePlus = vgui.Create("DButton", radioFrame)
	freqButtonOnePlus:SetSize(60, 16)
	freqButtonOnePlus:SetText("+")
	freqButtonOnePlus:SetPos(4, 29)
	freqButtonOnePlus.DoClick = function()
		tempfreq[1] = tempfreq[1] + 1
		if tempfreq[1] == 10 then
			tempfreq[1] = 0
		end

		freqDigitOne:SetText(tempfreq[1])
		surface.PlaySound("forp/ui_menu_ok.wav")
	end

	local freqButtonTwoPlus = vgui.Create("DButton", radioFrame)
	freqButtonTwoPlus:SetSize(60, 16)
	freqButtonTwoPlus:SetText("+")
	freqButtonTwoPlus:SetPos(68, 29)
	freqButtonTwoPlus.DoClick = function()
		tempfreq[2] = tempfreq[2] + 1
		if tempfreq[2] == 10 then
			tempfreq[2] = 0
		end

		freqDigitTwo:SetText(tempfreq[2])
		surface.PlaySound("forp/ui_menu_ok.wav")
	end

	local freqButtonThreePlus = vgui.Create("DButton", radioFrame)
	freqButtonThreePlus:SetSize(60, 16)
	freqButtonThreePlus:SetText("+")
	freqButtonThreePlus:SetPos(132, 29)
	freqButtonThreePlus.DoClick = function()
		tempfreq[3] = tempfreq[3] + 1
		if tempfreq[3] == 10 then
			tempfreq[3] = 0
		end

		freqDigitThree:SetText(tempfreq[3])
		surface.PlaySound("forp/ui_menu_ok.wav")
	end

	local freqButtonFourPlus = vgui.Create("DButton", radioFrame)
	freqButtonFourPlus:SetSize(60, 16)
	freqButtonFourPlus:SetText("+")
	freqButtonFourPlus:SetPos(216, 29)
	freqButtonFourPlus.DoClick = function()
		tempfreq[4] = tempfreq[4] + 1
		if tempfreq[4] == 10 then
			tempfreq[4] = 0
		end

		freqDigitFour:SetText(tempfreq[4])
		surface.PlaySound("forp/ui_menu_ok.wav")
	end

	local freqButtonOneMinus = vgui.Create("DButton", radioFrame)
	freqButtonOneMinus:SetSize(60, 16)
	freqButtonOneMinus:SetText("-")
	freqButtonOneMinus:SetPos(4, 129)
	freqButtonOneMinus.DoClick = function()
		tempfreq[1] = tempfreq[1] - 1
		if tempfreq[1] == -1 then
			tempfreq[1] = 9
		end

		freqDigitOne:SetText(tempfreq[1])
		surface.PlaySound("forp/ui_menu_ok.wav")
	end
	
	local freqButtonTwoMinus = vgui.Create("DButton", radioFrame)
	freqButtonTwoMinus:SetSize(60, 16)
	freqButtonTwoMinus:SetText("-")
	freqButtonTwoMinus:SetPos(68, 129)
	freqButtonTwoMinus.DoClick = function()
		tempfreq[2] = tempfreq[2] - 1
		if tempfreq[2] == -1 then
			tempfreq[2] = 9
		end

		freqDigitTwo:SetText(tempfreq[2])
		surface.PlaySound("forp/ui_menu_ok.wav")
	end
	
	local freqButtonThreeMinus = vgui.Create("DButton", radioFrame)
	freqButtonThreeMinus:SetSize(60, 16)
	freqButtonThreeMinus:SetText("-")
	freqButtonThreeMinus:SetPos(132, 129)
	freqButtonThreeMinus.DoClick = function()
		tempfreq[3] = tempfreq[3] - 1
		if tempfreq[3] == -1 then
			tempfreq[3] = 9
		end

		freqDigitThree:SetText(tempfreq[3])
		surface.PlaySound("forp/ui_menu_ok.wav")
	end
	
	local freqButtonFourMinus = vgui.Create("DButton", radioFrame)
	freqButtonFourMinus:SetSize(60, 16)
	freqButtonFourMinus:SetText("-")
	freqButtonFourMinus:SetPos(216, 129)
	freqButtonFourMinus.DoClick = function()
		tempfreq[4] = tempfreq[4] - 1
		if tempfreq[4] == -1 then
			tempfreq[4] = 9
		end

		freqDigitFour:SetText(tempfreq[4])
		surface.PlaySound("forp/ui_menu_ok.wav")
	end
end

function SCHEMA:CreateSideMenu(menu)
	timer.Simple(0.01, function()
		for k, v in ipairs(SCHEMA:GetCurrencyIndex()) do
			if (LocalPlayer():getCurrency(k) > 0) then
				menu.money = menu:Add("DLabel")
				menu.money:Dock(TOP)
				menu.money.Think = function(label)
					label:SetText(SCHEMA:getCurrencyName(k, LocalPlayer():getCurrency(k)))
				end
				menu.money:SetContentAlignment(6)
				menu.money:SetTextColor(color_white)
				menu.money:SetExpensiveShadow(1, color_black)
				menu.money:SetFont("nut_TargetFont")
				menu.money:DockMargin(4, 4, 4, 4)
			end
		end
	end)
end

function SCHEMA:InspectItem(item)
	local data = item.itemData
	local itemname = data.custom and data.custom.name or item.name
	local itemmodel = data.custom and data.custom.model or item.model
	local itemquality = data.custom and data.custom.quality or "common"
	local itemcondition = 100

	if (data.custom and data.custom.condition) then
		itemcondition = data.custom.condition
	end

	local inspectFrame = vgui.Create("DFrame")
	inspectFrame:SetSize(450, 250)
	inspectFrame:Center()
	inspectFrame:SetTitle(itemname)
	inspectFrame:MakePopup()

	local inspectPanelTop = vgui.Create("DPanel", inspectFrame)
	inspectPanelTop:Dock(TOP)
	inspectPanelTop:SetTall(166)

	local inspectModel = vgui.Create("DModelPanel", inspectPanelTop)
	inspectModel:Dock(FILL)
	inspectModel:SetModel(itemmodel)
	inspectModel:SetFOV(item.inspectFOV or 15)
	inspectModel:SetLookAt(Vector(0,0,0))

	local itemtext = "This item appears to have "..itemcondition.."% condition\n".."This item is considered to be "..itemquality.."\n".."This item weighs "..item.weight.."lbs"

	local inspectPanelBottom = vgui.Create("DPanel", inspectFrame)
	inspectPanelBottom:Dock(BOTTOM)
	inspectPanelBottom:SetTall(48)

	local inspectText = vgui.Create("DLabel", inspectPanelBottom)
	inspectText:SetText(itemtext)
	inspectText:Dock(FILL)
	--inspectText:SetTextColor(Color(35,35,35,255))
	inspectText:SetContentAlignment(5)

	if data.custom and data.custom.wepdamage then
		inspectFrame:SetSize(450, 300)
		inspectPanelBottom:SetTall(98)
		itemtext = itemtext.."\n".."This weapon does "..(data.custom.wepdamage * 100).."% damage\n".."This weapon has "..(data.custom.weprecoil * 100).."% recoil\n".."This weapon has "..(data.custom.wepspread * 100).."% spread\n".."This weapons magazine capacity is "..data.custom.maxmagsize.." rounds"
		inspectText:SetText(itemtext)
	end
end

function SCHEMA:ModifyItem(item, index)
	local data = item.itemData
	local itemname, itemmodel, itemdesc, itemcolor, itemquality, itemcondition, wepdamage, weprecoil, wepspread, wepfiredelay, overridemagsize, maxmagsize
	if data.custom then
		itemname = data.custom.name
		itemmodel = data.custom.model
		itemdesc = data.custom.desc
		itemcolor = data.custom.color
		itemquality = data.custom.quality
		itemcondition = data.custom.condition
		wepdamage = data.custom.wepdamage
		weprecoil = data.custom.weprecoil
		wepspread = data.custom.wepspread
		wepfiredelay = data.custom.wepfiredelay
		overridemagsize = data.custom.overridemagsize
		maxmagsize = data.custom.maxmagsize
	else
		itemname = item.name
		itemmodel = item.model
		itemdesc = item.desc
		itemcolor = nut.config.mainColor
		itemquality = "common"
		itemcondition = 100
		wepdamage = 1
		weprecoil = 1
		wepspread = 1
		wepfiredelay = 1
		overridemagsize = false
		maxmagsize = 30
	end

	local modifyFrame = vgui.Create("DFrame")
	modifyFrame:SetSize(450, 600)
	modifyFrame:Center()
	modifyFrame:SetTitle(itemname)
	modifyFrame:MakePopup()
	modifyFrame:ShowCloseButton(false)

	local modifyScroll = vgui.Create("DScrollPanel", modifyFrame)
	modifyScroll:Dock(FILL)

	local modifyLabel = vgui.Create("DLabel", modifyScroll)
	modifyLabel:SetText("Name:")
	modifyLabel:Dock(TOP)

	local modifyName = vgui.Create("DTextEntry", modifyScroll)
	modifyName:SetToolTip("This is the new name of the item you are modifying.")
	modifyName:SetText(itemname)
	modifyName:Dock(TOP)

	modifyLabel = vgui.Create("DLabel", modifyScroll)
	modifyLabel:SetText("Description:")
	modifyLabel:Dock(TOP)

	local modifyDescription = vgui.Create("DTextEntry", modifyScroll)
	modifyDescription:SetText(itemdesc)
	modifyDescription:Dock(TOP)

	modifyLabel = vgui.Create("DLabel", modifyScroll)
	modifyLabel:SetText("Model:")
	modifyLabel:Dock(TOP)

	local modifyModel = vgui.Create("DTextEntry", modifyScroll)
	modifyModel:SetToolTip("This is a path to the model of the item you are modifying.")
	modifyModel:SetText(itemmodel)
	modifyModel:Dock(TOP)

	modifyLabel = vgui.Create("DLabel", modifyScroll)
	modifyLabel:SetText("Color:")
	modifyLabel:Dock(TOP)

	local modifyColor = vgui.Create("DColorMixer", modifyScroll)
	modifyColor:Dock(TOP)
	modifyColor:SetColor(itemcolor)

	modifyLabel = vgui.Create("DLabel", modifyScroll)
	modifyLabel:SetText("Quality:")
	modifyLabel:Dock(TOP)

	local choices = {"common", "rare", "legendary", "radioactive", "godlike", "unique", "epic", "one of a kind"}

	local modifyQuality = vgui.Create("DComboBox", modifyScroll)
	modifyQuality:SetToolTip("This is the item quality, please select appropriate qualities for your items.")
	modifyQuality:Dock(TOP)
	modifyQuality:SetValue(itemquality)
	for k, v in pairs(choices) do
		modifyQuality:AddChoice(v)
	end

	modifyLabel = vgui.Create("DLabel", modifyScroll)
	modifyLabel:SetText("Condition:")
	modifyLabel:Dock(TOP)

	local modifyCondition = vgui.Create("DNumberWang", modifyScroll)
	modifyCondition:SetToolTip("This is how damaged the item is.")
	modifyCondition:Dock(TOP)
	modifyCondition:SetMinMax(0, 100)
	modifyCondition:SetValue(itemcondition)

	modifyLabel = vgui.Create("DLabel", modifyScroll)
	modifyLabel:SetText("Is weapon?:")
	modifyLabel:Dock(TOP)

	local checkboxPanel = vgui.Create("DPanel", modifyScroll)
	checkboxPanel:Dock(TOP)

	local modifyWeaponCheckBox = vgui.Create("DCheckBox", checkboxPanel)
	modifyWeaponCheckBox:SetToolTip("Please tick this if you are modifying a weapon")

	modifyLabel = vgui.Create("DLabel", modifyScroll)
	modifyLabel:SetText("Damage Multiplier:")
	modifyLabel:Dock(TOP)

	local modifyWepDamage = vgui.Create("DNumberWang", modifyScroll)
	modifyWepDamage:SetToolTip("This is multiplied by weapon damage to determine how much damage a weapon can do. (multiplier x damage)")
	modifyWepDamage:Dock(TOP)
	modifyWepDamage:SetMinMax(0, 10)
	modifyWepDamage:SetValue(wepdamage)

	modifyLabel = vgui.Create("DLabel", modifyScroll)
	modifyLabel:SetText("Recoil Multiplier:")
	modifyLabel:Dock(TOP)

	local modifyWepRecoil = vgui.Create("DNumberWang", modifyScroll)
	modifyWepRecoil:SetToolTip("This is multiplied by weapon recoil to determine how much recoil the weapon has. (multiplier x recoil)")
	modifyWepRecoil:Dock(TOP)
	modifyWepRecoil:SetMinMax(0, 10)
	modifyWepRecoil:SetValue(weprecoil)

	modifyLabel = vgui.Create("DLabel", modifyScroll)
	modifyLabel:SetText("Spread Multiplier:")
	modifyLabel:Dock(TOP)

	local modifyWepSpread = vgui.Create("DNumberWang", modifyScroll)
	modifyWepSpread:SetToolTip("This is multiplied by weapon spread to determine how much spread the weapon has. (multiplier x spread)")
	modifyWepSpread:Dock(TOP)
	modifyWepSpread:SetMinMax(0, 10)
	modifyWepSpread:SetValue(wepspread)

	modifyLabel = vgui.Create("DLabel", modifyScroll)
	modifyLabel:SetText("Fire Delay Multipier:")
	modifyLabel:Dock(TOP)

	local modifyWepFireDelay = vgui.Create("DNumberWang", modifyScroll)
	modifyWepFireDelay:SetToolTip("This is multiplied by the firedelay to determine how fast you can shoot the weapon.")
	modifyWepFireDelay:Dock(TOP)
	modifyWepFireDelay:SetMinMax(0, 3)
	modifyWepFireDelay:SetValue(wepfiredelay)

	modifyLabel = vgui.Create("DLabel", modifyScroll)
	modifyLabel:SetText("Override Attatchment Max Magazine Size:")
	modifyLabel:Dock(TOP)

	checkboxPanel = vgui.Create("DPanel", modifyScroll)
	checkboxPanel:Dock(TOP)

	local modifyWeaponMaxMagazineOverride = vgui.Create("DCheckBox", checkboxPanel)
	modifyWeaponMaxMagazineOverride:SetToolTip("Tick to override attatchment max magazine size")
	modifyWeaponMaxMagazineOverride:SetChecked(overridemagsize)

	modifyLabel = vgui.Create("DLabel", modifyScroll)
	modifyLabel:SetText("Magazine Size:")
	modifyLabel:Dock(TOP)

	local modifyWepMagSize = vgui.Create("DNumberWang", modifyScroll)
	modifyWepMagSize:SetToolTip("This is the maximum magazine size.")
	modifyWepMagSize:Dock(TOP)
	modifyWepMagSize:SetMinMax(0, 100)
	modifyWepMagSize:SetValue(maxmagsize)

	local cancelButton = vgui.Create("DButton", modifyFrame)
	cancelButton:SetPos(322,4)
	cancelButton:SetSize(60,20)
	cancelButton:SetText("Abort")
	cancelButton.DoClick = function()
		modifyFrame:Remove()
		surface.PlaySound("forp/ui_menu_cancel.wav")
	end

	local closeButton = vgui.Create("DButton", modifyFrame)
	closeButton:SetPos(386,4)
	closeButton:SetSize(60,20)
	closeButton:SetText("Done")
	closeButton.DoClick = function()
		local customdata = {}
		customdata[1] = item.uniqueID
		customdata[2] = index
		customdata[3] = {}

		customdata[3].name = modifyName:GetValue()
		customdata[3].model = modifyModel:GetValue()
		customdata[3].desc = modifyDescription:GetValue()
		customdata[3].color = modifyColor:GetColor()
		customdata[3].quality = modifyQuality:GetValue()
		customdata[3].condition = modifyCondition:GetValue()

		if modifyWeaponCheckBox:GetChecked() then
			customdata[3].wepdamage = modifyWepDamage:GetValue()
			customdata[3].weprecoil = modifyWepRecoil:GetValue()
			customdata[3].wepspread = modifyWepSpread:GetValue()
			customdata[3].wepfiredelay = modifyWepFireDelay:GetValue()
			customdata[3].overridemagsize = modifyWeaponMaxMagazineOverride:GetChecked()
			customdata[3].maxmagsize = modifyWepMagSize:GetValue()
		end

		netstream.Start("nut_ModifyItem", customdata)

		modifyFrame:Remove()
		surface.PlaySound("forp/ui_menu_ok.wav")
	end
end