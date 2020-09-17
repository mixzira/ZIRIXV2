local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vrp_skinshop")
vRPloja = Tunnel.getInterface("vrp_skinshop")

RegisterServerEvent("vrp_skinshop:Comprar")
AddEventHandler("vrp_skinshop:Comprar", function(preco)
    local source = source
    local user_id = vRP.getUserId(source)
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

        
        if vRP.tryPayment(user_id,parseInt(pagamento)) then
            TriggerClientEvent("Notify",source,"sucesso","Você pagou <b>$"..vRP.format(parseInt(pagamento)).." dólares</b> em roupas e acessórios.")
            TriggerClientEvent('vrp_skinshop:ReceberCompra', source, true)
        else
            TriggerClientEvent("Notify",source,"negado","Dinheiro & saldo insuficientes.")
            TriggerClientEvent('vrp_skinshop:ReceberCompra', source, false)	
        end
    end
end)

