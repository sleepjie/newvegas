local PANEL = {}

function PANEL:Init()
	self:SetText("")
	self.value = false
end

function PANEL:SetValue(bool)
	self.value = bool
end

function PANEL:GetValue()
	return self.value
end

function PANEL:Paint(w, h)
	local add = math.sin(RealTime() * 3)*35 + 50

	if self.Hovered then
		surface.SetDrawColor(Color(155 + add,155 + add,155 + add,255))
		surface.DrawRect(0,0,w,h)

		surface.SetDrawColor(20, 20, 20, 235)
		surface.DrawRect(2,2,w-4,h-4)
	else
		self:SetTextColor(Color(100,100,100,255))

		surface.SetDrawColor(Color(55,55,55,255))
		surface.DrawRect(0,0,w,h)

		surface.SetDrawColor(20, 20, 20, 235)
		surface.DrawRect(2,2,w-4,h-4)
	end

	if self.value then
		surface.SetDrawColor(Color(165,165,165,255))
		surface.DrawRect(0,0,w,h)

		surface.SetDrawColor(20, 20, 20, 235)
		surface.DrawRect(2,2,w-4,h-4)

		surface.SetDrawColor(Color(165,165,165,255))
		surface.DrawRect(4,4,w - 8,h - 8)
	end	

	if self.value and self.Hovered then
		surface.SetDrawColor(Color(155 + add,155 + add,155 + add,255))
		surface.DrawRect(0,0,w,h)

		surface.SetDrawColor(20, 20, 20, 235)
		surface.DrawRect(2,2,w-4,h-4)

		surface.SetDrawColor(Color(155 + add,155 + add,155 + add,255))
		surface.DrawRect(4,4,w - 8,h - 8)
	end


end

function PANEL:Think()
	if self.Hovered and !self.CallHover then
		self.CallHover = true
		self:OnHover()
	elseif !self.Hovered and self.CallHover then
		self.CallHover = false
	end
end

function PANEL:OnHover()
	surface.PlaySound("forp/ui_menu_focus.wav")
end

function PANEL:OnMouseReleased(key)
	self:MouseCapture(false)
	
	if !self.Hovered then
		surface.PlaySound("forp/ui_menu_cancel.wav")
	end

	if (key == MOUSE_LEFT and self.DoClick and self.Hovered) then
		surface.PlaySound("forp/ui_menu_ok.wav")
		self.value = !self.value
	end
end

vgui.Register("SCheckBox", PANEL, "DButton")