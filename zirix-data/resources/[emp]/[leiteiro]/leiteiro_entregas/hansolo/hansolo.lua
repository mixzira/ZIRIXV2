local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")

--[ CONEXÃO ]----------------------------------------------------------------------------------------------------------------------------

emP = Tunnel.getInterface("leiteiro_entregas")

--[ VARIÁVEIS ]--------------------------------------------------------------------------------------------------------------------------

local blips = false
local servico = false
local selecionado = 0
local CoordenadaX = 2335.42 
local CoordenadaY = 4859.87
local CoordenadaZ = 41.81
local quantidade = 0

--[ RESIDENCIAS ]------------------------------------------------------------------------------------------------------------------------

local locs = {
	[1] = { ['x'] = -47.18, ['y'] = -1756.54, ['z'] = 29.43 },
	[2] = { ['x'] = 25.66, ['y'] = -1347.27, ['z'] = 29.5 }, 
	[3] = { ['x'] = -707.3, ['y'] = -912.88, ['z'] = 19.22 }, 
	[4] = { ['x'] = -1486.17, ['y'] = -380.32, ['z'] = 40.17 }, 
	[5] = { ['x'] = 1135.48, ['y'] = -980.48, ['z'] = 46.42 }, 
	[6] = { ['x'] = 1163.33, ['y'] = -322.12, ['z'] = 69.21 }, 
	[7] = { ['x'] = -2967.94, ['y'] = 389.41, ['z'] = 15.04 }, 
	[8] = { ['x'] = 373.78, ['y'] = 325.67, ['z'] = 103.57 }, 
	[9] = { ['x'] = -1224.17, ['y'] = -908.10, ['z'] = 12.32 }
}

--[ TRABALHAR ]--------------------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
	while true do
		local idle = 1000
		if not servico then
			idle = 5
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(CoordenadaX,CoordenadaY,CoordenadaZ)
			local distance = GetDistanceBetweenCoords(CoordenadaX,CoordenadaY,cdz,x,y,z,true)
			if distance < 10.1 then
				DrawMarker(23, CoordenadaX, CoordenadaY, CoordenadaZ-0.99, 0, 0, 0, 0, 0, 0, 0.7, 0.7, 0.5, 234, 203, 102, 220, 0, 0, 0, 0)
				if distance < 1.2 then
					drawTxt("PRESSIONE  ~y~E~w~  PARA INICIAR AS ENTREGAS",4,0.5,0.92,0.35,255,255,255,180)
					if IsControlJustPressed(0,38) then
						servico = true
						selecionado = math.random(9)
						CriandoBlip(locs,selecionado)
						emP.Quantidade()
						TriggerEvent("Notify","sucesso","Você entrou em serviço.")
						TriggerEvent("Notify","importante","Vá até o próximo local e entregue <b>"..quantidade.."x Garrafas de Leite</b>.")
					end
				end
			end
		end
		Citizen.Wait(idle)
	end
end)

--[ ENTREGAS ]---------------------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
	while true do
		local idle = 1000
		if servico then
			idle = 5
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(locs[selecionado].x,locs[selecionado].y,locs[selecionado].z)
			local distance = GetDistanceBetweenCoords(locs[selecionado].x,locs[selecionado].y,cdz,x,y,z,true)
			if distance < 5.3 then
				DrawMarker(23, locs[selecionado].x, locs[selecionado].y, locs[selecionado].z-0.97, 0, 0, 0, 0, 0, 0, 0.7, 0.7, 0.5, 234, 203, 102, 220, 0, 0, 0, 0)
				if distance < 1.2 then
					drawTxt("PRESSIONE  ~y~E~w~  PARA ENTREGAR AS GARRAFAS DE LEITE",4,0.5,0.92,0.35,255,255,255,180)
					if IsControlJustPressed(0,38) then
						if emP.checkPayment() then
							RemoveBlip(blips)
							backentrega = selecionado
							while true do
								if backentrega == selecionado then
									selecionado = math.random(9)
								else
									break
								end
								Citizen.Wait(1)
							end
							CriandoBlip(locs,selecionado)
							TriggerEvent("Notify","importante","Vá até o próximo local e entregue <b>"..quantidade.."x Garrafas de Leite</b>.")
						end
					end
				end
			end
		end
		Citizen.Wait(idle)
	end
end)

--[ CANCELAR ]---------------------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		if servico then
			if IsControlJustPressed(0,121) then
				TriggerEvent("Notify","importante","Vá até o próximo local e entregue <b>"..quantidade.."x Garrafas de Leite</b>.")
			elseif IsControlJustPressed(0,168) then
				servico = false
				RemoveBlip(blips)
				TriggerEvent("Notify","aviso","Você saiu de serviço.")
			end
		end
	end
end)

RegisterNetEvent("quantidade-leite")
AddEventHandler("quantidade-leite",function(status)
    quantidade = status
end)

--[ FUNÇÕES ]----------------------------------------------------------------------------------------------------------------------------

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
	blips = AddBlipForCoord(locs[selecionado].x,locs[selecionado].y,locs[selecionado].z)
	SetBlipSprite(blips,1)
	SetBlipColour(blips,5)
	SetBlipScale(blips,0.4)
	SetBlipAsShortRange(blips,false)
	SetBlipRoute(blips,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Entrega de Leite")
	EndTextCommandSetBlipName(blips)
end