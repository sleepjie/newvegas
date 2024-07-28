local r, g, b =  91, 166, 221

if (nut.config.highvischat) then
	r, g, b =  91, 166, 221
else
	r, g, b = 255, 255, 150
end

local vischat = false
hook.Add("Think", "DetectVarChange", function()
	if (nut.config.highvischat != vischat) then
		if (nut.config.highvischat) then
			r, g, b =  91, 166, 221
		else
			r, g, b = 255, 255, 150
		end
		vischat = nut.config.highvischat
	end
end)

function SCHEMA:GetChatColor(speaker)
	local r2, g2, b2 = r, g, b
	local partner = LocalPlayer():GetEyeTraceNoCursor().Entity
	if (partner == speaker) and (speaker != LocalPlayer()) then
		r2 = 120
		g2 = 200 
		b2 = 0
	elseif (speaker:GetEyeTraceNoCursor().Entity == LocalPlayer()) then
		if (speaker != LocalPlayer()) then
			r2 = 200
			g2 = 80
			b2 = 0
		end
	end

	return r2, g2, b2
end

local ValidPunctuation = {",", ".", "-", "?", "!", "~"}

function SCHEMA:EnforceGrammer(text, bIsMe)
	if (!bIsMe) then
		text = string.SetChar(text, 1, string.upper(string.GetChar(text, 1)))
		if (!table.HasValue(ValidPunctuation, (string.GetChar(text, string.len(text))))) then
			text = text.."."
		end
	end
	
	return text
end

nut.chat.Register("whisper", {
	canHear = nut.config.whisperRange,
	onChat = function(speaker, text)
		local r, g, b = SCHEMA:GetChatColor(speaker)
		local text = SCHEMA:EnforceGrammer(text)

		if (nut.config.lazzychat) then
			chat.AddText(Color(r - 25, g - 25, b - 25), hook.Run("GetPlayerName", speaker, "whisper", text)..' whispers "'..text..'"')
		else
			chat.AddText(Color(r - 25, g - 25, b - 25), hook.Run("GetPlayerName", speaker, "whisper", text)..": "..text)
		end
	end,
	prefix = {"/w", "/whisper"},
	font = "forp_ChatFontWhisper"
})

nut.chat.Register("comms", {
	canHear = nut.config.BroadcastRange,
	onChat = function(speaker, text)
		local r, g, b = SCHEMA:GetChatColor(speaker)
		local text = SCHEMA:EnforceGrammer(text)

		if (nut.config.lazzychat) then
			chat.AddText(Color(r - 255, g - 255, b - 25), hook.Run("GetPlayerName", speaker, "whisper", text)..' says on radio "'..text..'"')
		else
			chat.AddText(Color(r - 25, g - 25, b - 25), hook.Run("GetPlayerName", speaker, "whisper", text)..": "..text)
		end
	end,	
	prefix = {"/comms", "/radio"},
	font = "forp_ChatFontAction"
})
nut.chat.Register("looc", {
	canHear = nut.config.chatRange,
	onChat = function(speaker, text)
		chat.AddText(Color(250, 40, 40), "[LOOC] ", Color(r, g, b), speaker:Name()..": "..text)
	end,
	prefix = {".//", "[[", "/looc"},
	canSay = function(speaker)
		return true
	end,
	noSpacing = true
}, "OOC")

nut.chat.Register("it", {
	canHear = nut.config.chatRange,
	onChat = function(speaker, text)
		local r, g, b = SCHEMA:GetChatColor(speaker)
		local text = SCHEMA:EnforceGrammer(text, true)

		chat.AddText(Color(r + 15, g + 15, b + 15), "**"..text)
	end,
	prefix = "/it",
	font = "forp_ChatFontAction"
})

nut.chat.Register("itc", {
	canHear = nut.config.whisperRange,
	onChat = function(speaker, text)
		local r, g, b = SCHEMA:GetChatColor(speaker)
		local text = SCHEMA:EnforceGrammer(text, true)

		chat.AddText(Color(r - 35, g - 35, b -  35), "**"..text)
	end,
	prefix = "/itc",
	font = "forp_ChatFontActionClose"
})

nut.chat.Register("itl", {
	canHear = nut.config.chatRange,
	onChat = function(speaker, text)
		local r, g, b = SCHEMA:GetChatColor(speaker)
		local text = SCHEMA:EnforceGrammer(text, true)

		chat.AddText(Color(r + 45, g + 45, b + 45), "**"..text)
	end,
	prefix = "/itl",
	font = "forp_ChatFontActionLong"
})

