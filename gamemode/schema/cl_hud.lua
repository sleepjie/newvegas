local PB_RED 	= PB_RED or 255
local PB_GREEN 	= PB_GREEN or 255
local PB_BLUE 	= PB_BLUE or 255
local trace 	= ErrorNoHalt
local drawcross = drawcross or true

local LoadedColor = LoadedColor or false

local htock = surface.GetTextureID("hud/fo/tick") 
local hammo = surface.GetTextureID("hud/fo/ammo") 
local cross = surface.GetTextureID("hud/fo/crhossair") 

local cross_normal = Material("forp/glow_crosshair.png", "noclamp smooth")
local cross_highlight = Material("forp/glow_crosshair_filled.png", "noclamp smooth")
local bottom_infobars = Material("forp/glow_hud_bottom_info_seperator_divider.png", "noclamp smooth")

concommand.Add("refreshcolor", function() SCHEMA:RefreshColor() end)

function SCHEMA:RefreshColor()
	LoadedColor = false
end

function SCHEMA:GetPBColor(a)
	if (!LoadedColor) then
		if file.Exists("lazaruscolors.txt", "DATA") then
			local colors = string.Explode(" ", file.Read("lazaruscolors.txt", "DATA"))
			PB_RED = colors[1]
			PB_GREEN = colors[2]
			PB_BLUE = colors[3]


			LoadedColor = true
		else
			file.Write("lazaruscolors.txt", "255 194 0")

			PB_RED = 255
			PB_GREEN = 194
			PB_BLUE = 0

			LoadedColor = true
		end
	end
	
	return Color(PB_RED, PB_GREEN, PB_BLUE, a or 255)
end
---------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------

-- This HUD was created by Gonzolablog, we have permission to use a modified version --

---------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------

function SCHEMA.DrawBlur(x,y,text,align,blur,color,font,blurfont,alpha)
	local alpha = alpha or 255

	if blur == nil then 
		blur = false 
	end

	if color and color != 0 then
		color = color
	else
		color = SCHEMA:GetPBColor()
	end

	local normfo, blurfo = "FOFont_normal", "FOFont_normal_blur"

	if (font and blurfont) then
		normfo = font
		blurfo = blurfont
	end

	if (!blur) then
		for i =0,3 do
			draw.SimpleText(text, blurfo, x, y, Color(0, 0, 0, alpha), align, 0)
		end

		draw.SimpleText(text, normfo, x, y, color, align, 0)
	else
		for i =0,3 do
			draw.SimpleText(text, "FOFont_big_blur", x, y, Color(0, 0, 0, alpha), align, 0)
		end

		draw.SimpleText(text, "FOFont_big", x, y, color, align, 0)
	end
end

local validclasses = {"nut_keys", "nut_fists", "weapon_physgun", "gmod_tool"}

local val = val or ""
local weight = weight or ""
local interactname = interactname or 0
local name = name or ""
local itemcolor =itemcolor or 0 
local isdoor = isdoor or false
local isbench = isbench or false

hook.Add("Think", "HUD_DrawInfoCheck", function()
	local trace = LocalPlayer():GetEyeTraceNoCursor()
	local refresh = true

	if (LocalPlayer():GetPos():Distance(trace.HitPos)) < 128 then
		if (trace.Entity and trace.Entity:GetClass() != "Worldspawn") then
			if (trace.Entity.GetInteractionData) then
				local interactinfo = trace.Entity:GetInteractionData()
				itemcolor = interactinfo[5] or 0
				val = interactinfo[4]  or "--"
				weight = interactinfo[3] or "--"
				interactname = interactinfo[2]  or ""
				name = interactinfo[1] or "Take"

				refresh = false
			elseif (trace.Entity.isdoor) then
				name = trace.Entity:GetType()
				interactname = trace.Entity:GetDestination()
				isdoor = true
				refresh = false
			elseif (trace.Entity.craftingbench) then
				name = "horse"
				interactname = "horse"
				isbench = true
				refresh = false
			end
		end
	end

	if (refresh) then
		isdoor, itemcolor, weight, interactname, val, name = false, 0, "", 0, "", ""
		isbench = false
	end
end)

