-- lazy code ahead, waaah johnny you're so bad
-- fuck off it's on the client you dickhead.

local KeyDownDelay = CurTime() or KeyDownDelay

hook.Add("Think", "nut_OpenAuxMenus", function()
	if input.IsKeyDown(KEY_F3) and (KeyDownDelay < CurTime()) then
		KeyDownDelay = CurTime() + 1.5

		if (!LocalPlayer().vguiopen) then
			RunConsoleCommand("testvgui")
		end
	elseif input.IsKeyDown(KEY_F4) and (KeyDownDelay < CurTime()) then
		KeyDownDelay = CurTime() + 1.5
		
		if (!LocalPlayer().vguiopen) then
			RunConsoleCommand("testmedical")
		end
		
	elseif input.IsKeyDown(KEY_F2) and (KeyDownDelay < CurTime()) then
		KeyDownDelay = CurTime() + 1.5
		
		if (!LocalPlayer().vguiopen) then
			netstream.Start("nut_RequestTradeInfo")
		end
	end
end)

netstream.Hook("nut_RequestTradeInfo", function(data)
	if (data) then --and type(data) == "table") then
		LocalPlayer().BusinessInfo = data
		
		if IsValid(nut.gui.businessMenu) then
			nut.gui.businessMenu:Remove()
			nut.gui.businessMenu = nil
			
			return
		else
			local trademenu = vgui.Create("nut_NewBusiness")
			local currencyConv = vgui.Create("nut_CurrencyConversion")
			trademenu.PanelFriend = currencyConv
			nut.gui.businessMenu = trademenu
		end
	--elseif (data and type(data) == "string") then
	--	local trademenu = vgui.Create("nut_NewBusiness")
	else
		LocalPlayer():ChatPrint("You do not have access to this menu.")
	end
end)

