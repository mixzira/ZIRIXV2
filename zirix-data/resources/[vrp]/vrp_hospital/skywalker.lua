local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local Tools = module("vrp","lib/Tools")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

--[ CONEXÕES ]------------------------------------------------------------------------------------------------------------------------------------------------------------------

Resg = {}
Tunnel.bindInterface("vrp_hospital",Resg)

--[ VARIÁVEL ]------------------------------------------------------------------------------------------------------------------------------------------------------------------

local idgens = Tools.newIDGenerator()

--[ WEBHOOK ]-------------------------------------------------------------------------------------------------------------------------------------------------------------------

local logSistemaLaudo = ""

--[ RESGATE ]-------------------------------------------------------------------------------------------------------------------------------------------------------------------

RegisterCommand('resgate', function(source,args,rawCommand)
 	local user_id = vRP.getUserId(source)
 	local player = vRP.getUserSource(user_id)
 	local colaboradordmla = vRP.getUsersByPermission("ems.permissao")
 	local paramedicos = 0
	
	for k,v in ipairs(colaboradordmla) do
		paramedicos = paramedicos + 1
	end

	if parseInt(#colaboradordmla) == 0 then
		TriggerClientEvent("Notify",source,"importante", "Não há <b>colaboradores do departamento médico</b> em serviço no momento.")
	elseif parseInt(#colaboradordmla) == 1 then
		TriggerClientEvent("Notify",source,"importante", "Atualmente, <b>"..paramedicos.." colaborador do departamento médico</b> está em serviço.")
	elseif  parseInt(#colaboradordmla) >= 1 then
		TriggerClientEvent("Notify",source,"importante", "Atualmente, <b>"..paramedicos.." colaboradores do departamento médico</b> estão em serviço.")
	end

	
end)

-- [ REANIMAR ] ----------------------------------------------------------------------------------------------------------------------------------------------------------------

RegisterCommand('reanimar',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"administrador.permissao") or vRP.hasPermission(user_id,"ems.permissao") then
		TriggerClientEvent('reanimar',source)
	end
end)

RegisterServerEvent("reanimar:pagamento")
AddEventHandler("reanimar:pagamento",function()
	local user_id = vRP.getUserId(source)
	if user_id then
		pagamento = math.random(50,80)
		vRP.giveMoney(user_id,pagamento)
		TriggerClientEvent("Notify",source,"sucesso","Recebeu <b>$"..pagamento.." dólares</b> de gorjeta do americano.")
	end
end)

-- [ RE ] ----------------------------------------------------------------------------------------------------------------------------------------------------------------------

RegisterCommand('re',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"ems.permissao") then
		local nplayer = vRPclient.getNearestPlayer(source,2)
		
		if nplayer then
			if vRPclient.isInComa(nplayer) then
				local identity_user = vRP.getUserIdentity(user_id)
				local nuser_id = vRP.getUserId(nplayer)
				local identity_coma = vRP.getUserIdentity(nuser_id)
				
				local set_user = "Departamento Médico"

				TriggerClientEvent('cancelando',source,true)
				vRPclient._playAnim(source,false,{{"amb@medic@standing@tendtodead@base","base"},{"mini@cpr@char_a@cpr_str","cpr_pumpchest"}},true)
				TriggerClientEvent("progress",source,30000,"reanimando")

				SetTimeout(30000,function()	
					vRPclient.killGod(nplayer)
					vRPclient._stopAnim(source,false)
					TriggerClientEvent('cancelando',source,false)
				end)

			else
				TriggerClientEvent("Notify",source,"importante","A pessoa precisa estar em coma para prosseguir.")
			end
		else
			TriggerClientEvent("Notify",source,"importante","Chegue mais perto do paciente.")
		end
	elseif vRP.hasPermission(user_id,"policia.permissao") then
		if Resg.checkServices() then
			if nplayer then
				if vRPclient.isInComa(nplayer) then
					local identity_user = vRP.getUserIdentity(user_id)
					local nuser_id = vRP.getUserId(nplayer)
					local identity_coma = vRP.getUserIdentity(nuser_id)
					
					local set_user = "Departmanto de Polícia"
	
					TriggerClientEvent('cancelando',source,true)
					vRPclient._playAnim(source,false,{{"amb@medic@standing@tendtodead@base","base"},{"mini@cpr@char_a@cpr_str","cpr_pumpchest"}},true)
					TriggerClientEvent("progress",source,30000,"reanimando")
					
					SetTimeout(30000,function()
						vRPclient.killGod(nplayer)
						vRPclient._stopAnim(source,false)
						TriggerClientEvent('cancelando',source,false)
					end)
				else
					TriggerClientEvent("Notify",source,"importante","A pessoa precisa estar em coma para prosseguir.")
				end
			end
		else
			TriggerClientEvent("Notify",source,"negado","Existem membros do Departamento Médico em serviço!")
		end 
	end
end)

--[ TRATAMENTO ]----------------------------------------------------------------------------------------------------------------------------------------------------------------

RegisterCommand('tratamento',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"ems.permissao") then
        local nplayer = vRPclient.getNearestPlayer(source,3)
        if nplayer then
			if not vRPclient.isComa(nplayer) then
				TriggerClientEvent("medical-tratamento",nplayer)
				TriggerClientEvent("Notify",source,"sucesso","Tentando tratar o paciente.",10000)
            end
        end
    end
end)

