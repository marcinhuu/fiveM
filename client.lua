ESX = nil
CargarObjeto = nil
local PlayerData = {}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end 
    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(100)
    end
    
    PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

Citizen.CreateThread(function()
    while true do 
        local _msec = 250
        if PlayerData.job and PlayerData.job.name == 'police' or PlayerData.job and PlayerData.job.name == 'offpolice' then
            _msec = 0
            if IsControlJustPressed(0, 167) then
                exports['mythic_notify']:DoHudText('inform', '👮🏼‍| Menu Polícia')
                TriggerEvent('policia-contextmenu')
            end
        end
        Citizen.Wait(_msec)
    end
end)

Citizen.CreateThread(function()
    while true do
        local _msec = 250
        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)

        for k,v in pairs(Config.MenuGeneralPolicia) do
            if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), v.x, v.y,v.z) <= 3.0 then
                _msec = 0
                if PlayerData.job and PlayerData.job.name == 'police' or PlayerData.job and PlayerData.job.name == 'offpolice' then
                    DrawText3Ds(v.x, v.y, v.z + 1.0, '~b~[E]~w~ | Menu Geral Polícia', v)
                    if IsControlJustPressed(0,38) then
                        TriggerEvent('policia-general')
                    end
                end
            end
        end
        for k,v in pairs(Config.SpawnarVeiculos) do
            if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), v.x, v.y,v.z) <= 3.0 then
                _msec = 0
                if PlayerData.job and PlayerData.job.name == 'police' or PlayerData.job and PlayerData.job.name == 'offpolice' then
                    DrawText3Ds(v.x, v.y, v.z + 1.0,'~b~[E]~w~ | Garagem da Polícia', v)
                    if IsControlJustPressed(0,38) then
                        --exports['mythic_notify']:DoHudText('inform', '👮🏼‍| Veículo retirado com sucesso')
                        TriggerEvent('policia-veiculos')
                    end
                end
            end
        end        
        for k,v in pairs(Config.ApagarVeiculo) do
            if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), v.x, v.y,v.z) <= 3.0 then
                _msec = 0
                if PlayerData.job and PlayerData.job.name == 'police' or PlayerData.job and PlayerData.job.name == 'offpolice' then
                    DrawText3Ds(v.x, v.y, v.z + 1.0,'~b~[E]~w~ | Guardar Veículo', v)
                    if IsControlJustPressed(0,38) then
                        exports['mythic_notify']:DoHudText('inform', '👮🏼‍| Veículo guardado com sucesso')
                        DeleteVehicle(vehicle)
                    end
                end
            end
        end
        for k,v in pairs(Config.BlipComputer) do
            if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), v.x, v.y,v.z) <= 3.0 then
                _msec = 0
                if PlayerData.job and PlayerData.job.name == 'police' or PlayerData.job and PlayerData.job.name == 'offpolice' then
                    DrawText3Ds(v.x, v.y, v.z + 1.0,'~b~[E]~w~ | Análise DNA', v)
                    if IsControlJustPressed(0,38) then
                        --inMarker = true
                    end
                end
            end
        end        
        Citizen.Wait(_msec)
    end
end)

function DrawText3Ds(x,y,z, text)
  local onScreen,_x,_y=World3dToScreen2d(x,y,z)
  local px,py,pz=table.unpack(GetGameplayCamCoords())

  SetTextScale(0.35, 0.35)
  SetTextFont(4)
  SetTextProportional(1)
  SetTextColour(255, 255, 255, 215)
  SetTextEntry("STRING")
  SetTextCentre(true)
  AddTextComponentString(text)
  DrawText(_x,_y)
  local factor = (string.len(text)) / 370
  DrawRect(_x,_y+0.0125, 0.015+ factor, 0, 0, 0, 0.0)
end

