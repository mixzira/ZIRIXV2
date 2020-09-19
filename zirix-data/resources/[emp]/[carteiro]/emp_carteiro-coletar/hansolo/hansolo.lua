local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

--[ CONNECTION ]----------------------------------------------------------------------------------------------------------------

func = Tunnel.getInterface("carteiro_coletar")

--[ VARIABLES ]-----------------------------------------------------------------------------------------------------------------

local process = false
local CoordenadaX = 78.93
local CoordenadaY = 112.45
local CoordenadaZ = 81.16

--[ TIME | FUNCTION ]-----------------------------------------------------------------------------------------------------------

local time = 0
function CalculateTimeToDisplay()
	time = GetClockHours()
	if time <= 9 then
		time = "0" .. time
	end
end

--[ PROCESS | THREAD ]----------------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
	while true do
		local idle = 1000
		if not process then
			local ped = PlayerPedId()
			if not IsPedInAnyVehicle(ped) then
				local x,y,z = table.unpack(GetEntityCoords(ped))
				if Vdist(CoordenadaX,CoordenadaY,CoordenadaZ,x,y,z) < 5.1 then
					DrawMarker(23, CoordenadaX, CoordenadaY, CoordenadaZ-0.99, 0, 0, 0, 0, 0, 0, 0.7, 0.7, 0.5, 136, 96, 240, 180, 0, 0, 0, 0)
					if Vdist(CoordenadaX,CoordenadaY,CoordenadaZ,x,y,z) <= 1.2 then

						if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), CoordenadaX,CoordenadaY,CoordenadaZ, true ) <= 1.1 and not process then
							DrawText3D(CoordenadaX,CoordenadaY,CoordenadaZ, "Pressione [~p~E~w~] para empacotar as ~p~ENCOMENDAS~w~.")
						end

						if IsControlJustPressed(1,38) then
							CalculateTimeToDisplay()
							if parseInt(time) >= 06 and parseInt(time) <= 20 then
								if func.checkPayment() then
									process = true
									TriggerEvent('cancelando',true)
									TriggerEvent("Progress",10000)
									SetTimeout(8000,function()
										process = false
										TriggerEvent('cancelando',false)
									end)
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

--[ TEXT | FUNCTION ]-----------------------------------------------------------------------------------------------------------

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