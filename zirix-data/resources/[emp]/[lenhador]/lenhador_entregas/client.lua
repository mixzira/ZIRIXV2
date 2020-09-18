local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
emP = Tunnel.getInterface("lenhador_entregas")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local blips = false
local servico = false
local selecionado = 0
local CoordenadaX = 1218.74
local CoordenadaY = -1266.87
local CoordenadaZ = 36.42
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESIDENCIAS
-----------------------------------------------------------------------------------------------------------------------------------------
local locs = {
	[1] = { 1124.79,-2369.15,30.10 },
	[2] = { 271.83,-3153.45,4.98 },
	[3] = { 109.74,-2672.04,5.19 },
	[4] = { -26.02,-2670.99,5.19 },
	[5] = { -112.58,-2700.43,5.19 },
	[6] = { -363.03,-2790.88,5.18 },
	[7] = { -218.08,-2501.01,5.19 },
	[8] = { 952.12,-1512.69,30.23 },
	[9] = { 705.52,-1392.25,25.49 },
	[10] = { 772.66,-1196.22,23.47 },
	[11] = { 815.98,-874.28,24.43 },
	[12] = { 728.53,-863.43,23.83 },
	[13] = { 737.00,-652.98,27.46 },
	[14] = { -380.40,397.44,107.55 },
	[15] = { -930.52,409.17,78.57 },
	[16] = { -1176.63,-493.07,34.77 },
	[17] = { -1050.41,-548.03,34.16 },
	[18] = { -1099.02,-1643.29,3.72 },
	[19] = { -728.40,-1498.21,4.19 },
	[20] = { -1156.71,-1984.25,12.35 },
	[21] = { -463.52,-2172.48,9.26 },
	[22] = { -109.44,-2213.78,7.00 },
	[23] = { -553.36,-1642.20,18.25 },
	[24] = { -310.18,-1171.19,23.37 },
	[25] = { -159.29,-974.10,21.27 },
	[26] = { -121.97,-1030.47,27.27 },
	[27] = { 1404.78,-736.41,67.15 },
	[28] = { -569.03,776.12,185.89 },
	[29] = { -1116.77,-978.27,1.82 },
	[30] = { -1207.30,-1794.82,3.58 }
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
		if not servico then
			local ped = PlayerPedId()
			if not IsPedInAnyVehicle(ped) then
				local x,y,z = table.unpack(GetEntityCoords(ped))
				if Vdist(x,y,z,CoordenadaX,CoordenadaY,CoordenadaZ) <= 30.0 then
					DrawMarker(23,CoordenadaX,CoordenadaY,CoordenadaZ-0.97,0,0,0,0,0,0,1.0,1.0,0.5,240,200,80,20,0,0,0,0)
					if Vdist(x,y,z,CoordenadaX,CoordenadaY,CoordenadaZ) <= 1.2 then
						drawTxt("PRESSIONE  ~b~E~w~  PARA INICIAR ENTREGAS",4,0.5,0.93,0.50,255,255,255,180)
						if IsControlJustPressed(1,38) then
							CalculateTimeToDisplay()
							if parseInt(hora) >= 06 and parseInt(hora) <= 20 then
								servico = true
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
-- ENTREGAS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		if servico then
			local ped = PlayerPedId()
			if IsPedInAnyVehicle(ped) then
				local x,y,z = table.unpack(GetEntityCoords(ped))
				if Vdist(x,y,z,locs[selecionado][1],locs[selecionado][2],locs[selecionado][3]) <= 30.0 and IsVehicleModel(GetVehiclePedIsUsing(ped),GetHashKey("ratloader")) then
					DrawMarker(21,locs[selecionado][1],locs[selecionado][2],locs[selecionado][3]+0.5,0,0,0,0,180.0,130.0,2.0,2.0,1.0,240,200,80,20,1,0,0,1)
					if Vdist(x,y,z,locs[selecionado][1],locs[selecionado][2],locs[selecionado][3]) <= 2.5 then
						drawTxt("PRESSIONE  ~b~E~w~  PARA ENTREGAR TORAS DE MADEIRA",4,0.5,0.93,0.50,255,255,255,255)
						if IsControlJustPressed(1,38) then
							CalculateTimeToDisplay()
							if parseInt(hora) >= 06 and parseInt(hora) <= 20 then
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
	AddTextComponentString("Entrega de Madeira")
	EndTextCommandSetBlipName(blips)
end