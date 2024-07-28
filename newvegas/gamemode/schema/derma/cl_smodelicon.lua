local PANEL = {}

function PANEL:Init()
	self.ModelPanel = vgui.Create("DModelPanel", self)
	self.ModelPanel:SetLookAt(Vector(0,0,0))
	self.ModelPanel:SetFOV(25)
	self.ModelPanel.LayoutEntity = function(Entity) 
		self.ModelPanel:RunAnimation() 
	end

	self.ModelButton = vgui.Create("DButton", self)
	self.ModelButton.Paint = function(w, h)
	end

	self.ModelButton.OnHover = function()
		surface.PlaySound("forp/ui_menu_focus.wav")
	end

	self.ModelButton:SetText("")

	self.ModelButton.OnMouseReleased = function(key)
		self.ModelButton:MouseCapture(false)
		
		if !self.ModelButton.Hovered then
			surface.PlaySound("forp/ui_menu_cancel.wav")
		end

		if (self.DoClick and self.ModelButton.Hovered) then
			surface.PlaySound("forp/ui_menu_ok.wav")
			self.DoClick(self)
		end
	end


	timer.Simple(0.001, function()
		self.ModelPanel:SetSize(self:GetWide(), self:GetTall())
		self.ModelButton:SetSize(self:GetWide(), self:GetTall())
	end)
end

function PANEL:Think()
	if self.ModelButton.Hovered and !self.ModelButton.CallHover then
		self.ModelButton.CallHover = true
		self.ModelButton:OnHover()
	elseif !self.ModelButton.Hovered and self.ModelButton.CallHover then
		self.ModelButton.CallHover = false
	end
end

function PANEL:Paint(w, h)
	if !self.ModelButton.Hovered then
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

vgui.Register("SModelIcon", PANEL, "DPanel")