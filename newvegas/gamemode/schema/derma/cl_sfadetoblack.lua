local PANEL = {}

function PANEL:Init()
	self.alpha = 255
	self:SetSize(ScrW(), ScrH())

	self.gradient = surface.GetTextureID("gui/gradient")

	self.delay = CurTime() + 5
	self.xOffset = -300
	self.labelAlpha = 255

	surface.PlaySound("forp/ui_popup_questnew.wav")
end

function PANEL:Think()
	if (self.delay + 15) < CurTime() then
		self:Remove()
	end
end

function PANEL:Paint(w, h)
	if self.delay < CurTime() then
		self.alpha = math.Clamp(self.alpha - 0.20, 0, 255)
		self.labelAlpha = 0
	end

	self.xOffset = self.xOffset + 1.25

	surface.SetDrawColor(Color(0,0,0,self.alpha))
	surface.DrawRect(0,0,w,h)

	surface.SetTextColor(255,255,255,self.alpha)
	surface.SetFont("LargeText54")
	surface.SetTextPos(100, ScrH() - 250)
	surface.DrawText("FALLOUT: NEW VEGAS")
	
	surface.SetDrawColor(Color(0,0,0,self.labelAlpha))
	surface.DrawRect(200+self.xOffset,ScrH() - 250,1000,54)

	surface.SetTexture(self.gradient)
   	surface.SetDrawColor(0,0,0,self.labelAlpha)
   	surface.DrawTexturedRectRotated(150+self.xOffset,ScrH() - 223,100,54,180)
end

vgui.Register("SFadeToBlack", PANEL, "DPanel")