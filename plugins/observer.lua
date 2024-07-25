PLUGIN.name = "Observer"
PLUGIN.author = "Chessnut"
PLUGIN.desc = "Hides admins who noclip and restoring position."

if (SERVER) then
	function PLUGIN:PlayerNoClip(client)
		if (client:IsAdmin()) then
			if (client:GetMoveType() == MOVETYPE_WALK) then
				client:SetNetVar("noclipPos", client:GetPos())
				client:SetNoDraw(true)
				client:DrawShadow(false)
				client:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
				client:SetNetVar("noclipping", true)
				nut.util.AddLog(Format("%s entered observer mode.", client:Name()), LOG_FILTER_CONCOMMAND)
				SCHEMA:PushClothesPurgeEvent()
			else
				client:SetNoDraw(false)
				client:DrawShadow(true)
				client:SetCollisionGroup(COLLISION_GROUP_PLAYER)

				if (client:GetInfoNum("nut_observetp", 0) > 0) then
					local position = client:GetNutVar("noclipPos")

					if (position) then
						timer.Simple(0, function()
							client:SetPos(position)
						end)
					end
				end

				client:SetNetVar("noclipPos", nil)
				client:SetNetVar("noclipping", nil)
				nut.util.AddLog(Format("%s quit observer mode.", client:Name()), LOG_FILTER_CONCOMMAND)
				SCHEMA:PushClothesPurgeEvent()
			end
		end
	end
else
	CreateClientConVar("nut_observetp", "0", true, true)
	local showESP = CreateClientConVar("nut_observeesp", "1", true, true)

	function PLUGIN:HUDPaint()
		local client = LocalPlayer()

		if (client:IsAdmin() and !IsValid(client:GetObserverTarget()) and client.character and client:GetMoveType() == MOVETYPE_NOCLIP and showESP:GetInt() > 0) then
			for k, v in pairs(player.GetAll()) do
				if (v != client and v.character) then
					local position = v:LocalToWorld(v:OBBCenter()):ToScreen()
					local x, y = position.x, position.y
					nut.util.DrawText(x, y+16, v:RealName(), team.GetColor(Color(255,255,255)))
					nut.util.DrawText(x, y, v:Name(), team.GetColor(v:Team()))
				end
			end
		end
	end
	
	-- doesnt work
	--[[function PLUGIN:PlayerNoClip(client, bool)
		if client:IsAdmin() then
			if SCHEMA.ClothesTable[client] then
				for k,v in pairs(SCHEMA.ClothesTable[client]) do
					v.entity:SetNoDraw(bool)
				end
			end
		end
	end]]--
	
	hook.Add("PostPlayerDraw", "ObserveFixTest", function(client)
		if IsValid(client) then
			if client:GetNoDraw() then
				client.wasNoDraw = true
				if SCHEMA.ClothesTable[client] then
					for k,v in pairs(SCHEMA.ClothesTable[client]) do
						if IsValid(v.entity) then
							v.entity:SetNoDraw(true)
						end
					end
				end
			elseif client.wasNoDraw then
				client.wasNoDraw = false
				for k,v in pairs(SCHEMA.ClothesTable[client]) do
					if IsValid(v.entity) then
						v.entity:SetNoDraw(false)
					end
				end
			end
		end
	end)
end
