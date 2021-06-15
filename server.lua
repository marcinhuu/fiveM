ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('esx_society:registerSociety', 'police', 'police', 'society_police', 'society_police', 'society_police', {type = 'private'})

ESX.RegisterServerCallback('sky_policia:getPlayerInventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.inventory

	cb( { items = items } )
end)

RegisterServerEvent('sky_policia:putStockItems')
AddEventHandler('sky_policia:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_police', function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		
		if sourceItem.count >= count and count > 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
			TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'inform', text = '👮🏼‍| Polícia: Depositas-te um item com sucesso'})
			TriggerEvent('logs:colocarpolicia', GetPlayerName(source).. ' colocou: ' .. count .. ' ' .. itemName .. ' do baú da polícia ' ..xPlayer.job.label)
		else
			TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'error', text = '👮🏼‍| Polícia: Quantidade inválida'})
		end
	end) -- colocar itens do armazem da polícia
end)

ESX.RegisterServerCallback('sky_policia:getStockItems', function(source, cb)
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_police', function(inventory)
		cb(inventory.items)
	end)
end)

RegisterServerEvent('sky_policia:getStockItem')
AddEventHandler('sky_policia:getStockItem', function(itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_police', function(inventory)
		local inventoryItem = inventory.getItem(itemName)
		if count > 0 and inventoryItem.count >= count then
			if xPlayer.canCarryItem(itemName, count) then
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
				TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = '👮🏼‍| Polícia: Retiras-te um item com sucesso'})
				TriggerEvent('logs:retirarpolicia', GetPlayerName(source).. ' retirou: ' .. count .. ' ' .. itemName .. ' do baú da polícia ' ..xPlayer.job.label)

			else
				TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'error', text = '👮🏼‍| Polícia: Quantidade inválida'})
			end
		else
			TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'error', text = '👮🏼‍| Polícia: Quantidade inválida'})
		end
	end) -- retirar itens do armazem da polícia
end)    

RegisterServerEvent('policia:arma1')
AddEventHandler('policia:arma1', function()
  local xPlayer = ESX.GetPlayerFromId(source)
  xPlayer.addWeapon('weapon_stungun', 250)
  TriggerEvent('logs:retirararmapolicia', GetPlayerName(source).. ' Retirou uma **Pistola de Tazer** do baú da polícia.')
end)
RegisterServerEvent('policia:arma2')
AddEventHandler('policia:arma2', function()
  local xPlayer = ESX.GetPlayerFromId(source)
  xPlayer.addWeapon('weapon_combatpistol', 250)
  TriggerEvent('logs:retirararmapolicia', GetPlayerName(source).. ' Retirou uma **Pistola Normal** do baú da polícia.')
end)
RegisterServerEvent('policia:arma3')
AddEventHandler('policia:arma3', function()
  local xPlayer = ESX.GetPlayerFromId(source)
  xPlayer.addWeapon('weapon_smg', 250)
  TriggerEvent('logs:retirararmapolicia', GetPlayerName(source).. ' Retirou uma **Pistola SMG** do baú da polícia.')
end)
RegisterServerEvent('policia:arma4')
AddEventHandler('policia:arma4', function()
  local xPlayer = ESX.GetPlayerFromId(source)
  xPlayer.addWeapon('weapon_pumpshotgun', 250)
  TriggerEvent('logs:retirararmapolicia', GetPlayerName(source).. ' Retirou uma **Pistola Caçaceira** do baú da polícia.')
end)
RegisterServerEvent('policia:arma5')
AddEventHandler('policia:arma5', function()
  local xPlayer = ESX.GetPlayerFromId(source)
  xPlayer.addWeapon('weapon_heavyshotgun', 250)
  TriggerEvent('logs:retirararmapolicia', GetPlayerName(source).. ' Retirou uma **Pistola Caçaceira Tática** do baú da polícia.')
end)
RegisterServerEvent('policia:arma6')
AddEventHandler('policia:arma6', function()
  local xPlayer = ESX.GetPlayerFromId(source)
  xPlayer.addWeapon('weapon_carbinerifle', 250)
  TriggerEvent('logs:retirararmapolicia', GetPlayerName(source).. ' Retirou uma **Pistola M4A4** do baú da polícia.')
end)
RegisterServerEvent('policia:arma7')
AddEventHandler('policia:arma7', function()
  local xPlayer = ESX.GetPlayerFromId(source)
  xPlayer.addWeapon('weapon_sniperrifle', 250)
  TriggerEvent('logs:retirararmapolicia', GetPlayerName(source).. ' Retirou uma **Pistola Sniperrifle** do baú da polícia.')
end)

