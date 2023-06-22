@echo Updating plugins using packer
@rem nvim --headless -u %HOME%\VimConfig\lua\init.lua -c "PackerSync"
@nvim -u %HOME%\VimConfig\lua\init.lua -c ":PackerInstall" -c ":PackerCompile"
