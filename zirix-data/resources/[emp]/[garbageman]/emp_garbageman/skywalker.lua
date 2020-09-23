local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

--[ CONNECTION ]----------------------------------------------------------------------------------------------------------------

emp = {}
Tunnel.bindInterface("emp_garbageman",emp)

--[ FUNCTION ]------------------------------------------------------------------------------------------------------------------

function emp.checkPayment()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("saco-lixo") <= vRP.getInventoryMaxWeight(user_id) then
			vRP.giveInventoryItem(user_id,"saco-lixo",1)
			return true
		end
	end
end

--[ DELIVERY ORDER | FUNCTION ]-------------------------------------------------------------------------------------------------

function emp.checkCrimeRecord()
	local source = source
	local user_id = vRP.getUserId(source)

	if vRP.checkCrimeRecord(user_id) < 1 then
		return true
	else
		TriggerClientEvent("Notify",source,"importante","Não contratamos pessoas com <b>Ficha Criminal</b>.",10000)
		return false	
	end
end

--[ CHECK PLATE | FUNCTION ]----------------------------------------------------------------------------------------------------

function emp.checkPlate(modelo)
	local source = source
	local user_id = vRP.getUserId(source)
	local veh,vhash,vplaca,vname = vRPclient.vehListHash(source,4)
	if veh and vhash == modelo then
		local placa_user_id = vRP.getUserByRegistration(vplaca)
		if user_id == placa_user_id then
			return true
		end
	end
end