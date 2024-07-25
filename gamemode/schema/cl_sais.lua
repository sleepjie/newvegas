function SCHEMA:ModifyItem(item, index)
	local data = item.itemData
	local itemname, itemmodel, itemdesc, itemcolor, itemquality, itemcondition, wepdamage, weprecoil, wepspread, wepfiredelay, overridemagsize, maxmagsize
	if data.custom then
		itemname = data.custom.name or ""
		itemmodel = data.custom.model or ""
		itemdesc = data.custom.desc or ""
		itemcolor = data.custom.color or Color(255, 255, 255)
		itemquality = data.custom.quality or 1
		itemcondition = data.custom.condition or 0
		wepdamage = data.custom.wepdamage or 10
		weprecoil = data.custom.weprecoil or 10
		wepspread = data.custom.wepspread or 10
		wepfiredelay = data.custom.wepfiredelay or 10
		overridemagsize = data.custom.overridemagsize or 10
		maxmagsize = data.custom.maxmagsize or 10
	else
		itemname = item.name
		itemmodel = item.model
		itemdesc = item.desc
		itemcolor = nut.config.mainColor
		itemquality = "common"
		itemcondition = 100
		wepdamage = 1
		weprecoil = 1
		wepspread = 1
		wepfiredelay = 1
		overridemagsize = false
		maxmagsize = 30
	end

	local modifyFrame = vgui.Create("DFrame")
	modifyFrame:SetSize(450, 600)
	modifyFrame:Center()
	modifyFrame:SetTitle(itemname)
	modifyFrame:MakePopup()
	modifyFrame:ShowCloseButton(false)

	local modifyScroll = vgui.Create("DScrollPanel", modifyFrame)
	modifyScroll:Dock(FILL)

	local modifyLabel = vgui.Create("DLabel", modifyScroll)
	modifyLabel:SetText("Name:")
	modifyLabel:Dock(TOP)

	local modifyName = vgui.Create("DTextEntry", modifyScroll)
	modifyName:SetToolTip("This is the new name of the item you are modifying.")
	modifyName:SetText(itemname)
	modifyName:Dock(TOP)

	modifyLabel = vgui.Create("DLabel", modifyScroll)
	modifyLabel:SetText("Description:")
	modifyLabel:Dock(TOP)

	local modifyDescription = vgui.Create("DTextEntry", modifyScroll)
	modifyDescription:SetText(itemdesc)
	modifyDescription:Dock(TOP)

	modifyLabel = vgui.Create("DLabel", modifyScroll)
	modifyLabel:SetText("Model:")
	modifyLabel:Dock(TOP)

	local modifyModel = vgui.Create("DTextEntry", modifyScroll)
	modifyModel:SetToolTip("This is a path to the model of the item you are modifying.")
	modifyModel:SetText(itemmodel)
	modifyModel:Dock(TOP)

	modifyLabel = vgui.Create("DLabel", modifyScroll)
	modifyLabel:SetText("Color:")
	modifyLabel:Dock(TOP)

	local modifyColor = vgui.Create("DColorMixer", modifyScroll)
	modifyColor:Dock(TOP)
	modifyColor:SetColor(itemcolor)

	modifyLabel = vgui.Create("DLabel", modifyScroll)
	modifyLabel:SetText("Quality:")
	modifyLabel:Dock(TOP)

	local choices = {"common", "rare", "legendary", "radioactive", "godlike", "unique", "epic", "one of a kind"}

	local modifyQuality = vgui.Create("DComboBox", modifyScroll)
	modifyQuality:SetToolTip("This is the item quality, please select appropriate qualities for your items.")
	modifyQuality:Dock(TOP)
	modifyQuality:SetValue(itemquality)
	for k, v in pairs(choices) do
		modifyQuality:AddChoice(v)
	end

	modifyLabel = vgui.Create("DLabel", modifyScroll)
	modifyLabel:SetText("Condition:")
	modifyLabel:Dock(TOP)

	local modifyCondition = vgui.Create("DNumberWang", modifyScroll)
	modifyCondition:SetToolTip("This is how damaged the item is.")
	modifyCondition:Dock(TOP)
	modifyCondition:SetMinMax(0, 100)
	modifyCondition:SetValue(itemcondition)

	modifyLabel = vgui.Create("DLabel", modifyScroll)
	modifyLabel:SetText("Is weapon?:")
	modifyLabel:Dock(TOP)

	local checkboxPanel = vgui.Create("DPanel", modifyScroll)
	checkboxPanel:Dock(TOP)

	local modifyWeaponCheckBox = vgui.Create("DCheckBox", checkboxPanel)
	modifyWeaponCheckBox:SetToolTip("Please tick this if you are modifying a weapon")

	modifyLabel = vgui.Create("DLabel", modifyScroll)
	modifyLabel:SetText("Damage Multiplier:")
	modifyLabel:Dock(TOP)

	local modifyWepDamage = vgui.Create("DNumberWang", modifyScroll)
	modifyWepDamage:SetToolTip("This is multiplied by weapon damage to determine how much damage a weapon can do. (multiplier x damage)")
	modifyWepDamage:Dock(TOP)
	modifyWepDamage:SetMinMax(0, 10)
	modifyWepDamage:SetValue(wepdamage)

	modifyLabel = vgui.Create("DLabel", modifyScroll)
	modifyLabel:SetText("Recoil Multiplier:")
	modifyLabel:Dock(TOP)

	local modifyWepRecoil = vgui.Create("DNumberWang", modifyScroll)
	modifyWepRecoil:SetToolTip("This is multiplied by weapon recoil to determine how much recoil the weapon has. (multiplier x recoil)")
	modifyWepRecoil:Dock(TOP)
	modifyWepRecoil:SetMinMax(0, 10)
	modifyWepRecoil:SetValue(weprecoil)

	modifyLabel = vgui.Create("DLabel", modifyScroll)
	modifyLabel:SetText("Spread Multiplier:")
	modifyLabel:Dock(TOP)

	local modifyWepSpread = vgui.Create("DNumberWang", modifyScroll)
	modifyWepSpread:SetToolTip("This is multiplied by weapon spread to determine how much spread the weapon has. (multiplier x spread)")
	modifyWepSpread:Dock(TOP)
	modifyWepSpread:SetMinMax(0, 10)
	modifyWepSpread:SetValue(wepspread)

	modifyLabel = vgui.Create("DLabel", modifyScroll)
	modifyLabel:SetText("Fire Delay Multipier:")
	modifyLabel:Dock(TOP)

	local modifyWepFireDelay = vgui.Create("DNumberWang", modifyScroll)
	modifyWepFireDelay:SetToolTip("This is multiplied by the firedelay to determine how fast you can shoot the weapon.")
	modifyWepFireDelay:Dock(TOP)
	modifyWepFireDelay:SetMinMax(0, 3)
	modifyWepFireDelay:SetValue(wepfiredelay)

	modifyLabel = vgui.Create("DLabel", modifyScroll)
	modifyLabel:SetText("Override Attatchment Max Magazine Size:")
	modifyLabel:Dock(TOP)

	checkboxPanel = vgui.Create("DPanel", modifyScroll)
	checkboxPanel:Dock(TOP)

	local modifyWeaponMaxMagazineOverride = vgui.Create("DCheckBox", checkboxPanel)
	modifyWeaponMaxMagazineOverride:SetToolTip("Tick to override attatchment max magazine size")
	modifyWeaponMaxMagazineOverride:SetChecked(overridemagsize)

	modifyLabel = vgui.Create("DLabel", modifyScroll)
	modifyLabel:SetText("Magazine Size:")
	modifyLabel:Dock(TOP)

	local modifyWepMagSize = vgui.Create("DNumberWang", modifyScroll)
	modifyWepMagSize:SetToolTip("This is the maximum magazine size.")
	modifyWepMagSize:Dock(TOP)
	modifyWepMagSize:SetMinMax(0, 100)
	modifyWepMagSize:SetValue(maxmagsize)

	local cancelButton = vgui.Create("DButton", modifyFrame)
	cancelButton:SetPos(322,4)
	cancelButton:SetSize(60,20)
	cancelButton:SetText("Abort")
	cancelButton.DoClick = function()
		modifyFrame:Remove()
		surface.PlaySound("forp/ui_menu_cancel.wav")
	end

	local closeButton = vgui.Create("DButton", modifyFrame)
	closeButton:SetPos(386,4)
	closeButton:SetSize(60,20)
	closeButton:SetText("Done")
	closeButton.DoClick = function()
		local customdata = {}
		customdata[1] = item.uniqueID
		customdata[2] = index
		customdata[3] = {}

		customdata[3].name = modifyName:GetValue()
		customdata[3].model = modifyModel:GetValue()
		customdata[3].desc = modifyDescription:GetValue()
		customdata[3].color = modifyColor:GetColor()
		customdata[3].quality = modifyQuality:GetValue()
		customdata[3].condition = modifyCondition:GetValue()

		if modifyWeaponCheckBox:GetChecked() then
			customdata[3].wepdamage = modifyWepDamage:GetValue()
			customdata[3].weprecoil = modifyWepRecoil:GetValue()
			customdata[3].wepspread = modifyWepSpread:GetValue()
			customdata[3].wepfiredelay = modifyWepFireDelay:GetValue()
			customdata[3].overridemagsize = modifyWeaponMaxMagazineOverride:GetChecked()
			customdata[3].maxmagsize = modifyWepMagSize:GetValue()
		end

		netstream.Start("nut_ModifyItem", customdata)

		modifyFrame:Remove()
		surface.PlaySound("forp/ui_menu_ok.wav")
	end
end