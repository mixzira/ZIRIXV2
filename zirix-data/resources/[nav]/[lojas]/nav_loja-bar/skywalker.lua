local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

--[ ARRAY ]------------------------------------------------------------------------------------------------------------------------------

local valores = {
	{ item = "pibwassen", quantidade = 1, compra = 12 },
	{ item = "tequilya", quantidade = 1, compra = 24 },
	{ item = "patriot", quantidade = 1, compra = 12 },
	{ item = "blarneys", quantidade = 1, compra = 25 },
	{ item = "jakeys", quantidade = 1, compra = 36 },
	{ item = "barracho", quantidade = 1, compra = 12 },
	{ item = "ragga", quantidade = 1, compra = 20 },
	{ item = "nogo", quantidade = 1, compra = 29 },
	{ item = "mount", quantidade = 1, compra = 51 },
	{ item = "cherenkov", quantidade = 1, compra = 39 },
	{ item = "bourgeoix", quantidade = 1, compra = 42 },
	{ item = "bleuterd", quantidade = 1, compra = 34 }
}

--[ COMPRAR ]----------------------------------------------------------------------------------------------------------------------------

RegisterServerEvent("bar-comprar")
AddEventHandler("bar-comprar",function(item)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		for k,v in pairs(valores) do
			if item == v.item then
				if vRP.getInventoryWeight(user_id)+vRP.getItemWeight(v.item)*v.quantidade <= vRP.getInventoryMaxWeight(user_id) then
					local preco = parseInt(v.compra)
					if preco then
						if vRP.hasPermission(user_id,"ultimate.permissao") then
							desconto = math.floor(preco*20/100)
							pagamento = math.floor(preco-desconto)
						elseif vRP.hasPermission(user_id,"platinum.permissao") then
							desconto = math.floor(preco*15/100)
							pagamento = math.floor(preco-desconto)
						elseif vRP.hasPermission(user_id,"gold.permissao") then
							desconto = math.floor(preco*10/100)
							pagamento = math.floor(preco-desconto)
						elseif vRP.hasPermission(user_id,"standard.permissao") then
							desconto = math.floor(preco*5/100)
							pagamento = math.floor(preco-desconto)
						else
							pagamento = math.floor(preco)
						end
				
						if vRP.tryPayment(user_id,parseInt(pagamento)) then
							TriggerClientEvent("Notify",source,"sucesso","Comprou <b>"..parseInt(v.quantidade).."x "..vRP.itemNameList(v.item).."</b> por <b>$"..vRP.format(parseInt(pagamento)).." dólares</b>.")
							vRP.giveInventoryItem(user_id,v.item,parseInt(v.quantidade))
						else
							TriggerClientEvent("Notify",source,"negado","Dinheiro insuficiente.")
						end
					end
				else
					TriggerClientEvent("Notify",source,"negado","Espaço insuficiente.")
				end
			end
		end
	end
end)