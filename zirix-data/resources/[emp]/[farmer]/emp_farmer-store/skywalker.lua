local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

--[ CONNECTION ]-------------------------------------------------------------------------------------------------------------------------

emp = {}
Tunnel.bindInterface("emp_miner-store",emp)

--[ VARIABLES ]--------------------------------------------------------------------------------------------------------------------------

local valores = {
	{ item = "semente-blueberry", quantidade = 1, compra = 30 },
	{ item = "semente-laranja", quantidade = 1, compra = 30 },
	{ item = "semente-tomate", quantidade = 1, compra = 30 },
	{ item = "blueberry", quantidade = 1, vender = 60 },
	{ item = "laranja", quantidade = 1, vender = 60 },
	{ item = "tomate", quantidade = 1, vender = 60 }
}

--[ COMPRAR ]----------------------------------------------------------------------------------------------------------------------------

RegisterServerEvent("departamento-comprar")
AddEventHandler("departamento-comprar",function(item)
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

--[ COMPRAR ]----------------------------------------------------------------------------------------------------------------------------

RegisterServerEvent("farmer-vender")
AddEventHandler("farmer-vender",function(item)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		for k,v in pairs(valores) do
			if item == v.item then
				if vRP.tryGetInventoryItem(user_id,v.item,parseInt(v.quantidade)) then
					TriggerClientEvent("Notify",source,"sucesso","Vendeu <b>"..parseInt(v.quantidade).."x "..vRP.itemNameList(v.item).."</b> por <b>$"..vRP.format(parseInt(v.vender)).." dólares</b>.")
					vRP.giveDinheirama(user_id,parseInt(v.vender))
				else
					TriggerClientEvent("Notify",source,"negado","Você precisa de <b>x"..v.quantidade.." "..v.item.."</b>.")
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