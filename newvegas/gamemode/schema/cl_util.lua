
-- Returns a single cached copy of a material or creates it if it doesn't exist.
function nut.util.getMaterial(materialPath)
	-- Cache the material.
	nut.util.cachedMaterials = nut.util.cachedMaterials or {}

	if (!nut.util.cachedMaterials[materialPath]) then
		surface.SetMaterial(Material(materialPath))
	end

	nut.util.cachedMaterials[materialPath] = nut.util.cachedMaterials[materialPath] or Material(materialPath)

	return nut.util.cachedMaterials[materialPath]
end


NUT_CVAR_CHEAP = CreateClientConVar("nut_cheapblur", 0, true)

local useCheapBlur = NUT_CVAR_CHEAP:GetBool()
local blur = nut.util.getMaterial("pp/blurscreen")

cvars.AddChangeCallback("nut_cheapblur", function(name, old, new)
	useCheapBlur = (tonumber(new) or 0) > 0
end)

-- Draws a blurred material over the screen, to blur things.
function nut.util.drawBlur(panel, amount, passes)
	-- Intensity of the blur.
	amount = amount or 5
	
	if (useCheapBlur) then
		surface.SetDrawColor(50, 50, 50, amount * 20)
		surface.DrawRect(0, 0, panel:GetWide(), panel:GetTall())
	else
		surface.SetMaterial(blur)
		surface.SetDrawColor(255, 255, 255)

		local x, y = panel:LocalToScreen(0, 0)
		
		for i = -(passes or 0.2), 1, 0.2 do
			-- Do things to the blur material to make it blurry.
			blur:SetFloat("$blur", i * amount)
			blur:Recompute()

			-- Draw the blur material over the screen.
			render.UpdateScreenEffectTexture()
			surface.DrawTexturedRect(x * -1, y * -1, ScrW(), ScrH())
		end
	end
end

function nut.util.drawBlurAt(x, y, w, h, amount, passes)
	-- Intensity of the blur.
	amount = amount or 5

	if (useCheapBlur) then
		surface.SetDrawColor(30, 30, 30, amount * 20)
		surface.DrawRect(x, y, w, h)
	else
		surface.SetMaterial(blur)
		surface.SetDrawColor(255, 255, 255)

		local scrW, scrH = ScrW(), ScrH()
		local x2, y2 = x / scrW, y / scrH
		local w2, h2 = (x + w) / scrW, (y + h) / scrH

		for i = -(passes or 0.2), 1, 0.2 do
			blur:SetFloat("$blur", i * amount)
			blur:Recompute()

			render.UpdateScreenEffectTexture()
			surface.DrawTexturedRectUV(x, y, w, h, x2, y2, w2, h2)
		end
	end
end

-- Draw a text with a shadow.
function nut.util.drawText(text, x, y, color, alignX, alignY, font, alpha)
	color = color or color_white

	return draw.TextShadow({
		text = text,
		font = font or "nutGenericFont",
		pos = {x, y},
		color = color,
		xalign = alignX or 0,
		yalign = alignY or 0
	}, 1, alpha or (color.a * 0.575))
end

-- Wraps text so it does not pass a certain width.
function nut.util.wrapText(text, width, font)
	font = font or "nutChatFont"
	surface.SetFont(font)

	local exploded = string.Explode("%s", text, true)
	local line = ""
	local lines = {}
	local w = surface.GetTextSize(text)
	local maxW = 0
	
	if (w <= width) then
		return {(text:gsub("%s", " "))}, w
	end
	
	for i = 1, #exploded do
		local word = exploded[i]
		line = line.." "..word
		w = surface.GetTextSize(line)
		
		if (w > width) then
			lines[#lines + 1] = line
			line = ""
			
			if (w > maxW) then
				maxW = w
			end
		end
	end

	if (line != "") then
		lines[#lines + 1] = line
	end
	
	return lines, maxW
end