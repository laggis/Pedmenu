local isMenuOpen = false
local selectedIndex = 1
local menuAlpha = 0
local itemAlpha = 0
local lastFrameTime = 0
local lastSelectTime = 0
local currentTextColors = {}
local titleColor = {255, 255, 255}  -- Title color for animation

-- Initialize notification system
local notifications = {}
local NOTIFICATION = {
    width = 0.16,              -- Match menu width
    height = 0.03,             -- Compact height
    baseY = 0.75,             -- Position near bottom
    x = 0.08,                 -- Match menu x position
    spacing = 0.005,          -- Small gap between notifications
    maxNotifications = 3,      -- Limit number of notifications
    fadeIn = 200,             -- Quick fade in (ms)
    fadeOut = 300,            -- Smooth fade out (ms)
    duration = 5000,          -- Show for 5 seconds
}

-- Minimalist dark theme
local COLORS = {
    background = {15, 15, 15},   -- Very dark gray background
    surface = {30, 30, 30},      -- Lighter surface for selected
    text = {255, 255, 255},      -- Pure white text
    dimText = {180, 180, 180}    -- Light gray for unselected
}

-- Menu settings
local MENU = {
    width = 0.16,               -- Menu width
    x = 0.08,                  -- Position on left side
    headerHeight = 0.03,        -- Compact header
    itemHeight = 0.03,          -- Item height
    spacing = 0.001,           -- Minimal spacing
    padding = 0.004,           -- Slight padding
    maxItems = 20,             -- Show more items
    opacity = 0.92,            -- Better visibility
    footerPadding = 0.008      -- Space before footer
}

-- Animation settings
local ANIM = {
    speed = 8.0,
    itemSpeed = 12.0,
    scaleSpeed = 7.0,
    bounceAmplitude = 0.05,
    bounceFrequency = 3.0,
    colorSpeed = 3.0,  -- Speed for color transitions
    titleColors = {
        {255, 255, 255},  -- White
        {200, 200, 200},  -- Light gray
        {150, 150, 150},  -- Medium gray
        {200, 200, 200},  -- Light gray
        {255, 255, 255}   -- White
    }
}

-- Load required textures
Citizen.CreateThread(function()
    RequestStreamedTextureDict("commonmenu")
    while not HasStreamedTextureDictLoaded("commonmenu") do
        Wait(100)
    end
end)

-- Initialize text colors for all peds
Citizen.CreateThread(function()
    Wait(0) -- Wait for Config to be loaded
    if Config and Config.Peds then
        for i = 1, #Config.Peds do
            currentTextColors[i] = {
                COLORS.dimText[1],
                COLORS.dimText[2],
                COLORS.dimText[3]
            }
        end
    end
end)

-- Smooth lerp function with acceleration
local function smoothLerp(a, b, t, acceleration)
    acceleration = acceleration or 1.0
    local easedT = 1 - math.pow(1 - t, acceleration)
    return a + (b - a) * easedT
end

-- Bounce animation function
local function getBounceOffset(time, amplitude, frequency)
    return amplitude * math.sin(time * frequency) * math.exp(-2 * time)
end

-- Function to draw rounded rectangle with shadow
local function DrawRoundedRect(x, y, w, h, color, alpha, radius, shadow)
    if shadow then
        -- Draw shadow
        DrawRect(x + 0.002, y + 0.002, w, h, 0, 0, 0, alpha * 0.3)
    end
    
    -- Main rectangle with rounded corners
    DrawRect(x, y, w - radius * 0.1, h, color[1], color[2], color[3], alpha)
    DrawRect(x, y, w, h - radius * 0.1, color[1], color[2], color[3], alpha)
    
    -- Corner gradients for rounded effect
    local cornerSize = radius * 0.5
    DrawSprite("commonmenu", "gradient_nav", x - w/2 + cornerSize, y - h/2 + cornerSize, 
        cornerSize * 2, cornerSize * 2, 45.0, color[1], color[2], color[3], alpha)
    DrawSprite("commonmenu", "gradient_nav", x + w/2 - cornerSize, y - h/2 + cornerSize, 
        cornerSize * 2, cornerSize * 2, 135.0, color[1], color[2], color[3], alpha)
    DrawSprite("commonmenu", "gradient_nav", x - w/2 + cornerSize, y + h/2 - cornerSize, 
        cornerSize * 2, cornerSize * 2, 315.0, color[1], color[2], color[3], alpha)
    DrawSprite("commonmenu", "gradient_nav", x + w/2 - cornerSize, y + h/2 - cornerSize, 
        cornerSize * 2, cornerSize * 2, 225.0, color[1], color[2], color[3], alpha)
end

