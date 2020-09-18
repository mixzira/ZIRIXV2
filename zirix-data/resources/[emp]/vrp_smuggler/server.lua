-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local Tools = module("vrp","lib/Tools")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONEXÃO
-----------------------------------------------------------------------------------------------------------------------------------------
src = {}
Tunnel.bindInterface("vrp_smuggler",src)
local idgens = Tools.newIDGenerator()
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIÁVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local blips = {}
local amount = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- STARTPAYMENTS
-----------------------------------------------------------------------------------------------------------------------------------------
function src.startPayments()
	local source = source

	if amount[source] == nil then
		amount[source] = math.random(20,40)
	end

	local user_id = vRP.getUserId(source)
	if user_id then
		local data = vRP.getUserAptitudes(user_id)
		if data then
			if vRP.tryGetInventoryItem(user_id,"wammo|WEAPON_ASSAULTSMG",amount[source]) then
				local price = math.random(90,105)
				local payment = price+(price*data.creative.contrabandista*0.0001)

				vRP.giveInventoryItem(user_id,"dinheirosujo",parseInt(payment*amount[source]))
				TriggerClientEvent("vrp_sound:source",source,'coin',0.2)
				TriggerClientEvent("Notify",source,"sucesso","Entrega concluída, recebido <b>$"..vRP.format(parseInt(payment*amount[source])).." dólares</b>.",8000)

				amount[source] = nil

				if math.random(100) >= 75 then
					vRP.searchTimer(user_id,120)
					TriggerClientEvent("Notify",source,"aviso","A policia foi acionada.",8000)

					local x,y,z = vRPclient.getPosition(source)
					local policia = vRP.getUsersByPermission("policia.permissao")

					if parseInt(#policia) <= 3 then
						TriggerClientEvent("lockCops",source)
					end

					for k,v in pairs(policia) do
						local player = vRP.getUserSource(parseInt(v))
						if player then
							async(function()
								vRPclient._playSound(player,"CONFIRM_BEEP","HUD_MINI_GAME_SOUNDSET")
								TriggerClientEvent("NotifyPush",player,{ code = 58, title = "Recebemos uma denuncia do tráfico de munições, verifique o ocorrido.", x = x, y = y, z = z, badge = "Ammunition Trafficking." })
							end)
						end
						Citizen.Wait(10)
					end
				end
				
				return true
			else
				TriggerClientEvent("Notify",source,"aviso","Você precisa de <b>"..amount[source].."x Munições de MTAR-21</b>.",8000)
			end
		end
		return false
	end
end