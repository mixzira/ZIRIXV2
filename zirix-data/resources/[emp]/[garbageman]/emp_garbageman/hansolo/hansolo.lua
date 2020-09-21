local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

--[ CONNECTION ]----------------------------------------------------------------------------------------------------------------

emP = Tunnel.getInterface("emp_garbageman")

--[ VARIABLES ]-----------------------------------------------------------------------------------------------------------------

local blips = false
local servico = false
local selecionado = 0
local CoordenadaX = -349.84
local CoordenadaY = -1569.79
local CoordenadaZ = 25.22
local locs = {
	[1] = { -364.39,-1864.58,20.24 },
	[2] = { 119.92,-2049.79,18.00 },
	[3] = { 140.51,-1876.13,23.52 },
	[4] = { 159.26,-1814.52,28.13 },
	[5] = { 241.46,-1944.45,23.12 },
	[6] = { 447.58,-1936.93,24.31 },
	[7] = { 487.06,-1515.02,29.00 },
	[8] = { 419.46,-1526.35,28.99 },
	[9] = { 266.11,-1493.93,28.92 },
	[10] = { 120.39,-1545.78,28.95 },
	[11] = { 136.37,-1369.56,28.95 },
	[12] = { -13.08,-1388.95,29.10 },
	[13] = { 482.05,-1279.73,29.25 },
	[14] = { 430.18,-1066.45,28.92 },
	[15] = { 305.60,-1038.61,28.89 },
	[16] = { 241.49,-831.53,29.62 },
	[17] = { 18.98,-544.66,36.34 },
	[18] = { 7.39,-366.43,40.23 },
	[19] = { 303.37,-259.79,53.67 },
	[20] = { 973.44,-158.95,73.09 },
	[21] = { 921.25,47.69,80.48 },
	[22] = { 916.12,-194.66,72.63 },
	[23] = { 587.96,67.51,93.18 },
	[24] = { 312.00,329.08,105.16 },
	[25] = { -381.52,289.96,84.55 },
	[26] = { -601.73,270.61,81.69 },
	[27] = { -1239.73,405.86,75.35 },
	[28] = { -1772.09,-478.61,39.42 },
	[29] = { -1977.30,-488.59,11.45 },
	[30] = { -1320.02,-1216.42,4.49 },
	[31] = { -1208.72,-1411.40,3.89 },
	[32] = { -1111.55,-1549.99,4.08 },
	[33] = { -574.54,-857.53,25.97 },
	[34] = { -352.88,-959.45,30.79 },
	[35] = { 49.47,-1240.88,28.94 },
	[36] = { -148.22,-1296.49,30.78 },
	[37] = { -333.68,-1366.33,31.01 },
	[38] = { -303.08,-1538.89,26.32 }
}

--[ IN WORKING AREA | THREAD ]--------------------------------------------------------------------------------------------------

local hora = 0
function CalculateTimeToDisplay()
	hora = GetClockHours()
	if hora <= 9 then
		hora = "0" .. hora
	end
end

--[ IN WORKING AREA | THREAD ]--------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		if not servico then
			local ped = PlayerPedId()
			if not IsPedInAnyVehicle(ped) then
				local x,y,z = table.unpack(GetEntityCoords(ped))
				local distance = Vdist(x,y,z,CoordenadaX,CoordenadaY,CoordenadaZ)
				if distance <= 30.0 then
					DrawMarker(23,CoordenadaX,CoordenadaY,CoordenadaZ-0.97,0,0,0,0,0,0,1.0,1.0,0.5,136, 96, 240, 180,0,0,0,0)
					if distance <= 1.2 then
						drawTxt("PRESSIONE  ~b~E~w~  PARA INICIAR A COLETA",4,0.5,0.93,0.50,255,255,255,180)
						if IsControlJustPressed(1,38) then
							CalculateTimeToDisplay()
							if parseInt(hora) >= 06 and parseInt(hora) <= 20 then
								servico = true
								selecionado = 1
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

--[ IN WORKING AREA | THREAD ]--------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		if servico then
			local ped = PlayerPedId()
			if IsPedInAnyVehicle(ped) then
				local vehicle = GetVehiclePedIsUsing(ped)
				local x,y,z = table.unpack(GetEntityCoords(ped))
				local distance = Vdist(x,y,z,locs[selecionado][1],locs[selecionado][2],locs[selecionado][3])

				if distance <= 30.0 and IsVehicleModel(vehicle,GetHashKey("trash")) then
					DrawMarker(21,locs[selecionado][1],locs[selecionado][2],locs[selecionado][3]+0.30,0,0,0,0,180.0,130.0,2.0,2.0,1.0,136, 96, 240, 180,1,0,0,1)
					if distance <= 5.1 then
						drawTxt("PRESSIONE  ~b~E~w~  PARA COLETAR SACO DE LIXO",4,0.5,0.93,0.50,255,255,255,180)
						if IsControlJustPressed(1,38) then
							CalculateTimeToDisplay()
							if parseInt(hora) >= 06 and parseInt(hora) <= 20 then
								if emP.checkPayment() then
									RemoveBlip(blips)
									if selecionado == #locs then
										selecionado = 1
									else
										selecionado = selecionado + 1
									end
									CriandoBlip(locs,selecionado)
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

--[ IN WORKING AREA | THREAD ]--------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		if servico then
			if IsControlJustPressed(1,121) then
				servico = false
				RemoveBlip(blips)
			end
		end
	end
end)

--[ IN WORKING AREA | THREAD ]--------------------------------------------------------------------------------------------------

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

function CriandoBlip(locs,selecionado)
	blips = AddBlipForCoord(locs[selecionado][1],locs[selecionado][2],locs[selecionado][3])
	SetBlipSprite(blips,1)
	SetBlipColour(blips,5)
	SetBlipScale(blips,0.4)
	SetBlipAsShortRange(blips,false)
	SetBlipRoute(blips,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Coleta de Lixo")
	EndTextCommandSetBlipName(blips)
end