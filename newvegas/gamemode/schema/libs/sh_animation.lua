--[[
	Purpose: A library to specify which animations should be used by which models and
	contains tables that provide the appropriate act or sequence that is to be used.
--]]

nut.anim = nut.anim or {}
nut.anim.classes = nut.anim.classes or {}

--[[
	Purpose: Adds a new model to a class. If the class does not exist, a table will be created
	automatically.
--]]
function nut.anim.SetModelClass(class, model)
	model = string.lower(model)

	nut.anim.classes[model] = class
end

--[[
	Purpose: Translates the model and returns the animation class.
--]]
function nut.anim.GetClass(model)
	return nut.anim.classes[model] or (string.find(model, "female") and "citizen_female" or "citizen_male")
end

--[[
	Purpose: Quick utility function that automatically includes the groups of citizens
	based off the gender provided.
--]]
local function defineCitizenClass(prefix)
	for k, v in pairs(file.Find("models/humans/group01/"..prefix.."_*.mdl", "GAME")) do
		nut.anim.SetModelClass("citizen_"..prefix, "models/humans/group01/"..v)
	end

	for k, v in pairs(file.Find("models/humans/group02/"..prefix.."_*.mdl", "GAME")) do
		nut.anim.SetModelClass("citizen_"..prefix, "models/humans/group02/"..v)
	end

	for k, v in pairs(file.Find("models/humans/group03/"..prefix.."_*.mdl", "GAME")) do
		nut.anim.SetModelClass("citizen_"..prefix, "models/humans/group03/"..v)
	end

	for k, v in pairs(file.Find("models/humans/group03m/"..prefix.."_*.mdl", "GAME")) do
		nut.anim.SetModelClass("citizen_"..prefix, "models/humans/group03m/"..v)
	end
end

defineCitizenClass("male")
defineCitizenClass("female")

nut.anim.SetModelClass("citizen_female", "models/mossman.mdl")
nut.anim.SetModelClass("citizen_female", "models/alyx.mdl")

nut.anim.SetModelClass("metrocop", "models/police.mdl")

nut.anim.SetModelClass("overwatch", "models/combine_super_soldier.mdl")
nut.anim.SetModelClass("overwatch", "models/combine_soldier_prisonguard.mdl")
nut.anim.SetModelClass("overwatch", "models/combine_soldier.mdl")

nut.anim.SetModelClass("vort", "models/vortigaunt.mdl")
nut.anim.SetModelClass("vort", "models/vortigaunt_slave.mdl")

nut.anim.SetModelClass("metrocop", "models/dpfilms/metropolice/playermodels/pm_skull_police.mdl")

