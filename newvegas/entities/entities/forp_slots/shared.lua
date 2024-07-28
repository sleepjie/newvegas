
DEFINE_BASECLASS( "base_anim" )

ENT.PrintName		= "Slot Machine"
ENT.Author			= "thor / slivz"
ENT.Information		= "Just remember.. the house always wins."
ENT.Category		= "Fallout"

ENT.Editable		= false
ENT.Spawnable		= true
ENT.AdminOnly		= true
ENT.RenderGroup		= RENDERGROUP_BOTH

SLOTS_SPECIAL 	= -1
SLOTS_SPLIT 	= 0
SLOTS_CHERRY 	= 1
SLOTS_BELL 		= 2
SLOTS_BAR 		= 3
SLOTS_SEVEN 	= 4
SLOTS_LEMON 	= 5
SLOTS_GRAPE		= 6
SLOTS_ORANGE	= 7

ENT.Payout = {
	[SLOTS_SPECIAL] = {
		[0] = 0,
		[1] = 2,
		[2] = 5,
		[3] = 30,
	},
	[SLOTS_SPLIT] = 0,
	[SLOTS_CHERRY] = 30,
	[SLOTS_BELL] = 20,
	[SLOTS_BAR] = 40,
	[SLOTS_SEVEN] = 50,
	[SLOTS_LEMON] = 125,
	[SLOTS_GRAPE] = 250,
	[SLOTS_ORANGE] = 500,
}

