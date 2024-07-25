local PANEL = {}
local gradient = surface.GetTextureID("gui/gradient_up")
local gradient2 = surface.GetTextureID("gui/gradient_down")
local gradient3 = surface.GetTextureID("gui/center_gradient")

local mapbackground = Material("thor/worldmap/background.png", "noclamp smooth")
local icons = {
	cave = Material("thor/worldmap/icon/icon_cave.png", "noclamp smooth"),
	city = Material("thor/worldmap/icon/icon_city.png", "noclamp smooth"),
	encampment = Material("thor/worldmap/icon/icon_encampment.png", "noclamp smooth"),
	factory = Material("thor/worldmap/icon/icon_factory.png", "noclamp smooth"),
	metro = Material("thor/worldmap/icon/icon_metro.png", "noclamp smooth"),
	military = Material("thor/worldmap/icon/icon_military.png", "noclamp smooth"),
	monument = Material("thor/worldmap/icon/icon_monument.png", "noclamp smooth"),
	nautral = Material("thor/worldmap/icon/icon_natural.png", "noclamp smooth"),
	office = Material("thor/worldmap/icon/icon_office.png", "noclamp smooth"),
	settlement = Material("thor/worldmap/icon/icon_settlement.png", "noclamp smooth"),
	vault = Material("thor/worldmap/icon/icon_vault.png", "noclamp smooth"),
	undiscovered = Material("thor/worldmap/icon/icon_undiscovered.png", "noclamp smooth"),
}

surface.CreateFont("worldmap_far", {
	font = "Monofonto",
	size = 24,
	weight = 500
})

surface.CreateFont("worldmap_med", {
	font = "Monofonto",
	size = 30,
	weight = 500
})

surface.CreateFont("worldmap_near", {
	font = "Monofonto",
	size = 36,
	weight = 500
})

local function locHL(self, x, y, iconSize)
	local mx, my = gui.MousePos()
	if (mx < x) or (mx > x + iconSize) then
		return false
	elseif (my < y) or (my > y + iconSize) then
		return false
	end
	return true
end

-- make sure the indexes match up with the serverside spawns!!
local locationList = {
	[1] = {x = 564, y = 528, icon = "encampment", name = "HELIOS One", namepos = 1, index = 10, shouldHighlight = locHL},
	[2] = {x = 455, y = 530, icon = "military", name = "Hidden Valley", namepos = 2, index = 2, shouldHighlight = locHL},
	[3] = {x = 264, y = 808, icon = "military", name = "Mojave Outpost", namepos = 1, index = 4, shouldHighlight = locHL},
	[4] = {x = 715, y = 442, icon = "monument", name = "Hoover Dam", namepos = 1, index = 8, shouldHighlight = locHL},
	[5] = {x = 681, y = 784, icon = "encampment", name = "Cottonwood Cove", namepos = 1, index = 1, shouldHighlight = locHL},
	[6] = {x = 765, y = 382, icon = "military", name = "Fortification Hill", namepos = 2, index = 9, shouldHighlight = locHL},
	[7] = {x = 409, y = 782, icon = "city", name = "Nipton", namepos = 1, index = 0, shouldHighlight = locHL},
	[8] = {x = 342, y = 667, icon = "city", name = "Primm", namepos = 1, index = 3, shouldHighlight = locHL},
	[9] = {x = 479, y = 189, icon = "city", name = "Freeside North Gate", namepos = 1, index = 5, shouldHighlight = locHL},
	[10] = {x = 474, y = 220, icon = "city", name = "Freeside East Gate", namepos = 1, index = 6, shouldHighlight = locHL},
	[11] = {x = 443, y = 254, icon = "city", name = "The Strip", namepos = 2, index = 7, shouldHighlight = locHL},
	[12] = {x = 280, y = 320, icon = "encampment", name = "Red Rock Canyon", namepos = 1, index = 11, shouldHighlight = locHL},
}
function PANEL:Init()

	self:SetSize(ScrW(), ScrH())
	self:SetDrawBackground(false)
	self:MakePopup()
	
	self.IsDragging = false
	
	self.iconSize = 32
	
	self.maxUVSize = 1
	self.curUVSize = 1
	self.minUVSize = 0.25
	self.uvStepSize = 0.05
	
	self.uPos = 0
	self.vPos = 0
	
	self.testDrawX = ScrW()
	self.testDrawY = ScrH()
	
