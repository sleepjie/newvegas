SCHEMA.ProtectronFootstepsR = {"lazarus/right/npc_robotprotectron_foot_04.wav", "lazarus/right/npc_robotprotectron_foot_05.wav", "lazarus/right/npc_robotprotectron_foot_06.wav"}
SCHEMA.ProtectronFootstepsL = {"lazarus/left/npc_robotprotectron_foot_01.wav", "lazarus/left/npc_robotprotectron_foot_02.wav", "lazarus/left/npc_robotprotectron_foot_03.wav"}

function SCHEMA:PlayerFootstep(client, pos, foot, soumd, volume, rf)
	if client:IsRobot() then
		local robot = robotIndex[client:GetRobotType()]
		local footstep = robot.footstepSound

		if footstep == 1 then
			if foot == 0 then
				footstep = table.Random(SCHEMA.ProtectronFootstepsR)
			else
				footstep = table.Random(SCHEMA.ProtectronFootstepsL)
			end

			sound.PlayFile("sound/"..footstep, "3d", function(station)
				if (IsValid(station)) then
					station:Play()
					station:SetPos(client:GetPos())
					station:SetVolume(0.8)
				end
			end)
		end

		if client.footstepstation and client.footstepstation:GetState() != 1 then
			sound.PlayFile("sound/"..footstep, "3d", function(station)
				if (IsValid(station)) then
					print("playing")
					station:Play()
					station:SetPos(client:GetPos())
					station:SetVolume(0.8)
					client.footstepstation = station
				end
			end)
		end

		if !client.footstepstation then
			sound.PlayFile("sound/"..footstep, "3d", function(station)
				if (IsValid(station)) then
					station:Play()
					station:SetPos(client:GetPos())
					station:SetVolume(0.8)
					client.footstepstation = station
				end
			end)
		end
		return true
	end
end

hook.Add("Think", "RobotSounds", function()
	for k, v in pairs(player.GetAll()) do

		v.nextplay = v.nextplay or 0
		
		if v:IsRobot() then
			if v.footstepstation then
				if v:GetVelocity().x == 0 and v:GetVelocity().y == 0 and v:GetVelocity().z == 0 then
					v.footstepstation:SetVolume(0)
				elseif !v:OnGround() then
					v.footstepstation:SetVolume(0)
				elseif v:Alive() and !v:GetNetVar("noclipping") and !v:GetNetVar("stealth") and v:OnGround() then
					v.footstepstation:SetVolume(0.8)
				end

				v.footstepstation:SetPos(v:GetPos())
			end

			if v.idlestation then
				v.idlestation:SetPos(v:GetPos())
			end

			local robot = robotIndex[v:GetRobotType()]

			if !v.idlestation and v:Alive() and !v:GetNetVar("noclipping") and !v:GetNetVar("stealth") then
				sound.PlayFile("sound/"..robot.idlesound, "3d", function(station)
					if (IsValid(station)) then
						station:Play()
						station:SetPos(v:GetPos())
						station:SetVolume(0.3)
						v.idlestation = station

						v.nextplay = CurTime() + robot.idlelen
					end
				end)
			end

			if v.nextplay < CurTime() and v:Alive() and !v:GetNetVar("noclipping") and !v:GetNetVar("stealth") then
				v.nextplay = CurTime() + robot.idlelen
				sound.PlayFile("sound/"..robot.idlesound, "3d", function(station)
					if (IsValid(station)) then
						station:Play()
						station:SetPos(v:GetPos())
						station:SetVolume(0.3)
						v.idlestation = station
					end
				end)
			end
		end
	end
end)