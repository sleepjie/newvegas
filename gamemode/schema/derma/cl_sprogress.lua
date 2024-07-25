local PANEL = {}

function PANEL:Init()
	self.min = 0
	self.max = 10
end

function PANEL:Paint(w, h)
	local startPos, endPos = 0, w
	local difference = w
	local progress = ((self.current/self.max) * difference)

	surface.SetDrawColor(150, 150, 150, 25 + 60)
	surface.DrawRect(startPos, 0, difference, h)

	surface.SetDrawColor(195, 195, 195, 35 + 60)
	surface.DrawRect(startPos, 0, progress, h)
end

function PANEL:SetMin(value)
	self.min = value
end

function PANEL:SetMax(value)
	self.max = value
end

function PANEL:SetValue(value)
	self.current = value
end

function PANEL:GetValue()
	return self.current
end

vgui.Register("SProgress", PANEL, "DPanel")