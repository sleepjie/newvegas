AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Money"
ENT.Category = "NutScript"
ENT.Spawnable = false

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "Amount")
	self:NetworkVar("Int", 1, "Type")
end


if (SERVER) then	
	function ENT:Initialize()
		self:SetModel("models/props_lab/box01a.mdl")
		self:SetSolid(SOLID_VPHYSICS)
		self:PhysicsInit(SOLID_VPHYSICS)

		local physObj = self:GetPhysicsObject()

		if (IsValid(physObj)) then
			physObj:EnableMotion(true)
			physObj:Wake()
		else
			local min, max = Vector(-8, -8, -8), Vector(8, 8, 8)

			self:PhysicsInitBox(min, max)
			self:SetCollisionBounds(min, max)
		end
	end

	function ENT:Use(activator)
		if !(activator:IsPlayer()) then
			return
		end

		if (hook.Run("onPickupCurrency", activator, self) != false) then
			self:Remove()
		end
	end
else
	function ENT:onShouldDrawEntityInfo()
		return true
	end

	local name = ""
	
	function ENT:Initialize()
		name = SCHEMA:getCurrencyName(self:GetType(), self:GetAmount())
	end

	function ENT:GetInteractionData()
		return {"Take", name}
	end

	function ENT:DrawTargetID(x, y, alpha)
		local color = Color(255,255,255,alpha)
		nut.util.DrawText(x, y, name, color)	
	end
end