--NOTE: each reel should have weights that sum up to 1!!
ENT.reel1 = {
	[1] = {sym = SLOTS_CHERRY, weight = 1/24},
	[2] = {sym = SLOTS_SPLIT, weight = 1/24},
	[3] = {sym = SLOTS_BAR, weight = 1/24},
	[4] = {sym = SLOTS_SPLIT, weight = 1/24},
	[5] = {sym = SLOTS_SEVEN, weight = 1/24},
	[6] = {sym = SLOTS_SPLIT, weight = 1/24},
	[7] = {sym = SLOTS_LEMON, weight = 1/24},
	[8] = {sym = SLOTS_SPLIT, weight = 1/24},
	[9] = {sym = SLOTS_BELL, weight = 1/24},
	[10] = {sym = SLOTS_SPLIT, weight = 1/24},
	[11] = {sym = SLOTS_CHERRY, weight = 1/24},
	[12] = {sym = SLOTS_SPLIT, weight = 1/24},
	[13] = {sym = SLOTS_SEVEN, weight = 1/24},
	[14] = {sym = SLOTS_SPLIT, weight = 1/24},
	[15] = {sym = SLOTS_BELL, weight = 1/24},
	[16] = {sym = SLOTS_SPLIT, weight = 1/24},
	[17] = {sym = SLOTS_GRAPE, weight = 1/24},
	[18] = {sym = SLOTS_SPLIT, weight = 1/24},
	[19] = {sym = SLOTS_BAR, weight = 1/24},
	[20] = {sym = SLOTS_SPLIT, weight = 1/24},
	[21] = {sym = SLOTS_ORANGE, weight = 1/24},
	[22] = {sym = SLOTS_SPLIT, weight = 1/24},
	[23] = {sym = SLOTS_BELL, weight = 1/24},
	[24] = {sym = SLOTS_SPLIT, weight = 1/24},
}
ENT.reel2 = {
	[1] = {sym = SLOTS_BELL, weight = 1/24},
	[2] = {sym = SLOTS_SPLIT, weight = 1/24},
	[3] = {sym = SLOTS_LEMON, weight = 1/24},
	[4] = {sym = SLOTS_SPLIT, weight = 1/24},
	[5] = {sym = SLOTS_SEVEN, weight = 1/24},
	[6] = {sym = SLOTS_SPLIT, weight = 1/24},
	[7] = {sym = SLOTS_CHERRY, weight = 1/24},
	[8] = {sym = SLOTS_SPLIT, weight = 1/24},
	[9] = {sym = SLOTS_BELL, weight = 1/24},
	[10] = {sym = SLOTS_SPLIT, weight = 1/24},
	[11] = {sym = SLOTS_BAR, weight = 1/24},
	[12] = {sym = SLOTS_SPLIT, weight = 1/24},
	[13] = {sym = SLOTS_ORANGE, weight = 1/24},
	[14] = {sym = SLOTS_SPLIT, weight = 1/24},
	[15] = {sym = SLOTS_BELL, weight = 1/24},
	[16] = {sym = SLOTS_SPLIT, weight = 1/24},
	[17] = {sym = SLOTS_BAR, weight = 1/24},
	[18] = {sym = SLOTS_SPLIT, weight = 1/24},
	[19] = {sym = SLOTS_SEVEN, weight = 1/24},
	[20] = {sym = SLOTS_SPLIT, weight = 1/24},
	[21] = {sym = SLOTS_GRAPE, weight = 1/24},
	[22] = {sym = SLOTS_SPLIT, weight = 1/24},
	[23] = {sym = SLOTS_CHERRY, weight = 1/24},
	[24] = {sym = SLOTS_SPLIT, weight = 1/24},
}
ENT.reel3 = {
	[1] = {sym = SLOTS_SEVEN, weight = 1/24},
	[2] = {sym = SLOTS_SPLIT, weight = 1/24},
	[3] = {sym = SLOTS_ORANGE, weight = 1/24},
	[4] = {sym = SLOTS_SPLIT, weight = 1/24},
	[5] = {sym = SLOTS_LEMON, weight = 1/24},
	[6] = {sym = SLOTS_SPLIT, weight = 1/24},
	[7] = {sym = SLOTS_BAR, weight = 1/24},
	[8] = {sym = SLOTS_SPLIT, weight = 1/24},
	[9] = {sym = SLOTS_CHERRY, weight = 1/24},
	[10] = {sym = SLOTS_SPLIT, weight = 1/24},
	[11] = {sym = SLOTS_BELL, weight = 1/24},
	[12] = {sym = SLOTS_SPLIT, weight = 1/24},
	[13] = {sym = SLOTS_GRAPE, weight = 1/24},
	[14] = {sym = SLOTS_SPLIT, weight = 1/24},
	[15] = {sym = SLOTS_SEVEN, weight = 1/24},
	[16] = {sym = SLOTS_SPLIT, weight = 1/24},
	[17] = {sym = SLOTS_BELL, weight = 1/24},
	[18] = {sym = SLOTS_SPLIT, weight = 1/24},
	[19] = {sym = SLOTS_BAR, weight = 1/24},
	[20] = {sym = SLOTS_SPLIT, weight = 1/24},
	[21] = {sym = SLOTS_BELL, weight = 1/24},
	[22] = {sym = SLOTS_SPLIT, weight = 1/24},
	[23] = {sym = SLOTS_CHERRY, weight = 1/24},
	[24] = {sym = SLOTS_SPLIT, weight = 1/24},
}
ENT.betAmount = 20

function ENT:SetBetAmount(num)
	if num > 200 then
		num = 200
	elseif num < 1 then
		num = 1
	end
	
	self.betAmount = num
end

function ENT:GetBetAmount()
	return self.betAmount
end

function ENT:FindReelValue(reel, i)
	
	local p = 0
	for k,v in pairs(reel) do
		local prevWeight = p
		p = p + v.weight
		if i <= p then
			return k
		end
	end
	
	ErrorNoHalt("FindReelValue returned no value from " .. i .. " (" .. p .. ")! Defaulting to index 1!")
	return 1
end

function ENT:CheckVictory(d1, d2, d3)
	
	local r1Value = self.reel1[d1].sym
	local r2Value = self.reel2[d2].sym
	local r3Value = self.reel3[d3].sym
	
	if r1Value == r2Value then
		if r2Value == r3Value then
			return self.Payout[r1Value]
		end
	end
	
	local cherryCount = 0
	if r1Value == SLOTS_CHERRY then cherryCount = cherryCount + 1 end
	if r2Value == SLOTS_CHERRY then cherryCount = cherryCount + 1 end
	if r3Value == SLOTS_CHERRY then cherryCount = cherryCount + 1 end
	
	return self.Payout[SLOTS_SPECIAL][cherryCount]
end