AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Currency"
ENT.Category = "Fallout Roleplay"
ENT.Author = "Johnny Guitar"
ENT.Spawnable = true

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "Amount")
	self:NetworkVar("Int", 1, "Type")
end

if (SERVER) then
	function ENT:Initialize()
		self:SetModel("models/Items/item_item_crate.mdl")
		self:SetSolid(SOLID_BSP)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetHealth(100)
		self:SetType(math.random(1,3))
		self:SetAmount(1)
		self:SetUseType(SIMPLE_USE)

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
		
		client:GiveCurrency(self:GetType(), self:GetAmount())
		if amount > 1 then
			nut.util.Notify("You have picked up "..SCHEMA:GetCurrencyName(self:GetType(), self:GetAmount() > 1)..".", client)
		end
	end
end

if (CLIENT) then
	local amount, name = 0, ""
	function ENT:Initialize()
		amount = self:GetAmount()
		name = SCHEMA:GetCurrencyName(self:GetType(), self:GetAmount() > 1)
	end

	function ENT:GetInteractionData()
		return {"Take", name, 0, amount}
	end

	function ENT:DrawTargetID(x, y, alpha)
		local color = Color(255,255,255,alpha)
		nut.util.DrawText(x, y, amount.." "..name, color)	
	end
end