inMenu = false
local bank = 0
local firstname = ''

RegisterNetEvent("vRP:updateBalanceGc")
AddEventHandler('vRP:updateBalanceGc', function(bank)
      SendNUIMessage({event = 'updateBankbalance', banking = bank})    
end)

RegisterNetEvent('esx:playerLoaded69696969')
AddEventHandler('esx:playerLoaded69696969', function(playerData)
      local accounts = playerData.accounts or {}
      for index, account in ipairs(accounts) do 
            if account.name == 'bank' then
                  setBankBalance(account.money)
                  break
            end
      end
end)

RegisterNetEvent('esx:setAccountMoney69696969')
AddEventHandler('esx:setAccountMoney69696969', function(account)
      if account.name == 'bank' then
            setBankBalance(account.money)
      end
end)

RegisterNetEvent("es:addedBank")
AddEventHandler("es:addedBank", function(m)
      setBankBalance(bank + m)
end)

RegisterNetEvent("es:removedBank")
AddEventHandler("es:removedBank", function(m)
      setBankBalance(bank - m)
end)

RegisterNetEvent('es:displayBank')
AddEventHandler('es:displayBank', function(bank)
      setBankBalance(bank)
end)

AddEventHandler('gcphone:bankTransfer', function(data)
      TriggerServerEvent('bank:transfer', data.id, data.amount)
end)






