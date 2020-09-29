local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

--[ CONNECTION ]----------------------------------------------------------------------------------------------------------------

nav = Tunnel.getInterface("nav_teste")

--[ VARIABLES ]-----------------------------------------------------------------------------------------------------------------

local menuactive = false
local locs = {
    { ['x'] = 161.31, ['y'] = -1002.0, ['z'] = 29.36, ['type'] = "GunsOne" },
    { ['x'] = 168.28, ['y'] = -1001.63, ['z'] = 29.35, ['type'] = "GunsTwo" }
}

--[ MANU | FUNCTION ]-----------------------------------------------------------------------------------------------------------

function ToggleActionMenu(type)
	menuactive = not menuactive
	if menuactive then
		local id = type
		SetNuiFocus(true,true)
		TransitionToBlurred(1000)
		if id == "GunsOne" then
			SendNUIMessage({ showmenu = true, type = "GunsOne" })
		elseif id == "GunsTwo" then
			SendNUIMessage({ showmenu = true, type = "GunsTwo" })
		end
	else
		SetNuiFocus(false)
		TransitionFromBlurred(1000)
		SendNUIMessage({ hidemenu = true })
	end
end


RegisterCommand("corno",function(source,args)
	ToggleActionMenu()
end)

--[ BUTTOM | FUNCTION ]---------------------------------------------------------------------------------------------------------

RegisterNUICallback("ButtonClick",function(data,name,cb)
	print(name)
	if data ~= "fechar" then
		TriggerServerEvent("manufacturing",data)
	else
		ToggleActionMenu()
	end
end)

RegisterNUICallback("requestChest",function(data,cb)
	local itens, itensTwo = nav.openNav()

	if itens or itensTwo then
		cb({ itens = itens, itensTwo = itensTwo })
	end
end)

--[ LOCAL ACTION | THREAD ]-----------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
	while true do
		local idle = 1000

		for k,v in pairs(locs) do
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(v.x,v.y,v.z)
			local distance = GetDistanceBetweenCoords(v.x,v.y,cdz,x,y,z,true)
			local locs = locs[k]

			if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), locs.x, locs.y, locs.z, true ) < 1.2 and not menuactive then
				if locs.type == "GunsOne" then
					DrawText3D(locs.x, locs.y, locs.z, "Pressione [~r~E~w~] para acessar a ~r~GUNS ONE~w~.")
				elseif	locs.type == "GunsTwo" then
					DrawText3D(locs.x, locs.y, locs.z, "Pressione [~r~E~w~] para acessar a ~r~GUNS TWO~w~.")
				end
            end
            
			if distance < 5.1 then
				DrawMarker(23, locs.x, locs.y, locs.z-0.97,0,0,0,0,0,0,0.7,0.7,0.5,214,29,0,100,0,0,0,0)
				idle = 5
				if distance < 1.2 then
					if IsControlJustPressed(0,38) then
						if locs.type == "GunsOne" then
							ToggleActionMenu("GunsOne")
						elseif locs.type == "GunsTwo" then
							ToggleActionMenu("GunsTwo")
						end
					end
				end
			end
		end
		Citizen.Wait(idle)
	end
end)

--[ TEXT | FUNCTION ]-----------------------------------------------------------------------------------------------------------

function DrawText3D(x, y, z, text)
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