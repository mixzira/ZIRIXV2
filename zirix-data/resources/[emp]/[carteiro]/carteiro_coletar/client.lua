local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
func = Tunnel.getInterface("carteiro_coletar")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local processo = false
local CoordenadaX = 78.93
local CoordenadaY = 112.45
local CoordenadaZ = 81.16
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
-- PROCESSO
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		if not processo then
			local ped = PlayerPedId()
			if not IsPedInAnyVehicle(ped) then
				local x,y,z = table.unpack(GetEntityCoords(ped))
				if Vdist(CoordenadaX,CoordenadaY,CoordenadaZ,x,y,z) <= 1.2 then
					drawTxt("PRESSIONE  ~b~E~w~  PARA EMPACOTAR ENCOMENDA",4,0.5,0.93,0.50,255,255,255,180)
					if IsControlJustPressed(1,38) then
						CalculateTimeToDisplay()
						if parseInt(hora) >= 06 and parseInt(hora) <= 20 then
							if func.checkPayment() then
								processo = true
								TriggerEvent('cancelando',true)
								TriggerEvent("Progress",10000)
								SetTimeout(8000,function()
									processo = false
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