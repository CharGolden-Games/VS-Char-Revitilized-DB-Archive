@echo off
color 0a
echo INSTALLING/SETTING LIBRARIES
@echo on
haxelib git discord_rpc https://github.com/Aidan63/linc_discord-rpc.git
haxelib set flixel 5.2.2
haxelib set flixel-tools 1.5.1
haxelib set flixel-addons 3.0.2
haxelib set flixel-ui 2.5.0
haxelib set sscript 5.2.0
haxelib set hxcodec 2.6.1
haxelib set lime 8.0.1
haxelib git linc_luajit https://github.com/superpowers04/linc_luajit.git
haxelib set openfl 9.2.1
haxelib install haxeui-core
haxelib install haxeui-flixel
haxelib install tjson
set /p answer=Are you planning on compiling with the debug flag? E.G. "lime test windows -debug" (Y/N)?
if /i "%answer:~,1%" EQU "Y" haxelib install hxcpp-debug-server
if /i "%answer:~,1%" EQU "N" echo Skipping hxcpp-debug-server
@echo off
echo DONE
pause
