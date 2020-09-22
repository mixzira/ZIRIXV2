local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

vRPNserver = Tunnel.getInterface("vrp_doors")

local doors = {}
local hora = 0

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
		if GetDistanceBetweenCoords(x,y,z,v.x,v.y,v.z,true) < 1.5 then
			return k
		end
	end
	return 0
end

function searchIdDoor1()
	local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
	for k,v in pairs(doors) do
		if GetDistanceBetweenCoords(x,y,z,v.x,v.y,v.z,true) < 5.0 then
			return true
		end
	end
	return 0
end

function CalculateTimeToDisplay()
	hora = GetClockHours()
	if hora <= 9 then
		hora = "0" .. hora
	end
end

Citizen.CreateThread(function()
	while true do
		local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
		local idle = 1000
		
		local id = searchIdDoor()
		if id ~= 0 then
			CalculateTimeToDisplay()
			if parseInt(hora) >= 07 and parseInt(hora) <= 17 then
				for k,v in pairs(doors) do
					if v.public then
						TriggerServerEvent("vrpdoorsystem:timeOpen",id)
					else
						if IsControlJustPressed(0,38) then
							vRP._playAnim(true,{{"veh@mower@base","start_engine"}},false)
							Citizen.Wait(2200)
							TriggerServerEvent("vrpdoorsystem:open",id)
						end
					end
				end
			else
				TriggerServerEvent("vrpdoorsystem:timeLock",id)
			end
		end

		for k,v in pairs(doors) do
			if id ~= 0 then
				if v.public then
					if v.lock == true then
						if IsControlJustPressed(0,38) and vRPNserver.checkTime(id) then
							vRP._playAnim(true,{{"veh@mower@base","start_engine"}},false)
							Citizen.Wait(2200)
							TriggerServerEvent("vrpdoorsystem:timeForceOpen",id)
						end
					end
				end
			end

			if GetDistanceBetweenCoords(x,y,z,v.x,v.y,v.z,true) < 5.1 then
				idle = 100
				if GetDistanceBetweenCoords(x,y,z,v.x,v.y,v.z,true) < 1.9 then
					idle = 5
					local door = GetClosestObjectOfType(v.x,v.y,v.z,1.0,v.hash,false,false,false)
					if door ~= 0 then
						SetEntityCanBeDamaged(door,false)
						if v.lock == false then
							if v.text then
								if not v.public then
									DrawText3Ds(v.x,v.y,v.z+0.2,"[~p~E~w~] Porta ~p~destrancada~w~.")
								end
							end
							NetworkRequestControlOfEntity(door)
							FreezeEntityPosition(door,false)
						else
							local lock,heading = GetStateOfClosestDoorOfType(v.hash,v.x,v.y,v.z,lock,heading)
							if heading > -0.02 and heading < 0.02 then
								if v.text then
									if v.public then
										DrawText3Ds(v.x,v.y,v.z+0.2,"Horário de funcionamento: ~p~07~w~:~p~00 ~w~às ~p~17~w~:~p~00~w~.")
									else
										DrawText3Ds(v.x,v.y,v.z+0.2,"[~p~E~w~] Porta ~p~trancada~w~.")
									end
								end
								NetworkRequestControlOfEntity(door)
								FreezeEntityPosition(door,true)
							end
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