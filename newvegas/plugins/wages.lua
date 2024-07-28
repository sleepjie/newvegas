PLUGIN.name = "Wages"
PLUGIN.author = "thor"
PLUGIN.desc = "gives people salary money"

-- im gonna use this to handle default spawnpoints
function PLUGIN:PlayerLoadedChar(client)
	for k,v in pairs(SCHEMA.factions) do
		if v.WeekPay and client:HasFlag(k) then
			local currentTime = os.time()
			local lastWeekWage = client.character:GetData("lastWeekWage")
			
			if not lastWeekWage then
				client.character:SetData("lastWeekWage", os.time())
				lastWeekWage = os.time()
			end
			
			currentTime = tonumber(os.date("%U", currentTime))
			lastWeekWage = tonumber(os.date("%U", lastWeekWage))
			
			if (currentTime >= 53) or (lastWeekWage >= 53) then
				currentTime = currentTime - 53
				lastWeekWage = lastWeekWage - 53
			end
			
			if currentTime > lastWeekWage then
				local pay = v.WeekPay.amount + (client.character:GetData("hourWages") or 0)
				client:giveCurrency(v.WeekPay.type, pay)
				client.character:SetData("lastWeekWage", os.time())
				client.character:SetData("hourWages", 0)
				client.character:SetData("wageProgress", 0)
			end
		end
	end
end

if SERVER then
	timer.Create("paydayTimer", 360, 0, function()
		for k,v in pairs(player.GetAll()) do 
			if v.character then
				for i,e in pairs(SCHEMA.factions) do
					if v:HasFlag(i) and e.HourPay then
						local wageProgress = v.character:GetData("wageProgress") or 0
						wageProgress = wageProgress + 10
						if wageProgress >= 100 then
							local hourWages = v.character:GetData("hourWages") or 0
							hourWages = hourWages + e.HourPay.amount
							v.character:SetData("hourWages", hourWages)
							wageProgress = 0
						end
						v.character:SetData("wageProgress", wageProgress)
					end
				end
			end
		end
	end)
end

-- defines
-- ncr
SCHEMA.factions["N"]["WeekPay"] = {amount = 1000, type = CUR_NCR}
SCHEMA.factions["N"]["HourPay"] = {amount = 50, type = CUR_NCR}
-- legion
SCHEMA.factions["C"]["WeekPay"] = {amount = 100, type = CUR_CLD}
SCHEMA.factions["C"]["HourPay"] = {amount = 5, type = CUR_CLD}