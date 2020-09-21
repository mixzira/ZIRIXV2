local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

--[ CONNECTION ]----------------------------------------------------------------------------------------------------------------

emp = Tunnel.getInterface("emp_miner")

--[ VARIABLES ]-----------------------------------------------------------------------------------------------------------------

local working = false
local selected = 1
local process = false

local rocks = {
	[1] = { ['x'] = 2925.86, ['y'] = 2792.39, ['z'] = 41.28 },
	[2] = { ['x'] = 2927.92, ['y'] = 2788.92, ['z'] = 40.63 },
	[3] = { ['x'] = 2934.52, ['y'] = 2784.21, ['z'] = 40.17 },
	[4] = { ['x'] = 2938.35, ['y'] = 2774.26, ['z'] = 39.76 },
	[5] = { ['x'] = 2938.97, ['y'] = 2768.87, ['z'] = 39.72 },
	[6] = { ['x'] = 2952.42, ['y'] = 2767.91, ['z'] = 40.02 },
	[7] = { ['x'] = 2957.69, ['y'] = 2772.68, ['z'] = 40.32 },
	[8] = { ['x'] = 2972.52, ['y'] = 2775.06, ['z'] = 39.32 },
	[9] = { ['x'] = 2983.28, ['y'] = 2763.07, ['z'] = 43.64 },
	[10] = { ['x'] = 2991.06, ['y'] = 2776.44, ['z'] = 43.75 },
	[11] = { ['x'] = 2993.86, ['y'] = 2753.04, ['z'] = 43.68 },
	[12] = { ['x'] = 2956.27, ['y'] = 2820.02, ['z'] = 43.11 },
	[13] = { ['x'] = 2944.35, ['y'] = 2818.70, ['z'] = 43.53 }
}

--[ IN WORKING AREA | THREAD ]--------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
	while true do
		local idle = 1000
		if not working then
			local ped = PlayerPedId()
			if not IsPedInAnyVehicle(ped) then
				local x,y,z = table.unpack(GetEntityCoords(ped))
				local distance = Vdist(x, y, z, rocks[selected].x, rocks[selected].y, rocks[selected].z)
				local lastVehicle = GetEntityModel(GetPlayersLastVehicle())
				if distance <= 100.0 then
					idle = 5
					DrawMarker(21, rocks[selected].x, rocks[selected].y, rocks[selected].z-0.3, 0, 0, 0, 0, 180.0, 130.0, 0.6, 0.8, 0.5, 136, 96, 240, 180, 1, 0, 0, 1)
					if distance <= 1.2 and IsControlJustPressed(1,38) then
						if lastVehicle == 48339065 and emp.checkPlate(lastVehicle) and emp.checkCrimeRecord() then
							if emp.checkWeight() then
								working = true
								vRP.DeletarObjeto()
								TriggerEvent("cancelando",true)
								SetEntityCoords(ped, rocks[selected].x+0.0001, rocks[selected].y+0.0001, rocks[selected].z+0.0001-1, 1, 0, 0, 1)
								vRP.CarregarObjeto("amb@world_human_const_drill@male@drill@base", "base","prop_tool_jackham", 15, 28422)
								
								SetTimeout(10000,function()
									working = false
									vRP.DeletarObjeto()
									vRP._stopAnim(false)
									TriggerEvent("cancelando",false)
									backentrega = selected
									while true do
										if backentrega == selected then
											selected = math.random(#rocks)
										else
											break
										end
										Citizen.Wait(10)
									end
									emp.collectOres()
								end)
							else
								TriggerEvent("Notify","negado","<b>Ferramenta</b> ou <b>espaço na mochila</b> insuficientes.")	
							end
						else
							TriggerEvent("Notify","negado","Você precisa do <b>veículo da mineradora</b> para fazer isso.")
						end
					end
				end
			end
		end
		Citizen.Wait(idle)
	end
end)