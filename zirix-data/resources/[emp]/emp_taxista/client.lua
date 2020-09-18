local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
emP = Tunnel.getInterface("emp_taxista")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local blips = nil
local selecionado = 0
local emservico = false
local CoordenadaX = 903.83
local CoordenadaY = -166.17
local CoordenadaZ = 74.08
local passageiro = nil
local lastpassageiro = nil
local checkped = true
local timers = 0
local payment = 10
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOCALIDADES
-----------------------------------------------------------------------------------------------------------------------------------------
local locs = {
	[1] = { 151.30,-1028.63,28.84,152.45,-1041.24,29.37,252.0 },
	[2] = { 423.84,-959.30,28.81,437.37,-979.03,30.68,271.0 },
	[3] = { 1.03,-1510.86,29.40,20.67,-1505.62,31.85,319.0 },
	[4] = { -188.07,-1612.28,33.39,-189.55,-1585.80,34.76,178.0 },
	[5] = { 98.88,-1927.16,20.25,101.02,-1912.35,21.40,70.0 },
	[6] = { 320.98,-2022.02,20.40,335.73,-2010.77,22.31,321.0 },
	[7] = { 755.53,-2486.26,19.54,774.34,-2475.07,20.14,356.0 },
	[8] = { 1057.66,-2124.80,32.20,1040.09,-2115.65,32.84,175.0 },
	[9] = { 1377.08,-1530.01,56.07,1379.33,-1514.99,58.43,119.0 },
	[10] = { 1260.24,-588.15,68.53,1240.60,-601.63,69.78,193.0 },
	[11] = { 899.58,-590.58,56.85,886.76,-608.20,58.44,238.0 },
	[12] = { 945.18,-140.04,74.07,959.34,-121.23,74.96,60.0 },
	[13] = { 84.44,476.19,146.91,80.10,486.12,148.20,118.0 },
	[14] = { -720.03,482.23,107.10,-721.10,489.75,109.38,110.0 },
	[15] = { -1244.39,497.98,93.86,-1229.15,515.72,95.42,359.0 },
	[16] = { -1514.99,442.97,109.70,-1495.97,437.10,112.49,296.0 },
	[17] = { -1684.14,-308.47,51.41,-1684.87,-291.66,51.89,234.0 },
	[18] = { -1413.14,-531.91,30.98,-1447.29,-537.71,34.74,215.0 },
	[19] = { -1036.80,-492.27,36.15,-1007.32,-486.80,39.97,27.0 },
	[20] = { -551.46,-648.64,32.73,-533.39,-622.87,34.67,92.0 },
	[21] = { -616.30,-920.80,22.98,-598.49,-929.96,23.86,291.0 },
	[22] = { -752.13,-1041.29,12.25,-759.21,-1047.16,13.50,117.0 },
	[23] = { -1155.20,-1413.48,4.46,-1150.56,-1426.38,4.95,247.0 },
	[24] = { -997.88,-1599.65,4.59,-989.04,-1575.82,5.17,271.0 },
	[25] = { -829.38,-1218.09,6.54,-822.50,-1223.35,7.36,319.0 },
	[26] = { -334.47,-1418.13,29.71,-320.10,-1389.73,36.50,91.0 },
	[27] = { 135.28,-1306.46,28.65,132.91,-1293.90,29.26,119.0 },
	[28] = { -34.00,-1079.86,26.26,-39.02,-1082.46,26.42,69.0 }
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
-- TRABALHAR
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		if not emservico then
			local ped = PlayerPedId()
			if not IsPedInAnyVehicle(ped) then
				local x,y,z = table.unpack(GetEntityCoords(ped))
				if Vdist(x,y,z,CoordenadaX,CoordenadaY,CoordenadaZ) <= 30.0 then
					DrawMarker(23,CoordenadaX,CoordenadaY,CoordenadaZ-0.97,0,0,0,0,0,0,1.0,1.0,0.5,240,200,80,20,0,0,0,0)
					if Vdist(x,y,z,CoordenadaX,CoordenadaY,CoordenadaZ) <= 1.2 then
						drawTxt("PRESSIONE  ~b~E~w~  PARA INICIAR EXPEDIENTE",4,0.5,0.93,0.50,255,255,255,180)
						if IsControlJustPressed(1,38) and emP.checkPermission() then
							emservico = true
							selecionado = math.random(#locs)
							CriandoBlip(locs,selecionado)
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
				local vehicle = GetVehiclePedIsUsing(ped)
				local x,y,z = table.unpack(GetEntityCoords(ped))

				if Vdist(x,y,z,locs[selecionado][1],locs[selecionado][2],locs[selecionado][3]) <= 50.0 and IsVehicleModel(vehicle,GetHashKey("taxi")) then
					DrawMarker(21,locs[selecionado][1],locs[selecionado][2],locs[selecionado][3]+0.20,0,0,0,0,180.0,130.0,2.0,2.0,1.0,240,200,80,20,1,0,0,1)
					if Vdist(x,y,z,locs[selecionado][1],locs[selecionado][2],locs[selecionado][3]) <= 2.5 then
						if IsControlJustPressed(1,38) and emP.checkPermission() and (GetEntityHeading(ped) >= locs[selecionado][7]-20.0 and GetEntityHeading(ped) <= locs[selecionado][7]+20.0) then
							RemoveBlip(blips)
							FreezeEntityPosition(vehicle,true)
							if DoesEntityExist(passageiro) then
								emP.checkPayment(payment)
								Citizen.Wait(3000)
								TaskLeaveVehicle(passageiro,vehicle,262144)
								TaskWanderStandard(passageiro,10.0,10)
								Citizen.Wait(1100)
								SetVehicleDoorShut(vehicle,3,0)
								Citizen.Wait(1000)
							end

							if checkped then
								local pmodel = math.random(#pedlist)
								modelRequest(pedlist[pmodel][1])

								passageiro = CreatePed(4,pedlist[pmodel][2],locs[selecionado][4],locs[selecionado][5],locs[selecionado][6],3374176,true,false)
								TaskEnterVehicle(passageiro,vehicle,-1,2,1.0,1,0)
								SetEntityInvincible(passageiro,true)
								checkped = false
								payment = 10
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
						end
					end
				end

				if IsEntityAVehicle(vehicle) and DoesEntityExist(passageiro) then
					local vehiclespeed = GetEntitySpeed(vehicle)*2.236936
					if math.ceil(vehiclespeed) >= 81 and timers <= 0 and payment > 0 then
						timers = 5
						payment = payment - 1
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TIMERS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if timers > 0 then
			timers = timers - 1
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
			if IsControlJustPressed(1,121) then
				RemoveBlip(blips)
				if DoesEntityExist(passageiro) then
					TriggerServerEvent("tryDeleteEntity",PedToNet(passageiro))
					FreezeEntityPosition(GetVehiclePedIsUsing(GetPlayerPed(-1)),false)
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
	AddTextComponentString("Corrida de Taxista")
	EndTextCommandSetBlipName(blips)
end