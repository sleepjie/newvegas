local PANEL = {}
	local gradient = surface.GetTextureID("gui/gradient_up")
	local gradient2 = surface.GetTextureID("gui/gradient_down")
	local gradient3 = surface.GetTextureID("gui/center_gradient")

	local backgroundNV = Material("thespireroleplay/vgui/charmenu/background.png")

	function PANEL:Init()

		self:SetSize(ScrW(), ScrH())
		self:SetDrawBackground(false)
		self:MakePopup()

			self.FalloutLogo = vgui.Create("nsFade", self)
			self.FalloutLogo:SetText(" ")
			self.FalloutLogo:FadeIn(1.5)
			self.FalloutLogo:SetImage("thespireroleplay/vgui/charmenu/main.png")
			self.FalloutLogo:SetImageSize(512, 128)
			self.FalloutLogo:SetSize(512,128)
			self.FalloutLogo:SetMouseInputEnabled(false)
			self.FalloutLogo:SetPos(24, ((ScrH() / 2)-42))

			timer.Simple(0.7, function()
				self.createButton = vgui.Create("SButton", self)
				self.createButton:SetText("Continue")
				self.createButton:FadeIn(1)
				self.createButton:SetWide(220)
				self.createButton:SetPos(ScrW() - (200 + self.createButton:GetWide()/2), (ScrH() / 2) - 150)
				self.createButton:SetMouseInputEnabled(true)
				self.createButton.DoClick = function(panel)
					if IsValid(characterPanel) and characterPanel.Active then
						characterPanel:FadeOut(characterPanel)
						return
					end

	
					if IsValid(factionPanel) and factionPanel.Active then 
						factionPanel:FadeOut(factionPanel)
						return
					end
		
					self.characters = {}
					local y = 0
	
					characterPanel = vgui.Create("DPanel", self)
					characterPanel:SetPos(ScrW() - (775), (ScrH() / 2) - 150)
					characterPanel:SetSize(450, 500)
					characterPanel.Active = true
					characterPanel.Paint = function(p, w, h)
					    surface.SetDrawColor(50, 50, 50, 0) 
					    surface.DrawRect(0, 0, w, h)
					end
					characterPanel.FadeOut = function(p)
						local children = p:GetChildren()
						for _, panel in pairs(children) do
							panel:FadeOut(0.25)
						end
						p.Active = false
						timer.Simple(2, function()
							if IsValid(p) then
								p:Remove()
							end
						end)
					end
	
					if (LocalPlayer().characters and table.Count(LocalPlayer().characters) > 0) then
						for k, v in SortedPairsByMemberValue(LocalPlayer().characters, "id", true) do
							local color = nut.config.mainColor
							local r, g, b = color.r, color.g, color.b
	
							self.charSelect = vgui.Create("SButton", characterPanel)
							local name = v.name or "Error"
							self.charSelect:SetText("Load - "..name)
							self.charSelect:FadeIn(0.5)
							self.charSelect:SetWide(450)
							self.charSelect:SetMouseInputEnabled(true)
							self.charSelect:SetPos(0,y)
							self.charSelect.DoClick = function()
								self.id = v.id
								if (self.id) then
									netstream.Start("nut_CharChoose", self.id)
								else
									return false
								end
							end
	
							y = self.charSelect:GetTall() + 10 + y
							self.characters[v.id] = panel
						end
					end
				end
	
				self.continueButton = vgui.Create("SButton", self)
				self.continueButton:SetText("New")
				self.continueButton:FadeIn(1)
				self.continueButton:SetWide(220)
				self.continueButton:SetPos(ScrW() - (200 + self.continueButton:GetWide()/2), (ScrH() / 2) - 100)
				self.continueButton:SetMouseInputEnabled(true)
				self.continueButton.DoClick = function(panel)
					if IsValid(factionPanel) and factionPanel.Active then
						factionPanel:FadeOut(factionPanel)
						return
					end

					if IsValid(characterPanel) and characterPanel.Active then 
						characterPanel:FadeOut(characterPanel)
						return
					end
	
					if (IsValid(nut.gui.charCreate)) then
						return false
					end
	
					if (LocalPlayer().characters and table.Count(LocalPlayer().characters) >= nut.config.maxChars) then
						return false
					end
	
					if (IsValid(self.selector)) then
						self.selector:Remove()
	
						return
					end
	
					local grace = CurTime() + 0.1
	
					local y = 0
	
					factionPanel = vgui.Create("DPanel", self)
					factionPanel:SetPos(ScrW() - (775), (ScrH() / 2) - 150)
					factionPanel:SetSize(460, 500)
					factionPanel.Active = true
					factionPanel.Paint = function(p, w, h)
					    surface.SetDrawColor(50, 50, 50, 0) 
					    surface.DrawRect(0, 0, w, h) -- Draw the rect
					end
					factionPanel.FadeOut = function(p)
						local children = p:GetChildren()
						for _, panel in pairs(children) do
							panel:FadeOut(0.25)
						end
						p.Active = false
						timer.Simple(2, function()
							if IsValid(p) then
								p:Remove()
							end
						end)
					end
	
					for k, v in ipairs(nut.faction.GetAll()) do
						if (nut.faction.CanBe(LocalPlayer(), v.index)) then
	
							self.factionSelect = vgui.Create("SButton", factionPanel)
							self.factionSelect:SetText(v.name)
							self.factionSelect:SetWide(450)
							self.factionSelect:FadeIn(0.5)
							self.factionSelect:SetMouseInputEnabled(true)
							self.factionSelect:SetPos(0, y)
							self.factionSelect.DoClick = function(panel)
								if IsValid(factionPanel) and factionPanel.Active then
									factionPanel:FadeOut(factionPanel)
								end
								SCHEMA:PlayIntro()
								self:Remove()
								self:FadeOutMusic()
							end
	
							y = self.factionSelect:GetTall() + 10 + y
						end
					end
				end
	
				self.loadButton = vgui.Create("SButton", self)
				self.loadButton:SetText("Load")
				self.loadButton:FadeIn(1)
				self.loadButton:SetWide(220)
				self.loadButton:SetPos(ScrW() - (200 + self.loadButton:GetWide()/2), (ScrH() / 2) - 50)
				self.loadButton:SetMouseInputEnabled(true)
				self.loadButton.DoClick = function(panel)
	
					if IsValid(characterPanel) and characterPanel.Active then
						characterPanel:FadeOut(characterPanel)
						return
					end
	
					if IsValid(factionPanel) and factionPanel.Active then 
						factionPanel:FadeOut(factionPanel)
						return
					end
		
					self.characters = {}
					local y = 0
	
					characterPanel = vgui.Create("DPanel", self)
					characterPanel:SetPos(ScrW() - (775), (ScrH() / 2) - 150)
					characterPanel:SetSize(460, 500)
					characterPanel.Active = true
					characterPanel.Paint = function(p, w, h)
					    surface.SetDrawColor(50, 50, 50, 0) 
					    surface.DrawRect(0, 0, characterPanel:GetWide(), characterPanel:GetTall()) -- Draw the rect
					end
					characterPanel.FadeOut = function(p)
						local children = p:GetChildren()
						for _, panel in pairs(children) do
							panel:FadeOut(0.25)
						end
						p.Active = false
						timer.Simple(2, function()
							if IsValid(p) then
								p:Remove()
							end
						end)
					end

					if (LocalPlayer().characters and table.Count(LocalPlayer().characters) > 0) then
						for k, v in SortedPairsByMemberValue(LocalPlayer().characters, "id", true) do
							local color = nut.config.mainColor
							local r, g, b = color.r, color.g, color.b
	
							self.charSelect = vgui.Create("SButton", characterPanel)
							local name = v.name or "Error"
							self.charSelect:SetText("Load - "..name)
							self.charSelect:SetWide(450)
							self.charSelect:FadeIn(0.5)
							self.charSelect:SetMouseInputEnabled(true)
							self.charSelect:SetPos(0,y)
							self.charSelect.DoClick = function(panel)
								self.id = v.id
									
								if (self.id) then
									netstream.Start("nut_CharChoose", self.id)
								else
									return false
								end
							end
	
							y = self.charSelect:GetTall() + 10 + y
	
							self.characters[v.id] = panel
						end
					end
				end
	
				self.settingsButton = vgui.Create("SButton", self)
				self.settingsButton:SetText("Delete")
				self.settingsButton:FadeIn(1)
				self.settingsButton:SetWide(220)
				self.settingsButton:SetPos(ScrW() - (200 + self.settingsButton:GetWide()/2), (ScrH() / 2))
				self.settingsButton:SetMouseInputEnabled(true)
				self.settingsButton.DoClick = function(panel)
					if IsValid(characterPanel) and characterPanel.Active then
						characterPanel:FadeOut(characterPanel)
						return
					end
	
					if IsValid(factionPanel) and factionPanel.Active then 
						factionPanel:FadeOut(factionPanel)
						return
					end
		
					self.characters = {}
					local y = 0
	
					characterPanel = vgui.Create("DPanel", self)
					characterPanel:SetPos(ScrW() - (775), (ScrH() / 2) - 150)
					characterPanel:SetSize(460, 250)
					characterPanel.Active = true
					characterPanel.Paint = function(p, w, h)
					    surface.SetDrawColor(50, 50, 50, 0) 
					    surface.DrawRect(0, 0, characterPanel:GetWide(), characterPanel:GetTall()) -- Draw the rect
					end
					characterPanel.FadeOut = function(p)
						local children = p:GetChildren()
						for _, panel in pairs(children) do
							panel:FadeOut(0.25)
						end
						p.Active = false
						timer.Simple(2, function()
							if IsValid(p) then
								p:Remove()
							end
						end)
					end

					if (LocalPlayer().characters and table.Count(LocalPlayer().characters) > 0) then
						for k, v in SortedPairsByMemberValue(LocalPlayer().characters, "id", true) do
							local color = nut.config.mainColor
							local r, g, b = color.r, color.g, color.b
	
							self.charDelete = vgui.Create("SButton", characterPanel)
							local name = v.name or "Error"
							self.charDelete:SetText("DELETE - "..name)
							self.charDelete:SetWide(450)
							self.charDelete:FadeIn(0.5)
							self.charDelete:SetTextColor(Color(255,80,80))
							self.charDelete:SetMouseInputEnabled(true)
							self.charDelete:SetPos(0,y)
							self.charDelete.DoClick = function(panel)
								self.id = v.id
	
								if (self.id) then
									netstream.Start("nut_CharDelete", self.id)
								else
									return false
								end
	
								for k, v in pairs(LocalPlayer().characters) do
									if (v.id == self.id) then
										LocalPlayer().characters[k] = nil
									end
								end
	
								timer.Simple(0, function()
									if (IsValid(nut.gui.charMenu)) then
										nut.gui.charMenu:FadeOutMusic()
										nut.gui.charMenu:Remove()
									end
			
									nut.gui.charMenu = vgui.Create("nut_CharMenu")
								end)
							end
	
							y = self.charDelete:GetTall() + 10 + y
							self.characters[v.id] = panel
						end
					end
				end
	
				self.creditsTab = vgui.Create("SButton", self)
				self.creditsTab:SetText("Discord")
				self.creditsTab:SetWide(220)
				self.creditsTab:FadeIn(1)
				self.creditsTab:SetPos(ScrW() - (200 + self.settingsButton:GetWide()/2), (ScrH() / 2) + 50)
				self.creditsTab:SetMouseInputEnabled(true)
 				self.creditsTab.DoClick = function(panel)
					gui.OpenURL("https://discord.gg/y3PRSqEecg")
				end
	
				
				self.Forums = vgui.Create("SButton", self)
				self.Forums:SetText("Content")
				self.Forums:SetWide(220)
				self.Forums:FadeIn(1)
				self.Forums:SetPos(ScrW() - (200 + self.Forums:GetWide()/2), (ScrH() / 2) + 100)
				self.Forums:SetMouseInputEnabled(true)
				self.Forums.DoClick = function(panel)
					gui.OpenURL("https://steamcommunity.com/sharedfiles/filedetails/?id=1856713663")
				end
				
	
				self.Leave = vgui.Create("SButton", self)
				self.Leave:SetText("Disconnect")
				self.Leave:FadeIn(1)
				self.Leave:SetWide(220)
				self.Leave:SetPos(ScrW() - (200 + self.Leave:GetWide()/2), (ScrH() / 2) + 150)
				self.Leave:SetMouseInputEnabled(true)
				self.Leave.DoClick = function(panel)
					if (LocalPlayer().character) then
						if (IsValid(nut.gui.charCreate)) then
							return false
						end
						self:FadeOutMusic()
						self:Remove()
					else
						RunConsoleCommand("disconnect")
					end
				end
	
				if (LocalPlayer().character) then
					self.Leave:SetText("Back")
					self.disconnect = vgui.Create("SButton", self)
					self.disconnect:SetText("Disconnect")
					self.disconnect:SetWide(220)
					self.disconnect:FadeIn(1)
					self.disconnect:SetPos(ScrW() - (200 + self.Leave:GetWide()/2), ScrH() - 100)
					self.disconnect:SetMouseInputEnabled(true)
					self.disconnect.DoClick = function(panel)
						RunConsoleCommand("disconnect")
					end
				end
			end)

		do
			if (nut.menuMusic) then
				nut.menuMusic:Stop()
				nut.menuMusic = nil
			end

			nut.menuMusic = CreateSound(LocalPlayer(), "fosounds/fix/MainTitle.mp3")
			nut.menuMusic:Play()
			nut.menuMusic:ChangeVolume(80 / 100, 0)
		end

		nut.loaded = true
	end

	function PANEL:FadeOutMusic()
		if (!nut.menuMusic) then
			return
		end

		nut.menuMusic:FadeOut(3)
		timer.Simple(3, function()
			nut.menuMusic = nil
		end)
	end

	function PANEL:Paint(w, h)
		surface.SetDrawColor(20, 20, 20)
		surface.SetTexture(gradient)
		surface.DrawTexturedRect(0, 0, w, h)

		surface.SetDrawColor(255,255,255)
		surface.SetMaterial(backgroundNV)
		surface.DrawTexturedRect(0, 0, w, h)
	end

	function PANEL:FadeIn()
		timer.Simple(0.1, function()
			self.Leave:SetAlpha(0)
			self.Forums:SetAlpha(0)
			self.creditsTab:SetAlpha(0)
			self.settingsButton:SetAlpha(0)
			self.loadButton:SetAlpha(0)
			self.continueButton:SetAlpha(0)
			self.createButton:SetAlpha(0)
			self.FalloutLogo:SetAlpha(0)

			timer.Simple(1.4, function()
				self.Leave:FadeIn(1)
				self.Forums:FadeIn(1)
				self.creditsTab:FadeIn(1)
				self.settingsButton:FadeIn(1)
				self.loadButton:FadeIn(1)
				self.continueButton:FadeIn(1)
				self.createButton:FadeIn(1)
			end)

			self.FalloutLogo:FadeIn(1.5)
		end)
	end

vgui.Register("nut_CharMenu", PANEL, "DPanel")

netstream.Hook("nut_CharMenu", function(forced)
	if (IsValid(nut.gui.charMenu)) then
		nut.gui.charMenu:FadeOutMusic()
		nut.gui.charMenu:Remove()

		if (!forced) then
			return
		end
	end

	if (forced) then
		nut.loaded = nil
	end

	nut.gui.charMenu = vgui.Create("nut_CharMenu")
end)