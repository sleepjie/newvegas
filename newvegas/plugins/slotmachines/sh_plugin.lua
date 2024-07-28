local PLUGIN = PLUGIN

PLUGIN.name = "Slot Machines"
PLUGIN.author = "thor"
PLUGIN.desc = "Allows slot machines to be saved and loaded."

function PLUGIN:SaveData()
	local slots = {}
	
	for k,v in ipairs(ents.FindByClass("forp_slots")) do
		slots[#slots + 1] = {v:GetPos(), v:GetAngles(), v:GetBetAmount(), v.moneyEarned, v.ownerList}
	end
	
	nut.util.WriteTable("slotmachines", slots)
end

function PLUGIN:LoadData()
	local slots = nut.util.ReadTable("slotmachines")
	
	for k,v in ipairs(slots) do
		local e = ents.Create("forp_slots")
		e:SetPos(v[1])
		e:SetAngles(v[2])
		e:SetBetAmount(v[3])
		e.moneyEarned = v[4]
		e.ownerList = v[5]
		e:Spawn()
		e:Activate()
	end
end

nut.command.Register({
	adminOnly = true,
	syntax = "<string target>",
	onRun = function(client, arguments)
		local data = {}
			data.start = client:GetShootPos()
			data.endpos = data.start + client:GetAimVector()*512
			data.filter = client
		local target = util.TraceLine(data).Entity
		if target and (target:GetClass() == "forp_slots") then
			local ply = nut.util.FindPlayer(arguments[1])
			if IsValid(ply) then
				target:AddOwner(ply)
				PLUGIN:SaveData()
				nut.util.Notify("Added owner (" .. ply:Nick() .. ")", client)
			else
				nut.util.Notify("No player found.", client)
			end
		else
			nut.util.Notify("No slot machine found.", client)
		end
	end,
}, "addslotowner")

nut.command.Register({
	adminOnly = true,
	syntax = "<string target>",
	onRun = function(client, arguments)
		local data = {}
			data.start = client:GetShootPos()
			data.endpos = data.start + client:GetAimVector()*512
			data.filter = client
		local target = util.TraceLine(data).Entity
		if target and (target:GetClass() == "forp_slots") then
			local ply = nut.util.FindPlayer(arguments[1])
			if IsValid(ply) then
				target:RemoveOwner(ply)
				PLUGIN:SaveData()
				nut.util.Notify("Removed owner (" .. ply:Nick() .. ")", client)
			else
				nut.util.Notify("No player found.", client)
			end
		else
			nut.util.Notify("No slot machine found.", client)
		end
	end,
}, "removeslotowner")