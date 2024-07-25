local PANEL = {}

function PANEL:Init()
	self:SetText("x")
	self:SetSize(20,20)
end

function PANEL:Think()
	if self.Hovered and !self.CallHover then
		self.CallHover = true
		self:OnHover()
	elseif !self.Hovered and self.CallHover then
		self.CallHover = false
	end
end

function PANEL:OnMouseReleased(key)
	self:MouseCapture(false)
	
	if !self.Hovered then
		surface.PlaySound("forp/ui_menu_cancel.wav")
	end

	if (key == MOUSE_LEFT and self.DoClick and self.Hovered) then
		surface.PlaySound("forp/ui_menu_ok.wav")
		if self.DoClick then
			self.DoClick(self)
		end
		if self.CloseOnClick or self.CloseOnClick == nil then
			self.Close(self)
		end
	end
end

function PANEL:Paint(w, h)
	surface.SetDrawColor(20, 20, 20, 235)
	surface.DrawRect(0,0,w,h)

	if self.Hovered then
		local add = math.sin(RealTime() * 3)*25 + 50
		self:SetTextColor(Color(155 + add,155 + add,155 + add,255))
	else
		self:SetTextColor(Color(100,100,100,255))
	end
end

function PANEL:OnHover()
	surface.PlaySound("forp/ui_menu_focus.wav")
end

function PANEL:Close()
	self:GetParent():Remove()
end

vgui.Register("SCloseButton", PANEL, "DButton")