hook.Add("HUDPaint","DrawHUDFO",function() 

	if !nut.config.drawHUD then 
		return 
	end

	if LocalPlayer().character == nil then 
		return 
	end
	local class = "nut_keys"
	if (LocalPlayer():Alive() and LocalPlayer():GetActiveWeapon():IsValid()) then
		class = LocalPlayer():GetActiveWeapon():GetClass()
	end

	if table.HasValue(validclasses, class) then
		if (LocalPlayer():Alive() and !LocalPlayer():IsRagdolled()) then
			if !(LocalPlayer():GetAmmoCount(LocalPlayer():GetActiveWeapon():GetPrimaryAmmoType()) > 0 or LocalPlayer():GetActiveWeapon():Clip1() > -1) then
				if (name != "" and interactname != "") then
					if (!isdoor and !isbench) then
						if (drawcross) then
							surface.SetMaterial(cross_highlight)
							surface.SetDrawColor(SCHEMA:GetPBColor())
							surface.DrawTexturedRectRotated(ScrW()/2, ScrH() /2, 64,64,0)
						end
	
						surface.SetMaterial(bottom_infobars)
						surface.DrawTexturedRectRotated(ScrW()/2, ScrH() - 40, 323, 128, 0)
	
						SCHEMA.DrawBlur(ScrW()/2, ScrH() - 160,"E) "..name, 1, false)
						SCHEMA.DrawBlur(ScrW()/2, ScrH() - 136, interactname, 1, false)
	
	
						SCHEMA.DrawBlur(ScrW()/2 - 130, ScrH() - 80,"WG", 0, false)
						SCHEMA.DrawBlur(ScrW()/2 - 20, ScrH() - 80,weight, 2, false)
						
						if (itemcolor != 0) then
							if string.len(tostring(val)) > 8 then
								SCHEMA.DrawBlur(ScrW()/2 + 20, ScrH() - 80,"VAL", 0, false)
								SCHEMA.DrawBlur(ScrW()/2 + 56, ScrH() - 80,string.upper(tostring(val)), 0, false, itemcolor)
							else
								SCHEMA.DrawBlur(ScrW()/2 + 20, ScrH() - 80,"VAL", 0, false)
								SCHEMA.DrawBlur(ScrW()/2 + 120, ScrH() - 80,string.upper(tostring(val)), 2, false, itemcolor)
							end
						else
							if string.len(tostring(val)) > 8 then
								SCHEMA.DrawBlur(ScrW()/2 + 20, ScrH() - 80,"VAL", 0, false)
								SCHEMA.DrawBlur(ScrW()/2 + 56, ScrH() - 80,string.upper(tostring(val)), 0, false)
							end
							SCHEMA.DrawBlur(ScrW()/2 + 20, ScrH() - 80,"VAL", 0, false)
							SCHEMA.DrawBlur(ScrW()/2 + 120, ScrH() - 80,string.upper(tostring(val)), 2, false)
						end
					elseif (isbench) then
						if (drawcross) then
							surface.SetMaterial(cross_highlight)
							surface.SetDrawColor(SCHEMA:GetPBColor())
							surface.DrawTexturedRectRotated(ScrW()/2, ScrH() /2, 64,64,0)
						end

						SCHEMA.DrawBlur(ScrW()/2, ScrH() - 160,"E) ".."Interact With Crafting Bench", 1, false)
					else
						if (drawcross) then
							surface.SetMaterial(cross_highlight)
							surface.SetDrawColor(SCHEMA:GetPBColor())
							surface.DrawTexturedRectRotated(ScrW()/2, ScrH() /2, 64,64,0)
						end

						SCHEMA.DrawBlur(ScrW()/2, ScrH() - 160,"E) ".."Open", 1, false)
						SCHEMA.DrawBlur(ScrW()/2, ScrH() - 136, name.." to "..interactname, 1, false)
					end
				else
					if (drawcross) then
						surface.SetMaterial(cross_normal)
						surface.SetDrawColor(SCHEMA:GetPBColor())
						surface.DrawTexturedRectRotated(ScrW()/2, ScrH() /2, 64,64,0)
					end
				end
			end
		end
	end

	surface.SetTexture(hammo)
	surface.SetDrawColor(PB_RED,PB_GREEN,PB_BLUE,255)   
	surface.DrawTexturedRectRotated( ScrW() - 170, ScrH() - 40, 390,200,0 )

	if LocalPlayer().character:GetVar("stamina", 0) <= 100 && LocalPlayer().character:GetVar("stamina", 0) then
		hl = LocalPlayer().character:GetVar("stamina", 0)
		for i=0,hl/2.75 do
			surface.SetTexture(htock)
			surface.SetDrawColor(PB_RED,PB_GREEN,PB_BLUE,255)
			surface.DrawTexturedRectRotated( ScrW()  - 90 - i * 6, ScrH() - 100, 20,24,0 )
		end

		elseif(LocalPlayer():Health() > 0) then

		for i=0,36.3636 do
			surface.SetTexture(htock)
			surface.SetDrawColor(PB_RED,PB_GREEN,PB_BLUE,255)
			surface.DrawTexturedRectRotated( ScrW() - 100 - i * 7, ScrH() - 116, 24,30,0 )
		end
	end
end)

