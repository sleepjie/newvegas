SCHEMA.Quality = {}
SCHEMA.Quality[3] = {name = "Rare", color = Color(255, 93, 0)}
SCHEMA.Quality[4] = {name = "Epic", color = Color(0, 206, 206)}
SCHEMA.Quality[5] = {name = "Legendary", color = Color(255, 30, 30)}
SCHEMA.Quality[6] = {name = "One Of A Kind", color = Color(0, 127, 31)}

SCHEMA.Lootcrates = {}
SCHEMA.Lootcrates.Series = {}

SCHEMA.Lootcrates.Series["chems"] = {
	meta = {},
	content = {}
}
SCHEMA.Lootcrates.Series["chems"].meta.AbundanceOdds = {}
SCHEMA.Lootcrates.Series["chems"].meta.AbundanceOdds[1] = 0
SCHEMA.Lootcrates.Series["chems"].meta.AbundanceOdds[2] = 500
SCHEMA.Lootcrates.Series["chems"].meta.Randomness = {
	{prepend = "Jumpy", effectmul = 1.1},
	{prepend = "Weak", effectmul = 0.6},
	{prepend = "Potent", effectmul = 1.2},
	{prepend = "Strong", effectmul = 1.25},
	{prepend = "Weakened", effectmul = 0.9},
	{prepend = "Spent", effectmul = 0.2},
	{prepend = "Powerful", effectmul = 1.35},
	{prepend = "Concentrate", effectmul = 1.8},
	{prepend = "Vigorous", effectmul = 1.6},
	{prepend = "Wicked", effectmul = 2}
}

SCHEMA.Lootcrates.Series["crafting"] = {
	meta = {},
	content = {}
}
SCHEMA.Lootcrates.Series["crafting"].meta.AbundanceOdds = {}
SCHEMA.Lootcrates.Series["crafting"].meta.AbundanceOdds[1] = 0

SCHEMA.Lootcrates.Series["food"] = {
	meta = {},
	content = {}
}
SCHEMA.Lootcrates.Series["food"].meta.AbundanceOdds = {}
SCHEMA.Lootcrates.Series["food"].meta.AbundanceOdds[1] = 0
SCHEMA.Lootcrates.Series["food"].meta.Randomness = {
	{prepend = "Repulsive", effectmul = 0.1},
	{prepend = "Gross", effectmul = 0.5},
	{prepend = "Rotten", effectmul = 0.3},
	{prepend = "Stale", effectmul = 0.9},
	{prepend = "Well-Made", effectmul = 1.3},
	{prepend = "Tasty", effectmul = 1.2},
	{prepend = "Delicous", effectmul = 1.5}
}

SCHEMA.Lootcrates.Series["clothes"] = {
	meta = {},
	content = {}
}
SCHEMA.Lootcrates.Series["clothes"].meta.AbundanceOdds = {}
SCHEMA.Lootcrates.Series["clothes"].meta.AbundanceOdds[1] = 0
SCHEMA.Lootcrates.Series["clothes"].meta.AbundanceOdds[2] = 700
SCHEMA.Lootcrates.Series["clothes"].meta.AbundanceOdds[3] = 800
SCHEMA.Lootcrates.Series["clothes"].meta.AbundanceOdds[4] = 920
SCHEMA.Lootcrates.Series["clothes"].meta.AbundanceOdds[5] = 980

SCHEMA.Lootcrates.Series["fromashes"] = {
	meta = {},
	content = {}
}
SCHEMA.Lootcrates.Series["fromashes"].meta.AbundanceOdds = {}
SCHEMA.Lootcrates.Series["fromashes"].meta.AbundanceOdds[1] = 0
SCHEMA.Lootcrates.Series["fromashes"].meta.AbundanceOdds[2] = 840
SCHEMA.Lootcrates.Series["fromashes"].meta.AbundanceOdds[3] = 965
SCHEMA.Lootcrates.Series["fromashes"].meta.AbundanceOdds[4] = 981
SCHEMA.Lootcrates.Series["fromashes"].meta.AbundanceOdds[5] = 989

function SCHEMA:AddLootcrateItem(series, itemdata, abundance) -- pass itemdata as a string that points to a unique ID to have a generic item inserted into the DB
	--print(series, itemdata, abundance)

	if (type(itemdata) == "string") then
		if !SCHEMA.Lootcrates.Series[series].content[abundance] then
			SCHEMA.Lootcrates.Series[series].content[abundance]= {}
		end

		SCHEMA.Lootcrates.Series[series].content[abundance][itemdata] = itemdata
	else
		if !SCHEMA.Lootcrates.Series[series].content[abundance] then
			SCHEMA.Lootcrates.Series[series].content[abundance]= {}
		end

		SCHEMA.Lootcrates.Series[series].content[abundance][itemdata.uniqueID] = {uniqueID = itemdata.uniqueID, data = itemdata.data}
	end
end

function SCHEMA:GiveLunchboxItem(series, quality, condition, client)
	local item = table.Random(SCHEMA.Lootcrates.Series[series].content[quality])
	local itemTable

	if (type(item) == "table" and item.uniqueID) then
		itemTable = nut.item.Get(item.uniqueID)
	else
		itemTable = nut.item.Get(item)
	end

	local data = itemTable.data
	data.custom = {}

	if (type(item) == "table" and item.data) then
		data = table.Merge(data, item.data)
	end

	if (math.random(1, 4) == 4) then
		if (SCHEMA.Lootcrates.Series[series].meta.Randomness) then
			local random = table.Random(SCHEMA.Lootcrates.Series[series].meta.Randomness)
			data.custom.name = random.prepend.." "..itemTable.name
		end
	end

	if (math.random(1, 10) == 10) then
		local quality = math.random(3, 6)

		if data.custom.name then
			data.custom.name = SCHEMA.Quality[quality].name.." "..data.custom.name
		else
			data.custom.name = SCHEMA.Quality[quality].name.." "..itemTable.name
		end
		data.custom.color = SCHEMA.Quality[quality].color
	end

	data.custom.condition = (condition * 0.01)

	client:UpdateInv(itemTable.uniqueID, 1, data, true)
end

function SCHEMA:OpenLunchbox(series, client)
	if (SCHEMA.Lootcrates.Series[series]) then
		math.random(((13213216 * os.time()^2) - 50)) -- never show this to anyone
		local odds = math.random(0,1000)
		local cond = math.random(35,100)
		local quality = 1
		print(odds)

		if (#SCHEMA.Lootcrates.Series[series].meta.AbundanceOdds != 1) then
			for i = 1, #SCHEMA.Lootcrates.Series[series].meta.AbundanceOdds do
				if SCHEMA.Lootcrates.Series[series].meta.AbundanceOdds[i] > odds then
					if (SCHEMA.Lootcrates.Series[series].meta.AbundanceOdds[i+1]) and SCHEMA.Lootcrates.Series[series].meta.AbundanceOdds[i] < odds then
						print(quality)
						quality = i
					end
				end
			end
		end

		math.random(os.time())
		SCHEMA:GiveLunchboxItem(series, quality, cond, client)
	end
end