
--[ vRP ]--------------------------------------------------------------------------------------------------------------------------------

local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

--[ CONEXÃO ]----------------------------------------------------------------------------------------------------------------------------

Resg = Tunnel.getInterface("vrp_hospital")

--[ VARIÁVEIS ]--------------------------------------------------------------------------------------------------------------------------

local tratamento = false
local segundos = 0
local medicalTratamento = false

--[ REANIMAR ]---------------------------------------------------------------------------------------------------------------------------

RegisterNetEvent('reanimar')
AddEventHandler('reanimar',function()
	local handle,ped = FindFirstPed()
	local finished = false
	local reviver = nil
	repeat
		local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),GetEntityCoords(ped),true)
		if IsPedDeadOrDying(ped) and not IsPedAPlayer(ped) and distance <= 1.5 and reviver == nil then
			reviver = ped
			TriggerEvent("cancelando",true)
			vRP._playAnim(false,{{"amb@medic@standing@tendtodead@base","base"},{"mini@cpr@char_a@cpr_str","cpr_pumpchest"}},true)
			TriggerEvent("progress",15000,"reanimando")
			SetTimeout(15000,function()
				SetEntityHealth(reviver,110)
				local newped = ClonePed(reviver,GetEntityHeading(reviver),true,true)
				TaskWanderStandard(newped,10.0,10)
				local model = GetEntityModel(reviver)
				SetModelAsNoLongerNeeded(model)
				Citizen.InvokeNative(0xAD738C3085FE7E11,reviver,true,true)
				TriggerServerEvent("trydeleteped",PedToNet(reviver))
				vRP._stopAnim(false)
				TriggerEvent("cancelando",false)
			end)
			finished = true
		end
		finished,ped = FindNextPed(handle)
	until not finished
	EndFindPed(handle)
end)

--[ MACAS DO HOSPITAL ]------------------------------------------------------------------------------------------------------------------  ['x'] = 318.39, ['y'] = -580.79, ['z'] = 43.29

