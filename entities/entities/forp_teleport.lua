AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Teleporter"
ENT.Category = "Fallout Roleplay"
ENT.Author = "Johnny Guitar"
ENT.Spawnable = true
ENT.isdoor = true

function ENT:SetupDataTables()
	self:NetworkVar("String", 1, "Destination")
	self:NetworkVar("String", 2, "Type")
	self:NetworkVar("String", 3, "UID")
end

if (SERVER) then
	function ENT:Initialize()
		self:SetModel("models/props_c17/door01_left.mdl")
		self:SetSolid(SOLID_BSP)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetHealth(100)
		self:SetUseType(SIMPLE_USE)
		self:SetUID("DefaultUID")
		self:SetType("Door")
		self:SetDestination("The Mojave Wasteland")

		local physicsObject = self:GetPhysicsObject();

		if (IsValid(physicsObject)) then
			physicsObject:Wake()
			physicsObject:EnableMotion(true)
		end
	end

	function ENT:Use(client)
		if !client:IsPlayer() then
			return
		end
		
		SCHEMA:TeleportPlayer(self:GetUID(), client)
	end
end

if (CLIENT) then
	--function ENT:DrawTargetID(x, y, alpha)
	--	local color = Color(255,255,255,alpha)
	--	nut.util.DrawText(x, y, self:GetType().." to "..self:GetDestination(), color)	
	--	nut.util.DrawText(x, y-24, self:GetUID(), color)	
	--end
end