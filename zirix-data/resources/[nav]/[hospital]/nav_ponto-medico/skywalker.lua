local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local Tools = module("vrp","lib/Tools")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

Resg = {}
Tunnel.bindInterface("nav_ponto-medico",Resg)

--[ WEBHOOK ]----------------------------------------------------------------------------------------------------------------------------

local resgatePonto = ""

--[ PONTO ]------------------------------------------------------------------------------------------------------------------------------

RegisterServerEvent("entrar-servico")
AddEventHandler("entrar-servico",function()
    local user_id = vRP.getUserId(source)

    if vRP.hasPermission(user_id,"ems.permissao") then
        TriggerClientEvent("Notify",source,"negado","Você já está em serviço.")
    else
        vRP.addUserGroup(user_id,"dmla")
        TriggerEvent('eblips:add2',{ name = "Colaborador", src = source, color = 48 })
        TriggerClientEvent("Notify",source,"sucesso","Você entrou em serviço.")
        logEntradaServico()
    end
end)

RegisterServerEvent("sair-servico")
AddEventHandler("sair-servico",function()
    local user_id = vRP.getUserId(source)

    if vRP.hasPermission(user_id,"paisana-ems.permissao") then
        TriggerClientEvent("Notify",source,"negado","Você já está fora de serviço.")
    else
        vRP.addUserGroup(user_id,"paisana-dmla")
        TriggerEvent('eblips:remove',source)
        TriggerClientEvent("Notify",source,"sucesso","Você saiu de serviço.")
        logSaidaServico()
    end
end)

function logEntradaServico()
    local user_id = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(user_id)

    PerformHttpRequest(resgatePonto, function(err, text, headers) end, 'POST', json.encode({
        embeds = {
            { 
                title = identity.name.." entrou em serviço.",
                description = "Registro de Ponto do Departamento Médico de Los Anjos. Registro de entrada em serviço.\n⠀",
                thumbnail = {
                    url = "https://i.imgur.com/Wp2QrV7.png"
                },
                fields = {
                    { 
                        name = "**IDENTIFICAÇÃO DO COLABORADOR:**",
                        value = "**"..identity.name.." "..identity.firstname.."** [**"..user_id.."**]\n⠀"
                    }
                },
                footer = { 
                    text = "Los Anjos RP - "..os.date("%d/%m/%Y | %H:%M:%S"),
                    icon_url = "https://i.imgur.com/Wp2QrV7.png"
                },
                color = 15906321
            }
        }
    }), { ['Content-Type'] = 'application/json' })
end

function logSaidaServico()
    local user_id = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(user_id)

    PerformHttpRequest(resgatePonto, function(err, text, headers) end, 'POST', json.encode({
        embeds = {
            { 
                title = identity.name.." saiu de serviço.",
                description = "Registro de Ponto do Departamento Médico de Los Anjos. Registro de saída de serviço.\n⠀",
                thumbnail = {
                    url = "https://i.imgur.com/Wp2QrV7.png"
                },
                fields = {
                    { 
                        name = "**IDENTIFICAÇÃO DO COLABORADOR:**",
                        value = "**"..identity.name.." "..identity.firstname.."** [**"..user_id.."**]\n⠀"
                    }
                },
                footer = { 
                    text = "Los Anjos RP - "..os.date("%d/%m/%Y | %H:%M:%S"),
                    icon_url = "https://i.imgur.com/Wp2QrV7.png"
                },
                color = 15906321
            }
        }
    }), { ['Content-Type'] = 'application/json' })
end

function Resg.checkPermissao()
	local source = source
	local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"ems.permissao") or vRP.hasPermission(user_id,"paisana-ems.permissao") then
        return true
	end
end