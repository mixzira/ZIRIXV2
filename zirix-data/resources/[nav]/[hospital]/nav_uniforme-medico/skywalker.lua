local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local Tools = module("vrp","lib/Tools")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

Resg = {}
Tunnel.bindInterface("nav_uniforme-medico",Resg)

--[ ROUPAS ]-----------------------------------------------------------------------------------------------------------------------------


local diretorgeral = {
    [1885233650] = {
        [1] = { -1,0 },
        [2] = { 21,0 },
        [3] = { 4,0 },
        [4] = { 24,0 },
        [5] = { -1,0 },
        [6] = { 10,0 },
        [7] = { 126,0 },			
        [8] = { 31,0 },
        [9] = { -1,0 },
        [10] = { -1,0 },
        [11] = { 29,0 },
        ["p0"] = { -1,0 },
        ["p1"] = { -1,0 },
        ["p2"] = { -1,0 },
        ["p6"] = { 1,0 },
        ["p7"] = { -1,0 }
    },
    [-1667301416] = {
        [1] = { -1,0 },
        [2] = { 6,0 },
        [3] = { 5,0 },
        [4] = { 7,0 },
        [5] = { -1,0 },
        [6] = { 6,0 },
        [7] = { 96,0 },			
        [8] = { 95,0 },
        [9] = { -1,0 },
        [10] = { -1,0 },
        [11] = { 57,0 },			
        ["p0"] = { -1,0 },
        ["p1"] = { -1,0 },
        ["p2"] = { -1,0 },
        ["p6"] = { -1,0 },
        ["p7"] = { -1,0 }
    }
}

local diretorauxiliar = {
    [1885233650] = {
        [1] = { -1,0 },
        [2] = { 21,0 },
        [3] = { 4,0 },
        [4] = { 24,0 },
        [5] = { -1,0 },
        [6] = { 10,0 },
        [7] = { 126,0 },			
        [8] = { 31,0 },
        [9] = { -1,0 },
        [10] = { -1,0 },
        [11] = { 29,0 },
        ["p0"] = { -1,0 },
        ["p1"] = { -1,0 },
        ["p2"] = { -1,0 },
        ["p6"] = { 1,0 },
        ["p7"] = { -1,0 }
    },
    [-1667301416] = {
        [1] = { -1,0 },
        [2] = { 6,0 },
        [3] = { 5,0 },
        [4] = { 7,0 },
        [5] = { -1,0 },
        [6] = { 6,0 },
        [7] = { 96,0 },			
        [8] = { 95,0 },
        [9] = { -1,0 },
        [10] = { -1,0 },
        [11] = { 57,0 },			
        ["p0"] = { -1,0 },
        ["p1"] = { -1,0 },
        ["p2"] = { -1,0 },
        ["p6"] = { -1,0 },
        ["p7"] = { -1,0 }
    }
}

local medicochefe = {
    [1885233650] = {
        [1] = { -1,0 },
        [2] = { 21,0 },
        [3] = { 77,0 },
        [4] = { 20,0 },
        [5] = { -1,0 },
        [6] = { 7,0 },
        [7] = { 127,0 },			
        [8] = { 31,0 },
        [9] = { -1,0 },
        [10] = { -1,0 },
        [11] = { 192,0 },
        ["p0"] = { -1,0 },
        ["p1"] = { -1,0 },
        ["p2"] = { -1,0 },
        ["p6"] = { 1,0 },
        ["p7"] = { -1,0 }
    },
    [-1667301416] = {
        [1] = { -1,0 },
        [2] = { 6,0 },
        [3] = { 3,0 },
        [4] = { 23,0 },
        [5] = { -1,0 },
        [6] = { 19.3,0 },
        [7] = { 97,0 },			
        [8] = { 38,0 },
        [9] = { -1,0 },
        [10] = { -1,0 },
        [11] = { 139.2,0 },			
        ["p0"] = { -1,0 },
        ["p1"] = { -1,0 },
        ["p2"] = { -1,0 },
        ["p6"] = { -1,0 },
        ["p7"] = { -1,0 }
    }
}

local medicoauxiliar = {
    [1885233650] = {
        [1] = { -1,0 },
        [2] = { 21,0 },
        [3] = { 77,0 },
        [4] = { 20,0 },
        [5] = { -1,0 },
        [6] = { 7,0 },
        [7] = { 127,0 },			
        [8] = { 31,0 },
        [9] = { -1,0 },
        [10] = { -1,0 },
        [11] = { 192,0 },
        ["p0"] = { -1,0 },
        ["p1"] = { -1,0 },
        ["p2"] = { -1,0 },
        ["p6"] = { 1,0 },
        ["p7"] = { -1,0 }
    },
    [-1667301416] = {
        [1] = { -1,0 },
        [2] = { 6,0 },
        [3] = { 3,0 },
        [4] = { 23,0 },
        [5] = { -1,0 },
        [6] = { 19.3,0 },
        [7] = { 97,0 },			
        [8] = { 38,0 },
        [9] = { -1,0 },
        [10] = { -1,0 },
        [11] = { 139,2 },			
        ["p0"] = { -1,0 },
        ["p1"] = { -1,0 },
        ["p2"] = { -1,0 },
        ["p6"] = { -1,0 },
        ["p7"] = { -1,0 }
    }
}

