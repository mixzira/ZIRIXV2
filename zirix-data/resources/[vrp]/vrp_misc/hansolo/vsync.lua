local hora = 6
local minuto = 20
local currentweather = "EXRTASUNNY"
local lastWeather = currentweather

--[ UPDATEWEATHER ]----------------------------------------------------------------------------------------------------------------------

RegisterNetEvent("vrp_misc:updateWeather")
AddEventHandler("vrp_misc:updateWeather",function(NewWeather)
	currentweather = NewWeather
end)

--[ FUNCTIONWEATHER ]--------------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
	while true do
		if lastWeather ~= currentweather then
			lastWeather = currentweather
			SetWeatherTypeOverTime(currentweather,15.0)
			Citizen.Wait(15000)
		end

		ClearOverrideWeather()
		ClearWeatherTypePersist()
		SetWeatherTypePersist(lastWeather)
		SetWeatherTypeNow(lastWeather)
		SetWeatherTypeNowPersist(lastWeather)
		
		Citizen.Wait(100)
	end
end)

--[ PLAYERSPAWNED ]----------------------------------------------------------------------------------------------------------------------

AddEventHandler("playerSpawned",function()
	TriggerServerEvent("vrp_misc:requestSync")
end)

--[ SYNCTIMERS ]-------------------------------------------------------------------------------------------------------------------------

RegisterNetEvent("vrp_misc:syncTimers")
AddEventHandler("vrp_misc:syncTimers",function(timer)
	hora = timer[2]
	minuto = timer[1]
end)

--[ NETWORKCLOCK ]-----------------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		NetworkOverrideClockTime(hora,minuto,00)
	end
end)