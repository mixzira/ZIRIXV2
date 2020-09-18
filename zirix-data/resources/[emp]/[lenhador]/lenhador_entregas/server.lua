local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
emP = {}
Tunnel.bindInterface("lenhador_entregas",emP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local quantidade = {}
function emP.Quantidade()
	local source = source
	if quantidade[source] == nil then
		quantidade[source] = math.random(3,6)
	end
end

function emP.checkPayment()
	emP.Quantidade()
	local source = source
	local user_id = vRP.getUserId(source)
	local data = vRP.getUserAptitudes(user_id)
	if user_id then
		if vRP.getToken(user_id) > 0 then
			TriggerClientEvent("Notify",source,"importante","Não estamos contratando pessoas com <b>Ficha Criminal</b>, caso queira trabalhar<br>conosco procure as autoridades e efetue a limpeza da mesma.",10000)
			return false
		end

		if vRP.tryGetInventoryItem(user_id,"tora",quantidade[source]) then
			local valor = math.random(170,250)
			local result = valor+(valor*data.creative.lenhador*0.0001)
			vRP.giveMoney(user_id,parseInt(result*quantidade[source]))
			TriggerClientEvent("vrp_sound:source",source,'coin',0.2)
			TriggerClientEvent("Notify",source,"sucesso","Entrega concluída, recebido <b>$"..vRP.format(parseInt(result*quantidade[source])).." dólares</b>.",8000)
			quantidade[source] = nil

			return true
		else
			TriggerClientEvent("Notify",source,"aviso","Você precisa de <b>"..quantidade[source].."x Toras de Madeira</b>.",8000)
		end
	end
end