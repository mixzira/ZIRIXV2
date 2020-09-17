local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

--[ CONEXÃO ]----------------------------------------------------------------------------------------------------------------------------

emP = {}
Tunnel.bindInterface("leiteiro_entregas",emP)

--[ VARIÁVEIS ]--------------------------------------------------------------------------------------------------------------------------

local quantidade = {}
function emP.Quantidade()
	local source = source
	if quantidade[source] == nil then
	   quantidade[source] = math.random(4,6)
	end
	   TriggerClientEvent("quantidade-leite",source,parseInt(quantidade[source]))
end

function emP.checkPayment()
	emP.Quantidade()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.tryGetInventoryItem(user_id,"garrafa-leite",quantidade[source]) then
			randmoney = (math.random(45,65)*quantidade[source])
	        vRP.giveDinheirama(user_id,parseInt(randmoney))

	        TriggerClientEvent("vrp_sound:source",source,'coins',0.5)
	        TriggerClientEvent("Notify",source,"sucesso","Você recebeu <b>$"..vRP.format(parseInt(randmoney)).." dólares</b>.")
			
			quantidade[source] = nil
			emP.Quantidade()
			return true
		else
			TriggerClientEvent("Notify",source,"negado","Você precisa de <b>"..quantidade[source].."x Garrafas de Leite</b>.")
		end
	end
end