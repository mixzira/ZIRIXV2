local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

vRPN = {}
Tunnel.bindInterface("vrp_identity",vRPN)
Proxy.addInterface("vrp_identity",vRPN)

local cfg = module("vrp","cfg/groups")
local groups = cfg.groups

local identidade = false

--[ FUNÇÕES ]----------------------------------------------------------------------------------------------------------------------------

function vRPN.Identidade()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local banco = vRP.getBankMoney(user_id)
		local identity = vRP.getUserIdentity(user_id)
		local multas = vRP.getUData(user_id,"vRP:multas")
		local mymultas = json.decode(multas) or 0

		local groupv = vRPN.getUserGroupByType(user_id,"job")
		local cargo = vRPN.getUserGroupByType(user_id,"hie")

		if groupv == "" and cargo == "" then
			groupv = "Desempregado"
		end

		if cargo ~= "" then
			groupv = cargo
		end

		local cnh = "Inválido"
		if identity.licenca == 0 then
			cnh = "Não habilitado"
		elseif identity.licenca == 1 then
			cnh = "Habilitado"
		elseif identity.licenca == 3 then
			cnh = "Cassada"
		end

		if identity then
			return identity.foto,identity.name,identity.firstname,identity.user_id,identity.registration,identity.age,identity.phone,vRP.format(parseInt(banco)),vRP.format(parseInt(mymultas)),groupv,cnh
		end
	end
end

function vRPN.nuIdentidade()
	local nplayer = vRPclient.getNearestPlayer(source,2)
	local nuser_id = vRP.getUserId(nplayer)
	if nplayer then
		local identitynu = vRP.getUserIdentity(nuser_id)

		local cnh = "Inválido"
		if identitynu.licenca == 0 then
			cnh = "Não habilitado"
		elseif identitynu.licenca == 1 then
			cnh = "Habilitado"
		elseif identitynu.licenca == 3 then
			cnh = "Cassada"
		end

		if identitynu then
			return identitynu.foto,identitynu.name,identitynu.firstname,identitynu.registration,identitynu.age,cnh
		end
	end
end

function vRPN.modifyIdentidade()
	local source = source
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	
	if user_id then
		if vRP.getInventoryItemAmount(user_id,"passaporte") >= 1 then
			local nome = vRP.prompt(source,"Qual é o nome? ( Preencha com atençao! )", "")
			if nome ~= "" then
				local sobrenome = vRP.prompt(source,"Qual é o sobrenome? ( Preencha com atençao! )", "")
				if sobrenome ~= "" then
					local idade = vRP.prompt(source,"Qual é a sua idade? ( Preencha com atençao! )", "")
					if idade ~= "" then
						local checkIdade = idade
						if idade >= "18" and idade <= "90" then

							vRP.execute("vRP/update_user_identity",{
								user_id = user_id,
								firstname = sobrenome,
								name = nome,
								age = idade,
								registration = identity.registration,
								phone = identity.phone
							})

							vRP.tryGetInventoryItem(user_id,"passaporte",1)
							TriggerClientEvent("Notify",source,"sucesso","Você foi cadastrado no sistema do governo com sucesso!.",8000)
							return true
						else
							TriggerClientEvent("Notify",source,"negado","Sua idade não pode ser menor que 18 ou maior que 90.",8000)
							return false
						end
					else
						TriggerClientEvent("Notify",source,"negado","Você precisa dizer a sua idade!",8000)
						return false
					end
				else
					TriggerClientEvent("Notify",source,"negado","Você precisa dizer o seu sobrenome!",8000)
					return false
				end
			else
				TriggerClientEvent("Notify",source,"negado","Você precisa dizer o seu nome!",8000)
				return false
			end
		else
			TriggerClientEvent("Notify",source,"negado","Você precisa de um passaporte para iniciar o cadastro na cidade.",8000)
			return false
		end
	end
end

function vRPN.getUserGroupByType(user_id,gtype)
	local user_groups = vRP.getUserGroups(user_id)
	for k,v in pairs(user_groups) do
		local kgroup = groups[k]
		if kgroup then
			if kgroup._config and kgroup._config.gtype and kgroup._config.gtype == gtype then
				return kgroup._config.title
			end
		end
	end
	return ""
end