end

function PANEL:OnRemove()
	if self.popup then
		if IsValid(self.popup) then
			self.popup:Remove()
		end
		self.popup = nil
	end
end

function PANEL:FadeOutMusic()
	if (!nut.menuMusic) then
		return
	end

	nut.menuMusic:FadeOut(3)
	timer.Simple(3, function()
		nut.menuMusic = nil
	end)
end

function PANEL:OnMousePressed(code)
	local selected = false
	for k,v in pairs(locationList) do
		local discoveredLocations = LocalPlayer().character:GetData("locations")
		local w, h = self:GetSize()
		local drawX = (v.x * (ScrH()/900) - (self.uPos * ScrH())) / self.curUVSize
		local drawY = (v.y * (ScrH()/900) - (self.vPos * ScrH())) / self.curUVSize
		drawX = drawX + (w/2 - h/2) - self.iconSize / (2*self.curUVSize)
		drawY = drawY - self.iconSize / (2*self.curUVSize)
		if v:shouldHighlight(drawX, drawY, self.iconSize / self.curUVSize) and table.HasValue(discoveredLocations, v.index) then
			local popup = vgui.Create("nut_PopupMessage")
			popup:SetText("Spawn at " .. v.name.."?")
			popup:SetButtonText("Yes")
			local b2 = popup:EnableButton2("No")
			b2:Setup(100, 50, 240, 80, "Monofonto24", "No", 0.1, 5)
			b2:SetContentAlignment(5)

			popup:SetButtonOneCallback(function()
				netstream.Start("nut_SelectSpawn", v.index)
				popup:Remove()
			end)
			popup:SetButtonTwoCallback(function()
				popup:Remove()
			end)
			self.popup = popup
			return
		end
	end
	
	self.IsDragging = true
	self.lastMouseX, self.lastMouseY = gui.MousePos()
	
	local testX = (self.lastMouseX - (ScrW()/2 - ScrH()/2)) * self.curUVSize
	local testY = self.lastMouseY * self.curUVSize
	local testXOffset = self.uPos * ScrH()
	local testYOffset = self.vPos * ScrH()
	
	--print(testX + testXOffset)
	--print(testY + testYOffset)
	self.testDrawX = testX + testXOffset
	self.testDrawY = testY + testYOffset
end

function PANEL:OnMouseReleased(code)
	self.IsDragging = false
end

function PANEL:OnMouseWheeled(delta)
	local x, y = gui.MousePos()
	local mapX = ScrW()/2 - ScrH()/2
	local mapY = 0
	
	if x >= mapX and x <= (mapX + ScrH()) then
		local prevSize = self.curUVSize
		self.curUVSize = self.curUVSize - self.uvStepSize * delta
		self.curUVSize = math.Clamp(self.curUVSize, self.minUVSize, self.maxUVSize)
		self.uPos = self.uPos + prevSize/2 - self.curUVSize/2
		self.vPos = self.vPos + prevSize/2 - self.curUVSize/2
		if self.uPos + self.curUVSize > 1 then
			self.uPos = 1 - self.curUVSize
		elseif self.uPos < 0 then
			self.uPos = 0
		end
		if (self.vPos + self.curUVSize) > 1 then
			self.vPos = 1 - self.curUVSize
		elseif self.vPos < 0 then
			self.vPos = 0
		end
	end
end

function PANEL:Think()
	if self.IsDragging then
		local w, h = self:GetSize()
		local mx, my = gui.MousePos()
		local deltaX = self.lastMouseX - mx
		local deltaY = self.lastMouseY - my
		
		local deltaU = deltaX / ScrH()
		local deltaV = deltaY / ScrH()
		
		self.uPos = self.uPos + deltaU
		self.vPos = self.vPos + deltaV
		self.uPos = math.Clamp(self.uPos, 0, 1 - self.curUVSize)
		self.vPos = math.Clamp(self.vPos, 0, 1 - self.curUVSize)
		
		self.lastMouseX = mx
		self.lastMouseY = my
	end
