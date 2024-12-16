fx_version 'cerulean'
game 'gta5'

author 'Your Name'
description 'Ped Menu'
version '1.0.0'

shared_scripts {
    '@es_extended/imports.lua', 
    '@qb-core/shared/locale.lua', 
    '@qb-core/shared/vehicles.lua', 
    '@qb-core/shared/jobs.lua', 
    '@qb-core/shared/gangs.lua' 
}

client_scripts {
    'client/*.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js'
}

-- You can use either framework
dependency {
    'klarserver_base',
    --'qb-core' 
}