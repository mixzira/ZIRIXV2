local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

--[ VARIABLES ]------------------------------------------------------------------------------------------------------------------------------

local valores = {
	{ item = "laranja", quantidade = 1, vender = 60 },
	{ item = "tomate", quantidade = 1, vender = 60 },
	{ item = "blueberry", quantidade = 1, vender = 60 },
}

--[ SALE EVENT ]----------------------------------------------------------------------------------------------------------------------

RegisterServerEvent("departamento-vender")
AddEventHandler("departamento-vender",function(item)
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