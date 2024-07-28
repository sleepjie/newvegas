include("shared.lua")

--these are just here for tracking
ENT.moneyEarned = 0
ENT.numSpins = 0

local symbolPath = {
	[SLOTS_SPLIT] = "thor/slots/slotsplit",
	[SLOTS_CHERRY] = "thor/slots/slotcherry",
	[SLOTS_BELL] = "thor/slots/slotbell",
	[SLOTS_BAR] = "thor/slots/slotbar",
	[SLOTS_SEVEN] = "thor/slots/slot7",
	[SLOTS_LEMON] = "thor/slots/slotlemon",
	[SLOTS_GRAPE] = "thor/slots/slotgrape",
	[SLOTS_ORANGE] = "thor/slots/slotorange",
}

function ENT:Initialize()
	
	self.vReel1 = 1
	self.reelDest1 = 1
	
	self.vReel2 = 1
	self.reelDest2 = 1
	
	self.vReel3 = 1
	self.reelDest3 = 1
	
	self.reelSpeed1 = 0
	self.reelSpeed2 = 0
	self.reelSpeed3 = 0
	
	self.doneReel1Anim = true
	self.doneReel2Anim = true
	self.doneReel3Anim = true
	
	self.lastAnimCall = 0
	self.lastSpinTime = 0
	
end

function ENT:OnRemove()
	
end