concommand.Add("testvgui", function()
	LocalPlayer().vguiopen = true
	local frame = vgui.Create("DFrame")
	frame:SetSize(400, 519)
	frame:Center()
	frame:SetPos(frame:GetPos(), ScrH()*0.2)
	frame:SetTitle(LocalPlayer():Nick())
	frame:MakePopup()
	frame.OnClose = function()
		LocalPlayer().vguiopen = false
	end

	local panel = vgui.Create("DPanel", frame)
	panel:Dock(FILL)

	local charinfo = vgui.Create("DPanel", panel)
	charinfo:DockMargin(0,0,0,4)
	charinfo:Dock(TOP)
	charinfo:SetTall(68)

	local chardesc = vgui.Create("DLabel", charinfo)
	chardesc:DockMargin(6,6,6,6)
	chardesc:Dock(FILL)
	chardesc:SetWrap(true)
	chardesc:SetContentAlignment(7)
	chardesc:SetFont("nut_menufont")
	chardesc:SetText(LocalPlayer().character:GetVar("description", "No description available."))

	local changedesc = vgui.Create("DButton", panel)
	changedesc:DockMargin(0,0,0,4)
	changedesc:Dock(TOP)
	changedesc:SetFont("nut_menufont")
	changedesc:SetText("Change Description")
	changedesc.DoClick = function()
		netstream.Start("nut_RequestDesc", false)
		frame:Remove()
		LocalPlayer().vguiopen = false
	end

	local changedesc = vgui.Create("DButton", panel)
	changedesc:DockMargin(0,0,0,4)
	changedesc:Dock(TOP)
	changedesc:SetFont("nut_menufont")
	changedesc:SetText("Recognise Players..")
	changedesc.DoClick = function()
		local menu = DermaMenu()

		menu:AddOption("Recognise the player you are currenlty looking at.", function()
			LocalPlayer():ConCommand("say /recognise aim")
			frame:Remove()
			LocalPlayer().vguiopen = false
		end)

		menu:AddOption("Recognise all players within talking range.", function()
			LocalPlayer():ConCommand("say /recognise")
			frame:Remove()
			LocalPlayer().vguiopen = false
		end)

		menu:AddOption("Recognise all players within whispering range.", function()
			LocalPlayer():ConCommand("say /recognise whisper")
			frame:Remove()
			LocalPlayer().vguiopen = false
		end)

		menu:AddOption("Recognise all players within yelling range.", function()
			LocalPlayer():ConCommand("say /recognise yell")
			frame:Remove()
			LocalPlayer().vguiopen = false
		end)

		menu:Open()
		menu:SetParent(p)
	end

	local moneyinfopanel = vgui.Create("DPanel", panel)
	moneyinfopanel:DockMargin(0,0,0,4)
	moneyinfopanel:Dock(TOP)
	moneyinfopanel:SetTall(40)

	local moneytext = "You have "..LocalPlayer():GetMoney().." Caps"

	local count = 0
	for k, v in pairs(SCHEMA:GetCurrencyIndex()) do
		if (LocalPlayer():getCurrency(k) > 0) then
			if (count == 0) then
				count = 1

				moneytext = moneytext.." as well as "..SCHEMA:getCurrencyName(k, LocalPlayer():getCurrency(k))
			else
				moneytext = moneytext.." and, "..SCHEMA:getCurrencyName(k, LocalPlayer():getCurrency(k))
			end
		end
	end

	moneytext = moneytext.."."

	local moneyinfo = vgui.Create("DLabel", moneyinfopanel)
	moneyinfo:DockMargin(6,6,6,6)
	moneyinfo:Dock(FILL)
	moneyinfo:SetWrap(true)
	moneyinfo:SetContentAlignment(7)
	moneyinfo:SetFont("nut_menufont")
	moneyinfo:SetText(moneytext)

	local givemoney = vgui.Create("DButton", panel)
	givemoney:DockMargin(0,0,0,4)
	givemoney:Dock(TOP)
	givemoney:SetText("Give Money")
	givemoney:SetFont("nut_menufont")
	givemoney.DoClick = function(p)
		local menu = DermaMenu()
		menu:AddOption("Caps", function()
			Derma_StringRequest("Give Caps", "How many Caps would you like to give?", "", function(text)
				LocalPlayer():ConCommand("say /givemoney".." "..text)
				frame:Remove()
				LocalPlayer().vguiopen = false
			end) 
		end)
		for k, v in pairs(SCHEMA:GetCurrencyIndex()) do
			menu:AddOption(v[2], function()
				Derma_StringRequest("Give "..v[2], "How much "..v[2].." would you like to give?", "", function(text)
					LocalPlayer():ConCommand("say /give"..v[3].." "..text)
					frame:Remove()
					LocalPlayer().vguiopen = false
				end) 
			end)
		end

		menu:Open()
		menu:SetParent(p)
	end

	local dropmoney = vgui.Create("DButton", panel)
	dropmoney:DockMargin(0,0,0,4)
	dropmoney:Dock(TOP)
	dropmoney:SetText("Drop Money")
	dropmoney:SetFont("nut_menufont")
	dropmoney.DoClick = function(p)
		local menu = DermaMenu()
		menu:AddOption("Caps", function()
			Derma_StringRequest("Drop Caps", "How many Caps would you like to drop?", "", function(text)
				LocalPlayer():ConCommand("say /dropmoney".." "..text)
				frame:Remove()
				LocalPlayer().vguiopen = false
			end) 
		end)
		for k, v in pairs(SCHEMA:GetCurrencyIndex()) do
			menu:AddOption(v[2], function()
				Derma_StringRequest("Drop "..v[2], "How much "..v[2].." would you like to drop?", "", function(text)
					LocalPlayer():ConCommand("say /drop"..v[3].." "..text)
					frame:Remove()
					LocalPlayer().vguiopen = false
				end) 
			end)
		end

		menu:Open()
		menu:SetParent(p)
	end

	local quickact = vgui.Create("DButton", panel)
	quickact:DockMargin(0,0,0,4)
	quickact:Dock(TOP)
	quickact:SetText("Perform Animation")
	quickact:SetFont("nut_menufont")
	quickact.DoClick = function(pnl)
		local class = nut.anim.GetClass(string.lower(LocalPlayer():GetModel()))
		local list = SCHEMA.sequences[class]
		local menu = DermaMenu()
		if (list) then
			for uid, actdata in SortedPairs(list) do
				if (list) then
					menu:AddOption((actdata.name or uid), function()
						LocalPlayer():ConCommand(Format("say /act%s", uid))
						frame:Remove()
						LocalPlayer().vguiopen = false
					end)
				end
			end
		end
		menu:Open()
		menu:SetParent(pnl)
	end

	local quickreset = vgui.Create("DButton", panel)
	quickreset:DockMargin(0,0,0,4)
	quickreset:Dock(TOP)
	quickreset:SetText("Reset Animation")
	quickreset:SetFont("nut_menufont")
	quickreset.DoClick = function()
		LocalPlayer():ConCommand("say /actstand")
		frame:Remove()
		LocalPlayer().vguiopen = false
	end

	local quickflag = vgui.Create("DButton", panel)
	quickflag:DockMargin(0,0,0,4)
	quickflag:Dock(TOP)
	quickflag:SetText("Flag Up")
	quickflag:SetFont("nut_menufont")
	quickflag.DoClick = function(pnl)
		local menu = DermaMenu()
			for k, v in pairs(SCHEMA.factions) do
				menu:AddOption(v.name, function()
					LocalPlayer():ConCommand("say /flagup "..k)
					frame:Remove()
					LocalPlayer().vguiopen = false
				end)
			end
		menu:Open()
		menu:SetParent(pnl)
	end

	local quickflagdown = vgui.Create("DButton", panel)
	quickflagdown:DockMargin(0,0,0,4)
	quickflagdown:Dock(TOP)
	quickflagdown:SetText("Flag Down")
	quickflagdown:SetFont("nut_menufont")
	quickflagdown.DoClick = function()
		LocalPlayer():ConCommand("say /flagdown")
		frame:Remove()
		LocalPlayer().vguiopen = false
	end

	local viewmedical = vgui.Create("DButton", panel)
	viewmedical:DockMargin(0,0,0,4)
	viewmedical:Dock(TOP)
	viewmedical:SetText("View Medical Info")
	viewmedical:SetFont("nut_menufont")
	viewmedical.DoClick = function()
		SCHEMA:OpenMedicalInfo()
		frame:Remove()
		LocalPlayer().vguiopen = false
	end

	local thirdPersonPanel = vgui.Create("DPanel", panel)
	thirdPersonPanel:Dock(TOP)

	local label = thirdPersonPanel:Add("DLabel")
	label:Dock(TOP)
	label:SetText("Third Person Settings")
	label:SetFont("nut_menufont")
	label:SetTextColor(Color(233, 233, 233))
	label:SizeToContents()
	label:SetContentAlignment(5)
	--label:SetExpensiveShadow(2, Color(0, 0, 0))

	local category = thirdPersonPanel:Add("DPanel")
	category:Dock(TOP)
	category:DockPadding(10, 5, 0, 5)
	category:DockMargin(0, 5, 0, 5)
	category:SetTall(110)
	category:SetDrawBackground(false)

	local distance = category:Add("DNumSlider")
	distance:Dock(TOP)
	distance:SetText( "View Distance" )   -- Set the text above the slider
	--distance.Label:SetTextColor(Color(22, 22, 22))
	distance:SetMin( 0 )                  -- Set the minimum number you can slide to
	distance:SetMax(100)                -- Set the maximum number you can slide to
	distance:SetDecimals( 0 )             -- Decimal places - zero for whole number
	distance:SetTall( 25 )             -- Decimal places - zero for whole number
	distance:SetValue(LocalPlayer():GetThirdPersonConfig("distance"))

	function distance:OnValueChanged( val )
		local val = self:GetValue()
		LocalPlayer():SetThirdPersonConfig("distance", val)
	end

	local sensitive = category:Add("DNumSlider")
	sensitive:Dock(TOP)
	sensitive:SetText( "Mouse Sensitive" )   -- Set the text above the slider
	--sensitive.Label:SetTextColor(Color(22, 22, 22))
	sensitive:SetMin( 0 )                  -- Set the minimum number you can slide to
	sensitive:SetMax( 1 )                -- Set the maximum number you can slide to
	sensitive:SetDecimals( 2 )             -- Decimal places - zero for whole number
	sensitive:SetTall( 25 )             -- Decimal places - zero for whole number
	sensitive:SetValue(LocalPlayer():GetThirdPersonConfig("sensitive"))

	function sensitive:OnValueChanged( val )
		local val = self:GetValue()
		LocalPlayer():SetThirdPersonConfig("sensitive", val)
	end

	local changedir = category:Add("DCheckBoxLabel")
	changedir:Dock(TOP)
	changedir:SetText( "Left Chasecam" )   -- Set the text above the slider
	--changedir.Label:SetTextColor(Color(22, 22, 22))
	changedir:SetTall( 25 )             -- Decimal places - zero for whole number
	changedir:DockMargin(0, 7, 0, 0)
	changedir:SetValue(LocalPlayer():GetThirdPersonConfig("changedir"))

	function changedir:OnChange( val )
		LocalPlayer():SetThirdPersonConfig("changedir", val)
	end

	local classic = category:Add("DCheckBoxLabel")
	classic:Dock(TOP)
	classic:SetText( "Classic" )   -- Set the text above the slider
	--classic.Label:SetTextColor(Color(22, 22, 22))
	classic:SetTall( 25 )             -- Decimal places - zero for whole number
	classic:SetValue(LocalPlayer():GetThirdPersonConfig("classic"))

	function classic:OnChange(val)
		LocalPlayer():SetThirdPersonConfig("classic", val)
	end

	thirdPersonPanel:SetTall(256)
end)

