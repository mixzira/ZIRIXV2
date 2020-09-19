--[ vRP ]----------------------------------------------------------------------------------------------

local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

--[ CONNECTION ]---------------------------------------------------------------------------------------

misc = Tunnel.getInterface("vrp_misc")

--[ VARIABLES ]----------------------------------------------------------------------------------------

local waterCoolers = {
    {'prop_watercooler'}
}

--[ THREADS ]------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
    while true do
        local idle = 1000
        local ped = GetPlayerPed(-1)
        local pedCoords = GetEntityCoords(ped, 0)
        local coolerEmpty = false

        for k,v in pairs(waterCoolers) do
            local cooler = GetClosestObjectOfType(pedCoords["x"], pedCoords["y"], pedCoords["z"], 1.0, GetHashKey(v[1]), true, true, true)
            SetEntityAsMissionEntity(cooler, true, true)
            if DoesEntityExist(cooler) then
                coolerCoords = GetEntityCoords(cooler, 0)
            end
        end

        if coolerCoords ~= nil then
            local distance = GetDistanceBetweenCoords(pedCoords["x"], pedCoords["y"], pedCoords["z"], coolerCoords["x"], coolerCoords["y"], coolerCoords["z"])
            if distance < 1.5 then
                idle = 5   
            end
            if distance > 2 then
                coolerCoords = nil
            end
        end

        if coolerCoords ~= nil then
            if GetDistanceBetweenCoords(pedCoords["x"], pedCoords["y"], pedCoords["z"], coolerCoords["x"], coolerCoords["y"], coolerCoords["z"] < 1) and not IsPedInAnyVehicle(ped) then
                DrawText3D(coolerCoords["x"], coolerCoords["y"], coolerCoords["z"]+1.2, "Pressione [~p~E~w~] para ~p~ENCHER SUA GARRAFA D'ÁGUA~w~.")
                
                if GetDistanceBetweenCoords(pedCoords["x"], pedCoords["y"], pedCoords["z"], coolerCoords["x"], coolerCoords["y"], coolerCoords["z"] < 0.5) then
                    if IsControlPressed(1,38) then
                        if misc.searchCooler(coolerCoords["x"]) then
                            misc.coolerPayment()
                        end
                    end
                end
            end
        end
        Citizen.Wait(idle)
    end 
end)