local macas = {
	{ ['x'] = 323.35, ['y'] = -582.42, ['z'] = 43.29, ['x2'] = 324.35, ['y2'] = -582.73, ['z2'] = 44.21, ['h'] = 339.96, ['name'] = "Pressione [~p~E~w~] para deitar   ~p~&~w~    [~p~G~w~] para se tratar." }, -- Enfermaria;
	{ ['x'] = 318.39, ['y'] = -580.79, ['z'] = 43.29, ['x2'] = 319.48, ['y2'] = -581.01, ['z2'] = 44.21, ['h'] = 339.96, ['name'] = "Pressione [~p~E~w~] para deitar   ~p~&~w~    [~p~G~w~] para se tratar." },
	{ ['x'] = 314.76, ['y'] = -579.3, ['z'] = 43.29, ['x2'] = 313.97, ['y2'] = -579.01, ['z2'] = 44.21, ['h'] = 339.96, ['name'] = "Pressione [~p~E~w~] para deitar   ~p~&~w~    [~p~G~w~] para se tratar." },
	{ ['x'] = 310.24, ['y'] = -577.68, ['z'] = 43.29, ['x2'] = 309.32, ['y2'] = -577.36, ['z2'] = 44.21, ['h'] = 339.96, ['name'] = "Pressione [~p~E~w~] para deitar   ~p~&~w~    [~p~G~w~] para se tratar." },
	{ ['x'] = 321.79, ['y'] = -586.96, ['z'] = 43.29, ['x2'] = 322.6, ['y2'] = -587.22, ['z2'] = 44.21, ['h'] = 156.98, ['name'] = "Pressione [~p~E~w~] para deitar   ~p~&~w~    [~p~G~w~] para se tratar." },
	{ ['x'] = 318.56, ['y'] = -585.65, ['z'] = 43.29, ['x2'] = 317.79, ['y2'] = -585.37, ['z2'] = 44.21, ['h'] = 156.98, ['name'] = "Pressione [~p~E~w~] para deitar   ~p~&~w~    [~p~G~w~] para se tratar." },
	{ ['x'] = 315.37, ['y'] = -584.49, ['z'] = 43.29, ['x2'] = 314.52, ['y2'] = -584.21, ['z2'] = 44.21, ['h'] = 156.98, ['name'] = "Pressione [~p~E~w~] para deitar   ~p~&~w~    [~p~G~w~] para se tratar." },
	{ ['x'] = 311.96, ['y'] = -583.24, ['z'] = 43.29, ['x2'] = 311.17, ['y2'] = -582.94, ['z2'] = 44.21, ['h'] = 156.98, ['name'] = "Pressione [~p~E~w~] para deitar   ~p~&~w~    [~p~G~w~] para se tratar." },
	{ ['x'] = 308.58, ['y'] = -582.09, ['z'] = 43.29, ['x2'] = 307.76, ['y2'] = -581.79, ['z2'] = 44.21, ['h'] = 156.98, ['name'] = "Pressione [~p~E~w~] para deitar   ~p~&~w~    [~p~G~w~] para se tratar." },

	{ ['x'] = 314.6, ['y'] = -566.17, ['z'] = 43.29, ['x2'] = 315.38, ['y2'] = -566.59, ['z2'] = 44.28, ['h'] = 339.61, ['name'] = "Pressione [~p~E~w~] para deitar." }, -- Sala de Cirurgia;
	{ ['x'] = 320.38, ['y'] = -568.08, ['z'] = 43.29, ['x2'] = 321.24, ['y2'] = -568.47, ['z2'] = 44.15, ['h'] = 339.61, ['name'] = "Pressione [~p~E~w~] para deitar." },-- Sala de Cirurgia;
	{ ['x'] = 326.08, ['y'] = -570.8, ['z'] = 43.29, ['x2'] = 326.83, ['y2'] = -570.83, ['z2'] = 44.26, ['h'] = 339.61, ['name'] = "Pressione [~p~E~w~] para deitar." }, -- Sala de Cirurgia;
	{ ['x'] = 336.33, ['y'] = -575.05, ['z'] = 43.29, ['x2'] = 336.93, ['y2'] = -575.27, ['z2'] = 44.19, ['h'] = 339.61, ['name'] = "Pressione [~p~E~w~] para deitar." }, -- Sala de Tumografia;
	{ ['x'] = 347.99, ['y'] = -579.29, ['z'] = 43.29, ['x2'] = 348.49, ['y2'] = -579.89, ['z2'] = 44.19, ['h'] = 339.61, ['name'] = "Pressione [~p~E~w~] para deitar." }, -- Sala de Raio X;


	{ ['x'] = 361.06, ['y'] = -582.07, ['z'] = 43.29, ['x2'] = 361.42, ['y2'] = -581.23, ['z2'] = 44.2, ['h'] = 249.73, ['name'] = "Pressione [~p~E~w~] para deitar  ~p~&~w~   [~p~G~w~] para se tratar." }, -- Quarto particular 01;
	{ ['x'] = 359.81, ['y'] = -585.34, ['z'] = 43.29, ['x2'] = 359.63, ['y2'] = -586.28, ['z2'] = 44.21, ['h'] = 249.73, ['name'] = "Pressione [~p~E~w~] para deitar  ~p~&~w~   [~p~G~w~] para se tratar." }, -- Quarto particular 02;
	{ ['x'] = 366.27, ['y'] = -582.46, ['z'] = 43.29, ['x2'] = 366.56, ['y2'] = -581.66, ['z2'] = 44.22, ['h'] = 251.97, ['name'] = "Pressione [~p~E~w~] para deitar  ~p~&~w~   [~p~G~w~] para se tratar." }, -- Quarto particular 3 01;
	{ ['x'] = 365.2, ['y'] = -585.03, ['z'] = 43.29, ['x2'] = 364.86, ['y2'] = -585.83, ['z2'] = 44.22, ['h'] = 251.97, ['name'] = "Pressione [~p~E~w~] para deitar  ~p~&~w~   [~p~G~w~] para se tratar." }, -- Quarto particular 3 02;
	{ ['x'] = 364.06, ['y'] = -588.13, ['z'] = 43.29, ['x2'] = 363.75, ['y2'] = -588.95, ['z2'] = 44.22, ['h'] = 251.97, ['name'] = "Pressione [~p~E~w~] para deitar  ~p~&~w~   [~p~G~w~] para se tratar." }, -- Quarto particular 3 03;
	{ ['x'] = 354.2, ['y'] = -600.99, ['z'] = 43.29, ['x2'] = 354.27, ['y2'] = -600.16, ['z2'] = 44.22, ['h'] = 257.55, ['name'] = "Pressione [~p~E~w~] para deitar  ~p~&~w~   [~p~G~w~] para se tratar." } -- Quarto particular 03;
}

