local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
emP = {}
Tunnel.bindInterface("emp_piloto",emP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
function emP.checkPermission()
	local source = source
	local user_id = vRP.getUserId(source)
	return vRP.hasPermission(user_id,"piloto.permissao")
end

function emP.checkPayment()
	local source = source
	local user_id = vRP.getUserId(source)
	local data = vRP.getUserAptitudes(user_id)
	if user_id then
		if vRP.getToken(user_id) > 0 then
			TriggerClientEvent("Notify",source,"importante","Não estamos contratando pessoas com <b>Ficha Criminal</b>, caso queira trabalhar<br>conosco procure as autoridades e efetue a limpeza da mesma.",10000)
			return false
		end

		local valor = math.random(1500,2000)
		local result = valor+(valor*data.creative.piloto*0.0001)
		vRP.giveMoney(user_id,parseInt(result))
		if vRP.tryGetInventoryItem(user_id,"rebite",1) then
			vRP.giveInventoryItem(user_id,"dinheirosujo",math.random(350,500))
		end
	end
end