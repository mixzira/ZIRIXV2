local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

--[ CONNECTION ]----------------------------------------------------------------------------------------------------------------

emp = Tunnel.getInterface("emp_garbageman")

--[ VARIABLES ]-----------------------------------------------------------------------------------------------------------------

local blips = false
local working = false
local selected = 0
local hour = 0
local coordX = -351.05
local coordY = -1566.82
local coordZ = 25.23
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

function CalculateTimeToDisplay()
	hour = GetClockHours()
	if hour <= 9 then
		hour = "0" .. hour
	end
end

--[ IN WORKING AREA | COAMMAND ]------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
	while true do
		local idle = 1000
		local ped = PlayerPedId()
		if not IsPedInAnyVehicle(ped) then
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local distance = Vdist(x,y,z,coordX,coordY,coordZ)
			if distance < 5.1 then
				idle = 5
				DrawMarker(23,coordX,coordY,coordZ-0.97,0,0,0,0,0,0,1.0,1.0,0.5,136, 96, 240, 180,0,0,0,0)

				if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), coordX,coordY,coordZ, true ) <= 1.1  then
					DrawText3D(coordX,coordY,coordZ, "Pressione [~p~E~w~] para iniciar a coleta de ~p~LIXO~w~.")
				end

				if distance < 1.3 then
					if IsControlJustPressed(1,38) and emp.checkCrimeRecord() then
						if not working then
							CalculateTimeToDisplay()
							if parseInt(hour) >= 06 and parseInt(hour) <= 20 then
								working = true
								selected = 1
								createBlip(locs,selected)
								TriggerEvent("Notify","sucesso","Entrou em <b>serviço</b>.")
							else
								TriggerEvent("Notify","importante","Funcionamento é das <b>06:00</b> as <b>20:00</b>.",8000)
							end
						end
					end
				end
			end
		end
		Citizen.Wait(idle)
	end
end)

--[ IN WORKING AREA | THREAD ]--------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
	while true do
		local idle = 1000
		if working then
			local ped = PlayerPedId()
			if IsPedInAnyVehicle(ped) then
				local vehicle = GetVehiclePedIsUsing(ped)
				local x,y,z = table.unpack(GetEntityCoords(ped))
				local distance = Vdist(x,y,z,locs[selected][1],locs[selected][2],locs[selected][3])

				if distance < 30.1 and IsVehicleModel(vehicle,GetHashKey("trash2")) then
					idle = 5
					DrawMarker(21,locs[selected][1],locs[selected][2],locs[selected][3]+0.30,0,0,0,0,180.0,130.0,2.0,2.0,1.0,136, 96, 240, 180,1,0,0,1)
					if distance <= 5.1 then

						drawTxt("PRESSIONE  ~b~E~w~  PARA COLETAR SACO DE LIXO",4,0.5,0.93,0.50,255,255,255,180)

						if IsControlJustPressed(1,38) and emp.checkCrimeRecord() then
							CalculateTimeToDisplay()
							
							if parseInt(hour) >= 06 and parseInt(hour) <= 20 then
								if emp.checkPayment() then
									RemoveBlip(blips)
									if selected == #locs then
										selected = 1
									else
										selected = selected + 1
									end
									createBlip(locs,selected)
								end
							else
								TriggerEvent("Notify","importante","Funcionamento é das <b>06:00</b> as <b>20:00</b>.",8000)
							end
						end
					end
				end
			end
		end
		Citizen.Wait(idle)
	end
end)

--[ IN WORKING AREA | THREAD ]--------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
	while true do
		local idle = 1000
		if working then
			idle = 1
			local ped = PlayerPedId()
			if IsPedInAnyVehicle(ped) then
				drawTxt("PRESSIONE ~r~F7~w~ PARA ENCERRAR A COLETA DE LIXO.",4,0.226,0.962,0.35,255,255,255,120)
			else
				drawTxt("PRESSIONE ~r~F7~w~ PARA ENCERRAR A COLETA DE LIXO.",4,0.072,0.962,0.35,255,255,255,120)
			end
			if IsControlJustPressed(1,121) then
				working = false
				RemoveBlip(blips)
			end
		end
		Citizen.Wait(idle)
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

function createBlip(locs,selected)
	blips = AddBlipForCoord(locs[selected][1],locs[selected][2],locs[selected][3])
	SetBlipSprite(blips,1)
	SetBlipColour(blips,5)
	SetBlipScale(blips,0.4)
	SetBlipAsShortRange(blips,false)
	SetBlipRoute(blips,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Coleta de Lixo")
	EndTextCommandSetBlipName(blips)
end

function DrawText3D(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.28, 0.28)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.005+ factor, 0.03, 41, 11, 41, 68)
end