--[ USO ]-------------------------------------------------------------------------------------------------------------------------------- 

local emMaca = false
Citizen.CreateThread(function()
	while true do
		local idle = 1000
		
		for k,v in pairs(macas) do
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(v.x,v.y,v.z)
			local distance = GetDistanceBetweenCoords(v.x,v.y,cdz,x,y,z,true)
			local cod = macas[k]

			if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), cod.x, cod.y, cod.z, true ) < 1.2 then
				DrawText3D(cod.x, cod.y, cod.z, cod.name)
			end

			if distance < 1.5 then
				idle = 5
				if IsControlJustPressed(0,38) then
					SetEntityCoords(ped,v.x2,v.y2,v.z2)
					SetEntityHeading(ped,v.h)
					vRP._playAnim(false,{{"amb@world_human_sunbathe@female@back@idle_a","idle_a"}},true)
					emMaca = true
				end
				if IsControlJustPressed(0,47) then
					if Resg.checkServices() then
						TriggerEvent('tratamento')
						SetEntityCoords(ped,v.x2,v.y2,v.z2)
						SetEntityHeading(ped,v.h)
						vRP._playAnim(false,{{"amb@world_human_sunbathe@female@back@idle_a","idle_a"}},true)
					else
						TriggerEvent("Notify","aviso","Existem paramédicos em serviço.")
					end
				end
			end

			if tratamento then
				idle = 5
				drawTxt("RESTAM ~p~"..segundos.." SEGUNDOS ~w~PARA TERMINAR O TRATAMENTO.",4,0.5,0.92,0.35,255,255,255,200)
				DisableControlAction(0,167,true)
				DisableControlAction(0,75,true)
				DisableControlAction(0,245,true)
			end

			if IsControlJustPressed(0,167) then
				ClearPedTasks(GetPlayerPed(-1))
				emMaca = false
			end
		end

		Citizen.Wait(idle)
	end
end)

--[ TRATAMENTO ]-------------------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if tratamento then
			segundos = segundos - 1
			if segundos <= 0 then
				tratamento = false
				ClearPedTasks(PlayerPedId())
				TriggerEvent('cancelando',false)
				TriggerEvent('final-tratamento')
			end
		end
	end
end)

RegisterNetEvent("tratamento")
AddEventHandler("tratamento",function()
    local ped = PlayerPedId()
    local health = GetEntityHealth(ped)
    local armour = GetPedArmour(ped)

    SetEntityHealth(ped,health)
    SetPedArmour(ped,armour)
	
	if tratamento then
		return
	end
	vRP.blockAcao()
	segundos = 300
	tratamento = true
	TriggerEvent("Notify","sucesso","Tratamento iniciado, aguarde a liberação do <b>profissional médico.</b>.",8000)
end)

RegisterNetEvent("final-tratamento")
AddEventHandler("final-tratamento",function()
    local ped = PlayerPedId()
    local health = GetEntityHealth(ped)
    local armour = GetPedArmour(ped)

    SetEntityHealth(ped,health)
    SetPedArmour(ped,armour)
	
	SetEntityHealth(ped,400)
	vRP.desblockAcao()
end)

local medicalTratamento = false

RegisterNetEvent("medical-tratamento")
AddEventHandler("medical-tratamento",function()
    local ped = PlayerPedId()
    local health = GetEntityHealth(ped)
    local armour = GetPedArmour(ped)

    SetEntityHealth(ped,health)
    SetPedArmour(ped,armour)
	
	if emMaca then
		if medicalTratamento then
			return
		end

		medicalTratamento = true
		TriggerEvent("Notify","sucesso","Tratamento iniciado, aguarde a liberação do <b>profissional médico.</b>.",8000)
		TriggerEvent('resetWarfarina')
		TriggerEvent('resetDiagnostic')
		

		if medicalTratamento then
			repeat
				Citizen.Wait(600)
				if GetEntityHealth(ped) > 101 then
					SetEntityHealth(ped,GetEntityHealth(ped)+1)
				end
			until GetEntityHealth(ped) >= 320 or GetEntityHealth(ped) <= 101
				TriggerEvent("Notify","sucesso","Tratamento concluido.",8000)
				medicalTratamento = false
		end
	else
		TriggerEvent("Notify","negado","Você precisa estar deitado em uma maca para ser tratado.",8000)
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