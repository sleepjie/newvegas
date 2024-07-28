local PANEL = {}

function PANEL:Init()
	self.ButtonL = vgui.Create("SCloseButton", self)
	self.ButtonR = vgui.Create("SCloseButton", self)
	self.ButtonL:SetPos(0,0)
	self.ButtonL:SetText("-")
	self.ButtonR:SetText("+")
	self.ButtonL.CloseOnClick = false
	self.ButtonR.CloseOnClick = false

	self.change = 100
	self.min = 0
	self.max = 10
	self.current = 0
	self.hoverTime = 0

	self.ButtonR.DoClick = function()
		self:SetValue(math.Clamp((self.current + 1), self.min, self.max))
		self.hoverTime = CurTime() + 1
		if self.OnValueChanged then
			self.OnValueChanged(self.current + 1)
		end
	end

	self.ButtonL.DoClick = function()
		self:SetValue(math.Clamp((self.current - 1), self.min, self.max))
		self.hoverTime = CurTime() + 1
		if self.OnValueChanged then
			self.OnValueChanged(self.current + 1)
		end
	end

	timer.Simple(0.001, function()
		self.ButtonL:SetSize(20,self:GetTall())
		self.ButtonR:SetSize(20,self:GetTall())
		self.ButtonR:SetPos(self:GetWide()-20,0)
	end)

end

function PANEL:Paint(w, h)
	local startPos, endPos = 20, (w - 20)
	local difference = w - 40
	local progress = ((self.current/self.max) * difference)

	surface.SetDrawColor(150, 150, 150, 25)
	surface.DrawRect(startPos, 0, difference, h)

		surface.SetDrawColor(195, 195, 195, 25)
		surface.DrawRect(startPos, 0, progress, h)

	if self.hoverTime > CurTime() then
		surface.SetDrawColor(195 + self.change, 195 + self.change, 195 + self.change, 25 + self.change)
		surface.DrawRect(startPos, 0, progress, h)
	end
end

function PANEL:SetMin(value)
	self.min = value - 1
end

function PANEL:SetMax(value)
	self.max = value - 1
end

function PANEL:SetValue(value)
	self.current = value
end

function PANEL:GetValue()
	return self.current
end

vgui.Register("SSelector", PANEL, "DPanel")