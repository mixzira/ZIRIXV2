local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

--[ ARRAY ]------------------------------------------------------------------------------------------------------------------------------

local plan = {}

local valores = {
	{ item = "radio", quantidade = 1, compra = 300 },
	{ item = "maquininha", quantidade = 1, compra = 600 },
	{ item = "celular", quantidade = 1, compra = 800 },
	{ item = "celular-pro", quantidade = 1, compra = 2800 }
}

local valoresPlanos = {
	{ plano = "planoOneDay", dias = 1, compra = 150 },
	{ plano = "planoThreeDay", dias = 3, compra = 300 },
	{ plano = "planoFiveDay", dias = 5, compra = 500 },
	{ plano = "planoTenDay", dias = 10, compra = 1000 }
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

RegisterServerEvent("departamento-comprarPlano")
AddEventHandler("departamento-comprarPlano",function(plano)
	local source = source
	local user_id = vRP.getUserId(source)
	
	if user_id then
		for k,v in pairs(valoresPlanos) do
			if plano == v.plano then
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
					
					local dias = parseInt(v.dias)

					if vRP.tryPayment(user_id,parseInt(pagamento)) then
						local consulta = vRP.getUData(user_id,"vRP:plano")
						local resultado = json.decode(consulta) or {}
						resultado.tempo = resultado.tempo or 0

						if resultado.tempo > 0 then
							resultado = resultado.tempo/1440 or 0

							TriggerClientEvent("Notify",source,"negado","Você já tem um plano ativo no momento, com <b>"..math.ceil(resultado).." dias restantes</b>.")
						else
							resultado.tempo = (resultado.tempo or 0)+tonumber(dias)*1440
							plan[vRP.getUserId(source)] = resultado.tempo
							vRP.setUData(user_id, "vRP:plano", json.encode(resultado))
							TriggerClientEvent("Notify",source,"sucesso","Plano contratado com sucesso! Você tem <b>"..dias.." dias restantes</b>.")
						end
					else
						TriggerClientEvent("Notify",source,"negado","Dinheiro insuficiente.")
					end
				end
			end
		end
	end
end)