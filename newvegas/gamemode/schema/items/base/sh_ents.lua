BASE.name = "Entity Dropper"
BASE.desc = "Drops an Entity. You probably shouldnt be seeing this. tell a developer please."
BASE.model = "models/weapons/w_package.mdl"
BASE.entdrop = ""
BASE.functions = {}
BASE.functions.Use = {
	text = "Use",
	run = function(item)

			item.player:EmitSound( "physics/flesh/flesh_bloody_break.wav", 75, 200 )
				local ent = ents.Create( item.entdrop )
				ent:SetPos(item.player:EyePos() + ( item.player:GetAimVector() * 50))
				ent:Spawn()

		return true
	end
}
