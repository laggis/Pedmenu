Config = {}

-- Command to open the ped menu
Config.Command = 'pedmenu'

-- Use Discord whitelist (true) or Ace Permissions (false)
Config.UseDiscord = true

-- Discord settings (only if UseDiscord = true)
Config.DiscordToken = '' -- Your bot token
Config.GuildId = '' -- Your server ID
Config.RoleId = '' -- Required role ID

-- Available peds
Config.Peds = {
    {
        label = "Default Male",
        model = "mp_m_freemode_01"
    },
    {
        label = "Default Female",
        model = "mp_f_freemode_01"
    },
    {
        label = "SWAT Officer",
        model = "s_m_y_swat_01"
    },
    {
        label = "Sheriff",
        model = "s_m_y_sheriff_01"
    },
    {
        label = "FIB Agent",
        model = "s_m_m_fiboffice_01"
    },
    {
        label = "Paramedic",
        model = "s_m_m_paramedic_01"
    },
    {
        label = "Firefighter",
        model = "s_m_y_fireman_01"
    },
    {
        label = "Business Man",
        model = "a_m_y_business_02"
    },
    {
        label = "Business Woman",
        model = "a_f_y_business_04"
    },
    {
        label = "Beach Male",
        model = "a_m_y_beach_01"
    },
    {
        label = "Beach Female",
        model = "a_f_y_beach_01"
    },
    {
        label = "Biker",
        model = "g_m_y_lost_01"
    },
    {
        label = "Security Guard",
        model = "s_m_m_security_01"
    },
    {
        label = "Street Vendor",
        model = "s_m_m_strvendor_01"
    },
    {
        label = "Gang Member",
        model = "g_m_y_ballasout_01"
    },
    {
        label = "High End Shopper",
        model = "a_f_y_bevhills_04"
    }
}
