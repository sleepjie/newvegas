SCHEMA.factions = {}
SCHEMA.factions["N"] = {name = "New California Republic", color = "245 145 0", rank = true, firstRank = "Pvt.", defaultSpawn = 4}
SCHEMA.factions["B"] = {name = "Brotherhood of Steel", color = "100 0 0", rank = true, firstRank = "Initiate", defaultSpawn = 10}
SCHEMA.factions["C"] = {name = "Caesars Legion", color = "150 0 0", rank = true, firstRank = "Recruit", defaultSpawn = 9}

nut.command.Register({
	adminOnly = false,
	allowDead = true,
	syntax = "<string flag>",
	onRun = function(client, arguments)
		if !(arguments[1]) then
			client:Notify("You have not specified a flag.")
		end
	
		client:FlagUp(arguments[1])
	end
}, "flagup")


nut.command.Register({
	adminOnly = false,
	allowDead = true,
	syntax = "<void>",
	onRun = function(client, arguments)
		client:FlagDown()
	end
}, "flagdown")

nut.command.Register({
	adminOnly = true,
	allowDead = true,
	syntax = "<string client name>  <string rank>",
	onRun = function(client, arguments)
		if !(arguments[1]) then
			client:Notify("You did not specify a rank.")
		end
		local target = nut.command.FindPlayer(client, arguments[1])
	
		target:SetRank(arguments[2])
	end
}, "setrank")

if (SERVER) then
	local playerMeta = FindMetaTable("Player")

	function playerMeta:FlagUp(flag)
		if (!flag) then
			return
		end

		local character = self.character

		local faction = SCHEMA.factions[flag]

		if (!faction) then
			self:Notify("Invalid faction.")
			return
		end

		local rank = nil
		if (faction.rank) then
			rank = character:GetData("rank", faction.firstRank)
		end

		if (character:GetData("flagged", false)) then
			self:Notify("You are already flagged up.")
			return
		end

		if (!self:HasFlag(flag)) then
			self:Notify("You do not have the flag required.")
			return
		end

		if (rank) then
			local oldname = self:Name()
			character:SetData("oldname", oldname)
			character:SetData("flagged", flag)
			character:SetVar("charname", rank.." "..oldname)

			self:Notify("You are now flagged up as a member of "..faction.name)
		end

		local dispcolor = SCHEMA.factions[flag].color
		character:SetVar("DisplayColor", dispcolor, player.GetAll())
	end

	function playerMeta:FlagDown()
		local character = self.character
		if (character:GetData("flagged", false)) then
			character:SetVar("charname", character:GetData("oldname"))
			character:SetData("flagged", false)
			character:SetData("oldname", nil)
			character:SetVar("DisplayColor", 0, player.GetAll())

			self:Notify("You have flagged down.")
		else
			self:Notify("You are currently not flagged up.")
		end
	end

	-- Gets a players faction that they are currently flagged up as, returns false if they are not flagged up
	function playerMeta:GetFlaggedFaction()
		local character = self.character
		return character:GetData("flagged", false)
	end

	-- Sets a players rank
	function playerMeta:SetRank(rank)
		local character = self.character
		if (character:GetData("flagged", false)) then
			local oldname = character:GetData("oldname", self:Nick())
			character:SetData("rank", rank)
			character:SetVar("charname", rank.." "..oldname)
		else
			character:SetData("rank", rank)
		end

		self:Notify("Your rank has been set to "..rank)
	end

end

local tiers = {1,2,3,4}

for k, v in pairs(tiers) do
	nut.flag.Create(tostring(v), {
		desc = "Allows access to business menu and tier "..tostring(v).." goods.",
	})
end

nut.flag.Create("0", {
	desc = "Grants a player event manager permissions.",
})

nut.flag.Create("m", {
	desc = "Allows the purchase of medical supplies.",
})
nut.flag.Create("P", {
	desc = "Access to PAC3.",
})
function SCHEMA:PlayerCanSeeBusiness()
	return false
end