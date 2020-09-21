-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONEXÃO
-----------------------------------------------------------------------------------------------------------------------------------------
src = {}
Tunnel.bindInterface("vrp_impound",src)
vCLIENT = Tunnel.getInterface("vrp_impound")
vGARAGE = Tunnel.getInterface("vrp_garages")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIÁVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local impoundVehs = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKIMPOUND
-----------------------------------------------------------------------------------------------------------------------------------------
function src.checkImpound()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.getToken(user_id) > 0 then
			TriggerClientEvent("Notify",source,"importante","Não estamos contratando pessoas com <b>Ficha Criminal</b>, caso queira trabalhar<br>conosco procure as autoridades e efetue a limpeza da mesma.",10000)
			return false
		end

		if vRP.hasPermission(user_id,"mecanico.permissao") then
			local vehicle,vnetid,placa,vname = vRPclient.vehList(source,7)
			if vehicle then
				if impoundVehs[vname.."-"..placa] then
					vRP.giveMoney(user_id,4000)
					vGARAGE.deleteVehicle(source,vehicle)
					TriggerClientEvent("Notify",source,"importante","O veículo <b>"..vRP.vehicleName(vname).."</b> foi enviado ao <b>DMV</b> e você recebeu<br><b>$4.000 dólares</b> como pagamento por seu serviço.",10000)
					impoundVehs[vname.."-"..placa] = nil
					return true
				end
			end
		end
		return false
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKIMPOUND
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("impound",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"policia.permissao") then
			local vehicle,vnetid,placa,vname = vRPclient.vehList(source,7)
			if vehicle then
				if not impoundVehs[vname.."-"..placa] then
					impoundVehs[vname.."-"..placa] = true
					TriggerClientEvent("Notify",source,"sucesso","O veículo <b>"..vRP.vehicleName(vname).."</b> foi cadastrado na lista do <b>DMV</b>.",10000)
				else
					TriggerClientEvent("Notify",source,"aviso","O veículo <b>"..vRP.vehicleName(vname).."</b> já encontra-se na lista do <b>DMV</b>.",10000)
				end
			end
		end
	end
end)