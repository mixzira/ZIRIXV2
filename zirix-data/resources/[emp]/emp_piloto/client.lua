local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
emP = Tunnel.getInterface("emp_piloto")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local blips = nil
local selecionado = 0
local emservico = false
local CoordenadaX = -930.73
local CoordenadaY = -2957.57
local CoordenadaZ = 13.94
local passageiro = nil
local lastpassageiro = nil
local checkped = true
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOCALIDADES
-----------------------------------------------------------------------------------------------------------------------------------------
local locs = {
	[1] = { -75.14,-818.92,326.17,-72.06,-808.11,324.01 },
	[2] = { -1016.51,-2226.01,9.09,-1041.36,-2208.09,9.08 },
	[3] = { -2144.79,3240.62,32.82,-2172.68,3255.8,32.82 },
	[4] = { -774.60,5568.87,33.48,-754.20,5578.89,36.70 },
	[5] = { -79.55,6552.02,31.49,-59.37,6524.09,31.49 },
	[6] = { 2144.09,4805.18,41.18,2158.54,4789.91,41.13 },
	[7] = { 1856.82,2538.04,45.68,1840.04,2529.44,45.68 },
	[8] = { 199.56,2793.54,45.65,180.46,2793.39,45.65 },
	[9] = { -745.49,-1468.49,5.00,-753.66,-1512.03,5.02 },
	[10] = { -422.41,1134.94,325.85,-429.49,1109.77,327.68 },
	[11] = { -914.26,-378.75,137.91,-902.63,-369.79,136.29 },
	[12] = { 702.8,605.04,128.92,711.87,590.62,129.06 },
	[13] = { -1220.03,-831.88,29.41,-1241.11,-838.72,29.41 },
	[14] = { 792.19,1279.95,360.29,780.82,1274.84,361.28 },
	[15] = { -1582.06,-569.55,116.32,-1560.88,-569.03,114.44 },
	[16] = { 934.59,76.65,78.8,928.3,46.22,80.9 },
	[17] = { -1391.66,-477.62,91.25,-1374.27,-481.30,89.44 },
	[18] = { -356.23,-89.98,45.64,-380.53,-84.57,45.67 },
	[19] = { -2303.59,261.95,194.61,-2312.22,255.01,191.58 },
	[20] = { -1622.25,202.09,60.53,-1601.73,206.86,59.26 },
	[21] = { -2533.82,2330.19,33.06,-2544.01,2316.34,33.22 },
	[22] = { -1390.19,54.2,53.61,-1366.84,56.73,54.1 },
	[23] = { -1812.8,811.67,138.56,-1819.5,788.96,138.14 },
	[24] = { 1420.24,3617.98,34.91,1407.68,3619.21,34.89 },
	[25] = { 1716.92,6405.20,33.86,1706.16,6425.65,32.77 },
	[26] = { -369.13,6090.21,31.45,-370.88,6101.41,31.5 },
	[27] = { -1839.14,2997.22,32.82,-1832.03,3020.42,32.81 },
	[28] = { -3152.01,1072.01,20.66,-3153.95,1053.66,20.87 },
	[29] = { 1153.93,-1508.78,34.69,1150.80,-1530.08,35.37 },
	[30] = { 600.18,2798.63,41.91, 620.34,2800.26,41.93 },
	[31] = { -697.21,5774.32,17.33,-689.28,5789.14,17.33 },
	[32] = { -2978.85,74.37,11.61,-2989.43,69.73,11.61 },
	[33] = { -577.02,5252.18,70.47,-567.91,5252.94,70.49 },
	[34] = { 429.24,6535.07,27.76,416.34,6520.81,27.72 },
	[35] = { 2929.71,4637.62,48.55,2932.25,4624.06,48.73 },
	[36] = { 2700.07,3442.79,55.82,2709.98,3455.03,56.32 },
	[37] = { 3522.17,3769.75,29.97, 3512.83,3753.02,30.12 },
	[38] = { -985.0,-2056.99,9.41,-962.54,-2071.12,9.41 },
	[39] = { -1298.77,-1308.51,4.71,-1309.97,-1317.65,4.88 },
	[40] = { -2171.99,-411.99,13.3,-2188.05,-408.59,13.17 },
	[41] = { -144.74,-593.9,211.78,-139.9,-583.64,210.96 },
	[42] = { 1719.01,-1572.01,112.61,1713.23,-1555.48,113.95 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PEDLIST
-----------------------------------------------------------------------------------------------------------------------------------------
local pedlist = {
	[1] = { "ig_abigail",0x400AEC41 },
	[2] = { "a_m_o_acult_02",0x4BA14CCA },
	[3] = { "a_m_m_afriamer_01",0xD172497E },
	[4] = { "ig_mp_agent14",0xFBF98469 },
	[5] = { "u_m_m_aldinapoli",0xF0EC56E2 },
	[6] = { "ig_amandatownley",0x6D1E15F7 },
	[7] = { "ig_andreas",0x47E4EEA0 },
	[8] = { "csb_anita",0x0703F106 },
	[9] = { "u_m_y_antonb",0xCF623A2C },
	[10] = { "g_m_y_armgoon_02",0xC54E878A },
	[11] = { "ig_ashley",0x7EF440DB },
	[12] = { "s_m_m_autoshop_01",0x040EABE3 },
	[13] = { "g_m_y_ballaeast_01",0xF42EE883 },
	[14] = { "g_m_y_ballaorig_01",0x231AF63F },
	[15] = { "s_m_y_barman_01",0xE5A11106 },
	[16] = { "u_m_y_baygor",0x5244247D },
	[17] = { "a_m_o_beach_01",0x8427D398 },
	[18] = { "a_m_y_beachvesp_01",0x7E0961B8 },
	[19] = { "ig_bestmen",0x5746CD96 },
	[20] = { "a_f_y_bevhills_01",0x445AC854 },
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
local hora = 0
function CalculateTimeToDisplay()
	hora = GetClockHours()
	if hora <= 9 then
		hora = "0" .. hora
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRABALHAR
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		if not emservico then
			local ped = PlayerPedId()
			if not IsPedInAnyVehicle(ped) then
				local x,y,z = table.unpack(GetEntityCoords(ped))
				local distance = Vdist(x,y,z,CoordenadaX,CoordenadaY,CoordenadaZ)
				if distance <= 30.0 then
					DrawMarker(23,CoordenadaX,CoordenadaY,CoordenadaZ-0.97,0,0,0,0,0,0,1.0,1.0,0.5,240,200,80,20,0,0,0,0)
					if distance <= 1.2 then
						drawTxt("PRESSIONE  ~b~E~w~  PARA INICIAR EXPEDIENTE",4,0.5,0.93,0.50,255,255,255,180)
						if IsControlJustPressed(1,38) and emP.checkPermission() then
							CalculateTimeToDisplay()
							if parseInt(hora) >= 06 and parseInt(hora) <= 20 then
								emservico = true
								selecionado = math.random(#locs)
								CriandoBlip(locs,selecionado)
							else
								TriggerEvent("Notify","importante","Funcionamento é das <b>06:00</b> as <b>20:00</b>.",8000)
							end
						end
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PASSAGEIRO
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		if emservico then
			local ped = PlayerPedId()
			if IsPedInAnyVehicle(ped) then
				local x,y,z = table.unpack(GetEntityCoords(ped))
				local vehicle = GetVehiclePedIsUsing(ped)
				local distance = Vdist(x,y,z,locs[selecionado][1],locs[selecionado][2],locs[selecionado][3])
				if distance <= 200.0 and (IsVehicleModel(vehicle,GetHashKey("supervolito")) or IsVehicleModel(vehicle,GetHashKey("supervolito2")) or IsVehicleModel(vehicle,GetHashKey("buzzard2")) or IsVehicleModel(vehicle,GetHashKey("frogger")) or IsVehicleModel(vehicle,GetHashKey("maverick"))) then
					DrawMarker(23,locs[selecionado][1],locs[selecionado][2],locs[selecionado][3]-0.95,0,0,0,0,0,0,10.0,10.0,0.5,240,200,80,50,0,0,0,0)
					if distance <= 10.1 then
						if IsControlJustPressed(1,38) and emP.checkPermission() then
							CalculateTimeToDisplay()
							if parseInt(hora) >= 06 and parseInt(hora) <= 20 then
								RemoveBlip(blips)
								FreezeEntityPosition(vehicle,true)
								if DoesEntityExist(passageiro) then
									emP.checkPayment()
									Citizen.Wait(3000)
									TaskLeaveVehicle(passageiro,vehicle,262144)
									TaskWanderStandard(passageiro,10.0,10)
									Citizen.Wait(1300)
									SetVehicleDoorShut(vehicle,1,0)
									Citizen.Wait(1000)
								end

								if checkped then
									local pmodel = math.random(#pedlist)
									modelRequest(pedlist[pmodel][1])

									passageiro = CreatePed(4,pedlist[pmodel][2],locs[selecionado][4],locs[selecionado][5],locs[selecionado][6],3374176,true,false)
									TaskEnterVehicle(passageiro,vehicle,-1,0,1.0,1,0)
									SetEntityInvincible(passageiro,true)
									checkped = false
									lastpassageiro = passageiro
								else
									passageiro = nil
									checkped = true
									FreezeEntityPosition(vehicle,false)
									removePeds()
								end

								lselecionado = selecionado
								while true do
									if lselecionado == selecionado then
										selecionado = math.random(#locs)
									else
										break
									end
									Citizen.Wait(10)
								end

								CriandoBlip(locs,selecionado)

								if DoesEntityExist(passageiro) then
									while true do
										Citizen.Wait(5)
										local x2,y2,z2 = table.unpack(GetEntityCoords(passageiro))
										if not IsPedSittingInVehicle(passageiro,vehicle) then
											DrawMarker(21,x2,y2,z2+1.3,0,0,0,0,180.0,130.0,0.6,0.8,0.5,240,200,80,50,1,0,0,1)
										end
										if IsPedSittingInVehicle(passageiro,vehicle) then
											FreezeEntityPosition(vehicle,false)
											break
										end
									end
								end
							else
								TriggerEvent("Notify","importante","Funcionamento é das <b>06:00</b> as <b>20:00</b>.",8000)
							end
						end
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVENPCS
-----------------------------------------------------------------------------------------------------------------------------------------
function removePeds()
	SetTimeout(20000,function()
		if emservico and lastpassageiro and passageiro == nil then
			TriggerServerEvent("tryDeleteEntity",PedToNet(lastpassageiro))
		end
	end)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CANCELAR
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		if emservico then
			local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1))
			if IsControlJustPressed(1,121) and (IsVehicleModel(vehicle,GetHashKey("supervolito")) or IsVehicleModel(vehicle,GetHashKey("supervolito2")) or IsVehicleModel(vehicle,GetHashKey("buzzard2")) or IsVehicleModel(vehicle,GetHashKey("frogger")) or IsVehicleModel(vehicle,GetHashKey("maverick"))) then
				RemoveBlip(blips)
				if DoesEntityExist(passageiro) then
					TaskLeaveVehicle(passageiro,vehicle,262144)
					TaskWanderStandard(passageiro,10.0,10)
					Citizen.Wait(1300)
					SetVehicleDoorShut(vehicle,1,0)
					FreezeEntityPosition(vehicle,false)
				end
				blips = nil
				selecionado = 0
				passageiro = nil
				checkped = true
				emservico = false
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
function drawTxt(text,font,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextScale(scale,scale)
	SetTextColour(r,g,b,a)
	SetTextOutline()
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x,y)
end

function modelRequest(model)
	local hash = GetHashKey(model)

	RequestModel(hash)
	while not HasModelLoaded(hash) do
		RequestModel(hash)
		Citizen.Wait(10)
	end
end

function CriandoBlip(locs,selecionado)
	blips = AddBlipForCoord(locs[selecionado][1],locs[selecionado][2],locs[selecionado][3])
	SetBlipSprite(blips,1)
	SetBlipColour(blips,5)
	SetBlipScale(blips,0.4)
	SetBlipAsShortRange(blips,false)
	SetBlipRoute(blips,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Corrida Aerea")
	EndTextCommandSetBlipName(blips)
end