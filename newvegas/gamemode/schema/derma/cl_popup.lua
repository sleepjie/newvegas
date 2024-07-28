local PANEL = {}
local background = Material("thor/worldmap/fuzzy.png", "noclamp smooth")
local seperator = Material("falloutrp/interface/messages/glow_messages_seperator.png", "noclamp smooth")
local fadeToLeft = Material("forp/uistuff/fade_to_left.png", "noclamp smooth")
local fadeToRight = Material("forp/uistuff/fade_to_right.png", "noclamp smooth")
local fadeToTop = Material("forp/uistuff/fade_to_top.png", "noclamp smooth")
local fadeToBottom = Material("forp/uistuff/fade_to_bottom.png", "noclamp smooth")

function PANEL:Init()
	self:SetSize(450, 150)
	self:Center()
	self:MakePopup()
		
	self.buttonOne = vgui.Create("SButton", self)
	self.buttonOne:SetSize(100, 50)
	self.buttonOne:SetPos(185, 80)
	self.buttonOne:SetColor(SCHEMA:GetPBColor())
	self.buttonOne:SetFont("Monofonto24")
	self.buttonOne:SetText("OK")
	self.buttonOne:SetContentAlignment(5)

	self:SetButtonOneCallback(function()
		self:Remove()
	end)
end

function PANEL:EnableButton2(text)
	self.buttonOne:SetPos(130, 80)
	
	self.buttonTwo = vgui.Create("SButton", self)
	return self.buttonTwo
end

function PANEL:SetText(str)
	self.sText = str
end

function PANEL:SetButtonText(str)
	self.buttonOne:SetText(str)
end

function PANEL:SetButton2Text(str)
	self.buttonTwo:SetText(str)
end

function PANEL:SetButtonOneCallback(func)
	self.buttonOne.DoClick = func
end

function PANEL:SetButtonTwoCallback(func)
	self.buttonTwo.DoClick = func
end

function PANEL:GetText()
	return self.sText
end

function PANEL:Think()
	self:MakePopup()
end

function PANEL:Paint(w, h)
	surface.SetDrawColor(0, 0, 0, 200)
	surface.DrawRect(0, 0, w, h)

	nut.util.drawBlur(self, 5)

	surface.SetDrawColor(SCHEMA:GetPBColor())
	surface.SetMaterial(fadeToBottom)
	surface.DrawTexturedRect(0, 0, 2, h * 0.2)
	surface.SetMaterial(fadeToBottom)
	surface.DrawTexturedRect(w - 2, 0, 2, h * 0.2)
	
	surface.SetMaterial(fadeToTop)
	surface.DrawRect(0, h-2, w, 2)
	surface.DrawRect(0, 0, w, 2)
	surface.DrawTexturedRect(w - 2, h, 2, h * 0.2)

	surface.DrawTexturedRect(0, h * 0.8, 2, h * 0.2)
	surface.DrawTexturedRect(w-2, h * 0.8, 2, h * 0.2)


	SCHEMA.DrawBlur(w/2, h/6, self:GetText(), TEXT_ALIGN_CENTER, nil, SCHEMA:GetPBColor(), "Monofonto24", "Monofonto24_blur")
end
vgui.Register("nut_PopupMessage", PANEL, "DPanel")

netstream.Hook("nut_PopupMessage", function(data)
	if (IsValid(nut.gui.popupMessage)) then
		nut.gui.popupMessage:Remove()

		return
	end
	
	nut.gui.popupMessage = vgui.Create("nut_PopupMessage")
	nut.gui.popupMessage:SetText(data[1])
	nut.gui.popupMessage:SetButtonText(data[2])
end)