RegisterNetEvent('policia-contextmenu', function()
    TriggerEvent('nh-context:sendMenu', {
        {
            id = 1,
            header = "Menu Pessoal Mecânico",
            txt = "",
        },
        {
            id = 2,
            header = "Cidadão",
            txt = "Informações do cidadão",
            params = {
                event = "policia:cidadao"
            }
        },
        {
            id = 3,
            header = "Faturas",
            txt = "Enviar uma fatura",
            params = {
                event = "policia:factura"
            }
        },
    }) -- MENU F6
end)
RegisterNetEvent('policia-general', function()
    TriggerEvent('nh-context:sendMenu', {
        {
            id = 1,
            header = "Menu Geral Mecânico",
            txt = "",
        },
      

        {
            id = 2,
            header = "Armamento",
            txt = "Armas da polícia",
            params = {
                event = "policia-armamento",
                args = {
                    outfits = "policia-armamento"
                }
            }
        },       
        {
            id = 3,
            header = "Outfit de Trabalho",
            txt = "Fardamentos da Polícia",
            params = {
                event = "policia-roupas",
                args = {
                    outfits = "policia-roupas"
                }
            }
        },
        {
            id = 4,
            header = "Colocar Items",
            txt = "Armazém dos mecânicos",
            params = {
                event = "policia:inventario",
                args = {
                    invOpcion = "meter"
                }
            }
        },
        {
            id = 5,
            header = "Retirar Items",
            txt = "Armazém dos mecânicos",
            params = {
                event = "policia:inventario",
                args = {
                    invOpcion = "sacar"
                }
            }
        },
        {
            id = 6,
            header = "Empresa",
            txt = "Sobre a tua empresa",
            params = {
                event = "policia:sociedad"
            }
        },

        {
            id = 7,
            header = "Serviço",
            txt = "Sair e entrar de serviço",
            params = {
                event = "policia:servico"
            }
        },

    })
end)
RegisterNetEvent('policia-roupas', function()
    TriggerEvent('nh-context:sendMenu', {
        {
            id = 1,
            header = "Menu de Roupas da Polícia",
            txt = "",
        },
      
        {
            id = 2,
            header = "Roupas",
            txt = "Vestuário de Recruta",
            params = {
                event = "policia:roupa1",
                args  = {
                  outfits  =   "rouparecruta"
                }
            }
        },
        {
            id = 3,
            header = "Roupas",
            txt = "Vestuário de Agente",
            params = {
                event = "policia:roupa1",
                args  = {
                  outfits  =   "roupaagente"
                }
            }
        },   
        {
            id = 4,
            header = "Roupas",
            txt = "Vestuário de GOE",
            params = {
                event = "policia:roupa1",
                args  = {
                  outfits  =   "roupagoe"
                }
            }
        },  
        {
            id = 5,
            header = "Roupas",
            txt = "Vestuário de Mota",
            params = {
                event = "policia:roupa1",
                args  = {
                  outfits  =   "roupamota"
                }
            }
        }, 
        {
            id = 6,
            header = "Roupas",
            txt = "Vestuário de Coordenador",
            params = {
                event = "policia:roupa1",
                args  = {
                  outfits  =   "roupacord"
                }
            }
        }, 
        {
            id = 7,
            header = "Roupas",
            txt = "Vestuário de Helicóptero",
            params = {
                event = "policia:roupa1",
                args  = {
                  outfits  =   "roupaheli"
                }
            }
        },  
        {
            id = 8,
            header = "Roupas",
            txt = "Vestuário de Superior",
            params = {
                event = "policia:roupa1",
                args  = {
                  outfits  =   "roupasuperior"
                }
            }
        },  
        {
            id = 9,
            header = "Roupas",
            txt = "Vestuário de Superior",
            params = {
                event = "policia:roupa1",
                args  = {
                  outfits  =   "roupadiretor"
                }
            }
        },  
        {
            id = 10,
            header = "Coletes",
            txt = "Vestuário de Coletes",
            params = {
                event = "policia-coletes",
            }
        },   
        {
            id = 11,
            header = "Voltar",
            txt = "Voltar ao menu anterior",
            params = {
                event = "policia-general",
            }
        },                                                        
    })
end)
RegisterNetEvent('policia-coletes', function()
    TriggerEvent('nh-context:sendMenu', {
        {
            id = 1,
            header = "Menu de Coletes da Polícia",
            txt = "",
        },
      
        {
            id = 2,
            header = "Coletes da Polícia",
            txt = "Vestuário de Colete Normal",
            params = {
                event = "policia:roupa1",
                args  = {
                  outfits  =   "coletenormal"
                }
            }
        },
        {
            id = 3,
            header = "Coletes da Polícia",
            txt = "Vestuário de Coldre da Polícia",
            params = {
                event = "policia:roupa1",
                args  = {
                  outfits  =   "coldre"
                }
            }
        },
        {
            id = 4,
            header = "Voltar",
            txt = "Voltar ao menu anterior",
            params = {
                event = "policia-roupas",
            }
        },                                                                
    })
end)
RegisterNetEvent('policia-armamento', function()
    TriggerEvent('nh-context:sendMenu', {
        {
            id = 1,
            header = "Menu de Armamento",
            txt = "",
        },
        {
            id = 2,
            header = "Pistola de Taser",
            txt = "Obter Pistola de Taser",
            params = {
                event = "policia:arma1"
            }
        },
        {
            id = 3,
            header = "Pistola Normal",
            txt = "Obter Pistola Normal",
            params = {
                event = "policia:arma2"
            }
        },
        {
            id = 4,
            header = "Pistola SMG",
            txt = "Obter Pistola SMG",
            params = {
                event = "policia:arma3"
            }
        },
        {
            id = 5,
            header = "Pistola Caçaceira",
            txt = "Obter Pistola Caçaceira",
            params = {
                event = "policia:arma4"
            }
        }, 
        {
            id = 6,
            header = "Pistola Caçaceira Tática",
            txt = "Obter Pistola Caçaceira Tática",
            params = {
                event = "policia:arma5"
            }
        },  
        {
            id = 7,
            header = "Pistola M4A4",
            txt = "Obter Pistola M4A4",
            params = {
                event = "policia:arma6"
            }
        },  
        {
            id = 8,
            header = "Pistola Sniperrifle",
            txt = "Obter Pistola Sniperrifle",
            params = {
                event = "policia:arma7"
            }
        },  
        {
            id = 9,
            header = "Voltar",
            txt = "Voltar ao menu anterior",
            params = {
                event = "policia-general"
            }
        },                                  
    })
end)
RegisterNetEvent('policia-veiculos', function()
    TriggerEvent('nh-context:sendMenu', {
        {
            id = 0,
            header = 'Veículos da Polícia',
            txt = ''
        },
        {
            id = 1,
            header = "Veículos da Polícia Normais",
            txt = 'Abrir menu veículos da polícia normais',
            params = {
                event = "policia-veiculosnormais",
            }
        },                          
        {
            id = 2,
            header = "Veículo da Patrulha",
            txt = 'Abrir menu de veículos de patrulha',
            params = {
                event = "policia-veiculospatrulha",
            }
        },
        {
            id = 3,
            header = "Motas da Polícia",
            txt = 'Abrir menu de motas da polícia',
            params = {
                event = "policia-motas",
            }
        },        
    })
end)
RegisterNetEvent('policia-veiculosnormais', function()
    TriggerEvent('nh-context:sendMenu', {
        {
            id = 0,
            header = 'Veículos da Polícia',
            txt = ''
        },
        {
            id = 1,
            header = "Veículo da Polícia",
            txt = 'Carrinha Transporte Prisão',
            params = {
                event = "policia:carro",
                args = {
                    carro = 'pbus'
                }
            }
        },
        {
            id = 2,
            header = "Veículo da Polícia",
            txt = 'Jipe Wrangler',
            params = {
                event = "policia:carro",
                args = {
                    carro = 'wrangler_psp'
                }
            }
        },
        {
            id = 3,
            header = "Veículo da Polícia",
            txt = 'Carrinha de Comunicações',
            params = {
                event = "policia:carro",
                args = {
                    carro = 'benson'
                }
            }
        },
        {
            id = 4,
            header = "Veículo da Polícia",
            txt = 'Mercedes Amg Gt63',
            params = {
                event = "policia:carro",
                args = {
                    carro = 'rmodgt63police'
                }
            }
        }, 
        {
            id = 5,
            header = "Veículo da Polícia",
            txt = 'BMW I8',
            params = {
                event = "policia:carro",
                args = {
                    carro = 'gnr_i8'
                }
            }
        },  
        {
            id = 6,
            header = "Veículo da Polícia",
            txt = 'Blindado',
            params = {
                event = "policia:carro",
                args = {
                    carro = 'riot'
                }
            }
        },   
        {
            id = 7,
            header = "Veículo da Polícia",
            txt = 'Carrinha de Intervençao',
            params = {
                event = "policia:carro",
                args = {
                    carro = 'pspt'
                }
            }
        },        
        {
            id = 8,
            header = "Veículo da Polícia",
            txt = 'Audi R8',
            params = {
                event = "policia:carro",
                args = {
                    carro = 'policer8'
                }
            }
        },                           
        {
            id = 9,
            header = "Voltar",
            txt = 'Voltar ao menu dos veículos da polícia',
            params = {
                event = "policia-veiculos",
            }
        },        
    })
end)
RegisterNetEvent('policia-veiculospatrulha', function()
    TriggerEvent('nh-context:sendMenu', {
        {
            id = 0,
            header = 'Veículos da Polícia de Patrulha',
            txt = ''
        },
        {
            id = 1,
            header = "Veículo da Polícia",
            txt = 'Carro Fiat [Patrulha]',
            params = {
                event = "policia:carro",
                args = {
                    carro = 'psp_ftipo2'
                }
            }
        },
        {
            id = 2,
            header = "Veículo da Polícia",
            txt = 'Carro Maserati [Patrulha]',
            params = {
                event = "policia:carro",
                args = {
                    carro = 'ghispo2'
                }
            }
        },
        {
            id = 3,
            header = "Veículo da Polícia",
            txt = 'Carro Bmw 530 [Patrulha]',
            params = {
                event = "policia:carro",
                args = {
                    carro = 'pspt_530d'
                }
            }
        },
        {
            id = 4,
            header = "Voltar",
            txt = 'Voltar aos veiculos normais da polícia',
            params = {
                event = "policia-veiculos",
            }
        },        
    })
end)
RegisterNetEvent('policia-motas', function()
    TriggerEvent('nh-context:sendMenu', {
        {
            id = 0,
            header = 'Veículos da Polícia de Patrulha',
            txt = ''
        },
        {
            id = 1,
            header = "Mota da Polícia",
            txt = 'Mota da Polícia [Perseguição]',
            params = {
                event = "policia:carro",
                args = {
                    carro = 'policeb'
                }
            }
        },
        {
            id = 2,
            header = "Mota da Polícia",
            txt = 'Mota da Polícia [Patrulha]',
            params = {
                event = "policia:carro",
                args = {
                    carro = 'psp_bmwgs'
                }
            }
        },
        {
            id = 3,
            header = "Mota da Polícia",
            txt = 'Mota da Polícia [Cross]',
            params = {
                event = "policia:carro",
                args = {
                    carro = 'sanchez'
                }
            }
        },
        {
            id = 4,
            header = "Voltar",
            txt = 'Voltar aos veiculos normais da polícia',
            params = {
                event = "policia-veiculos",
            }
        },        
    })
end)
-- Armamento
RegisterNetEvent('policia:arma1')
AddEventHandler('policia:arma1', function(data)
    local player = PlayerPedId()
    local coords    = GetEntityCoords(playerPed)
    TriggerServerEvent('policia:arma1')
    exports['mythic_notify']:DoHudText('inform', '👮🏼‍| Polícia: Recebeste um Pistola de Tazer')
end)
RegisterNetEvent('policia:arma2')
AddEventHandler('policia:arma2', function(data)
    local player = PlayerPedId()
    local coords    = GetEntityCoords(playerPed)
    TriggerServerEvent('policia:arma2')
    exports['mythic_notify']:DoHudText('inform', '👮🏼‍| Polícia: Recebeste uma Pistola Normal')
end)
RegisterNetEvent('policia:arma3')
AddEventHandler('policia:arma3', function(data)
    local player = PlayerPedId()
    local coords    = GetEntityCoords(playerPed)
    TriggerServerEvent('policia:arma3')
    exports['mythic_notify']:DoHudText('inform', '👮🏼‍| Polícia: Recebeste uma Pistola SMG')
end)
RegisterNetEvent('policia:arma4')
AddEventHandler('policia:arma4', function(data)
    local player = PlayerPedId()
    local coords    = GetEntityCoords(playerPed)
    TriggerServerEvent('policia:arma4')
    exports['mythic_notify']:DoHudText('inform', '👮🏼‍| Polícia: Recebeste uma Pistola Caçaceira')
end)
RegisterNetEvent('policia:arma5')
AddEventHandler('policia:arma5', function(data)
    local player = PlayerPedId()
    local coords    = GetEntityCoords(playerPed)
    TriggerServerEvent('policia:arma5')
    exports['mythic_notify']:DoHudText('inform', '👮🏼‍| Polícia: Recebeste uma Pistola Caçaceira Tática')
end)
RegisterNetEvent('policia:arma6')
AddEventHandler('policia:arma6', function(data)
    local player = PlayerPedId()
    local coords    = GetEntityCoords(playerPed)
    TriggerServerEvent('policia:arma6')
    exports['mythic_notify']:DoHudText('inform', '👮🏼‍| Polícia: Recebeste uma Pistola M4A4')
end)
RegisterNetEvent('policia:arma7')
AddEventHandler('policia:arma7', function(data)
    local player = PlayerPedId()
    local coords    = GetEntityCoords(playerPed)
    TriggerServerEvent('policia:arma7')
    exports['mythic_notify']:DoHudText('inform', '👮🏼‍| Polícia: Recebeste uma Pistola Sniperrifle')
end)
-- Entrar e sair de serviço
RegisterNetEvent('policia:servico')
AddEventHandler('policia:servico', function(data)
    if PlayerData.job.name == 'police' or PlayerData.job.name == 'offpolice' then
        TriggerServerEvent('duty:police')
    if PlayerData.job.name == 'police' then
        exports['mythic_notify']:DoHudText('inform', '👮🏼‍| Polícia: Saíste de serviço')
        Wait(1000)
    else
        exports['mythic_notify']:DoHudText('inform', '👮🏼‍| Polícia: Entraste de serviço')
        Wait(1000)
        end
    else
        exports['mythic_notify']:DoHudText('inform', '👮🏼‍| Polícia: Não pertences ao nosso departamento')
        Wait(1000)
    end
end)
-- Menu de Cidadão
RegisterNetEvent('policia:cidadao')
AddEventHandler('policia:cidadao', function(data)


    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'police_actions', {
        title    = 'Menu da Polícia',
        align    = 'right',
        elements = {
            {label = 'Interagir com o cidadão', value = 'citizen_interaction'},
            {label = 'Interagir com o veículo', value = 'vehicle_interaction'},
            {label = 'Interagir com a ciclovia', value = 'object_spawner'}
    }}, function(data, menu)
        if data.current.value == 'citizen_interaction' then
            local elements = {
                {label = 'Cartão de Cidadão', value = 'identity_card'},
                {label = 'Revistar o Cidadão', value = 'search'},
                {label = 'Algemar o Cidadão', value = 'handcuff'},
                {label = 'Arrastar o Cidadão', value = 'drag'},
                {label = 'Colocar no Veículo', value = 'put_in_vehicle'},
                {label = 'Retirar do Veículo', value = 'out_the_vehicle'},
                {label = 'Passar uma Multa', value = 'fine'},
                {label = 'Verificar multas do Cidadão', value = 'unpaid_bills'}
            }

            if Config.EnableLicenses then
                table.insert(elements, {label = 'Verificar Licenças', value = 'license'})
            end

            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction', {
                title    = 'Interagir com o cidadão',
                align    = 'right',
                elements = elements
            }, function(data2, menu2)
                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                if closestPlayer ~= -1 and closestDistance <= 3.0 then
                    local action = data2.current.value

                    if action == 'identity_card' then
                        OpenIdentityCardMenu(closestPlayer)
                    elseif action == 'search' then
                        OpenBodySearchMenu(closestPlayer)
                    elseif action == 'handcuff' then
                        TriggerServerEvent('sky_policia:handcuff', GetPlayerServerId(closestPlayer))
                    elseif action == 'drag' then
                        TriggerServerEvent('sky_policia:drag', GetPlayerServerId(closestPlayer))
                    elseif action == 'put_in_vehicle' then
                        TriggerServerEvent('sky_policia:putInVehicle', GetPlayerServerId(closestPlayer))
                    elseif action == 'out_the_vehicle' then
                        TriggerServerEvent('sky_policia:OutVehicle', GetPlayerServerId(closestPlayer))
                    elseif action == 'fine' then
                        OpenFineMenu(closestPlayer)
                    elseif action == 'license' then
                        ShowPlayerLicense(closestPlayer)
                    elseif action == 'unpaid_bills' then
                        OpenUnpaidBillsMenu(closestPlayer)
                    end
                else
                    exports['mythic_notify']:DoHudText('error', 'Sem jogadores por perto')
                end
            end, function(data2, menu2)
                menu2.close()
            end)
        elseif data.current.value == 'vehicle_interaction' then
            local elements  = {}
            local playerPed = PlayerPedId()
            local vehicle = ESX.Game.GetVehicleInDirection()

            if DoesEntityExist(vehicle) then
                table.insert(elements, {label = 'Informações do Veículo', value = 'vehicle_infos'})
                table.insert(elements, {label = 'Destrancar o Veículo', value = 'hijack_vehicle'})
                table.insert(elements, {label = 'Apreender o Veículo', value = 'impound'})
            end

            table.insert(elements, {label = 'Procurar na base de dados', value = 'search_database'})

            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_interaction', {
                title    = 'Interagir com o Veículo',
                align    = 'right',
                elements = elements
            }, function(data2, menu2)
                local coords  = GetEntityCoords(playerPed)
                vehicle = ESX.Game.GetVehicleInDirection()
                action  = data2.current.value

                if action == 'search_database' then
                    LookupVehicle()
                elseif DoesEntityExist(vehicle) then
                    if action == 'vehicle_infos' then
                        local vehicleData = ESX.Game.GetVehicleProperties(vehicle)
                        OpenVehicleInfosMenu(vehicleData)
                    elseif action == 'hijack_vehicle' then
                        if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 3.0) then
                            TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_WELDING', 0, true)
                            Citizen.Wait(20000)
                            ClearPedTasksImmediately(playerPed)

                            SetVehicleDoorsLocked(vehicle, 1)
                            SetVehicleDoorsLockedForAllPlayers(vehicle, false)
                            exports['mythic_notify']:DoHudText('inform', 'Veículo destrancado')
                        end
                    elseif action == 'impound' then
                        -- is the script busy?
                        if currentTask.busy then
                            return
                        end
                        exports['mythic_notify']:DoHudText('inform', 'Pressiona [X] para cancelar a apreensão')
                        TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)

                        currentTask.busy = true
                        currentTask.task = ESX.SetTimeout(10000, function()
                            ClearPedTasks(playerPed)
                            ImpoundVehicle(vehicle)
                            Citizen.Wait(100) -- sleep the entire script to let stuff sink back to reality
                        end)

                        -- keep track of that vehicle!
                        Citizen.CreateThread(function()
                            while currentTask.busy do
                                Citizen.Wait(1000)

                                vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 3.0, 0, 71)
                                if not DoesEntityExist(vehicle) and currentTask.busy then
                                    exports['mythic_notify']:DoHudText('inform', 'A apreensão foi cancelada')
                                    ESX.ClearTimeout(currentTask.task)
                                    ClearPedTasks(playerPed)
                                    currentTask.busy = false
                                    break
                                end
                            end
                        end)
                    end
                else
                    exports['mythic_notify']:DoHudText('error', 'Nenhum veículo por perto')
                end

            end, function(data2, menu2)
                menu2.close()
            end)
        elseif data.current.value == 'object_spawner' then
            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction', {
                title    = 'Interagir com a Ciclovia',
                align    = 'right',
                elements = {
                    {label = 'Cone', model = 'prop_roadcone02a'},
                    {label = 'Barreira', model = 'prop_barrier_work05'},
                    {label = 'Picos', model = 'p_ld_stinger_s'},
                    {label = 'Caixa', model = 'prop_boxpile_07d'},
                    {label = 'Dinheiro', model = 'hei_prop_cash_crate_half_full'}
            }}, function(data2, menu2)
                local playerPed = PlayerPedId()
                local coords, forward = GetEntityCoords(playerPed), GetEntityForwardVector(playerPed)
                local objectCoords = (coords + forward * 1.0)

                ESX.Game.SpawnObject(data2.current.model, objectCoords, function(obj)
                    SetEntityHeading(obj, GetEntityHeading(playerPed))
                    PlaceObjectOnGroundProperly(obj)
                end)
            end, function(data2, menu2)
                menu2.close()
            end)
        end
    end, function(data, menu)
        menu.close()
    end)
