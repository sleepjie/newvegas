ENT.Type = "anim"
ENT.PrintName = "Crafting Table"
ENT.Author = "Black Tea"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Category = "NutScript"
ENT.RenderGroup 		= RENDERGROUP_BOTH
ENT.craftingbench = true

if (SERVER) then
	function ENT:Initialize()
		self:SetModel("models/fallout new vegas/reload_bench.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
		local physicsObject = self:GetPhysicsObject()
		if ( IsValid(physicsObject) ) then
			physicsObject:Wake()
		end
	end

	function ENT:Use(activator)
		netstream.Start( activator, "nut_CraftWindow", activator) 
	end
else
	netstream.Hook("nut_CraftWindow", function(client, data)
		if (IsValid(nut.gui.crafting)) then
			nut.gui.crafting:Remove()
			return
		end
		surface.PlaySound( "items/ammocrate_close.wav" )
		nut.gui.crafting = vgui.Create("nut_Crafting")
		nut.gui.crafting:Center()
	end)

	function ENT:Initialize()
	end

	function ENT:OnRemove()
	end
end
