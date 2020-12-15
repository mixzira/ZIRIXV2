local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

--[ CONEXÃO ]----------------------------------------------------------------------------------------------------------------------------

src = {}
Tunnel.bindInterface("vrp_inspect",src)
vCLIENT = Tunnel.getInterface("vrp_inspect")

--[ VARIAVEIS ]--------------------------------------------------------------------------------------------------------------------------

local opened = {}

--[ /REVISTAR ]--------------------------------------------------------------------------------------------------------------------------

RegisterCommand("revistar",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local x,y,z = vRPclient.getPosition(source)
	if user_id then
		local nplayer = vRPclient.getNearestPlayer(source,2)
		if nplayer and vRPclient.getHealth(source) >= 102 and not vRPclient.isInVehicle(source) then
			local nuser_id = vRP.getUserId(nplayer)
			local identitynu = vRP.getUserIdentity(nuser_id)
			if vRP.hasPermission(user_id,"policia.permissao") then
				vRPclient._playAnim(source,true,{{"oddjobs@shop_robbery@rob_till","loop"}},true)
				vRPclient._playAnim(nplayer,true,{{"random@arrests@busted","idle_a"}},true)
				TriggerClientEvent("cancelando",nplayer,true)
				local weapons = vRPclient.replaceWeapons(nplayer,{})
				for k,v in pairs(weapons) do
					vRP.giveInventoryItem(parseInt(nuser_id),"wbody|"..k,1)
					if parseInt(v.ammo) > 0 then
						vRP.giveInventoryItem(parseInt(nuser_id),"wammo|"..k,parseInt(v.ammo))
					end
				end
				vCLIENT.toggleCarry(nplayer,source)
				PerformHttpRequest(config.webhookInspect, function(err, text, headers) end, 'POST', json.encode({embeds = {{title = "REGISTRO DE REVISTAR:\n⠀", thumbnail = {url = config.webhookIcon}, fields = {{ name = "**QUEM ESTÁ REVISTANDO:**", value = "**"..identity.name.." "..identity.firstname.."** [**"..user_id.."**]"}, { name = "**QUEM ESTÁ SENDO REVISTADO:**", value = "**"..identitynu.name.." "..identitynu.firstname.."** [**"..nuser_id.."**]\n⠀⠀"}, { name = "**LOCAL: "..tD(x)..", "..tD(y)..", "..tD(z).."**", value = "⠀" }}, footer = { text = config.webhookBottom..os.date("%d/%m/%Y | %H:%M:%S"), icon_url = config.webhookIcon}, color = config.webhookColor}}}), { ['Content-Type'] = 'application/json' })
				opened[parseInt(user_id)] = parseInt(nuser_id)
				vCLIENT.openInspect(source)
			else
				local policia = vRP.getUsersByPermission("policia.permissao")
				if #policia >= 2 then
					local h = vCLIENT.entityHeading(source)
					if vRPclient.getHealth(nplayer) >= 102 then
						local request = vRP.request(nplayer,"Solicitação de revista! Deseja cooperar?",60)
						if request then
							vRPclient._playAnim(source,true,{"oddjobs@shop_robbery@rob_till","loop"},true)
							vRPclient._playAnim(nplayer,true,{"random@arrests@busted","idle_a"},true)
							TriggerClientEvent("cancelando",nplayer,true)
							local weapons = vRPclient.replaceWeapons(nplayer,{})
							for k,v in pairs(weapons) do
								vRP.giveInventoryItem(parseInt(nuser_id),"wbody|"..k,1)
								if parseInt(v.ammo) > 0 then
									vRP.giveInventoryItem(parseInt(nuser_id),"wammo|"..k,parseInt(v.ammo))
								end
							end
							vCLIENT.toggleCarry(nplayer,source)
							PerformHttpRequest(config.webhookInspect, function(err, text, headers) end, 'POST', json.encode({embeds = {{title = "REGISTRO DE REVISTAR:\n⠀", thumbnail = {url = config.webhookIcon}, fields = {{ name = "**QUEM ESTÁ REVISTANDO:**", value = "**"..identity.name.." "..identity.firstname.."** [**"..user_id.."**]"}, { name = "**QUEM ESTÁ SENDO REVISTADO:**", value = "**"..identitynu.name.." "..identitynu.firstname.."** [**"..nuser_id.."**]\n⠀⠀"}, { name = "**LOCAL: "..tD(x)..", "..tD(y)..", "..tD(z).."**", value = "⠀" }}, footer = { text = config.webhookBottom..os.date("%d/%m/%Y | %H:%M:%S"), icon_url = config.webhookIcon}, color = config.webhookColor}}}), { ['Content-Type'] = 'application/json' })
							opened[parseInt(user_id)] = parseInt(nuser_id)
							vCLIENT.openInspect(source)
						else
							TriggerClientEvent("Notify",source,"negado","Revista negada! A pessoa não quer cooperar.",5000)
						end
					end
				else
					TriggerClientEvent("Notify",source,"negado","Você não pode fazer isso nesse momento.",5000)
				end
			end
		end
	end
end)