nut.chat.Register("ic", {
	canHear = nut.config.chatRange,
	onChat = function(speaker, text)
		local r, g, b = SCHEMA:GetChatColor(speaker)
		local text = SCHEMA:EnforceGrammer(text)

		if (nut.config.lazzychat) then
			chat.AddText(Color(r, g, b), hook.Run("GetPlayerName", speaker, "whisper", text)..' says "'..text..'"')
		else
			chat.AddText(Color(r, g, b), hook.Run("GetPlayerName", speaker, "whisper", text)..": "..text)
		end
	end,
	font = "nut_newchatfont"
})

nut.chat.Register("yell", {
	canHear = nut.config.yellRange,
	onChat = function(speaker, text)
		local r, g, b = SCHEMA:GetChatColor(speaker)
		local text = SCHEMA:EnforceGrammer(text)

		if (nut.config.lazzychat) then
			chat.AddText(Color(r + 35, g + 35, b + 35), hook.Run("GetPlayerName", speaker, "whisper", text)..' yells "'..text..'"')
		else
			chat.AddText(Color(r + 35, g + 35, b + 35), hook.Run("GetPlayerName", speaker, "whisper", text)..": "..text)
		end		end,
	prefix = {"/y", "/yell"},
	font = "forp_ChatFontYell"
})

nut.chat.Register("me", {
	canHear = nut.config.chatRange,
	onChat = function(speaker, text)
		local r, g, b = SCHEMA:GetChatColor(speaker)
		local text = SCHEMA:EnforceGrammer(text, true)

		chat.AddText(Color(r, g, b), "**"..hook.Run("GetPlayerName", speaker, "me", text).." "..text)
	end,
	prefix = {"/me", "/action"},
	font = "forp_ChatFontAction"
})

nut.chat.Register("mec", {
	canHear = nut.config.whisperRange,
	onChat = function(speaker, text)
		local r, g, b = SCHEMA:GetChatColor(speaker)
		local text = SCHEMA:EnforceGrammer(text, true)

		chat.AddText(Color(r, g, b), "**"..hook.Run("GetPlayerName", speaker, "me", text).." "..text)
	end,
	prefix = {"/mec", "/actionclose"},
	font = "forp_ChatFontActionClose"
})

nut.chat.Register("mel", {
	canHear = nut.config.yellRange,
	onChat = function(speaker, text)
		local r, g, b = SCHEMA:GetChatColor(speaker)
		local text = SCHEMA:EnforceGrammer(text, true)

		chat.AddText(Color(r, g, b), "**"..hook.Run("GetPlayerName", speaker, "me", text).." "..text)
	end,
	prefix = {"/mel", "/actionlong"},
	font = "forp_ChatFontActionLong"
})

nut.command.Register({
	adminOnly = false,
	allowDead = true,
	onRun = function(client, arguments)
		if (!client:Alive()) then
			client:Spawn()
		end
	end
}, "acd")

nut.command.Register({
	adminOnly = true,
	allowDead = false,
	onRun = function(client, arguments)
		local trace = client:GetEyeTraceNoCursor()

		if trace.Entity then
			trace.Entity:SetUID(arguments[1])
		end	
	end
}, "setuid")

SCHEMA.lootpos = SCHEMA.lootpos or {}

nut.command.Register({
	adminOnly = true,
	allowDead = false,
	onRun = function(client, arguments)
		local trace = client:GetEyeTraceNoCursor()

		if trace.HitPos then
			SCHEMA.lootpos[trace.HitPos] = true
		end	
		
		
	end
}, "addlootpos")

nut.command.Register({
	adminOnly = true,
	allowDead = false,
	onRun = function(client, arguments)
		local towrite = ""
		
		for k, v in pairs(SCHEMA.lootpos) do
			towrite = towrite..k.x.." "..k.y.." "..k.z.." ".."\n"
		end
		SCHEMA.lootpos = {}
		file.Write("lootpos.txt", towrite)
	end
}, "savelootspawn")

nut.command.Register({
	adminOnly = true,
	allowDead = false,
	onRun = function(client, arguments)
		local trace = client:GetEyeTraceNoCursor()

		if trace.Entity then
			trace.Entity:SetUID(arguments[1])
		end	
	end
}, "setuid")

nut.command.Register({
	adminOnly = true,
	allowDead = false,
	onRun = function(client, arguments)
		local trace = client:GetEyeTraceNoCursor()

		if trace.Entity then
			trace.Entity:SetType(string.Implode(" ", arguments))
		end	
	end
}, "settype")

