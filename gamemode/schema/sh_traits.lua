local playerMeta = FindMetaTable("Player")

SCHEMA.Traits = {}

function SCHEMA:RegisterTrait(flag, Name, Desc)
	SCHEMA.Traits[flag] = {name = Name, desc = Desc}
end

function SCHEMA:GetTraitData(trait)
	return SCHEMA.Traits[trait]
end

function SCHEMA:GetTraitName(trait)
	return SCHEMA.Traits[trait].name 
end

nut.command.Register({
	adminOnly = true,
	allowDead = true,
	syntax = "<string client name>  <string trait>",
	onRun = function(client, arguments)
		if !(arguments[1]) then
			client:Notify("You did not specify a trait.")
		end

		local target = nut.command.FindPlayer(client, arguments[1])
		target:GiveTrait(arguments[2], client)
	end
}, "givetrait")

nut.command.Register({
	adminOnly = true,
	allowDead = true,
	syntax = "<string client name>  <string trait>",
	onRun = function(client, arguments)
		if !(arguments[1]) then
			client:Notify("You did not specify a trait.")
		end

		local target = nut.command.FindPlayer(client, arguments[1])
		target:TakeTrait(arguments[2], client)
	end
}, "taketrait")

if (SERVER) then
	function playerMeta:GiveTrait(trait, giver)
		if (!SCHEMA:GetTraitData(trait)) then
			if (giver) then
				giver:Notify("This trait does not exist.")
			end

			return
		end
		local trait = trait or ""
		local character = self.character
		local traitString = character:GetData("TraitString", "")

		if (string.find(traitString, trait)) then
			if (giver) then
				giver:Notify(self:Name().." already has the "..SCHEMA:GetTraitName(trait).." trait.")
			end
		else
			character:SetData("TraitString", traitString..trait)
			if (giver) then
				giver:Notify("You have given "..self:Name().." the "..SCHEMA:GetTraitName(trait).." trait.")
				self:Notify("You have been given the "..SCHEMA:GetTraitName(trait).." trait by "..giver:Name()..".")
			end
		end
	end

	function playerMeta:TakeTrait(trait, taker)
		if (!SCHEMA:GetTraitData(trait)) then
			if (taker) then
				taker:Notify("This trait does not exist.")
			end

			return
		end
		local trait = trait or ""
		local character = self.character
		local traitString = character:GetData("TraitString", "")

		if self:HasTrait(trait) then
			traitString = string.Replace(traitString, trait, "")
			character:SetData("TraitString", traitString)
			if (taker) then
				taker:Notify("You have taken "..self:Name().."'s "..SCHEMA:GetTraitName(trait).." trait away.")
				self:Notify("You have had the "..SCHEMA:GetTraitName(trait).." trait revoked.")
			end
		else
			if (taker) then
				taker:Notify(self:Name().." does not posses the "..SCHEMA:GetTraitName(trait)..".")
			end
		end
	end

	function playerMeta:HasTrait(trait)
		if (!SCHEMA:GetTraitData(trait)) then
			return
		end
		
		local trait = trait or ""
		local character = self.character
		local traitString = character:GetData("TraitString", "")
		
		return (string.find(traitString, trait))
	end
else
	hook.Add("BuildHelpOptions", "nut_TraitHelp", function(data)
		data:AddHelp("Traits", function()
			local html = ""

			for k, v in SortedPairs(SCHEMA.Traits) do
				local color = "<font color=\"red\">&#10008;"

				if (LocalPlayer():HasTrait(k)) then
					color = "<font color=\"green\">&#10004;"
				end

				html = html.."<p><b>"..color.."&nbsp;</font>"..k.."</b><br /><hi>"..v.desc or nut.lang.Get("no_desc").."</p>"
			end

			return html
		end, "icon16/flag_red.png")
	end)

	function playerMeta:HasTrait(trait)
		if (self != LocalPlayer()) then
			return
		end

		local trait = trait or ""
		local character = self.character
		local traitString = character:GetData("TraitString", "")

		return (string.find(traitString, trait))
	end
end