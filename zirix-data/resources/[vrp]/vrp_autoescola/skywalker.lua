local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local Tools = module("vrp", "lib/Tools")
vRPclient = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")

--[ CONEXÃO ]----------------------------------------------------------------------------------------------------------------------------

dmv = {}
Tunnel.bindInterface("vrp_autoescola",dmv)

--[ mySQL ]------------------------------------------------------------------------------------------------------------------------------

vRP._prepare("vRP/update_driverlicense","UPDATE vrp_user_identities SET driverlicense = @driverlicense WHERE user_id = @user_id")
vRP._prepare("vRP/get_driverlicense","SELECT user_id FROM vrp_user_identities WHERE driverlicense = @driverlicense")

--[ AÇÃO ]-------------------------------------------------------------------------------------------------------------------------------

function dmv.pagamento()
    local source = source
    local user_id = vRP.getUserId(source)
    local preco = 600

    if preco then
        if vRP.hasPermission(user_id,"ultimate.permissao") then
            desconto = math.floor(preco*20/100)
            pagamento = math.floor(preco-desconto)
        elseif vRP.hasPermission(user_id,"platinum.permissao") then
            desconto = math.floor(preco*15/100)
            pagamento = math.floor(preco-desconto)
        elseif vRP.hasPermission(user_id,"gold.permissao") then
            desconto = math.floor(preco*10/100)
            pagamento = math.floor(preco-desconto)
        elseif vRP.hasPermission(user_id,"standard.permissao") then
            desconto = math.floor(preco*5/100)
            pagamento = math.floor(preco-desconto)
        else
            pagamento = math.floor(preco)
        end

        if vRP.getInventoryItemAmount(user_id,"cartaodebito") >= 1 then
            if vRP.tryPayment(user_id,parseInt(pagamento)) then
                TriggerClientEvent("Notify",source,"sucesso","Você pagou <b>$"..vRP.format(parseInt(pagamento)).." dólares</b> em roupas e acessórios. <b>( Dinheiro )</b>")
                return true
            else
                if vRP.tryDebitPayment(user_id,parseInt(pagamento)) then
                    TriggerClientEvent("Notify",source,"sucesso","Você pagou <b>$"..vRP.format(parseInt(pagamento)).." dólares</b> em roupas e acessórios. <b>( Débito )</b>")
                    return true
                else
                    TriggerClientEvent("Notify",source,"negado","Dinheiro & saldo insuficientes.")
                    return false
                end
            end
        else
            if vRP.tryPayment(user_id,parseInt(pagamento)) then
                if preco > 0 then
                    TriggerClientEvent("Notify",source,"sucesso","Você pagou <b>$"..vRP.format(parseInt(pagamento)).." dólares</b> em roupas e acessórios. <b>( Dinheiro )</b>")
                    return true
                end
            else
                TriggerClientEvent("Notify",source,"negado","Dinheiro insuficiente.")
                return false
            end
        end
    end
end

function dmv.checkcarlicense()
    local source = source
    local user_id = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(user_id)

    if identity.driverlicense == 0 or identity.driverlicense == 3 then
        return true
    end
end

function dmv.sucesso()
    local source = source
    local user_id = vRP.getUserId(source)

    TriggerEvent("carteira",1,user_id)
end

RegisterCommand('aprender',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(user_id)
    if vRP.hasPermission(user_id,"policia.permissao") then
        if args[1] == "cnh" then
            local nplayer = vRPclient.getNearestPlayer(source,2)
            local nuser_id = user_id
            local identitynu = vRP.getUserIdentity(nuser_id)

            if nplayer then
                TriggerEvent("carteira",3,nuser_id)
                TriggerClientEvent("Notify",source,"sucesso","Você apreendeu a carteira de motorista de <b>"..identitynu.name.." "..identitynu.firstname.."</b>.")
                TriggerClientEvent("Notify",nplayer,"negado","O oficial <b>"..identity.name.." "..identity.firstname.."</b> apreendeu sua carteira de motorista.")
            else
                TriggerClientEvent("Notify",source,"negado","Não há players por perto.")
            end
        end
    end
end)

RegisterServerEvent("carteira")
AddEventHandler("carteira",function(driverlicense,user_id)
    vRP.execute("vRP/update_driverlicense", {driverlicense = driverlicense, user_id = user_id})
end)