nut.command.Register({
	adminOnly = true,
	allowDead = false,
	onRun = function(client, arguments)
		local trace = client:GetEyeTraceNoCursor()

		if trace.Entity then
			trace.Entity:SetDestination(string.Implode(" ", arguments))
		end	
	end
}, "setdestination")

nut.command.Register({
	adminOnly = false,
	allowDead = false,
	onRun = function(client, arguments)
		local key = arguments[1]
		SCHEMA:RedeemKey(key, client)
	end
}, "redeemkey")

nut.command.Register({
	adminOnly = true,
	allowDead = false,
	onRun = function(client, arguments)
		local count = 1
		local towrite = ""
		for k, v in pairs(ents.FindByClass("forp_teleport")) do
			towrite = towrite.."["..count.."] = {"..'pos = Vector("'..tostring(v:GetPos())..'"), '..'angs = Angle("'..tostring(v:GetAngles())..'"), '..'uid = "'..v:GetUID()..'", '..'Type = "'..v:GetType()..'", '..'dest = "'..v:GetDestination()..'"}'.."\n"
			count = count + 1
		end

		count = 0

		for k, v in pairs(ents.FindByClass("forp_teleportdestination")) do
			towrite = towrite.."["..count.."] = {"..'pos = Vector("'..tostring(v:GetPos())..'"), '..'angs = Angle("'..tostring(v:GetAngles())..'"), '..'uid = "'..v:GetUID()..'"}'.."\n"
			count = count + 1
		end
		
		if (SERVER) then
			file.Write("doors.txt", towrite)
		end
	end
}, "savedoors")

nut.command.Register({
	adminOnly = true,
	allowDead = false,
	onRun = function(client, arguments)
		for k, v in pairs(doorinfo) do
			local teleport = ents.Create("forp_teleport")
			teleport:SetPos(v.pos)
			teleport:SetAngles(v.angs)
			teleport:Spawn()

			local phys = teleport:GetPhysicsObject()
			if (phys and phys:IsValid()) then
				phys:EnableMotion(false)
			end

			teleport:SetType(v.Type)
			teleport:SetDestination(v.dest)
			teleport:SetUID(v.uid)
		end

		for k, v in pairs(destinfo) do
			local teleport = ents.Create("forp_teleportdestination")
			teleport:SetPos(v.pos)
			teleport:SetAngles(v.angs)
			teleport:Spawn()

			local phys = teleport:GetPhysicsObject()
			if (phys and phys:IsValid()) then
				phys:EnableMotion(false)
			end

			teleport:SetUID(v.uid)		
		end
	end
}, "loaddoors")

nut.chat.Register("event", {
	onChat = function(speaker, text)
		--print(speaker:IsAdmin(), speaker:HasFlag("x"))
		if (!speaker:HasFlag("x") and !speaker:IsAdmin()) then
			nut.util.Notify(nut.lang.Get("no_perm", speaker:Name()), speaker)

			return
		end
		
		--print(speaker:Name().." - ("..speaker:Nick()..")".." has used /event")
		chat.AddText(Color(240,110,30), text)
	end,
	prefix = "/event",
	font = "forp_ChatFontEvent"
})

nut.chat.Register("admin", {
	canHear = 0,
	onChat = function(speaker, text)
		local texttable = util.JSONToTable(text) 	
		chat.AddText(Color(255, 40, 40), texttable.name.." - [AC]: ",Color(220, 220, 220),texttable.words)
	end,
	font = "ChatFont"
})

nut.chat.Register("serverinfo", {
	canHear = 0,
	onChat = function(speaker, text)
		chat.AddText(Color(140, 90, 255), text)
	end,
	font = "nut_newchatfont"
})

nut.chat.Register("alert", {
	canHear = 0,
	onChat = function(speaker, text)
		chat.AddText(Color(255, 40, 40), "[Alert]: ",Color(220, 220, 220),text)
	end,
	font = "nut_newchatfont"
})

