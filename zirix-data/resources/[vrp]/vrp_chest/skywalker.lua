local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

--[ CONEXÃO ]-----------------------------------------------------------------------------------------------------------------------------------------------------------

src = {}
Tunnel.bindInterface("vrp_chest",src)
vCLIENT = Tunnel.getInterface("vrp_chest")

--[ VARIAVEIS ]---------------------------------------------------------------------------------------------------------------------------------------------------------

local logBauDmla = ""
local logDplaArsenal = ""
local logDplaEvidencias = ""

--[ CHEST ]-------------------------------------------------------------------------------------------------------------------------------------------------------------

local chest = {
	["ems"] = { 5000,"ems.permissao" },
	["policia-arsenal"] = { 5000,"policia.permissao" },
	["policia-evidencias"] = { 5000,"policia.permissao" },
}

--[ VARIÁVEIS ]---------------------------------------------------------------------------------------------------------------------------------------------------------

local actived = {}

--[ ACTIVEDOWNTIME ]----------------------------------------------------------------------------------------------------------------------------------------------------

local actived = {}
Citizen.CreateThread(function()
	while true do
		for k,v in pairs(actived) do
			if actived[k] > 0 then
				actived[k] = v - 1
				if actived[k] <= 0 then
					actived[k] = nil
				end
			end
		end
		Citizen.Wait(100)
	end
end)

--[ CHECKINTPERMISSIONS ]-----------------------------------------------------------------------------------------------------------------------------------------------

function src.checkIntPermissions(chestName)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if not vRP.searchReturn(source,user_id) then
			if vRP.hasPermission(user_id,"policia.permissao") then
				return true
			end

			if vRP.hasPermission(user_id,chest[chestName][2]) then
				return true
			end
		end
	end
	return false
end

--[ OPENCHEST ]---------------------------------------------------------------------------------------------------------------------------------------------------------

function src.openChest(chestName)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local hsinventory = {}
		local myinventory = {}
		local data = vRP.getSData("chest:"..tostring(chestName))
		local result = json.decode(data) or {}
		if result then
			for k,v in pairs(result) do
				if vRP.itemBodyList(k) then
					table.insert(hsinventory,{ amount = parseInt(v.amount), name = vRP.itemNameList(k), index = vRP.itemIndexList(k), key = k, peso = vRP.getItemWeight(k) })
				end
			end

			local inv = vRP.getInventory(parseInt(user_id))
			for k,v in pairs(inv) do
				if vRP.itemBodyList(k) then
					table.insert(myinventory,{ amount = parseInt(v.amount), name = vRP.itemNameList(k), index = vRP.itemIndexList(k), key = k, peso = vRP.getItemWeight(k) })
				end
			end
		end
		return hsinventory,myinventory,vRP.getInventoryWeight(user_id),vRP.getInventoryMaxWeight(user_id),vRP.computeItemsWeight(result),parseInt(chest[tostring(chestName)][1])
	end
	return false
end

--[ STOREITEM ]---------------------------------------------------------------------------------------------------------------------------------------------------------

