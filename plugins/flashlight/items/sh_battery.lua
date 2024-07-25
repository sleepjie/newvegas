ITEM.name = "Battery"
ITEM.uniqueID = "battery"
ITEM.model = Model("models/Items/car_battery01.mdl")
ITEM.desc = "A battery that can be inserted into a flashlight."
ITEM.flag = "1"
ITEM.data = { 
	battery = 100, 
	Equipped = false 
}
ITEM.functions = {}
ITEM.functions.Use = {
	run = function(itemTable, client, data)
		if (SERVER) then
			RechargeFlashlight(client)
		end
	end
}