-- Male citizen animation tree.
nut.anim.citizen_male = {
	normal = {
		idle 					=	{ACT_IDLE, ACT_IDLE_ANGRY_SMG1},
		idle_crouch 			=	{ACT_COVER_LOW, ACT_COVER_LOW},
		walk 					=	{ACT_WALK, ACT_WALK_AIM_RIFLE_STIMULATED},
		walk_crouch 			=	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		run 					=	{"run_all", ACT_RUN_AIM_RIFLE_STIMULATED},

		idle_panicked 			=	{"crouchIdle_panicked4", "Crouch_Idle_RPG"},
		run_panicked 			=	{"crouchRUNALL1", "crouchRUNHOLDINGALL1"},
		walk_panicked 			=	{"walk_panicked_all", "walk_panicked_all"},
		walk_panicked_crouch 	=	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		idle_panicked_crouch 	=	{ACT_COVER_LOW, ACT_COVER_LOW},

		idle_depressed 			=	{"LineIdle02", ACT_IDLE_ANGRY_SMG1},
		run_depressed 			=	{"run_all", ACT_RUN_AIM_RIFLE_STIMULATED},
		walk_depressed 			=	{"pace_all", ACT_WALK_AIM_RIFLE_STIMULATED},
		walk_depressed_crouch 	=	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		idle_depressed_crouch 	=	{ACT_COVER_LOW, ACT_COVER_LOW}

	},
	pistol = {
		idle 					= 	{ACT_IDLE, ACT_IDLE_ANGRY_SMG1},
		idle_crouch 			= 	{ACT_COVER_LOW, "crouch_aim_smg1"},
		walk 					= 	{ACT_WALK, ACT_WALK_AIM_RIFLE_STIMULATED},
		walk_crouch 			= 	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		run 					= 	{ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},
		attack 					= 	ACT_GESTURE_RANGE_ATTACK_PISTOL,
		reload 					= 	ACT_GESTURE_RELOAD_SMG1,

		idle_panicked 			= 	{"crouchIdle_panicked4", "crouch_aim_smg1"},
		run_panicked 			= 	{"crouch_run_holding_RPG_all", "crouchRUNHOLDINGALL1"},
		walk_panicked 			= 	{"walk_panicked_all", "Crouch_walk_aiming_all"},
		walk_panicked_crouch 	= 	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		idle_panicked_crouch 	= 	{ACT_COVER_LOW, ACT_COVER_LOW},

		idle_depressed 			= 	{ACT_IDLE, ACT_IDLE_ANGRY_SMG1},	
		run_depressed 			= 	{ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},
		walk_depressed 			= 	{ACT_WALK, ACT_WALK_AIM_RIFLE_STIMULATED},
		walk_depressed_crouch 	=	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		idle_depressed_crouch 	=	{ACT_COVER_LOW, "crouch_aim_smg1"}
	},
	ar2 = {
		idle 					= 	{ACT_IDLE_SHOTGUN_RELAXED, ACT_IDLE_ANGRY_RPG},
		idle_crouch 			= 	{ACT_COVER_LOW_RPG,  "crouch_aim_smg1"},
		walk 					= 	{ACT_WALK_RPG,  ACT_WALK_AIM_RIFLE_STIMULATED},
		walk_crouch 			= 	{ACT_WALK_CROUCH, "Crouch_walk_aiming_all"},
		run 					= 	{ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},
		attack 					= 	ACT_GESTURE_RANGE_ATTACK_SNIPER_RIFLE,
		reload 					= 	ACT_GESTURE_RELOAD_SMG1,

		idle_panicked 			= 	{"crouchIdle_panicked4", "crouch_aim_smg1"},
		run_panicked 			= 	{"crouch_run_holding_RPG_all", "crouchRUNHOLDINGALL1"},
		walk_panicked 			= 	{"walk_panicked_all", "Crouch_walk_aiming_all"},
		walk_panicked_crouch 	= 	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		idle_panicked_crouch 	= 	{ACT_COVER_LOW, ACT_COVER_LOW},

		idle_depressed 			= 	{ACT_IDLE, ACT_IDLE_ANGRY_SMG1},	
		run_depressed 			= 	{ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},
		walk_depressed 			= 	{ACT_WALK, ACT_WALK_AIM_RIFLE_STIMULATED},
		walk_depressed_crouch 	=	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		idle_depressed_crouch 	=	{ACT_COVER_LOW, "crouch_aim_smg1"}
	},
	smg = {
		idle 					= 	{ACT_IDLE_SMG1_RELAXED, ACT_IDLE_ANGRY_SMG1},
		idle_crouch 			= 	{ACT_COVER_LOW, "crouch_aim_smg1"},
		walk 					= 	{ACT_WALK_RIFLE_RELAXED, ACT_WALK_AIM_RIFLE_STIMULATED},
		walk_crouch 			= 	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		run 					= 	{ACT_RUN_RIFLE_RELAXED, ACT_RUN_AIM_RIFLE_STIMULATED},
		attack 					= 	ACT_GESTURE_RANGE_ATTACK_SMG1,
		reload 					= 	ACT_GESTURE_RELOAD_SMG1,

		idle_panicked 			= 	{"crouchIdle_panicked4", "crouch_aim_smg1"},
		run_panicked 			= 	{"crouch_run_holding_RPG_all", "crouchRUNHOLDINGALL1"},
		walk_panicked 			= 	{"Crouch_walk_holding_RPG_all", "Crouch_walk_aiming_all"},
		walk_panicked_crouch 	= 	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		idle_panicked_crouch 	= 	{ACT_COVER_LOW, ACT_COVER_LOW},

		idle_depressed 			= 	{ACT_IDLE, ACT_IDLE_ANGRY_SMG1},	
		run_depressed 			= 	{ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},
		walk_depressed 			= 	{ACT_WALK, ACT_WALK_AIM_RIFLE_STIMULATED},
		walk_depressed_crouch 	=	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		idle_depressed_crouch 	=	{ACT_COVER_LOW, "crouch_aim_smg1"}
	},
	shotgun = {
		idle 					= 	{ACT_IDLE_SHOTGUN_RELAXED, ACT_IDLE_ANGRY_SMG1},
		idle_crouch 			= 	{ACT_COVER_LOW, "crouch_aim_smg1"},
		walk 					= 	{ACT_WALK_RIFLE_RELAXED, ACT_WALK_AIM_RIFLE_STIMULATED},
		walk_crouch 			= 	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		run 					= 	{ACT_RUN_RIFLE_RELAXED, ACT_RUN_AIM_RIFLE_STIMULATED},
		attack 					= 	ACT_GESTURE_RANGE_ATTACK_SHOTGUN,

		idle_panicked 			= 	{"crouchIdle_panicked4", "crouch_aim_smg1"},
		run_panicked 			= 	{"crouch_run_holding_RPG_all", "crouchRUNHOLDINGALL1"},
		walk_panicked 			= 	{"Crouch_walk_holding_RPG_all", "Crouch_walk_aiming_all"},
		walk_panicked_crouch 	= 	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		idle_panicked_crouch 	= 	{ACT_COVER_LOW, ACT_COVER_LOW},

		idle_depressed 			= 	{ACT_IDLE, ACT_IDLE_ANGRY_SMG1},	
		run_depressed 			= 	{ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},
		walk_depressed 			= 	{ACT_WALK, ACT_WALK_AIM_RIFLE_STIMULATED},
		walk_depressed_crouch 	=	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		idle_depressed_crouch 	=	{ACT_COVER_LOW, "crouch_aim_smg1"}
	},
	grenade = {
		idle 					= 	{ACT_IDLE, ACT_IDLE_MANNEDGUN},
		idle_crouch 			= 	{ACT_COVER_LOW, "crouch_aim_smg1"},
		walk 					= 	{ACT_WALK, ACT_WALK_AIM_RIFLE},
		walk_crouch 			= 	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		run 					= 	{ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},
		attack 					= 	ACT_RANGE_ATTACK_THROW,

		idle_panicked 			= 	{"crouchIdle_panicked4", "crouch_aim_smg1"},
		run_panicked 			= 	{"crouch_run_holding_RPG_all", "crouchRUNHOLDINGALL1"},
		walk_panicked 			= 	{"Crouch_walk_holding_RPG_all", "Crouch_walk_aiming_all"},
		walk_panicked_crouch 	= 	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		idle_panicked_crouch 	= 	{ACT_COVER_LOW, ACT_COVER_LOW},

		idle_depressed 			= 	{ACT_IDLE, ACT_IDLE_ANGRY_SMG1},	
		run_depressed 			= 	{ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},
		walk_depressed 			= 	{ACT_WALK, ACT_WALK_AIM_RIFLE_STIMULATED},
		walk_depressed_crouch 	=	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		idle_depressed_crouch 	=	{ACT_COVER_LOW, "crouch_aim_smg1"}
	},
	melee = {
		idle 					= 	{ACT_IDLE_SUITCASE, ACT_IDLE_ANGRY_MELEE},
		idle_crouch 			= 	{ACT_COVER_LOW, "crouch_aim_smg1"},
		walk 					= 	{ACT_WALK, ACT_WALK_AIM_RIFLE},
		walk_crouch 			= 	{ACT_WALK_CROUCH, ACT_WALK_CROUCH},
		run 					= 	{ACT_RUN, ACT_RUN},
		attack 					= 	ACT_MELEE_ATTACK_SWING,

		idle_panicked 			= 	{"crouchIdle_panicked4", "crouch_aim_smg1"},
		run_panicked 			= 	{"crouch_run_holding_RPG_all", "crouchRUNHOLDINGALL1"},
		walk_panicked 			= 	{"walk_panicked_all", "Crouch_walk_aiming_all"},
		walk_panicked_crouch 	= 	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		idle_panicked_crouch 	= 	{ACT_COVER_LOW, ACT_COVER_LOW},

		idle_depressed 			= 	{ACT_IDLE, ACT_IDLE_ANGRY_SMG1},	
		run_depressed 			= 	{ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},
		walk_depressed 			= 	{ACT_WALK, ACT_WALK_AIM_RIFLE_STIMULATED},
		walk_depressed_crouch 	=	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		idle_depressed_crouch 	=	{ACT_COVER_LOW, "crouch_aim_smg1"}
	},
	glide = ACT_GLIDE
}

