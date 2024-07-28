local currencyIndex = {}
currencyIndex[0] = {"Caps", "Caps"}
currencyIndex[CUR_NCR] = {"NCR Dollars", "NCR Dollars"}
currencyIndex[CUR_CLD] = {"Legion Denarii", "Legion Denarius"}
currencyIndex[CUR_CLA] = {"Legion Aureuii", "Legion Aureus"}

local PANEL = {}
	function PANEL:Init()
		self:SetPos(ScrW() * (nut.config.menuWidth + 0.375) - 195, ScrH() * (0.125 + nut.config.menuHeight * 0.1))
		self:SetSize(200, 100)
		self:Dock(NODOCK)
		local label = vgui.Create("DLabel", self)
		local curSelection1 = vgui.Create("DComboBox", self)
		local curSelection2 = vgui.Create("DComboBox", self)
		local textEntry1 = vgui.Create("DTextEntry", self)
		local button = vgui.Create("SButton", self)
		
		label:SetSize(200, 20)
		label:SetPos(4, 2)
		label:SetTextColor(SCHEMA:GetPBColor())
		label:SetFont("Monofonto24")
		label:SetText("Currency Conversion")
		curSelection1:SetSize(100, 20)
		curSelection1:SetPos(4, 29)
		curSelection1:SetTextColor(Color(0, 0, 0, 255))
		textEntry1:SetSize(100, 20)
		textEntry1:SetPos(4, 49)
		textEntry1:SetNumeric(true)
		textEntry1:SetValue(0)
		curSelection2:SetSize(100, 20)
		curSelection2:SetPos(4, 69)
		curSelection2:SetTextColor(Color(0, 0, 0, 255))
		button:SetSize(92, 40)
		button:SetPos(104, 35)
		button:SetFont("Monofonto24")
		button:SetText("Convert")
		button:SetContentAlignment(5)
		
		for k,v in pairs(currencyIndex) do
			curSelection1:AddChoice(v[1])
			curSelection2:AddChoice(v[1])
		end
		curSelection1:ChooseOptionID(1)
		curSelection2:ChooseOptionID(2)
		
		textEntry1.OnValueChange = function(self, val)
			local type = curSelection1:GetSelectedID() - 1
			if tonumber(val) < 0 then self:SetValue(0) return false end
			if type == 0 then
				if not LocalPlayer():CanAfford(tonumber(val)) then
					--self:SetValue(LocalPlayer():GetMoney())
					return false
				end
			else
				if not LocalPlayer():canTakeCurrency(type, tonumber(val)) then
					--self:SetValue(LocalPlayer():getCurrency(type))
					return false
				end
			end
		end
		
		button.DoClick = function(self)
			local indexOne = curSelection1:GetSelectedID() - 1
			local indexTwo = curSelection2:GetSelectedID() - 1
			local val = tonumber(textEntry1:GetValue())
			
			local amt1, amt2
			if indexOne == 0 then
				if not LocalPlayer():CanAfford(val) then
					textEntry1:SetValue(LocalPlayer:GetMoney())
					return
				end
			else
				if not LocalPlayer():canTakeCurrency(indexOne, val) then
					textEntry1:SetValue(LocalPlayer():getCurrency(indexOne))
					return
				end
			end
			
			local data = {indexOne, indexTwo, val}
			netstream.Start("nut_ConvertCurrency", data)
		end
		
		self:MakePopup()
	end
	
	function PANEL:IsActive()
		if self:HasFocus() then return true end
		for k,v in pairs(self:GetChildren()) do
			if v:HasFocus() then
				return true
			end
		end
		return false
	end
	
	local fadeToLeft = Material("forp/uistuff/fade_to_left.png", "noclamp smooth")
	local fadeToRight = Material("forp/uistuff/fade_to_right.png", "noclamp smooth")
	local fadeToTop = Material("forp/uistuff/fade_to_top.png", "noclamp smooth")
	local fadeToBottom = Material("forp/uistuff/fade_to_bottom.png", "noclamp smooth")
	function PANEL:Paint(w, h)
		-- aaayyyyy	
		surface.SetDrawColor(0, 0, 0, 200)
		surface.DrawRect(0, 0, w, h)

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
	end

	function PANEL:Think()
	end
vgui.Register("nut_CurrencyConversion", PANEL, "EditablePanel")