-- Function to draw text with outline
local function DrawText(text, x, y, scale, font, color, center, shadow, wrap)
    SetTextScale(scale, scale)
    SetTextFont(font or 4)
    SetTextColour(color[1], color[2], color[3], math.floor(255))
    SetTextCentre(center)
    if shadow then 
        SetTextDropShadow(1, 0, 0, 0, 255)
    end
    if wrap then
        SetTextWrap(x, x + MENU.width - MENU.padding * 2)
    end
    BeginTextCommandDisplayText('STRING')
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(x, y)
end

-- Function to draw menu header
local function DrawMenuHeader()
    -- Draw title text (static white)
    DrawText("Character Selection", MENU.x, 0.078, 0.4, 4, COLORS.text, true, false)
    -- Draw subtitle (static dim)
    DrawText("Choose your appearance", MENU.x, 0.105, 0.3, 4, COLORS.dimText, true, false)
end

-- Function to draw menu items
local function DrawMenuItems()
    if not Config or not Config.Peds then return end
    
    local baseY = 0.14
    local startIndex = 1
    local endIndex = math.min(#Config.Peds, MENU.maxItems)
    
    -- Main background
    DrawRect(MENU.x, baseY + ((endIndex - startIndex) * MENU.itemHeight / 2), 
        MENU.width, (endIndex - startIndex + 1) * MENU.itemHeight + MENU.padding * 2, 
        COLORS.background[1], COLORS.background[2], COLORS.background[3], 
        math.floor(255 * MENU.opacity))
    
    -- Draw items
    for i = startIndex, endIndex do
        local ped = Config.Peds[i]
        if not ped then goto continue end
        
        local itemY = baseY + ((i - startIndex) * MENU.itemHeight)
        
        -- Selected item highlight
        if i == selectedIndex then
            DrawRect(MENU.x, itemY + (MENU.itemHeight/2), 
                MENU.width, MENU.itemHeight, 
                COLORS.surface[1], COLORS.surface[2], COLORS.surface[3], 
                math.floor(255 * MENU.opacity))
            
            -- Draw item text (selected - white)
            if ped.label then
                DrawText(ped.label, 
                    MENU.x, itemY + (MENU.itemHeight/2) - 0.0065, 
                    0.35, 4, COLORS.text, true, false)
            end
        else
            -- Draw item text (unselected - dim)
            if ped.label then
                DrawText(ped.label, 
                    MENU.x, itemY + (MENU.itemHeight/2) - 0.0065, 
                    0.35, 4, COLORS.dimText, true, false)
            end
        end
        
        ::continue::
    end
    
    -- Draw footer
    local footerY = baseY + ((endIndex - startIndex + 1) * MENU.itemHeight) + MENU.footerPadding
    DrawText("↑/↓: Navigate  ENTER: Select  BACKSPACE: Close", 
        MENU.x, footerY, 0.28, 4, COLORS.dimText, true, false)
end

-- Function to draw menu
local function DrawMenu()
    if not isMenuOpen then return end
    
    -- Draw header
    DrawMenuHeader()
    
    -- Draw items
    DrawMenuItems()
end

-- Function to show animated notification
local function ShowNotification(text, type, duration)
    -- Ensure text is a string
    text = tostring(text or '')
    
    -- Remove oldest notification if we exceed the limit
    while #notifications >= NOTIFICATION.maxNotifications do
        table.remove(notifications, 1)
    end
    
    local notification = {
        text = text,
        type = type or 'info',
        alpha = 0,
        scale = 0.95,
        duration = duration or NOTIFICATION.duration,
        createTime = GetGameTimer()
    }
    
    table.insert(notifications, notification)
    
    -- Play appropriate sound
    if type == 'success' then
        PlaySoundFrontend(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
    elseif type == 'error' then
        PlaySoundFrontend(-1, "ERROR", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
    else
        PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
    end
end

-- Function to draw notifications
local function DrawNotifications()
    local currentTime = GetGameTimer()
    local toRemove = {}
    
    for i, notif in ipairs(notifications) do
        local age = currentTime - notif.createTime
        local remainingTime = notif.duration - age
        
        -- Update animation
        if age < NOTIFICATION.fadeIn then
            -- Fade in
            local progress = age / NOTIFICATION.fadeIn
            notif.alpha = smoothLerp(0, 1, progress)
            notif.scale = smoothLerp(0.98, 1.0, progress)
        elseif remainingTime < NOTIFICATION.fadeOut then
            -- Fade out
            local progress = remainingTime / NOTIFICATION.fadeOut
            notif.alpha = progress
            notif.scale = smoothLerp(1.0, 0.98, 1 - progress)
        else
            -- Fully visible
            notif.alpha = 1
            notif.scale = 1.0
        end
        
        -- Remove if expired
        if age > notif.duration then
            table.insert(toRemove, i)
        else
            -- Draw notification
            local y = NOTIFICATION.baseY + ((i-1) * (NOTIFICATION.height + NOTIFICATION.spacing))
            
            -- Background
            DrawRect(NOTIFICATION.x, y, NOTIFICATION.width * notif.scale, NOTIFICATION.height,
                COLORS.background[1], COLORS.background[2], COLORS.background[3],
                math.floor(255 * notif.alpha * 0.95))
            
            -- Text
            DrawText(notif.text, 
                NOTIFICATION.x, y - 0.004, 
                0.27, 4, 
                {COLORS.text[1], COLORS.text[2], COLORS.text[3], 
                math.floor(255 * notif.alpha)},
                true, false)
        end
    end
    
    -- Remove expired notifications
    for i = #toRemove, 1, -1 do
        table.remove(notifications, toRemove[i])
    end
    
    -- Limit number of notifications
    while #notifications > NOTIFICATION.maxNotifications do
        table.remove(notifications, 1)
    end
end

-- Function to handle menu opening/closing
local function SetMenuOpen(open)
    isMenuOpen = open
    if open then
        PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
    else
        PlaySoundFrontend(-1, "BACK", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
    end
end

-- Function to change ped model safely
local function ChangePedModel(model)
    if not IsModelInCdimage(model) or not IsModelValid(model) then
        ShowNotification('Invalid ped model!', 'error')
        return false
    end

    -- Request the model with timeout
    local timeout = 0
    RequestModel(model)
    while not HasModelLoaded(model) do
        timeout = timeout + 100
        if timeout > 5000 then -- 5 second timeout
            ShowNotification('Failed to load ped model!', 'error')
            return false
        end
        Wait(100)
    end

    -- Set player model
    SetPlayerModel(PlayerId(), model)
    SetPedDefaultComponentVariation(PlayerPedId())
    SetModelAsNoLongerNeeded(model)
    
    ShowNotification('Character changed successfully!', 'success')
    return true
end

-- Function to handle menu controls
local function HandleControls()
    if not isMenuOpen then return end
    
    DisableControlActions()
    
    if IsDisabledControlJustPressed(0, 172) then -- Arrow Up
        selectedIndex = selectedIndex - 1
        if selectedIndex < 1 then 
            selectedIndex = #Config.Peds 
        end
        lastSelectTime = GetGameTimer() / 1000.0
        PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
    end
    
    if IsDisabledControlJustPressed(0, 173) then -- Arrow Down
        selectedIndex = selectedIndex + 1
        if selectedIndex > #Config.Peds then 
            selectedIndex = 1 
        end
        lastSelectTime = GetGameTimer() / 1000.0
        PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
    end
    
    if IsDisabledControlJustPressed(0, 191) then -- Enter
        local selectedPed = Config.Peds[selectedIndex]
        if selectedPed then
            if ChangePedModel(GetHashKey(selectedPed.model)) then
                ShowNotification('Ped changed successfully!', 'success')
                PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
                SetMenuOpen(false)
            end
        end
    end
    
    if IsDisabledControlJustPressed(0, 194) then -- Backspace
        SetMenuOpen(false)
        PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
    end
end

-- Function to disable control actions while menu is open
function DisableControlActions()
    DisableControlAction(0, 1, true) -- Look Left/Right
    DisableControlAction(0, 2, true) -- Look Up/Down
    DisableControlAction(0, 142, true) -- MeleeAttackAlternate
    DisableControlAction(0, 18, true) -- Enter
    DisableControlAction(0, 322, true) -- ESC
    DisableControlAction(0, 106, true) -- VehicleMouseControlOverride
end

-- Main thread for menu rendering
Citizen.CreateThread(function()
    while true do
        if isMenuOpen then
            DrawMenu()
            DrawNotifications()
            HandleControls()
            Wait(0)
        else
            DrawNotifications()
            Wait(500)
        end
    end
end)

-- Register client event for notifications
RegisterNetEvent('pedmenu:notification')
AddEventHandler('pedmenu:notification', function(text, type, duration)
    ShowNotification(text, type, duration)
end)

-- Register command to open menu
RegisterCommand(Config.Command, function()
    if not isMenuOpen then
        TriggerServerEvent('pedmenu:checkPermission')
    end
end)

-- Event handler for permission response
RegisterNetEvent('pedmenu:openMenu')
AddEventHandler('pedmenu:openMenu', function(hasPermission)
    if hasPermission and not isMenuOpen then
        SetMenuOpen(true)
        selectedIndex = 1
        ShowNotification('Use arrow keys to navigate, ENTER to select, BACKSPACE to close', 5000)
    else
        ShowNotification('~r~You don\'t have permission to use this menu!', 'error', 3000)
    end
end)