nut.chat.Register("request", {
	canHear = 0,
	onChat = function(speaker, text)
		local texttable = util.JSONToTable(text) 	
		chat.AddText(Color(0, 220, 255), texttable.name.." ("..texttable.realname..") - [Request]: ",Color(220, 220, 220),texttable.words)
	end,
	font = "nut_newchatfont"
})
nut.command.Register({
	onRun = function(client, arguments)
	--	local text = table.concat(arguments, " ")
--
	--	if (!client:IsAdmin()) then
	--		local texttab = {}
	--		texttab.words = text
	--		texttab.name = client:Nick()
	--		texttab.realname = client:RealName()
	--		local texttable = util.TableToJSON(texttab)
	--		for k, v in pairs(players.GetAll()) do
	--			if v:IsAdmin() or v == client then
	--				nut.chat.Send(v, "request", texttable)
	--			end
	--		end
--
--
	--		--nut.util.Notify("You are not an administrator!", client)
	--		--return
	--	end
--
	--	for k, v in pairs(player.GetAll()) do
	--		if v:IsAdmin() then
	--			local texttab = {}
	--			texttab.words = text
	--			texttab.name = client:RealName()
	--			local texttable = util.TableToJSON(texttab) 
	--			nut.chat.Send(v, "admin", texttable)
	--		end
	--	end
	end
}, "admin")

nut.command.Register({
	onRun = function(client, arguments)
		for k, v in pairs(player.GetAll()) do
			if v:IsAdmin() or (v:GetUserGroup() == "operator") then
				local texttab = {}
				texttab.name = v:Nick()
				texttab.realname = v:RealName()
				texttab.rank = v:GetUserGroup()
				local texttable = util.TableToJSON(texttab)
				nut.chat.Send(client, "listadmins", texttable)
			end
		end
	end
}, "listadmins")

nut.chat.Register("listadmins", {
	canHear = 0,
	onChat = function(speaker, text)
		local texttable = util.JSONToTable(text) 	
		chat.AddText(Color(0, 220, 255), "("..texttable.realname..") - ["..SCHEMA:EnforceGrammer(texttable.rank, true).."]")
	end,
	font = "ChatFont"
})

--if (client.character:GetData("hair")) then
--	client:SetBodygroup(2, client.character:GetData("hair"))
--else
--	client:SetBodygroup(2, 1)
--end

--if (client.character:GetData("haircolor")) then
--	client:SetColor(SCHEMA.HairTable[client.character:GetData("haircolor")].color)
--else
--	client:SetColor(Color(255,255,255,255))
--end

--if (client.character:GetData("facialhair")) then
--	client:SetBodygroup(3, client.character:GetData("facialhair"))
--else
--	client:SetBodygroup(3, 0)
--end

nut.command.Register({
	adminOnly = true,
	allowDead = true,
	syntax = "<string target>",
	onRun = function(client, arguments)
	if SERVER then
		if #arguments != 2 then
			nut.util.Notify("Invalid argument", client)
			return
		end

		local target = nut.command.FindPlayer(target, arguments[1])
		target.character:SetData("facemap", tonumber(arguments[2]))

		if (target:GetGender() == "female") then
			local face = (target.character:GetData("facemap") + 1)
			if (!target:IsGhoul()) then
				target:SetSubMaterial(0, "models/lazarus/female/"..SCHEMA.FemaleFaces[target:GetRace()][face])
			end
		elseif (target:GetGender() == "male") then
			local face = (target.character:GetData("facemap") + 1)
			if (!target:IsGhoul()) then
				target:SetSubMaterial(0, "models/lazarus/male/"..SCHEMA.MaleFaces[target:GetRace()][face])
			end
		end
		if (target:IsGhoul()) then
			target:SetSkin(target.character:GetData("facemap") - 1)
		end
		SCHEMA:PushClothesPurgeEvent()
	end
end
}, "setfacemap")

nut.command.Register({
	adminOnly = true,
	allowDead = true,
	syntax = "<string target>",
	onRun = function(client, arguments)
	if SERVER then
		if #arguments != 2 then
			nut.util.Notify("Invalid argument", client)
			return
		end

		local target = nut.command.FindPlayer(target, arguments[1])
		target.character:SetData("facialhair",tonumber(arguments[2]))
		target:SetBodygroup(3, tonumber(arguments[2]))
		SCHEMA:PushClothesPurgeEvent()
	end
end
}, "setfacialhair")

nut.command.Register({
	adminOnly = true,
	allowDead = true,
	syntax = "<string target>",
	onRun = function(client, arguments)
	if SERVER then
		if #arguments != 2 then
			nut.util.Notify("Invalid argument", client)
			return
		end

		local target = nut.command.FindPlayer(client, arguments[1])

		PrintTable(arguments)

		target.character:SetData("haircolor", tonumber(arguments[2]))
		target:SetColor(SCHEMA.HairTable[tonumber(arguments[2])].color)
		SCHEMA:PushClothesPurgeEvent()
	end
end
}, "sethaircolor")

