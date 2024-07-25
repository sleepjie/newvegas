local PANEL = {}
	function PANEL:Init()
		self:SetSize(ScrW() * nut.config.menuWidth, ScrH() * nut.config.menuHeight)
		self:Center()
		self:MakePopup()
		self:SetTitle(nut.lang.Get("inventory"))

		if (LocalPlayer():IsSuperAdmin()) then
			local p = self:Add( "nut_NoticePanel" )
			p:Dock( TOP )
			p:DockMargin( 0, 0, 0, 5 )
			p:SetType( 4 )
			if (LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin()) then
				p:SetText("Left click to take. Right click to destroy.")
			else
				p:SetText("You are not able to take or destroy any items.")
			end
		end
	
		self.weight = self:Add("DPanel")
		self.weight:Dock(TOP)
		self.weight:SetTall(18)
		self.weight:DockMargin(0, 0, 0, 4)
		self.weight.Paint = function(panel, w, h)
			local width = self.weightValue or 0

			surface.SetDrawColor(100, 100, 100, 200)
			surface.DrawRect(0, 0, w * width, h)

			surface.SetDrawColor(255, 255, 255, 20)
			surface.DrawRect(0, 0, w * width, h * 0.4)

			surface.SetDrawColor(255, 255, 255, 30)
			surface.DrawOutlinedRect(0, 0, w, h)
		end

		local weight, maxWeight = LocalPlayer():GetInvWeight(LocalPlayer().InspectInventory)
		self.weightValue = weight / maxWeight

		self.weightText = self.weight:Add("DLabel")
		self.weightText:Dock(FILL)
		self.weightText:SetExpensiveShadow(1, color_black)
		self.weightText:SetTextColor(color_white)
		self.weightText:SetContentAlignment(5)
		self.weightText:SetText(weight.."/"..maxWeight.."lbs")

		self.list = self:Add("DScrollPanel")
		self.list:Dock(FILL)
		self.list:SetDrawBackground(true)

		self.categories = {}

		local categories = {}

		for k, v in pairs(LocalPlayer().InspectInventory or LocalPlayer:GetInventory()) do
			local itemTable = nut.item.Get(k)
			
			if (itemTable) then
				categories[itemTable.category] = categories[itemTable.category] or {}
				table.insert(categories[itemTable.category], {k, v, itemTable.name})
			end
		end

		for _, items2 in SortedPairs(categories) do
			for _, data in SortedPairsByMemberValue(items2, 3) do
				local class = data[1]
				local items = data[2]
				local itemTable = nut.item.Get(class)

				if (itemTable and table.Count(items) > 0) then
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
						category3:InvalidateLayout(true)

						self.categories[category2] = {list = list, category = category3, panel = panel}
					end

					local list = self.categories[category2].list

					for k, v in SortedPairs(items) do
						local icon = list:Add("SpawnIcon")
						icon:SetModel(itemTable.model or "models/error.mdl", itemTable.skin)

						if (itemTable.bodygroup) then
							for k, v in pairs(itemTable.bodygroup) do
								icon:SetBodyGroup( k, v )
							end
						end

						icon.PaintOver = function(icon, w, h)
							surface.SetDrawColor(0, 0, 0, 45)
							surface.DrawOutlinedRect(1, 1, w - 2, h - 2)

							if (itemTable.PaintIcon) then
								itemTable.data = v.data
									itemTable:PaintIcon(w, h)
								itemTable.data = nil
							end
						end
						
						local label = icon:Add("DLabel")
						label:SetPos(8, 3)
						label:SetWide(64)
						label:SetText(v.quantity)
						label:SetFont("DermaDefaultBold")
						label:SetDark(true)
						label:SetExpensiveShadow(1, Color(240, 240, 240))
						local iname, idesc = (v.data.custom and v.data.custom.name) or itemTable.name or "error", (v.data.custom and v.data.custom.desc) or itemTable:GetDesc(v.data)
						icon:SetToolTip("Name: "..iname.."\nDescription: "..idesc)
						if (LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin()) then
							icon.DoClick = function(icon)
								netstream.Start("nut_RequestItemRemoval", {itemuid = itemTable.uniqueID, itemdata = data, target = LocalPlayer().InspectTarget, destroy = false})
								SCHEMA:UpdateInspectInv(itemTable.uniqueID, -1, data)
								self:Remove()
								vgui.Create("nut_InspectInventory")
							end
							icon.DoRightCick = function(icon)
								netstream.Start("nut_RequestItemRemoval", {itemuid = itemTable.uniqueID, itemdata = data, target = LocalPlayer().InspectTarget, destroy = true})
								SCHEMA:UpdateInspectInv(itemTable.uniqueID, -1, data)
								self:Remove()
								vgui.Create("nut_InspectInventory")
							end
						end
					end
				elseif (table.Count(items) == 0) then
					LocalPlayer():GetInventory()[class] = nil
				end
			end
		end
	end

	function PANEL:Think()
		if (!self:IsActive()) then
			self:MakePopup()
		end
	end

	function PANEL:Reload()
		local parent = self:GetParent()

		self:Remove()

		nut.gui.inv = vgui.Create("nut_InspectInventory", parent)
		nut.gui.menu:SetCurrentMenu(nut.gui.inv, true)
	end
vgui.Register("nut_InspectInventory", PANEL, "DFrame")