RegisterServerEvent("logs:retirararmapolicia")
AddEventHandler("logs:retirararmapolicia", function(message)
    local xPlayer = ESX.GetPlayerFromId(source)
    retirarpolicia(message)
end)

RegisterServerEvent("logs:retirarpolicia")
AddEventHandler("logs:retirarpolicia", function(message)
    local xPlayer = ESX.GetPlayerFromId(source)
    retirarpolicia(message)
end)

RegisterServerEvent("logs:colocarpolicia")
AddEventHandler("logs:colocarpolicia", function(message)
    local xPlayer = ESX.GetPlayerFromId(source)
    colocarpolicia(message)
end)
-- LOGS
function retirarpolicia(message)
    local content = {
        {
            ["color"] = '3447003',  --azul
            ["title"] = "Armazém Polícia",
            ["description"] = message,
            ["footer"] = {
                ["icon_url"] = "https://cdn.discordapp.com/attachments/788560493954203679/788839061678063616/logo_just_cloud.png",
                ["text"] = "© Sky Logs - "..os.date("%x %X %p")
            }, 
        }
    }
        
    PerformHttpRequest( "https://discord.com/api/webhooks/853748592954048572/JN80y0WkzB6MzrbBzuzhEzLhD2K6a4KU97k9UCFMA-w3-K2BmaiFFs77fB9_PxO484GG", function(err, text, headers) end, 'POST', json.encode({username = name, embeds = content}), { ['Content-Type'] = 'application/json' })
end

function colocarpolicia(message)
    local content = {
        {
            ["color"] = '3447003',  --azul
            ["title"] = "Armazém Polícia",
            ["description"] = message,
            ["footer"] = {
                ["icon_url"] = "https://cdn.discordapp.com/attachments/788560493954203679/788839061678063616/logo_just_cloud.png",
                ["text"] = "© Sky Logs - "..os.date("%x %X %p")
            }, 
        }
    }
        
    PerformHttpRequest( "https://discord.com/api/webhooks/853748592954048572/JN80y0WkzB6MzrbBzuzhEzLhD2K6a4KU97k9UCFMA-w3-K2BmaiFFs77fB9_PxO484GG", function(err, text, headers) end, 'POST', json.encode({username = name, embeds = content}), { ['Content-Type'] = 'application/json' })
end

TriggerEvent('esx_phone:registerNumber', 'police', 'Alerta da Polícia', true, true)
TriggerEvent('esx_society:registerSociety', 'police', 'Police', 'society_police', 'society_police', 'society_police', {type = 'public'})

RegisterServerEvent('sky_policia:handcuff2') -- algemar2
AddEventHandler('sky_policia:handcuff2', function(target)
    local name = getIdentity(source)
  TriggerClientEvent('sky_policia:handcuff', target)
end)

RegisterServerEvent('esx_mafiajob:drag') -- arrastar 
AddEventHandler('esx_mafiajob:drag', function(target)
  local _source = source
  TriggerClientEvent('esx_mafiajob:drag', target, _source)
end)

RegisterNetEvent('sky_policia:drag') -- arrastar 3
AddEventHandler('sky_policia:drag', function(target)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.job.name == 'police' then
        TriggerClientEvent('sky_policia:dragpolice', target, source)
    end
end)

RegisterServerEvent('sky_policia:putInVehicle') -- colocar no veiculo
AddEventHandler('sky_policia:putInVehicle', function(target)
  local name = getIdentity(source)
  TriggerClientEvent('sky_policia:putInVehicle', target)
end)

RegisterServerEvent('sky_policia:OutVehicle') -- retirar do veiculo
AddEventHandler('sky_policia:OutVehicle', function(target)
    local name = getIdentity(source)
    TriggerClientEvent('sky_policia:OutVehicle', target)
end)

function getIdentity(source)
    local identifier = GetPlayerIdentifiers(source)[1]
    local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {['@identifier'] = identifier})
    if result[1] ~= nil then
        local identity = result[1]

        return {
            identifier = identity['identifier'],
            name = identity['name'],
            firstname = identity['firstname'],
            lastname = identity['lastname'],
            dateofbirth = identity['dateofbirth'],
            sex = identity['sex'],
            height = identity['height'],
            job = identity['job'],
            group = identity['group']
        }
    else
        return nil
    end -- obter identidade
end