local compass = surface.GetTextureID("hud/fo/compass") 
local npc = surface.GetTextureID("hud/fo/pointer2") 
local player = surface.GetTextureID("hud/fo/player_found") 
local objetive = surface.GetTextureID("hud/fo/objetive")

hook.Add("HUDPaint","DRAWFOTEXT",function()

	if !nut.config.drawHUD then 
		return 
	end

	SCHEMA.DrawBlur(90,ScrH() - 135,"HP",0)
	SCHEMA.DrawBlur(ScrW() - 95,ScrH() - 135,"AP",2)

	if(LocalPlayer():GetActiveWeapon():IsValid()) then
		if LocalPlayer():GetAmmoCount(LocalPlayer():GetActiveWeapon():GetPrimaryAmmoType()) > 0 or LocalPlayer():GetActiveWeapon():Clip1() > -1 then
			if(LocalPlayer():GetActiveWeapon():Clip1() > -1) then
				SCHEMA.DrawBlur(ScrW() - 95,ScrH() - 80,tostring(LocalPlayer():GetActiveWeapon():Clip1()).."/"..tostring(LocalPlayer():GetAmmoCount(LocalPlayer():GetActiveWeapon():GetPrimaryAmmoType())),2)
			else
				SCHEMA.DrawBlur(ScrW() - 95,ScrH() - 80,tostring(LocalPlayer():GetAmmoCount(LocalPlayer():GetActiveWeapon():GetPrimaryAmmoType())),2)
			end
		end
	end

	for c,b in pairs(ents.GetAll()) do
		if(b:GetNWBool("FOObjetive") == true) then
			ang = LocalPlayer():GetAngles().y - SCHEMA.GetAngleOfLineBetweenTwoPoints(LocalPlayer(),b)
				if (ang < -103) then
					ang = -104
				elseif(ang > 145) then
					ang = 145
				end

				surface.SetTexture(objetive)

				if(b:GetNWBool("Enemy") == true) then
					surface.SetDrawColor(255,75,75,255)
				else
					surface.SetDrawColor(PB_RED, PB_GREEN, PB_BLUE, 255)
				end
			surface.DrawTexturedRectRotated(ang + 202, ScrH() - 48 , 48,48,0 )
		end
	end
	surface.SetTexture(compass)
	surface.SetDrawColor(PB_RED, PB_GREEN, PB_BLUE, 255)
	SCHEMA.DrawPartialTexturedRect( 82, ScrH() - 97, 256, 64, (-LocalPlayer():GetAngles().y/360) * 1024, 0, 256, 64,1024,64 );
end)

local htick = surface.GetTextureID("hud/fo/tick") 
local hbar = surface.GetTextureID("hud/fo/life_hud") 
local henemy = surface.GetTextureID("hud/fo/enemy_health") 
local armor = surface.GetTextureID("hud/fo/armor") 

