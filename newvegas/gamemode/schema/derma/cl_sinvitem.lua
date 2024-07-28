local PANEL = {}

function PANEL:Init()
     self:Droppable("invitem")
     self:SetLookAt(Vector(0,0,0))
     self:SetFOV(25)
     self:SetModel("models/props_c17/streetsign001c.mdl")
end

function PANEL:GetItemName()
     return self.invItem.name
end

function PANEL:LayoutEntity(Entity)
     self:RunAnimation() 
end

--function PANEL:Paint(w, h)
--     if self.Hovered or self:IsDragging() then
--          surface.SetDrawColor(Color(255,255,55,255))
--          surface.DrawRect(0,0,w,h)
--     
--          surface.SetDrawColor(20, 20, 20, 235)
--          surface.DrawRect(2,2,w-4,h-4)
--     end
--end

vgui.Register("SInvItem", PANEL, "DModelPanel")