end)
RegisterNetEvent('sky_policia:handcuff') --algemar
AddEventHandler('sky_policia:handcuff', function()
    isHandcuffed = not isHandcuffed
    local playerPed = PlayerPedId()

    if isHandcuffed then
        RequestAnimDict('mp_arresting')
        while not HasAnimDictLoaded('mp_arresting') do
            Citizen.Wait(100)
        end

        TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)

        SetEnableHandcuffs(playerPed, true)
        DisablePlayerFiring(playerPed, true)
        SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true) -- unarm player
        SetPedCanPlayGestureAnims(playerPed, false)
        DisplayRadar(false)

        if Config.EnableHandcuffTimer then
            if HandcuffTimer.active then
                ESX.ClearTimeout(HandcuffTimer.task)
            end

            StartHandcuffTimer()
        end
    else
        if Config.EnableHandcuffTimer and HandcuffTimer.active then
            ESX.ClearTimeout(HandcuffTimer.task)
        end

        ClearPedSecondaryTask(playerPed)
        SetEnableHandcuffs(playerPed, false)
        DisablePlayerFiring(playerPed, false)
        SetPedCanPlayGestureAnims(playerPed, true)
        DisplayRadar(true)
    end
end)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()

        if isHandcuffed then
            DisableControlAction(2, 1, true) -- Disable pan
            DisableControlAction(2, 2, true) -- Disable tilt
            DisableControlAction(2, 24, true) -- Attack
            DisableControlAction(2, 257, true) -- Attack 2
            DisableControlAction(2, 25, true) -- Aim
            DisableControlAction(2, 263, true) -- Melee Attack 1
            DisableControlAction(2, Keys['R'], true) -- Reload
            DisableControlAction(2, Keys['TOP'], true) -- Open phone (not needed?)
            DisableControlAction(2, Keys['SPACE'], true) -- Jump
            DisableControlAction(0, Keys['LEFTSHIFT'], true) -- Jump
            DisableControlAction(2, Keys['Q'], true) -- Cover
            DisableControlAction(2, Keys['TAB'], true) -- Select Weapon
            DisableControlAction(2, Keys['F'], true) -- Also 'enter'?
            DisableControlAction(2, Keys['F1'], true) -- Disable phone
            DisableControlAction(2, Keys['F2'], true) -- Inventory
            DisableControlAction(1, 323, true) -- Inventory
            DisableControlAction(1, 303, true) -- Inventory
            DisableControlAction(2, Keys['F3'], true) -- Animations
            DisableControlAction(2, Keys['F6'], true) -- F6
            DisableControlAction(2, Keys['V'], true) -- Disable changing view
            DisableControlAction(2, Keys['P'], true) -- Disable pause screen
            DisableControlAction(2, 59, true) -- Disable steering in vehicle
            DisableControlAction(2, Keys['LEFTCTRL'], true) -- Disable going stealth
            DisableControlAction(0, 47, true)  -- Disable weapon
            DisableControlAction(0, 264, true) -- Disable melee
            DisableControlAction(0, 257, true) -- Disable melee
            DisableControlAction(0, 140, true) -- Disable melee
            DisableControlAction(0, 141, true) -- Disable melee
            DisableControlAction(0, 142, true) -- Disable melee
            DisableControlAction(0, 143, true) -- Disable melee
            DisableControlAction(0, 75, true)  -- Disable exit vehicle
            DisableControlAction(27, 75, true) -- Disable exit vehicle

            if IsEntityPlayingAnim(playerPed, 'mp_arresting', 'idle', 3) ~= 1 then
                ESX.Streaming.RequestAnimDict('mp_arresting', function()
                    TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
                end)
            end
        else
            Citizen.Wait(500)
        end
    end --algemar
