local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

--[ CONNECTION ]----------------------------------------------------------------------------------------------------------------

emp = {}
Tunnel.bindInterface("emp_minerador",emp)

--[ VARIABLES ]-----------------------------------------------------------------------------------------------------------------

local ammount = {}
local percentage = 0
local itemName = ""

--[ RANDOM AMMOUNT | FUNCTION ]-------------------------------------------------------------------------------------------------

function emp.ammount()
	local source = source
	if ammount[source] == nil then
		ammount[source] = math.random(1,4)
	end
end

--[ CHECK WEIGHT | FUNCTION ]---------------------------------------------------------------------------------------------------

function emp.checkWeight()
	emp.ammount()

	local source = source
	local user_id = vRP.getUserId(source)

	if user_id then
		percentage = math.random(100)
		if percentage <= 30 then
			itemName = "minerio-ferro"
		elseif percentage >= 31 and percentage <= 69 then
			itemName = "minerio-prata"
		elseif percentage >= 70 and percentage <= 89 then
			itemName = "minerio-ouro"
		elseif percentage >= 90 then
			itemName = "minerio-diamante"
		end
		return vRP.getInventoryWeight(user_id)+vRP.getItemWeight(itemName)*ammount[source] <= vRP.getInventoryMaxWeight(user_id)
	end
end

--[ COLLECT | FUNCTION ]--------------------------------------------------------------------------------------------------------

function emp.collectOres()
	local source = source
	local user_id = vRP.getUserId(source)

	if user_id then
		vRP.giveInventoryItem(user_id,itemName,ammount[source])
		TriggerClientEvent("Notify",source,"sucesso","Encontrou <b>"..ammount[source].."x "..vRP.itemNameList(itemName).."</b>.",8000)
		ammount[source] = nil
	end
end