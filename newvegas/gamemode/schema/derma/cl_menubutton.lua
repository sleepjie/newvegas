local PANEL = {}
	local HOVER_ALPHA = 150

	function PANEL:Init()
		surface.SetFont("FranKleinBold")
		local _, height = surface.GetTextSize("W")

		self:SetTall(height + 16)
		self:DockMargin(0, 0, 0, 8)
		self:Dock(TOP)
		self:SetDrawBackground(false)
		self:SetFont("FranKleinBold")
		self:SetTextColor(Color(240, 240, 240))
		self:SetExpensiveShadow(1, color_black)
		self.alphaApproach = 15
		self.alpha = self.alphaApproach
	end

	function PANEL:OnCursorEntered()
		surface.PlaySound("fosounds/fix/ui_pipboy_mode.mp3")
		self.alpha = HOVER_ALPHA
	end

	function PANEL:OnCursorExited()
		self.alpha = 15
	end
	
	function PANEL:DoClick()
		if (self.OnClick) then
			local result = self:OnClick()

			if (result == false) then
				surface.PlaySound("fosounds/fix/ui_pipboy_select.mp3")
			else
				surface.PlaySound("fosounds/fix/ui_pipboy_select.mp3")
				self.alphaApproach = HOVER_ALPHA + 150
			end
		end
	end

	local sin = math.sin

	function PANEL:Paint(w, h)
		self.alphaApproach = math.Approach(self.alphaApproach, self.alpha, FrameTime() * 240)
	
		local blink = 0
	
		if (self.alphaApproach == HOVER_ALPHA) then
			blink = sin(RealTime() * 5) * 20
		end
	
		local color = Color(0,0,0,255)
	
		surface.SetDrawColor(SCHEMA:GetPBColor(self.alphaApproach + blink))
		surface.DrawRect(0, 0, w, h)

		surface.SetDrawColor(SCHEMA:GetPBColor(225))
		surface.DrawLine(0, 0, w, 0)
		surface.DrawLine(0, h-1, w, h-1)
	end
vgui.Register("nut_MenuButton", PANEL, "DButton")