end)
RegisterNetEvent('sky_policia:unrestrain') -- desalgemar
AddEventHandler('sky_policia:unrestrain', function()
    if isHandcuffed then
        local playerPed = PlayerPedId()
        isHandcuffed = false

        ClearPedSecondaryTask(playerPed)
        SetEnableHandcuffs(playerPed, false)
        DisablePlayerFiring(playerPed, false)
        SetPedCanPlayGestureAnims(playerPed, true)
        FreezeEntityPosition(playerPed, false)
        DisplayRadar(true)

        -- end timer
        if Config.EnableHandcuffTimer and HandcuffTimer.active then
            ESX.ClearTimeout(HandcuffTimer.task)
        end
    end
end)
RegisterNetEvent('sky_policia:drag') -- arrastar
AddEventHandler('sky_policia:drag', function(copId)
    if isHandcuffed then
        dragStatus.isDragged = not dragStatus.isDragged
        dragStatus.CopId = copId
    end
end)
Citizen.CreateThread(function()
    local wasDragged

    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()

        if isHandcuffed and dragStatus.isDragged then
            local targetPed = GetPlayerPed(GetPlayerFromServerId(dragStatus.CopId))

            if DoesEntityExist(targetPed) and IsPedOnFoot(targetPed) and not IsPedDeadOrDying(targetPed, true) then
                if not wasDragged then
                    AttachEntityToEntity(playerPed, targetPed, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
                    wasDragged = true
                else
                    Citizen.Wait(1000)
                end
            else
                wasDragged = false
                dragStatus.isDragged = false
                DetachEntity(playerPed, true, false)
            end
        elseif wasDragged then
            wasDragged = false
            DetachEntity(playerPed, true, false)
        else
            Citizen.Wait(500)
        end
    end -- arrastar
end)
RegisterNetEvent('sky_policia:putInVehicle') -- colocar no veículo
AddEventHandler('sky_policia:putInVehicle', function()
    if isHandcuffed then
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)

        if IsAnyVehicleNearPoint(coords, 5.0) then
            local vehicle = GetClosestVehicle(coords, 5.0, 0, 71)

            if DoesEntityExist(vehicle) then
                local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(vehicle)

                for i=maxSeats - 1, 0, -1 do
                    if IsVehicleSeatFree(vehicle, i) then
                        freeSeat = i
                        break
                    end
                end

                if freeSeat then
                    TaskWarpPedIntoVehicle(playerPed, vehicle, freeSeat)
                    dragStatus.isDragged = false
                end
            end
        end
    end
end)
RegisterNetEvent('sky_policia:OutVehicle') -- retirar do veículo
AddEventHandler('sky_policia:OutVehicle', function()
    local playerPed = PlayerPedId()

    if IsPedSittingInAnyVehicle(playerPed) then
        local vehicle = GetVehiclePedIsIn(playerPed, false)
        TaskLeaveVehicle(playerPed, vehicle, 64)
    end
end)
-- Funções
function OpenIdentityCardMenu(player) -- Abrir cartão de cidadão
    ESX.TriggerServerCallback('sky_policia:getOtherPlayerData', function(data)
        local sexo = 0

        local elements = {
            {label = 'Nome:', ': ' ..data.firstname .. ' ' .. data.lastname},
            {label = 'Trabalho:', ('%s'):format(data.job)}
        }

        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin) 
            if skin.sex ~= 0 then sexo = 1 end
        end)

        if Config.EnableESXIdentity then
            if sexo == 0 then
            table.insert(elements, {label = 'Sexo:', 'Masculino'})
            else
            table.insert(elements, {label = 'Sexo', 'Feminino'}) 
            end
            table.insert(elements, {label = 'Crimes:', data.dob})
            table.insert(elements, {label = 'Altura:', data.height})
        end

        if data.drunk then
            table.insert(elements, {label = 'Bac:', data.drunk})
        end

        if data.licenses then
            table.insert(elements, {label = 'Licenças:'})

            for i=1, #data.licenses, 1 do
                table.insert(elements, {label = data.licenses[i].label})
            end
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction', {
            title    = 'Intera com o Cidadão',
            align    = 'right',
            elements = elements
        }, nil, function(data, menu)
            menu.close()
        end)
    end, GetPlayerServerId(player))
end
function OpenBodySearchMenu(player) -- Revistar o jogador
    TriggerEvent("esx_inventoryhud:openPlayerInventory", GetPlayerServerId(player), GetPlayerName(player))
end
function OpenFineCategoryMenu(player, category)

    ESX.TriggerServerCallback('sky_policia:getFineList', function(fines)
  
      local elements = {}
  
      for i=1, #fines, 1 do
        table.insert(elements, {
          label     = fines[i].label .. ' <span style="color: green;">' .. fines[i].amount .. '€</span>',
          value     = fines[i].id,
          amount    = fines[i].amount,
          fineLabel = fines[i].label
        })
      end
  
      ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'fine_category',
        {
          title    = 'Multas',
          align    = 'right',
          elements = elements,
        },
        function(data, menu)
  
          local label  = data.current.fineLabel
          local amount = data.current.amount
  
          menu.close()
  
          if Config.EnablePlayerManagement then
            TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'society_police', 'Total da multa:', label, amount)
          else
            TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), '', 'Total da multa:', label, amount)
          end
  
          ESX.SetTimeout(300, function()
            OpenFineCategoryMenu(player, category)
          end)
  
        end,
        function(data, menu)
          menu.close()
        end
      )
  
    end, category)
  
  end  -- Abrir categorias de multas
function LookupVehicle()
    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'lookup_vehicle', {
        title = 'Verificar Matrícula na BD',
    }, function(data, menu)
        local length = string.len(data.value)
        if not data.value or length < 2 or length > 8 then
            exports['mythic_notify']:DoHudText('error', 'Matrícula inválida')      
        else
            ESX.TriggerServerCallback('sky_policia:getVehicleInfos', function(retrivedInfo)
                local elements = {{label = 'Matrícula:', retrivedInfo.plate}}
                menu.close()

                if not retrivedInfo.owner then
                    table.insert(elements, {label = 'Não tem dono'})
                else
                    table.insert(elements, {label = 'Dono:', retrivedInfo.owner})
                end

                ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_infos', {
                    title    = 'Informações do Veículo',
                    align    = 'right',
                    elements = elements
                }, nil, function(data2, menu2)
                    menu2.close()
                end)
            end, data.value)

        end
    end, function(data, menu)
        menu.close()
    end)  
end-- Informações dos veículo
function ShowPlayerLicense(player) -- Ver livenças / revogar licenças
    local elements = {}

    ESX.TriggerServerCallback('sky_policia:getOtherPlayerData', function(playerData)
        if playerData.licenses then
            for i=1, #playerData.licenses, 1 do
                if playerData.licenses[i].label and playerData.licenses[i].type then
                    table.insert(elements, {
                        label = playerData.licenses[i].label,
                        type = playerData.licenses[i].type
                    })
                end
            end
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_license', {
            title    = 'Revogar Licenças',
            align    = 'right',
            elements = elements,
        }, function(data, menu)
            ESX.ShowNotification('Revogaste a: ', data.current.label, playerData.name)
            TriggerServerEvent('sky_policia:message', GetPlayerServerId(player), _U('license_revoked', data.current.label))

            TriggerServerEvent('esx_license:removeLicense', GetPlayerServerId(player), data.current.type)

            ESX.SetTimeout(300, function()
                ShowPlayerLicense(player)
            end)
        end, function(data, menu)
            menu.close()
        end)

    end, GetPlayerServerId(player))
end
function OpenUnpaidBillsMenu(player) -- Ver multas por pagar
    local elements = {}

    ESX.TriggerServerCallback('esx_billing:getTargetBills', function(bills)
        for i=1, #bills, 1 do
            table.insert(elements, {label = "[" .. bills[i].data .. "] " .. bills[i].label .. ' - <span style="color: red;">' .. bills[i].amount .. '€</span>', value = bills[i].id})
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'billing',
        {
            title    = 'Multas por Pagar',
            align    = 'right',
            elements = elements
        }, function(data, menu)
    
        end, function(data, menu)
            menu.close()
        end)
    end, GetPlayerServerId(player))
end
function OpenVehicleInfosMenu(vehicleData) -- Ver informações dos veículos
    ESX.TriggerServerCallback('sky_policia:getVehicleInfos', function(retrivedInfo)
        local elements = {{label = 'Matrícula:', retrivedInfo.plate}}

        if not retrivedInfo.owner then
            table.insert(elements, {label = 'Sem dono'})
        else
            table.insert(elements, {label = 'Dono:', retrivedInfo.owner})
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_infos', {
            title    = 'Informações do Veículo',
            align    = 'right',
            elements = elements
        }, nil, function(data, menu)
            menu.close()
        end)
    end, vehicleData.plate)
end
function StartHandcuffTimer()
    if Config.EnableHandcuffTimer and HandcuffTimer.active then
        ESX.ClearTimeout(HandcuffTimer.task)
    end

    HandcuffTimer.active = true

    HandcuffTimer.task = ESX.SetTimeout(Config.HandcuffTimer, function()
        exports['mythic_notify']:DoHudText('inform', 'Parece que as alegemas estão a escorregar')    
        TriggerEvent('sky_policia:unrestrain')
        HandcuffTimer.active = false
    end) -- Tempo do algemar
end
function Porte(closestPlayer) -- Tirar porte de arma
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'portearma', {
        title = 'Confirma a emissão a: ' ..GetPlayerName(closestPlayer).. ' ?',
        align = 'right',
        elements = {
            {label = 'Não confirmar', value = 'no' },
            {label = 'Confirmar', value = 'yes' },
        }
    }, function(data, menu)
        if data.current.value =='no' then
            menu.close()
            exports['mythic_notify']:DoHudText('inform', 'Não emitiste a licença')            
        end
        if data.current.value == 'yes' then
            ESX.TriggerServerCallback('esx_license:checkLicense', function(hasWeaponLicense)
                if hasWeaponLicense then
                    exports['mythic_notify']:DoHudText('inform', 'Licença Emitida ao: '..GetPlayerName(closestPlayer))
                    TriggerServerEvent('esx_license:addLicense', GetPlayerServerId(closestPlayer), 'weapon')
                    TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_police', 'Licença Porte de Armas', 40000)
                else
                    exports['mythic_notify']:DoHudText('inform', 'Licença Psicotécnica não encontrada')                    
                end
            end, GetPlayerServerId(closestPlayer), 'psico')
        end
    end, function(data, menu)
        ESX.UI.Menu.CloseAll()
    end)
end
function ImpoundVehicle(vehicle) -- Apreensão de véiculo
    ESX.Game.DeleteVehicle(vehicle)
    exports['mythic_notify']:DoHudText('inform', 'Apreendeste o veículo')
    currentTask.busy = false
end
function SendToCommunityService(player) -- Enviar comunitário
    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'Community Service Menu', {
        title = "Serviço Comunitário",
    }, function (data2, menu)
        local community_services_count = tonumber(data2.value)
        
        if community_services_count == nil then
            exports['mythic_notify']:DoHudText('inform', 'Contagem de serviços inválida')        
        else
            TriggerServerEvent("esx_communityservice:sendToCommunityService", player, community_services_count)
            menu.close()
        end
    end, function (data2, menu)
        menu.close()
    end)
end
function CargarAnim(animDict)
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Citizen.Wait(10)
    end
