local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
emP = {}
Tunnel.bindInterface("leiteiro_coletar",emP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
function emP.checkPayment()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.getToken(user_id) > 0 then
			TriggerClientEvent("Notify",source,"importante","Não estamos contratando pessoas com <b>Ficha Criminal</b>, caso queira trabalhar<br>conosco procure as autoridades e efetue a limpeza da mesma.",10000)
			return false
		end

		if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("garrafadeleite")*3 <= vRP.getInventoryMaxWeight(user_id) then
			if vRP.tryGetInventoryItem(user_id,"garrafavazia",3) then
				vRP.giveInventoryItem(user_id,"garrafadeleite",3)
				return true
			end
		end
	end
end