--bad code ahead
 
local gradient = surface.GetTextureID("gui/gradient")
local surface = surface
 
local PANEL = {}
        function PANEL:Init()
                self:SetSize(ScrW() * 0.375, ScrH() * 0.85)
                self:Center()
                self:MakePopup()
                self:SetDrawBackground(false)
 
                self.title = self:Add("DLabel")
                self.title:Dock(TOP)
                self.title:DockMargin(8, 8, 8, 0)
                self.title:SetText(GetHostName())
                self.title:SetFont("nut_ScoreTitleFont")
                self.title:SetTextColor(color_white)
                self.title:SetExpensiveShadow(2, color_black)
                self.title:SizeToContents()
 
                self.list = self:Add("DScrollPanel")
                self.list:Dock(FILL)
                self.list:DockMargin(8, 8, 8, 8)
                self.list:DockPadding(4, 4, 4, 4)
                self.list.Paint = function(panel, w, h)
                        surface.SetDrawColor(100, 100, 100, 5)
                        surface.DrawOutlinedRect(0, 0, w, h)
 
                        surface.SetDrawColor(50, 50, 50, 150)
                        surface.DrawRect(0, 0, w, h)
                end
 
                self:PopulateList()
 
                self.lastUpdate = 0
                self.lastCount = #player.GetAll()
        end
 
        function PANEL:PopulateList()
                self.teamList = {}
 
                local players = player.GetAll()
 
                table.sort(players, function(a, b)
                        return a:Team() > b:Team()
                end)
 
                for k, v in ipairs(players) do
                        if (v.character) then
                                local customClass = v:GetNetVar("customClass")
 
                                if (customClass == "") then
                                        customClass = nil
                                end
 
                                local teamName = "" --make teams all the same thing in the scoreboard so you're not grouped by faction
 
                                --if (v.character:GetVar("DisplayColor") != 0) then
                                --        local dispcol = v.character:GetVar("DisplayColor")
                                --        if (SCHEMA.factions) then
                                --                for k, v in pairs(SCHEMA.factions) do
                                --                        if v.color == dispcol then
                                --                                teamName = v.name
                                --                        end
                                --                end
                                --        end
                                --end
 
                                if (!IsValid(self.teamList[teamName])) then
                                        self.teamList[teamName] = self.list:Add("DPanel")
                                        self.teamList[teamName]:Dock(TOP)
                                        self.teamList[teamName]:SetDrawBackground(false)
 
                                        local title = self.teamList[teamName]:Add("DLabel")
                                        title:Dock(TOP)
                                        title:DockMargin(4, 0, 4, -18)
                                        title:SetText(teamName)
                                        title:SetFont("nut_ScoreTeamFont")
                                        title:SizeToContents()
                                        title:SetTextColor(color_white)
                                        title:SetExpensiveShadow(1, color_black)
                                end
 
                                local panel = self.teamList[teamName]
 
                                if (IsValid(panel)) then
                                        local panel2 = panel:Add("nut_PlayerScore")
                                        panel2:DockMargin(4, 0, 4, -30)
                                        panel2:Dock(TOP)
                                        panel2:SetPlayer(v)
                                        panel:SetTall(panel:GetTall() + 32 + 8)
                                end
                        end
                end
        end
 
        function PANEL:Think()
                if (self.lastUpdate < CurTime()) then
                        self.lastUpdate = CurTime() + 1
 
                        if (self.lastCount != #player.GetAll()) then
                                self.list:Clear(true)
                                self:PopulateList()
                        end
 
                        self.lastCount = #player.GetAll()
                end
        end
 
        function PANEL:Paint(w, h)
                surface.SetDrawColor(25, 25, 25, 200)
                surface.DrawOutlinedRect(0, 0, w, h)
 
                surface.SetDrawColor(200, 200, 200, 100)
                surface.DrawOutlinedRect(1, 1, w - 2, h - 2)
 
                surface.SetDrawColor(0, 0, 0, 230)
                surface.DrawRect(0, 0, w, h)
        end
vgui.Register("nut_Scoreboard", PANEL, "DPanel")
 
local PANEL = {}
        function PANEL:Init()
                local width = (ScrW() * 0.375) - 32
 
                self:SetTall(68)
 
                self.avatar = vgui.Create("AvatarImage", self)
                self.avatar:SetPos(2, 2)
                self.avatar:SetSize(32, 32)
                self.avatar:SetPlayer(self.player, 32)
                --self.model:SetModel("models/error.mdl")
                --self.model:SetToolTip("Click to open their profile.")
 
                self.profile = vgui.Create("SpawnIcon", self)
                self.profile:SetPos(2, 2)
                self.profile:SetSize(32, 32)
                self.profile:SetModel("models/barney_animations.mdl") --removes the error/missing model and replaces it with an invisible one...lmao.
                self.profile.DoClick = function()
                        if (IsValid(self.player)) then
                                self.player:ShowProfile()
                        end
                end
                self.profile:SetToolTip("Click to open their profile.")
 
                self.name = vgui.Create("DLabel", self)
                self.name:SetPos(52, 4)
                self.name:SetText("John Doe")
                self.name:SetFont("nut_TargetFont")
                self.name:SetTextColor(color_white)
                self.name:SetExpensiveShadow(1, color_black)
 
                self.desc = vgui.Create("DImage", self)
                self.desc:SetPos(38, 10)
                self.desc:SizeToContents()
 
 
                self.ping = vgui.Create("DLabel", self)
                self.ping:SetPos(width - 84, 6)
                self.ping:SetText("000")
                self.ping:SetTextColor(color_white)
                self.ping:SetExpensiveShadow(1, color_black)
                self.ping:SetFont("nut_TargetFont")
                self.ping:SetContentAlignment(6)
        end
 
        function PANEL:SetPlayer(client)
                self.player = client
 
                local recognized = hook.Run("IsPlayerRecognized", client)
                local name = ""
                local model = ""
 
                name = client:RealName()
 
                self.avatar:SetPlayer(client, 64) --update icons of players every time a new one spawns in
                self.profile:SetToolTip("Click to open "..name.."'s Steam profile.") --name is the client's real name
 
                if(self.player:IsAdmin() && !self.player:IsSuperAdmin()) then --check rank, make sure they're admin but not super admin
                        self.desc:SetImage("icon16/star.png")
                                else if (self.player:IsSuperAdmin()) then --check if superadmin
                                        self.desc:SetImage("icon16/shield.png")
                                else if(!self.player:IsSuperAdmin() && !self.player:IsAdmin()) then
                                        self.desc:SetImage("icon16/user.png")
                                end
                        end
                end
 
                self.name:SetText(name)
                self.name:SizeToContents()
        end
 
        function PANEL:Think()
                if (IsValid(self.player)) then
                        self.ping:SetText(self.player:Ping())
                end
        end
 
        function PANEL:Paint(w, h)
                --surface.SetDrawColor(5, 5, 5, 150) -- ?
                --surface.DrawOutlinedRect(0, 0, w, h - 40)
 
                surface.SetDrawColor(255, 255, 255, 10)
                surface.DrawOutlinedRect(1, 1, w - 2, h - 32) --outline at bottom of player tab
 
                --surface.SetDrawColor(125, 125, 125, 25) -- ?
                --surface.DrawRect(0, 0, w, h - 40)
 
                if (IsValid(self.player)) then
                        local color = team.GetColor(self.player:Team())
                        if (self.player.character:GetVar("DisplayColor") and self.player.character:GetVar("DisplayColor") != 0) then
                                local col = string.Explode(" ", self.player.character:GetVar("DisplayColor"))
                                color = Color(col[1], col[2], col[3])
                        end
 
                        if(self.player:IsBot()) then
                                math.randomseed(util.CRC(self.player:RealName()))
                        else
                                math.randomseed(self.player:SteamID64() + util.CRC("catmeow:3"))
                                --math.randomseed("76561198000245133")
                        end
 
                        local color = Color(math.random(20, 255), math.random(20, 255), math.random(20, 255)) --cleanliness
 
                        --print(color.r)
 
                        surface.SetDrawColor(color.r, color.g, color.b, 35)
                        surface.DrawRect(0, 0, w, h - 32) --gradient at bottom of player tab
 
                        math.randomseed(os.time()) --restore randomseed
                end
        end
vgui.Register("nut_PlayerScore", PANEL, "DPanel")
 
function GM:ScoreboardShow()
        if (!IsValid(nut.gui.score)) then
                nut.gui.score = vgui.Create("nut_Scoreboard")
        end
end
 
function GM:ScoreboardHide()
        if (IsValid(nut.gui.score)) then
                nut.gui.score:Remove()
        end
end