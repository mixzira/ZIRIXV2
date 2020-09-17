local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

--[ CONEXÕES ]---------------------------------------------------------------------------------------------------------------------------

emP = Tunnel.getInterface("leiteiro_coletar")

--[ VARIÁVEIS ]--------------------------------------------------------------------------------------------------------------------------

local processo = false
local segundos = 0

--[ CORDENADAS DAS VACAS ]---------------------------------------------------------------------------------------------------------------

local vacas = {
	{ 2432.78,4802.78,34.82 },
	{ 2440.98,4794.38,34.66 },
	{ 2449.0,4786.67,34.65 },
	{ 2457.28,4778.75,34.52 },
	{ 2464.67,4770.23,34.38 }
}

--[ PROCESSO ]---------------------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
	while true do
		local idle = 1000
		if not processo then
			idle = 5
			for _,func in pairs(vacas) do
				local ped = PlayerPedId()
				local x,y,z = table.unpack(func)
				local distancia = GetDistanceBetweenCoords(GetEntityCoords(ped),x,y,z)
				if distancia < 30.1 then
					if distancia < 1.2 then
						drawTxt("PRESSIONE  ~y~E~w~  PARA ORDENHAR A VACA",4,0.5,0.92,0.35,255,255,255,180)
						if IsControlJustPressed(0,38) and emP.checkPayment() then
							TriggerEvent('cancelando',true)
							vRP._playAnim(false,{{"amb@medic@standing@tendtodead@base","base"}},true)						
							processo = true
							segundos = 8
							SetTimeout(8000,function()
								vRP._stopAnim(false)
								emP.checkAddItem()
							end)
						end
						
					end
				end
			end
		end
		if processo then
			drawTxt("AGUARDE ~y~"..segundos.."~w~ SEGUNDOS ATÉ FINALIZAR A EXTRAÇÃO DO LEITE",4,0.5,0.92,0.35,255,255,255,180)
		end
		Citizen.Wait(idle)
	end
end)

--[ SEGUNDOS ]---------------------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if processo then
			if segundos > 0 then
				segundos = segundos - 1
				if segundos == 0 then
					processo = false
					TriggerEvent('cancelando',false)
				end
			end
		end
	end
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