nut.command.Register({
	adminOnly = true,
	allowDead = true,
	syntax = "<string target>",
	onRun = function(client, arguments)
	if SERVER then
		if #arguments != 2 then
			nut.util.Notify("Invalid argument", client)
			return
		end

		local target = nut.command.FindPlayer(target, arguments[1])
		target.character:SetData("hair",tonumber(arguments[2]))
		target:SetBodygroup(2, tonumber(arguments[2]))
		SCHEMA:PushClothesPurgeEvent()
	end
end
}, "sethair")

nut.command.Register({
	adminOnly = true,
	allowDead = true,
	syntax = "<string target>",
	onRun = function(client, arguments)
	if SERVER then
		if #arguments != 1 then
			nut.util.Notify("Invalid argument", client)
			return
		end

		local target = nut.command.FindPlayer(client, arguments[1])
		nut.chat.Send(client, "serverinfo", "Steam Name: "..target:RealName().."\nSteam ID: "..target:SteamID().."\nCharacter Name: "..target:Nick())
	end
end
}, "who")

nut.command.Register({
	adminOnly = true,
	allowDead = true,
	syntax = "<string target>",
	onRun = function(client, arguments)
	if SERVER then
		if #arguments != 1 then
			nut.util.Notify("Invalid argument", client)
			return
		end

		local target = nut.command.FindPlayer(client, arguments[1])

		if (!target:IsSuperAdmin()) then
			netstream.Start(target, "screamer", false)
		end
	end
end
}, "screamer")

nut.command.Register({
	adminOnly = true,
	allowDead = true,
	syntax = "<string target>",
	onRun = function(client, arguments)
	if SERVER then
		if #arguments != 1 then
			nut.util.Notify("Invalid argument", client)
			return
		end

		local target = nut.command.FindPlayer(client, arguments[1])

		target.character:SetData("chest", false)
	end
end
}, "resetsrk")

nut.command.Register({
	adminOnly = true,
	allowDead = true,
	syntax = "<number cards to draw>",
	onRun = function(client, arguments)
	if SERVER then
		if #arguments != 1 then
			nut.util.Notify("Invalid argument", client)
			return
		end

		if (!client:HasItem("doc")) then
			client:Notify("You do not have a deck of cards.")
			return
		end

		local cards = {"1","2","3","4","5","6","7","8","9","10","Ace","Queen","King","Jack"}
		local family = {"Spades", "Hearts", "Diamonds", "Clovers"}

		if type(arguments[1]) == "string" and tonumber(arguments[1]) == 1 then
			nut.chat.Send(client, "roll", client:Name().." has drawn an "..table.Random(cards).." of "..table.Random(family))
		else
			local takestring = client:Name().." has drawn a "..table.Random(cards).." of "..table.Random(family)
			for i = 1, (tonumber(arguments[1]) - 1) do
				if (i == tonumber(arguments[1]) - 1) then
					takestring = takestring.." and a "..table.Random(cards).." of "..table.Random(family)
				else
					takestring = takestring..", "..table.Random(cards).." of "..table.Random(family)
				end
			end
			nut.chat.Send(client, "roll", takestring)
		end
	end
end
}, "draw")

nut.command.Register({
	adminOnly = true,
	allowDead = true,
	syntax = "<string target>",
	onRun = function(client, arguments)
	if SERVER then
		if #arguments != 1 then
			nut.util.Notify("Invalid argument", client)
			return
		end

		local target = nut.command.FindPlayer(client, arguments[1])
		if (target) then
			local data = {}
			data.target = target
			data.inventory = target:GetInventory()
			netstream.Start(client, "InspectInventory", data)
		end
	end
end
}, "inspectinventory")

for k, v in pairs(SCHEMA.languages) do
	nut.chat.Register(v, {
		canHear = 128,
		onChat = function(speaker, text)
			local partner = LocalPlayer():GetEyeTraceNoCursor().Entity
			if (partner == speaker) and (speaker != LocalPlayer()) then
				r = 120
				g = 200 
				b = 0	
			end

			if LocalPlayer():HasTrait(string.GetChar(v,1)) then
				chat.AddText(Color(r, g, b), hook.Run("GetPlayerName", speaker, "whisper", text).." ["..v.."] says "..'"'..text..'"')
			else
				chat.AddText(Color(r, g, b), hook.Run("GetPlayerName", speaker, "whisper", text).." speaks in "..v)
			end
			r, g, b =  91, 166, 221
		end,
		prefix = {"/"..string.lower(v)},
		canSay = function(speaker)
			return speaker:HasTrait(string.GetChar(v,1))
		end
	})
end
