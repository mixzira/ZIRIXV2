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
Tunnel.bindInterface("vrp_milkman",src)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIÁVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local amount = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- STARTPAYMENTS
-----------------------------------------------------------------------------------------------------------------------------------------
function src.startPayments()
	local source = source

	if amount[source] == nil then
		amount[source] = math.random(3,6)
	end

	local user_id = vRP.getUserId(source)
	if user_id then
	
		local data = vRP.getUserAptitudes(user_id)
		if data then
			if vRP.tryGetInventoryItem(user_id,"garrafa-leite",amount[source]) then
				local price = math.random(150,220)
				local payment = price+(price*data.creative.leiteiro*0.0001)

				vRP.giveMoney(user_id,parseInt(payment*amount[source]))
				TriggerClientEvent("vrp_sound:source",source,'coin',0.2)
				TriggerClientEvent("Notify",source,"sucesso","Entrega concluída, recebido <b>$"..vRP.format(parseInt(payment*amount[source])).." dólares</b>.",8000)

				amount[source] = nil

				if vRP.tryGetInventoryItem(user_id,"rebite",1) then
					vRP.giveInventoryItem(user_id,"dinheirosujo",math.random(350,500))
				end
				
				return true
			else
				TriggerClientEvent("Notify",source,"aviso","Você precisa de <b>"..amount[source].."x Garrafas de Leite</b>.",8000)
			end
		end
		return false
	end
end