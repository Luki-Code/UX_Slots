fx_version "adamant"

game "gta5"

author "UX-Systems [Luki]"

description "Slots-Script for FiveM"

client_scripts {

    "lua/customnotifyevent.lua",
    "lua/client.lua",
    "settings/config.lua"

}

server_scripts {

    "lua/server.lua"
}

shared_script 'settings/config.lua'


ui_page "html/index.html"

files {
    "settings/config.json",
    "settings/language.json",
    "html/index.html",
    "html/index.css",
    "html/index.js",
    "html/notification.js",
    "html/howler.js",
    "html/images/*.png",
    "html/images/*.jpg",
    "html/images/*.gif",
    "html/images/*.svg",
    "html/sounds/*.mp3",
    "html/sounds/*.ogg",
    "html/sounds/*.wav"
}


escrow_ignore {
    'settings/config.lua',
    'settings/language.json',
    'settings/config.json',
    "lua/customnotifyevent.lua"
}

lua54 "yes"
