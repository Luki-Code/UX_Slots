Framework = nil


if Config.Framework == 'ESX' then
    TriggerEvent('esx:getSharedObject', function(obj) Framework = obj end)

    Framework.RegisterServerCallback("Slots:BalanceStatement", function(source, cb)

        if (Config.UseItem == true and Config.UseMoney == false) then
            local xPlayer = Framework.GetPlayerFromId(source)
            cb(xPlayer.getInventoryItem(Config.ItemName).count)
        elseif (Config.UseItem == false and Config.UseMoney == true) then
            local xPlayer = Framework.GetPlayerFromId(source)
            cb(xPlayer.getMoney())
        else
            print("ERROR WRONG SETTINGS IN CONFIG: MONEY OR ITEM MUST BE FALSE")
        end
    end)


    Framework.RegisterServerCallback("Slots:RemoveMoneyFromBetsServer", function(source, cb, moneyPlacedInteger)

        local xPlayer = Framework.GetPlayerFromId(source)
        if (Config.UseItem == true and Config.UseMoney == false) then
            balance = xPlayer.getInventoryItem(Config.ItemName).count
        elseif (Config.UseItem == false and Config.UseMoney == true) then
            balance = xPlayer.getMoney()
        end
        if (tonumber(moneyPlacedInteger) <= balance) then
            DiscordLog(source,' [SLOTS]',Config.Webhook,"\n- SETTER:\n"..GetPlayerName(source).."("..source..")\n- HEX:\n"..Framework.GetPlayerFromId(source).identifier.."\n- BETAMOUNT:\n"..moneyPlacedInteger.."\n - TIME:\n"..os.date()..'')
            if (Config.UseItem == true and Config.UseMoney == false) then
                xPlayer.removeInventoryItem(Config.ItemName, moneyPlacedInteger)
                newbalance = xPlayer.getInventoryItem(Config.ItemName).count
            elseif (Config.UseItem == false and Config.UseMoney == true) then
                xPlayer.removeMoney(moneyPlacedInteger)
                newbalance = xPlayer.getMoney()
            end
            cb(newbalance)
        else
            cb(balance)
        end
    end)


    Framework.RegisterServerCallback("Slots:AddMoneyFromWinServer", function(source, cb, win)

        _src = source
        local xPlayer = Framework.GetPlayerFromId(source)
        DiscordLog(source,' [SLOTS]',Config.Webhook,"\n- WINNER:\n"..GetPlayerName(source).."("..source..")\n- HEX:\n"..Framework.GetPlayerFromId(source).identifier.."\n- WINAMOUNT:\n"..win.."\n - TIME:\n"..os.date()..'')
        if (win > 0) then
            if (Config.UseItem == true and Config.UseMoney == false) then
                xPlayer.addInventoryItem(Config.ItemName, win)
                newbalance = xPlayer.getInventoryItem(Config.ItemName).count
            elseif (Config.UseItem == false and Config.UseMoney == true) then
                xPlayer.addMoney(win)
                newbalance = xPlayer.getMoney()
            end
            Wait(500)
        else
        end
        cb(newbalance)
    end)





elseif Config.Framework == 'QBCore' then
    Framework = exports['qb-core']:GetCoreObject()
    Framework.Functions.CreateCallback("Slots:BalanceStatement", function(source, cb)
        local Player = Framework.Functions.GetPlayer(source)
        if (Config.UseItem == true and Config.UseMoney == false) then
            cb(Player.Functions.GetItemByName(Config.ItemName).amount)
        elseif (Config.UseItem == false and Config.UseMoney == true) then
            cb(Player.PlayerData.money['cash'])
        else
            print("ERROR WRONG SETTINGS IN CONFIG: MONEY OR ITEM MUST BE FALSE")
        end
    end)

    Framework.Functions.CreateCallback("Slots:RemoveMoneyFromBetsServer", function(source, cb, bets)
        local Player = Framework.Functions.GetPlayer(source)
        if (Config.UseItem == true and Config.UseMoney == false) then
            balance = Player.Functions.GetItemByName(Config.ItemName).amount
        elseif (Config.UseItem == false and Config.UseMoney == true) then
            balance = Player.PlayerData.money['cash']
        end
        if (tonumber(bets) <= balance) then
            DiscordLog(source,' [SLOTS]',Config.Webhook,"\n- SETTER:\n"..GetPlayerName(source).."("..source..")\n-BETAMOUNT:\n"..bets.."\n - TIME:\n"..os.date()..'')
            if (Config.UseItem == true and Config.UseMoney == false) then
                Player.Functions.RemoveItem(Config.ItemName, bets)
                newbalance = Player.Functions.GetItemByName(Config.ItemName).amount
            elseif (Config.UseItem == false and Config.UseMoney == true) then
                Player.Functions.RemoveMoney('cash', bets)
                Player.Functions.UpdatePlayerData()
                newbalance = Player.Functions.GetMoney('cash')
            end
            cb(newbalance)
        else
        end
    end)

    Framework.Functions.CreateCallback("Slots:AddMoneyFromWinServer", function(source, cb, win)
        _src = source
        local Player = Framework.Functions.GetPlayer(source)
        DiscordLog(source,' [SLOTS]',Config.Webhook,"\n- WINNER:\n"..GetPlayerName(source).."("..source..")\n-WINAMOUNT:\n"..win.."\n - TIME:\n"..os.date()..'')
        if (win > 0) then
            if (Config.UseItem == true and Config.UseMoney == false) then
                Player.Functions.AddItem(Config.ItemName, win)
                Player.Functions.UpdatePlayerData()
                newbalance = Player.Functions.GetItemByName(Config.ItemName).amount
            elseif (Config.UseItem == false and Config.UseMoney == true) then
                Player.Functions.AddMoney('cash', win)
                Player.Functions.UpdatePlayerData()
                newbalance = Player.Functions.GetMoney('cash')
            end
        else
        end
        cb(newbalance)
    end)
end

function DiscordLog(xPlayer,description,webhook,extra)
    local headers = {
        ['Content-Type'] = 'application/json'
    }
    local data = {
        ["embeds"] = {{
                          ["author"] = {
                              ["name"] = description..'\n'..extra..''
                          },
                          ["color"] = 15105570,
                          ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
                      }}
    }
    PerformHttpRequest(Config.Webhook, function(err, text, headers) end, 'POST', json.encode(data), headers)
end
