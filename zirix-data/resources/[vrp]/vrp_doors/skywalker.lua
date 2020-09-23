local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

--[ CONNECTION ]----------------------------------------------------------------------------------------------------------------

vRPN = {}
Tunnel.bindInterface("vrp_doors",vRPN)
Proxy.addInterface("vrp_doors",vRPN)

--[ VARIABLES ]-----------------------------------------------------------------------------------------------------------------

local cfg = module("vrp_doors","cfg/config")
local hora = 0
local timers = {}

--[ EVENTS ]--------------------------------------------------------------------------------------------------------------------

AddEventHandler("vRP:playerSpawn",function(user_id,source,first_spawn)
	if first_spawn then
		TriggerClientEvent('vrpdoorsystem:load',source,cfg.list)
	end
end)

RegisterServerEvent('vrpdoorsystem:updateHora')
AddEventHandler('vrpdoorsystem:updateHora',function(hour)
	hora = hour
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

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		for k,v in pairs(timers) do
			if v > 0 then
				timers[k] = v - 1
			end
		end
	end
end)

function vRPN.checkItemTime(id)
	local source = source
	local user_id = vRP.getUserId(source)

	if timers[id] == 0 or not timers[id] then
		if cfg.list[id].public then
			if vRP.tryGetInventoryItem(user_id,"lockpick",1) then
				return true
			else
				TriggerClientEvent('Notify',source,'negado','Você precisa de uma lockpick para fazer isso!')
				return false
			end
		else
			TriggerClientEvent('Notify',source,'negado','Você não pode destrancar essa porta!')
			return false
		end
	else
		TriggerClientEvent('Notify',source,'negado','Porta destrancada por '..timers[id]..' segundos.')
		return false
	end
end

function vRPN.timeClose(id)
	local source = source
	local user_id = vRP.getUserId(source)
	
	if timers[id] == 0 or not timers[id] then
		TriggerClientEvent('vrpdoorsystem:statusSend',-1,id,true)
		if cfg.list[id].other ~= nil then
			local idsecond = cfg.list[id].other
			cfg.list[idsecond].lock = cfg.list[id].lock
			TriggerClientEvent('vrpdoorsystem:statusSend',-1,idsecond,true)
		end
	end
end

function vRPN.forceOpen(id)
	local source = source
	local user_id = vRP.getUserId(source)
	
	if timers[id] == 0 or not timers[id] then
		timers[id] = 120
		TriggerClientEvent('vrpdoorsystem:statusSend',-1,id,false)
		if cfg.list[id].other ~= nil then
			local idsecond = cfg.list[id].other
			cfg.list[idsecond].lock = cfg.list[id].lock
			TriggerClientEvent('vrpdoorsystem:statusSend',-1,idsecond,false)
		end
	end
end

--[ THREADS ]-------------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10000)
		if parseInt(hora) >= 07 and parseInt(hora) <= 17 then
			TriggerClientEvent('vrpdoorsystem:infoDoors',-1,false)
		else
			TriggerClientEvent('vrpdoorsystem:infoDoors',-1,true)
		end
	end
end)