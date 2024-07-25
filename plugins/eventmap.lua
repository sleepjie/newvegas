PLUGIN.name = "Events"
PLUGIN.author = "thor"
PLUGIN.desc = "Allows certain prop setups to be saved and loaded"

function PLUGIN:PlayerSpawnedProp(client, model, entity)
	if SERVER then
		if IsValid(client) then
			entity.playerProp = true
		end
	end
end

function PLUGIN:PhysgunPickup(client, entity)
	if entity.eventProp and not client:IsSuperAdmin() then
		return false
	end
end

nut.command.Register({
	superAdminOnly = true,
	syntax = "<eventname (no spaces)>",
	onRun = function(client, arguments)
		local eventName = arguments[1]
		local path = "event_"..eventName
		local propTable = {}
		
		for k,v in pairs(ents.GetAll()) do
			if v:GetClass() == "prop_physics" then
				if v.playerProp then
					table.insert(propTable, {ang = v:GetAngles(), pos = v:GetPos(), mdl = v:GetModel()})
				end
			end
		end
		
		nut.util.WriteTable(path, propTable)
	end,
}, "saveevent")

nut.command.Register({
	superAdminOnly = true,
	syntax = "<eventname (no spaces)>",
	onRun = function(client, arguments)
		local eventName = arguments[1]
		local path = "event_"..eventName
		local propTable = nut.util.ReadTable(path)
		
		if not propTable then return end
		for k,v in pairs(propTable) do
			local prop = ents.Create("prop_physics")
			prop:SetPos(v.pos)
			prop:SetAngles(v.ang)
			prop:SetModel(v.mdl)
			prop:Spawn()
			prop:SetMoveType(MOVETYPE_NONE)
			prop.eventProp = true
		end
	end,
}, "loadevent")

nut.command.Register({
	superAdminOnly = true,
	syntax = "<just hit enter>",
	onRun = function(client, arguments)
		for k,v in pairs(ents.GetAll()) do
			if v:GetClass() == "prop_physics" then
				if v.eventProp then
					v:Remove()
				end
			end
		end
	end,
}, "cleanupevents")