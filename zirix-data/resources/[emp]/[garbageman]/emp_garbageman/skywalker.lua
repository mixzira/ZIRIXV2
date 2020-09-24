local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

--[ CONNECTION ]----------------------------------------------------------------------------------------------------------------

emp = {}
Tunnel.bindInterface("emp_garbageman",emp)

--[ FUNCTION ]------------------------------------------------------------------------------------------------------------------

function emp.payment()
	local source = source
	local user_id = vRP.getUserId(source)
	local payment = 20 + math.random(5,40)
	
	if user_id then
		vRP.giveDinheirama(user_id,payment)
		TriggerClientEvent("Notify",source,"sucesso","<b>Lixo coletado!</b> | Ganhos: <b>$"..payment.." dólares</b>.")
	end
end