local cirurgiao = {
    [1885233650] = {
        [1] = { -1,0 },
        [2] = { 21,0 },
        [3] = { 77,0 },
        [4] = { 20,0 },
        [5] = { -1,0 },
        [6] = { 7,0 },
        [7] = { 126,0 },			
        [8] = { 21,4 },
        [9] = { -1,0 },
        [10] = { -1,0 },
        [11] = { 187,4 },
        ["p0"] = { -1,0 },
        ["p1"] = { -1,0 },
        ["p2"] = { -1,0 },
        ["p6"] = { -1,0 },
        ["p7"] = { -1,0 }
    },
    [-1667301416] = {
        [1] = { -1,0 },
        [2] = { 6,0 },
        [3] = { 5,0 },
        [4] = { 23,0 },
        [5] = { -1,0 },
        [6] = { 19,7 },
        [7] = { 96,0 },			
        [8] = { 7,0 },
        [9] = { -1,0 },
        [10] = { -1,0 },
        [11] = { 189,4 },			
        ["p0"] = { -1,0 },
        ["p1"] = { -1,0 },
        ["p2"] = { -1,0 },
        ["p6"] = { -1,0 },
        ["p7"] = { -1,0 }
    }
}

local medico = {
    [1885233650] = {
        [1] = { -1,0 },
        [2] = { 21,0 },
        [3] = { 77,0 },
        [4] = { 20,0 },
        [5] = { -1,0 },
        [6] = { 7,0 },
        [7] = { 126,0 },			
        [8] = { 21,4 },
        [9] = { -1,0 },
        [10] = { -1,0 },
        [11] = { 29,7 },
        ["p0"] = { -1,0 },
        ["p1"] = { -1,0 },
        ["p2"] = { -1,0 },
        ["p6"] = { -1,0 },
        ["p7"] = { -1,0 }
    },
    [-1667301416] = {
        [1] = { -1,0 },
        [2] = { 6,0 },
        [3] = { 88,0 },
        [4] = { 23,0 },
        [5] = { -1,0 },
        [6] = { 6,2 },
        [7] = { 97,0 },			
        [8] = { 72,0 },
        [9] = { -1,0 },
        [10] = { -1,0 },
        [11] = { 7,1 },			
        ["p0"] = { -1,0 },
        ["p1"] = { -1,0 },
        ["p2"] = { -1,0 },
        ["p6"] = { -1,0 },
        ["p7"] = { -1,0 }
    }
}

local enfermeiro = {
    [1885233650] = {
        [1] = { -1,0 },
        [2] = { 21,0 },
        [3] = { 74,0 },
        [4] = { 20,0 },
        [5] = { -1,0 },
        [6] = { 7,0 },
        [7] = { 126,0 },			
        [8] = { 15,0 },
        [9] = { -1,0 },
        [10] = { -1,0 },
        [11] = { 146,0 },
        ["p0"] = { -1,0 },
        ["p1"] = { -1,0 },
        ["p2"] = { -1,0 },
        ["p6"] = { 1,0 },
        ["p7"] = { -1,0 }
    },
    [-1667301416] = {
        [1] = { -1,0 },
        [2] = { 6,0 },
        [3] = { 96,0 },
        [4] = { 23,1 },
        [5] = { -1,0 },
        [6] = { 19,0 },
        [7] = { 96,0 },			
        [8] = { 7,0 },
        [9] = { -1,0 },
        [10] = { -1,0 },
        [11] = { 73,0 },			
        ["p0"] = { -1,0 },
        ["p1"] = { -1,0 },
        ["p2"] = { -1,0 },
        ["p6"] = { -1,0 },
        ["p7"] = { -1,0 }
    }
}

local estagiario = {
    [1885233650] = {
        [1] = { -1,0 },
        [2] = { 21,0 },
        [3] = { 85,0 },
        [4] = { 20,0 },
        [5] = { -1,0 },
        [6] = { 7,0 },
        [7] = { 127,0 },			
        [8] = { 15,0 },
        [9] = { -1,0 },
        [10] = { -1,0 },
        [11] = { 271,0 },
        ["p0"] = { -1,0 },
        ["p1"] = { -1,0 },
        ["p2"] = { -1,0 },
        ["p6"] = { 1,0 },
        ["p7"] = { -1,0 }
    },
    [-1667301416] = {
        [1] = { -1,0 },
        [2] = { 6,0 },
        [3] = { 98,0 },
        [4] = { 23,0 },
        [5] = { -1,0 },
        [6] = { 19,7 },
        [7] = { 97,0 },			
        [8] = { 7,0 },
        [9] = { -1,0 },
        [10] = { -1,0 },
        [11] = { 280,0 },			
        ["p0"] = { -1,0 },
        ["p1"] = { -1,0 },
        ["p2"] = { -1,0 },
        ["p6"] = { -1,0 },
        ["p7"] = { -1,0 }
    }
}

