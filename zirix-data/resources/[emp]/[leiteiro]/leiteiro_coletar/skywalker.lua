local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

--[ CONEXÕES ]---------------------------------------------------------------------------------------------------------------------------

emP = {}
Tunnel.bindInterface("leiteiro_coletar",emP)

--[ FUNÇÕES ]----------------------------------------------------------------------------------------------------------------------------

function emP.checkPayment()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("garrafa-leite")*3 <= vRP.getInventoryMaxWeight(user_id) then
			if vRP.getInventoryItemAmount(user_id,"garrafa-vazia") >= 3 then	
				return true
			else
				TriggerClientEvent("Notify",source,"negado","<b>Garrafas</b> vazias insuficientes.") 
				return false
			end
		else
			TriggerClientEvent("Notify",source,"negado","<b>Mochila</b> cheia.") 
			return false
		end
	end
end

function emP.checkAddItem()
	local source = source
	local user_id = vRP.getUserId(source)
	if vRP.tryGetInventoryItem(user_id,"garrafa-vazia",3) then
		vRP.giveInventoryItem(user_id,"garrafa-leite",3)
		TriggerClientEvent("Notify",source,"sucesso","Você ordenhou <b>3x garrafas de leite</b>.") 
	end
end