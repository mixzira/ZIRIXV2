local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
emP = Tunnel.getInterface("emp_caminhao")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local blips = false
local random = 0
local modules = ""
local myPlate = nil
local servico = false
local servehicle = nil
local CoordenadaX = 1499.83
local CoordenadaY = 3745.58
local CoordenadaZ = 33.89
local CoordenadaX2 = 0.0
local CoordenadaY2 = 0.0
local CoordenadaZ2 = 0.0

--Locs 1499.83,3745.58,33.89

-----------------------------------------------------------------------------------------------------------------------------------------
-- DIESEL
-----------------------------------------------------------------------------------------------------------------------------------------
local diesel = {
	[1] = { 288.28,-1244.33,29.23 },
	[2] = { 851.33,-1047.87,28.33 },
	[3] = { 1200.47,-1386.57,35.23 },
	[4] = { 1161.74,-340.55,68.18 },
	[5] = { 641.96,277.5,103.2 },
	[6] = { 2568.68,379.32,108.47 },
	[7] = { 182.13,-1549.23,29.18 },
	[8] = { -334.92,-1487.37,30.64 },
	[9] = { 1778.1,3336.0,41.16 },
	[10] = { 37.85,2790.99,57.88 },
	[11] = { 245.2,2601.39,45.13 },
	[12] = { 1026.21,2658.06,39.56 },
	[13] = { 1207.38,2642.3,37.84 },
	[14] = { 2536.6,2580.05,37.95 },
	[15] = { 2688.06,3277.38,55.25 },
	[16] = { 1990.72,3763.6,32.19 },
	[17] = { 1687.91,4917.91,42.08 },
	[18] = { 1717.26,6419.69,33.28 },
	[19] = { 180.09,6623.35,31.73 },
	[20] = { -78.57,6431.78,31.5 },
	[21] = { -2537.66,2324.99,33.06 },
	[22] = { -1814.89,779.6,137.32 },
	[23] = { -1422.58,-286.04,46.25 },
	[24] = { -2073.95,-304.73,13.16 },
	[25] = { -727.11,-919.42,19.02 },
	[26] = { -514.5,-1214.96,18.32 },
	[27] = { -65.19,-1749.36,29.38 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- GAS
-----------------------------------------------------------------------------------------------------------------------------------------
local gas = {
	[1] = { 288.28,-1244.33,29.23 },
	[2] = { 851.33,-1047.87,28.33 },
	[3] = { 1200.47,-1386.57,35.23 },
	[4] = { 1161.74,-340.55,68.18 },
	[5] = { 641.96,277.5,103.2 },
	[6] = { 2568.68,379.32,108.47 },
	[7] = { 182.13,-1549.23,29.18 },
	[8] = { -334.92,-1487.37,30.64 },
	[9] = { 1778.1,3336.0,41.16 },
	[10] = { 37.85,2790.99,57.88 },
	[11] = { 245.2,2601.39,45.13 },
	[12] = { 1026.21,2658.06,39.56 },
	[13] = { 1207.38,2642.3,37.84 },
	[14] = { 2536.6,2580.05,37.95 },
	[15] = { 2688.06,3277.38,55.25 },
	[16] = { 1990.72,3763.6,32.19 },
	[17] = { 1687.91,4917.91,42.08 },
	[18] = { 1717.26,6419.69,33.28 },
	[19] = { 180.09,6623.35,31.73 },
	[20] = { -78.57,6431.78,31.5 },
	[21] = { -2537.66,2324.99,33.06 },
	[22] = { -1814.89,779.6,137.32 },
	[23] = { -1422.58,-286.04,46.25 },
	[24] = { -2073.95,-304.73,13.16 },
	[25] = { -727.11,-919.42,19.02 },
	[26] = { -514.5,-1214.96,18.32 },
	[27] = { -65.19,-1749.36,29.38 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- CARS
-----------------------------------------------------------------------------------------------------------------------------------------
local cars = {
	[1] = { -227.87,6243.21,31.49 },
	[2] = { -94.27,91.85,71.94 },
	[3] = { -1080.46,-2216.40,13.28 },
	[4] = { 1216.58,-2995.11,5.86 },
	[5] = { -15.95,-1105.02,26.67 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- WOODS
-----------------------------------------------------------------------------------------------------------------------------------------
local woods = {
	[1] = { -565.04,5359.85,70.21 },
	[2] = { -289.69,-2502.01,6.00 },
	[3] = { 567.05,-2735.02,6.05 },
	[4] = { 52.74,6541.27,31.46 },
	[5] = { 182.19,-2219.64,5.95 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOWS
-----------------------------------------------------------------------------------------------------------------------------------------
local show = {
	[1] = { 128.49,6361.89,31.25 },
	[2] = { -1136.16,-521.33,33.26 },
	[3] = { -258.01,-2089.43,27.62 },
	[4] = { 224.93,1239.33,225.46 },
	[5] = { 364.63,286.91,103.39 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- /PACK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("pack",function(source,args)
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(ped)
	local x,y,z = table.unpack(GetEntityCoords(ped))
	local distance = Vdist(x,y,z,CoordenadaX,CoordenadaY,CoordenadaZ)

	if distance <= 100.1 and not servico then
		if IsVehicleModel(vehicle,GetHashKey("phantom")) then
			if args[1] == "diesel" then
				myPlate = emP.setPlate()
				servico = true
				modules = args[1]
				servehicle = -1207431159
				random = math.random(#diesel)
				CoordenadaX2 = diesel[random][1]
				CoordenadaY2 = diesel[random][2]
				CoordenadaZ2 = diesel[random][3]
				CriandoBlip(CoordenadaX2,CoordenadaY2,CoordenadaZ2)
				TriggerEvent("Notify","importante","Entrega de <b>Diesel</b> iniciada, pegue o caminhão, a carga e vá até o destino marcado.",8000)
				createVehicles("armytanker")
			elseif args[1] == "gas" then
				myPlate = emP.setPlate()
				servico = true
				modules = args[1]
				servehicle = 1956216962
				random = math.random(#gas)
				CoordenadaX2 = gas[random][1]
				CoordenadaY2 = gas[random][2]
				CoordenadaZ2 = gas[random][3]
				CriandoBlip(CoordenadaX2,CoordenadaY2,CoordenadaZ2)
				TriggerEvent("Notify","importante","Entrega de <b>Combustível</b> iniciada, pegue o caminhão, a carga e vá até o destino marcado.",8000)
				createVehicles("tanker2")
			elseif args[1] == "cars" then
				myPlate = emP.setPlate()
				servico = true
				modules = args[1]
				servehicle = 2091594960
				random = math.random(#cars)
				CoordenadaX2 = cars[random][1]
				CoordenadaY2 = cars[random][2]
				CoordenadaZ2 = cars[random][3]
				CriandoBlip(CoordenadaX2,CoordenadaY2,CoordenadaZ2)
				TriggerEvent("Notify","importante","Entrega de <b>Veículos</b> iniciada, pegue o caminhão, a carga e vá até o destino marcado.",8000)
				createVehicles("tr4")
			elseif args[1] == "woods" then
				myPlate = emP.setPlate()
				servico = true
				modules = args[1]
				servehicle = 2016027501
				random = math.random(#woods)
				CoordenadaX2 = woods[random][1]
				CoordenadaY2 = woods[random][2]
				CoordenadaZ2 = woods[random][3]
				CriandoBlip(CoordenadaX2,CoordenadaY2,CoordenadaZ2)
				TriggerEvent("Notify","importante","Entrega de <b>Madeiras</b> iniciada, pegue o caminhão, a carga e vá até o destino marcado.",8000)
				createVehicles("trailerlogs")
			elseif args[1] == "show" then
				myPlate = emP.setPlate()
				servico = true
				modules = args[1]
				servehicle = -1770643266
				random = math.random(#show)
				CoordenadaX2 = show[random][1]
				CoordenadaY2 = show[random][2]
				CoordenadaZ2 = show[random][3]
				CriandoBlip(CoordenadaX2,CoordenadaY2,CoordenadaZ2)
				TriggerEvent("Notify","importante","Entrega de <b>Shows</b> iniciada, pegue o caminhão, a carga e vá até o destino marcado.",8000)
				createVehicles("tvtrailer")
			else
				TriggerEvent("Notify","aviso","<b>Disponíveis:</b> diesel, cars, show, woods e gas",8000)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ENTREGAR
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		if servico then
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local distance = Vdist(x,y,z,CoordenadaX2,CoordenadaY2,CoordenadaZ2)

			if distance <= 100.0 then
				DrawMarker(23,CoordenadaX2,CoordenadaY2,CoordenadaZ2-0.96,0,0,0,0,0,0,10.0,10.0,1.0,136, 96, 240, 180,0,0,0,0)
				if distance <= 5.9 then
					if IsControlJustPressed(1,38) then
						local vehicle = getVehicleInDirection(GetEntityCoords(ped),GetOffsetFromEntityInWorldCoords(ped,0.0,5.0,0.0))
						if GetEntityModel(vehicle) == servehicle then
							emP.checkPayment(random,modules,parseInt(GetVehicleBodyHealth(GetPlayersLastVehicle())))
							RemoveBlip(blips)
							servico = false
							SetTimeout(10000,function()
								TriggerServerEvent("tryDeleteVehicle",VehToNet(vehicle))
								Citizen.Wait(1000)
								if DoesEntityExist(vehicle) then
									TriggerServerEvent("tryDeleteVehicle",VehToNet(vehicle))
								end
							end)
						end
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CANCELSERVICE
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		if servico and IsControlJustPressed(1,121) then
			servico = false
			RemoveBlip(blips)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
function getVehicleInDirection(coordsfrom,coordsto)
	local handle = CastRayPointToPoint(coordsfrom.x,coordsfrom.y,coordsfrom.z,coordsto.x,coordsto.y,coordsto.z,10,GetPlayerPed(-1),false)
	local a,b,c,d,vehicle = GetRaycastResult(handle)
	return vehicle
end

function CriandoBlip(x,y,z)
	blips = AddBlipForCoord(x,y,z)
	SetBlipSprite(blips,1)
	SetBlipColour(blips,5)
	SetBlipScale(blips,0.4)
	SetBlipAsShortRange(blips,false)
	SetBlipRoute(blips,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Entrega de Carga")
	EndTextCommandSetBlipName(blips)
end

function createVehicles(vname)
	local ped = PlayerPedId()
	local mhash = GetHashKey(vname)

	RequestModel(mhash)
	while not HasModelLoaded(mhash) do
		RequestModel(mhash)
		Citizen.Wait(10)
	end

	local nveh = CreateVehicle(mhash,GetEntityCoords(ped),GetEntityHeading(ped),true,false)

	SetVehicleOnGroundProperly(nveh)
	SetEntityInvincible(nveh,false)
	SetEntityAsMissionEntity(nveh,true,true)
	SetVehicleNumberPlateText(nveh,myPlate)

	AttachVehicleToTrailer(GetVehiclePedIsUsing(ped),nveh,10.0)

	SetModelAsNoLongerNeeded(mhash)
end