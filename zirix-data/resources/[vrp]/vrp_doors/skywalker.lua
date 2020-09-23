local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

--[ CONNECTION ]----------------------------------------------------------------------------------------------------------------

vRPN = {}
Tunnel.bindInterface("vrp_doors",vRPN)
Proxy.addInterface("vrp_doors",vRPN)

--[ VARIABLES ]-----------------------------------------------------------------------------------------------------------------

local cfg = module("vrp_doors","config/config")

--[ SPAWN | EVENT ]-------------------------------------------------------------------------------------------------------------

AddEventHandler("vRP:playerSpawn",function(user_id,source,first_spawn)
	if first_spawn then
		TriggerClientEvent('vrpdoorsystem:load',source,cfg.list)
	end
end)

--[ OPEN DOOR PERMISSION | EVENT ]----------------------------------------------------------------------------------------------

RegisterServerEvent('vrpdoorsystem:open')
AddEventHandler('vrpdoorsystem:open',function(id)
	local source = source
	local user_id = vRP.getUserId(source)
	
	if vRP.hasPermission(user_id,cfg.list[id].perm) or vRP.hasPermission(user_id,cfg.list[id].perm2) or vRP.hasPermission(user_id,"administrador.permissao") or vRP.hasPermission(user_id,"manager.permissao") then
		cfg.list[id].lock = not cfg.list[id].lock
		TriggerClientEvent('vrpdoorsystem:statusSend',-1,id,cfg.list[id].lock)
		if cfg.list[id].other ~= nil then
			local idsecond = cfg.list[id].other
			cfg.list[idsecond].lock = cfg.list[id].lock
			TriggerClientEvent('vrpdoorsystem:statusSend',-1,idsecond,cfg.list[id].lock)
		end
	end
end)