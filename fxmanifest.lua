fx_version 'cerulean'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

game 'rdr3'
lua54 'yes'
author 'BCC Team'

shared_scripts {
    'shared/configs/*.lua',
    'shared/locale.lua',
    'shared/languages/*.lua'
}

client_scripts {
    'client/client_init.lua',
    'client/dataview.lua',
    'client/client.lua',
    'client/menu.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/server_init.lua',
    'server/database.lua',
    'server/server.lua'
}

ui_page {
	'ui/index.html'
}

files {
    "ui/index.html",
    "ui/js/*.*",
    "ui/css/*.*",
    "ui/fonts/*.*",
    "ui/img/*.*"
}

version '2.1.4'