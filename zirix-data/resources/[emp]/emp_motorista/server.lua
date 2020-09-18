local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
emP = {}
Tunnel.bindInterface("emp_motorista",emP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
function emP.checkPayment(porc,bonus)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.getToken(user_id) > 0 then
			TriggerClientEvent("Notify",source,"importante","Não estamos contratando pessoas com <b>Ficha Criminal</b>, caso queira trabalhar<br>conosco procure as autoridades e efetue a limpeza da mesma.",10000)
			return false
		end

		local data = vRP.getUserAptitudes(user_id)
		if data then
			local valor = math.random(20,30)
			local result = valor+(valor*data.creative.motorista*0.0001)
			vRP.giveMoney(user_id,parseInt((result*porc)+bonus))
			TriggerClientEvent("vrp_sound:source",source,'coin',0.2)
			TriggerClientEvent("Notify",source,"sucesso","Entrega concluída, recebido <b>$"..vRP.format(parseInt((result*porc)+bonus)).." dólares</b>.",8000)

			if vRP.tryGetInventoryItem(user_id,"rebite",1) then
				vRP.giveInventoryItem(user_id,"dinheirosujo",math.random(300,400))
			end
		end
	end
end