-- Discord API functions
local function DiscordRequest(method, endpoint, jsondata)
    local data = nil
    PerformHttpRequest(string.format("https://discordapp.com/api/%s", endpoint), function(errorCode, resultData, resultHeaders)
        data = {data = resultData, code = errorCode, headers = resultHeaders}
    end, method, #jsondata > 0 and json.encode(jsondata) or "", {["Content-Type"] = "application/json", ["Authorization"] = "Bot " .. Config.DiscordToken})
    
    while data == nil do Wait(0) end
    return data
end

-- Helper function to send notifications
local function SendNotification(source, text, type, duration)
    TriggerClientEvent('pedmenu:notification', source, text, type, duration)
end

local function CheckDiscordRole(user)
    if Config.DiscordToken == '' then return false end
    
    local endpoint = ("guilds/%s/members/%s"):format(Config.GuildId, user)
    local member = DiscordRequest("GET", endpoint, {})
    
    if member.code == 200 then
        local data = json.decode(member.data)
        local roles = data.roles
        for _, role in ipairs(roles) do
            if role == Config.RoleId then
                return true
            end
        end
    end
    return false
end

-- Variables
local resourceName = GetCurrentResourceName()
local startupComplete = false

-- Function to print startup message once
local function PrintStartupMessage()
    if startupComplete then return end
    
    local baseMsg = 'Standalone Ped Menu started successfully!'
    print('^2' .. baseMsg .. '^7')  -- Simple green message without animation
    startupComplete = true
end

-- Check permissions when player tries to open menu
RegisterServerEvent('pedmenu:checkPermission')
AddEventHandler('pedmenu:checkPermission', function()
    local src = source
    local hasPermission = false
    
    if Config.UseDiscord then
        local identifiers = GetPlayerIdentifiers(src)
        for _, id in ipairs(identifiers) do
            if string.match(id, "discord:") then
                local discordId = string.gsub(id, "discord:", "")
                hasPermission = CheckDiscordRole(discordId)
                if not hasPermission then
                    SendNotification(src, 'You do not have the required Discord role!', 'error')
                end
                break
            end
        end
        if not hasPermission and #identifiers > 0 then
            SendNotification(src, 'Discord ID not found. Please ensure your Discord is linked!', 'error')
        end
    else
        -- Check Ace permissions
        hasPermission = IsPlayerAceAllowed(src, "pedmenu")
        if not hasPermission then
            SendNotification(src, 'You do not have the required server permissions!', 'error')
        end
    end
    
    -- Send result back to client
    TriggerClientEvent('pedmenu:openMenu', src, hasPermission)
end)

-- Print startup message once when resource starts
AddEventHandler('onResourceStart', function(resource)
    if resource == resourceName then
        PrintStartupMessage()
    end
end)

-- Handle resource stop
AddEventHandler('onResourceStop', function(resource)
    if resource == resourceName then
        startupComplete = false  -- Reset for next start
    end
end)
