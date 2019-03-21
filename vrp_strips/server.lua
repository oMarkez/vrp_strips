--[[              
  /     \  _____     __| _/  ____   \______   \ ___.__.   ____    /     \  _____   _______ |  | __  ____  ________
 /  \ /  \ \__  \   / __ | _/ __ \   |    |  _/<   |  |  /  _ \  /  \ /  \ \__  \  \_  __ \|  |/ /_/ __ \ \___   /
/    Y    \ / __ \_/ /_/ | \  ___/   |    |   \ \___  | (  <_> )/    Y    \ / __ \_ |  | \/|    < \  ___/  /    / 
\____|__  /(____  /\____ |  \___  >  |______  / / ____|  \____/ \____|__  /(____  / |__|   |__|_ \ \___  >/_____ \
        \/      \/      \/      \/          \/  \/                      \/      \/              \/     \/       \/

------------------------CREDITS------------------------
--   Copyright 2019 �oMarkez. All rights reserved    --
-------------------------------------------------------

]]


local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vRP_atm")

playerstrips = {}

vRP.registerMenuBuilder({"main", function(add, data)
    local user_id = vRP.getUserId({data.player})
	if user_id ~= nil then
        local choices = {}
        
        choices[config.titler.menutitel] = {function(player,choice)
            local menu = {name="Funktioner",css={top="75px",header_color="rgba(225,160,0,0.75)"}}
            menu.onclose = function(player) vRP.openMainMenu({player}) end -- nest menu

            menu[config.titler.funktiontitel] = {function(player,choice)
                vRPclient.getNearestPlayer(player,{5},function(nplayer)
                    if nplayer ~= nil then
                        if playerstrips[nplayer] == nil then
                            if vRP.tryGetInventoryItem({user_id,config.itemname,1,true}) then
                                vRPclient.toggleHandcuff(nplayer,{})
                                vRPclient.notify(player,{"Du har puttet strips på den nærmeste spiler!"})
                                playerstrips[nplayer] = {status = "on"}
                            end
                        elseif playerstrips[nplayer].status == "off" then
                            if vRP.tryGetInventoryItem({user_id,config.itemname,1,true}) then
                                vRPclient.toggleHandcuff(nplayer,{})
                                vRPclient.notify(player,{"Du har puttet strips på den nærmeste spiler!"})
                                playerstrips[nplayer] = {status = "on"}
                            end
                        elseif playerstrips[nplayer].status == "on" then
                            vRPclient.toggleHandcuff(nplayer,{})
                            vRPclient.notify(player,{"Du har taget strips af den nærmeste spiler!"})
                            playerstrips[nplayer] = {status = "off"}
                        end
                    end
                end)
            end,"Put strips på en anden - kræver at du har nogle strips"}

            vRP.openMenu({player, menu})
        end}
		add(choices)
	end
end})