function SCHEMA:OpenMedicalInfo(target, medinfo)
	if (!target and !medinfo) then
		target = LocalPlayer()
		medinfo = von.deserialize(LocalPlayer():GetNetVar("MedicalData"))
	end

	LocalPlayer().vguiopen = true

	local frame = vgui.Create("DFrame")
	frame:SetSize(400, 364)
	frame:Center()
	frame:SetPos(frame:GetPos(), ScrH()*0.2)
	frame:SetTitle(target:Nick().." - Medical Info")
	frame:MakePopup()
	frame.OnClose = function()
		LocalPlayer().vguiopen = false
	end

	local panel = vgui.Create("DPanel", frame)
	panel:Dock(FILL)

	for k, hitgroup in ipairs(medinfo) do
		local hit = vgui.Create("DPanel", panel)
		hit:DockMargin(0,0,0,-1)
		hit:Dock(TOP)
		hit:SetTall(48)

		local medicalText = vgui.Create("DLabel", hit)
		medicalText:DockMargin(2,2,2,2)
		medicalText:Dock(FILL)
		medicalText:SetContentAlignment(7)
		medicalText:SetWrap(true)

		local medtext = SCHEMA:GetMedicalEnums()[k].." - "..hitgroup.health.."%"

		if (hitgroup.health > 75) then
			medtext = medtext.."\n".."Healthy"
		else
			medtext = medtext.."\n".."Hurt"
		end

		for k, v in pairs(hitgroup.conditions) do
			medtext = medtext..", "..SCHEMA:GetMedicalCondition(k).name
		end

		medicalText:SetText(medtext)
	end
end

netstream.Hook("nut_OpenCondition", function(data)
	SCHEMA:OpenMedicalInfo(data.target, data.medinfo)
end)

concommand.Add("testmedical", function()
	SCHEMA:OpenMedicalInfo()
end)
