local PANEL = {}
	function PANEL:Init()
		self:SetPos(ScrW() * 0.375, ScrH() * 0.125)
		self:SetSize(ScrW() * nut.config.menuWidth, ScrH() * nut.config.menuHeight)
		self:MakePopup()
		self:SetTitle(nut.lang.Get("inventory"))

		local p = self:Add( "nut_NoticePanel" )
		p:Dock( TOP )
		p:DockMargin( 0, 0, 0, 5 )
		p:SetType( 4 )
		p:SetText("You can drag and drop items!")
		
		self.inventoryContainer = self:Add("DPanel")
		self.inventoryContainer:Dock(BOTTOM)
		self.inventoryContainer:SetTall(ScrH() * nut.config.menuHeight - 70)

		self.bagList = self.inventoryContainer:Add("DPanel")
		self.bagList:Dock(LEFT)
		self.bagList:SetWide(80)

		self.list = self.inventoryContainer:Add("DScrollPanel")
		self.list:Dock(RIGHT)

		self.list:SetWide(ScrW() * nut.config.menuWidth - 90)
		self.list:SetDrawBackground(true)

		local currentBag = LocalPlayer().CurrentBag or {}
		currentBag.name = LocalPlayer().CurrentBag and LocalPlayer().CurrentBag.name or "default"
		currentBag.bag = LocalPlayer().CurrentBag and LocalPlayer().CurrentBag.bag or {}

		for _, bags in ipairs(LocalPlayer():GetInventoryBags()) do
			local itemTable = nut.item.Get(bags.meta)

			if (!LocalPlayer().CurrentBag) then
				if (bags.meta == currentBag.name) then
					currentBag.bag = bags.bag
					currentBag.meta = bags.meta
					currentBag.maxWeight = itemTable and itemTable.capacity or nut.config.defaultInvWeight
				end 
			end
		end

		for _, bags in ipairs(LocalPlayer():GetInventoryBags()) do
			local itemTable = nut.item.Get(bags.meta)

			if bags.meta == "default" then
				local weight = LocalPlayer():GetInvWeight(bags.bag) / nut.config.defaultInvWeight
				self.bag = self.bagList:Add("SpawnIcon")
				self.bag:SetModel("models/Gibs/HGIBS.mdl")
				self.bag:Dock(TOP)
				self.bag:DockMargin(8,8,8,8)
				self.bag.weight = weight
				self.bag.currentBag = bags.meta
				self.bag.selectedBag = currentBag.meta
				self.bag.maxWeight = bags.maxWeight
				self.bag.PaintOver = function(p, w, h)
					local w, h = p:GetSize()
					surface.SetDrawColor(0,0,0,255)
					surface.DrawRect(8, 48, 48, 4)

					if (p.weight >= 1) then
						surface.SetDrawColor(150,20,20,255)
					else
						surface.SetDrawColor(10,150,10,255)
					end

					surface.DrawRect(8, 48, 48*math.Clamp(p.weight,0,1), 4)
					surface.SetDrawColor(0,0,0,140)
					
					if (p.isHovered and !LocalPlayer():HasItemEquipped(p.itemTable.uniqueID, p.itemData, LocalPlayer():GetInventoryByBag(p.selectedBag))) then
						local weight = LocalPlayer():GetInvWeight(LocalPlayer():GetInventoryByBag(p.currentBag))
						local maxWeight = p.maxWeight

						--print(weight + p.itemTable:GetWeight(p.itemData), maxWeight)
						--print(weight + p.itemTable:GetWeight(p.itemData) < maxWeight)
						if (weight + p.itemTable:GetWeight(p.itemData) < maxWeight) then
							surface.SetDrawColor(10,200,10,255)
						elseif (p.isHovered) then
							surface.SetDrawColor(200,10,10,255)
						end
					end

					if (p.selectedBag == p.currentBag) then
						surface.SetDrawColor(200,120,50,255)	
					end

					surface.DrawOutlinedRect(1,1,w-2,h-2)

					p.isHovered = false
				end

				self.bag:SetToolTip("Player Inventory".."\n".."Capacity: "..LocalPlayer():GetInvWeight(bags.bag).."/"..nut.config.defaultInvWeight.."lbs".."\n".."Weight Reduction: N/A")
			else
				local weight = LocalPlayer():GetInvWeight(bags.bag) / itemTable.capacity
				self.bag = self.bagList:Add("SpawnIcon")
				self.bag:SetModel(itemTable.model, itemTable.skin or 0)
				self.bag:Dock(TOP)
				self.bag:DockMargin(8,8,8,8)
				self.bag.weight = weight
				self.bag.currentBag = bags.meta
				self.bag.selectedBag = currentBag.meta
				self.bag.maxWeight = bags.maxWeight
				self.bag.PaintOver = function(p, w, h)
					local w, h = p:GetSize()
					surface.SetDrawColor(0,0,0,255)
					surface.DrawRect(8, 48, 48, 4)

					if (p.weight >= 1) then
						surface.SetDrawColor(150,20,20,255)
					else
						surface.SetDrawColor(10,150,10,255)
					end

					surface.DrawRect(8, 48, 48*math.Clamp(p.weight,0,1), 4)
					surface.SetDrawColor(0,0,0,140)

					if (p.isHovered and !LocalPlayer():HasItemEquipped(p.itemTable.uniqueID, p.itemData, LocalPlayer():GetInventoryByBag(p.selectedBag))) then
						local weight = LocalPlayer():GetInvWeight(LocalPlayer():GetInventoryByBag(p.currentBag))
						local maxWeight = p.maxWeight

						--print(weight + p.itemTable:GetWeight(p.itemData), maxWeight)
						--print(weight + p.itemTable:GetWeight(p.itemData) < maxWeight)
						if (weight + p.itemTable:GetWeight(p.itemData) < maxWeight) then
							surface.SetDrawColor(10,200,10,255)
						elseif (p.isHovered) then
							surface.SetDrawColor(200,10,10,255)
						end
					end

					if (p.selectedBag == p.currentBag) then
						surface.SetDrawColor(200,120,50,255)	
					end

					surface.DrawOutlinedRect(1,1,w-2,h-2)

					p.isHovered = false
				end

				self.bag:SetToolTip(itemTable.name.."\n".."Capacity: "..LocalPlayer():GetInvWeight(bags.bag).."/"..itemTable.capacity.."lbs".."\n".."Weight Reduction: "..(itemTable.reduction * 100).."%".."\n".."DT: "..(itemTable.dt or 0).."\nDR: "..itemTable.reduction)
			end

			self.bag:Receiver("Item", function(receiver, panels, dropped)
				receiver.isHovered = true
				receiver.itemTable = panels[1].itemTable
				if (dropped and LocalPlayer():HasInvSpace(nut.item.Get(panels[1].itemTable.uniqueID), 1, false, true, bags.bag) and !LocalPlayer():HasItemEquipped(panels[1].itemTable.uniqueID, panels[1].itemData, LocalPlayer():GetInventoryByBag(receiver.selectedBag))) then
					local data = {}
					data.targetUniqueID = panels[1].itemTable.uniqueID
					data.targetItemData = panels[1].itemData
					data.targetBag = receiver.selectedBag 
					data.receiverBag = receiver.currentBag

					netstream.Start("nut_RequestItemTransfer", data)
				end
			end)

			self.bag.DoClick = function()
				local inventory = LocalPlayer():GetInventoryByBag(bags.meta)
				LocalPlayer().CurrentBag = {}
				LocalPlayer().CurrentBag.name = bags.meta
				LocalPlayer().CurrentBag.meta = bags.meta
				LocalPlayer().CurrentBag.bag = inventory
				LocalPlayer().CurrentBag.maxWeight = itemTable and itemTable.capacity or nut.config.defaultInvWeight
				self:Reload()
			end
		end
	
		self.categories = {}
	
		local categories = {}
		for k, v in pairs(currentBag.bag) do
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
	
					for k, v in SortedPairs(items) do
						local panel = self.list:Add("DPanel")
						panel:Dock(TOP)
						panel:DockMargin(0,2,0,2)
						panel:SetTall(64)
						panel.itemTable = itemTable
						panel.itemData = v.data

						panel.PaintOver = function(icon, w, h)
							surface.SetDrawColor(0, 0, 0, 45)
							surface.DrawRect(w*0.55,1,1,h-2)
							surface.DrawRect(w*0.85,1,1,h-2)
						end

						local panelwidth, panelheight = 870*(ScrW()/1920), 64*(ScrH()/1080)

						local icon = panel:Add("SpawnIcon")
						icon:Dock(LEFT)
						icon:SetModel(itemTable.model, itemTable.skin or 0)
						if (itemTable.bodygroup) then
							for k, v in pairs(itemTable.bodygroup) do
								icon:SetBodyGroup(k, v)
							end
						end
						icon:DockMargin(4,4,4,4)
						icon:SetWide(56)

						local iname, idesc = (v.data and v.data.custom and v.data.custom.name) or itemTable.name or "error", (v.data and v.data.custom and v.data.custom.desc) or itemTable:GetDesc(v.data)
						local condition = v.data and v.data.custom and v.data.custom.condition or 1
						icon:SetToolTip("Name: "..iname.."\nDescription: "..idesc.."\nCondition "..(condition * 100).."%")
						icon.DoClick = function(icon)
							nut.item.OpenMenu(itemTable, v, k, icon, label)
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

						icon.DoClick = function(icon)
							nut.item.OpenMenu(itemTable, v, k, icon, label)
						end

						if (v.quantity > 1) then
							local label = vgui.Create("DLabel", icon)
							label:SetPos(4, 2)
							label:SizeToContentsX()
							label:SetContentAlignment(7)
							label:SetText(v.quantity)
							label:SetFont("DermaDefault")
							label:SetTextColor(Color(255,255,255))
						end

						local label = vgui.Create("DLabel", panel)
						label:SetPos(64, 4)
						label:SetContentAlignment(4)
						label:SetText(iname)
						label:SetFont("DermaDefaultBold")
						local namecol

						if (v.data and v.data.custom and v.data.custom.color) then
							namecol = Color(v.data.custom.color.r, v.data.custom.color.g, v.data.custom.color.b, 255)
						else
							namecol = Color(255,255,255)
						end

						label:SetTextColor(namecol)
						label:SizeToContents()

						local label = vgui.Create("DLabel", panel)
						label:SetPos(64, 18)
						label:SetContentAlignment(4)
						label:SetText(idesc)
						label:SetFont("DermaDefaultBold")
						label:SetTextColor(Color(180,180,180))
						label:SizeToContents()

						local label = vgui.Create("DLabel", panel)
						label:SetPos(panelwidth*0.55 + 8, 4)
						label:SetContentAlignment(4)
						label:SetText(category)
						label:SetFont("DermaDefaultBold")
						label:SetTextColor(Color(255,255,255))
						label:SizeToContents()

						local pounds
						if (itemTable.weight == 1) then
							pounds = "lb"
						else
							pounds = "lbs"
						end

						local label = vgui.Create("DLabel", panel)
						label:SetPos(panelwidth*0.55 + 8, 18)
						label:SetContentAlignment(4)
						label:SetFont("DermaDefaultBold")
						label:SetTextColor(Color(180,180,180))

						if (itemTable.weight >= 1) then
							label:SetText("Weight: "..itemTable.weight..pounds)
						else
							label:SetText("Weight: N/A")
						end

						label:SizeToContents()
						--local dropButton = panel:Add("DButton")
						--dropButton:SetPos(panelwidth*0.85, 0)
						--dropButton:SetSize(panelwidth - (panelwidth*0.85), panelheight)
						--dropButton:SetText("Drop")
						--dropButton.Paint = function(w,h)

						--end

						local label = vgui.Create("DLabel", panel)
						label:SetPos(panelwidth*0.85, 4)
						label:SetContentAlignment(4)
						label:SetText("Data")
						label:SetFont("DermaDefaultBold")
						label:SetTextColor(Color(255,255,255))
						label:SizeToContents()

						local label = vgui.Create("DLabel", panel)
						label:SetPos(panelwidth*0.85, 16)
						label:SetContentAlignment(7)
						label:SetFont("DermaDefaultBold")
						label:SetTextColor(Color(180,180,180))

						local texttoset = ""
						if (v.data and v.data.custom and v.data.custom.condition) then
							texttoset = "CND: "..(v.data.custom.condition * 100).."%"
						else
							texttoset = "CND: 100".."%"
						end

						if (itemTable.dt) then
							texttoset = texttoset.."\nDT: "..(itemTable.dt)
						end

						if (itemTable.reduction and itemTable.dt) then
							texttoset = texttoset.."\nDR: "..(itemTable.reduction)
						end

						if (itemTable.reduction and !itemTable.dt) then
							texttoset = texttoset.."\nWR: "..(itemTable.reduction)
						end

						texttoset = texttoset

						label:SetText(texttoset)
						label:SizeToContentsY()

						panel:Droppable("Item")
					end
				elseif (table.Count(items) == 0) then
					LocalPlayer():GetInventory()[class] = nil
				end
			end
		end
	end

	nut.char.HookVar("inv", "refreshInv", function(character)
		if (IsValid(nut.gui.inv)) then
			nut.gui.inv:Reload()
		end
	end)

	function PANEL:Think()
		if (!self:IsActive()) then
			self:MakePopup()
		end
	end

	function PANEL:Reload()
		local parent = self:GetParent()

		self:Remove()

		nut.gui.inv = vgui.Create("nut_Inventory", parent)
		nut.gui.menu:SetCurrentMenu(nut.gui.inv, true)
	end
vgui.Register("nut_Inventory", PANEL, "DFrame")
