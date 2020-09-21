local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

--[ CONNECTION ]----------------------------------------------------------------------------------------------------------------

emp = {}
Tunnel.bindInterface("emp_farmer-store",emp)

--[ VARIABLES ]-----------------------------------------------------------------------------------------------------------------

local items = {
	{ item = "semente-blueberry", amount = 1, purchasePrice = 30 },
	{ item = "semente-laranja", amount = 1, purchasePrice = 30 },
	{ item = "semente-tomate", amount = 1, purchasePrice = 30 },
	{ item = "blueberry", amount = 1, salePrice = 60 },
	{ item = "laranja", amount = 1, salePrice = 60 },
	{ item = "tomate", amount = 1, salePrice = 60 }
}

--[ BUY | EVENT ]---------------------------------------------------------------------------------------------------------------

RegisterServerEvent("farmer-buy")
AddEventHandler("farmer-buy",function(item)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		for k,v in pairs(items) do
			if item == v.item then
				if vRP.getInventoryWeight(user_id)+vRP.getItemWeight(v.item)*v.amount <= vRP.getInventoryMaxWeight(user_id) then
					local price = parseInt(v.purchasePrice)
					if price then
						if vRP.hasPermission(user_id,"ultimate.permissao") then
							discount = math.floor(price*20/100)
							payment = math.floor(price-discount)
						elseif vRP.hasPermission(user_id,"platinum.permissao") then
							discount = math.floor(price*15/100)
							payment = math.floor(price-discount)
						elseif vRP.hasPermission(user_id,"gold.permissao") then
							discount = math.floor(price*10/100)
							payment = math.floor(price-discount)
						elseif vRP.hasPermission(user_id,"standard.permissao") then
							discount = math.floor(price*5/100)
							payment = math.floor(price-discount)
						else
							payment = math.floor(price)
						end
						if vRP.tryPayment(user_id,parseInt(payment)) then
							TriggerClientEvent("Notify",source,"sucesso","Comprou <b>"..parseInt(v.amount).."x "..vRP.itemNameList(v.item).."</b> por <b>$"..vRP.format(parseInt(payment)).." dólares</b>.")
							vRP.giveInventoryItem(user_id,v.item,parseInt(v.amount))
						else
							TriggerClientEvent("Notify",source,"negado","<b>Dinheiro</b> insuficiente.")
						end
					end
				else
					TriggerClientEvent("Notify",source,"negado","<b>Mochila</b> cheia.")
				end
			end
		end
	end
end)

--[ SELL | EVENT ]--------------------------------------------------------------------------------------------------------------

RegisterServerEvent("farmer-sell")
AddEventHandler("farmer-sell",function(item)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		for k,v in pairs(items) do
			if item == v.item then
				if vRP.tryGetInventoryItem(user_id,v.item,parseInt(v.amount)) then
					TriggerClientEvent("Notify",source,"sucesso","Vendeu <b>"..parseInt(v.amount).."x "..vRP.itemNameList(v.item).."</b> por <b>$"..vRP.format(parseInt(v.salePrice)).." dólares</b>.")
					vRP.giveDinheirama(user_id,parseInt(v.salePrice))
				else
					TriggerClientEvent("Notify",source,"negado","Você precisa de <b>x"..v.amount.." "..v.item.."</b>.")
				end
			end
		end
	end
end)

--[ FUNCTION ]---------------------------------------------------------------------------------------------------------------------------

function emp.checkCrimeRecord()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.checkCrimeRecord(user_id) > 0 then
			TriggerClientEvent("Notify",source,"negado","Não contratamos pessoas com <b>Ficha Criminal</b>.",10000)
			return false
		else
			return true
		end
	end
end