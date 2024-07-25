SCHEMA.name = "Fallout New Vegas RP"
SCHEMA.author = "Barata & Lazarus"

SCHEMA.desc = {"Burn away the flags. Begin again.", 
"Ring-a-Ding-Ding-Baby!", 
"For The Republic!", 
"The House Always Wins", 
"Ain't that a kick in the head?", 
"Back in The Saddle.", 
"Et Tu, Brute?", 
"Veni, Vidi, Vici!", 
"In hoc signo taurus vinces.", 
"Patrolling the Mojave almost makes me..", 
"The Meatballers Want Their Protection Money",
"War, war never changes.",
"If you want to see the fate of democracies, just look out the window.",
"Truth is, the game was rigged from the start.",
"Feed a man for free, he'll be back for more. Feed a man a bullet, you won't hear from him again.",
"War does not determine who is right, only who is left.",
"No Gods, No Masters.",
"Back in the Saddle!",
"Wonderful you came by!",
"You�ll Know It When It Happens.",
"Eureka!",
"All or Nothing!",
"Cold, Cold Heart.",
"That Lucky Old Sun.",
"My Kind of Town.",
"Come Fly With Me!",
"Don�t Tread on the Bear!",
"Crazy, Crazy, Crazy�",
"Nothin� But a Hound Dog.",
"I Forgot to Remember to Forget.",
"For Auld Lang Syne.",
"Old World Blues.",
"A smile can get you far, a gun can get you farther.",
"You and What Army?",
"Eyesight to the Blind.",
"Atom Bomb Baby!", "Caesar would be proud", "Bet all your 1000 chips for a faction"}

if (SERVER) then
	concommand.Remove("gm_save")
end

SCHEMA.uniqueID = "fallout"

nut.currency.SetUp("Cap", "Caps")

--nut.config.menuMusic = "music/hl1_song24.mp3"
nut.config.bigIntroText = "The Nevada Wastes"
nut.config.smallIntroText = SCHEMA.desc
nut.config.mainColor = Color(75, 75, 75)

nut.config.defaultModel = "models/thespireroleplay/humans/group100/"
nut.config.deathTime = 10

nut.config.priceMultiplier = 1

nut.config.showTypingText = false
nut.config.maxChars = 8

CLOTHES_FULLUPDATE = 0
CLOTHES_PARTIALUPDATE = 1
CLOTHES_DISCONNECTUPDATE = 2
CLOTHES_RELOAD = 3
CLOTHES_PURGE = 4
CLOTHES_REMOVE = 5
CLOTHES_WIPE = 6
CLOTHES_DRAW = 7
if (SERVER) then
	nut.config.canSuicide = false
	nut.config.defaultFlags = ""
	nut.config.fallDamageScale = 1
	nut.config.flashlight = false
	nut.config.startingAmount = 50
	nut.config.jumpPower = 128
	nut.config.allowVoice = false
	nut.config.voice3D = false
	nut.config.oocDelay = 0
	nut.config.clearMaps = false
	nut.config.noPersist = false
	nut.config.walkSpeed = 165
	nut.config.runSpeed = 300
	nut.config.showTime = false
	nut.config.BroadcastRange = 6942000
	nut.config.dateStartMonth = 10
	nut.config.dateStartDay = 31
	nut.config.dateStartYear = 2276
	nut.config.moneyModel = "models/props_lab/box01a.mdl"
end

nut.config.defaultInvWeight = 20

nut.util.Include("sv_hooks.lua")
nut.util.Include("sh_traits.lua")
nut.util.Include("sv_trade.lua")
nut.util.Include("sv_priviledgekeys.lua")
nut.util.Include("sv_itemcrates.lua")
nut.util.Include("sv_schema.lua")

nut.util.Include("cl_util.lua")
nut.util.Include("sh_selectspawn.lua")
nut.util.Include("sh_chems.lua")
nut.util.Include("sh_languages.lua")
nut.util.Include("sh_looting.lua")
nut.util.Include("sh_hooks.lua")
nut.util.Include("sh_robot.lua")
nut.util.Include("sh_itemdb.lua")
nut.util.Include("sh_medical.lua")
nut.util.Include("sh_commands.lua")
nut.util.Include("sh_currency.lua")
nut.util.Include("sh_flags.lua")
nut.util.Include("sh_customization.lua")
nut.util.Include("sh_voicedsuit.lua")

