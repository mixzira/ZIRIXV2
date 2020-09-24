local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

--[ CONNECTION ]----------------------------------------------------------------------------------------------------------------

emp = Tunnel.getInterface("emp_garbageman")

--[ VARIABLES ]-----------------------------------------------------------------------------------------------------------------

local blips = false
local working = false
local onTrash = false
local trashHand = false
local trashSpawn = false
local onRota = false
local onLocal = false
local trashOn = false
local selected = 0
local hour = 0

local coordX = -349.99
local coordY = -1569.89
local coordZ = 25.23

local locs = {
	[1] = { ['x'] = -361.81, ['y'] = -1864.69, ['z'] = 20.52 },
	[2] = { ['x'] = 123.46, ['y'] = -2058.40, ['z'] = 18.33 },
	[3] = { ['x'] = 226.48, ['y'] = -1953.29, ['z'] = 22.10 },
	[4] = { ['x'] = 146.09, ['y'] = -1869.88, ['z'] = 24.05 },
	[5] = { ['x'] = 135.21, ['y'] = -1718.60, ['z'] = 29.23 },
	[6] = { ['x'] = -172.81, ['y'] = -1458.24, ['z'] = 31.63 },
	[7] = { ['x'] = -86.39, ['y'] = -1379.98, ['z'] = 29.35 },
	[8] = { ['x'] = 217.43, ['y'] = -1341.94, ['z'] = 29.28 },
	[9] = { ['x'] = 377.98, ['y'] = -1270.77, ['z'] = 32.46 },
	[10] = { ['x'] = 489.78, ['y'] = -995.11, ['z'] = 27.73 },
	[11] = { ['x'] = 446.03, ['y'] = -684.05, ['z'] = 28.52 },
	[12] = { ['x'] = 313.60, ['y'] = -736.85, ['z'] = 29.31 },
	[13] = { ['x'] = 257.97, ['y'] = -984.02, ['z'] = 29.32 },
	[14] = { ['x'] = 178.65, ['y'] = -1122.83, ['z'] = 29.30 },
	[15] = { ['x'] = 23.37, ['y'] = -1115.96, ['z'] = 29.23 },
	[16] = { ['x'] = -245.71, ['y'] = -1128.06, ['z'] = 23.02 },
	[17] = { ['x'] = -527.08, ['y'] = -979.96, ['z'] = 23.35 },
	[18] = { ['x'] = -438.71, ['y'] = -674.48, ['z'] = 31.12 },
	[19] = { ['x'] = -63.58, ['y'] = -262.00, ['z'] = 45.43 },
	[20] = { ['x'] = 264.62, ['y'] = -382.44, ['z'] = 44.85 },
	[21] = { ['x'] = 706.38, ['y'] = -300.32, ['z'] = 59.23 },
	[22] = { ['x'] = 1180.07, ['y'] = -304.01, ['z'] = 69.07 },
	[23] = { ['x'] = 1267.84, ['y'] = -423.12, ['z'] = 69.09 },
	[24] = { ['x'] = 1250.96, ['y'] = -569.47, ['z'] = 69.09 },
	[25] = { ['x'] = 1215.92, ['y'] = -729.22, ['z'] = 58.95 },
	[26] = { ['x'] = 1192.33, ['y'] = -598.85, ['z'] = 63.99 },
	[27] = { ['x'] = 1004.67, ['y'] = -526.71, ['z'] = 60.39 },
	[28] = { ['x'] = 1058.06, ['y'] = -787.24, ['z'] = 58.26 },
	[29] = { ['x'] = 1142.82, ['y'] = -985.73, ['z'] = 45.95 },
	[30] = { ['x'] = 1216.37, ['y'] = -1188.17, ['z'] = 36.66 },
	[31] = { ['x'] = 1219.41, ['y'] = -1381.39, ['z'] = 35.27 },
	[32] = { ['x'] = 1267.77, ['y'] = -1581.03, ['z'] = 52.77 },
	[33] = { ['x'] = 1168.06, ['y'] = -1651.60, ['z'] = 36.77 },
	[34] = { ['x'] = 1056.75, ['y'] = -1887.50, ['z'] = 30.33 },
	[35] = { ['x'] = 934.44, ['y'] = -1977.39, ['z'] = 30.24 },
	[36] = { ['x'] = 909.75, ['y'] = -2214.58, ['z'] = 30.49 },
	[37] = { ['x'] = 286.43, ['y'] = -2092.90, ['z'] = 16.81 },
	[38] = { ['x'] = 337.75, ['y'] = -1966.46, ['z'] = 24.45 }
}

--[ EVENTS ]--------------------------------------------------------------------------------------------------------------------

function CalculateTimeToDisplay()
	hour = GetClockHours()
	if hour <= 9 then
		hour = "0" .. hour
	end
end

--[ EVENTS ]--------------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
	while true do
		local idle = 1000
		local ped = PlayerPedId()
		if not IsPedInAnyVehicle(ped) then
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(coordX,coordY,coordZ)
			local distance = GetDistanceBetweenCoords(coordX,coordY,cdz,x,y,z,true)
			if distance < 10.1 then
				idle = 5
				DrawMarker(23,coordX,coordY,coordZ-0.99,0,0,0,0,0,0,1.0,1.0,0.5,136, 96, 240, 180,0,0,0,0)
				
				if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), coordX, coordY, coordZ, true ) < 1.3 then
					DrawText3D(coordX, coordY, coordZ, "Pressione [~p~E~w~] para iniciar a coleta de ~p~LIXO~w~.")
				end
				
				if distance < 1.1 then
					if IsControlJustPressed(1,38) then
						CalculateTimeToDisplay()
						if parseInt(hour) >= 06 and parseInt(hour) <= 20 then
							if not working then
								working = true
							  	selected = 1
							  	createBlip(locs,selected)
						  	end
						else
							TriggerEvent("Notify","importante","Funcionamento é das <b>06:00</b> as <b>20:00</b>.",8000)
						end
					end
				end
			end
		end
		Citizen.Wait(idle)
	end
