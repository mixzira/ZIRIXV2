local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
emP = Tunnel.getInterface("leiteiro_coletar")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local processo = false
local segundos = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- CORDENADAS DAS VACAS
-----------------------------------------------------------------------------------------------------------------------------------------
local vacas = {
	{ 426.10,6463.47,28.77 },
	{ 431.42,6459.22,28.75 },
	{ 436.70,6454.85,28.74 },
	{ 428.42,6477.27,28.78 }
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
-- PROCESSO
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		if not processo then
			local ped = PlayerPedId()
			if not IsPedInAnyVehicle(ped) then
				local x,y,z = table.unpack(GetEntityCoords(ped))
				for _,func in pairs(vacas) do
					local x2,y2,z2 = table.unpack(func)
					local distancia = Vdist(x,y,z,x2,y2,z2)
					if distancia <= 1.2 then
						drawTxt("PRESSIONE  ~b~E~w~  PARA ORDENHAR A VACA",4,0.5,0.93,0.50,255,255,255,180)
						if IsControlJustPressed(1,38) then
							CalculateTimeToDisplay()
							if parseInt(hora) >= 06 and parseInt(hora) <= 20 then
								if emP.checkPayment() then
									TriggerEvent('cancelando',true)
									processo = true
									segundos = 10
								end
							else
								TriggerEvent("Notify","importante","Funcionamento é das <b>06:00</b> as <b>20:00</b>.",8000)
							end
						end
					end
				end
			end
		end
		if processo then
			drawTxt("AGUARDE ~b~"..segundos.."~w~ SEGUNDOS ATÉ FINALIZAR A EXTRAÇÃO DO LEITE",4,0.5,0.93,0.50,255,255,255,180)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if segundos > 0 and processo then
			segundos = segundos - 1
			if segundos == 0 then
				processo = false
				TriggerEvent('cancelando',false)
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