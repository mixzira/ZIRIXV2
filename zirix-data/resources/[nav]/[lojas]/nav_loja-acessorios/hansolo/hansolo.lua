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
	if data == "comprar-mochila" then
		TriggerServerEvent("acessorios-comprar","mochila")
	
	elseif data == "comprar-mascara" then
		TriggerServerEvent("acessorios-comprar","mascara")

	elseif data == "comprar-oculos" then
		TriggerServerEvent("acessorios-comprar","oculos")

	elseif data == "fechar" then
		ToggleActionMenu()
	
	end
end)

--[ LOCAIS ]-----------------------------------------------------------------------------------------------------------------------------

local lojas = {
	{ ['x'] = 425.57, ['y'] = -806.27, ['z'] = 29.5 },
	{ ['x'] = 75.44, ['y'] = -1392.85, ['z'] = 29.38 },
	{ ['x'] = -822.38, ['y'] = -1073.59, ['z'] = 11.33 },
	{ ['x'] = -1193.17, ['y'] = -767.95, ['z'] = 17.32 },
	{ ['x'] = -163.54, ['y'] = -303.28, ['z'] = 39.74 },
	{ ['x'] = 125.72, ['y'] = -223.82, ['z'] = 54.56 },
	{ ['x'] = -710.04, ['y'] = -152.58, ['z'] = 37.42 },
	{ ['x'] = -1450.05, ['y'] = -237.21, ['z'] = 49.82 },
	{ ['x'] = -3170.62, ['y'] = 1043.74, ['z'] = 20.87 },
	{ ['x'] = -1101.29, ['y'] = 2710.63, ['z'] = 19.11 },
	{ ['x'] = 614.2, ['y'] = 2762.82, ['z'] = 42.09 },
	{ ['x'] = 1196.75, ['y'] = 2710.26, ['z'] = 38.23 },
	{ ['x'] = 1693.84, ['y'] = 4822.9, ['z'] = 42.07 },
	{ ['x'] = 4.82, ['y'] = 6512.48, ['z'] = 31.88 },
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
				DrawText3D(lojas.x, lojas.y, lojas.z, "Pressione [~y~E~w~] para acessar a ~y~LOJA DE ACESSÓRIOS~w~.")
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