RegisterCommand("saquear",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local x,y,z = vRPclient.getPosition(source)
	if user_id then
		local nplayer = vRPclient.getNearestPlayer(source,2)
		if nplayer and vRPclient.getHealth(source) >= 102 and not vRPclient.isInVehicle(source) then
			local nuser_id = vRP.getUserId(nplayer)
			local identitynu = vRP.getUserIdentity(nuser_id)

			if vRPclient.getHealth(nplayer) <= 102 then
				local policia = vRP.getUsersByPermission("policia.permissao")
				if #policia >= 0 then
					TriggerClientEvent("cancelando",nplayer,true)
					local weapons = vRPclient.replaceWeapons(nplayer,{})
					for k,v in pairs(weapons) do
						vRP.giveInventoryItem(parseInt(nuser_id),"wbody|"..k,1)
						if parseInt(v.ammo) > 0 then
							vRP.giveInventoryItem(parseInt(nuser_id),"wammo|"..k,parseInt(v.ammo))
						end
					end

					PerformHttpRequest(logSaquear, function(err, text, headers) end, 'POST', json.encode({
						embeds = {
							{ 	------------------------------------------------------------
								title = "REGISTRO DE SAQUEAR:⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n⠀",
								thumbnail = {
								url = "https://i.imgur.com/5ydYKZg.png"
								}, 
								fields = {
									{ 
										name = "**QUEM ESTÁ SAQUEANDO:**", 
										value = "**"..identity.name.." "..identity.firstname.."** [**"..user_id.."**]"
									},
									{ 
										name = "**QUEM ESTÁ SENDO SAQUEADO:**", 
										value = "**"..identitynu.name.." "..identitynu.firstname.."** [**"..nuser_id.."**]\n⠀⠀"
									},
									{ 
										name = "**LOCAL: "..tD(x)..", "..tD(y)..", "..tD(z).."**",
										value = "⠀"
									}
								}, 
								footer = { 
									text = "ZIRIX - "..os.date("%d/%m/%Y | %H:%M:%S"), 
									icon_url = "https://i.imgur.com/5ydYKZg.png" 
								},
								color = 16431885 
							}
						}
					}), { ['Content-Type'] = 'application/json' })

					opened[parseInt(user_id)] = parseInt(nuser_id)
					vCLIENT.openInspect(source)
				else
					TriggerClientEvent("Notify",source,"negado","Você não pode fazer isso nesse momento.",5000)
				end
			else
				TriggerClientEvent("Notify",source,"negado","Essa pessoa não está em coma.",5000)
			end
		else
			TriggerClientEvent("Notify",source,"negado","Não players por perto.",5000)
		end
	end
end)

--[ ABRIR INVENTÁRIOS ]------------------------------------------------------------------------------------------------------------------

