local QBCore = exports['qb-core']:GetCoreObject()

function DrawText3Ds(x, y, z, text)
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)
    local px,py,pz=table.unpack(GetGameplayCamCoord())
    
    SetTextScale(0.35, 0.35)
    SetTextFontForCurrentCommand(1)
    SetTextColor(255, 255, 255, 215)
    local str = CreateVarString(10, "LITERAL_STRING", text, Citizen.ResultAsLong())
    SetTextCentre(1)
    DisplayText(str,_x,_y)
    local factor = (string.len(text)) / 150
end

CreateThread(function()
    while true do
        local InRange = false
        local PlayerPed = PlayerPedId()
        local PlayerPos = GetEntityCoords(PlayerPed)

        for shop, _ in pairs(Config.Locations) do
            local position = Config.Locations[shop]["coords"]
            for _, loc in pairs(position) do
                local dist = #(PlayerPos - vector3(loc["x"], loc["y"], loc["z"]))
                if dist < 10 then
                    InRange = true
                    Citizen.InvokeNative(0x2A32FAA57B937173, -1795314153, 2, loc["x"], loc["y"] + 0.5, loc["z"] - 1, 0, 0, 0, 0, 0, 0, 1.3, 1.3, 2.0, 93, 0, 0, 155, 0, 0, 2, 0, 0, 0, 0)            --end
                    if dist < 1 then
                        DrawText3Ds(loc["x"], loc["y"], loc["z"] + 0.15, '~g~E~w~ - Shop')
                        if IsControlJustPressed(0, 0xCEFD9220) then -- E
                            local ShopItems = {}
                            ShopItems.items = {}
                            QBCore.Functions.TriggerCallback('qb-shops:server:getLicenseStatus', function(result)
                                ShopItems.label = Config.Locations[shop]["label"]
                                if Config.Locations[shop].type == "weapon" then
                                    if result then
                                        ShopItems.items = Config.Locations[shop]["products"]
                                    else
                                        for i = 1, #Config.Locations[shop]["products"] do
                                            if not Config.Locations[shop]["products"][i].requiresLicense then
                                                table.insert(ShopItems.items, Config.Locations[shop]["products"][i])
                                            end
                                        end
                                    end
                                else
                                    ShopItems.items = Config.Locations[shop]["products"]
                                end
                                ShopItems.slots = 30
                                TriggerServerEvent("inventory:server:OpenInventory", "shop", "Itemshop_"..shop, ShopItems)
                            end)
                        end
                    end
                end
            end
        end
        if not InRange then
            Wait(5000)
        end
        Wait(5)
    end
end)

RegisterNetEvent('qb-shops:client:UpdateShop')
AddEventHandler('qb-shops:client:UpdateShop', function(shop, itemData, amount)
    TriggerServerEvent('qb-shops:server:UpdateShopItems', shop, itemData, amount)
end)

RegisterNetEvent('qb-shops:client:SetShopItems')
AddEventHandler('qb-shops:client:SetShopItems', function(shop, shopProducts)
    Config.Locations[shop]["products"] = shopProducts
end)

RegisterNetEvent('qb-shops:client:RestockShopItems')
AddEventHandler('qb-shops:client:RestockShopItems', function(shop, amount)
    if Config.Locations[shop]["products"] ~= nil then 
        for k, v in pairs(Config.Locations[shop]["products"]) do 
            Config.Locations[shop]["products"][k].amount = Config.Locations[shop]["products"][k].amount + amount
        end
    end
end)

Citizen.CreateThread(function()
    for store,_ in pairs(Config.Locations) do
	if Config.Locations[store]["showblip"] then
	    StoreBlip = AddBlipForCoord(Config.Locations[store]["coords"][1]["x"], Config.Locations[store]["coords"][1]["y"], Config.Locations[store]["coords"][1]["z"])
	    SetBlipColour(StoreBlip, 0)

	    if Config.Locations[store]["products"] == Config.Products["normal"] then
	        SetBlipSprite(StoreBlip, 52)
	        SetBlipScale(StoreBlip, 0.6)
	    elseif Config.Locations[store]["products"] == Config.Products["coffeeplace"] then
	        SetBlipSprite(StoreBlip, 52)
	        SetBlipScale(StoreBlip, 0.6)
	    elseif Config.Locations[store]["products"] == Config.Products["gearshop"] then
	        SetBlipSprite(StoreBlip, 52)
	        SetBlipScale(StoreBlip, 0.6)
	    elseif Config.Locations[store]["products"] == Config.Products["hardware"] then
	        SetBlipSprite(StoreBlip, 402)
	        SetBlipScale(StoreBlip, 0.8)
	    elseif Config.Locations[store]["products"] == Config.Products["weapons"] then
	        SetBlipSprite(StoreBlip, 110)
	        SetBlipScale(StoreBlip, 0.85)
	    elseif Config.Locations[store]["products"] == Config.Products["leisureshop"] then
	        SetBlipSprite(StoreBlip, 52)
	        SetBlipScale(StoreBlip, 0.6)
	        SetBlipColour(StoreBlip, 3)           
	    elseif Config.Locations[store]["products"] == Config.Products["mustapha"] then
	        SetBlipSprite(StoreBlip, 225)
	        SetBlipScale(StoreBlip, 0.6)
	        SetBlipColour(StoreBlip, 3)              
	    elseif Config.Locations[store]["products"] == Config.Products["coffeeshop"] then
	        SetBlipSprite(StoreBlip, 140)
	        SetBlipScale(StoreBlip, 0.55)
	    elseif Config.Locations[store]["products"] == Config.Products["casino"] then
	        SetBlipSprite(StoreBlip, 617)
	        SetBlipScale(StoreBlip, 0.70)
	    end

	    SetBlipDisplay(StoreBlip, 4)
	    SetBlipAsShortRange(StoreBlip, true)


	    BeginTextCommandSetBlipName("STRING")
	    AddTextComponentSubstringPlayerName(Config.Locations[store]["label"])
	    EndTextCommandSetBlipName(StoreBlip)
	end
    end
end)