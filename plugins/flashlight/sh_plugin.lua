PLUGIN.name = "Flashlight"
PLUGIN.author = "Johnny Guitar"
PLUGIN.desc = "Provides a flashlight item to regular flashlight usage."

function PLUGIN:PlayerSwitchFlashlight(client, state)
	if (state and !client:HasItemEquipped("flashlight")) then
		return false
	end

	return true
end

if (SERVER) then

	function RechargeFlashlight(client)
		if client:HasItem("flashlight") then
			for k, v in pairs( client:GetItemsByClass("flashlight") ) do
				if v.data.Equipped == true then
					v.data.battery = 100
				end
			end
		end
	end

	function PLUGIN:PlayerPostThink(client)
		if client:FlashlightIsOn() == true then
			if client:HasItem("flashlight") then
				for k, v in pairs( client:GetItemsByClass("flashlight") ) do
					if v.data.Equipped == true then
						if (v.data.battery > 0) then
							if (!player.nextbattery or player.nextbattery < CurTime()) then
								player.nextbattery = CurTime() + 45
								v.data.battery = v.data.battery - 1
							end
						else
							client:Flashlight(false)
						end
					end
				end
			end
		end
	end

end