local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

--[ CONNECTION ]----------------------------------------------------------------------------------------------------------------

vRPN = {}
Tunnel.bindInterface("vrp_doors",vRPN)
Proxy.addInterface("vrp_doors",vRPN)

--[ VARIABLES ]-----------------------------------------------------------------------------------------------------------------

local cfg = module("vrp_doors","config/config")
local timers = {}

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

--[ TIMERS ID | THREAD ]--------------------------------------------------------------------------------------------------------

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

--[ OPEN DOOR TIME | FUNCTION ]-------------------------------------------------------------------------------------------------

function vRPN.timeOpen(id)
	TriggerClientEvent('vrpdoorsystem:statusSend',-1,id,false)
	if cfg.list[id].other ~= nil then
		local idsecond = cfg.list[id].other
		cfg.list[idsecond].lock = cfg.list[id].lock
		TriggerClientEvent('vrpdoorsystem:statusSend',-1,idsecond,false)
	end
end

--[ CLOSE DOOR TIME | FUNCTION ]------------------------------------------------------------------------------------------------

function vRPN.timeClose(id)
	if timers[id] == 0 or not timers[id] then
		TriggerClientEvent('vrpdoorsystem:statusSend',-1,id,true)
		if cfg.list[id].other ~= nil then
			local idsecond = cfg.list[id].other
			cfg.list[idsecond].lock = cfg.list[id].lock
			TriggerClientEvent('vrpdoorsystem:statusSend',-1,idsecond,true)
		end
	else
		TriggerClientEvent('vrpdoorsystem:statusSend',-1,id,false)
		if cfg.list[id].other ~= nil then
			local idsecond = cfg.list[id].other
			cfg.list[idsecond].lock = cfg.list[id].lock
			TriggerClientEvent('vrpdoorsystem:statusSend',-1,idsecond,false)
		end
	end
end

--[ FORCE OPEN DOOR | FUNCTION ]------------------------------------------------------------------------------------------------

function vRPN.forceOpen(id)
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

--[ CHECK TIME AND ITEM | FUNCTION ]--------------------------------------------------------------------------------------------

function vRPN.checkItemTime(id)
	local source = source
	local user_id = vRP.getUserId(source)

	if timers[id] == 0 or not timers[id] then
		if vRP.tryGetInventoryItem(user_id,"lockpick",1) then
			return true
		else
			TriggerClientEvent("Notify",source,"negado","Precisa de <b>Lockpick</b>.")
			return false
		end
	else
		TriggerClientEvent("Notify",source,"negado","Essa porta <b>já está destrancada</b> por <b>"..timers[id].." segundos</b>.")
		return false
	end
end