function ENT:SpinReels(int1, int2, int3)
	
	local newDest1 = self:FindReelValue(self.reel1, int1)
	local newDest2 = self:FindReelValue(self.reel2, int2)
	local newDest3 = self:FindReelValue(self.reel3, int3)
	
	self.reelSpeed1 = (newDest1 + #self.reel1 * 0) - self.reelDest1 + #self.reel1 * 2
	self.reelSpeed2 = (newDest2 + #self.reel2 * 1) - self.reelDest2 + #self.reel2 * 2
	self.reelSpeed3 = (newDest3 + #self.reel3 * 2) - self.reelDest3 + #self.reel3 * 2
	
	self.reelDest1 = newDest1
	self.reelDest2 = newDest2
	self.reelDest3 = newDest3
	
	self.doneReel1Anim = false
	self.doneReel2Anim = false
	self.doneReel3Anim = false
	
	sound.Play("thor/slots/sfx_slots_pulllever.wav", self:GetPos(), 50, 100, 1)
	self.numSpins = self.numSpins + 1
	self.moneyEarned = self.moneyEarned - self:GetBetAmount()
	
	self.lastAnimCall = RealTime()
	self.lastSpinTime = RealTime()
	
end

-- convenience function to turn visIndex into a proper index
local function orderClamp(tbl, n)
	local m = #tbl
	
	n = math.floor(n)
	if n <= 0 then
		while n <= 0 do
			n = m + n
		end
	elseif n >= m+1 then
		while n >= m+1 do
			n = n - m
		end
	end
	
	return n
end
			
-- drawReel using the IMesh object (only use a single mesh object, just rendered several times with matrix)
local panelVerts = {
	{pos = Vector(128, 64, 0), normal = Vector(0, 0, 1), u = 1, v = 0, color = Color(255, 255, 255, 255)},
	{pos = Vector(-128, -64, 0), normal = Vector(0, 0, 1), u = 0, v = 1, color = Color(255, 255, 255, 255)},
	{pos = Vector(-128, 64, 0), normal = Vector(0, 0, 1), u = 0, v = 0, color = Color(255, 255, 255, 255)},
	{pos = Vector(128, 64, 0), normal = Vector(0, 0, 1), u = 1, v = 0, color = Color(255, 255, 255, 255)},
	{pos = Vector(128, -64, 0), normal = Vector(0, 0, 1), u = 1, v = 1, color = Color(255, 255, 255, 255)},
	{pos = Vector(-128, -64, 0), normal = Vector(0, 0, 1), u = 0, v = 1, color = Color(255, 255, 255, 255)},
}
local panelMesh = Mesh()
panelMesh:BuildFromTriangles(panelVerts)

function ENT:drawReelIMesh(pos, ang, reel, visIndex)
	
	local w = 256
	local h = 128
	local m = Matrix()
	m:Translate(pos)
	m:Rotate(ang)
	m:Scale(Vector(1/140, 1/150, 1/150))
	
	-- were using static meshs now, so use clipping planes instead of altering size/uv
	render.PushCustomClipPlane(m:GetRight(), m:GetRight():Dot(m:GetTranslation() - m:GetRight() * 5 * h / 2))
	render.PushCustomClipPlane(-m:GetRight(), -m:GetRight():Dot(m:GetTranslation() + m:GetRight() * 5 * h / 2))
	
	local p = visIndex % 1
	m:Translate(Vector(0, h*3, 0))
	for i=0, 6 do
		m:Translate(Vector(0, -h * p, 0))
		render.SetMaterial(Material(symbolPath[reel[orderClamp(reel, visIndex+3 - i)].sym]))
		cam.PushModelMatrix(m)
			panelMesh:Draw()
		cam.PopModelMatrix()
		m:Translate(Vector(0, -h * (1-p), 0))
	end
	
	render.PopCustomClipPlane()
	render.PopCustomClipPlane()
	
end

function ENT:PlayResultSound()
	local payout = self:CheckVictory(self.reelDest1, self.reelDest2, self.reelDest3)
	
	if payout >= 150 then
		sound.Play("thor/slots/sfx_slots_jackpot.wav", self:GetPos(), 60, 100, 1)
	elseif payout >= 25 then
		sound.Play("thor/slots/sfx_slots_win_med.wav", self:GetPos(), 50, 100, 1)
	elseif payout > 0 then
		sound.Play("thor/slots/sfx_slots_win_small.wav", self:GetPos(), 50, 100, 1)
	end
	
	self.moneyEarned = self.moneyEarned + self:GetBetAmount() * payout
end

function ENT:DoReelAnimation()
	
	-- the RealTime() - self.lastAnimCall is done because frametime seems to be inaccurate relative to the draw calls
	local t = RealTime() - self.lastAnimCall
	if not (RealTime() - 2 > self.lastSpinTime) then
		self.vReel1 = self.vReel1 + self.reelSpeed1 * (t/2)
	elseif not self.doneReel1Anim then
		if self.vReel1 > #self.reel1 then self.vReel1 = self.vReel1 % #self.reel1 end
		if not (self.vReel1 == self.reelDest1) then
			self.vReel1 = math.Approach(self.vReel1, self.reelDest1, math.Clamp(t*math.abs(self.reelDest1-self.vReel1), t, 20))
		else
			self.doneReel1Anim = true
		end
	end
	
	if not (RealTime() - 3 > self.lastSpinTime) then
		self.vReel2 = self.vReel2 + self.reelSpeed2 * (t/3)
	elseif not self.doneReel2Anim then
		if self.vReel2 > #self.reel2 then self.vReel2 = self.vReel2 % #self.reel2 end
		if not (self.vReel2 == self.reelDest2) then
			self.vReel2 = math.Approach(self.vReel2, self.reelDest2, math.Clamp(t*math.abs(self.reelDest2-self.vReel2), t, 20))
		else
			self.doneReel2Anim = true
		end
	end
	
	-- i should really put this stuff in like a table or something
	if not (RealTime() - 4 > self.lastSpinTime) then
		self.vReel3 = self.vReel3 + self.reelSpeed3 * (t/4)
	elseif not self.doneReel3Anim then
		if self.vReel3 > #self.reel3 then self.vReel3 = self.vReel3 % #self.reel3 end
		if not (self.vReel3 == self.reelDest3) then
			self.vReel3 = math.Approach(self.vReel3, self.reelDest3, math.Clamp(t*math.abs(self.reelDest3-self.vReel3), t, 20))
		else
			self.doneReel3Anim = true
			self:PlayResultSound()
		end
	end
	
	self.lastAnimCall = RealTime()
end

function ENT:Draw()
	
	self:DrawModel()
	
	local reelAngles = Angle(0, 90, 70)
	local reelPos1 = self:LocalToWorld(Vector(0, 0, 15) + reelAngles:Up() * 0.425 + reelAngles:Forward() * -3.24 + reelAngles:Right() * 0.2)
	local reelPos2 = self:LocalToWorld(Vector(0, 0, 15) + reelAngles:Up() * 0.425 + reelAngles:Forward() * -1.02 + reelAngles:Right() * 0.2)
	local reelPos3 = self:LocalToWorld(Vector(0, 0, 15) + reelAngles:Up() * 0.425 + reelAngles:Forward() * 1.3 + reelAngles:Right() * 0.2)
	reelAngles = self:LocalToWorldAngles(reelAngles)
	
	-- imesh is the only one that supports lighting, others require fullbright
	self:drawReelIMesh(reelPos1, reelAngles, self.reel1, self.vReel1)
	self:drawReelIMesh(reelPos2, reelAngles, self.reel2, self.vReel2)
	self:drawReelIMesh(reelPos3, reelAngles, self.reel3, self.vReel3)
	
	self:DoReelAnimation()
	
end

local function slotsCalcView(ply, pos, angles, fov)
	
	if (not ply.slotMachine) or (not ply.slotMachine:IsValid()) then return end
	
	local view = {}
	local slot = LocalPlayer().slotMachine
	local nAng = Angle(0, 180, 0)
	local nPos = Vector(0, 0, 0) - nAng:Forward() * 10 + nAng:Up() * 17 - nAng:Right() * 1
	nPos = slot:LocalToWorld(nPos)
	
	-- tilt angles downwards slightly!
	nAng = nAng + Angle(10, 0, 0)
	nAng = slot:LocalToWorldAngles(nAng)
	
	view.origin = nPos
	view.angles = nAng
	view.fov = fov
	
	return view
	
end
hook.Add("CalcView", "slotsCalcView", slotsCalcView)

surface.CreateFont( "slotsFont1", {
	font = "montofonto",
	size = 24,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = false,
	outline = false,
})
surface.CreateFont( "slotsFont2", {
	font = "montofonto",
	size = 24,
	weight = 800,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = false,
	outline = false,
})

local fadeToTop = Material("forp/uistuff/fade_to_top.png", "nocull")
local fadeToRight = Material("forp/uistuff/fade_to_right.png", "nocull")
local iconList = {
	[1] = {mat = Material("thor/icons/cherry.png", "nocull"), text = "Bet x30"},
	[2] = {mat = Material("thor/icons/bell.png", "nocull"), text = "Bet x20"},
	[3] = {mat = Material("thor/icons/bar.png", "nocull"), text = "Bet x40"},
	[4] = {mat = Material("thor/icons/seven.png", "nocull"), text = "Bet x50"},
	[5] = {mat = Material("thor/icons/lemon.png", "nocull"), text = "Bet x100"},
	[6] = {mat = Material("thor/icons/grape.png", "nocull"), text = "Bet x250"},
	[7] = {mat = Material("thor/icons/orange.png", "nocull"), text = "Bet x500"},
}

local slotsButtonPane = nil
local slotsPayoutPane = nil
local slotsSpinButton = nil
local slotsPayoutButton = nil
local slotsExitButton = nil
local function toggleSlotsGUI(slot)
	
	if slotsButtonPane then
		
		if slotsExitButton then
			if slotsExitButton:IsValid() then
				slotsExitButton:Remove()
			end
			slotsExitButton = nil
		end
		
		if slotsPayoutButton then
			if slotsPayoutButton:IsValid() then
				slotsPayoutButton:Remove()
			end
			slotsPayoutButton = nil
		end
		
		if slotsSpinButton then
			if slotsSpinButton:IsValid() then
				slotsSpinButton:Remove()
			end
			slotsSpinButton = nil
		end
		
		if slotsPayoutPane then
			if slotsPayoutPane:IsValid() then
				slotsPayoutPane:Remove()
			end
			slotsPayoutPane = nil
		end
		
		if slotsButtonPane:IsValid() then
			slotsButtonPane:Remove()
		end
		slotsButtonPane = nil
		
		LocalPlayer().slotMachine = nil
		
		gui.EnableScreenClicker(false)
		
		return
		
	end
	
	local w = 300
	local h = 150
	LocalPlayer().slotMachine = slot
	
	slotsButtonPane = vgui.Create("DPanel")
	slotsButtonPane:SetSize(w, h)
	slotsButtonPane:SetPos(25, ScrH() - h - 125)
	slotsButtonPane.Paint = function(panel, w, h)
		
		surface.SetMaterial(fadeToTop)
		surface.SetDrawColor(Color(255, 191, 65))
		surface.DrawTexturedRect(0, 0, 3, 30)
		surface.DrawRect(0, 30, 3, h-30)
		
		surface.SetMaterial(fadeToRight)
		surface.SetDrawColor(Color(255, 191, 65))
		surface.DrawTexturedRect(w - 30, h - 3, 30, 3)
		surface.DrawRect(0, h - 3, w - 30, 3)
		
		local str1 = "Current Bet: "
		local str2 = "Caps: "
		local str3 = "Current Winnings: "
		local str4 = tostring(slot:GetBetAmount())
		local str5 = tostring(LocalPlayer():GetMoney())
		local str6 = tostring(slot.moneyEarned)
		
		surface.SetTextColor(Color(255, 191, 65))
		surface.SetFont("slotsFont1")
		
		local tWidth, tHeight = surface.GetTextSize(str1)
		surface.SetTextPos(25, 40)
		surface.DrawText(str1)
		
		surface.SetTextPos(w - 100, 40)
		surface.DrawText(str4)
		
		local tWidth2, tHeight2 = surface.GetTextSize(str2)
		surface.SetTextPos(25, 40 + tHeight)
		surface.DrawText(str2)
		
		surface.SetTextPos(w - 100, 40 + tHeight)
		surface.DrawText(str5)
		
		local tWidth3, tHeight3 = surface.GetTextSize(str3)
		surface.SetTextPos(25, 40 + tHeight + tHeight2)
		surface.DrawText(str3)
		
		surface.SetTextPos(w - 100, 40 + tHeight + tHeight2)
		surface.DrawText(str6)
		
	end
	
	slotsSpinButton = vgui.Create("DButton")
	slotsSpinButton:SetSize(200, 100)
	slotsSpinButton:SetPos(ScrW() - 200 - 25, ScrH() - 300 - 150 - 25)
	slotsSpinButton:SetText("")
	slotsSpinButton.Paint = function(self, w, h)
		
		surface.SetDrawColor(Color(0, 0, 0, 200))
		surface.DrawRect(0, 0, w, h)
		
		surface.SetDrawColor(Color(255, 191, 0))
		surface.DrawOutlinedRect(0, 0, w, h)
		surface.DrawOutlinedRect(1, 1, w-2, h-2)
		
		local text = "Spin"
		local tWidth, tHeight = surface.GetTextSize(text)
		surface.SetTextColor(Color(255, 255, 255, 255))
		surface.SetFont("slotsFont2")
		surface.SetTextPos(w/2 - tWidth/2, h/2 - tHeight/2)
		surface.DrawText(text)
		
	end
	slotsSpinButton.DoClick = function()
		
		if not LocalPlayer():CanAfford(slot:GetBetAmount()) then
			local popup = vgui.Create("nut_PopupMessage")
			popup:SetText("You can not afford the bet!")
			popup:SetButtonText("OK")
			return
		end
		
		net.Start("slotsSpinSlot")
		net.SendToServer()
		
		slotsSpinButton:SetDisabled(true)
		slotsPayoutButton:SetDisabled(true)
		slotsExitButton:SetDisabled(true)
		
		timer.Simple(4, function()
			if slotsSpinButton then
				slotsSpinButton:SetEnabled(true)
				slotsPayoutButton:SetEnabled(true)
				slotsExitButton:SetEnabled(true)
			end
		end)
		
	end
	
	slotsPayoutButton = vgui.Create("DButton")
	slotsPayoutButton:SetSize(200, 100)
	slotsPayoutButton:SetPos(ScrW() - 200 - 25, ScrH() - 200 - 125 - 25)
	slotsPayoutButton:SetText("")
	slotsPayoutButton.Paint = function(self, w, h)
		
		surface.SetDrawColor(Color(0, 0, 0, 200))
		surface.DrawRect(0, 0, w, h)
		
		surface.SetDrawColor(Color(255, 191, 0))
		surface.DrawOutlinedRect(0, 0, w, h)
		surface.DrawOutlinedRect(1, 1, w-2, h-2)
		
		local text = "Payouts"
		local tWidth, tHeight = surface.GetTextSize(text)
		surface.SetTextColor(Color(255, 255, 255, 255))
		surface.SetFont("slotsFont2")
		surface.SetTextPos(w/2 - tWidth/2, h/2 - tHeight/2)
		surface.DrawText(text)
		
	end
	slotsPayoutButton.DoClick = function()
		
		if slotsPayoutPane then
			if slotsPayoutPane:IsValid() then
				slotsPayoutPane:Remove()
			end
			slotsPayoutPane = nil
			return
		end
		
		slotsPayoutPane = vgui.Create("DPanel")
		slotsPayoutPane:SetSize(300, 380)
		slotsPayoutPane:SetPos(ScrW()/2 - 150, ScrH()/2 - 190)
		slotsPayoutPane.Paint = function(self, w, h)
			
			local text = "Slots Payouts"
			surface.SetFont("slotsFont1")
			local tWidth, tHeight = surface.GetTextSize(text)
			
			surface.SetDrawColor(Color(0, 0, 0, 230))
			surface.DrawRect(0, 0, w, tHeight * 3 / 2)
			
			surface.SetDrawColor(Color(245, 222, 179, 230))
			surface.DrawRect(0, tHeight * 3 / 2, w, h - tHeight * 3 / 2)
			
			surface.SetDrawColor(Color(255, 191, 0))
			surface.DrawOutlinedRect(0, 0, w, h)
			surface.DrawOutlinedRect(1, 1, w-2, h-2)
			
			surface.SetTextColor(Color(255, 191, 65))
			surface.SetTextPos(w/2 - tWidth/2, tHeight/2)
			surface.DrawText(text)
			
			surface.DrawRect(0, tHeight * 3 / 2, w, 3)
			
			local iconSize = 32
			-- cherries
			surface.SetMaterial(iconList[1].mat)
			surface.SetDrawColor(Color(255, 255, 255, 255))
			surface.SetTextColor(Color(0, 0, 0, 255))
			surface.SetFont("TargetID")
			-- 1x
			surface.DrawTexturedRect(25 + (iconSize + 2), 50, iconSize, iconSize)
			surface.SetTextPos(25 + 96 + 75, 58)
			surface.DrawText("Bet x2")
			-- 2x
			surface.DrawTexturedRect(25 + (iconSize + 2)/2, 50 + (iconSize + 2), iconSize, iconSize)
			surface.DrawTexturedRect(25 + (iconSize + 2) * 3 / 2, 50 + (iconSize + 2), iconSize, iconSize)
			surface.SetTextPos(25 + 96 + 75, 58 + (iconSize + 2))
			surface.DrawText("Bet x5")
			
			for k, v in pairs(iconList) do
				-- 3x
				surface.SetMaterial(v.mat)
				surface.DrawTexturedRect(25, 50 + (iconSize + 2) * (k+1), iconSize, iconSize)
				surface.DrawTexturedRect(25 + (iconSize + 2), 50 + (iconSize + 2) * (k+1), iconSize, iconSize)
				surface.DrawTexturedRect(25 + (iconSize + 2) * 2, 50 + (iconSize + 2) * (k+1), iconSize, iconSize)
				surface.SetTextPos(25 + 96 + 75, 58 + (iconSize + 2) * (k+1))
				surface.DrawText(v.text)
			end
			
		end
		
	end
	
	slotsExitButton = vgui.Create("DButton")
	slotsExitButton:SetSize(200, 100)
	slotsExitButton:SetPos(ScrW() - 200 - 25, ScrH() - 125 - 100)
	slotsExitButton:SetText("")
	slotsExitButton.Paint = function(self, w, h)
		
		surface.SetDrawColor(Color(0, 0, 0, 200))
		surface.DrawRect(0, 0, w, h)
		
		surface.SetDrawColor(Color(255, 191, 0))
		surface.DrawOutlinedRect(0, 0, w, h)
		surface.DrawOutlinedRect(1, 1, w-2, h-2)
		
		local text = "Exit"
		local tWidth, tHeight = surface.GetTextSize(text)
		surface.SetTextColor(Color(255, 255, 255, 255))
		surface.SetFont("slotsFont2")
		surface.SetTextPos(w/2 - tWidth/2, h/2 - tHeight/2)
		surface.DrawText(text)
		
	end
	slotsExitButton.DoClick = function()
	
		net.Start("slotsExitSlot")
		net.SendToServer()
		
	end
	
	gui.EnableScreenClicker(true)
end

local slotsAdminPane = nil
local slotsBetEntry = nil
local slotsAdminDeposit = nil
local slotsAdminWithdrawl = nil
local function toggleSlotsAdminGUI(slot, currentCash)

	if slotsAdminPane then
		
		if slotsAdminWithdrawl then
			if slotsAdminWithdrawl:IsValid() then
				slotsAdminWithdrawl:Remove()
			end
			slotsAdminWithdrawl = nil
		end
		
		if slotsAdminDeposit then
			if slotsAdminDeposit:IsValid() then
				slotsAdminDeposit:Remove()
			end
			slotsAdminDeposit = nil
		end
		
		if slotsBetEntry then
			if slotsBetEntry:IsValid() then
				slotsBetEntry:Remove()
			end
			slotsBetEntry = nil
		end
		
		if slotsAdminPane:IsValid() then
			slotsAdminPane:Remove()
		end
		slotsAdminPane = nil
		
		gui.EnableScreenClicker(false)
		
		return
	end
	
	slotsAdminPane = vgui.Create("DFrame")
	slotsAdminPane:SetSize(400, 170)
	slotsAdminPane:SetPos(ScrW()/2-200, ScrH()/2-85)
	slotsAdminPane.Paint = function(self, w, h)
		
		surface.SetFont("slotsFont2")
		local text = "Slots Maintenance"
		local tWidth, tHeight = surface.GetTextSize(text)
		
		surface.SetDrawColor(Color(0, 0, 0, 230))
		surface.DrawRect(0, 0, w, tHeight * 3 / 2)
		
		surface.SetDrawColor(Color(245, 222, 179, 230))
		surface.DrawRect(0, tHeight * 3 / 2, w, h - tHeight * 3 / 2)
		
		surface.SetDrawColor(Color(255, 191, 0))
		surface.DrawOutlinedRect(0, 0, w, h)
		surface.DrawOutlinedRect(1, 1, w-2, h-2)
		
		surface.SetTextColor(Color(255, 191, 65))
		surface.SetTextPos(w/2 - tWidth/2, tHeight/2)
		surface.DrawText(text)
		
		surface.DrawRect(0, tHeight * 3 / 2, w, 3)
		
		local machineCaps = currentCash
		local myCaps = LocalPlayer():GetMoney()
		surface.SetFont("TargetID")
		surface.SetTextColor(Color(0, 0, 0, 255))
		surface.SetTextPos(25, 50)
		surface.DrawText("Your Caps: ")
		
		surface.SetTextPos(125, 50)
		surface.DrawText(tostring(myCaps))
		
		surface.SetTextPos(25, 100)
		surface.DrawText("Machine Caps: ")
		
		surface.SetTextPos(125, 100)
		surface.DrawText(tostring(machineCaps))
		
		surface.SetTextPos(300, 65)
		surface.DrawText("Current Bet")
		
		surface.SetTextPos(290, 110)
		surface.DrawText("(1 < bet < 200)")
		
	end
	slotsAdminPane:SetTitle("")
	slotsAdminPane:MakePopup()
	slotsAdminPane.OnClose = function()
		toggleSlotsAdminGUI()
	end
	
	slotsBetEntry = vgui.Create("DTextEntry", slotsAdminPane)
	slotsBetEntry:SetSize(75, 25)
	slotsBetEntry:SetPos(300, 85)
	slotsBetEntry:SetNumeric(true)
	slotsBetEntry:SetValue(slot:GetBetAmount())
	slotsBetEntry.OnValueChange = function(self, value)
		
		if tonumber(value) < 1 then
			self:SetText("1")
			return
		elseif tonumber(value) > 200 then
			self:SetText("200")
			return
		end
		
		net.Start("slotsAdminSetBet")
			net.WriteUInt(slot:EntIndex(), 12)
			net.WriteInt(tonumber(value), 8)
		net.SendToServer()
		
	end
	
	slotsAdminDeposit = vgui.Create("DButton", slotsAdminPane)
	slotsAdminDeposit:SetSize(100, 30)
	slotsAdminDeposit:SetPos(30, 67.5)
	slotsAdminDeposit:SetText("")
	slotsAdminDeposit.Paint = function(self, w, h)
		surface.SetDrawColor(Color(0, 0, 0, 200))
		surface.DrawRect(0, 0, w, h)
		
		surface.SetDrawColor(Color(255, 191, 0))
		surface.DrawOutlinedRect(0, 0, w, h)
		surface.DrawOutlinedRect(1, 1, w-2, h-2)
		
		local text = "Deposit"
		local tWidth, tHeight = surface.GetTextSize(text)
		surface.SetTextColor(Color(255, 255, 255, 255))
		surface.SetFont("targetID")
		surface.SetTextPos(w/2 - tWidth/2, h/2 - tHeight/2)
		surface.DrawText(text)
	end
	slotsAdminDeposit.DoClick = function(self)
		self.popup = vgui.Create("DFrame")
		self.popup:SetSize(150, 75)
		self.popup:SetTitle("Enter Amount")
		self.popup:SetPos(ScrW()/2 - 70, ScrH()/2 + 10)
		self.popup:MakePopup()
		
		self.popup.textentry = vgui.Create("DTextEntry", self.popup)
		self.popup.textentry:SetSize(100, 25)
		self.popup.textentry:SetPos(25, 40)
		self.popup.textentry:SetNumeric(true)
		self.popup.textentry.OnValueChange = function(self, value)
			if (not value) or (value == "") then return end
			if tonumber(value) < 0 then
				self:SetText("0")
				return
			elseif tonumber(value) > LocalPlayer():GetMoney() then
				self:SetText(tostring(LocalPlayer():GetMoney()))
				return
			elseif tonumber(value) > (2^32 - 1) then
				self:SetText(tostring(2^32 - 1))
				return
			end
			
			currentCash = currentCash + value
			net.Start("slotsAdminDeposit")
				net.WriteUInt(slot:EntIndex(), 12)
				net.WriteInt(tonumber(value), 32)
			net.SendToServer()
			
			self:GetParent():Remove()
			self:Remove()
		end
	end
	
	slotsAdminWithdrawl = vgui.Create("DButton", slotsAdminPane)
	slotsAdminWithdrawl:SetSize(100, 30)
	slotsAdminWithdrawl:SetPos(30, 117.5)
	slotsAdminWithdrawl:SetText("")
	slotsAdminWithdrawl.Paint = function(self, w, h)
		surface.SetDrawColor(Color(0, 0, 0, 200))
		surface.DrawRect(0, 0, w, h)
		
		surface.SetDrawColor(Color(255, 191, 0))
		surface.DrawOutlinedRect(0, 0, w, h)
		surface.DrawOutlinedRect(1, 1, w-2, h-2)
		
		local text = "Withdrawl"
		local tWidth, tHeight = surface.GetTextSize(text)
		surface.SetTextColor(Color(255, 255, 255, 255))
		surface.SetFont("targetID")
		surface.SetTextPos(w/2 - tWidth/2, h/2 - tHeight/2)
		surface.DrawText(text)
	end
	slotsAdminWithdrawl.DoClick = function(self, value)
		self.popup = vgui.Create("DFrame")
		self.popup:SetSize(150, 75)
		self.popup:SetTitle("Enter Amount")
		self.popup:SetPos(ScrW()/2 - 70, ScrH()/2 + 10)
		self.popup:MakePopup()
		
		self.popup.textentry = vgui.Create("DTextEntry", self.popup)
		self.popup.textentry:SetSize(100, 25)
		self.popup.textentry:SetPos(25, 40)
		self.popup.textentry:SetNumeric(true)
		self.popup.textentry.OnValueChange = function(self, value)
			if (not value) or (value == "") then return end
			if tonumber(value) < 0 then
				self:SetText("0")
				return
			elseif tonumber(value) > currentCash then
				self:SetText(tostring(currentCash))
				return
			elseif tonumber(value) > (2^32 - 1) then
				self:SetText(tostring(2^32 - 1))
				return
			end
			
			currentCash = currentCash - value
			net.Start("slotsAdminWithdrawl")
				net.WriteUInt(slot:EntIndex(), 12)
				net.WriteInt(tonumber(value), 32)
			net.SendToServer()
			
			self:GetParent():Remove()
			self:Remove()
		end
	end
	
	slotsPlaySlots = vgui.Create("DButton", slotsAdminPane)
	slotsPlaySlots:SetSize(100, 30)
	slotsPlaySlots:SetPos(160, 65)
	slotsPlaySlots:SetText("")
	slotsPlaySlots.Paint = function(self, w, h)
		surface.SetDrawColor(Color(0, 0, 0, 200))
		surface.DrawRect(0, 0, w, h)
		
		surface.SetDrawColor(Color(255, 191, 0))
		surface.DrawOutlinedRect(0, 0, w, h)
		surface.DrawOutlinedRect(1, 1, w-2, h-2)
		
		local text = "Play Slots"
		local tWidth, tHeight = surface.GetTextSize(text)
		surface.SetTextColor(Color(255, 255, 255, 255))
		surface.SetFont("targetID")
		surface.SetTextPos(w/2 - tWidth/2, h/2 - tHeight/2)
		surface.DrawText(text)
	end
	slotsPlaySlots.DoClick = function(self)
		net.Start("slotsAdminPlay")
			net.WriteUInt(slot:EntIndex(), 12)
		net.SendToServer()
		toggleSlotsAdminGUI()
	end
	
	gui.EnableScreenClicker(true)
	
end

local function receiveSlotsAdminUsed(len)

	local entIndex = net.ReadUInt(12)
	local betAmount = net.ReadUInt(8)
	local currentCash = net.ReadInt(32)
	
	Entity(entIndex):SetBetAmount(betAmount)
	toggleSlotsAdminGUI(Entity(entIndex), currentCash)
	
end
net.Receive("slotsAdminUse", receiveSlotsAdminUsed)

local function receiveSlotsUsed(len)
	
	local entIndex = net.ReadUInt(12)
	local betAmount = 20
	
	if len > 12 then
		betAmount = net.ReadUInt(8)
		Entity(entIndex):SetBetAmount(betAmount)
	end
	
	Entity(entIndex).moneyEarned = 0
	toggleSlotsGUI(Entity(entIndex))
	
end
net.Receive("slotsOnUse", receiveSlotsUsed)

local function receiveSlotResult(len)
	
	local entIndex = net.ReadUInt(12)
	local seed = net.ReadUInt(32)
	
	local ent = Entity(entIndex)
	math.randomseed(seed)
	local int1 = math.random()
	local int2 = math.random()
	local int3 = math.random()
	math.randomseed(os.time())
	
	Entity(entIndex):SpinReels(int1, int2, int3)
	
end
net.Receive("slotsGetResult", receiveSlotResult)
