-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONEXÃO
-----------------------------------------------------------------------------------------------------------------------------------------
cRP = {}
Tunnel.bindInterface("vrp_farmer",cRP)
vCLIENT = Tunnel.getInterface("vrp_farmer")
vRPclient = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIÁVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local locates = {}
local blueberry = {}
local maconha = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- STARTPLANTING
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.startPlanting(id,receive)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if not locates[id] then
			if vRP.tryGetInventoryItem(user_id,"semente",1) then
				locates[id] = 0
				TriggerClientEvent("cancelando",source,true)
				TriggerClientEvent("Progress",source,9000)
				vRPclient._playAnim(source,false,{"amb@world_human_gardener_plant@female@idle_a","idle_a_female"},true)
				Citizen.Wait(9000)
				vRPclient._stopAnim(source,false)
				TriggerClientEvent("cancelando",source,false)
			end
		else
			if locates[id] >= 100 then
				if receive == "blueberry" then

					if vRP.getToken(user_id) > 0 then
						TriggerClientEvent("Notify",source,"importante","Não estamos contratando pessoas com <b>Ficha Criminal</b>, caso queira trabalhar<br>conosco procure as autoridades e efetue a limpeza da mesma.",10000)
						return false
					end

					if blueberry[source] == nil then
						blueberry[source] = math.random(10,20)
					end

					if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("blueberry")*parseInt(blueberry[source]) <= vRP.getInventoryMaxWeight(user_id) then
						locates[id] = nil
						TriggerClientEvent("cancelando",source,true)
						TriggerClientEvent("Progress",source,10000)
						vRPclient._playAnim(source,false,{"amb@world_human_gardener_plant@female@base","base_female"},true)
						Citizen.Wait(10000)
						vRPclient._stopAnim(source,false)
						vCLIENT.returnPlanting(-1,locates)
						TriggerClientEvent("cancelando",source,false)
						vRP.giveInventoryItem(user_id,"blueberry",parseInt(blueberry[source]))
						blueberry[source] = nil
					end

				elseif receive == "maconha" then

					if maconha[source] == nil then
						local data = vRP.getUserAptitudes(user_id)
						if data then
							if parseInt(data.creative.traficante) >= 10000 then
								maconha[source] = math.random(3,7)
							else
								maconha[source] = math.random(2,6)
							end
						end
					end

					if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("maconha")*parseInt(maconha[source]) <= vRP.getInventoryMaxWeight(user_id) then
						locates[id] = nil
						TriggerClientEvent("cancelando",source,true)
						TriggerClientEvent("Progress",source,10000)
						vRPclient._playAnim(source,false,{"amb@world_human_gardener_plant@female@base","base_female"},true)
						Citizen.Wait(10000)
						vRPclient._stopAnim(source,false)
						vCLIENT.returnPlanting(-1,locates)
						TriggerClientEvent("cancelando",source,false)
						vRP.giveInventoryItem(user_id,"maconha",parseInt(maconha[source]))
						maconha[source] = nil
					end

				end
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADTIMERS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		for k,v in pairs(locates) do
			if v ~= nil and v < 100 then
				locates[k] = v + 1
				vCLIENT.returnPlanting(-1,locates)
				Citizen.Wait(10)
			end
		end
		Citizen.Wait(5000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKPAYMENT
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.checkPayment(receive)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if receive == "blueberry" then
			if vRP.getToken(user_id) > 0 then
				TriggerClientEvent("Notify",source,"importante","Não estamos contratando pessoas com <b>Ficha Criminal</b>, caso queira trabalhar<br>conosco procure as autoridades e efetue a limpeza da mesma.",10000)
				return false
			end

			if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("energetico2") <= vRP.getInventoryMaxWeight(user_id) then
				if vRP.tryGetInventoryItem(user_id,"blueberry",3) and vRP.tryGetInventoryItem(user_id,"garrafavazia",1) then
					vRP.giveInventoryItem(user_id,"energetico2",1)
					return true
				end
			end
		elseif receive == "maconha" then
			if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("baseado") <= vRP.getInventoryMaxWeight(user_id) then
				if vRP.tryGetInventoryItem(user_id,"maconha",1) then
					vRP.giveInventoryItem(user_id,"baseado",1)
					return true
				end
			end
		end
		return false
	end
end