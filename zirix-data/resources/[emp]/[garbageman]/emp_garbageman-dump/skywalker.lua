local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

--[ CONNECTION ]----------------------------------------------------------------------------------------------------------------

emp = {}
Tunnel.bindInterface("emp_garbageman-dump",emp)

--[ IN WORKING AREA | THREAD ]--------------------------------------------------------------------------------------------------

function emp.checkPayment()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.getToken(user_id) > 0 then
			TriggerClientEvent("Notify",source,"importante","Não estamos contratando pessoas com <b>Ficha Criminal</b>, caso queira trabalhar<br>conosco procure as autoridades e efetue a limpeza da mesma.",10000)
			return false
		end

		local data = vRP.getUserAptitudes(user_id)
		if data then
			if vRP.tryGetInventoryItem(user_id,"sacodelixo",1) then
				local valor = math.random(120,220)
				local result = valor+(valor*data.creative.lixeiro*0.0001)
				vRP.giveMoney(user_id,parseInt(result))
				TriggerClientEvent("vrp_sound:source",source,'coin',0.2)
				TriggerClientEvent("Notify",source,"sucesso","Despejo concluído, recebido <b>$"..vRP.format(parseInt(result)).." dólares</b>.",8000)
				return true
			end
		end
	end
end