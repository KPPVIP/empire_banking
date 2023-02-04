-- Leaked by Luxury Leaks
-- discord.gg/luxury-leaks
fx_version 'cerulean'
game 'gta5'

author "Luxury Leaks"
description "Empire X Banking (needs to get fixxed) - discord.gg/luxury-leaks"

ui_page 'client/html/index.html'

client_scripts {
	'client/main.lua',
} 

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'settings.lua',
	'notifications.lua',
	'server/main.lua'
} 

files {
	'client/html/index.html',
	'client/html/assets/**/*'
}

