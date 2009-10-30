#!/bin/sh

LUA_PATH="/usr/local/share/lua/5.1//?.lua;/usr/local/share/lua/5.1//?/init.lua;./?.lua;/usr/local/share/lua/5.1/?.lua;/usr/local/share/lua/5.1/?/init.lua;/usr/local/lib/lua/5.1/?.lua;/usr/local/lib/lua/5.1/?/init.lua;$LUA_PATH"
LUA_CPATH="./?.so;/usr/local/lib/lua/5.1/?.so;/usr/local/lib/lua/5.1/loadall.so;$LUA_CPATH"
export LUA_PATH LUA_CPATH
exec "/usr/local/bin/lua" -lluarocks.require "/usr/local/lib/luarocks/rocks/kepler/1.1.1-1/bin/cgilua.cgi" "$@"