end
function CargarModelo(model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Citizen.Wait(10)
    end
end
OpenPutStocksMenu = function()
    ESX.TriggerServerCallback('sky_policia:getPlayerInventory', function(inventory)
        local elements = {}

        for i=1, #inventory.items, 1 do
            local item = inventory.items[i]

            if item.count > 0 then
                table.insert(elements, {
                    label = item.label .. ' x' .. item.count,
                    type = 'item_standard',
                    value = item.name
                })
            end
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
            title    = 'Inventario',
            align    = 'bottom-right',
            elements = elements
        }, function(data, menu)
            local itemName = data.current.value

            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count', {
                title = 'Cantidad'
            }, function(data2, menu2)
                local count = tonumber(data2.value)

                if count == nil then
                    exports['mythic_notify']:DoHudText('inform', '👮🏼‍| Polícia: Quantidade inválida')
                else
                    menu2.close()
                    menu.close()
                    TriggerServerEvent('sky_policia:putStockItems', itemName, count)

                    Citizen.Wait(300)
                    OpenPutStocksMenu()
                end
            end, function(data2, menu2)
                menu2.close()
            end)
        end, function(data, menu)
            menu.close()
        end)
    end)
end
OpenGetStocksMenu = function()
    ESX.TriggerServerCallback('sky_policia:getStockItems', function(items)
        local elements = {}

        for i=1, #items, 1 do
            table.insert(elements, {
                label = 'x' .. items[i].count .. ' ' .. items[i].label,
                value = items[i].name
            })
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
            title    = 'Armazém',
            align    = 'bottom-right',
            elements = elements
        }, function(data, menu)
            local itemName = data.current.value

            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count', {
                title = 'Cantidad'
            }, function(data2, menu2)
                local count = tonumber(data2.value)

                if count == nil then
                    exports['mythic_notify']:DoHudText('inform', '👮🏼‍| Polícia: Quantidade inválida')
                else
                    menu2.close()
                    menu.close()
                    TriggerServerEvent('sky_policia:getStockItem', itemName, count)

                    Citizen.Wait(1000)
                    OpenGetStocksMenu()
                end
            end, function(data2, menu2)
                menu2.close()
            end)
        end, function(data, menu)
            menu.close()
        end)
    end)
end
function draweTxt(x,y ,width,height,scale, text, r,g,b,a)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(2, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end
-- Eventos --
RegisterNetEvent('policia:carro')
AddEventHandler('policia:carro', function(data)
    local carro = data.carro
    local playerPed = PlayerPedId()
    local coords    = GetEntityCoords(playerPed)
    for k,v in pairs(Config.SpawnVeiculo) do
        Citizen.Wait(0)
        if carro == 'bison2' and PlayerData.job.grade_name == 'boss' then
            DoScreenFadeOut(500)

            ESX.Game.SpawnVehicle(carro, v, 177.85, function(vehicle)
                exports['mythic_notify']:DoHudText('inform', '👮🏼‍| Polícia: Retiraste o veículo da garagem com sucesso')
                ESX.Game.SetVehicleProperties(vehicle, {
                    plate = PlayerData.job.grade_name,
                })
                Citizen.Wait(2000)
                DoScreenFadeIn(2000)

                TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
            end)
            
        elseif carro ~= 'bison2' then
            DoScreenFadeOut(500)

            ESX.Game.SpawnVehicle(carro, v, 177.85, function(vehicle)
                exports['mythic_notify']:DoHudText('inform', '👮🏼‍| Polícia: Retiraste o veículo da garagem com sucesso')
                ESX.Game.SetVehicleProperties(vehicle, {
                    plate = PlayerData.job.grade_name,
                })
                Citizen.Wait(2000)
                DoScreenFadeIn(2000)

                TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
            end)

        else
            exports['mythic_notify']:DoHudText('inform', '👮🏼‍| Polícia: Não és o diretor da polícia')
        end
    end
end)

RegisterNetEvent('policia:roupa1') -- Roupas
AddEventHandler('policia:roupa1', function(data)
    local outfits = data.outfits

    if outfits == "rouparecruta" then
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
            if skin.sex == 0 then
                TriggerEvent('skinchanger:loadClothes', skin, {
                    sex      = 0,
                    tshirt_1 = 58,
                    tshirt_2 = 0,
                    arms     = 1,
                    torso_1  = 93,
                    torso_2  = 0,
                    pants_1  = 31,
                    pants_2  = 0,
                    shoes_1  = 25,
                    helmet_1 = 10
                })
            else
                TriggerEvent('skinchanger:loadClothes', skin, {
                    sex      = 1,
                    tshirt_1 = 0,
                    tshirt_2 = 0,
                    arms     = 1,
                    torso_1  = 44,
                    torso_2  = 0,
                    pants_1  = 6,
                    pants_2  = 0,
                    shoes_1  = 27
                })
                RequestModel(model)
                while not HasModelLoaded(model) do
                    RequestModel(model)
                    Citizen.Wait(0)
                end
                SetPlayerModel(PlayerId(), model)
                SetModelAsNoLongerNeeded(model)
            end
        end)
    elseif outfits == "roupaagente" then
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
            if skin.sex == 0 then
                TriggerEvent('skinchanger:loadClothes', skin, {
                    sex      = 0,
                    tshirt_1 = 58,
                    tshirt_2 = 0,
                    arms     = 0,
                    torso_1  = 97,
                    torso_2  = 0,
                    pants_1  = 31,
                    pants_2  = 0,
                    shoes_1  = 25,
                    helmet_1 = 10
                })
            else
                TriggerEvent('skinchanger:loadClothes', skin, {
                    sex      = 1,
                    tshirt_1 = 0,
                    tshirt_2 = 0,
                    arms     = 1,
                    torso_1  = 44,
                    torso_2  = 0,
                    pants_1  = 6,
                    pants_2  = 0,
                    shoes_1  = 27
                })
                RequestModel(model)
                while not HasModelLoaded(model) do
                    RequestModel(model)
                    Citizen.Wait(0)
                end
                SetPlayerModel(PlayerId(), model)
                SetModelAsNoLongerNeeded(model)
            end
        end)
    elseif outfits == "roupagoe" then
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
            if skin.sex == 0 then
                TriggerEvent('skinchanger:loadClothes', skin, {
                    sex      = 0,
                    tshirt_1 = 15,
                    tshirt_2 = 0,
                    arms     = 17,
                    torso_1  = 98,
                    torso_2  = 0,
                    pants_1  = 59,
                    pants_2  = 0,
                    shoes_1  = 24,
                    helmet_1 = 39,
                    mask_1   = 103,
                    chain_1  = 15,
                    bproof_1 = 8
                })
            else
                TriggerEvent('skinchanger:loadClothes', skin, {
                    sex      = 1,
                    tshirt_1 = 6,
                    tshirt_2 = 0,
                    arms     = 22,
                    torso_1  = 30,
                    torso_2  = 0,
                    pants_1  = 44,
                    pants_2  = 0,
                    shoes_1  = 28
                })
                RequestModel(model)
                while not HasModelLoaded(model) do
                    RequestModel(model)
                    Citizen.Wait(0)
                end
                SetPlayerModel(PlayerId(), model)
                SetModelAsNoLongerNeeded(model)
            end
        end)
    elseif outfits == "roupamota" then
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
            if skin.sex == 0 then
                TriggerEvent('skinchanger:loadClothes', skin, {
                    sex      = 0,
                    tshirt_1 = 15,
                    tshirt_2 = 0,
                    arms     = 22,
                    torso_1  = 14,
                    torso_2  = 0,
                    pants_1  = 31,
                    pants_2  = 0,
                    shoes_1  = 25,
                    helmet_1 = 8
                })
            else
                TriggerEvent('skinchanger:loadClothes', skin, {
                    sex      = 1,
                    tshirt_1 = 98,
                    tshirt_2 = 0,
                    arms     = 22,
                    torso_1  = 30,
                    torso_2  = 0,
                    pants_1  = 34,
                    pants_2  = 0,
                    shoes_1  = 25,
                    shoes_2  = 0
                })
                RequestModel(model)
                while not HasModelLoaded(model) do
                    RequestModel(model)
                    Citizen.Wait(0)
                end
                SetPlayerModel(PlayerId(), model)
                SetModelAsNoLongerNeeded(model)
            end
        end)
    elseif outfits == "roupacord" then
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
            if skin.sex == 0 then
                TriggerEvent('skinchanger:loadClothes', skin, {
                    sex      = 0,
                    tshirt_1 = 48,
                    tshirt_2 = 0,
                    arms     = 17,
                    torso_1  = 51,
                    torso_2  = 0,
                    pants_1  = 33,
                    pants_2  = 0,
                    shoes_1  = 25
                })
            else
                TriggerEvent('skinchanger:loadClothes', skin, {
                    sex      = 1,
                    tshirt_1 = 35,
                    tshirt_2 = 0,
                    arms     = 22,
                    torso_1  = 98,
                    torso_2  = 0,
                    pants_1  = 34,
                    pants_2  = 0,
                    shoes_1  = 25,
                    shoes_2  = 0
                })
                RequestModel(model)
                while not HasModelLoaded(model) do
                    RequestModel(model)
                    Citizen.Wait(0)
                end
                SetPlayerModel(PlayerId(), model)
                SetModelAsNoLongerNeeded(model)
            end
        end)
    elseif outfits == "roupaheli" then
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
            if skin.sex == 0 then
                TriggerEvent('skinchanger:loadClothes', skin, {
                    sex      = 0,
                    tshirt_1 = 15,
                    tshirt_2 = 0,
                    arms     = 17,
                    torso_1  = 54,
                    torso_2  = 0,
                    pants_1  = 34,
                    pants_2  = 0,
                    shoes_1  = 25
                })
            else
                TriggerEvent('skinchanger:loadClothes', skin, {
                    sex      = 1,
                    tshirt_1 = 35,
                    tshirt_2 = 0,
                    arms     = 22,
                    torso_1  = 98,
                    torso_2  = 0,
                    pants_1  = 34,
                    pants_2  = 0,
                    shoes_1  = 25,
                    shoes_2  = 0
                })
                RequestModel(model)
                while not HasModelLoaded(model) do
                    RequestModel(model)
                    Citizen.Wait(0)
                end
                SetPlayerModel(PlayerId(), model)
                SetModelAsNoLongerNeeded(model)
            end
        end)
    elseif outfits == "roupasuperior" then
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
            if skin.sex == 0 then
                TriggerEvent('skinchanger:loadClothes', skin, {
                    sex      = 0,
                    tshirt_1 = 10,
                    tshirt_2 = 0,
                    arms     = 4,
                    torso_1  = 35,
                    torso_2  = 0,
                    pants_1  = 31,
                    pants_2  = 0,
                    shoes_1  = 25
                })
            else
                TriggerEvent('skinchanger:loadClothes', skin, {
                    sex      = 1,
                    tshirt_1 = 6,
                    tshirt_2 = 0,
                    arms     = 9,
                    torso_1  = 225,
                    torso_2  = 0,
                    pants_1  = 34,
                    pants_2  = 0,
                    shoes_1  = 27,
                    shoes_2  = 0
                })
                RequestModel(model)
                while not HasModelLoaded(model) do
                    RequestModel(model)
                    Citizen.Wait(0)
                end
                SetPlayerModel(PlayerId(), model)
                SetModelAsNoLongerNeeded(model)
            end
        end)
    elseif outfits == "roupadiretor" then
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
            if skin.sex == 0 then
                TriggerEvent('skinchanger:loadClothes', skin, {
                    sex      = 0,
                    tshirt_1 = 15,
                    tshirt_2 = 0,
                    arms     = 4,
                    torso_1  = 24,
                    torso_2  = 0,
                    pants_1  = 35,
                    pants_2  = 0,
                    shoes_1  = 10
                })
            else
                TriggerEvent('skinchanger:loadClothes', skin, {
                    sex      = 1,
                    tshirt_1 = 6,
                    tshirt_2 = 0,
                    arms     = 9,
                    torso_1  = 225,
                    torso_2  = 0,
                    pants_1  = 34,
                    pants_2  = 0,
                    shoes_1  = 27,
                    shoes_2  = 0
                })
                RequestModel(model)
                while not HasModelLoaded(model) do
                    RequestModel(model)
                    Citizen.Wait(0)
                end
                SetPlayerModel(PlayerId(), model)
                SetModelAsNoLongerNeeded(model)
            end
        end)
    end
