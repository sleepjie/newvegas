local PANEL = {}
	local gradient = surface.GetTextureID("gui/gradient")
	function PANEL:Init()
		local bg = vgui.Create("nut_MenuSide")
		self.background = bg
	
		self:SetPos(ScrW() * 0.375, ScrH() * 0.125)
		self:SetSize(ScrW() * nut.config.menuWidth, ScrH() * nut.config.menuHeight)
		self:MakePopup()
		self:SetTitle(nut.lang.Get("business"))
		self:Center()

		local noticePanel = self:Add( "nut_NoticePanel" )
		noticePanel:Dock( TOP )
		noticePanel:DockMargin( 0, 0, 0, 5 )
		noticePanel:SetType( 4 )
		noticePanel:SetText("Left click purchase at full price. Right click to purchase at half price with half condition.")
		
		self.list = self:Add("DScrollPanel")
		self.list:Dock(FILL)
		self.list:SetDrawBackground(true)

		self.categories = {}
		self.nextBuy = 0

		local result = hook.Run("BusinessPrePopulateItems", self)

		if (result != false) then
			local categories = {}
			for k, v in pairs(LocalPlayer().BusinessInfo) do
				local itemTable = nut.item.Get(k)
				if (itemTable) then
					itemTable.meta = v.data
					categories[itemTable.category] = categories[itemTable.category] or {}
					table.insert(categories[itemTable.category], itemTable)
				end
			end

			for _, items in SortedPairs(categories) do
				for _, itemTable in SortedPairsByMemberValue(items, "name") do
					local class = itemTable.uniqueID
					local allowed = true

					if (itemTable.faction) then
						if (type(itemTable.faction) == "number" and itemTable.faction != LocalPlayer():Team()) then
							allowed = false
						elseif (type(itemTable.faction) == "table" and !table.HasValue(itemTable.faction, LocalPlayer():Team())) then
							allowed = false
						end
					end

					if (allowed and hook.Run("ShouldItemDisplay", itemTable) != false and !itemTable.noBusiness and (!itemTable.ShouldShowOnBusiness or (itemTable.ShouldShowOnBusiness and itemTable:ShouldShowOnBusiness(LocalPlayer()) != false))) then
						local category = itemTable.category
						local category2 = string.lower(category)

						if (!self.categories[category2]) then
							local category3 = self.list:Add("DCollapsibleCategory")
							category3:Dock(TOP)
							category3:SetLabel(category)
							category3:DockMargin(5, 5, 5, 5)
							category3:SetPadding(5)

							local list = vgui.Create("DIconLayout")
								list.Paint = function(list, w, h)
									surface.SetDrawColor(0, 0, 0, 25)
									surface.DrawRect(0, 0, w, h)
								end
							category3:SetContents(list)
								local icon = list:Add("SpawnIcon")
								icon:SetModel(itemTable.model or "models/error.mdl", itemTable.skin)

								local cost = "Price: Free"

								if (itemTable.price and itemTable.price > 0) then
									if (!nut.currency.IsSet()) then
										error("Item has price but no currency is set!")
									end
								
									cost = "Price: "..nut.currency.GetName(itemTable.price or 0)
								end

								icon:SetToolTip("Name: " .. itemTable.name .. "\nDescription: "..itemTable:GetDesc().."\n"..cost.."\nThis item will be in restocked in "..(string.NiceTime(itemTable.meta.lastrefresh + itemTable.meta.cooldown - os.time())))

								icon.label = vgui.Create("DLabel", icon)
								icon.label:SetPos(4, 2)
								icon.label:SizeToContentsX()
								icon.label:SetContentAlignment(7)
								icon.label:SetFont("DermaDefault")
								icon.label:SetTextColor(Color(255,255,255))
								icon.label:SetText(itemTable.meta.stock)
								icon.label.stock = itemTable.meta.stock
	
								if (itemTable.meta.stock == 0) then
									icon.OutOfStock = true
								end
	
								icon.DoClick = function(panel)
									if (icon.disabled) then
										return
									end
	
									if (icon.OutOfStock) then
										return
									end
	
									if (LocalPlayer():CanAfford(itemTable.price or 0) and LocalPlayer():HasInvSpace(itemTable)) then
										netstream.Start("nut_NewBuyItem", {uniqueID = class})
										icon.disabled = true
										icon:SetAlpha(70)
										
										--LocalPlayer().BusinessInfo[class].data.stock = LocalPlayer().BusinessInfo[k].data.stock - 1
										icon.label:SetText(icon.label.stock - 1)
										icon.label.stock = icon.label.stock - 1
									end
	
									timer.Simple(nut.config.buyDelay, function()
										if (IsValid(icon)) then
											icon.disabled = false
											icon:SetAlpha(255)
										end
									end)
								end
	
								icon.DoRightClick = function(panel)
									if (icon.disabled) then
										return
									end
	
									if (icon.OutOfStock) then
										return
									end
	
									if (LocalPlayer():CanAfford(itemTable.price/2 or 0) and LocalPlayer():HasInvSpace(itemTable)) then
										netstream.Start("nut_NewBuyItem", {uniqueID = class, halfcond = true})
										icon.disabled = true
										icon:SetAlpha(70)
										
										--LocalPlayer().BusinessInfo[class].data.stock = LocalPlayer().BusinessInfo[k].data.stock - 1
										icon.label:SetText(icon.label.stock - 1)
										icon.label.stock = icon.label.stock - 1
									end
	
									timer.Simple(nut.config.buyDelay, function()
										if (IsValid(icon)) then
											icon.disabled = false
											icon:SetAlpha(255)
										end
									end)
								end

								icon.Think = function()
									if (icon.OutOfStock) then
										icon:SetAlpha(70)
										icon:SetToolTip("**THIS ITEM IS OUT OF STOCK**".."\nThis item will be in stock in "..(string.NiceTime(itemTable.meta.lastrefresh + itemTable.meta.cooldown - os.time())).."\nName: " .. itemTable.name .. "\nDescription: "..itemTable:GetDesc().."\n"..cost)
									end
	
									if (icon.label.stock == 0) then
										icon:SetAlpha(70)
										icon.OutOfStock = true
									end
								end

							self.categories[category2] = {list = list, category = category3, panel = panel}
						else
							local list = self.categories[category2].list
							local icon = list:Add("SpawnIcon")
							icon:SetModel(itemTable.model or "models/error.mdl", itemTable.skin)

							local cost = "Price: Free"

							if (itemTable.price and itemTable.price > 0) then
								if (!nut.currency.IsSet()) then
									error("Item has price but no currency is set!")
								end

								cost = "Price: "..nut.currency.GetName(itemTable.price or 0)
							end

							icon:SetToolTip("Name: " .. itemTable.name .. "\nDescription: "..itemTable:GetDesc().."\n"..cost.."\nThis item will be in restocked in "..(string.NiceTime(itemTable.meta.lastrefresh + itemTable.meta.cooldown - os.time())))
							-- insert below

							icon.label = vgui.Create("DLabel", icon)
							icon.label:SetPos(4, 2)
							icon.label:SizeToContentsX()
							icon.label:SetContentAlignment(7)
							icon.label:SetFont("DermaDefault")
							icon.label:SetTextColor(Color(255,255,255))
							icon.label:SetText(itemTable.meta.stock)
							icon.label.stock = itemTable.meta.stock

							if (itemTable.meta.stock == 0) then
								icon.OutOfStock = true
								icon:SetToolTip("**THIS ITEM IS OUT OF STOCK**".."\nThis item will be in stock in "..(string.NiceTime(itemTable.meta.lastrefresh + itemTable.meta.cooldown - os.time())).."\nName: " .. itemTable.name .. "\nDescription: "..itemTable:GetDesc().."\n"..cost)
							end

							icon.DoClick = function(panel)
								if (icon.disabled) then
									return
								end

								if (icon.OutOfStock) then
									return
								end

								if (LocalPlayer():CanAfford(itemTable.price or 0) and LocalPlayer():HasInvSpace(itemTable)) then
									netstream.Start("nut_NewBuyItem", {uniqueID = class})
									icon.disabled = true
									icon:SetAlpha(70)
	
									--LocalPlayer().BusinessInfo[class].data.stock = LocalPlayer().BusinessInfo[k].data.stock - 1
									icon.label:SetText(icon.label.stock - 1)
									icon.label.stock = icon.label.stock - 1
								end

								timer.Simple(nut.config.buyDelay, function()
									if (IsValid(icon)) then
										icon.disabled = false
										icon:SetAlpha(255)
									end
								end)
							end
							icon.DoRightClick = function(panel)
								if (icon.disabled) then
									return
								end

								if (icon.OutOfStock) then
									return
								end

								if (LocalPlayer():CanAfford(itemTable.price/2 or 0) and LocalPlayer():HasInvSpace(itemTable)) then
									netstream.Start("nut_NewBuyItem", {uniqueID = class, halfcond = true})
									icon.disabled = true
									icon:SetAlpha(70)
									
									--LocalPlayer().BusinessInfo[class].data.stock = LocalPlayer().BusinessInfo[k].data.stock - 1
									icon.label:SetText(icon.label.stock - 1)
									icon.label.stock = icon.label.stock - 1
								end

								timer.Simple(nut.config.buyDelay, function()
									if (IsValid(icon)) then
										icon.disabled = false
										icon:SetAlpha(255)
									end
								end)
							end

							icon.Think = function()
								if (icon.OutOfStock) then
									icon:SetAlpha(70)
								end

								if (icon.label.stock == 0) then
									icon:SetAlpha(70)
									icon.OutOfStock = true
								end
							end

							hook.Run("BusinessItemCreated", itemTable, icon)			
						end
					end
				end
			end
		end

		hook.Run("BusinessPostPopulateItems", self)
	end

	function PANEL:Think()
	end
	
	function PANEL:OnRemove()
		if IsValid(self.PanelFriend) then
			self.PanelFriend:Remove()
		end
		if IsValid(self.background) then
			self.background:Remove()
		end
	end
vgui.Register("nut_NewBusiness", PANEL, "DFrame")