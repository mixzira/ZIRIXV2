local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

--[ CONNECTION ]----------------------------------------------------------------------------------------------------------------

emp = Tunnel.getInterface("emp_garbageman-dump")

--[ VARIABLES ]-----------------------------------------------------------------------------------------------------------------

local working = false
local seconds = 0
local hour = 0

--[ IN WORKING AREA | THREAD ]--------------------------------------------------------------------------------------------------

function CalculateTimeToDisplay()
	hour = GetClockHours()
	if hour <= 9 then
		hour = "0" .. hour
	end
end

--[ IN WORKING AREA | THREAD ]--------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		if not working then
			local ped = PlayerPedId()
			if not IsPedInAnyVehicle(ped) then
				local x,y,z = table.unpack(GetEntityCoords(ped))
				local distancia = Vdist(x,y,z,-330.57,-1564.40,25.23)
				if distancia <= 2.1 then
					drawTxt("PRESSIONE  ~b~E~w~  PARA DESPEJAR LIXO",4,0.5,0.93,0.50,255,255,255,180)
					if IsControlJustPressed(1,38) then
						CalculateTimeToDisplay()
						if parseInt(hour) >= 06 and parseInt(hour) <= 20 then
							if emp.checkPayment() then
								working = true
								seconds = 3
							end
						else
							TriggerEvent("Notify","importante","Funcionamento é das <b>06:00</b> as <b>20:00</b>.",8000)
						end
					end
				end
			end
		end
		if working then
			drawTxt("AGUARDE ~b~"..seconds.."~w~ seconds ATÉ FINALIZAR O DESPEJO DO LIXO",4,0.5,0.93,0.50,255,255,255,180)
		end
	end
end)

--[ IN WORKING AREA | THREAD ]--------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if seconds > 0 and working then
			seconds = seconds - 1
			if seconds == 0 then
				working = false
				TriggerEvent('cancelando',false)
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