fx_version 'cerulean'
game 'gta5'

name 'qbx_valet_parking'
description 'Simple valet/parking bridge for qbx_garages + ox_target + ox_lib'
author 'Codex'
lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'client.lua'
}