end

function PANEL:Paint(w, h)
	surface.SetDrawColor(SCHEMA:GetPBColor())
	surface.SetMaterial(mapbackground)
	surface.DrawTexturedRectUV(w/2 - h/2, 0, h, h, self.uPos, self.vPos, self.uPos + self.curUVSize, self.vPos + self.curUVSize)
	
	for k,v in pairs(locationList) do
		local drawX = (v.x * (ScrH()/900) - (self.uPos * ScrH())) / self.curUVSize
		local drawY = (v.y * (ScrH()/900) - (self.vPos * ScrH())) / self.curUVSize
		drawX = drawX + (w/2 - h/2) - self.iconSize / (2*self.curUVSize)
		drawY = drawY - self.iconSize / (2*self.curUVSize)
		
		local discoveredLocations = LocalPlayer().character:GetData("locations") or {}
		if table.HasValue(discoveredLocations, v.index) then
			surface.SetDrawColor(SCHEMA:GetPBColor())
			surface.SetMaterial(icons[v.icon])
			surface.DrawTexturedRect(drawX, drawY, self.iconSize / self.curUVSize, self.iconSize / self.curUVSize)
			
			surface.SetDrawColor(20, 20, 20, 200)
			if self.curUVSize >= self.maxUVSize * 0.75 then
				surface.SetFont("worldmap_far")
			elseif self.curUVSize >= self.maxUVSize * 0.5 then
				surface.SetFont("worldmap_med")
			else
				surface.SetFont("worldmap_near")
			end
			surface.SetTextColor(SCHEMA:GetPBColor())
			if v.namepos == 1 then
				local tW, tH = surface.GetTextSize(v.name)
				local pX, pY = drawX + self.iconSize / self.curUVSize, drawY
				surface.SetTextPos(pX, pY + (self.iconSize / (2*self.curUVSize)) - tH/2)
				surface.DrawRect(pX, pY + (self.iconSize / (2*self.curUVSize)) - tH/2, tW, tH)
			elseif v.namepos == 2 then
				local tW, tH = surface.GetTextSize(v.name)
				local pX, pY = drawX + self.iconSize / (2*self.curUVSize) - tW/2, drawY + self.iconSize / self.curUVSize
				surface.DrawRect(pX, pY, tW, tH)
				surface.SetTextPos(pX, pY)
			end
			surface.DrawText(v.name)
		else
			surface.SetDrawColor(SCHEMA:GetPBColor())
			surface.SetMaterial(icons["undiscovered"])
			surface.DrawTexturedRect(drawX, drawY, self.iconSize / self.curUVSize, self.iconSize / self.curUVSize)
		end
		
		if self:HasFocus() then
			if v:shouldHighlight(drawX, drawY, self.iconSize / self.curUVSize) then
				surface.SetDrawColor(SCHEMA:GetPBColor())
				surface.DrawOutlinedRect(drawX, drawY, self.iconSize / self.curUVSize, self.iconSize / self.curUVSize)
			end
		end
	end
	
	surface.SetDrawColor(0, 0, 0, 255)
	surface.DrawRect(0, 0, w/2 - h/2, h)
	surface.DrawRect(w/2 + h/2, 0, w/2 - h/2, h)
	
	--[[local count = 0
	for k,v in pairs(icons) do
		surface.SetDrawColor(253, 186, 105, 255)
		surface.SetMaterial(v)
		surface.DrawTexturedRect(0, 64 * count, 64, 64)
		
		surface.SetFont("worldmap_far")
		surface.SetTextColor(253, 186, 105, 255)
		local tW, tH = surface.GetTextSize(k)
		surface.SetTextPos(64, 64 * count + tH/2)
		surface.DrawText(k)
		
		count = count + 1
	end]]--
end
vgui.Register("nut_WorldMap", PANEL, "DPanel")

netstream.Hook("nut_WorldMap", function()
	if (IsValid(nut.gui.worldMap)) then
		nut.gui.worldMap:Remove()

		return
	end

	nut.gui.worldMap = vgui.Create("nut_WorldMap")
end)