local PANEL = {}

function PANEL:Init()
	self.alpha = 255
	self:SetSize(ScrW(), ScrH())

	self.gradient = surface.GetTextureID("gui/gradient")

	self.delay = CurTime() + 5
	self.xOffset = 650
	self.labelAlpha = 255
	self.coverAlpha = 255
	self.fnvalpha = 255
end

function PANEL:Think()
	if (self.delay + 15) < CurTime() then
		self:Remove()
	end
end

function PANEL:Paint(w, h)

	surface.SetDrawColor(Color(0,0,0,self.alpha))
	surface.DrawRect(0,0,w,h)

	if self.delay < (CurTime()) then

		if self.coverAlpha == 0 and !self.once then
			self.once = true
			self.coverAlpha = 255
		end

		surface.SetTextColor(255,255,255,self.fnvalpha)
		surface.SetFont("LargeText54")
		surface.SetTextPos(100, ScrH() - 250)
		surface.DrawText("FALLOUT: NEW VEGAS")

		self.xOffset = self.xOffset - 1.5
		self.labelAlpha = 255

		self.coverAlpha = math.Clamp(self.coverAlpha - 2.5, 0, 255)

		surface.SetDrawColor(Color(0,0,0,self.coverAlpha))
		surface.DrawRect(0,ScrH() - 250,1000,200)

	else

		surface.SetTextColor(255,255,255,self.alpha)
		surface.SetFont("LargeText54")
		surface.SetTextPos(100, ScrH() - 250)
		surface.DrawText("THE SPIRE ROLEPLAY")
	
		surface.SetTextPos(100, ScrH() - 200)
		surface.DrawText("PRESENTS")
		self.labelAlpha = 0

		self.coverAlpha = math.Clamp(self.coverAlpha - 2.5, 0, 255)

		surface.SetDrawColor(Color(0,0,0,self.coverAlpha))
		surface.DrawRect(0,ScrH() - 250,1000,200)
	end

	if self.delay < CurTime() - 8 then
		self.alpha = math.Clamp(self.alpha - 0.20, 0, 255)
		self.labelAlpha = 0
		self.fnvalpha = 0
	end

	surface.SetDrawColor(Color(0,0,0,self.labelAlpha))
	surface.DrawRect(200+self.xOffset,ScrH() - 250,10000,54)

	surface.SetTexture(self.gradient)
   	surface.SetDrawColor(0,0,0,self.labelAlpha)
   	surface.DrawTexturedRectRotated(150+self.xOffset,ScrH() - 223,100,54,180)
end

vgui.Register("SIntroCinematic", PANEL, "DPanel")