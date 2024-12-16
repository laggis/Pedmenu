local display = false

local peds = {
    {name = "Beach Lifeguard", model = "s_m_y_baywatch_01", key = 157}, -- 1
    {name = "Business Man", model = "a_m_y_business_03", key = 158}, -- 2
    {name = "Police Officer", model = "s_m_y_cop_01", key = 160}, -- 3
    {name = "Security Guard", model = "s_m_m_security_01", key = 164}, -- 4
    {name = "Paramedic", model = "s_m_m_paramedic_01", key = 165}, -- 5
}

-- Function to change player ped
function ChangePed(model)
    local hash = GetHashKey(model)
    
    -- Load model
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Wait(0)
    end
    
    -- Change player model
    SetPlayerModel(PlayerId(), hash)
    
    -- Framework specific handling
    local framework = GetFramework()
    if framework then
        local FrameworkObj = GetFrameworkObject()
        
        if framework == 'qb' then
            -- QB-Core specific
            local playerData = FrameworkObj.Functions.GetPlayerData()
            if playerData then
                -- Restore player stats
                SetPedMaxHealth(PlayerPedId(), 200)
                SetPedArmour(PlayerPedId(), playerData.metadata["armor"])
            end
        elseif framework == 'esx' then
            -- ESX specific
            local playerData = FrameworkObj.GetPlayerData()
            if playerData then
                -- Restore player stats
                SetPedMaxHealth(PlayerPedId(), 200)
                SetPedArmour(PlayerPedId(), playerData.armor or 0)
            end
        end
    end
    
    -- Cleanup
    SetModelAsNoLongerNeeded(hash)
    SetPedDefaultComponentVariation(PlayerPedId())
end

function ToggleMenu(bool)
    display = bool
    
    if bool then
        -- Disable mouse controls
        SetNuiFocus(false, false)
        SetNuiFocusKeepInput(false)
        DisableControlAction(0, 1, true) -- LookLeftRight
        DisableControlAction(0, 2, true) -- LookUpDown
        DisableControlAction(0, 106, true) -- VehicleMouseControlOverride
    else
        -- Re-enable mouse controls
        EnableAllControlActions(0)
    end
    
    SendNUIMessage({
        type = "ui",
        status = bool,
        peds = peds
    })
end

-- Main thread for key handling
CreateThread(function()
    while true do
        Wait(0)
        if IsControlJustPressed(0, 168) then -- F7 key
            ToggleMenu(not display)
        end
        
        -- Keep mouse disabled while menu is open
        if display then
            DisableControlAction(0, 1, true) -- LookLeftRight
            DisableControlAction(0, 2, true) -- LookUpDown
            DisableControlAction(0, 106, true) -- VehicleMouseControlOverride
            
            -- Check for number keys
            for _, ped in ipairs(peds) do
                if IsControlJustPressed(0, ped.key) then
                    ChangePed(ped.model)
                end
            end
            
            -- ESC to close menu
            if IsControlJustPressed(0, 322) then
                ToggleMenu(false)
            end
        end
    end
end)

-- NUI Callbacks
RegisterNUICallback("exit", function(data, cb)
    ToggleMenu(false)
    cb('ok')
end)

-- Reset controls on resource stop
AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    EnableAllControlActions(0)
end)