local paramedico = {
    [1885233650] = {
        [1] = { -1,0 },
        [2] = { 21,0 },
        [3] = { 85,0 },
        [4] = { 96,0 },
        [5] = { -1,0 },
        [6] = { 10,0 },
        [7] = { 126,0 },			
        [8] = { 122,0 },
        [9] = { -1,0 },
        [10] = { -1,0 },
        [11] = { 250,0 },
        ["p0"] = { -1,0 },
        ["p1"] = { -1,0 },
        ["p2"] = { -1,0 },
        ["p6"] = { 1,0 },
        ["p7"] = { -1,0 }
    },
    [-1667301416] = {
        [1] = { -1,0 },
        [2] = { 6,0 },
        [3] = { 98,0 },
        [4] = { 99,0 },
        [5] = { -1,0 },
        [6] = { 27,0 },
        [7] = { 96,0 },			
        [8] = { 152,0 },
        [9] = { -1,0 },
        [10] = { -1,0 },
        [11] = { 258,0 },			
        ["p0"] = { -1,0 },
        ["p1"] = { -1,0 },
        ["p2"] = { -1,0 },
        ["p6"] = { -1,0 },
        ["p7"] = { -1,0 }
    }
}

local socorrista = {
    [1885233650] = {
        [1] = { -1,0 },
        [2] = { 21,0 },
        [3] = { 85,0 },
        [4] = { 96,0 },
        [5] = { -1,0 },
        [6] = { 10,0 },
        [7] = { 127,0 },			
        [8] = { 58,0 },
        [9] = { -1,0 },
        [10] = { -1,0 },
        [11] = { 250,0 },
        ["p0"] = { -1,0 },
        ["p1"] = { -1,0 },
        ["p2"] = { -1,0 },
        ["p6"] = { 1,0 },
        ["p7"] = { -1,0 }
    },
    [-1667301416] = {
        [1] = { -1,0 },
        [2] = { 6,0 },
        [3] = { 98,0 },
        [4] = { 99,1 },
        [5] = { -1,0 },
        [6] = { 27,0 },
        [7] = { 97,0 },			
        [8] = { 35,0 },
        [9] = { -1,0 },
        [10] = { -1,0 },
        [11] = { 258,0 },			
        ["p0"] = { -1,0 },
        ["p1"] = { -1,0 },
        ["p2"] = { -1,0 },
        ["p6"] = { -1,0 },
        ["p7"] = { -1,0 }
    }
}


RegisterServerEvent("diretorgeral")
AddEventHandler("diretorgeral",function()
    local user_id = vRP.getUserId(source)
    local custom = diretorgeral
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

RegisterServerEvent("diretorauxiliar")
AddEventHandler("diretorauxiliar",function()
    local user_id = vRP.getUserId(source)
    local custom = diretorauxiliar
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

RegisterServerEvent("medicochefe")
AddEventHandler("medicochefe",function()
    local user_id = vRP.getUserId(source)
    local custom = medicochefe
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

RegisterServerEvent("medicoauxiliar")
AddEventHandler("medicoauxiliar",function()
    local user_id = vRP.getUserId(source)
    local custom = medicoauxiliar
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

RegisterServerEvent("cirurgiao")
AddEventHandler("cirurgiao",function()
    local user_id = vRP.getUserId(source)
    local custom = cirurgiao
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

RegisterServerEvent("medico")
AddEventHandler("medico",function()
    local user_id = vRP.getUserId(source)
    local custom = medico
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

RegisterServerEvent("enfermeiro")
AddEventHandler("enfermeiro",function()
    local user_id = vRP.getUserId(source)
    local custom = enfermeiro
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

RegisterServerEvent("estagiario")
AddEventHandler("estagiario",function()
    local user_id = vRP.getUserId(source)
    local custom = estagiario
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

RegisterServerEvent("paramedico")
AddEventHandler("paramedico",function()
    local user_id = vRP.getUserId(source)
    local custom = paramedico
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

RegisterServerEvent("socorrista")
AddEventHandler("socorrista",function()
    local user_id = vRP.getUserId(source)
    local custom = socorrista
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

function Resg.checkPermissao()
	local source = source
	local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"ems.permissao") or vRP.hasPermission(user_id,"paisana-ems.permissao") then
        return true
	end
end