local playerMeta = FindMetaTable("Player")

SCHEMA.CategoryFlags = {}
SCHEMA.CategoryFlags["Throwable"] = {default = {cooldown = 21600, stock = 5}, flag = "2"}
SCHEMA.CategoryFlags["Miscellaneous"] = {default = {cooldown = 21600, stock = 5}, flag = "1"}
SCHEMA.CategoryFlags["Default"] = {default = {cooldown = 21600, stock = 5}, flag = "1"}
SCHEMA.CategoryFlags["Storage"] = {default = {cooldown = 21600, stock = 5}, flag = "2"}
SCHEMA.CategoryFlags["Communication"] = {default = {cooldown = 21600, stock = 5}, flag = "1"}
SCHEMA.CategoryFlags["Storage Options"] = {default = {cooldown = 21600, stock = 5}, flag = "2"}
SCHEMA.CategoryFlags["_Clothing"] = {default = {cooldown = 21600, stock = 5}, flag = "1"}
SCHEMA.CategoryFlags["_Weapons"] = {default = {cooldown = 21600, stock = 5}, flag = "1"}

SCHEMA.TradePreCache = SCHEMA.TradePreCache  or {}

-- trade table is a list of item unique id's that the player is capable of purchasing
function playerMeta:GetTradeTable()
	local trade = {}

	for uniqueID, item in pairs(nut.item.GetAll()) do
		local flag = nil

		if SCHEMA.CategoryFlags[item.category] and !item.flag then
			flag = SCHEMA.CategoryFlags[item.category].flag
		elseif item.flag then
			flag = item.flag
		else
			flag = SCHEMA.CategoryFlags["Default"].flag
		end

		flag = item.flag or flag

		if (self:HasFlag(flag)) then
			trade[uniqueID] = {data = {cooldown = 0, stock = 0}, uniqueid = item.uniqueID}
		end
	end

	trade = self:ProcessTradeTable(trade)

	return trade
end

function playerMeta:GetTradeDataByUniqueID(uniqueID)
	local TradeData = self.character:GetData("TradeData", false)

	if (TradeData) then
		if (TradeData[uniqueID]) then
			return TradeData[uniqueID]
		end
	else
		return false
	end
end

function playerMeta:GetTradeCooldownByUniqueID(uniqueID)
	local TradeData = self.character:GetData("TradeData", false)

	if (TradeData) then
		if (TradeData[uniqueID]) then
			return TradeData[uniqueID].cooldown
		end
	else
		return false
	end
end

function playerMeta:GetTradeStockByUniqueID(uniqueID)
	local TradeData = self.character:GetData("TradeData", false)

	if (TradeData) then
		if (TradeData[uniqueID]) then
			return TradeData[uniqueID].stock
		end
	else
		return false
	end
end

function playerMeta:WipeTradeData()
	self.character:SetData("TradeData", {})
end

function playerMeta:SetTradeStockByUniqueID(uniqueID, newStock)
	local TradeData = self.character:GetData("TradeData", {})
	local itemTable = nut.item.Get(uniqueid)

	if (TradeData) then
		if (TradeData[uniqueID]) then
			TradeData[uniqueID].stock = newStock
			self.character:GetData("TradeData", TradeData)
		else
			TradeData[uniqueID] = {}
			TradeData[uniqueID].stock = newStock
			TradeData[uniqueID].lastrefresh = os.time()
			self.character:GetData("TradeData", TradeData)
		end
	end
end

function playerMeta:SetTradeDataByUniqueID(uniqueID, newData)
	local TradeData = self.character:GetData("TradeData", {})

	if (TradeData) then
		TradeData[uniqueID] = newData
		TradeData[uniqueID].lastrefresh = os.time()
		self.character:SetData("TradeData", TradeData)
	end
end