hook.Add("HUDPaint","FOHL",function()
	if !nut.config.drawHUD then 
		return 
	end
	
	surface.SetTexture(hbar)
	surface.SetDrawColor(PB_RED, PB_GREEN, PB_BLUE, 255)
	surface.DrawTexturedRectRotated( 264, ScrH() - 40, 390,200,0 )

	if(LocalPlayer():Health() <= 100 && LocalPlayer():Health() > 0) then
		hl = LocalPlayer():Health()
		for i=0,hl/2.75 do
			surface.SetTexture(htick)
			surface.SetDrawColor(PB_RED, PB_GREEN, PB_BLUE, 255)
			surface.DrawTexturedRectRotated( 92.5 + i * 6, ScrH() - 100, 20,24,0 )
		end
	elseif(LocalPlayer():Health() > 0) then
		for i=0,36.3636 do
			surface.SetTexture(htick)
			surface.SetDrawColor(PB_RED, PB_GREEN, PB_BLUE, 255)
			surface.DrawTexturedRectRotated( 92.5 + i * 6, ScrH() - 100, 20,24,0 )
		end
	end

	if (LocalPlayer():Armor() > 0) then
			surface.SetTexture(armor)
			surface.SetDrawColor(PB_RED, PB_GREEN, PB_BLUE, 255)
			surface.DrawTexturedRectRotated( 327, ScrH() - 102, 20,20,0 )
	end

	if(LocalPlayer():GetNWEntity("FOVictim"):IsValid()) then
		SCHEMA.DrawBlur(ScrW()/2,ScrH() - 85,LocalPlayer():GetNWEntity("FOVictim"):GetClass(),1,false)

		surface.SetTexture(henemy)
		surface.SetDrawColor(255,70,70,255)
		surface.DrawTexturedRectRotated( ScrW() / 2 + 60, ScrH() - 75, 390,75,0 )
		exponent = LocalPlayer():GetNWInt("VOHLT")/LocalPlayer():GetNWInt("VLIFE") * 100

		for i=0,exponent/6.5 do
			surface.SetTexture(htick)
			surface.SetDrawColor(255,70,70,255)
			surface.DrawTexturedRectRotated( ScrW() / 2 + 5 - i * 6, ScrH() - 100, 24,30,0 )
		end

		for i=0,exponent/6.5 do
			surface.SetTexture(htick)
			surface.SetDrawColor(255,70,70,255)
			surface.DrawTexturedRectRotated( ScrW() / 2 + 10 + i * 6, ScrH() - 100, 23,30,0 )
		end
	end
end)

function SCHEMA.DrawPartialTexturedRect(x, y, w, h, partx, party, partw, parth, texw, texh)

    -- Verify that we recieved all arguments
    if !( x && y && w && h && partx && party && partw && parth && texw && texh ) then

        return
    end

    -- Get the positions and sizes as percentages / 100
    local percX, percY = partx / texw, party / texh
    local percW, percH = partw / texw, parth / texh

    -- Process the data
    local vertexData = {
        {
            x = x,
            y = y,
            u = percX,
            v = percY
        },
        {
            x = x + w,
            y = y,
            u = percX + percW,
            v = percY
        },
        {
            x = x + w,
            y = y + h,
            u = percX + percW,
            v = percY + percH
        },
        {
            x = x,
            y = y + h,
            u = percX,
            v = percY + percH
        }
    }
    surface.DrawPoly( vertexData )
end

--function SCHEMA.DrawPartialTexturedRect( x, y, w, h, partx, party, partw, parth, texturename )
--
--    if !( x && y && w && h && partx && party && partw && parth && texturename ) then
--    	return
--    end
--
--    local texture = surface.GetTextureID(texturename)
--    local texW, texH = surface.GetTextureSize( texture )
--    local percX, percY = partx / texW, party / texH
--    local percW, percH = partw / texW, parth / texH
--
--    local vertexData = {
--        {
--            x = x,
--            y = y,
--            u = percX,
--            v = percY
--        },
--        {
--            x = x + w,
--            y = y,
--            u = percX + percW,
--            v = percY
--        },
--        {
--            x = x + w,
--            y = y + h,
--            u = percX + percW,
--            v = percY + percH
--        },
--        {
--            x = x,
--            y = y + h,
--            u = percX,
--            v = percY + percH
--        }
--    }
--
--    surface.SetTexture( texture )
--    surface.SetDrawColor( 255, 255, 255, 255  * multiplo_fixture )
--    surface.DrawPoly( vertexData )
--end

local pointer = surface.GetTextureID("hud/fo/pointer") 
local cPos = Vector(0,0,0)

function SCHEMA.GetOurAttachment(npc) -- Create a selfmade function, that takes 1 argument.
	local ID = npc:LookupAttachment("eyes") -- this will return a number corresponding with the given attachment.
	return npc:GetAttachment( ID ) -- this will return a small table, see GetAttachment for more information.
end

