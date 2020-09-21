local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

--[ CONNECTION ]----------------------------------------------------------------------------------------------------------------

emp = {}
Tunnel.bindInterface("emp_farmer",emp)
vCLIENT = Tunnel.getInterface("emp_farmer")

--[ VARIABLES ]-----------------------------------------------------------------------------------------------------------------

local locates = {}
local ammount = {}

--[ RANDOM AMMOUNT | FUNCTION ]-------------------------------------------------------------------------------------------------

function emp.ammount()
	local source = source
	if ammount[source] == nil then
		ammount[source] = math.random(2,6)
	end
end

--[ PLANTING AND COLLECT | FUNCTION ]-------------------------------------------------------------------------------------------

function emp.startPlanting(id,receive)
	local source = source
	local user_id = vRP.getUserId(source)

	if user_id then
		if not locates[id] then		
			if receive == "blueberry" then				
				if vRP.tryGetInventoryItem(user_id,"semente-blueberry",1) then
					locates[id] = 0
					TriggerClientEvent("cancelando",source,true)
					TriggerClientEvent("progress",source,9000,"plantando")
					vRPclient._playAnim(source,true,{{"amb@world_human_gardener_plant@female@idle_a","idle_a_female"}},false)
					Citizen.Wait(9000)
					vRPclient._stopAnim(source,false)
					TriggerClientEvent("cancelando",source,false)
				else
					TriggerClientEvent("Notify",source,"negado","Você precisa de: <b>Semente de Blueberry</b>.")
				end
			elseif receive == "marijuana" then
				if vRP.tryGetInventoryItem(user_id,"semente-marijuana",1) then
					locates[id] = 0
					TriggerClientEvent("cancelando",source,true)
					TriggerClientEvent("progress",source,9000,"plantando")
					vRPclient._playAnim(source,true,{{"amb@world_human_gardener_plant@female@idle_a","idle_a_female"}},false)
					Citizen.Wait(9000)
					vRPclient._stopAnim(source,false)
					TriggerClientEvent("cancelando",source,false)
				else
					TriggerClientEvent("Notify",source,"negado","Você precisa de: <b>Semente de Marijuana</b>.")
				end
			end
		else
			if locates[id] >= 100 then
				emp.ammount()
				if receive == "blueberry" then
					if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("blueberry")*parseInt(ammount[source]) <= vRP.getInventoryMaxWeight(user_id) then
						locates[id] = nil
						TriggerClientEvent("cancelando",source,true)
						TriggerClientEvent("progress",source,10000,"colhendo")
						vRPclient._playAnim(source,true,{{"amb@world_human_gardener_plant@female@idle_a","idle_a_female"}},false)
						Citizen.Wait(10000)
						vRPclient._stopAnim(source,false)
						vCLIENT.returnPlanting(-1,locates)
						TriggerClientEvent("cancelando",source,false)
						vRP.giveInventoryItem(user_id,"blueberry",parseInt(ammount[source]))
						ammount[source] = nil
					end
				elseif receive == "marijuana" then
					if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("marijuana")*parseInt(ammount[source]) <= vRP.getInventoryMaxWeight(user_id) then
						locates[id] = nil
						TriggerClientEvent("cancelando",source,true)
						TriggerClientEvent("progress",source,10000,"colhendo")
						vRPclient._playAnim(source,true,{{"amb@world_human_gardener_plant@female@idle_a","idle_a_female"}},false)
						Citizen.Wait(10000)
						vRPclient._stopAnim(source,false)
						vCLIENT.returnPlanting(-1,locates)
						TriggerClientEvent("cancelando",source,false)
						vRP.giveInventoryItem(user_id,"marijuana",parseInt(ammount[source]))
						ammount[source] = nil
					end
				end
			end
		end
	end
end

--[ TIME | THREAD ]-------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
	while true do
		for k,v in pairs(locates) do
			if v ~= nil and v < 100 then
				locates[k] = v + 1
				vCLIENT.returnPlanting(-1,locates)
				Citizen.Wait(10)
			end
		end
		Citizen.Wait(1000)
	end
end)