-- Female citizen animation tree.
nut.anim.citizen_female = {
	normal = {
		idle 					=	{ACT_IDLE, ACT_IDLE_ANGRY_SMG1},
		idle_crouch 			=	{ACT_COVER_LOW, ACT_COVER_LOW},
		walk 					=	{ACT_WALK, ACT_WALK_AIM_RIFLE_STIMULATED},
		walk_crouch 			=	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		run 					=	{ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},

		idle_panicked 			=	{"crouch_panicked", "Crouch_Idle_RPG"},
		run_panicked 			=	{"run_panicked3__all", "crouchRUNHOLDINGALL1"},
		walk_panicked 			=	{"Crouch_walk_all", "Crouch_walk_all"},
		walk_panicked_crouch 	=	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		idle_panicked_crouch 	=	{ACT_COVER_LOW, ACT_COVER_LOW},

		idle_depressed 			=	{"LineIdle01", ACT_IDLE_ANGRY_SMG1},
		run_depressed 			=	{"run_all", ACT_RUN_AIM_RIFLE_STIMULATED},
		walk_depressed 			=	{"walk_all_Moderate", ACT_WALK_AIM_RIFLE_STIMULATED},
		walk_depressed_crouch 	=	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		idle_depressed_crouch 	=	{ACT_COVER_LOW, ACT_COVER_LOW}
	},
	pistol = {
		idle 					= 	{"Pistol_idle", "Pistol_idle_aim"},
		idle_crouch 			=	{ACT_COVER_LOW, "crouch_aim_smg1"},
		walk 					= 	{ACT_WALK, ACT_WALK_AIM_PISTOL},
		walk_crouch 			= 	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_PISTOL},
		run 					= 	{ACT_RUN, ACT_RUN_AIM_PISTOL},
		attack 					= 	ACT_GESTURE_RANGE_ATTACK_PISTOL,
		reload 					= 	ACT_GESTURE_RELOAD_SMG1,

		idle_panicked 			= 	{"idlepackage", "Pistol_idle_aim"},
		run_panicked 			= 	{"crouch_run_holding_RPG_all", "crouchRUNHOLDINGALL1"},
		walk_panicked 			= 	{"walk_holding_package_all", "Crouch_walk_aiming_all"},
		walk_panicked_crouch 	= 	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		idle_panicked_crouch 	= 	{ACT_COVER_LOW, "crouch_aim_smg1"},

		idle_depressed 			= 	{"Pistol_idle", "Pistol_idle_aim"},	
		run_depressed 			= 	{ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},
		walk_depressed 			= 	{"walk_all", ACT_WALK_AIM_RIFLE_STIMULATED},
		walk_depressed_crouch 	=	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		idle_depressed_crouch 	=	{ACT_COVER_LOW, "crouch_aim_smg1"}
	},
	smg = {
		idle 					=	{ACT_IDLE_SMG1_RELAXED, ACT_IDLE_ANGRY_SMG1},
		idle_crouch 			=	{ACT_COVER_LOW, "crouch_aim_smg1"},
		walk 					=	{ACT_WALK_RIFLE_RELAXED, ACT_WALK_AIM_RIFLE_STIMULATED},
		walk_crouch 			=	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		run 					= 	{ACT_RUN_RIFLE_RELAXED, ACT_RUN_AIM_RIFLE_STIMULATED},
		attack 					=	ACT_GESTURE_RANGE_ATTACK_SMG1,
		reload 					=	ACT_GESTURE_RELOAD_SMG1,

		idle_panicked 			= 	{"crouch_panicked", "crouch_aim_smg1"},
		run_panicked 			= 	{"crouch_run_holding_RPG_all", "crouchRUNHOLDINGALL1"},
		walk_panicked 			= 	{"Crouch_walk_holding_RPG_all", "Crouch_walk_aiming_all"},
		walk_panicked_crouch 	= 	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		idle_panicked_crouch 	= 	{ACT_COVER_LOW, "crouch_aim_smg1"},

		idle_depressed 			= 	{ACT_IDLE, ACT_IDLE_ANGRY_SMG1},	
		run_depressed 			= 	{ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},
		walk_depressed 			= 	{ACT_WALK, ACT_WALK_AIM_RIFLE_STIMULATED},
		walk_depressed_crouch 	=	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		idle_depressed_crouch 	=	{ACT_COVER_LOW, "crouch_aim_smg1"}
	},
	ar2 = {
		idle 					= 	{ACT_IDLE_SHOTGUN_RELAXED, ACT_IDLE_ANGRY_RPG},
		idle_crouch 			= 	{ACT_COVER_LOW_RPG,  "crouch_aim_smg1"},
		walk 					= 	{ACT_WALK_RPG,  ACT_WALK_AIM_RIFLE_STIMULATED},
		walk_crouch 			= 	{ACT_WALK_CROUCH, "Crouch_walk_aiming_all"},
		run 					= 	{ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},
		attack 					= 	ACT_GESTURE_RANGE_ATTACK_SNIPER_RIFLE,
		reload 					= 	ACT_GESTURE_RELOAD_SMG1,

		idle_panicked 			= 	{"crouchIdle_panicked4", "crouch_aim_smg1"},
		run_panicked 			= 	{"crouch_run_holding_RPG_all", "crouchRUNHOLDINGALL1"},
		walk_panicked 			= 	{"walk_panicked_all", "Crouch_walk_aiming_all"},
		walk_panicked_crouch 	= 	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		idle_panicked_crouch 	= 	{ACT_COVER_LOW, ACT_COVER_LOW},

		idle_depressed 			= 	{ACT_IDLE, ACT_IDLE_ANGRY_SMG1},	
		run_depressed 			= 	{ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},
		walk_depressed 			= 	{ACT_WALK, ACT_WALK_AIM_RIFLE_STIMULATED},
		walk_depressed_crouch 	=	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		idle_depressed_crouch 	=	{ACT_COVER_LOW, "crouch_aim_smg1"}
	},
	shotgun = {
		idle 					=	{ACT_IDLE_SHOTGUN_RELAXED, ACT_IDLE_ANGRY_SMG1},
		idle_crouch 			=	{ACT_COVER_LOW, "crouch_aim_smg1"},
		walk 					=	{ACT_WALK_RIFLE_RELAXED, ACT_WALK_AIM_RIFLE_STIMULATED},
		walk_crouch 			=	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		run 					=	{ACT_RUN_RIFLE_RELAXED, ACT_RUN_AIM_RIFLE_STIMULATED},
		attack 					=	ACT_GESTURE_RANGE_ATTACK_SHOTGUN,

		idle_panicked 			= 	{"crouch_panicked", "crouch_aim_smg1"},
		run_panicked 			= 	{"crouch_run_holding_RPG_all", "crouchRUNHOLDINGALL1"},
		walk_panicked 			= 	{"Crouch_walk_holding_RPG_all", "Crouch_walk_aiming_all"},
		walk_panicked_crouch 	= 	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		idle_panicked_crouch 	= 	{ACT_COVER_LOW, "crouch_aim_smg1"},

		idle_depressed 			= 	{ACT_IDLE, ACT_IDLE_ANGRY_SMG1},	
		run_depressed 			= 	{ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},
		walk_depressed 			= 	{ACT_WALK, ACT_WALK_AIM_RIFLE_STIMULATED},
		walk_depressed_crouch 	=	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		idle_depressed_crouch 	=	{ACT_COVER_LOW, "crouch_aim_smg1"}
	},
	grenade = {
		idle 					=	{ACT_IDLE, ACT_IDLE_ANGRY_SMG1},
		idle_crouch 			=	{ACT_COVER_LOW, "crouch_aim_smg1"},
		walk 					=	{ACT_WALK, ACT_WALK_AIM_RIFLE_STIMULATED},
		walk_crouch 			=	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		run 					=	{ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},
		attack 					=	ACT_RANGE_ATTACK_THROW,

		idle_panicked 			= 	{"crouch_panicked", "crouch_aim_smg1"},
		run_panicked 			= 	{"crouch_run_holding_RPG_all", "crouchRUNHOLDINGALL1"},
		walk_panicked 			= 	{"Crouch_walk_holding_RPG_all", "Crouch_walk_aiming_all"},
		walk_panicked_crouch 	= 	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		idle_panicked_crouch 	= 	{ACT_COVER_LOW, "crouch_aim_smg1"},

		idle_depressed 			= 	{ACT_IDLE, ACT_IDLE_ANGRY_SMG1},	
		run_depressed 			= 	{ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},
		walk_depressed 			= 	{ACT_WALK, ACT_WALK_AIM_RIFLE_STIMULATED},
		walk_depressed_crouch 	=	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		idle_depressed_crouch 	=	{ACT_COVER_LOW, "crouch_aim_smg1"}
	},
	melee = {
		idle 					=	{ACT_IDLE, ACT_IDLE_MANNEDGUN},
		idle_crouch 			=	{ACT_COVER_LOW, "crouch_aim_smg1"},
		walk 					=	{ACT_WALK, ACT_WALK_AIM_RIFLE},
		walk_crouch 			=	{ACT_WALK_CROUCH, ACT_WALK_CROUCH},
		run 					=	{ACT_RUN, ACT_RUN},
		attack 					=	ACT_MELEE_ATTACK_SWING,

		idle_panicked 			= 	{"crouch_panicked", "crouch_aim_smg1"},
		run_panicked 			= 	{"crouch_run_holding_RPG_all", "crouchRUNHOLDINGALL1"},
		walk_panicked 			= 	{"Crouch_walk_holding_RPG_all", "Crouch_walk_aiming_all"},
		walk_panicked_crouch 	= 	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		idle_panicked_crouch 	= 	{ACT_COVER_LOW, "crouch_aim_smg1"},

		idle_depressed 			= 	{ACT_IDLE, ACT_IDLE_ANGRY_SMG1},	
		run_depressed 			= 	{ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},
		walk_depressed 			= 	{ACT_WALK, ACT_WALK_AIM_RIFLE_STIMULATED},
		walk_depressed_crouch 	=	{ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		idle_depressed_crouch 	=	{ACT_COVER_LOW, "crouch_aim_smg1"}
	},
	glide = ACT_GLIDE
}

