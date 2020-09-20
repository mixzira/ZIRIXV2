local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

--[ CONNECTION ]----------------------------------------------------------------------------------------------------------------

emp = {}
Tunnel.bindInterface("emp_carteiro-entregar",emp)

--[ VARIABLES ]-----------------------------------------------------------------------------------------------------------------

local ammount = {}

--[ DELIVERY ORDER | FUNCTION ]-------------------------------------------------------------------------------------------------

function emp.startPayments()
	local source = source
	local user_id = vRP.getUserId(source)
	if ammount[source] == nil then
		ammount[source] = math.random(3,6)
	end
	if user_id then
		if vRP.tryGetInventoryItem(user_id,"encomenda",ammount[source]) then
			local price = math.random(100,140)
			vRP.giveMoney(user_id,parseInt(price))
			TriggerClientEvent("vrp_sound:source",source,'coin',0.2)
			TriggerClientEvent("Notify",source,"sucesso","Você entregou <b>x"..ammount[source].." encomendas</b>, recebendo <b>$"..vRP.format(parseInt(price)).." dólares</b>.",8000)
			ammount[source] = nil
			return true
		else
			TriggerClientEvent("Notify",source,"aviso","Você precisa de <b>"..ammount[source].."x Encomendas</b>.",8000)
		end
	end
end

--[ DELIVERY ORDER | FUNCTION ]-------------------------------------------------------------------------------------------------

function emp.checkCrimeRecord()
	local source = source
	local user_id = vRP.getUserId(source)

	if vRP.checkCrimeRecord(user_id) > 0 then
		TriggerClientEvent("Notify",source,"negado","Não contratamos pessoas com <b>Ficha Criminal</b>.",10000)
		return false
	else
		return true
	end
end