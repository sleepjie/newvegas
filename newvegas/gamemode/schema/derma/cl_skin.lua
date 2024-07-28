local SKIN = {}
	SKIN.fontFrame = "BudgetLabel"
	SKIN.fontTab = "nutSmallFont"
	SKIN.fontButton = "nutSmallFont"
	SKIN.Colours = table.Copy(derma.SkinList.Default.Colours)
	SKIN.Colours.Window.TitleActive = Color(0, 0, 0)
	SKIN.Colours.Window.TitleInactive = Color(255, 255, 255)

	SKIN.Colours.Button.Normal = Color(230, 230, 230)
	SKIN.Colours.Button.Hover = Color(255, 255, 255)
	SKIN.Colours.Button.Down = Color(180, 180, 180)
	SKIN.Colours.Button.Disabled = Color(0, 0, 0, 100)

	--SKIN.colTextEntryBG				= Color( 20, 20, 20, 255 )
	--SKIN.colTextEntryBorder			= Color( 20, 20, 20, 255 )
	--SKIN.colTextEntryText			= Color( 220, 220, 220, 255 )
	--SKIN.colTextEntryTextHighlight	= Color( 20, 200, 250, 255 )
	--SKIN.colTextEntryTextCursor		= Color( 220, 220, 220, 255 )

	local fade_to_top = fade_to_top or Material("materials/forp/uistuff/fade_to_top.png")
	local fade_to_left = fade_to_left or Material("materials/forp/uistuff/fade_to_left.png")
	local fade_to_right = fade_to_right or Material("materials/forp/uistuff/fade_to_right.png")
	local fade_to_bottom = fade_to_bottom or Material("materials/forp/uistuff/fade_to_bottom.png")

	function SKIN:PaintFrame(panel)
		local col = SCHEMA:GetPBColor()
		local name = panel.lblTitle:GetText()
		panel.lblTitle:SetTextColor(Color(0,0,0,0))
		nut.util.drawBlur(panel, 10)
		surface.SetDrawColor(45, 45, 45, 200)
		surface.DrawRect(0, 0, panel:GetWide(), panel:GetTall())

		surface.SetDrawColor(col)
		surface.DrawRect(0, 0, panel:GetWide(), 24)

		surface.SetDrawColor(col)
		surface.DrawRect(0,0,panel:GetWide(), 2)
		surface.DrawRect(0,panel:GetTall() - 2,panel:GetWide(), 2)

		surface.SetMaterial(fade_to_bottom)
		surface.DrawRect(0, 2, 2, 62)
		surface.DrawRect(panel:GetWide() - 2, 2, 2, 62)
		surface.DrawTexturedRect(0,64,2,62)
		surface.DrawTexturedRect(panel:GetWide() - 2, 64, 2, 62)

		surface.SetMaterial(fade_to_top)
		surface.DrawTexturedRect(0,panel:GetTall() - 120,2,62)
		surface.DrawTexturedRect(panel:GetWide() - 2,panel:GetTall() - 120,2,62)
		surface.DrawRect(0,panel:GetTall() - 64,2,62)
		surface.DrawRect(panel:GetWide() - 2,panel:GetTall() - 64,2,62)

		surface.SetTextColor(Color(255,255,255,255))
		surface.SetFont("Monofonto18")
		local w, h =surface.GetTextSize(name) 
		surface.SetTextPos((panel:GetWide()/2) - (w/2), (10 - (h/2)))
		surface.DrawText(name)
	end

	SKIN.colCollapsibleCategory	= Color(10,10,10,25)

	function SKIN:PaintCollapsibleCategory( panel, w, h )
		if ( !panel:GetExpanded() && h < 40 ) then
			surface.SetDrawColor(Color(0,0,0,120))
			surface.DrawRect(0,0,w,h)
	
			surface.SetDrawColor(SCHEMA:GetPBColor(25))
			surface.DrawOutlinedRect(0, 0, w, h)
		end

		surface.SetDrawColor(Color(0,0,0,120))
		surface.DrawRect(0,0,w,20)

		surface.SetDrawColor(SCHEMA:GetPBColor(25))
		surface.DrawOutlinedRect(0, 0, w, h)
	end

	function SKIN:DrawGenericBackground(x, y, w, h)
		surface.SetDrawColor(45, 45, 45, 240)
		surface.DrawRect(x, y, w, h)

		surface.SetDrawColor(SCHEMA:GetPBColor(180))
		surface.DrawOutlinedRect(x, y, w, h)

		surface.SetDrawColor(SCHEMA:GetPBColor(25))
		surface.DrawOutlinedRect(x + 1, y + 1, w - 2, h - 2)
	end

	function SKIN:PaintPanel(panel)
		if (panel.GetPaintBackground and panel:GetPaintBackground()) then
			local w, h = panel:GetWide(), panel:GetTall()

			surface.SetDrawColor(0, 0, 0, 100)
			surface.DrawRect(0, 0, w, h)
			surface.SetDrawColor(SCHEMA:GetPBColor(100))
			surface.DrawOutlinedRect(0, 0, w, h)
		end
	end

	function SKIN:PaintButton(panel)
		if (panel.GetPaintBackground and panel:GetPaintBackground()) then
			local w, h = panel:GetWide(), panel:GetTall()
			local alpha = 50

			if (panel:GetDisabled()) then
				alpha = 10
			elseif (panel.Depressed) then
				alpha = 180
			elseif (panel.Hovered) then
				alpha = 75
			end

			surface.SetDrawColor(30, 30, 30, alpha)
			surface.DrawRect(0, 0, w, h)

			surface.SetDrawColor(SCHEMA:GetPBColor(180))
			surface.DrawOutlinedRect(0, 0, w, h)

			surface.SetDrawColor(SCHEMA:GetPBColor(25))
			surface.DrawOutlinedRect(1, 1, w - 2, h - 2)
		end
	end


	local function PaintNotches( x, y, w, h, num )
		if ( !num ) then 
			return 
		end
		local space = w / num

		for i=0, num do
			surface.DrawRect( x + i * space, y + 4, 1,  5 )
		end
	end

	function SKIN:PaintNumSlider( panel, w, h )
		surface.SetDrawColor( Color( 255, 255, 255, 100 ) )
		surface.DrawRect( 8, h / 2 - 1, w - 15, 1 )
		
		PaintNotches( 8, h / 2 - 1, w - 16, 1, panel.m_iNotches )
	end

	-- I don't think we gonna need minimize button and maximize button.
	function SKIN:PaintWindowMinimizeButton( panel, w, h )
	end

	function SKIN:PaintWindowMaximizeButton( panel, w, h )
	end

derma.DefineSkin("nutscript", "The base skin for the NutScript framework.", SKIN)
derma.RefreshSkins()