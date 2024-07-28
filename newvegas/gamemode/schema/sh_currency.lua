CUR_CAP = 0
CUR_NCR = 1
CUR_CLD = 2
CUR_CLA = 3
CUR_SCRAP = 4

local currencyIndex = {}
currencyIndex[CUR_NCR] = {"NCR Dollars", "NCR Dollar", "ncr", 0.4}
currencyIndex[CUR_CLD] = {"Legion Denarii", "Legion Denarius", "cld", 4}
currencyIndex[CUR_CLA] = {"Legion Aureuii", "Legion Aureus", "cla", 100}
currencyIndex[CUR_SCRAP] = {"Scrap Metal", "Pieces of Scrap Metal", "scrap"}

function SCHEMA:GetCurrencyIndex()
	return currencyIndex
end

function SCHEMA:getCurrencyName(type, amount)
	if amount > 1 then
		return string.Comma(amount).." "..currencyIndex[type][2]
	else
		return string.Comma(amount).." "..currencyIndex[type][1]
	end
end

for currenum, currtable in pairs(currencyIndex) do 
	nut.command.Register({
		syntax = "<number amount>",
		onRun = function(client, arguments)
			local amount = math.Round(tonumber(arguments[1]))
			if (!amount or amount <= 0) then
				return client:Notify("Invalid Arguments")
			end
			
			if (!client:canTakeCurrency(currenum, amount)) then
				nut.util.Notify("You do not have enough "..currtable[2].." to do that.", client)
				return
			end
	
			local data = {}
				data.start = client:GetShootPos()
				data.endpos = data.start + client:GetAimVector()*96
				data.filter = client
			local trace = util.TraceLine(data)
			local pos = trace.HitPos
			local angle = trace.HitAngle

			client:takeCurrency(currenum, amount)
			SCHEMA:spawnCurrency(pos, Angle(0,0,0), amount, currenum)
		end
	}, "drop"..currtable[3])

	nut.command.Register({
		syntax = "<number amount>",
		onRun = function(client, arguments)
			local amount = math.Round(tonumber(arguments[1]))
			if (!amount or amount <= 0) then
				nut.util.Notify("You do not have enough "..currtable[2].." to do that.", client)
				return L("invalidArg", client, 2)
			end
	
			if (!client:canTakeCurrency(currenum, amount)) then
				nut.util.Notify("You do not have enough "..currtable[2].." to do that.", client)
				return
			end
	
			local data = {}
				data.start = client:GetShootPos()
				data.endpos = data.start + client:GetAimVector()*96
				data.filter = client
			local trace = util.TraceLine(data)
			local target = trace.Entity
		
			if (target and target:IsPlayer()) then
				client:takeCurrency(currenum, amount)
				target:giveCurrency(currenum, amount)
				if amount > 1 then
					nut.util.Notify("You have given "..amount.." "..currtable[2].." to "..target:Nick(), client)
					nut.util.Notify("You have received "..amount.." "..currtable[2].." from "..client:Nick(), target)
				else
					nut.util.Notify("You have given "..amount.." "..currtable[1].." to "..target:Nick(), client)
					nut.util.Notify("You have received "..amount.." "..currtable[1].." from "..client:Nick(), target)
				end
			end
		end
	},"give"..currtable[3])

	nut.command.Register({
		adminOnly = true,
		syntax = "<string target> <number amount>",
		onRun = function(client, arguments)
			if #arguments != 2 then
				nut.util.Notify("You need to specify an amount.", client)
				return L("invalidArg", client, 2)
			end

			local amount = math.Round(tonumber(arguments[2]))
			if (!amount or amount <= 0) then
				nut.util.Notify("You need to specify an amount.", client)
				return L("invalidArg", client, 2)
			end

			local target = nut.command.FindPlayer(client, arguments[1])

			if (target and target:IsPlayer()) then
				target:setCurrency(currenum, amount)
				nut.util.Notify("You have given set "..target:Nick().."'s".." "..currtable[2].." to "..amount, client)
			end
		end
	},"charset"..currtable[3])
end

local playerMeta = FindMetaTable("Player")

function playerMeta:getCurrency(type)
	return self.character:GetData("currency_"..type, 0)
end

function playerMeta:canTakeCurrency(type, amount)
	return (amount < self.character:GetData("currency_"..type, 0))
end

if (SERVER) then
	function SCHEMA:onPickupCurrency(client, currency)
		if (currency and currency:IsValid()) then
			local type, amount = currency:GetType(), currency:GetAmount()

			client:SendSound("fosounds/fix/ui_items_generic_up_0"..math.random(1, 4)..".mp3")
			client:giveCurrency(type, amount)
			nut.util.Notify("You have picked up: "..SCHEMA:getCurrencyName(type, amount), client)
		end
	end

	function SCHEMA:spawnCurrency(pos, angle, amount, type)
		if (!pos) then
			--print("[Nutscript] Can't create currency entity: Invalid Position")
		elseif (!amount or amount < 0) then
			--print("[Nutscript] Can't create currency entity: Invalid Amount of money")
		end

		local money = ents.Create("forp_currency")
		money:SetPos(pos)
		money:SetAmount(math.Round(math.abs(amount)))
		money:SetType(type)
		money:SetAngles(angle or Angle(0, 0, 0))
		money:Spawn()
		money:Activate()

		return money
	end

	function playerMeta:giveCurrency(type, amount)
		self:SendNotification("You\'ve gained " .. amount .. " " .. currencyIndex[type][1], "", "", "fosounds/fix/ui_items_bottlecaps_up_0"..math.random(1,4)..".mp3", 15, 0)
		self.character:SetData("currency_"..type, amount + self.character:GetData("currency_"..type))
	end

	function playerMeta:takeCurrency(type, amount)
		if self:canTakeCurrency(type, amount) then
			self:SendNotification("You\'ve lost " .. amount .. " " .. currencyIndex[type][1], "", "", "fosounds/fix/ui_items_bottlecaps_up_0"..math.random(1,4)..".mp3", 12, 0)
			self.character:SetData("currency_"..type, self.character:GetData("currency_"..type) - amount)
		end
	end

	function playerMeta:setCurrency(type, amount)
		self.character:SetData("currency_"..type, amount)
	end

	function playerMeta:setupCurrencies()
		for i = 1, #currencyIndex do
			self.character:SetData("currency_"..i, self.character:GetData("currency_"..i) or 0)
		end
	end
	
	netstream.Hook("nut_ConvertCurrency", function(client, data)
		local type1 = data[1]
		local type2 = data[2]
		local amt = math.abs(data[3])
		
		if type1 == type2 then return end
		if type1 == 0 then
			if not client:CanAfford(amt) then return end
			client:TakeMoney(amt)
			client:giveCurrency(type2, math.floor(amt / currencyIndex[type2][4]))
		else
			if not client:canTakeCurrency(type1, amt) then return end
			client:takeCurrency(type1, amt)
			if type2 == 0 then
				client:GiveMoney(math.floor(amt * currencyIndex[type1][4]))
			else
				client:GiveMoney(math.floor(amt / currencyIndex[type2][4] * currencyIndex[type1][4]))
			end
		end
	end)
end