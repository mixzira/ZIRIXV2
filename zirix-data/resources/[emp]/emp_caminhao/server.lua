local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
emP = {}
Tunnel.bindInterface("emp_caminhao",emP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYLIST
-----------------------------------------------------------------------------------------------------------------------------------------
local paylist = {
	["diesel"] = {
		[1] = { pay = math.random(3900,5900) },
		[2] = { pay = math.random(3600,5600) },
		[3] = { pay = math.random(3900,5900) },
		[4] = { pay = math.random(3300,5300) },
		[5] = { pay = math.random(3300,5300) },
		[6] = { pay = math.random(3600,5600) },
		[7] = { pay = math.random(4200,6200) },
		[8] = { pay = math.random(3900,5900) },
		[9] = { pay = math.random(600,2600) },
		[10] = { pay = math.random(1500,3500) },
		[11] = { pay = math.random(1500,3500) },
		[12] = { pay = math.random(1200,3200) },
		[13] = { pay = math.random(1200,3200) },
		[14] = { pay = math.random(1200,3200) },
		[15] = { pay = math.random(1200,3200) },
		[16] = { pay = math.random(600,2600) },
		[17] = { pay = math.random(1800,3800) },
		[18] = { pay = math.random(2700,4700) },
		[19] = { pay = math.random(3300,5300) },
		[20] = { pay = math.random(3600,5600) },
		[21] = { pay = math.random(3000,5000) },
		[22] = { pay = math.random(3600,5600) },
		[23] = { pay = math.random(3900,5900) },
		[24] = { pay = math.random(4200,6200) },
		[25] = { pay = math.random(4200,6200) },
		[26] = { pay = math.random(4200,6200) },
		[27] = { pay = math.random(4200,6200) }
	},
	["gas"] = {
		[1] = { pay = math.random(3900,5900) },
		[2] = { pay = math.random(3600,5600) },
		[3] = { pay = math.random(3900,5900) },
		[4] = { pay = math.random(3300,5300) },
		[5] = { pay = math.random(3300,5300) },
		[6] = { pay = math.random(3600,5600) },
		[7] = { pay = math.random(4200,6200) },
		[8] = { pay = math.random(3900,5900) },
		[9] = { pay = math.random(600,2600) },
		[10] = { pay = math.random(1500,3500) },
		[11] = { pay = math.random(1500,3500) },
		[12] = { pay = math.random(1200,3200) },
		[13] = { pay = math.random(1200,3200) },
		[14] = { pay = math.random(1200,3200) },
		[15] = { pay = math.random(1200,3200) },
		[16] = { pay = math.random(600,2600) },
		[17] = { pay = math.random(1800,3800) },
		[18] = { pay = math.random(2700,4700) },
		[19] = { pay = math.random(3300,5300) },
		[20] = { pay = math.random(3600,5600) },
		[21] = { pay = math.random(3000,5000) },
		[22] = { pay = math.random(3600,5600) },
		[23] = { pay = math.random(3900,5900) },
		[24] = { pay = math.random(4200,6200) },
		[25] = { pay = math.random(4200,6200) },
		[26] = { pay = math.random(4200,6200) },
		[27] = { pay = math.random(4200,6200) }
	},
	["cars"] = {
		[1] = { pay = math.random(2500,3000) },
		[2] = { pay = math.random(2500,3000) },
		[3] = { pay = math.random(3000,3500) },
		[4] = { pay = math.random(3000,3500) },
		[5] = { pay = math.random(2500,3000) }
	},
	["woods"] = {
		[1] = { pay = math.random(2500,3000) },
		[2] = { pay = math.random(3000,3500) },
		[3] = { pay = math.random(2500,3000) },
		[4] = { pay = math.random(2500,3000) },
		[5] = { pay = math.random(3000,3500) }
	},
	["show"] = {
		[1] = { pay = math.random(2500,3000) },
		[2] = { pay = math.random(3000,3500) },
		[3] = { pay = math.random(3000,3500) },
		[4] = { pay = math.random(2500,3000) },
		[5] = { pay = math.random(2500,3000) }
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKPAYMENT
-----------------------------------------------------------------------------------------------------------------------------------------
function emP.checkPayment(id,mod,health)
	local source = source
	local user_id = vRP.getUserId(source)
	local data = vRP.getUserAptitudes(user_id)
	if user_id then
		if mod == "gas" or mod == "diesel" then
			TriggerEvent("vrp_engine:setGallons",parseInt(id))
		end

		local valor = paylist[mod][id].pay+health
		local result = valor+(valor*data.creative.caminhoneiro*0.0001)

		if vRP.getToken(user_id) > 0 then
			vRP.giveInventoryItem(user_id,"dinheirosujo",parseInt(result*1.5))
			TriggerClientEvent("Notify",source,"sucesso","Entrega concluída, recebido <b>$"..vRP.format(parseInt(result*1.5)).." dólares</b>.",8000)
		else
			vRP.giveMoney(user_id,parseInt(result))
			TriggerClientEvent("Notify",source,"sucesso","Entrega concluída, recebido <b>$"..vRP.format(parseInt(result)).." dólares</b>.",8000)
		end
		TriggerClientEvent("vrp_sound:source",source,'coin',0.2)

		if vRP.tryGetInventoryItem(user_id,"rebite",1) then
			vRP.giveInventoryItem(user_id,"dinheirosujo",math.random(1000,1400))
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETPLATE
-----------------------------------------------------------------------------------------------------------------------------------------
function emP.setPlate()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		return vRP.getUserIdentity(user_id).registration
	end
end