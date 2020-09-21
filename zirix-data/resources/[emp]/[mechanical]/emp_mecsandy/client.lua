local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
emP = Tunnel.getInterface("emp_mecsandy")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local blips = false
local servico = false
local selecionado = 0
local CoordenadaX = 1187.17
local CoordenadaY = 2635.83
local CoordenadaZ = 38.40
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESIDENCIAS
-----------------------------------------------------------------------------------------------------------------------------------------
local locs = {
	[1] = { 567.72,2728.02,42.06 },
	[2] = { 243.52,2579.30,45.44 },
	[3] = { 364.62,3411.81,36.40 },
	[4] = { 909.81,3589.96,33.21 },
	[5] = { 1699.62,3583.21,35.50 },
	[6] = { 1964.52,3845.82,31.99 },
	[7] = { 2465.30,4073.92,38.06 },
	[8] = { 2524.05,4193.69,39.95 },
	[9] = { 53.75,3712.55,39.75 },
	[10] = { 1641.44,4834.34,42.02 },
	[11] = { 1973.58,5167.04,47.63 },
	[12] = { 2909.58,4371.47,50.37 }
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
					DrawMarker(23,CoordenadaX,CoordenadaY,CoordenadaZ-0.97,0,0,0,0,0,0,1.0,1.0,0.5,136, 96, 240, 180,0,0,0,0)
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
					DrawMarker(21,locs[selecionado][1],locs[selecionado][2],locs[selecionado][3]+0.30,0,0,0,0,180.0,130.0,2.0,2.0,1.0,136, 96, 240, 180,1,0,0,1)
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