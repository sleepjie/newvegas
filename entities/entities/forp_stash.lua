AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Stash"
ENT.Category = "Fallout Roleplay"
ENT.Author = "Johnny Guitar"
ENT.Spawnable = true

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "Health")
end

if (SERVER) then
	function ENT:Initialize()
		self:SetModel("models/Items/item_item_crate.mdl")
		self:SetSolid(SOLID_BSP)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetHealth(100)
		self:SetUseType(SIMPLE_USE)

		local physicsObject = self:GetPhysicsObject();
		if (IsValid(physicsObject)) then
			physicsObject:Wake()
			physicsObject:EnableMotion(true)
		end
	end

	function ENT:Use()
		self:OnBreak()
	end

	function ENT:OnBreak()
		local sfx = EffectData()
		sfx:SetOrigin(self:GetPos())
		sfx:SetStart(self:GetPos())
		sfx:SetMagnitude(400)
	
		util.Effect("GlassImpact", sfx)

		if (math.random(0,20) == 20) then
			nut.item.Spawn(self:GetPos() + Vector(0,0,15), self:GetAngles(), "lunchbox")
		end
		nut.item.Spawn(self:GetPos() + Vector(0,0,15), self:GetAngles(), "lunchbox")
		SCHEMA.RespawnTimer = SCHEMA.RespawnTimer + 5
		self:Remove()
	end

	function ENT:OnTakeDamage(damageInfo)
		local damage = damageInfo:GetDamage()
		local health = self:GetHealth()
		health = health - damage
		health = math.Clamp(health, 0, 100)

		if health <= 0 then
			self:OnBreak()
		end
	end
end

if (CLIENT) then
	function ENT:GetInteractionData()
		return {"Use", "Lunchbox"}
	end
end