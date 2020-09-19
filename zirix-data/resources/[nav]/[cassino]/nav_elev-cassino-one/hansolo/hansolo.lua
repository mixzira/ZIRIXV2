local menuactive = false
function ToggleActionMenu()
	menuactive = not menuactive
	if menuactive then
		SetNuiFocus(true,true)
		SendNUIMessage({ showmenu = true })
	else
		SetNuiFocus(false)
		SendNUIMessage({ hidemenu = true })
	end
end

--[ BUTTON ]-----------------------------------------------------------------------------------------------------------------------------

RegisterNUICallback("ButtonClick",function(data,cb)
	local ped = GetPlayerPed(-1)
	if data == "terraco-elev-one" then
		DoScreenFadeOut(1000)
		SetNuiFocus(false)
		SendNUIMessage({ hidemenu = true })
		menuactive = false
		SetTimeout(1400,function()
			SetEntityCoords(PlayerPedId(),965.01, 58.43, 112.56)
			SetEntityHeading(ped,68.44)
			TriggerEvent("vrp_sound:source",'elevator-bell',0.5)
			Citizen.Wait(750)
			DoScreenFadeIn(1000)
		end)
	elseif data == "terreo-elev-one" then
		DoScreenFadeOut(1000)
		SetNuiFocus(false)
		SendNUIMessage({ hidemenu = true })
		menuactive = false
		SetTimeout(1400,function()
			SetEntityCoords(PlayerPedId(),945.01, 47.72, 80.3)
			SetEntityHeading(ped,57.9)
			TriggerEvent("vrp_sound:source",'elevator-bell',0.5)
			Citizen.Wait(750)
			DoScreenFadeIn(1000)
		end)
	elseif data == "fechar" then
		ToggleActionMenu()
	end
end)

--[ LOCAIS ]-----------------------------------------------------------------------------------------------------------------------------

local elevadores = {
	{ ['x'] = 965.01, ['y'] = 58.43, ['z'] = 112.56 }, -- Terraço;
	{ ['x'] = 945.01, ['y'] = 47.72, ['z'] = 80.3 } -- Térreo;
}

Citizen.CreateThread(function()
	SetNuiFocus(false,false)
	while true do
		local idle = 1000
		for k,v in pairs(elevadores) do
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(v.x,v.y,v.z)
			local distance = GetDistanceBetweenCoords(v.x,v.y,cdz,x,y,z,true)
			local elev = elevadores[k]
			
			if distance < 5.1 then
				DrawMarker(23, elev.x, elev.y, elev.z-0.99, 0, 0, 0, 0, 0, 0, 0.7, 0.7, 0.5, 136, 96, 240, 180, 0, 0, 0, 0)
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