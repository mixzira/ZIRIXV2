local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
emP = {}
Tunnel.bindInterface("emp_paramedico",emP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
function emP.checkPermission()
	local source = source
	local user_id = vRP.getUserId(source)
	return vRP.hasPermission(user_id,"paramedico.permissao")
end

function emP.checkPayment(payment)
	local source = source
	local user_id = vRP.getUserId(source)
	local data = vRP.getUserAptitudes(user_id)
	if user_id then
		local valor = math.random(60,70)
		local result = valor+(valor*data.creative.paramedico*0.0001)
		vRP.giveMoney(user_id,parseInt(result*payment))
		TriggerClientEvent("vrp_sound:source",source,'coin',0.2)
		TriggerClientEvent("Notify",source,"sucesso","Entrega concluída, recebido <b>$"..vRP.format(parseInt(result*payment)).." dólares</b>.",8000)
	end
end