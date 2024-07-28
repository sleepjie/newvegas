AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

util.AddNetworkString("slotsAdminUse")
util.AddNetworkString("slotsAdminSetBet")
util.AddNetworkString("slotsAdminDeposit")
util.AddNetworkString("slotsAdminWithdrawl")
util.AddNetworkString("slotsAdminPlay")
util.AddNetworkString("slotsOnUse")
util.AddNetworkString("slotsGetResult")
util.AddNetworkString("slotsSpinSlot")
util.AddNetworkString("slotsExitSlot")

function ENT:Initialize()
	self:SetModel("models/newvegasprops/slots.mdl")
	
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_BBOX)
	
	self:PhysWake()
	
	self:SetUseType(SIMPLE_USE)
	
	self:SetBetAmount(20)
	self.moneyEarned = 0
	self.ownerList = {}
end

function ENT:SpinReels(int1, int2, int3)
	local ply = self.currentUser
	if not IsValid(ply) then return end
	
	local v1 = self:FindReelValue(self.reel1, int1)
	local v2 = self:FindReelValue(self.reel2, int2)
	local v3 = self:FindReelValue(self.reel3, int3)
	local payoutMul = self:CheckVictory(v1, v2, v3)
	timer.Simple(4.2, function()
		-- anything can happen in 4.2 seconds.....
		if not IsValid(ply) then return end
		self.moneyEarned = self.moneyEarned - payoutMul * self:GetBetAmount()
		ply:GiveMoney(payoutMul * self:GetBetAmount())
	end)
end

function ENT:AddOwner(owner)
	owner = owner.character:GetVar("id")
	if not table.HasValue(self.ownerList, owner) then
		table.insert(self.ownerList, owner)
	end
end

function ENT:GetOwners()
	return self.ownerList
end

function ENT:RemoveOwner(owner)
	owner = owner.character:GetVar("id")
	if table.HasValue(self.ownerList, owner) then
		table.RemoveByValue(self.ownerList, owner)
	end
end

function ENT:OnRemove()
	
end

function ENT:OnTakeDamage(dmginfo)
	
end

function ENT:Use(activator, caller)
	if IsValid(self.currentUser) then
		return
	end
	
	--admin menu
	if table.HasValue(self.ownerList, activator.character:GetVar("id")) then
		net.Start("slotsAdminUse")
			net.WriteUInt(self:EntIndex(), 12)
			net.WriteUInt(self:GetBetAmount(), 8)
			net.WriteInt(self.moneyEarned, 32)
		net.Send(activator)
		return
	end
	
	activator:Freeze(true)
	net.Start("slotsOnUse")
		net.WriteUInt(self:EntIndex(), 12)
		net.WriteUInt(self:GetBetAmount(), 8)
	net.Send(activator)
	self.currentUser = activator
	activator.slotMachine = self
end

function ENT:UpdateTransmitState()
	return TRANSMIT_PVS
end

function ENT:CheckOwnerStatus(ply)
	local c = ply.character
	local cID = 0
	if not c then return false end
	cID = c:GetVar("id")
	
	if not table.HasValue(self:GetOwners(), cID) then
		return false
	end
	
	return true
end

local function slotAdminSetBet(len, ply)
	local EntIndex = net.ReadUInt(12)
	local bet = net.ReadInt(8)
	local slot = Entity(EntIndex)
	
	if not IsValid(slot) then return end
	if not bet or not (type(bet) == "number") then return end
	
	slot:SetBetAmount(bet)
end
net.Receive("slotsAdminSetBet", slotAdminSetBet)

local function slotAdminDeposit(len, ply)
	local EntIndex = net.ReadUInt(12)
	local money = net.ReadInt(32)
	local slot = Entity(EntIndex)
	
	if not IsValid(slot) then return end
	if not money or not (type(money) == "number") then return end
	if not ply:CanAfford(money) then return end
	
	ply:TakeMoney(money)
	slot.moneyEarned = slot.moneyEarned + money
end
net.Receive("slotsAdminDeposit", slotAdminDeposit)

local function slotAdminWithdrawl(len, ply)
	local EntIndex = net.ReadUInt(12)
	local money = net.ReadInt(32)
	local slot = Entity(EntIndex)
	
	if not IsValid(slot) then return end
	if not money or not (type(money) == "number") then return end
	if not ((slot.moneyEarned - money) >= 0) then return end
	
	ply:GiveMoney(money)
	slot.moneyEarned = slot.moneyEarned - money
end
net.Receive("slotsAdminWithdrawl", slotAdminWithdrawl)

local function slotAdminPlay(len, ply)
	local EntIndex = net.ReadUInt(12)
	local slot = Entity(EntIndex)
	
	if IsValid(slot.currentUser) then
		return
	end
	
	ply:Freeze(true)
	net.Start("slotsOnUse")
		net.WriteUInt(EntIndex, 12)
		net.WriteUInt(Entity(EntIndex):GetBetAmount(), 8)
	net.Send(ply)
	slot.currentUser = ply
	ply.slotMachine = slot
end
net.Receive("slotsAdminPlay", slotAdminPlay)

local function slotsSpinSlot(len, ply)
	local slot = ply.slotMachine
	if not IsValid(slot) then
		ply.slotMachine = nil
		return
	end
	
	if not (slot.currentUser == ply) then 
		ply:Freeze(false)
		net.Start("slotsOnUse")
			net.WriteUInt(slot:EntIndex(), 12)
		net.Send(ply)
		ply.slotMachine = nil
		return
	end
	
	-- TODO: alert player that the slot machine is out of money, though hopefully this never happens
	if not ((slot.moneyEarned - slot:GetBetAmount()) > 0) then 
		netstream.Start(ply, "nut_PopupMessage", {"The machine is out of caps!", "OK"})
		return 
	end 
	
	-- TODO: alert player that they cannot afford the bet, hopefully thisll happen 
	if not ply:CanAfford(slot:GetBetAmount()) then 
		netstream.Start(ply, "nut_PopupMessage", {"You can not afford the bet!", "OK"})
		return 
	end
	
	local seed = math.floor(math.random() * slot:EntIndex() * CurTime())
	net.Start("slotsGetResult")
		net.WriteUInt(slot:EntIndex(), 12)
		net.WriteUInt(seed, 32)
	net.SendPVS(slot:GetPos())
	
	math.randomseed(seed)
	local int1 = math.random()
	local int2 = math.random()
	local int3 = math.random()
	math.randomseed(os.time())
	
	ply:TakeMoney(slot:GetBetAmount())
	slot.moneyEarned = slot.moneyEarned + slot:GetBetAmount()
	slot:SpinReels(int1, int2, int3)
end
net.Receive("slotsSpinSlot", slotsSpinSlot)

local function slotsExitSlot(len, ply)
	local slot = ply.slotMachine
	if not IsValid(slot) then
		ply.slotMachine = nil
		return 
	end
	
	ply:Freeze(false)
	net.Start("slotsOnUse")
		net.WriteUInt(slot:EntIndex(), 12)
	net.Send(ply)
	slot.currentUser = nil
	ply.slotMachine = nil
end
net.Receive("slotsExitSlot", slotsExitSlot)