function src.openChest()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local ninventory = {}
		local uinventory = {}

		local inv = vRP.getInventory(parseInt(opened[user_id]))
		if inv then
			for k,v in pairs(inv) do
				if vRP.itemBodyList(k) then
					table.insert(ninventory,{ amount = parseInt(v.amount), name = vRP.itemNameList(k), index = vRP.itemIndexList(k), key = k, peso = vRP.getItemWeight(k) })
				end
			end
		end

		local inv2 = vRP.getInventory(parseInt(user_id))
		if inv2 then
			for k,v in pairs(inv2) do
				if vRP.itemBodyList(k) then
					table.insert(uinventory,{ amount = parseInt(v.amount), name = vRP.itemNameList(k), index = vRP.itemIndexList(k), key = k, peso = vRP.getItemWeight(k) })
				end
			end
		end

		return ninventory,uinventory,vRP.getInventoryWeight(parseInt(user_id)),vRP.getInventoryMaxWeight(parseInt(user_id)),vRP.getInventoryWeight(parseInt(opened[user_id])),vRP.getInventoryMaxWeight(parseInt(opened[user_id]))
	end
end

--[ ENVIAR ITENS ]-----------------------------------------------------------------------------------------------------------------------

function src.storeItem(itemName,amount)
	local source = source
	if itemName then

		if itemName == "passaporte" then
			TriggerClientEvent("Notify",source,"negado","Você não pode <b>enviar</b> seu <b>passaporte</b>.",5000)
		else
			local user_id = vRP.getUserId(source)
			local nsource = vRP.getUserSource(parseInt(opened[user_id]))
			local identity = vRP.getUserIdentity(user_id)
			local nuser_id = vRP.getUserId(nsource)
			local identitynu = vRP.getUserIdentity(nuser_id)
			local x,y,z = vRPclient.getPosition(source)

			if user_id and nsource then
				if parseInt(amount) > 0 then
					if vRP.getInventoryWeight(parseInt(opened[user_id]))+vRP.getItemWeight(itemName)*parseInt(amount) <= vRP.getInventoryMaxWeight(parseInt(opened[user_id])) then
						if vRP.tryGetInventoryItem(parseInt(user_id),itemName,parseInt(amount)) then
							vRP.giveInventoryItem(parseInt(opened[user_id]),itemName,parseInt(amount))

							PerformHttpRequest(logEnviar, function(err, text, headers) end, 'POST', json.encode({
								embeds = {
									{ 	------------------------------------------------------------
										title = "REGISTRO DE ITEM ENVIADO VIA REVISTAR/SAQUEAR:⠀\n⠀",
										thumbnail = {
										url = "https://i.imgur.com/5ydYKZg.png"
										}, 
										fields = {
											{ 
												name = "**QUEM ENVIOU:**", 
												value = "**"..identity.name.." "..identity.firstname.."** [**"..user_id.."**]"
											},
											{ 
												name = "**ITEM ENVIADO:**", 
												value = "[ **Item: "..itemName.."** ][ **Quantidade: "..vRP.format(parseInt(amount)).."** ]"
											},
											{ 
												name = "**QUEM RECEBEU:**", 
												value = "**"..identitynu.name.." "..identitynu.firstname.."** [**"..nuser_id.."**]\n⠀⠀"
											},
											{ 
												name = "**LOCAL: "..tD(x)..", "..tD(y)..", "..tD(z).."**",
												value = "⠀"
											}
										}, 
										footer = { 
											text = "ZIRIX - "..os.date("%d/%m/%Y | %H:%M:%S"), 
											icon_url = "https://i.imgur.com/5ydYKZg.png" 
										},
										color = 16431885 
									}
								}
							}), { ['Content-Type'] = 'application/json' })

							TriggerClientEvent("vrp_inspect:Update",source,"updateChest")
						end
					else
						TriggerClientEvent("Notify",source,"negado","Sua <b>mochila</b> está cheia.",5000)
					end
				else
					local inv = vRP.getInventory(parseInt(user_id))
					if inv and inv[itemName] ~= nil then
						if vRP.getInventoryWeight(parseInt(opened[user_id]))+vRP.getItemWeight(itemName)*parseInt(inv[itemName].amount) <= vRP.getInventoryMaxWeight(parseInt(opened[user_id])) then
							if vRP.tryGetInventoryItem(parseInt(user_id),itemName,parseInt(inv[itemName].amount)) then
								vRP.giveInventoryItem(parseInt(opened[user_id]),itemName,parseInt(inv[itemName].amount))

								PerformHttpRequest(logEnviar, function(err, text, headers) end, 'POST', json.encode({
									embeds = {
										{ 	------------------------------------------------------------
											title = "REGISTRO DE ITEM ENVIADO VIA REVISTAR/SAQUEAR:⠀\n⠀",
											thumbnail = {
											url = "https://i.imgur.com/5ydYKZg.png"
											}, 
											fields = {
												{ 
													name = "**QUEM ENVIOU:**", 
													value = "**"..identity.name.." "..identity.firstname.."** [**"..user_id.."**]"
												},
												{ 
													name = "**ITEM ENVIADO:**", 
													value = "[ **Item: "..itemName.."** ][ **Quantidade: "..vRP.format(parseInt(inv[itemName].amount)).."** ]"
												},
												{ 
													name = "**QUEM RECEBEU:**", 
													value = "**"..identitynu.name.." "..identitynu.firstname.."** [**"..nuser_id.."**]\n⠀⠀"
												},
												{ 
													name = "**LOCAL: "..tD(x)..", "..tD(y)..", "..tD(z).."**",
													value = "⠀"
												}
											}, 
											footer = { 
												text = "ZIRIX - "..os.date("%d/%m/%Y | %H:%M:%S"), 
												icon_url = "https://i.imgur.com/5ydYKZg.png" 
											},
											color = 16431885 
										}
									}
								}), { ['Content-Type'] = 'application/json' })

								TriggerClientEvent("vrp_inspect:Update",source,"updateChest")
							end
						else
							TriggerClientEvent("Notify",source,"negado","Sua <b>mochila</b> está cheia.",5000)
						end
					end
				end
			end
		end
	end
	return false
