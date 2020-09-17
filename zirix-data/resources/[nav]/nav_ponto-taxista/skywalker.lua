local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local Tools = module("vrp","lib/Tools")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

emP = {}
Tunnel.bindInterface("nav_ponto-taxista",emP)

--[ WEBHOOK ]----------------------------------------------------------------------------------------------------------------------------

local taxiPonto = ""

--[ PONTO ]------------------------------------------------------------------------------------------------------------------------------

RegisterServerEvent("entrar-servico-taxista")
AddEventHandler("entrar-servico-taxista",function()
    local user_id = vRP.getUserId(source)

    if vRP.hasPermission(user_id,"taxista.permissao") then
        TriggerClientEvent("Notify",source,"negado","Você já está em serviço.")
    else
        vRP.addUserGroup(user_id,"taxista")
        TriggerClientEvent("Notify",source,"sucesso","Você entrou em serviço.")
    end
end)

RegisterServerEvent("sair-servico-taxista")
AddEventHandler("sair-servico-taxista",function()
    local user_id = vRP.getUserId(source)

    if vRP.hasPermission(user_id,"paisana-taxista.permissao") then
        TriggerClientEvent("Notify",source,"negado","Você já está fora de serviço.")
    else
        vRP.addUserGroup(user_id,"paisana-taxista")
        TriggerClientEvent("Notify",source,"sucesso","Você saiu de serviço.")
    end
end)

function logEntradaServico()
    local user_id = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(user_id)

    --[[PerformHttpRequest(resgatePonto, function(err, text, headers) end, 'POST', json.encode({
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
    }), { ['Content-Type'] = 'application/json' })]]
end

function logSaidaServico()
    local user_id = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(user_id)

    --[[PerformHttpRequest(resgatePonto, function(err, text, headers) end, 'POST', json.encode({
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
    }), { ['Content-Type'] = 'application/json' })]]
end