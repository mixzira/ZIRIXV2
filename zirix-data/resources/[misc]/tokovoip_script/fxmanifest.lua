fx_version 'adamant'
game 'gta5'

ui_page 'nui/index.html'

client_script{
    'src/c_utils.lua',
    'c_config.lua',
    'src/c_main.lua',
    'src/c_TokoVoip.lua',
    'src/nuiProxy.js'
}

server_scripts{
    's_config.lua',
    'src/s_main.lua',
    'src/s_utils.lua'
}

files{
    'nui/index.html',
    'nui/script.js'
}