end)

--[ FUNCTION ]------------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
	while true do
		local idle = 1000
		if working then
			idle = 5
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(locs[selected].x,locs[selected].y,locs[selected].z)
			local distance = GetDistanceBetweenCoords(locs[selected].x,locs[selected].y,cdz,x,y,z,true)
			local ped = PlayerPedId()

			local coord = GetOffsetFromEntityInWorldCoords(PlayerPedId(),0.0,1.0,-0.94)
			local prop = "prop_cs_rub_binbag_01"

			if distance >= 20.0 then
				onRota = true
				onLocal = false
				trashOn = false
			else
				onRota = false
				onLocal = true
				onTrash = true
			end

			if IsPedInAnyVehicle(ped) then
				drawTxt("PRESSIONE ~r~F7~w~ PARA ENCERRAR O SERVIÇO",4,0.218,0.963,0.35,255,255,255,120)
			else
				drawTxt("PRESSIONE ~r~F7~w~ PARA ENCERRAR O SERVIÇO",4,0.068,0.963,0.35,255,255,255,120)
			end

			if onRota then
				if IsPedInAnyVehicle(ped) then
					drawTxt("VÁ ATÉ O LOCAL DE COLETA DE LIXO",4,0.220,0.938,0.45,255,255,255,200)
				else
					drawTxt("VÁ ATÉ O LOCAL DE COLETA DE LIXO",4,0.070,0.938,0.45,255,255,255,200)
				end
			end

			if onLocal then
				if IsPedInAnyVehicle(ped) then
					drawTxt("PEGUE O SACO DE LIXO E JOGUE NO CAMINHÃO",4,0.242,0.938,0.45,255,255,255,200)
				else
					drawTxt("PEGUE O SACO DE LIXO E JOGUE NO CAMINHÃO",4,0.091,0.938,0.45,255,255,255,200)
				end
			end

			if onTrash then
				if DoesObjectOfTypeExistAtCoords(locs[selected].x,locs[selected].y,locs[selected].z-0.97,0.9,GetHashKey(prop),true) then
					onTrash = false
				else
					if not trashOn then
						if nome ~= "d" then
							sacolixo = CreateObject(GetHashKey(prop),locs[selected].x,locs[selected].y,locs[selected].z-0.97,true,true,true)
							PlaceObjectOnGroundProperly(sacolixo)
							SetModelAsNoLongerNeeded(sacolixo)
							Citizen.InvokeNative(0xAD738C3085FE7E11,sacolixo,true,true)
							FreezeEntityPosition(sacolixo,true)
							SetEntityAsNoLongerNeeded(sacolixo)
						end
						onTrash = false
						trashOn = true
						trashSpawn = true
					end
				end
			end

			if distance <= 1.5 then
				if trashSpawn then
					drawTxt("PRESSIONE ~b~E~w~ PARA PEGAR O SACO DE LIXO",4,0.5,0.93,0.50,255,255,255,180)
					if IsControlJustPressed(0,38) then
						sacolixo = GetClosestObjectOfType(locs[selected].x,locs[selected].y,locs[selected].z-0.97,0.9,GetHashKey(prop),false,false,false)
						Citizen.InvokeNative(0xAD738C3085FE7E11,sacolixo,true,true)
						SetObjectAsNoLongerNeeded(Citizen.PointerValueIntInitialized(sacolixo))
						DeleteObject(sacolixo)
						vRP.CarregarObjeto("","","prop_cs_rub_binbag_01",50,57005,0.11,0,0.0,0)
						trashHand = true
						trashSpawn = false
					end
				end
			end

			local vehicle = vRP.getNearestVehicle(7)
			local portaMalas = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle,"boot"))
			local distanciaPortaMalas = GetDistanceBetweenCoords(portaMalas, coord, 2)

			if trashHand then
				if distanciaPortaMalas <= 2 then
					drawTxt("PRESSIONE ~b~E~w~ PARA JOGAR A SACOLA DE LIXO NO CAMINHAO",4,0.5,0.93,0.50,255,255,255,180)
					if IsControlJustPressed(0,38) then
						vRP._DeletarObjeto()
						emp.payment()
						RemoveBlip(blips)
						if selected == #locs then
							selected = 1
						else
							selected = selected + 1
						end
						createBlip(locs,selected)
						trashHand = false
						onRota = true
					end
				end
			end
		end
		Citizen.Wait(idle)
	end
end)

--[ CANCEL | THREAD ]-----------------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
	while true do
		local idle = 1000
		if working then
			idle = 5
			if IsControlJustPressed(0,168) then
				working = false
				RemoveBlip(blips)
			end
		end
		Citizen.Wait(idle)
	end
end)

--[ FUNCTION ]------------------------------------------------------------------------------------------------------------------

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
	blips = AddBlipForCoord(locs[selected].x,locs[selected].y,locs[selected].z)
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