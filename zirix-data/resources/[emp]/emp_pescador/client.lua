local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
emP = Tunnel.getInterface("emp_pescador")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local processo = false
local segundos = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOCAIS
-----------------------------------------------------------------------------------------------------------------------------------------
local pescs = {
	{ -1455.48,5287.04,-1.03 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROCESSO
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		if not processo then
			local ped = PlayerPedId()
			if not IsPedInAnyVehicle(ped) then
				local x,y,z = table.unpack(GetEntityCoords(ped))
				for k,v in pairs(pescs) do
					local distancia = Vdist(x,y,z,v[1],v[2],v[3])
					if distancia <= 75 then
						DrawMarker(1,v[1],v[2],v[3]-1.5,0,0,0,0,0,0,150.0,150.0,50.0,255,255,255,25,0,0,0,0)
						if IsControlJustPressed(1,38) and not IsPedInAnyVehicle(ped) and GetEntityHealth(ped) >= 102 then
							if emP.checkPayment() then
								processo = true
								segundos = 14
								TriggerEvent('cancelando',true)
								TriggerEvent("Progress",13500)
								if not IsEntityPlayingAnim(ped,"amb@world_human_stand_fishing@idle_a","idle_c",3) then
									vRP._removeObjects()
									vRP._createObjects("amb@world_human_stand_fishing@idle_a","idle_c","prop_fishing_rod_01",15,60309)
								end
							end
						end
					end
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if segundos > 0 and processo then
			segundos = segundos - 1
			if segundos == 0 then
				processo = false
				TriggerEvent('cancelando',false)
			end
		end
	end
end)