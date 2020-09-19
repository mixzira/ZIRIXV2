local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

--[ ARRAY ]------------------------------------------------------------------------------------------------------------------------------

local valores = {
	{ item = "diamante", quantidade = 1, vender = 700 },
	{ item = "barra-ouro", quantidade = 1, vender = 600 },
	{ item = "barra-prata", quantidade = 1, vender = 500 },
	{ item = "barra-ferro", quantidade = 1, vender = 300 }
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- VENDER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("departamento-vender")
AddEventHandler("departamento-vender",function(item)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		for k,v in pairs(valores) do
			if item == v.item then
				if vRP.tryGetInventoryItem(user_id,v.item,parseInt(v.quantidade)) then
					TriggerClientEvent("Notify",source,"sucesso","Comprou <b>"..parseInt(v.quantidade).."x "..vRP.itemNameList(v.item).."</b> por <b>$"..vRP.format(parseInt(v.vender)).." dólares</b>.")
					vRP.giveDinheirama(user_id,parseInt(v.vender))
				else
					TriggerClientEvent("Notify",source,"negado","Você precisa de <b>x"..v.quantidade.." "..v.item.."</b>.")
				end
			end
		end
	end
end)