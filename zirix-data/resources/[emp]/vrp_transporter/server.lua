-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONEXÃO
-----------------------------------------------------------------------------------------------------------------------------------------
src = {}
Tunnel.bindInterface("vrp_transporter",src)
-----------------------------------------------------------------------------------------------------------------------------------------
-- STARTPAYMENTS
-----------------------------------------------------------------------------------------------------------------------------------------
function src.startPayments(atmid)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.getToken(user_id) > 0 then
			TriggerClientEvent("Notify",source,"importante","Não estamos contratando pessoas com <b>Ficha Criminal</b>, caso queira trabalhar<br>conosco procure as autoridades e efetue a limpeza da mesma.",10000)
			return false
		end

		local data = vRP.getUserAptitudes(user_id)
		if data then
			if vRP.tryGetInventoryItem(user_id,"malote",1) then
				local price = math.random(1100,1500)
				local payment = price+(price*data.creative.transportador*0.0001)

				vRP.execute("atms/add_cash",{ id = parseInt(atmid), cash = 1000 })

				vRP.giveMoney(user_id,parseInt(payment))
				TriggerClientEvent("vrp_sound:source",source,"coin",0.2)
				TriggerClientEvent("Notify",source,"sucesso","Entrega concluída, recebido <b>$"..vRP.format(parseInt(payment)).." dólares</b>.",8000)

				return true
			else
				TriggerClientEvent("Notify",source,"aviso","Você precisa de <b>1x Malote</b>.",8000)
			end
		end
		return false
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- STARTMALOTES
-----------------------------------------------------------------------------------------------------------------------------------------
function src.startMalotes()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("malote") <= vRP.getInventoryMaxWeight(user_id) then
			vRP.giveInventoryItem(user_id,"malote",1)
			return true
		end
	end
end