hook.Add("HUDPaint","PaintArrowsFO",function()
	if !nut.config.drawHUD then 
		return 
	end

	for k,v in pairs(ents.FindInSphere(LocalPlayer():GetPos(),2048)) do
		if(v:IsNPC()) then
			if(v:LookupAttachment("eyes") != 0) then

				cPos = SCHEMA.GetOurAttachment(v).Pos
				cPos = cPos + Vector(0,0,10)
				surface.SetTexture(pointer)

				if(v:GetNWBool("Enemy") == true) then
					surface.SetDrawColor(255,75,75,255)
				else
					surface.SetDrawColor(PB_RED, PB_GREEN, PB_BLUE, 255)
				end

				surface.DrawTexturedRectRotated( cPos:ToScreen().x, cPos:ToScreen().y , 32,32,0 )
			end
		end
	end
end)

function SCHEMA.GetAngleOfLineBetweenTwoPoints(p1, p2)
    xDiff = p2:GetPos().x - p1:GetPos().x
    yDiff = p2:GetPos().y - p1:GetPos().y
    return math.atan2(yDiff, xDiff) * (180 / math.pi)
end

local divider_left = Material("forp/glow_messages_left_seperator.png", "noclamp smooth")
local divider_right = Material("forp/glow_messages_right_seperator.png", "noclamp smooth")


SCHEMA.NotificationTimer = CurTime()
SCHEMA.CurrentNotification = 0
SCHEMA.Notifications = {} -- {message = "", messagetwo = "", messagethree = "", sound = "", image = 0, pos = 0}

