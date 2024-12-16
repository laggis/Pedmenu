local QBCore = nil
local ESX = nil
local framework = nil

-- Framework Detection
CreateThread(function()
    if GetResourceState('qb-core') == 'started' then
        QBCore = exports['qb-core']:GetCoreObject()
        framework = 'qb'
        print('QBCore detected')
    elseif GetResourceState('es_extended') == 'started' then
        ESX = exports['es_extended']:getSharedObject()
        framework = 'esx'
        print('ESX detected')
    end
end)

function GetFramework()
    return framework
end

function GetFrameworkObject()
    if framework == 'qb' then
        return QBCore
    elseif framework == 'esx' then
        return ESX
    end
    return nil
end
