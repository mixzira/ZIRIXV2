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
	if data == "ferramentas-comprar-paninho" then
		TriggerServerEvent("ferramentas-comprar","paninho")
	
	elseif data == "ferramentas-comprar-garrafa-vazia" then
		TriggerServerEvent("ferramentas-comprar","garrafa-vazia")
		
	elseif data == "ferramentas-comprar-caixa-vazia" then
		TriggerServerEvent("ferramentas-comprar","caixa-vazia")

	elseif data == "ferramentas-comprar-ponta-britadeira" then
		TriggerServerEvent("ferramentas-comprar","ponta-britadeira")

	elseif data == "ferramentas-comprar-semente-blueberry" then
		TriggerServerEvent("ferramentas-comprar","semente-blueberry")

	elseif data == "ferramentas-comprar-semente-marijuana" then
		TriggerServerEvent("ferramentas-comprar","semente-marijuana")

	elseif data == "ferramentas-comprar-semente-tomate" then
		TriggerServerEvent("ferramentas-comprar","semente-tomate")

	elseif data == "ferramentas-comprar-semente-laranja" then
		TriggerServerEvent("ferramentas-comprar","semente-laranja")

	elseif data == "ferramentas-comprar-repairkit" then
		TriggerServerEvent("ferramentas-comprar","repairkit")

	elseif data == "ferramentas-comprar-serra" then
		TriggerServerEvent("ferramentas-comprar","serra")

	elseif data == "ferramentas-comprar-pa" then
		TriggerServerEvent("ferramentas-comprar","pa")

	elseif data == "ferramentas-comprar-furadeira" then
		TriggerServerEvent("ferramentas-comprar","furadeira")

	elseif data == "ferramentas-comprar-martelo" then
		TriggerServerEvent("ferramentas-comprar","wbody|WEAPON_HAMMER")

	elseif data == "ferramentas-comprar-pecabra" then
		TriggerServerEvent("ferramentas-comprar","wbody|WEAPON_CROWBAR")

	elseif data == "ferramentas-comprar-machado" then
		TriggerServerEvent("ferramentas-comprar","wbody|WEAPON_WEAPON_HATCHET")

	elseif data == "ferramentas-comprar-grifo" then
		TriggerServerEvent("ferramentas-comprar","wbody|WEAPON_WHENCH")
	
	elseif data == "fechar" then
		ToggleActionMenu()
	
	end
end)

--[ LOCAIS ]-----------------------------------------------------------------------------------------------------------------------------

local lojas = {
	{ ['x'] = -39.1, ['y'] = -1661.16, ['z'] = 29.5 },
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
				DrawText3D(lojas.x, lojas.y, lojas.z, "Pressione [~p~E~w~] para acessar a ~p~LOJA DE FERRAMENTAS~w~.")
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