--[[hook.Add("Think", "SCHEMA.NotificationThink", function()
	if (#SCHEMA.Notifications > 0) and (CurTime() > SCHEMA.NotificationTimer) then
		SCHEMA.CurrentNotification = SCHEMA.Notifications[#SCHEMA.Notifications]
		surface.PlaySound(SCHEMA.Notifications[#SCHEMA.Notifications].sound)
		SCHEMA.NotificationTimer = CurTime() + 4
		hook.Remove("HUDPaint", "PaintNotification")

		local info = SCHEMA.Notifications[#SCHEMA.Notifications]

		hook.Add("HUDPaint", "PaintNotification", function()
			if (SCHEMA.CurrentNotification.pos == 0) then
				surface.SetMaterial(divider_left)
				surface.SetDrawColor(SCHEMA:GetPBColor())
				surface.DrawTexturedRect(16, 16, (512*1.25), (128*1.25))
			
				SCHEMA.DrawBlur(128, 38, SCHEMA.CurrentNotification.message, TEXT_ALIGN_LEFT, false, SCHEMA:GetPBColor())
				SCHEMA.DrawBlur(128, 58, SCHEMA.CurrentNotification.messagetwo, TEXT_ALIGN_LEFT, false, SCHEMA:GetPBColor())
				SCHEMA.DrawBlur(128, 78, SCHEMA.CurrentNotification.messagethree, TEXT_ALIGN_LEFT, false, SCHEMA:GetPBColor())

				surface.SetMaterial(SCHEMA.NotificationMaterials[SCHEMA.CurrentNotification.image])
				surface.SetDrawColor(SCHEMA:GetPBColor())
				surface.DrawTexturedRect(16, 18, 128, 128)
			else
				SCHEMA.DrawBlur(ScrW() - 128, 38, SCHEMA.CurrentNotification.message, TEXT_ALIGN_RIGHT, false, SCHEMA:GetPBColor())
				SCHEMA.DrawBlur(ScrW() - 128, 58, SCHEMA.CurrentNotification.messagetwo, TEXT_ALIGN_RIGHT, false, SCHEMA:GetPBColor())
				SCHEMA.DrawBlur(ScrW() - 128, 78, SCHEMA.CurrentNotification.messagethree,  TEXT_ALIGN_RIGHT, false, SCHEMA:GetPBColor())
			
				surface.SetMaterial(divider_right)
				surface.SetDrawColor(SCHEMA:GetPBColor())
				surface.DrawTexturedRect((ScrW() - ((512*1.25) + 16)), 16, (512*1.25), (128*1.25))
			
				surface.SetMaterial(SCHEMA.NotificationMaterials[SCHEMA.CurrentNotification.image])
				surface.SetDrawColor(SCHEMA:GetPBColor())
				surface.DrawTexturedRect((ScrW() - 150), 18, 128, 128)
			end
		end)

		timer.Simple(4, function()
			hook.Remove("HUDPaint", "PaintNotification")
		end)

		table.remove(SCHEMA.Notifications)
	end
end)]]--

function PaintNotification()
	if #SCHEMA.Notifications > 0 then
		if not SCHEMA.Notifications[1].timer then
			-- this is new!
			surface.PlaySound(SCHEMA.Notifications[1].sound)
			SCHEMA.Notifications[1].timer = CurTime() + 4
		elseif SCHEMA.Notifications[1].timer <= CurTime() then
			-- times up, skip a frame but thats ok!
			table.remove(SCHEMA.Notifications, 1)
			return
		end
		if (SCHEMA.Notifications[1].pos == 0) then
			local alpha = 1
			local drawColor = Color(SCHEMA:GetPBColor().r, SCHEMA:GetPBColor().g, SCHEMA:GetPBColor().b, 255)
			if (SCHEMA.Notifications[1].timer - CurTime()) <= 0.5 then
				alpha = (2 * (SCHEMA.Notifications[1].timer - CurTime()))
			elseif (SCHEMA.Notifications[1].timer - CurTime()) >= 3.5 then
				alpha = (2 * (4 - (SCHEMA.Notifications[1].timer - CurTime())))
			end
			drawColor.a = 255 * alpha
			
			surface.SetMaterial(divider_left)
			surface.SetDrawColor(drawColor)
			surface.DrawTexturedRect(16, 16, (512*1.25), (128*1.25))
		
			SCHEMA.DrawBlur(128, 38, SCHEMA.Notifications[1].message, TEXT_ALIGN_LEFT, false, drawColor, "FOFont_normal", "FOFont_normal_blur", 255 * alpha)
			SCHEMA.DrawBlur(128, 58, SCHEMA.Notifications[1].messagetwo, TEXT_ALIGN_LEFT, false, drawColor, "FOFont_normal", "FOFont_normal_blur", 255 * alpha)
			SCHEMA.DrawBlur(128, 78, SCHEMA.Notifications[1].messagethree, TEXT_ALIGN_LEFT, false, drawColor, "FOFont_normal", "FOFont_normal_blur", 255 * alpha)

			surface.SetMaterial(SCHEMA.NotificationMaterials[SCHEMA.Notifications[1].image])
			surface.SetDrawColor(drawColor)
			surface.DrawTexturedRect(16, 18, 128, 128)
		else
			local alpha = 1
			local drawColor = Color(SCHEMA:GetPBColor().r, SCHEMA:GetPBColor().g, SCHEMA:GetPBColor().b, 255)
			if (SCHEMA.Notifications[1].timer - CurTime()) <= 0.5 then
				alpha = (2 * (SCHEMA.Notifications[1].timer - CurTime()))
			elseif (SCHEMA.Notifications[1].timer - CurTime()) >= 3.5 then
				alpha = (2 * (4 - (SCHEMA.Notifications[1].timer - CurTime())))
			end
			drawColor.a = 255 * alpha
			
			SCHEMA.DrawBlur(ScrW() - 128, 38, SCHEMA.Notifications[1].message, TEXT_ALIGN_RIGHT, false, drawColor, "FOFont_normal", "FOFont_normal_blur", 255 * alpha)
			SCHEMA.DrawBlur(ScrW() - 128, 58, SCHEMA.Notifications[1].messagetwo, TEXT_ALIGN_RIGHT, false, drawColor, "FOFont_normal", "FOFont_normal_blur", 255 * alpha)
			SCHEMA.DrawBlur(ScrW() - 128, 78, SCHEMA.Notifications[1].messagethree,  TEXT_ALIGN_RIGHT, false, drawColor, "FOFont_normal", "FOFont_normal_blur", 255 * alpha)
		
			surface.SetMaterial(divider_right)
			surface.SetDrawColor(drawColor)
			surface.DrawTexturedRect((ScrW() - ((512*1.25) + 16)), 16, (512*1.25), (128*1.25))
		
			surface.SetMaterial(SCHEMA.NotificationMaterials[SCHEMA.Notifications[1].image])
			surface.SetDrawColor(drawColor)
			surface.DrawTexturedRect((ScrW() - 150), 18, 128, 128)
		end
	end
end
hook.Add("HUDPaint", "PaintNotification", PaintNotification)

netstream.Hook("nut_fnotify", function(data)
	data.message = data.message or ""
	data.messagetwo = data.messagetwo or ""
	data.messagethree = data.messagethree or ""
	SCHEMA.Notifications[#SCHEMA.Notifications+1] = data
end)

netstream.Hook("nut_Teleporting", function(teleport)
	nut.config.drawHUD = teleport
end)