local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

--[ CONNECTION ]----------------------------------------------------------------------------------------------------------------

emp = {}
Tunnel.bindInterface("emp_garbageman",emP)

--[ FUNCTION ]------------------------------------------------------------------------------------------------------------------

function emp.checkPayment()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.getToken(user_id) > 0 then
			TriggerClientEvent("Notify",source,"importante","Não estamos contratando pessoas com <b>Ficha Criminal</b>, caso queira trabalhar<br>conosco procure as autoridades e efetue a limpeza da mesma.",10000)
			return false
		end

		if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("sacodelixo") <= vRP.getInventoryMaxWeight(user_id) then
			vRP.giveInventoryItem(user_id,"sacodelixo",1)
			return true
		end
	end
end