--[ FUNÇÕES ]-------------------------------------------------------------------------------------------------------------------------------------------------------------------

function Resg.checkServices()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local dmla = vRP.getUsersByPermission("ems.permissao")
		if parseInt(#dmla) == 0 then
			return true
		end
	end
end

--[ LAUDO MÉDICO ]--------------------------------------------------------------------------------------------------------------------------------------------------------------

RegisterCommand('laudo',function(source,args,rawCommand)
	local source = source
	local user_id = vRP.getUserId(source)

	if vRP.hasPermission(user_id,"ems.permissao") then
		local source = source
		local user_id = vRP.getUserId(source)
		local identity = vRP.getUserIdentity(user_id)
		
		local nomep = vRP.prompt(source, "Nome completo do paciente:", "")
		if nomep ~= "" then
			local rgp = vRP.prompt(source, "RG do paciente:", "")
			if rgp ~= "" then
				local anamnese = vRP.prompt(source, "Anamnese:", "")
				if anamnese ~= "" then
					local laudo = vRP.prompt(source, "Laudo Médico:", "")
					if laudo ~= "" then
						local receutuario = vRP.prompt(source, "Medicamento receitado:", "")

						if receutuario == "paracetamil" or receutuario == "Paracetamil"  then
							vRP.giveInventoryItem(user_id,"r-paracetamil",1)
				
						elseif receutuario == "voltarom" or receutuario == "Voltarom" then
							vRP.giveInventoryItem(user_id,"r-voltarom",1)
				
						elseif receutuario == "trandrylux" or receutuario == "Trandrylux" then
							vRP.giveInventoryItem(user_id,"r-trandrylux",1)
				
						elseif receutuario == "dorfrex" or receutuario == "Dorfrex" then
							vRP.giveInventoryItem(user_id,"r-dorfrex",1)
				
						elseif receutuario == "buscopom" or receutuario == "Buscopom"  then
							vRP.giveInventoryItem(user_id,"r-buscopom",1)
				
						end

						PerformHttpRequest(logSistemaLaudo, function(err, text, headers) end, 'POST', json.encode({
							embeds = {
								{ 	------------------------------------------------------------
									title = "LAUDO MÉDICO:⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n⠀",
									thumbnail = {
									url = "https://i.imgur.com/5ydYKZg.png"
									}, 
									fields = {
										{ 
											name = "**NOME DO PACIENTE:**", 
											value = nomep.." \n⠀",
										},
										{ 
											name = "**ANAMNESE:**",
											value = anamnese.." \n⠀"
										},
										{ 
											name = "**RG DO PACIENTE:**",
											value = rgp
										},
										{ 
											name = "**LAUDO MÉDICO:**",
											value = laudo.." \n⠀"
										},
										{ 
											name = "**RECEITUÁRIO:**",
											value = receutuario.." \n⠀"
										},
										{ 
											name = "**NOME DO MÉDICO:**",
											value = identity.name.." "..identity.firstname.." \n⠀"
										}
				
									}, 
									footer = { 
										text = "ZIRIX - "..os.date("%d/%m/%Y | %H:%M:%S"), 
										icon_url = "https://i.imgur.com/5ydYKZg.png"
									},
									color = 15906321 
								}
							}
						}), { ['Content-Type'] = 'application/json' })
					else
						TriggerClientEvent("Notify",source,"negado","É <b>obrigatório</b> informar o laúdo médico.",10000)
					end
				else
					TriggerClientEvent("Notify",source,"negado","É <b>obrigatório</b> informar a anamnese informada pelo paciente.",10000)
				end
			else
				TriggerClientEvent("Notify",source,"negado","É <b>obrigatório</b> informar o rg do paciente.",10000)
			end
		else
			TriggerClientEvent("Notify",source,"negado","É <b>obrigatório</b> informar o nome do paciente.",10000)
		end
	end
end)

--[ LAUDO MÉDICO ]--------------------------------------------------------------------------------------------------------------------------------------------------------------

RegisterCommand('sme',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"ems.permissao") then
			if args[1] == "cadeira" then
				if args[2] == "add" then
					TriggerClientEvent("vrp_for_medic:wheelchair:spawn", source)
				elseif args[2] == "rem" then
					TriggerClientEvent("vrp_for_medic:wheelchair:delete", source)
				end
			elseif args[1] == "maca" then
				if args[2] == "add" then
					TriggerClientEvent("vrp_for_medic:stretcher:spawn", source)
				elseif args[2] == "rem" then
					TriggerClientEvent("vrp_for_medic:stretcher:delete", source)
				end
			end
		end
	end
end)