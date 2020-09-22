local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

--[ CONNECTION ]----------------------------------------------------------------------------------------------------------------

emp = Tunnel.getInterface("emp_farmer-store")

--[ VARIABLES ]-----------------------------------------------------------------------------------------------------------------

local menuactive = false
local market = {
	{ ['x'] = 1149.19, ['y'] = -297.31, ['z'] = 69.1 }
}

--[ MENU | FUNCTION ]-----------------------------------------------------------------------------------------------------------

function ToggleActionMenu()
	menuactive = not menuactive
	if menuactive then
		SetNuiFocus(true,true)
		TransitionToBlurred(1000)
		SendNUIMessage({ showmenu = true })
	else
		SetNuiFocus(false)
		TransitionFromBlurred(1000)
		SendNUIMessage({ hidemenu = true })
	end
end

--[ BUTTON ]--------------------------------------------------------------------------------------------------------------------

RegisterNUICallback("ButtonClick",function(data,cb)
	if data == "buy-semente-blueberry" then
		TriggerServerEvent("farmer-buy","semente-blueberry")

	elseif data == "buy-semente-laranja" then
		TriggerServerEvent("farmer-buy","semente-laranja")

	elseif data == "buy-semente-tomate" then
		TriggerServerEvent("farmer-buy","semente-tomate")

	elseif data == "sell-blueberry" then
		TriggerServerEvent("farmer-sell","blueberry")
		
	elseif data == "sell-laranja" then
		TriggerServerEvent("farmer-sell","laranja")
		
	elseif data == "sell-tomate" then
		TriggerServerEvent("farmer-sell","tomate")

	elseif data == "fechar" then
		ToggleActionMenu()
	
	end
end)

--[ OPEN MARKET MENU | THREAD ]-------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
	SetNuiFocus(false,false)
	while true do
		local idle = 1000
		for k,v in pairs(market) do
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(v.x,v.y,v.z)
			local distance = GetDistanceBetweenCoords(v.x,v.y,cdz,x,y,z,true)
			local market = market[k]
			
			if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), market.x, market.y, market.z, true ) <= 1.5 and not menuactive then
				DrawText3D(market.x, market.y, market.z, "Pressione [~p~E~w~] para acessar o ~p~COMÉRCIO~w~.")
			end

			if distance < 5.1 then
				DrawMarker(23, market.x, market.y, market.z-0.97, 0, 0, 0, 0, 0, 0, 0.7, 0.7, 0.5, 136, 96, 240, 180, 0, 0, 0, 0)
				idle = 5
				if distance <= 1.2 then
					if IsControlJustPressed(0,38) and emp.checkCrimeRecord() then
						ToggleActionMenu()
					end
				end
			end
		end
		Citizen.Wait(idle)
	end
end)

--[ TEXT | FUNCTION ]--------------------------------------------------------------------------------------------------------------------

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