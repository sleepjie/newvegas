local PANEL = {}
	function PANEL:Init()
		self:SetSize(ScrW() * 0.25, ScrH() * 0.500)
		self:SetTitle("Character Creation")
		self:MakePopup()
		self:Center()
		self:SetBackgroundBlur(true)
	end

	function PANEL:SetupFaction(index)
		if (!index) then
			return
		end

		local faction = nut.faction.GetByID(index)

		if (!faction) then
			return
		end

		self.scroll = self:Add("DScrollPanel")
		self.scroll:Dock(FILL)
		self.scroll:SetDrawBackground(false)
		
		self.label = vgui.Create("DLabel", self.scroll)
		self.label:Dock(TOP)
		self.label:SetText(nut.lang.Get("char_create_tip"))
		self.label:SetTextColor(Color(225,225,225,255))
		self.label:DockMargin(6,0,6,6)

		self.namelabel = vgui.Create("DLabel", self.scroll)
		self.namelabel:Dock(TOP)
		self.namelabel:SetText("Name:")
		self.namelabel:DockMargin(2,2,2,2)

		self.name = vgui.Create("DTextEntry", self.scroll)
		local randomName = ""..table.Random(MaleFirstNames).." "..table.Random(LastNames)..""
		self.name:SetText(randomName)
		self.name:Dock(TOP)

		if (faction.GetDefaultName) then
			local name, editable = faction:GetDefaultName(self.name)

			if (name) then
				self.name:SetEditable(editable or false)
				self.name:SetText(name)
			end
		end

		self.desclabel = vgui.Create("DLabel", self.scroll)
		self.desclabel:Dock(TOP)
		self.desclabel:SetText("Description:")
		self.desclabel:DockMargin(2,2,2,2)

		self.desc = vgui.Create("DTextEntry", self.scroll)
		self.desc:SetToolTip(nut.lang.Get("desc_char_req", nut.config.descMinChars))
		self.desc:Dock(TOP)

		self.genderlabel = vgui.Create("DLabel", self.scroll)
		self.genderlabel:Dock(TOP)
		self.genderlabel:SetText("Gender:")
		self.genderlabel:DockMargin(2,2,2,2)

		self.gender = vgui.Create("DComboBox", self.scroll)
		self.gender:Dock(TOP)
		self.gender.OnSelect = function(panel, index, value, data)
			if (string.lower(value)) == "female" then
			
				if (faction.GetDefaultName) then
				
				return
				
				end
				
				local randomName = ""..table.Random(FemaleFirstNames).." "..table.Random(LastNames)..""
				self.name:SetText(randomName)
				
			elseif (string.lower(value)) == "male" then
			
				if (faction.GetDefaultName) then
				
				return
				
				end
			
				local randomName = ""..table.Random(MaleFirstNames).." "..table.Random(LastNames)..""
				self.name:SetText(randomName)
			
			end
		end

		if (faction.maleModels and #faction.maleModels > 0) then
			self.gender:AddChoice("Male")
		end

		if (faction.femaleModels and #faction.femaleModels > 0) then
			self.gender:AddChoice("Female")
		end

		self.gender:ChooseOptionID(1)

		local points = nut.config.startingPoints
		local pointsLeft = points

		local pointsLabel = vgui.Create("DLabel", self.scroll)
		pointsLabel:SetText(nut.lang.Get("points_left", pointsLeft))
		pointsLabel:SetFont("DermaDefaultBold")
		pointsLabel:SetTextColor(Color(225,225,225,255))
		pointsLabel:SetContentAlignment(5)
		pointsLabel:Dock(TOP)
		pointsLabel:DockMargin(0,10,0,0)


		self.bars = {}

		for k, v in ipairs(nut.attribs.GetAll()) do
			local attribute = nut.attribs.Get(k)

			local bar = vgui.Create("nut_AttribBar", self.scroll)
			bar:Dock(TOP)
			bar:DockMargin(0,2,0,2)
			bar:SetMax(nut.config.startingPoints)
			bar:SetText(attribute.name)
			bar:SetToolTip(attribute.desc)
			bar.OnChanged = function(panel2, hindered)
				if (hindered) then
					pointsLeft = pointsLeft + 1
				else
					pointsLeft = pointsLeft - 1
				end

				pointsLabel:SetText(nut.lang.Get("points_left", pointsLeft))
			end
			bar.CanChange = function(panel2, hindered)
				if (hindered) then
					return true
				end

				return pointsLeft > 0
			end

			self.bars[k] = bar
		end

		self.finish = self:Add("SButton")
		self.finish:Dock(BOTTOM)
		self.finish:DockMargin(0, 4, 0, 0)
		self.finish:SetText(nut.lang.Get("finish"))
		--self.finish:SetImage("icon16/building_go.png")
		self.finish:SetTall(28)
		self.finish.DoClick = function(panel)
			local name = self.name:GetText()
			local gender = string.lower(self.gender:GetValue())
			local desc = self.desc:GetText()
			local model = "models/Police.mdl"
			local faction = index
			local attribs = {}

			for k, v in pairs(self.bars) do
				attribs[k] = v:GetValue()
			end

			local fault

			-- Huge if that verifies values for characters.
			if (!name or !string.find(name, "[^%s+]") or name == "") then
				fault = "You need to provide a valid name."
			elseif (!gender or (gender != "male" and gender != "female")) then
				fault = "You need to provide a valid gender."
			elseif (!desc or #desc < nut.config.descMinChars or !string.find(desc, "[^%s+]")) then
				fault = "You need to provide a valid description."
			elseif (!model) then
				fault = "You need to pick a valid model."
			elseif (!faction or !nut.faction.GetByID(faction)) then
				fault = "You did not choose a valid faction."
			end

			if (fault) then
				surface.PlaySound("buttons/button8.wav")

				self.label:SetTextColor(Color(255, 0, 0))
				self.label:SetText(fault)

				return
			end

			netstream.Start("nut_CharCreate", {
				name = name,
				gender = gender,
				desc = desc,
				model = model,
				faction = faction,
				attribs = attribs
			})

			self:ShowCloseButton(false)
			panel:SetDisabled(true)

			timer.Simple(45, function()
				if (IsValid(self)) then
					self:Remove()

					chat.AddText(Color(255, 0, 0), "Character creation request timed out!")
				end
			end)
		end
	end

	function PANEL:Think()
		if (!self:IsActive()) then
			self:MakePopup()
		end
	end
vgui.Register("nut_CharCreate", PANEL, "SFrame")

--netstream.Hook("nut_CharCreateAuthed", function()
--	nut.gui.charCreate:Remove()
--
--	surface.PlaySound("buttons/button9.wav")
--
--	timer.Simple(0.1, function()
--		if (IsValid(nut.gui.charMenu)) then
--			nut.gui.charMenu:FadeOutMusic()
--			nut.gui.charMenu:Remove()
--		end
--		
--		nut.gui.charMenu = vgui.Create("nut_CharMenu")
--	end)
--end)