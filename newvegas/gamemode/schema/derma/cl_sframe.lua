local PANEL = {}

function PANEL:Init()
	self.lblTitle:SetText("")
	self:ShowCloseButton(false)

	self.closeButton = vgui.Create("SCloseButton", self)

	-- hacky fix
	timer.Simple(0.001, function()
		self.closeButton:SetPos(self:GetWide() - 20,0)
		if self.noclose then
			self.closeButton:Remove()
		end

		if self.DoClose then
			self.closeButton.DoClick = self.DoClose
		end
	end)

	self.titleLabel = vgui.Create("DLabel", self)
	self.titleLabel:SetFont("ColaborateL12")
	self.titleLabel:SetPos(5,0)
end

function PANEL:Paint()
	surface.SetDrawColor(25, 25, 25, 235)
	surface.DrawRect(0,0,self:GetWide(),20)

	surface.SetDrawColor(35, 35, 35, 180)
	surface.DrawRect(0,20,self:GetWide(),self:GetTall()-20)

	surface.SetDrawColor(25, 25, 25, 225)
	surface.DrawOutlinedRect(0,20,self:GetWide(),self:GetTall()-20)

	surface.SetDrawColor(25, 25, 25, 225)
	surface.DrawOutlinedRect(0,20,self:GetWide(),self:GetTall()-20)
end

function PANEL:SetTitle(title)
	self.titleLabel:SetText(title)
	self.titleLabel:SizeToContentsX()
end

vgui.Register("SFrame", PANEL, "DFrame")