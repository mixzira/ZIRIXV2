local menuactive = false
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

--[ BUTTON ]-----------------------------------------------------------------------------------------------------------------------------

RegisterNUICallback("ButtonClick",function(data,cb)
	if data == "comprar-pibwassen" then
		TriggerServerEvent("bar-comprar","pibwassen")

	elseif data == "comprar-tequilya" then
		TriggerServerEvent("bar-comprar","tequilya")

	elseif data == "comprar-patriot" then
		TriggerServerEvent("bar-comprar","patriot")

	elseif data == "comprar-blarneys" then
		TriggerServerEvent("bar-comprar","blarneys")

	elseif data == "comprar-jakeys" then
		TriggerServerEvent("bar-comprar","jakeys")

	elseif data == "comprar-barracho" then
		TriggerServerEvent("bar-comprar","barracho")

	elseif data == "comprar-ragga" then
		TriggerServerEvent("bar-comprar","ragga")

	elseif data == "comprar-nogo" then
		TriggerServerEvent("bar-comprar","nogo")

	elseif data == "comprar-mount" then
		TriggerServerEvent("bar-comprar","mount")

	elseif data == "comprar-cherenkov" then
		TriggerServerEvent("bar-comprar","cherenkov")

	elseif data == "comprar-bourgeoix" then
		TriggerServerEvent("bar-comprar","bourgeoix")

	elseif data == "comprar-bleuterd" then
		TriggerServerEvent("bar-comprar","bleuterd")

	elseif data == "fechar" then
		ToggleActionMenu()
	
	end
end)

--[ LOCAIS ]-----------------------------------------------------------------------------------------------------------------------------

local lojas = {
	{ ['x'] = -560.27, ['y'] = 286.55, ['z'] = 82.18 }, -- Tequi-La-La;
	{ ['x'] = 352.2, ['y'] = 284.71, ['z'] = 91.2 }, -- Galaxy Club;
	{ ['x'] = 359.75, ['y'] = 280.46, ['z'] = 94.2 }, -- Galaxy Club;
	{ ['x'] = 127.4, ['y'] = -1283.89, ['z'] = 29.28 }, -- Vanilla Unicorn;
	{ ['x'] = 740.04, ['y'] = -824.19, ['z'] = 22.67 } -- Arcade Bar;
}

--[ MENU ]-------------------------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
	SetNuiFocus(false,false)
	while true do
		local idle = 1000

		for k,v in pairs(lojas) do
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(v.x,v.y,v.z)
			local distance = GetDistanceBetweenCoords(v.x,v.y,cdz,x,y,z,true)
			local lojas = lojas[k]
			
			if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), lojas.x, lojas.y, lojas.z, true ) <= 1.5 and not menuactive then
				DrawText3D(lojas.x, lojas.y, lojas.z, "Pressione [~p~E~w~] para acessar o ~p~MENU DO BAR~w~.")
			end

			if distance < 5.1 then
				DrawMarker(23, lojas.x, lojas.y, lojas.z-0.99, 0, 0, 0, 0, 0, 0, 0.7, 0.7, 0.5, 136, 96, 240, 180, 0, 0, 0, 0)
				idle = 5
				if distance <= 1.2 then
					if IsControlJustPressed(0,38) then
						ToggleActionMenu()
					end
				end
			end
		end
		Citizen.Wait(idle)
	end
end)

--[ FUNÇÃO ]-----------------------------------------------------------------------------------------------------------------------------

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