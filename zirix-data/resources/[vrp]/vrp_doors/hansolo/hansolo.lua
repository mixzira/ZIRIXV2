local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

local doors = {}

RegisterNetEvent('vrpdoorsystem:load')
AddEventHandler('vrpdoorsystem:load',function(list)
	doors = list
end)

RegisterNetEvent('vrpdoorsystem:statusSend')
AddEventHandler('vrpdoorsystem:statusSend',function(i,status)
	if i ~= nil and status ~= nil then
		doors[i].lock = status
	end
end)

function searchIdDoor()
	local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
	for k,v in pairs(doors) do
		if GetDistanceBetweenCoords(x,y,z,v.x,v.y,v.z,true) <= 1.5 then
			return k
		end
	end
	return 0
end

function searchIdDoor1()
	local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
	for k,v in pairs(doors) do
		if GetDistanceBetweenCoords(x,y,z,v.x,v.y,v.z,true) <= 1.0 then
			return true
		end
	end
	return 0
end

Citizen.CreateThread(function()
	while true do
		local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
		local idle = 1000

		if searchIdDoor1() then
			idle = 5
		end
		
		if IsControlJustPressed(0,38) then
			local id = searchIdDoor()
			if id ~= 0 then
				vRP._playAnim(true,{{"veh@mower@base","start_engine"}},false)
				Citizen.Wait(2200)
				TriggerServerEvent("vrpdoorsystem:open",id)
			end
		end

		for k,v in pairs(doors) do
			if GetDistanceBetweenCoords(x,y,z,v.x,v.y,v.z,true) <= 1 then
				local door = GetClosestObjectOfType(v.x,v.y,v.z,1.0,v.hash,false,false,false)
				if door ~= 0 then
					SetEntityCanBeDamaged(door,false)
					if v.lock == false then
						if v.text then
							DrawText3Ds(v.x,v.y,v.z+0.2,"[~y~E~w~] Porta ~y~destrancada~w~.")
						end
						NetworkRequestControlOfEntity(door)
						FreezeEntityPosition(door,false)
					else
						local lock,heading = GetStateOfClosestDoorOfType(v.hash,v.x,v.y,v.z,lock,heading)
						if heading > -0.02 and heading < 0.02 then
							if v.text then
								DrawText3Ds(v.x,v.y,v.z+0.2,"[~y~E~w~] Porta ~y~trancada~w~.")
							end
							NetworkRequestControlOfEntity(door)
							FreezeEntityPosition(door,true)
						end
					end
				end
			end
		end

		Citizen.Wait(idle)
	end
end)

function DrawText3Ds(x,y,z,text)
	local onScreen,_x,_y = World3dToScreen2d(x,y,z)
	SetTextFont(4)
	SetTextScale(0.25,0.25)
	SetTextColour(255,255,255,150)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)

	DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0115, 0.001+factor, 0.03, 0, 0, 0,80)
end