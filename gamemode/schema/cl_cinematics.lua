SCHEMA.IntroFrame = SCHEMA.IntroFrame or nil

concommand.Add("skipintro", function()
	SCHEMA.CinematicTransitionState = 0
	SCHEMA.CurrentFrame = 15
	SCHEMA.FrameTime = CurTime()
end)

SCHEMA.Frames = {
	[1] = {len = 3, image = "intro/frame1.png", narration = "vending_vintronarration_0016950c_1.ogg"},
	[2] = {len = 5, image = "intro/frame2.png", narration = "vending_vintronarration_0016950d_1.ogg"},
	[3] = {len = 9, image = "intro/frame3.png", narration = "vending_vintronarration_0016950e_1.ogg"},
	[4] = {len = 5, image = "intro/frame4.png", narration = "vending_vintronarration_0016950f_1.ogg"},
	[5] = {len = 7, image = "intro/frame5.png", narration = "vending_vintronarration_00169510_1.ogg"},
	[6] = {len = 10, image = "intro/frame6.png", narration = "vending_vintronarration_00169511_1.ogg"},
	[7] = {len = 8, image = "intro/frame7.png", narration = "vending_vintronarration_00169512_1.ogg"},
	[8] = {len = 7, image = "intro/frame8.png", narration = "vending_vintronarration_00169513_1.ogg"},
	[9] = {len = 5, image = "intro/frame9.png", narration = "vending_vintronarration_00169514_1.ogg"},
	[10] = {len = 6, image = "intro/frame9.png", narration = "vending_vintronarration_00169515_1.ogg"},
	[11] = {len = 8, image = "intro/frame11.png", narration = "vending_vintronarration_00169516_1.ogg"},
	[12] = {len = 6, image = "intro/frame12.png", narration = "vending_vintronarration_00169517_1.ogg"},
	[13] = {len = 7, image = "intro/frame13.png", narration = "vending_vintronarration_00169518_1.ogg"},
	[14] = {len = 4, image = "intro/frame14.png", narration = "vending_vintronarration_00169519_1.ogg"},
	[15] = {len = 4, image = "intro/frame14.png", narration = ""}
}

--precache the intro

util.PrecacheSound("intro/mus_inc_peaceful-024.ogg") 
util.PrecacheSound("fosounds/fix/mus_SCR_DocMitchell.mp3")

SCHEMA.CurrentFrame = SCHEMA.CurrentFrame or 0
SCHEMA.FrameMaterials = SCHEMA.FrameMaterials or {}
SCHEMA.FrameTime = SCHEMA.FrameTime or CurTime()

for k, v in pairs(SCHEMA.Frames) do
	SCHEMA.FrameMaterials[k] = Material(v.image)
end

function SCHEMA:PlayIntro()
	SCHEMA.IntroFrame = vgui.Create("DFrame")
	SCHEMA.IntroFrame:SetPos(ScrW(), ScrH())
	--SCHEMA.IntroFrame:Center()
	SCHEMA.IntroFrame:MakePopup()

	local lentotal = 0
	for k, v in pairs(SCHEMA.Frames) do
		lentotal = v.len + lentotal
	end
	SCHEMA.CinematicTransitionState = 0

	SCHEMA:PlayIntroSound("intro/"..SCHEMA.Frames[1].narration)
	SCHEMA:PlayIntroSound("fosounds/fix/mus_SCR_DocMitchell.mp3")
	
	SCHEMA.FrameTime = CurTime() + SCHEMA.Frames[1].len
	SCHEMA:PlayIntroSound("intro/"..SCHEMA.Frames[1].len)
	SCHEMA.CurrentFrame = 1
	
	SCHEMA:PlayIntroSound("intro/mus_inc_peaceful-024.ogg")
	
	hook.Add("Think", "IntroThink", function()
		if SCHEMA.FrameTime != 0 then
			if (SCHEMA.FrameTime < CurTime()) then
				SCHEMA:NextFrame()
				--SCHEMA:PlayIntroSound("intro/ui_loadscreen_initial.wav")
			end
		end
	end)
	
	hook.Add("HUDDrawScoreBoard", "RenderIntro", function()
		if SCHEMA.FrameMaterials[SCHEMA.CurrentFrame] then
			surface.SetMaterial(SCHEMA.FrameMaterials[SCHEMA.CurrentFrame])
		else
			surface.SetMaterial(SCHEMA.FrameMaterials[14])
		end
		surface.SetDrawColor(255,255,255,255)
		for i = 1, 30 do
			surface.DrawTexturedRect(0, 0, ScrW(), ScrH()) 
		end
	end)
end

function SCHEMA:NextFrame()
	SCHEMA.CurrentFrame = SCHEMA.CurrentFrame + 1
	if (SCHEMA.Frames[SCHEMA.CurrentFrame]) then
		SCHEMA.FrameTime = CurTime() + SCHEMA.Frames[SCHEMA.CurrentFrame].len + 1.5
		SCHEMA:PlayIntroSound("intro/"..SCHEMA.Frames[SCHEMA.CurrentFrame].narration)
	elseif (SCHEMA.CinematicTransitionState == 0) then
		SCHEMA.CinematicTransitionState = 1
		local fade = vgui.Create("nsFade")
		fade:SetPos(0,0)
		fade:SetSize(ScrW(), ScrH())
		fade:SetImage("forp/black.png")
		fade:FadeIn(2)
		timer.Simple(2, function()
			fade:FadeOut(0.1)
			timer.Simple(0.1, function()
				fade:Remove()
			end)
			SCHEMA:CreateCharacter()
			SCHEMA.FrameTime = 0
			hook.Remove("Think", "IntroThink")
			hook.Remove("HUDDrawScoreBoard", "RenderIntro")
			SCHEMA.IntroFrame:Remove()
		end)
		SCHEMA:PlayIntroSound("intro/mus_endgametransitionstinger.ogg")
	end
end

function SCHEMA:PlayIntroSound(path)
	path = "sound/"..path
	sound.PlayFile(path, "", function(station)
		if (IsValid(station)) then
			station:Play()
		end
	end) 
end