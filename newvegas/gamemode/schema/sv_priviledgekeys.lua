SCHEMA.KeyTable = SCHEMA.KeyTable or {}

function SCHEMA:GenerateKeys(count)
	local keys = {}
	for i = 1, count do
		table.insert(keys, util.Base64Encode(tostring(math.random(10000000,9999999999))))
	end
	return keys
end

function SCHEMA:DecodeKeys(keys)
	return string.Explode("~", keys)
end

function SCHEMA:EncodeKeys(keys)
	return string.Implode("~", keys)
end

function SCHEMA:RemoveKey(key)
	local index
	for l, v in pairs(SCHEMA.KeyTable) do
		for l2, v2 in pairs(v.k) do
			if (key == v2) then
				index = l
				table.remove(SCHEMA.KeyTable[l].k, l2)
				file.Write(SCHEMA.KeyTable[index].f, SCHEMA:EncodeKeys(SCHEMA.KeyTable[l].k))
			end
		end
	end
end

function SCHEMA:KeyExists(key)
	for l, v in pairs(SCHEMA.KeyTable) do
		for l2, v2 in pairs(v.k) do
			if (key == v2) then
				return true
			end
		end
	end
end

function SCHEMA:GetKeyIndex(key)
	for l, v in pairs(SCHEMA.KeyTable) do
		for l2, v2 in pairs(v.k) do
			if (key == v2) then
				return l
			end
		end
	end
end

function SCHEMA.RegisterKey(key, onrun, count)
	local count = count or 100
	local filename = key.."_key.txt"

	if (file.Exists(filename, "DATA")) then
		SCHEMA.KeyTable[key] = {f = filename, r = onrun, k = SCHEMA:DecodeKeys(file.Read(filename))}
	else
		local keys = SCHEMA:GenerateKeys(count)
		SCHEMA.KeyTable[key] = {f = filename, r = onrun, k = keys}
		file.Write(filename, SCHEMA:EncodeKeys(keys))
	end
end

function SCHEMA:RedeemKey(key, client)
	local index = SCHEMA:GetKeyIndex(key)
	if (SCHEMA:KeyExists(key)) then
		SCHEMA:RemoveKey(key)
		SCHEMA.KeyTable[index].r(client)
		client:Notify("Successfully redeemed key.")
	else
		client:Notify("Invalid key.")
	end
end