local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
emP = {}
Tunnel.bindInterface("emp_pescador",emP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
local peixes = {
	[1] = { "dourado" },
	[2] = { "corvina" },
	[3] = { "salmao" },
	[4] = { "pacu" },
	[5] = { "pintado" },
	[6] = { "pirarucu" },
	[7] = { "tilapia" },
	[8] = { "tucunare" }
}

function emP.checkPayment()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.getToken(user_id) > 0 then
			TriggerClientEvent("Notify",source,"importante","Não estamos contratando pessoas com <b>Ficha Criminal</b>, caso queira trabalhar<br>conosco procure as autoridades e efetue a limpeza da mesma.",10000)
			return false
		end

		if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("dourado") <= vRP.getInventoryMaxWeight(user_id) then
			if vRP.tryGetInventoryItem(user_id,"isca",1) then
				if math.random(100) >= 99 then
					vRP.giveInventoryItem(user_id,"lambari",1)
				else
					vRP.giveInventoryItem(user_id,peixes[math.random(8)][1],1)
				end
				return true
			end
		end
	end
end