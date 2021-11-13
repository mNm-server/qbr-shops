local QBCore = exports['qbr-core']:GetCoreObject()

RegisterServerEvent('qbr-shops:server:UpdateShopItems')
AddEventHandler('qbr-shops:server:UpdateShopItems', function(shop, itemData, amount)
    Config.Products[shop][itemData.slot].amount =  Config.Products[shop][itemData.slot].amount - amount
    if Config.Products[shop][itemData.slot].amount <= 0 then 
        Config.Products[shop][itemData.slot].amount = 0
    end
    TriggerClientEvent('qbr-shops:client:SetShopItems', -1, shop, Config.Products[shop])
end)

RegisterServerEvent('qbr-shops:server:RestockShopItems')
AddEventHandler('qbr-shops:server:RestockShopItems', function(shop)
    if Config.Products[shop] ~= nil then 
        local randAmount = math.random(10, 50)
        for k, v in pairs(Config.Products[shop]) do 
            Config.Products[shop][k].amount = Config.Products[shop][k].amount + randAmount
        end
        TriggerClientEvent('qbr-shops:client:RestockShopItems', -1, shop, randAmount)
    end
end)

QBCore.Functions.CreateCallback('qbr-shops:server:getLicenseStatus', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local licenseTable = Player.PlayerData.metadata["licences"]

    if licenseTable.weapon then
        cb(true)
    else
        cb(false)
    end
end)
