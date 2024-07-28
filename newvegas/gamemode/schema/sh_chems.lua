SCHEMA.ChemBuffer = {}

function SCHEMA:RegisterChem(key, chemtable)
	SCHEMA.ChemBuffer[key] = chemtable
end

function SCHEMA:RemoveChemTimer(name)
	if (timer.Exists(name)) then
		timer.Remove(name)
	end
end

local playerMeta = FindMetaTable("Player")

function playerMeta:CanAdministerChem(chem)
	if (self.character:GetVar(chem) == 1) then
		return false
	else
		return true
	end
end

if (SERVER) then
	local playerMeta = FindMetaTable("Player")

	function playerMeta:AdministerChem(chem)
		if (self:CanAdministerChem(chem)) then
			SCHEMA.ChemBuffer[chem].ongive(self)
	
			return true
		else
			self:Notify("You are already on that chem.")
			return false
		end
	end
end

function SCHEMA:RegisterTimedChem(name, usetext, duration)
	local usetext = usetext or "You have taken some "..string.lower(name).."."
	local duration = duration or 300
	SCHEMA:RegisterChem(name, {
	ongive = function(client)
		client.character:SetVar(name, 1)
		local timerUniqueID = client:Nick()..string.lower(name).."chemtimer"
		local deathUniqueID = client:Nick()..string.lower(name).."chemdeath"
		local disconnectUniqueID = client:Nick()..string.lower(name).."chemdisconnect"


		timer.Create(timerUniqueID, duration, 1, function()
			if (!IsValid(client)) then
				return
			end

			client:SendNotification(name.." has worn off.", "", "", "fosounds/fix/ui_health_chems_wearoff.mp3", 12, 0)

			client.character:SetVar(name, 0)
			SCHEMA:RemoveChemTimer(timerUniqueID)

			hook.Remove("PlayerDeath", deathUniqueID)
			hook.Remove("PlayerDisconnected", disconnectUniqueID)
		end)

		client:Notify(usetext)

		hook.Add("PlayerDeath", deathUniqueID, function(client)
			if (!IsValid(client)) then
				return
			end

			if (client.character:GetVar(name, 0)) then

				client.character:SetVar(name, 0)
				SCHEMA:RemoveChemTimer(timerUniqueID)

				hook.Remove("PlayerDeath", deathUniqueID)
				hook.Remove("PlayerDisconnected", disconnectUniqueID)
			end
		end)

		hook.Add("PlayerDisconnected", disconnectUniqueID, function(client)
			if (!IsValid(client)) then
				return
			end

			if (client.character:GetVar(name, 0)) then

				client.character:SetVar(name, 0)
				SCHEMA:RemoveChemTimer(timerUniqueID)

				hook.Remove("PlayerDeath", deathUniqueID)
				hook.Remove("PlayerDisconnected", disconnectUniqueID)
			end
		end)
	end
	})
end

SCHEMA:RegisterTimedChem("Buffout")
SCHEMA:RegisterTimedChem("Psycho", "You have injected some psycho.")
SCHEMA:RegisterTimedChem("Jet", "You have inhaled some jet.", 60)
SCHEMA:RegisterTimedChem("Rebound", "You have injected some rebound.", 240)
SCHEMA:RegisterTimedChem("Med-X", "You have injected some med-x.")
SCHEMA:RegisterTimedChem("Steady", "You have inhaled some steady.")
SCHEMA:RegisterTimedChem("Mentats")
SCHEMA:RegisterTimedChem("Ant Nectar", "You have eaten some ant nectar.")

SCHEMA:RegisterChem("Stimpak", {
	ongive = function(client)
		client:SetHealth(math.Clamp(client:Health() + 45, 0, 100))
		client:HealAllLimbs()
		client:Notify("You have injected a Stimpak.")
	end
})

SCHEMA:RegisterChem("Healing Powder", {
	ongive = function(client)
		client:SetHealth(math.Clamp(client:Health() + 23, 0, 100))
		client:Notify("You have applied some Healing Powder.")
	end
})
SCHEMA:RegisterChem("Stealth Boy", {
	ongive = function(client)
		local name, usetext = "Stealth Boy", "You have turned your stealth boy on."

		client.character:SetVar(name, 1)
		local timerUniqueID = client:Nick()..string.lower(name).."chemtimer"
		local deathUniqueID = client:Nick()..string.lower(name).."chemdeath"
		local disconnectUniqueID = client:Nick()..string.lower(name).."chemdisconnect"

		client:SetNetVar("stealth", true)
		SCHEMA:PushClothesPurgeEvent()
		client:SetMaterial("models/effects/vol_light001")

		timer.Create(timerUniqueID, 600, 1, function()
			if (!IsValid(client)) then
				return
			end

			client:SetMaterial("")
			client:SetNetVar("stealth", nil)
			client:SendSound("fosounds/fix/ui_health_chems_wearoff.mp3")

			SCHEMA:PushClothesPurgeEvent()
			client.character:SetVar(name, 0)
			SCHEMA:RemoveChemTimer(timerUniqueID)

			hook.Remove("PlayerDeath", deathUniqueID)
			hook.Remove("PlayerDisconnected", disconnectUniqueID)
		end)

		client:Notify(usetext)

		hook.Add("PlayerDeath", deathUniqueID, function(client)
			if (!IsValid(client)) then
				return
			end

			if (client.character:GetVar(name, 0)) then

				client:SetMaterial("")
				client:SetNetVar("stealth", nil)
				SCHEMA:PushClothesPurgeEvent()
				client.character:SetVar(name, 0)
				SCHEMA:RemoveChemTimer(timerUniqueID)

				hook.Remove("PlayerDeath", deathUniqueID)
				hook.Remove("PlayerDisconnected", disconnectUniqueID)
			end
		end)

		hook.Add("PlayerDisconnected", disconnectUniqueID, function(client)
			if (!IsValid(client)) then
				return
			end

			if (client.character:GetVar(name, 0)) then

				client:SetMaterial("")
				client:SetNetVar("stealth", nil)
				SCHEMA:PushClothesPurgeEvent()
				client.character:SetVar(name, 0)
				SCHEMA:RemoveChemTimer(timerUniqueID)

				hook.Remove("PlayerDeath", deathUniqueID)
				hook.Remove("PlayerDisconnected", disconnectUniqueID)
			end
		end)
	end
})