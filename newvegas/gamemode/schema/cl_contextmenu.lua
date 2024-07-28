local hud_comp_bkg = hud_comp_bkg or Material("forp/hud_comp_bkg.png", "noclamp smooth")
local hud_comp_pie = hud_comp_pie or Material("forp/hud_comp_pie.png", "noclamp smooth")

local hud_comp_slices = hud_comp_slices or {}

for i = 1, 8 do 
    hud_comp_slices[i] = Material("forp/hud_comp_slice"..i..".png", "noclamp smooth")
end

local ContextPanel = nil

function SCHEMA:CreateContextMenu(contextMenu)
    local start = CurTime()
    local contextMenu = contextMenu or {}
    local range = {}
    range[15] = {hud_comp_slices[8], 8}
    range[14] = {hud_comp_slices[8], 8}
    range[13] = {hud_comp_slices[8], 8}
    range[12] = {hud_comp_slices[8], 8}
    range[18] = {hud_comp_slices[7], 7}
    range[17] = {hud_comp_slices[7], 7}
    range[16] = {hud_comp_slices[7], 7}
    range[-18] = {hud_comp_slices[6], 6}
    range[-17] = {hud_comp_slices[6], 6}
    range[-16] = {hud_comp_slices[6], 6}
    range[-15] = {hud_comp_slices[5], 5}
    range[-14] = {hud_comp_slices[5], 5}
    range[-13] = {hud_comp_slices[5], 5}
    range[-12] = {hud_comp_slices[5], 5}
    range[-4] = {hud_comp_slices[4], 4}
    range[-5] = {hud_comp_slices[4], 4}
    range[-6] = {hud_comp_slices[4], 4}
    range[-1] = {hud_comp_slices[3], 3}
    range[-2] = {hud_comp_slices[3], 3}
    range[-3] = {hud_comp_slices[3], 3}
    range[0] = {hud_comp_slices[2], 2}
    range[1] = {hud_comp_slices[2], 2}
    range[2] = {hud_comp_slices[2], 2}
    range[3] = {hud_comp_slices[1], 1}
    range[4] = {hud_comp_slices[1], 1}
    range[5] = {hud_comp_slices[1], 1}
    range[6] = {hud_comp_slices[1], 1}
    
    if (ContextPanel and ContextPanel:IsValid()) then
        ContextPanel:Remove()
    end

    ContextPanel = vgui.Create("DFrame")
    ContextPanel:SetPos(ScrW(), ScrH())
    ContextPanel:SetSize(0,0)
    ContextPanel:MakePopup()

    local slice = 1
    local context = "Choose an Option"
    hook.Add("HUDPaint", "ContextMenu", function()
        drawcross = false
        surface.SetMaterial(hud_comp_bkg)
        surface.SetDrawColor(Color(255,255,255,240))
        surface.DrawTexturedRectRotated(ScrW()/2, ScrH()/2, 640, 640, 0)
    
        surface.SetDrawColor(SCHEMA:GetPBColor(255))
        surface.SetMaterial(hud_comp_pie)
        surface.DrawTexturedRectRotated(ScrW()/2, ScrH()/2, 640, 640, 0)
        
        for i = #contextMenu + 1, 8 do
            surface.SetMaterial(hud_comp_slices[i])
            surface.SetDrawColor(Color(150, 150, 150, 100))
            surface.DrawTexturedRectRotated(ScrW()/2, ScrH()/2, 640, 640, 0)
            surface.SetDrawColor(SCHEMA:GetPBColor(255))
        end

        local cX, cY = ScrW()/2, ScrH()/2
        local mX, mY = input.GetCursorPos() 
        local ang2 = math.deg(math.atan2(cY-mY, mX-cX))

        if (range[math.Round(ang2*0.1, 0)]) then
            surface.SetMaterial(range[math.Round(ang2*0.1, 0)][1])
            surface.DrawTexturedRectRotated(ScrW()/2, ScrH()/2, 640, 640, 0)
    
            if (slice ~= range[math.Round(ang2*0.1, 0)][2]) then
                slice = range[math.Round(ang2*0.1, 0)][2]
                surface.PlaySound("forp/ui_menu_focus.wav")
            end

            if contextMenu[range[math.Round(ang2*0.1, 0)][2]] then
                context = contextMenu[slice].Name
            else
                context = "Choose an Option"
            end
        end

        SCHEMA.DrawBlur(ScrW()/2, ScrH()/2 - 192, context, 1, false)
        
        if (input.IsMouseDown(MOUSE_LEFT) and start + 0.1 < CurTime()) then
            ContextPanel:Remove()
            hook.Remove("HUDPaint", "ContextMenu")
            drawcross = true
            surface.PlaySound("forp/ui_menu_ok.wav")
            if contextMenu[slice] then
                contextMenu[slice].OnClick()
            end
        elseif (input.IsMouseDown(MOUSE_RIGHT) and start + 0.1 < CurTime()) then
            surface.PlaySound("forp/ui_menu_cancel.wav")
            hook.Remove("HUDPaint", "ContextMenu")
            drawcross = true
            ContextPanel:Remove()
        end
    end)
end

