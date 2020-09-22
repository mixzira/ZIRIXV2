local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

local cfg = module("vrp_doors","cfg/config")

AddEventHandler("vRP:playerSpawn",function(user_id,source,first_spawn)
	if first_spawn then
		TriggerClientEvent('vrpdoorsystem:load',source,cfg.list)
	end
end)

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

RegisterServerEvent('vrpdoorsystem:timeLock')
AddEventHandler('vrpdoorsystem:timeLock',function(id)
	local source = source
	local user_id = vRP.getUserId(source)
	
	TriggerClientEvent('vrpdoorsystem:statusSend',-1,id,true)
	if cfg.list[id].other ~= nil then
		local idsecond = cfg.list[id].other
		cfg.list[idsecond].lock = cfg.list[id].lock
		TriggerClientEvent('vrpdoorsystem:statusSend',-1,idsecond,true)
	end
end)

RegisterServerEvent('vrpdoorsystem:timeOpen')
AddEventHandler('vrpdoorsystem:timeOpen',function(id)
	local source = source
	local user_id = vRP.getUserId(source)
	
	TriggerClientEvent('vrpdoorsystem:statusSend',-1,id,false)
	if cfg.list[id].other ~= nil then
		local idsecond = cfg.list[id].other
		cfg.list[idsecond].lock = cfg.list[id].lock
		TriggerClientEvent('vrpdoorsystem:statusSend',-1,idsecond,false)
	end
end)