end

--[ PEGAR ITENS ]------------------------------------------------------------------------------------------------------------------------

function src.takeItem(itemName,amount)
	local source = source
	if itemName then

		if itemName == "passaporte" then
			TriggerClientEvent("Notify",source,"negado","Você não pode <b>enviar</b> seu <b>passaporte</b>.",5000)
		else
			local user_id = vRP.getUserId(source)
			local nsource = vRP.getUserSource(parseInt(opened[user_id]))
			local identity = vRP.getUserIdentity(user_id)
			local nuser_id = vRP.getUserId(nsource)
			local identitynu = vRP.getUserIdentity(nuser_id)
			local x,y,z = vRPclient.getPosition(source)

			if user_id and nsource then
				if parseInt(amount) > 0 then
					if vRP.getInventoryWeight(parseInt(user_id))+vRP.getItemWeight(itemName)*parseInt(amount) <= vRP.getInventoryMaxWeight(parseInt(user_id)) then
						if vRP.tryGetInventoryItem(parseInt(opened[user_id]),itemName,parseInt(amount)) then
							vRP.giveInventoryItem(parseInt(user_id),itemName,parseInt(amount))

							PerformHttpRequest(logPegar, function(err, text, headers) end, 'POST', json.encode({
								embeds = {
									{ 	------------------------------------------------------------
										title = "REGISTRO DE ITEM PEGADO VIA REVISTAR/SAQUEAR:⠀⠀\n⠀",
										thumbnail = {
										url = "https://i.imgur.com/5ydYKZg.png"
										}, 
										fields = {
											{ 
												name = "**QUEM ENVIOU:**", 
												value = "**"..identity.name.." "..identity.firstname.."** [**"..user_id.."**]"
											},
											{ 
												name = "**ITEM ENVIADO:**", 
												value = "[ **Item: "..itemName.."** ][ **Quantidade: "..vRP.format(parseInt(amount)).."** ]"
											},
											{ 
												name = "**QUEM RECEBEU:**", 
												value = "**"..identitynu.name.." "..identitynu.firstname.."** [**"..nuser_id.."**]\n⠀⠀"
											},
											{ 
												name = "**LOCAL: "..tD(x)..", "..tD(y)..", "..tD(z).."**",
												value = "⠀"
											}
										}, 
										footer = { 
											text = "ZIRIX - "..os.date("%d/%m/%Y | %H:%M:%S"), 
											icon_url = "https://i.imgur.com/5ydYKZg.png" 
										},
										color = 16431885 
									}
								}
							}), { ['Content-Type'] = 'application/json' })

							TriggerClientEvent("vrp_inspect:Update",source,"updateChest")
						end
					else
						TriggerClientEvent("Notify",source,"negado","The <b>backpack</b> is full.",5000)
					end
				else
					local inv = vRP.getInventory(parseInt(opened[user_id]))
					if inv and inv[itemName] ~= nil then
						if vRP.getInventoryWeight(parseInt(user_id))+vRP.getItemWeight(itemName)*parseInt(inv[itemName].amount) <= vRP.getInventoryMaxWeight(parseInt(user_id)) then
							if vRP.tryGetInventoryItem(parseInt(opened[user_id]),itemName,parseInt(inv[itemName].amount)) then
								vRP.giveInventoryItem(parseInt(user_id),itemName,parseInt(inv[itemName].amount))

								PerformHttpRequest(logPegar, function(err, text, headers) end, 'POST', json.encode({
									embeds = {
										{ 	------------------------------------------------------------
											title = "REGISTRO DE ITEM PEGADO VIA REVISTAR/SAQUEAR:⠀⠀\n⠀",
											thumbnail = {
											url = "https://i.imgur.com/5ydYKZg.png"
											}, 
											fields = {
												{ 
													name = "**QUEM ENVIOU:**", 
													value = "**"..identity.name.." "..identity.firstname.."** [**"..user_id.."**]"
												},
												{ 
													name = "**ITEM ENVIADO:**", 
													value = "[ **Item: "..itemName.."** ][ **Quantidade: "..vRP.format(parseInt(inv[itemName].amount)).."** ]"
												},
												{ 
													name = "**QUEM RECEBEU:**", 
													value = "**"..identitynu.name.." "..identitynu.firstname.."** [**"..nuser_id.."**]\n⠀⠀"
												},
												{ 
													name = "**LOCAL: "..tD(x)..", "..tD(y)..", "..tD(z).."**",
													value = "⠀"
												}
											}, 
											footer = { 
												text = "ZIRIX - "..os.date("%d/%m/%Y | %H:%M:%S"), 
												icon_url = "https://i.imgur.com/5ydYKZg.png" 
											},
											color = 16431885 
										}
									}
								}), { ['Content-Type'] = 'application/json' })

								TriggerClientEvent("vrp_inspect:Update",source,"updateChest")
							end
						else
							TriggerClientEvent("Notify",source,"negado","The <b>backpack</b> is full.",5000)
						end
					end
				end
			end
		end
	end
end

--[ FINALIZAR REVISTA ]------------------------------------------------------------------------------------------------------------------

function src.resetInspect()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id and opened[parseInt(user_id)] then
		local nplayer = vRP.getUserSource(parseInt(opened[parseInt(user_id)]))
		if nplayer then
			TriggerClientEvent("cancelando",nplayer,false)
		end

		opened[parseInt(user_id)] = nil
		vRPclient._stopAnim(source,false)
	end
end

function tD(n)
    n = math.ceil(n * 100) / 100
    return n
end