local playerMeta = FindMetaTable("Player")

if (SERVER) then
	function playerMeta:SetOverrideSeq(sequence, time, startCallback, finishCallback)
		local realSeq, duration = self:LookupSequence(sequence)
		time = time or duration

		if (!realSeq or realSeq == -1) then
			return
		end
		
		self:SetNetVar("seq", sequence)

		if (startCallback) then
			startCallback()
		end

		if (time > 0) then
			timer.Create("nut_Seq"..self:UniqueID(), time, 1, function()
				if (IsValid(self)) then
					self:ResetOverrideSeq()

					if (finishCallback) then
						finishCallback()
					end
				end
			end)
		end

		return time, realSeq
	end

	function playerMeta:ResetOverrideSeq()
		self:SetNetVar("seq", false)
	end
end

function playerMeta:GetOverrideSeq()
	return self:GetNetVar("seq", false)
end

function playerMeta:GetGender()
	local model = string.lower(self:GetModel())
	local gender = "male"
	
	if (string.find(model, "female") or nut.anim.GetClass(model) == "citizen_female") then
		gender = "female"
	end
	
	return gender
end

WEAPON_LOWERED = 1
WEAPON_RAISED = 2

local math_NormalizeAngle = math.NormalizeAngle
local string_find = string.find
local string_lower = string.lower
local getAnimClass = nut.anim.GetClass
local getHoldType = nut.util.GetHoldType
local config = nut.config