function src.storeItem(chestName,itemName,amount)
    if itemName then
        local source = source
        local user_id = vRP.getUserId(source)
        if user_id then
			if vRP.storeChestItem(user_id,"chest:"..tostring(chestName),itemName,amount,chest[tostring(chestName)][1]) then
				local identity = vRP.getUserIdentity(user_id)
				if identity then
					if chestName == "dmla" then
						PerformHttpRequest(logBauDmla, function(err, text, headers) end, 'POST', json.encode({
							embeds = {
								{ 	------------------------------------------------------------
									title = "REGISTRO DE BAÚ MÉDICO:⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n⠀",
									thumbnail = {
									url = "https://i.imgur.com/5ydYKZg.png"
									}, 
									fields = {
										{ 
											name = "**QUEM GUARDOU:**", 
											value = "**"..identity.name.." "..identity.firstname.."** [**"..user_id.."**]"
										},
										{ 
											name = "**ITEM GUARDADO:**", 
											value = "[ **Item: "..vRP.itemNameList(itemName).."** ][ **Quantidade: "..parseInt(amount).."** ]\n⠀⠀"
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
					elseif chestName == "dpla-arsenal" then
						PerformHttpRequest(logDplaArsenal, function(err, text, headers) end, 'POST', json.encode({
							embeds = {
								{ 	------------------------------------------------------------
									title = "REGISTRO DE ARSENAL:⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n⠀",
									thumbnail = {
									url = "https://i.imgur.com/5ydYKZg.png"
									}, 
									fields = {
										{ 
											name = "**QUEM GUARDOU:**", 
											value = "**"..identity.name.." "..identity.firstname.."** [**"..user_id.."**]"
										},
										{ 
											name = "**ITEM GUARDADO:**", 
											value = "[ **Item: "..vRP.itemNameList(itemName).."** ][ **Quantidade: "..parseInt(amount).."** ]\n⠀⠀"
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
					elseif chestName == "dpla-evicencias" then
						PerformHttpRequest(logDplaEvidencias, function(err, text, headers) end, 'POST', json.encode({
							embeds = {
								{ 	------------------------------------------------------------
									title = "REGISTRO DE EVIDENCIAS:⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n⠀",
									thumbnail = {
									url = "https://i.imgur.com/5ydYKZg.png"
									}, 
									fields = {
										{ 
											name = "**QUEM GUARDOU:**", 
											value = "**"..identity.name.." "..identity.firstname.."** [**"..user_id.."**]"
										},
										{ 
											name = "**ITEM GUARDADO:**", 
											value = "[ **Item: "..vRP.itemNameList(itemName).."** ][ **Quantidade: "..parseInt(amount).."** ]\n⠀⠀"
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
					end
				end
				TriggerClientEvent("Chest:UpdateChest",source,"updateChest")
			else
				TriggerClientEvent("Notify",source,"negado","Você precisa especificar a quantidade.",10000)
            end
        end
    end
end

--[ TAKEITEM ]----------------------------------------------------------------------------------------------------------------------------------------------------------

function src.takeItem(chestName,itemName,amount)
    if itemName then
        local source = source
        local user_id = vRP.getUserId(source)
        if user_id then
			if vRP.tryChestItem(user_id,"chest:"..tostring(chestName),itemName,amount) then
				local identity = vRP.getUserIdentity(user_id)
				if identity then
					if chestName == "dmla" then
						PerformHttpRequest(logBauDmla, function(err, text, headers) end, 'POST', json.encode({
							embeds = {
								{ 	------------------------------------------------------------
									title = "REGISTRO DE BAÚ MÉDICO:⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n⠀",
									thumbnail = {
									url = "https://i.imgur.com/5ydYKZg.png"
									}, 
									fields = {
										{ 
											name = "**QUEM RETIROU:**", 
											value = "**"..identity.name.." "..identity.firstname.."** [**"..user_id.."**]"
										},
										{ 
											name = "**ITEM RETIRADO:**", 
											value = "[ **Item: "..vRP.itemNameList(itemName).."** ][ **Quantidade: "..parseInt(amount).."** ]\n⠀⠀"
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
					elseif chestName == "dpla-arsenal" then
						PerformHttpRequest(logDplaArsenal, function(err, text, headers) end, 'POST', json.encode({
							embeds = {
								{ 	------------------------------------------------------------
									title = "REGISTRO DE ARSENAL:⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n⠀",
									thumbnail = {
									url = "https://i.imgur.com/5ydYKZg.png"
									}, 
									fields = {
										{ 
											name = "**QUEM RETIROU:**", 
											value = "**"..identity.name.." "..identity.firstname.."** [**"..user_id.."**]"
										},
										{ 
											name = "**ITEM RETIRADO:**", 
											value = "[ **Item: "..vRP.itemNameList(itemName).."** ][ **Quantidade: "..parseInt(amount).."** ]\n⠀⠀"
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
					elseif chestName == "dpla-evicencias" then
						PerformHttpRequest(logDplaEvidencias, function(err, text, headers) end, 'POST', json.encode({
							embeds = {
								{ 	------------------------------------------------------------
									title = "REGISTRO DE EVIDENCIAS:⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n⠀",
									thumbnail = {
									url = "https://i.imgur.com/5ydYKZg.png"
									}, 
									fields = {
										{ 
											name = "**QUEM RETIROU:**", 
											value = "**"..identity.name.." "..identity.firstname.."** [**"..user_id.."**]"
										},
										{ 
											name = "**ITEM RETIRADO:**", 
											value = "[ **Item: "..vRP.itemNameList(itemName).."** ][ **Quantidade: "..parseInt(amount).."** ]\n⠀⠀"
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
					end
				end
				TriggerClientEvent("Chest:UpdateChest",source,"updateChest")
			else
				TriggerClientEvent("Notify",source,"negado","Você precisa especificar a quantidade.",10000)
            end
        end
    end
end