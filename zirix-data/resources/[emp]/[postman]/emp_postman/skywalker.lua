local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

--[ CONNECTION ]----------------------------------------------------------------------------------------------------------------

emp = {}
Tunnel.bindInterface("emp_postman",emp)

--[ COLLECT | FUNCTION ]--------------------------------------------------------------------------------------------------------

function emp.checkWeight()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("encomenda")*3 <= vRP.getInventoryMaxWeight(user_id) and vRP.tryGetInventoryItem(user_id,"caixa-vazia",3) and TriggerClientEvent("itensNotify",source,"usar","Usou","caixa-vazia") then
			return true
		else
			TriggerClientEvent("Notify",source,"negado","<b>Mochila</b> cheia ou <b>itens insuficientes</b> para o trabalho.",10000)
			return false
		end
	end
end

function emp.checkCrimeRecord()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.checkCrimeRecord(user_id) > 0 then
			TriggerClientEvent("Notify",source,"negado","Não contratamos pessoas com <b>Ficha Criminal</b>.",10000)
			return false
		else
			return true
		end
	end
end

function emp.giveOrders()
	local source = source
	local user_id = vRP.getUserId(source)

	vRP.giveInventoryItem(user_id,"encomenda",3)
	TriggerClientEvent("itensNotify",source,"sucesso","Empacotou","encomenda",3,vRP.format(vRP.getItemWeight("encomenda")*parseInt(3)))
end