ESX.RegisterServerCallback('sky_policia:getOtherPlayerData', function(source, cb, target)

    if Config.EnableESXIdentity then
  
      local xPlayer = ESX.GetPlayerFromId(target)
  
      local identifier = GetPlayerIdentifiers(target)[1]
  
      local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {
        ['@identifier'] = identifier
      })
  
      local user          = result[1]
      local firstname     = user['firstname']
      local lastname      = user['lastname']
      local sex           = user['sex']
      local dob           = user['dateofbirth']
      local height        = user['height'] .." cm"
  
      local data = {
        name        = GetPlayerName(target),
        job         = xPlayer.job.label.. " - " ..xPlayer.job.grade_label,
        inventory   = xPlayer.inventory,
        accounts    = xPlayer.accounts,
        weapons     = xPlayer.loadout,
        firstname   = firstname,
        lastname    = lastname,
        sex         = sex,
        dob         = dob,
        height      = height
      }
  
      TriggerEvent('esx_status:getStatus', target, 'drunk', function(status)
  
        if status ~= nil then
          data.drunk = math.floor(status.percent)
        end
  
      end)
  
      if Config.EnableLicenses then
  
        TriggerEvent('esx_license:getLicenses', target, function(licenses)
          data.licenses = licenses
          cb(data)
        end)
  
      else
        cb(data)
      end
  
    else
  
      local xPlayer = ESX.GetPlayerFromId(target)
  
      local data = {
        name       = GetPlayerName(target),
        job        = xPlayer.job,
        inventory  = xPlayer.inventory,
        accounts   = xPlayer.accounts,
        weapons    = xPlayer.loadout
      }
  
      TriggerEvent('esx_status:getStatus', target, 'drunk', function(status)
  
        if status ~= nil then
          data.drunk = math.floor(status.percent)
        end
  
      end)
  
      TriggerEvent('esx_license:getLicenses', target, function(licenses)
        data.licenses = licenses
      end)
  
      cb(data)
  
    end
  
  end) -- informações de jogadores

ESX.RegisterServerCallback('sky_policia:getFineList', function(source, cb, category)
    MySQL.Async.fetchAll('SELECT * FROM fine_types WHERE category = @category', {
        ['@category'] = category
    }, function(fines)
        cb(fines)
    end) -- informações das multas por pagar
end)

ESX.RegisterServerCallback('sky_policia:getVehicleInfos', function(source, cb, plate)
    MySQL.Async.fetchAll('SELECT owner FROM owned_vehicles WHERE plate = @plate', {
        ['@plate'] = plate
    }, function(result)
        local retrivedInfo = {plate = plate}

        if result[1] then
            local xPlayer = ESX.GetPlayerFromIdentifier(result[1].owner)

            -- is the owner online?
            if xPlayer then
                retrivedInfo.owner = xPlayer.getName()
                cb(retrivedInfo)
            elseif Config.EnableESXIdentity then
                MySQL.Async.fetchAll('SELECT firstname, lastname FROM users WHERE identifier = @identifier',  {
                    ['@identifier'] = result[1].owner
                }, function(result2)
                    if result2[1] then
                        retrivedInfo.owner = ('%s %s'):format(result2[1].firstname, result2[1].lastname)
                        cb(retrivedInfo)
                    else
                        cb(retrivedInfo)
                    end
                end)
            else
                cb(retrivedInfo)
            end
        else
            cb(retrivedInfo)
        end
    end) -- informações dos veículos
end)

ESX.RegisterServerCallback('sky_policia:getPlayerInventory', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local items   = xPlayer.inventory

    cb({items = items}) -- inventario do jogador
end)

AddEventHandler('playerDropped', function()
    -- Save the source in case we lose it (which happens a lot)
    local playerId = source

    -- Did the player ever join?
    if playerId then
        local xPlayer = ESX.GetPlayerFromId(playerId)

        -- Is it worth telling all clients to refresh?
        if xPlayer and xPlayer.job.name == 'police' then
            Citizen.Wait(5000)
            TriggerClientEvent('sky_policia:updateBlip', -1)
        end
    end
end)

RegisterNetEvent('sky_policia:spawned')
AddEventHandler('sky_policia:spawned', function()
    local xPlayer = ESX.GetPlayerFromId(playerId)

    if xPlayer and xPlayer.job.name == 'police' then
        Citizen.Wait(5000)
        TriggerClientEvent('sky_policia:updateBlip', -1)
    end -- blips
end)

RegisterNetEvent('sky_policia:forceBlip')
AddEventHandler('sky_policia:forceBlip', function()
    TriggerClientEvent('sky_policia:updateBlip', -1)
end)

-- TRACKING CARRO

RegisterServerEvent('sky_policia:sendblip')
AddEventHandler('sky_policia:sendblip', function(veh)
    local xPlayers = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

        if xPlayer.job.name == 'police' then
            TriggerClientEvent('sky_policia:trackerset', xPlayers[i],veh)
        end
    end
end)

RegisterServerEvent('sky_policia:removetracker')
AddEventHandler('sky_policia:removetracker', function(gps)
    local xPlayers = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

        if xPlayer.job.name == 'police' then
            TriggerClientEvent('sky_policia:trackerremove', xPlayers[i],gps)
        end
    end
end)