function SCHEMA:ContextMenuOpen()
    local ContextMenu = {}

    local validclasses = {"nut_keys", "weapon_physgun", "gmod_tool"}

    local class = "nut_keys"
    if LocalPlayer():GetActiveWeapon():IsValid() then
        class = LocalPlayer():GetActiveWeapon():GetClass()
    end

    if (!table.HasValue(validclasses, class)) then
        table.insert(ContextMenu, {Name = "Toggle Raise", OnClick = function() 
            LocalPlayer():ConCommand("say /toggleraise") 
        end})
    end

    local trace = LocalPlayer():GetEyeTraceNoCursor()
    local tracedist = 0

    if (trace.HitPos:Distance(LocalPlayer():GetPos()) > 256) then
        trace = nil
    else
        tracedist = trace.HitPos:Distance(LocalPlayer():GetPos())
    end

    if (trace and (trace.Entity == LocalPlayer())) then
        trace = nil
    end

    if (trace and trace.Entity:IsPlayer()) then
        local GiveCurrency = {}

        table.insert(GiveCurrency, {Name = "Give Caps", OnClick = function()
            Derma_StringRequest("Give Caps", "How many Caps would you like to give?", "", function(text)
                LocalPlayer():ConCommand("say /givemoney".." "..text)
            end) 
        end})

        for k, v in pairs(SCHEMA:GetCurrencyIndex()) do
            table.insert(GiveCurrency, {Name = "Give "..v[2], OnClick = function()
                Derma_StringRequest("Give "..v[2], "How much "..v[2].." would you like to give?", "", function(text)
                    LocalPlayer():ConCommand("say /give"..v[3].." "..text)

                end) 
            end})
        end

        table.insert(ContextMenu, {Name = "Give Currency", OnClick = function() SCHEMA:CreateContextMenu(GiveCurrency) end})

        if (tracedist < 96) then
            table.insert(ContextMenu, {Name = "Check Condition", OnClick = function() 
                netstream.Start("nut_CheckCondition", false)
            end})

            table.insert(ContextMenu, {Name = "Pat Down", OnClick = function() 
                netstream.Start("nut_PatDown", false)
            end})
    
            if (LocalPlayer():HasItem("ziptie")) then
                table.insert(ContextMenu, {Name = "Ziptie", OnClick = function() 
                    netstream.Start("nut_ZipTie", false)
                end})
            end
        end

        if trace.Entity:GetNetVar("tied") then
            table.insert(ContextMenu, {Name = "Untie", OnClick = function() 
                netstream.Start("nut_UnZipTie", false)
            end})
        end
    else
        local DropCurrencyMenu = {}

        table.insert(DropCurrencyMenu, {Name = "Caps", OnClick = function() 
            Derma_StringRequest("Drop Caps", "How many Caps would you like to drop?", "", function(text)
                LocalPlayer():ConCommand("say /dropmoney".." "..text)
            end)  
        end})

        for k, v in pairs(SCHEMA:GetCurrencyIndex()) do
            table.insert(DropCurrencyMenu, {Name = v[2], OnClick = function() 
                Derma_StringRequest("Drop "..v[2], "How much "..v[2].." would you like to drop?", "", function(text)
                    LocalPlayer():ConCommand("say /drop"..v[3].." "..text)
                end) 
            end})
        end

        table.insert(ContextMenu, {Name = "Drop Currency", OnClick = function() SCHEMA:CreateContextMenu(DropCurrencyMenu) end})
    end

    local found = false

    for k, client in pairs(player.GetAll()) do
        if (client:GetPos():Distance(LocalPlayer():GetPos()) < nut.config.yellRange) then
            if (!found and client != LocalPlayer()) then
                local RecContextMenu = {}

                table.insert(RecContextMenu, {Name = "Looking At", OnClick = function() 
                    LocalPlayer():ConCommand("say /recognise aim")
                end})
        
                table.insert(RecContextMenu, {Name = "Talking Range", OnClick = function() 
                    LocalPlayer():ConCommand("say /recognise")
                end})

                table.insert(RecContextMenu, {Name = "Whispering Range", OnClick = function() 
                    LocalPlayer():ConCommand("say /recognise whisper")
                end})

                table.insert(RecContextMenu, {Name = "Yelling Range", OnClick = function() 
                    LocalPlayer():ConCommand("say /recognise yell")
                end})

                found = true

                table.insert(ContextMenu, {Name = "Recognise Players", OnClick = function() SCHEMA:CreateContextMenu(RecContextMenu) end})
            end
        end
    end

    local grenades = {"throw_beacon_art", "throw_flare", "throw_flare_g", "throw_flare_y", "throw_teargas"}
    local tossnade = false

    for k, v in pairs(LocalPlayer():GetInventoryBags()) do
        for k2, v2 in pairs(v.bag) do
            if table.HasValue(grenades, k2) then
                local itemTable = nut.item.Get(k2)

                if (itemTable) then
                    if (!tossnade) then
                        tossnade = {}
                    end

                    table.insert(tossnade, {Name = itemTable.name, OnClick = function() 
                        netstream.Start("nut_ThrowNade", itemTable.uniqueID)
                    end})
                end
            end
        end
    end

    if (tossnade) then
        table.insert(ContextMenu, {Name = "Toss Grenade", OnClick = function() SCHEMA:CreateContextMenu(tossnade) end})
    end

    SCHEMA:CreateContextMenu(ContextMenu)

    return false
end