local Length2D = FindMetaTable("Vector").Length2D

function GM:CalcMainActivity(client, velocity)
	local model = string_lower(client:GetModel())
	local class = getAnimClass(model)

	if (string_find(model, "/player/") or string_find(model, "/playermodel") or class == "player") then
		return self.BaseClass:CalcMainActivity(client, velocity)
	end

	if (client.character and client:Alive()) then
		client.CalcSeqOverride = -1

		local weapon = client:GetActiveWeapon()
		local holdType = "normal"
		local action = "idle"
		local length2D = Length2D(velocity)

		local mood = client:GetNetVar("mood")
		local panicked, depressed = false, false

		if mood == "depressed" then
			depressed = true
		elseif mood == "panicked" then
			panicked = true
		end

		if panicked then
			action = "idle_panicked"
		elseif depressed then
			action = "idle_depressed"
		else
			action = "idle"
		end

		if (length2D >= config.runSpeed - 10) then
			if panicked then
				action = "run_panicked"
			elseif depressed then
				action = "run_depressed"
			else
				action = "run"
			end
		elseif (length2D >= 5) then
			if panicked then
				action = "walk_panicked"
			elseif depressed then
				action = "walk_depressed"
			else
				action = "walk"
			end
		end

		if (client:Crouching()) then
			action = action.."_crouch"
		end

		local state = WEAPON_LOWERED

		if (IsValid(weapon)) then
			holdType = getHoldType(weapon)

			if (weapon.AlwaysRaised or config.alwaysRaised[weapon:GetClass()]) then
				state = WEAPON_RAISED
			end
		end

		if (client:WepRaised()) then
			state = WEAPON_RAISED
		end
		
		local animClass = nut.anim[class]

		if (!animClass) then
			class = "citizen_male"
		end

		if (!animClass[holdType]) then
			holdType = "normal"
		end

		if (!animClass[holdType][action]) then
			action = "idle"
		end

		local animation = animClass[holdType][action]
		local value = ACT_IDLE

		if (!client:OnGround()) then
			client.CalcIdeal = animClass.glide or ACT_GLIDE
		elseif (client:InVehicle()) then
			client.CalcIdeal = animClass.normal.idle_crouch[1]
		elseif (animation) then
			value = animation[state]

			if (type(value) == "string") then
				client.CalcSeqOverride = client:LookupSequence(value)
			else
				client.CalcIdeal = value
			end
		end

		local override = client:GetNetVar("seq")

		if (override) then
			client.CalcSeqOverride = client:LookupSequence(override)
		end

		if (CLIENT) then
			client:SetIK(false)
		end

		local eyeAngles = client:EyeAngles()
		local yaw = velocity:Angle().yaw
		local normalized = math_NormalizeAngle(yaw - eyeAngles.y)

		client:SetPoseParameter("move_yaw", normalized)

		return client.CalcIdeal or ACT_IDLE, client.CalcSeqOverride or -1
	end
end