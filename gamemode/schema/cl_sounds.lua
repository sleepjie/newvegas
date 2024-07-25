local AREA_MOJAVE = 1
local AREA_SPECIAL = 2
local AREA_CREEPY = 3

SCHEMA.music = {}
SCHEMA.music[AREA_MOJAVE] = {}
SCHEMA.music[AREA_SPECIAL]= {}
SCHEMA.music[AREA_CREEPY] = {}

local dir = "sound/music/"
local area = AREA_MOJAVE
local nextplay = 50 or nextplay

for i = 0, 1 do
	if i == 0 then
		for i2 = 0, 9 do
			if i2 == 0 then
				for i3 = 1, 9 do
					table.insert(SCHEMA.music[AREA_MOJAVE], dir.."day/mus_inc_day-"..i..i2..i3..".ogg")
				end
			else
				for i3 = 0, 9 do
					table.insert(SCHEMA.music[AREA_MOJAVE], dir.."day/mus_inc_day-"..i..i2..i3..".ogg")
				end
			end
		end
	end

	if i == 1 then
		for i2 = 0, 2 do
			if i2 < 2 then
				for i3 = 0, 9 do
					table.insert(SCHEMA.music[AREA_MOJAVE], dir.."day/mus_inc_day-"..i..i2..i3..".ogg")
				end
			elseif i2 == 2 then
				for i3 = 0, 1 do
					table.insert(SCHEMA.music[AREA_MOJAVE], dir.."day/mus_inc_day-"..i..i2..i3..".ogg")
				end
			end
		end
	end
end

for i = 1, 4 do
	table.insert(SCHEMA.music[AREA_SPECIAL], dir.."special/freeside"..i..".mp3")
end

for i = 0, 1 do
	if i == 0 then
		for i2 = 0, 9 do
			if i2 == 0 then
				for i3 = 1, 9 do
					table.insert(SCHEMA.music[AREA_CREEPY], dir.."night/mus_inc_night-"..i..i2..i3..".ogg")
				end
			else
				for i3 = 0, 9 do
					table.insert(SCHEMA.music[AREA_CREEPY], dir.."night/mus_inc_night-"..i..i2..i3..".ogg")
				end

			end
		end
	end

	if i == 1 then
		for i2 = 0, 3 do
			if i2 < 3 then
				for i3 = 0, 9 do
					table.insert(SCHEMA.music[AREA_CREEPY], dir.."night/mus_inc_night-"..i..i2..i3..".ogg")
				end
			elseif i2 == 3 then
				for i3 = 0, 4 do
					table.insert(SCHEMA.music[AREA_CREEPY], dir.."night/mus_inc_night-"..i..i2..i3..".ogg")
				end
			end
		end
	end
end

hook.Add("PlayerEnterArea", "ToggleSounds", function(client)
	local newarea = string.lower(client:GetNetVar("area", ""))
	if newarea == "freeside" then 
		area = AREA_SPECIAL
	elseif newarea == "the mojave wasteland" then
		area = AREA_MOJAVE
	else
		area = AREA_CREEPY
	end
end)

local musplayer, found, song = nil, nil, nil
hook.Add("Think", "SoundPlayer", function()
	found = false

	if (CurTime() > nextplay) then
		song = table.Random(SCHEMA.music[area])
		sound.PlayFile(song, "", function(station)
			if (station and station:IsValid()) then
				station:SetVolume(0.4)
				if (LocalPlayer():Alive()) then
					station:Play()
				end
				musplayer = station
			end
		end)

		if (area != AREA_SPECIAL) then
			nextplay = CurTime() + 40
		else
			nextplay = CurTime() + 200
		end
	end

	if (musplayer and musplayer:IsValid()) then
		for k, v in pairs(ents.FindInSphere(LocalPlayer():GetPos(), 1500)) do
			if (v:GetClass() == "nut_musicradio") and (v:GetNetVar("active")) then
				musplayer:SetVolume(0)
				found = true
			end
		end
	end

	if (!found and musplayer and musplayer:IsValid()) then
		musplayer:SetVolume(0.4)
	end
end)