end)

RegisterNetEvent('policia:coletes') -- Roupas
AddEventHandler('policia:coletes', function(data)
    local outfits = data.outfits

    if outfits == "coletenormal" then
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
            if skin.sex == 0 then
                TriggerEvent('skinchanger:loadClothes', skin, {
                    bproof_1      = 27
                })
            else
                TriggerEvent('skinchanger:loadClothes', skin, {
                    bproof_1      = 29
                })
                RequestModel(model)
                while not HasModelLoaded(model) do
                    RequestModel(model)
                    Citizen.Wait(0)
                end
                SetPlayerModel(PlayerId(), model)
                SetModelAsNoLongerNeeded(model)
            end
        end)
    elseif outfits == "coldre" then
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
            if skin.sex == 0 then
                TriggerEvent('skinchanger:loadClothes', skin, {
                    chain_1      = 6
                })
            else
                TriggerEvent('skinchanger:loadClothes', skin, {
                    bproof_1      = 29
                })
                RequestModel(model)
                while not HasModelLoaded(model) do
                    RequestModel(model)
                    Citizen.Wait(0)
                end
                SetPlayerModel(PlayerId(), model)
                SetModelAsNoLongerNeeded(model)
            end
        end)
    end
end)

RegisterNetEvent('policia:inventario')
AddEventHandler('policia:inventario', function(data)
    local invOpcion = data.invOpcion
    if invOpcion == 'meter' then
        OpenPutStocksMenu()
    elseif invOpcion == 'sacar' then
        OpenGetStocksMenu()
    end
end)

RegisterNetEvent('policia:sociedad')
AddEventHandler('policia:sociedad', function()
    if PlayerData.job.grade_name == 'boss' then
        exports['mythic_notify']:DoHudText('inform', '👮🏼‍| Polícia: Menu da Polícia')
        TriggerEvent('esx_society:openBossMenu', 'police', function(data, menu)
            menu.close()
            align    = 'bottom-right'
        end, { wash = false })
    elseif PlayerData.job.grade_name ~= 'boss' then
        exports['mythic_notify']:DoHudText('inform', '👮🏼‍| Polícia: Não és o diretor da polícia')
    end
end)

RegisterNetEvent('policia:factura')
AddEventHandler('policia:factura', function()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'fine', {
        title    = 'Multas da Polícia',
        align    = 'right',
        elements = {
            {label = 'Multas de Tráfego', value = 0},
            {label = 'Multas Ligeiras',   value = 1},
            {label = 'Multas Médias', value = 2},
            {label = 'Multas Graves',   value = 3}
    }}, function(data, menu)
        OpenFineCategoryMenu(player, data.current.value)
    end, function(data, menu)
        menu.close()
    end)
end)

Citizen.CreateThread(function()
    for k,v in pairs(Config.BlipPolicia) do
        local blip = AddBlipForCoord(v)

        SetBlipSprite (blip, 446)
        SetBlipDisplay(blip, 4)
        SetBlipScale  (blip, 0.7)
        SetBlipColour (blip, 35)
        SetBlipAsShortRange(blip, true)

        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName('Polícia')
        EndTextCommandSetBlipName(blip)
    end -- blips 
end)

RegisterNetEvent('esx_mafiajob:drag') -- arrastar
AddEventHandler('esx_mafiajob:drag', function(cop)
  TriggerServerEvent('esx:clientLog', 'starting dragging')
  IsDragged = not IsDragged
  CopPed = tonumber(cop)
end)

Citizen.CreateThread(function()
  while true do
    Wait(0)
    if IsHandcuffed then
      if IsDragged then
        local ped = GetPlayerPed(GetPlayerFromServerId(CopPed))
        local myped = GetPlayerPed(-1)
        AttachEntityToEntity(myped, ped, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
      else
        DetachEntity(GetPlayerPed(-1), true, false)
      end
    end
  end
end)

RegisterNetEvent('pjob:identity_card') -- cartão cidadão
AddEventHandler('pjob:identity_card', function()
    ESX.UI.Menu.CloseAll()
    local closestPlayer, distance = ESX.Game.GetClosestPlayer()
                                
    if distance ~= -1 and distance <= 3.0 then
        OpenIdentityCardMenu(closestPlayer)
    else
        exports['mythic_notify']:SendAlert('error', 'Ninguém por perto!', 1500)
    end
end)

RegisterNetEvent('pjob:communityservice') -- serviço comunitário
AddEventHandler('pjob:communityservice', function()
    ESX.UI.Menu.CloseAll()
    local closestPlayer, distance = ESX.Game.GetClosestPlayer()
                                
    if distance ~= -1 and distance <= 3.0 then
        SendToCommunityService(GetPlayerServerId(closestPlayer))
    else
        exports['mythic_notify']:SendAlert('error', 'Ninguém por perto!', 1500)
    end
end)

RegisterNetEvent('pjob:body_search') -- revistar
AddEventHandler('pjob:body_search', function()
    ESX.UI.Menu.CloseAll()
    local closestPlayer, distance = ESX.Game.GetClosestPlayer()
                                
    if distance ~= -1 and distance <= 3.0 then
        TriggerServerEvent('sky_policia:ptgmessage', GetPlayerServerId(closestPlayer), _U('being_searched'))
        OpenBodySearchMenu(closestPlayer)       
        
    else
        exports['mythic_notify']:SendAlert('error', 'Ninguém por perto!', 1500)
    end
end)

RegisterNetEvent('pjob:handcuff2') -- revistar 2
AddEventHandler('pjob:handcuff2', function()
    local closestPlayer, distance = ESX.Game.GetClosestPlayer()
                                
    if distance ~= -1 and distance <= 3.0 then
        TriggerServerEvent('sky_policia:handcuff', GetPlayerServerId(closestPlayer))
    else
        exports['mythic_notify']:SendAlert('error', 'Ninguém por perto!', 1500)
    end
end)

RegisterNetEvent('pjob:drag') -- arrastar
AddEventHandler('pjob:drag', function()
    local closestPlayer, distance = ESX.Game.GetClosestPlayer()
                                
    if distance ~= -1 and distance <= 3.0 then
            TriggerServerEvent('sky_policia:drag', GetPlayerServerId(closestPlayer))  
    else
        exports['mythic_notify']:SendAlert('error', 'Ninguém por perto!', 1500)
    end
end)

RegisterNetEvent('pjob:put_in_vehicle') -- colocar no veículo
AddEventHandler('pjob:put_in_vehicle', function()
    local closestPlayer, distance = ESX.Game.GetClosestPlayer()
                                
    if distance ~= -1 and distance <= 3.0 then
        TriggerServerEvent('sky_policia:ptgputInVehicle', GetPlayerServerId(closestPlayer))
    else
        exports['mythic_notify']:SendAlert('error', 'Ninguém por perto!', 1500)
    end
end)

RegisterNetEvent('pjob:out_the_vehicle') -- retirar do veículo
AddEventHandler('pjob:out_the_vehicle', function()
    local closestPlayer, distance = ESX.Game.GetClosestPlayer()
                                
    if distance ~= -1 and distance <= 3.0 then
        TriggerServerEvent('sky_policia:ptgOutVehicle', GetPlayerServerId(closestPlayer)) 
    else
        exports['mythic_notify']:SendAlert('error', 'Ninguém por perto!', 1500)
    end
end)

RegisterNetEvent('pjob:fine') -- multas
AddEventHandler('pjob:fine', function()
    ESX.UI.Menu.CloseAll()
    local closestPlayer, distance = ESX.Game.GetClosestPlayer()
                                
    if distance ~= -1 and distance <= 3.0 then
        OpenFineMenu(closestPlayer)
    else
        exports['mythic_notify']:SendAlert('error', 'Ninguém por perto!', 1500)
    end
end)

RegisterNetEvent('pjob:unpaid_bills') -- verificar multas por pagar
AddEventHandler('pjob:unpaid_bills', function()
    ESX.UI.Menu.CloseAll()
    local closestPlayer, distance = ESX.Game.GetClosestPlayer()
                                
    if distance ~= -1 and distance <= 3.0 then
            OpenUnpaidBillsMenu(closestPlayer)  
    else
        exports['mythic_notify']:SendAlert('error', 'Ninguém por perto!', 1500)
    end
end)

RegisterNetEvent('pjob:license') -- licenças
AddEventHandler('pjob:license', function()
    ESX.UI.Menu.CloseAll()
    local closestPlayer, distance = ESX.Game.GetClosestPlayer()
                                
    if distance ~= -1 and distance <= 3.0 then
        ShowPlayerLicense(closestPlayer)
    else
        exports['mythic_notify']:SendAlert('error', 'Ninguém por perto!', 1500)
    end
end)

RegisterNetEvent('pjob:jail') -- dar jail
AddEventHandler('pjob:jail', function()
    ESX.UI.Menu.CloseAll()
    TriggerEvent("esx-qalle-jail:openJailMenu")
end)

RegisterNetEvent('pjob:barreiras') -- barreiras
AddEventHandler('pjob:barreiras', function()
    local model     = 'prop_barrier_work05'
    local playerPed = PlayerPedId()
    local coords    = GetEntityCoords(playerPed)
    local forward   = GetEntityForwardVector(playerPed)
    local x, y, z   = table.unpack(coords + forward * 1.0)

    if model == 'prop_roadcone02a' then
        z = z - 2.0
    end

    ESX.Game.SpawnObject(model, {
        x = x,
        y = y,
        z = z
    }, function(obj)
        SetEntityHeading(obj, GetEntityHeading(playerPed))
        PlaceObjectOnGroundProperly(obj)
    end)
end)

RegisterNetEvent('pjob:search_database') -- verificar na database
AddEventHandler('pjob:search_database', function()
    ESX.UI.Menu.CloseAll()
    LookupVehicle()
end)

RegisterNetEvent('pjob:menu') -- menu policia
AddEventHandler('pjob:menu', function()
    ESX.UI.Menu.CloseAll()
    OpenPoliceActionsMenu()
end)

RegisterNetEvent('pjob:vehicle_infos') -- informações dos veículos
AddEventHandler('pjob:vehicle_infos', function()
    ESX.UI.Menu.CloseAll()
    local playerPed = PlayerPedId()
    local coords    = GetEntityCoords(playerPed)
    local vehicle   = ESX.Game.GetVehicleInDirection()
    
    if DoesEntityExist(vehicle) then
        local vehicleData = ESX.Game.GetVehicleProperties(vehicle)
        OpenVehicleInfosMenu(vehicleData)
    else
        exports['mythic_notify']:SendAlert('error', 'Nenhum veículo por perto!', 1500)
    end
end)

RegisterNetEvent('pjob:hijack_vehicle') -- destrancar veículo
AddEventHandler('pjob:hijack_vehicle', function()
    ESX.UI.Menu.CloseAll()
    local playerPed = PlayerPedId()
    local coords    = GetEntityCoords(playerPed)
    local vehicle   = ESX.Game.GetVehicleInDirection()
    
    if DoesEntityExist(vehicle) then
        if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 3.0) then
            TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)
            Citizen.Wait(20000)
            ClearPedTasksImmediately(playerPed)

            SetVehicleDoorsLocked(vehicle, 1)
            SetVehicleDoorsLockedForAllPlayers(vehicle, false)
            exports['mythic_notify']:SendAlert('inform', 'Veículo destrancado')           
        end 
    else
        exports['mythic_notify']:SendAlert('error', 'Nenhum veículo por perto')      
    end
