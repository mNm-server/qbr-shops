local QBCore = exports['qbr-core']:GetCoreObject()

Citizen.CreateThread(function()
    for store, v in pairs(Config.Locations) do
        exports['qbr-prompts']:createPrompt(v.name, v.coords, 0xF3830D8E, 'Open ' .. v.name, {
            type = 'client',
            event = 'qbr-shops:openshop',
            args = {v.products, v.name},
        })
        if v.showblip == true then
            StoreBlip = AddBlipForCoord(v.coords)
            SetBlipColour(StoreBlip, 0)
    
            if v.products == "normal" then
                SetBlipSprite(StoreBlip, 52)
                SetBlipScale(StoreBlip, 0.6)
            elseif v.products == "coffeeplace" then
                SetBlipSprite(StoreBlip, 52)
                SetBlipScale(StoreBlip, 0.6)
            elseif v.products == "gearshop" then
                SetBlipSprite(StoreBlip, 52)
                SetBlipScale(StoreBlip, 0.6)
            elseif v.products == "hardware" then
                SetBlipSprite(StoreBlip, 402)
                SetBlipScale(StoreBlip, 0.8)
            elseif v.products == "weapons" then
                SetBlipSprite(StoreBlip, 110)
                SetBlipScale(StoreBlip, 0.85)
            elseif v.products == "leisureshop" then
                SetBlipSprite(StoreBlip, 52)
                SetBlipScale(StoreBlip, 0.6)
                SetBlipColour(StoreBlip, 3)           
            elseif v.products == "mustapha" then
                SetBlipSprite(StoreBlip, 225)
                SetBlipScale(StoreBlip, 0.6)
                SetBlipColour(StoreBlip, 3)              
            elseif v.products == "Saloon" then
                SetBlipSprite(StoreBlip, 140)
                SetBlipScale(StoreBlip, 0.55)
            elseif v.products == "casino" then
                SetBlipSprite(StoreBlip, 617)
                SetBlipScale(StoreBlip, 0.70)
            end
    
            SetBlipDisplay(StoreBlip, 4)
            SetBlipAsShortRange(StoreBlip, true)
    
    
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentSubstringPlayerName(v["label"])
            EndTextCommandSetBlipName(StoreBlip)
        end
    end     
end)

RegisterNetEvent('qbr-shops:openshop')
AddEventHandler('qbr-shops:openshop', function(shopType, shopName)
    local type = shopType
    local shop = shopName
    local ShopItems = {}
    ShopItems.items = {}
    QBCore.Functions.TriggerCallback('qbr-shops:server:getLicenseStatus', function(result)
        ShopItems.label = shop
        if type == "weapon" then
            if result then
                ShopItems.items =  Config.Products[type]
            else
                for i = 1, #Config.Products[type] do
                    if not Config.Products[type][i].requiresLicense then
                        table.insert(ShopItems.items, Config.Products[type][i])
                    end
                end
            end
        else
            ShopItems.items = Config.Products[type]
        end
        ShopItems.slots = 30
        TriggerServerEvent("inventory:server:OpenInventory", "shop", "Itemshop_"..shop, ShopItems)
    end)
end)

RegisterNetEvent('qbr-shops:client:UpdateShop')
AddEventHandler('qbr-shops:client:UpdateShop', function(shop, itemData, amount)
    TriggerServerEvent('qbr-shops:server:UpdateShopItems', shop, itemData, amount)
end)

RegisterNetEvent('qbr-shops:client:SetShopItems')
AddEventHandler('qbr-shops:client:SetShopItems', function(shop, shopProducts)
    Config.Products[shop] = shopProducts
end)

RegisterNetEvent('qbr-shops:client:RestockShopItems')
AddEventHandler('qbr-shops:client:RestockShopItems', function(shop, amount)
    if Config.Products[shop] ~= nil then 
        for k, v in pairs(Config.Products[shop]) do 
            Config.Products[shop][k].amount = Config.Products[shop][k].amount + amount
        end
    end
end)
