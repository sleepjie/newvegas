local PLUGIN = PLUGIN

--local RECIPE = {}
--RECIPE.uid = "example"
--RECIPE.name = "A Skull"
--RECIPE.category = nut.lang.Get( "icat_material" )
--RECIPE.model = Model( "models/Gibs/HGIBS.mdl" )
--RECIPE.desc = "A Skull."
--RECIPE.noBlueprint = true
--RECIPE.items = {
--	["bone"] = 1,
--}
--RECIPE.result = {
--	["skull"] = 2,
--}
--RECIPES:Register( RECIPE )
--[[
local ammo ={	
	{name = "testitem", result = "9ammo", model = "models/maxibammo/9mm.mdl", metalcount = 1, powdercount = 2},
}
for k, v in pairs(ammo) do
	local RECIPE = {}
	RECIPE = {}
	RECIPE.name = v.name
	RECIPE.uid = v.name
	RECIPE.desc = v.name.." Ammunition."
	RECIPE.model = v.model or "models/Items/BoxSRounds.mdl"
	RECIPE.category = "Ammunition"
	RECIPE.noBlueprint = true
	RECIPE.items = {}
	if (v.powdercount) then
		RECIPE.items["Jar of Gunpowder"] = v.powdercount
	end

	if (v.metalcount) then
		RECIPE.items["Scrap Metal"] = v.metalcount
	end

	if (v.electronics) then
		RECIPE.items["Scrap Electronics"] = v.electronics
	end


	RECIPE.result = {
		[v.result] = 1,
	}

	RECIPES:Register(RECIPE)
end
--]]