function playerMeta:RefreshStock(uid)
	local item = nut.item.Get(uid)
	local masterData = self.character:GetData("TradeData", {})
	local tradeData = self:GetTradeDataByUniqueID(uid) or {lastrefresh = 0, cooldown = 0, stock = 0}
	local coolDown

	if SCHEMA.CategoryFlags[item.category] then
		coolDown = item.cooldown or SCHEMA.CategoryFlags[item.category].default.cooldown 
	else
		coolDown = item.cooldown or SCHEMA.CategoryFlags["Default"].default.cooldown
	end

	local nextRefresh = coolDown + tradeData.lastrefresh

	if (os.time() > nextRefresh) then
		local Stock
		if SCHEMA.CategoryFlags[item.category] then
			Stock = SCHEMA.CategoryFlags[item.category].default.stock
		else
			Stock = SCHEMA.CategoryFlags["Default"].default.stock
		end

		Stock = item.defaultStock or Stock

		tradeData.lastrefresh = os.time()
		tradeData.stock = Stock
		tradeData.cooldown = coolDown
		masterData[uid] = tradeData

		self.character:SetData("TradeData", masterData)
	end

	return tradeData
end

function SCHEMA:SetupTradeData(uid)
	local item = nut.item.Get(uid)
	local CoolDown, Stock

	if (!item) then
		return
	end

	if SCHEMA.CategoryFlags[item.category] then
		CoolDown = item.cooldown or SCHEMA.CategoryFlags[item.category].default.cooldown
		Stock = item.defaultStock or SCHEMA.CategoryFlags[item.category].default.stock
	else
		CoolDown = item.cooldown or SCHEMA.CategoryFlags["Default"].default.cooldown
		Stock = item.defaultStock or SCHEMA.CategoryFlags["Default"].default.stock
	end

	local data = {}
		data.cooldown = CoolDown
		data.stock = Stock
		data.lastrefresh = os.time()
	return data
end

function playerMeta:ProcessTradeTable(trade)
	for uid, TradeData in pairs(trade) do
		local itemTable = nut.item.Get(uid)
		if (self:GetTradeDataByUniqueID(uid)) then
			--print("refresh")
			trade[uid].data = self:RefreshStock(uid)
		else
			--print("setup")
			trade[uid].data = SCHEMA:SetupTradeData(uid)
			self:SetTradeDataByUniqueID(uid, trade[uid].data)
		end
	end

	return trade
end

netstream.Hook("nut_RequestTradeInfo", function(client)
	--if (!SCHEMA.TradePreCache[client]) then
	--	SCHEMA.TradePreCache[client] = {}
	--end
	if (client:GetTradeTable() == {}) then
		netstream.Start(client, "nut_RequestTradeInfo", false)
	else
		--if (SCHEMA.TradePreCache[client] != client:GetTradeTable()) then
		--	netstream.Start(client, "nut_RequestTradeInfo", "usecache")
		--else
		--	SCHEMA.TradePreCache[client] = client:GetTradeTable()
			netstream.Start(client, "nut_RequestTradeInfo", client:GetTradeTable())
		--end
	end
end)

netstream.Hook("nut_NewBuyItem", function(client, data)
	local uniqueID = data.uniqueID
	local halfcond = data.halfcond

	if (!nut.config.businessEnabled) then
		return
	end
	
	local itemTable = nut.item.Get(uniqueID)

	if (!itemTable) then
		return nut.util.Notify("This item is not valid!", client)
	end

	if (itemTable:ShouldShowOnBusiness(client) == false) then
		return nut.util.Notify("You are not allowed to buy this item.", client)
	end

	local price = itemTable.price

	if (halfcond) then
		price = price/2
	end

	if (!client:HasInvSpace(itemTable)) then
		return nut.util.Notify(nut.lang.Get("no_invspace"), client)
	end

	if (client:GetTradeStockByUniqueID(uniqueID) == 0) then
		client:Notify("Item is out of stock.")
		return
	end

	local data = itemTable.data

	if (itemTable.GetBusinessData) then
		data = itemTable:GetBusinessData(client, data)
	end

	if (!client:HasFlag(itemTable.flag)) then
		return
	end

	if (halfcond) then
		data.custom = {}
		data.custom.condition = 0.5
	end
	
	if (client:CanAfford(price)) then
		local stock = client:GetTradeStockByUniqueID(uniqueID) or 5
		client:SetTradeStockByUniqueID(uniqueID, math.Clamp(stock - 1, 0, 100))
		client:UpdateInv(uniqueID, 1, data, true)
		client:TakeMoney(price)

		nut.util.Notify(nut.lang.Get("purchased_for", itemTable.name, nut.currency.GetName(price)), client)
	else
		nut.util.Notify(nut.lang.Get("no_afford"), client)
	end

	hook.Run("PlayerBoughtItem", client, itemTable)

	if (itemTable.OnBought) then
		itemTable:OnBought(client)
	end
end)