local PANEL = {}

function PANEL:Init()

	self.hoverTime = CurTime()

	self:Receiver("invitem", function(panel, table, dropped, x, y) 
		if !dropped then
			self.hoverTime = CurTime() + 0.025
		elseif dropped then
			self:ReceiveItem(panel, table, dropped, x, y)
		end
	end, {}) 

	self.gridx, self.gridy = 0,0
end

function PANEL:Think()
	if self.Hovered and !self.CallHover then
		self.CallHover = true
		self:OnHover()
	elseif !self.Hovered and self.CallHover then
		self.CallHover = false
	end

	if self.Hovered then
		self.hoverTime = CurTime() + 0.01
	end
end

function PANEL:ReceiveItem(panel, table, dropped, x, y)
	if !IsValid(table[1]) then
		return 
	end

	--if !checkPos(table[1].uniqueID, panel.gridx, panel.gridy) then
	--	return
	--end

	local posX, posY = self:GetPos()
	local offsetX, offsetY = self:GetParent():GetPos()

	table[1]:SetPos(posX, posY)
	surface.PlaySound("forp/ui_menu_cancel.wav")
end

function PANEL:OnHover()
	surface.PlaySound("forp/ui_menu_focus.wav")
end

function PANEL:GetCoords()
	return self.gridx, self.gridy
end

function PANEL:SetCoords(posx, posy)
	self.gridx = posx
	self.gridy = posy
end

function PANEL:Paint(w, h)
	if self.hoverTime < CurTime() then
		surface.SetDrawColor(Color(55,55,55,255))
		surface.DrawRect(0,0,w,h)
	
		surface.SetDrawColor(20, 20, 20, 235)
		surface.DrawRect(2,2,w-4,h-4)
	else
		local add = math.sin(RealTime() * 3)*25 + 50
		surface.SetDrawColor(Color(155 + add,155 + add,155 + add,255))
		surface.DrawRect(0,0,w,h)

		surface.SetDrawColor(20, 20, 20, 235)
		surface.DrawRect(2,2,w-4,h-4)
	end
end

function PANEL:SetModel(model)
	self.ModelPanel:SetModel(model)
end

function PANEL:SetDoClick(func)
	self.ModelButton.DoClick = func
end

vgui.Register("SInvSlot", PANEL, "DPanel")