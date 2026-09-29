fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'rr-sitonchairs'
author 'RR Interactive'
description 'Target any chair, bench, stool or couch and sit on it'
version '1.0.0'
repository 'https://github.com/RR-Interactive/rr-sitonchairs'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
}

client_scripts {
    'client.lua',
}

dependencies {
    'ox_lib',
    'ox_target',
}

escrow_ignore {
    'config.lua',
    'README.md',
}
