local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local Tools = module("vrp","lib/Tools")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

emP = {}
Tunnel.bindInterface("nav_uniforme-mecanico",emP)

--[ ROUPAS ]-----------------------------------------------------------------------------------------------------------------------------


local mecanico = {
    [1885233650] = {
        [1] = { -1,0 },
        [2] = { 19,0 },
        [3] = { 1,0 },
        [4] = { 39,0 },
        [5] = { -1,0 },
        [6] = { 54,0 },
        [7] = { -1,0 },			
        [8] = { 15,0 },
        [9] = { -1,0 },
        [10] = { -1,0 },
        [11] = { 66,0 },
        ["p0"] = { -1,0 },
        ["p1"] = { -1,0 },
        ["p2"] = { -1,0 },
        ["p6"] = { 1,0 },
        ["p7"] = { -1,0 }
    },
    [-1667301416] = {
        [1] = { -1,0 },
        [2] = { 19,0 },
        [3] = { 3,0 },
        [4] = { 39,0 },
        [5] = { -1,0 },
        [6] = { 55,0 },
        [7] = { -1,0 },		
        [8] = { 34,0 },
        [9] = { -1,0 },
        [10] = { -1,0 },
        [11] = { 60,0 },			
        ["p0"] = { -1,0 },
        ["p1"] = { -1,0 },
        ["p2"] = { -1,0 },
        ["p6"] = { -1,0 },
        ["p7"] = { -1,0 }
    }
}

RegisterServerEvent("colocar-uniforme")
AddEventHandler("colocar-uniforme",function()
    local user_id = vRP.getUserId(source)
    local custom = mecanico
    if custom then
        local old_custom = vRPclient.getCustomization(source)
        local idle_copy = {}

        idle_copy = vRP.save_idle_custom(source,old_custom)
        idle_copy.modelhash = nil

        for l,w in pairs(custom[old_custom.modelhash]) do
            idle_copy[l] = w
        end
        vRPclient._setCustomization(source,idle_copy)
    end
end)

RegisterServerEvent("tirar-uniforme")
AddEventHandler("tirar-uniforme",function()
    vRP.removeCloak(source)
end)

function emP.checkPermissao()
	local source = source
	local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"mecanico.permissao") or vRP.hasPermission(user_id,"paisana-mecanico.permissao") then
        return true
	end
end