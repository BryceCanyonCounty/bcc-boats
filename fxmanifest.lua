fx_version 'cerulean'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

game 'rdr3'
lua54 'yes'
author 'BCC Team'

shared_scripts {
    'configs/*.lua',
    'locale.lua',
    'languages/*.lua'
}

client_scripts {
    'client/dataview.lua',
    'client/client.lua',
    'client/menu.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
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

version '2.0.1'