nut.util.Include("cl_hooks.lua")
nut.util.Include("cl_fonts.lua")
nut.util.Include("cl_names.lua")
nut.util.Include("cl_hud.lua")
nut.util.Include("cl_sounds.lua")
nut.util.Include("cl_cinematics.lua")
nut.util.Include("cl_charcreation.lua")
nut.util.Include("cl_contextmenu.lua")
nut.util.Include("cl_footstepsounds.lua")
nut.util.Include("cl_sais.lua")
nut.util.Include("cl_showspare.lua")

SCHEMA:RegisterTrait("p", "Power Armor Training", "Allows a character to wield power armor.")
SCHEMA:RegisterTrait("c", "Cannibal", "Allows mutilation of bodies or unconcious players.")
SCHEMA:RegisterTrait("v", "Hard Hitter", "Do more damage with fists.")
SCHEMA:RegisterTrait("b", "Pint Sized Slasher", "Do more damage with knives.")
SCHEMA:RegisterTrait("n", "Chain Smoker", "Immunity to teargas.")
SCHEMA:RegisterTrait("m", "Thick Skinned", "Grants an additional 2 DT.")
SCHEMA:RegisterTrait("a", "Black Widow", "Grants a +10% damage bonus to male targets.")
SCHEMA:RegisterTrait("s", "Lady Killer", "Grants a +10% damage bonus to female targets.")
SCHEMA:RegisterTrait("d", "Gun Nut", "Grants a +5% damage bonus while using a gun.")
SCHEMA:RegisterTrait("f", "Fortune Finder", "50% chance to drop a second lootcrate from the same series.")
SCHEMA:RegisterTrait("g", "Pyromaniac", "5% chance to ignite a target.")
SCHEMA:RegisterTrait("h", "Toughness", "Grants and additional 2 DT.")
SCHEMA:RegisterTrait("j", "Pack Mule", "Grants and additional 5 carryweight.")
SCHEMA:RegisterTrait("k", "Strong Back", "Grants and additional 5 carryweight.")
SCHEMA:RegisterMedicalCondition("fracture", "splint", "Fracture", {4,5,6,7}) -- splint
SCHEMA:RegisterMedicalCondition("bleeding", "bandage", "Bleeding", {1,2,3,4,5,6,7}) -- bandages
SCHEMA:RegisterMedicalCondition("lacerations", "suture", "Deep Cuts", {1,2,3,4,5,6,7}) -- suture needle
SCHEMA:RegisterMedicalCondition("burned2", "burncream", "Second Degree Burns", {1,2,3,4,5,6,7}) -- burn cream
SCHEMA:RegisterMedicalCondition("burned", "burncream", "Third Degree Burns", {1,2,3,4,5,6,7}) -- burn cream
SCHEMA:RegisterMedicalCondition("gunshot", "tweezers", "Gunshot Wounds", {1,2,3,4,5,6,7}) -- tweezers + suture needle
SCHEMA:RegisterMedicalCondition("crippled", "docbag", "Crippled", {1,2,3,4,5,6,7}) -- doctors bag
SCHEMA:RegisterMedicalCondition("shrapnel", "tweezers", "Shrapnel", {1,2,3,4,5,6,7}) -- tweezers + suture needle
SCHEMA:RegisterMedicalCondition("plasma", "burncream", "Plasma Burns", {1,2,3,4,5,6,7}) -- burn cream
SCHEMA:RegisterMedicalCondition("laser", "burncream", "Laser Burns", {1,2,3,4,5,6,7}) -- burn cream
SCHEMA:RegisterMedicalCondition("bruise", "painkillers", "Light Bruising", {1,2,3,4,5,6,7}) -- painkillers
SCHEMA:RegisterMedicalCondition("bruiseh", "painkillers", "Heavy Bruising", {1,2,3,4,5,6,7}) -- painkillers
SCHEMA:RegisterMedicalCondition("nosebreak", "painkillers", "Broken Nose", {1}) -- painkillers

if (CLIENT) then
	nut.config.debug = false
	nut.config.drawHUD = true
	nut.config.highvischat = true
	nut.config.lazzychat = true
	nut.config.maskoverlay = true
	nut.config.colorcorrection = true
end