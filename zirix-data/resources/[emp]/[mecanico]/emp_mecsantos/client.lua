local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
emP = Tunnel.getInterface("emp_mecsantos")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local blips = false
local servico = false
local selecionado = 0
local CoordenadaX = -238.7
local CoordenadaY = -1397.75
local CoordenadaZ = 31.29

--local -238.7,-1397.75,31.29
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESIDENCIAS
-----------------------------------------------------------------------------------------------------------------------------------------
local locs = {
	[1] = { 478.51,-1890.44,26.09 },
	[2] = { 976.53,-1825.05,31.15 },
	[3] = { 1200.32,-1384.76,35.22 },
	[4] = { 1140.96,-776.02,57.59 },
	[5] = { -561.63,302.25,83.17 },
	[6] = { -1151.40,-206.73,37.95 },
	[7] = { -2091.83,-314.17,13.02 },
	[8] = { -1608.39,-822.20,10.04 },
	[9] = { -522.23,-1212.54,18.18 },
	[10] = { -719.60,-933.34,19.01 },
	[11] = { -314.40,-1472.76,30.54 },
	[12] = { -75.83,-1763.12,29.49 },
	[13] = { 490.07,-1312.75,29.25 },
	[14] = { 717.47,-1089.01,22.36 },
	[15] = { 1184.65,-334.11,69.17 },
	[16] = { -744.50,-1503.57,5.00 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRABALHAR
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		if not servico then
			local ped = PlayerPedId()
			if not IsPedInAnyVehicle(ped) then
				local x,y,z = table.unpack(GetEntityCoords(ped))
				local distance = Vdist(x,y,z,CoordenadaX,CoordenadaY,CoordenadaZ)
				if distance <= 30.0 then
					DrawMarker(23,CoordenadaX,CoordenadaY,CoordenadaZ-0.97,0,0,0,0,0,0,1.0,1.0,0.5,240,200,80,20,0,0,0,0)
					if distance <= 1.2 then
						drawTxt("PRESSIONE  ~b~E~w~  PARA INICIAR ENTREGAS",4,0.5,0.93,0.50,255,255,255,180)
						if IsControlJustPressed(1,38) and emP.checkPermission() then
							servico = true
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
-- ENTREGAS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		if servico then
			local ped = PlayerPedId()
			if IsPedInAnyVehicle(ped) then
				local x,y,z = table.unpack(GetEntityCoords(ped))
				local distance = Vdist(x,y,z,locs[selecionado][1],locs[selecionado][2],locs[selecionado][3])
				if distance <= 30.0 and (IsVehicleModel(GetVehiclePedIsUsing(ped),GetHashKey("flatbed")) or IsVehicleModel(GetVehiclePedIsUsing(ped),GetHashKey("towtruck2"))) then
					DrawMarker(21,locs[selecionado][1],locs[selecionado][2],locs[selecionado][3]+0.30,0,0,0,0,180.0,130.0,2.0,2.0,1.0,240,200,80,20,1,0,0,1)
					if distance <= 4.1 then
						drawTxt("PRESSIONE  ~b~E~w~  PARA ENTREGAR FERRAMENTA",4,0.5,0.93,0.50,255,255,255,180)
						if IsControlJustPressed(1,38) and emP.checkPermission() then
							if emP.checkPayment() then
								RemoveBlip(blips)
								backentrega = selecionado
								while true do
									if backentrega == selecionado then
										selecionado = math.random(#locs)
									else
										break
									end
									Citizen.Wait(10)
								end
								CriandoBlip(locs,selecionado)
							end
						end
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CANCELAR
-----------------------------------------------------------------------------------------------------------------------------------------
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

function CriandoBlip(locs,selecionado)
	blips = AddBlipForCoord(locs[selecionado][1],locs[selecionado][2],locs[selecionado][3])
	SetBlipSprite(blips,1)
	SetBlipColour(blips,5)
	SetBlipScale(blips,0.4)
	SetBlipAsShortRange(blips,false)
	SetBlipRoute(blips,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Entrega de Ferramenta")
	EndTextCommandSetBlipName(blips)
end