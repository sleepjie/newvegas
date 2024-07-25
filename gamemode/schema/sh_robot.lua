local playerMeta = FindMetaTable("Player")

robotIndex = {}

robotIndex["gutsy"] = {
	models = {"models/fallout/mistergutsy.mdl"},
	walkSpeed = 90,
	runSpeed = 200,
	footstepSound = "lazarus/npc_robotmrhandy_movement_lpm.wav",
	idlesound = "lazarus/npc_robotmisterhandy_idle_lp.wav",
	idlelen = 2
}

robotIndex["protectron"] = {
	models = {"models/fallout/protectron.mdl"},
	walkSpeed = 60,
	runSpeed = 90,
	footstepSound = 1,
	idlesound = "lazarus/npc_roboteyebot_idle_lp.wav",
	idlelen = 1,
	scale = 0.75
}

robotIndex["securitron"] = {
	models = {"models/TheSpire/Fallout/Robots/securitron.mdl", "models/TheSpire/Fallout/Robots/securitron_clean.mdl"},
	walkSpeed = 90,
	runSpeed = 275,
	footstepSound = "lazarus/npc_securitron_movement_lp.wav",
	idlesound = "lazarus/npc_securitron_conscious_lp.wav",
	idlelen = 4
}

robotIndex["sentrybot"] = {
	models = {"models/fallout/sentrybot.mdl"},
	walkSpeed = 90,
	runSpeed = 200,
	footstepSound = "thespireroleplay/footsteps/robot.wav",
	idlesound = "lazarus/npc_robot_sentrybot_idle_lp.wav",
	idlelen = 2
}

robotIndex["eyebot"] = {
	models = {"models/fallout/eyebot.mdl", "models/fallout/eyebot_ede.mdl"},
	walkSpeed = 90,
	runSpeed = 300,
	footstepSound = "lazarus/npc_robot_eyebot_movement_lpm.wav",
	idlesound = "lazarus/npc_roboteyebot_idle_lp.wav",
	idlelen = 1
}

function playerMeta:IsRobot()
	local playerModel = string.lower(self:GetModel())

	for k, v in pairs(robotIndex) do
		for k2, v2 in pairs(v.models) do
			if playerModel == string.lower(v2) then
				return true
			end
		end
	end

end

function playerMeta:GetRobotType()
	local playerModel = string.lower(self:GetModel())

	for k, v in pairs(robotIndex) do
		for k2, v2 in pairs(v.models) do
			if playerModel == string.lower(v2) then
				return k
			end
		end
	end

end

function playerMeta:UpdateRobot()
	if !self:IsRobot() then
		return
	end

	local robot = robotIndex[self:GetRobotType()]

	self:SetWalkSpeed(robot.walkSpeed)
	self:SetRunSpeed(robot.runSpeed)
	self:SetModelScale(robot.scale or 1, 1) 
end