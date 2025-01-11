@echo off
color 0a
echo INSTALLING/SETTING LIBRARIES
@echo on
haxelib --global git discord_rpc https://github.com/Aidan63/linc_discord-rpc.git
haxelib set flixel 5.2.2 --always
haxelib set flixel-tools 1.5.1 --always
haxelib set flixel-addons 3.0.2 --always
haxelib set flixel-ui 2.5.0 --always
haxelib set hxcodec 2.6.1 --always
haxelib set lime 8.0.2 --always
haxelib --global git linc_luajit https://github.com/superpowers04/linc_luajit.git
haxelib set openfl 9.2.1 --always
haxelib set haxeui-core 1.7.0 --always
haxelib set haxeui-flixel 1.7.0 --always
haxelib set tjson 1.4.0 --always
curl -# -L -O "https://github.com/CobaltBar/SScript-Archive/raw/refs/heads/main/archives/SScript-7,7,0.zip"
haxelib install "SScript-7,7,0.zip"
del "SScript-7,7,0.zip
@echo off
set /p answer=Are you planning on compiling with the debug flag? E.G. "lime test windows -debug" (Y/N)?
if /i "%answer:~,1%" EQU "Y" echo haxelib install hxcpp-debug-server & haxelib set hxcpp-debug-server 1.2.4 --always
if /i "%answer:~,1%" EQU "N" echo Skipping hxcpp-debug-server
echo DONE
pause
