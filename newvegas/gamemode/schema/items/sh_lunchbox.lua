ITEM.name = "Lunchbox"
ITEM.uniqueID = "lunchbox"
ITEM.model = Model("models/mosi/fallout4/props/junk/lunchbox_nuka.mdl")
ITEM.desc = "It seems to contain something!"
ITEM.weight = 0.1
ITEM.data = {
	series = "clothes"
}

ITEM.flag = "U"
ITEM.functions = {}
ITEM.functions["Open Lunchbox"] = {
	menuOnly = true,
	run = function(itemTable, client, data)
		if (SERVER) then
			SCHEMA:OpenLunchbox(data.series, client)
		end
		if (CLIENT) then
			surface.PlaySound("fosounds/fix/containers/drs_safe_open.mp3")
			timer.Simple(0.25, function()
				surface.PlaySound("fosounds/fix/ui_popup_questupdate.mp3")
			end)
		end
	end
}