end)

RegisterNetEvent('pjob:dep_vehicle') -- rebocar veículo
AddEventHandler('pjob:dep_vehicle', function()
    ESX.UI.Menu.CloseAll()
    local playerPed = PlayerPedId()
    local coords    = GetEntityCoords(playerPed)
    local vehicle   = ESX.Game.GetVehicleInDirection()
    
    if DoesEntityExist(vehicle) then
        local playerPed = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(playerPed, true)
        
        local towmodel = GetHashKey('reboquepolice')
        local isVehicleTow = IsVehicleModel(vehicle, towmodel)
                        
        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

        if isVehicleTow then
            local targetVehicle = ESX.Game.GetVehicleInDirection()

            if CurrentlyTowedVehicle == nil then
                if targetVehicle ~= 0 then
                    if not IsPedInAnyVehicle(playerPed, true) then
                        if vehicle ~= targetVehicle then
                            AttachEntityToEntity(targetVehicle, vehicle, 20, 0.7, -4.5, 0.9, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
                            CurrentlyTowedVehicle = targetVehicle
                            exports['mythic_notify']:SendAlert('inform', 'Veículo rebocado com sucesso')                      
                        else
                            exports['mythic_notify']:SendAlert('error', 'Não podes rebocar o teu próprio veículo')                         
                        end
                    end
                else
                   exports['mythic_notify']:SendAlert('error', 'Nenhum veículo por perto')                   
                end
            else

                AttachEntityToEntity(CurrentlyTowedVehicle, vehicle, 20, -0.5, -12.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
                DetachEntity(CurrentlyTowedVehicle, true, true)


                CurrentlyTowedVehicle = nil
                exports['mythic_notify']:SendAlert('inform', 'Veículo entregue com sucesso')                
            end
        else
            exports['mythic_notify']:SendAlert('inform', 'Precisas de um reboque prancha')         
        end 
    else
        exports['mythic_notify']:SendAlert('inform', 'Nenhum veículo por perto')    
    end
end)

RegisterNetEvent('pjob:impound') -- apreender veículo
AddEventHandler('pjob:impound', function()
    ESX.UI.Menu.CloseAll()
    local playerPed = PlayerPedId()
    local coords    = GetEntityCoords(playerPed)
    local vehicle   = ESX.Game.GetVehicleInDirection()
    
    if DoesEntityExist(vehicle) then
        -- is the script busy?
        if CurrentTask.Busy then
            return
        end

        exports['mythic_notify']:SendAlert('inform', 'Pressiona [X] para cancelar a apreensão')       
        
        TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
        
        CurrentTask.Busy = true
        CurrentTask.Task = ESX.SetTimeout(10000, function()
            ClearPedTasks(playerPed)
            ImpoundVehicle(vehicle)
            Citizen.Wait(100)
        end)
        
        -- keep track of that vehicle!
        Citizen.CreateThread(function()
            while CurrentTask.Busy do
                Citizen.Wait(1000)
            
                vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 3.0, 0, 71)
                if not DoesEntityExist(vehicle) and CurrentTask.Busy then
                    exports['mythic_notify']:SendAlert('inform', 'Apreensão cancelada')      
                    ESX.ClearTimeout(CurrentTask.Task)
                    ClearPedTasks(playerPed)
                    CurrentTask.Busy = false
                    break
                end
            end
        end)
    else
        exports['mythic_notify']:SendAlert('error', 'Nenhum veículo por perto')
    end
end)

RegisterNetEvent('psp:licença') -- tirar licenças
AddEventHandler('psp:licença', function()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    if closestPlayer == -1 or closestDistance > 3.0 then
        exports['mythic_notify']:SendAlert('error', 'Ninguém por perto')
    else        
    Porte(closestPlayer)
    end
end)

RegisterNetEvent('sky_policia:dragpolice') -- arrastar policia
AddEventHandler('sky_policia:dragpolice', function(copId)
    if isHandcuffed then
        dragStatus.isDragged = not dragStatus.isDragged
        dragStatus.CopId = copId
    end
end)

RegisterNetEvent('impoundVeh')
AddEventHandler('impoundVeh', function()
    local vehicle, attempt = ESX.Game.GetVehicleInDirection(), 0
    while not NetworkHasControlOfEntity(vehicle) and attempt < 100 and DoesEntityExist(vehicle) do
        Citizen.Wait(100)
        NetworkRequestControlOfEntity(vehicle)
        attempt = attempt + 1
    end
if DoesEntityExist(vehicle) and NetworkHasControlOfEntity(vehicle) then
        ESX.Game.DeleteVehicle(vehicle)
    end
end)

-- CAMERAS

local cameraActive = false
local currentCameraIndex = 0
local currentCameraIndexIndex = 0
local createdCamera = 0

Citizen.CreateThread(function()
    while true do
        for a = 1, #SecurityCamConfig.Locations do
            local ped = GetPlayerPed(PlayerId())
            local pedPos = GetEntityCoords(ped, false)
            local pedHead = GetEntityRotation(ped, 2)
            local distance = Vdist(pedPos.x, pedPos.y, pedPos.z, SecurityCamConfig.Locations[a].camBox.x, SecurityCamConfig.Locations[a].camBox.y, SecurityCamConfig.Locations[a].camBox.z)
            if SecurityCamConfig.DebugMode then
                Draw3DText(pedPos.x, pedPos.y, pedPos.z + 0.6, tostring("X: " .. pedPos.x))
                Draw3DText(pedPos.x, pedPos.y, pedPos.z + 0.4, tostring("Y: " .. pedPos.y))
                Draw3DText(pedPos.x, pedPos.y, pedPos.z + 0.2, tostring("Z: " .. pedPos.z))
                Draw3DText(pedPos.x, pedPos.y, pedPos.z, tostring("H: " .. pedHead))
            end
            local pedAllowed = false
            if #SecurityCamConfig.Locations[a].allowedModels >= 1 then
                pedAllowed = IsPedAllowed(ped, SecurityCamConfig.Locations[a].allowedModels)
            else
                pedAllowed = true
            end

            if pedAllowed then
                if distance <= 5.0 then
                    local box_label = SecurityCamConfig.Locations[a].camBox.label
                    local box_x = SecurityCamConfig.Locations[a].camBox.x
                    local box_y = SecurityCamConfig.Locations[a].camBox.y
                    local box_z = SecurityCamConfig.Locations[a].camBox.z
                    Draw3DText(box_x, box_y, box_z, tostring("~b~[E]~w~ Ver câmeras do: " .. box_label))
                    if IsControlJustPressed(1, 38) and createdCamera == 0 and distance <= 1.2 then
                        local firstCamx = SecurityCamConfig.Locations[a].cameras[1].x
                        local firstCamy = SecurityCamConfig.Locations[a].cameras[1].y
                        local firstCamz = SecurityCamConfig.Locations[a].cameras[1].z
                        local firstCamr = SecurityCamConfig.Locations[a].cameras[1].r
                        SetFocusArea(firstCamx, firstCamy, firstCamz, firstCamx, firstCamy, firstCamz)
                        ChangeSecurityCamera(firstCamx, firstCamy, firstCamz, firstCamr)
                        SendNUIMessage({
                            type = "enablecam",
                            label = SecurityCamConfig.Locations[a].cameras[1].label,
                            box = SecurityCamConfig.Locations[a].camBox.label
                        })
                        currentCameraIndex = a
                        currentCameraIndexIndex = 1
                        FreezeEntityPosition(GetPlayerPed(PlayerId()), true)
                    end
                end
            end

            if createdCamera ~= 0 then
                local instructions = CreateInstuctionScaleform("instructional_buttons")
                DrawScaleformMovieFullscreen(instructions, 255, 255, 255, 255, 0)
                SetTimecycleModifier("scanline_cam_cheap")
                SetTimecycleModifierStrength(2.0)

                if SecurityCamConfig.HideRadar then
                    DisplayRadar(false)
                end

                -- CLOSE CAMERAS
                if IsControlJustPressed(1, 194) then
                    CloseSecurityCamera()
                    SendNUIMessage({
                        type = "disablecam",
                    })
            if SecurityCamConfig.HideRadar then
                           DisplayRadar(true)
                    end
                end

                -- GO BACK CAMERA
                if IsControlJustPressed(1, 174) then
                    local newCamIndex

                    if currentCameraIndexIndex == 1 then
                        newCamIndex = #SecurityCamConfig.Locations[currentCameraIndex].cameras
                    else
                        newCamIndex = currentCameraIndexIndex - 1
                    end

                    local newCamx = SecurityCamConfig.Locations[currentCameraIndex].cameras[newCamIndex].x
                    local newCamy = SecurityCamConfig.Locations[currentCameraIndex].cameras[newCamIndex].y
                    local newCamz = SecurityCamConfig.Locations[currentCameraIndex].cameras[newCamIndex].z
                    local newCamr = SecurityCamConfig.Locations[currentCameraIndex].cameras[newCamIndex].r
                    SetFocusArea(newCamx, newCamy, newCamz, newCamx, newCamy, newCamz)
                    SendNUIMessage({
                        type = "updatecam",
                        label = SecurityCamConfig.Locations[currentCameraIndex].cameras[newCamIndex].label
                    })
                    ChangeSecurityCamera(newCamx, newCamy, newCamz, newCamr)
                    currentCameraIndexIndex = newCamIndex
                end

                -- GO FORWARD CAMERA
                if IsControlJustPressed(1, 175) then
                    local newCamIndex
                    
                    if currentCameraIndexIndex == #SecurityCamConfig.Locations[currentCameraIndex].cameras then
                        newCamIndex = 1
                    else
                        newCamIndex = currentCameraIndexIndex + 1
                    end

                    local newCamx = SecurityCamConfig.Locations[currentCameraIndex].cameras[newCamIndex].x
                    local newCamy = SecurityCamConfig.Locations[currentCameraIndex].cameras[newCamIndex].y
                    local newCamz = SecurityCamConfig.Locations[currentCameraIndex].cameras[newCamIndex].z
                    local newCamr = SecurityCamConfig.Locations[currentCameraIndex].cameras[newCamIndex].r
                    SetFocusArea(newCamx, newCamy, newCamz, newCamx, newCamy, newCamz)
                    SendNUIMessage({
                        type = "updatecam",
                        label = SecurityCamConfig.Locations[currentCameraIndex].cameras[newCamIndex].label
                    })
                    ChangeSecurityCamera(newCamx, newCamy, newCamz, newCamr)
                    currentCameraIndexIndex = newCamIndex
                end

                ---------------------------------------------------------------------------
                -- CAMERA ROTATION CONTROLS
                ---------------------------------------------------------------------------
                if SecurityCamConfig.Locations[currentCameraIndex].cameras[currentCameraIndexIndex].canRotate then
                    local getCameraRot = GetCamRot(createdCamera, 2)

                    -- ROTATE UP
                    if IsControlPressed(1, 32) then
                        if getCameraRot.x <= 0.0 then
                            SetCamRot(createdCamera, getCameraRot.x + 0.7, 0.0, getCameraRot.z, 2)
                        end
                    end

                    -- ROTATE DOWN
                    if IsControlPressed(1, 33) then
                        if getCameraRot.x >= -50.0 then
                            SetCamRot(createdCamera, getCameraRot.x - 0.7, 0.0, getCameraRot.z, 2)
                        end
                    end

                    -- ROTATE LEFT
                    if IsControlPressed(1, 34) then
                        SetCamRot(createdCamera, getCameraRot.x, 0.0, getCameraRot.z + 0.7, 2)
                    end

                    -- ROTATE RIGHT
                    if IsControlPressed(1, 35) then
                        SetCamRot(createdCamera, getCameraRot.x, 0.0, getCameraRot.z - 0.7, 2)
                    end
                end
            end
        end
        Citizen.Wait(0)
    end
end)

---------------------------------------------------------------------------
-- FUNCTIONS
---------------------------------------------------------------------------
function ChangeSecurityCamera(x, y, z, r)
    if createdCamera ~= 0 then
        DestroyCam(createdCamera, 0)
        createdCamera = 0
    end

    local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
    SetCamCoord(cam, x, y, z)
    SetCamRot(cam, r.x, r.y, r.z, 2)
    RenderScriptCams(1, 0, 0, 1, 1)
    Citizen.Wait(250)
    createdCamera = cam
end

function CloseSecurityCamera()
    DestroyCam(createdCamera, 0)
    RenderScriptCams(0, 0, 1, 1, 1)
    createdCamera = 0
    ClearTimecycleModifier("scanline_cam_cheap")
    SetFocusEntity(GetPlayerPed(PlayerId()))
    if SecurityCamConfig.HideRadar then
        DisplayRadar(true)
    end
    FreezeEntityPosition(GetPlayerPed(PlayerId()), false)
end

function Draw3DText(x, y, z, text)
  local onScreen,_x,_y=World3dToScreen2d(x,y,z)
  local px,py,pz=table.unpack(GetGameplayCamCoords())

  SetTextScale(0.35, 0.35)
  SetTextFont(4)
  SetTextProportional(1)
  SetTextColour(255, 255, 255, 215)
  SetTextEntry("STRING")
  SetTextCentre(true)
  AddTextComponentString(text)
  DrawText(_x,_y)
  local factor = (string.len(text)) / 370
  DrawRect(_x,_y+0.0125, 0.015+ factor, 0, 0, 0, 0.0)
    end


function IsPedAllowed(ped, pedList)
    for i = 1, #pedList do
        if GetHashKey(pedList[i]) == GetEntityModel(ped) then
            return true
        end
    end
    return false
end

function CreateInstuctionScaleform(scaleform)
    local scaleform = RequestScaleformMovie(scaleform)
    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(0)
    end
    PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
    PopScaleformMovieFunctionVoid()
    
    PushScaleformMovieFunction(scaleform, "SET_CLEAR_SPACE")
    PushScaleformMovieFunctionParameterInt(200)
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(0)
    InstructionButton(GetControlInstructionalButton(1, 175, true))
    InstructionButtonMessage("Go Forward")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(1)
    InstructionButton(GetControlInstructionalButton(1, 194, true))
    InstructionButtonMessage("Close Camera")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(2)
    InstructionButton(GetControlInstructionalButton(1, 174, true))
    InstructionButtonMessage("Go Back")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_BACKGROUND_COLOUR")
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(80)
    PopScaleformMovieFunctionVoid()

    return scaleform
end

function InstructionButton(ControlButton)
    N_0xe83a3e3557a56640(ControlButton)
end

function InstructionButtonMessage(text)
    BeginTextCommandScaleformString("STRING")
    AddTextComponentScaleform(text)
    EndTextCommandScaleformString()
end

-- TRACKING CAR

local deployed = false
local gpstarget = nil
local trackedveh = nil
local tracking = false

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if ( IsControlJustPressed(0,244) and IsPedInAnyVehicle(GetPlayerPed(-1)) and IsPedInAnyPoliceVehicle(GetPlayerPed(-1)) ) then
            if deployed and trackedveh ~= nil then
                TriggerServerEvent("sky_policia:removetracker", gpstarget)
                deployed = false
            elseif not deployed and not tracking then
                    trackedveh = GetTrackedVeh(GetVehiclePedIsIn(GetPlayerPed(-1)))
                if IsEntityAVehicle(trackedveh) then
                  deployed = true
                  tracking = false
                  exports['mythic_notify']:DoHudText('inform', 'Rastreador: Ativado')     
                  TriggerServerEvent('sky_policia:sendblip', trackedveh)
                end
            elseif not deployed and tracking then
                exports['mythic_notify']:DoHudText('inform', 'Rastreador: Desativado')          
              tracking = false
            end
        end
    end
end)

RegisterNetEvent("sky_policia:trackerset")
AddEventHandler("sky_policia:trackerset", function(veh)
  gps = AddBlipForEntity(veh)
  SetBlipSprite(gps, 42)
  if not tracking then
    tracking = true
    if deployed then
      gpstarget = gps
      SetBlipRoute(gps, true)
      SetEntityAsMissionEntity(veh, true, true)
    end
    while deployed or tracking do
      Citizen.Wait(0)
      if veh ~= nil then
          if not IsEntityAVehicle(veh) then
                exports['mythic_notify']:DoHudText('inform', 'Rastreador: Perdido o Sinal')     
                deployed = false
            tracking = false
        end
    else
        deployed = false
        tracking = false
      end
    end
  end
end)

RegisterNetEvent("sky_policia:trackerremove")
AddEventHandler("sky_policia:trackerremove", function(gps)
    RemoveBlip(gps)
    exports['mythic_notify']:DoHudText('inform', 'Rastreador: Desativado')
    tracking = false
end)

function GetTrackedVeh(e)
    local coord1 = GetOffsetFromEntityInWorldCoords(e, 0.0, 1.0, 1.0)
    local coord2 = GetOffsetFromEntityInWorldCoords(e, 0.0, 25.0, 0.0)
    local rayresult = StartShapeTestCapsule(coord1, coord2, 3.0, 10, e, 7)
    local a, b, c, d, e = GetShapeTestResult(rayresult)
    if DoesEntityExist(e) then
        return e
    else
        return nil
    end
end

function showNotification(string)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(string)
  DrawNotification(false, false)
end

