local Gamestate = require 'vendor/gamestate'

local RaveSwitch = {}
RaveSwitch.__index = RaveSwitch

function RaveSwitch.new(node, collider)
    local raveswitch = {}
    setmetatable(raveswitch, RaveSwitch)
    raveswitch.bb = collider:addRectangle(node.x, node.y, node.width, node.height)
    raveswitch.bb.node = raveswitch
    raveswitch.player_touched = false
    raveswitch.level = node.properties.level
    raveswitch.reenter = node.properties.reenter
    raveswitch.toDoor = node.properties.toDoor
    raveswitch.height = node.height
    raveswitch.width = node.width
    collider:setPassive(raveswitch.bb)
    return raveswitch
end

function RaveSwitch:switch(player)
    local level = Gamestate.get(self.level)
    local current = Gamestate.currentState()

    current.collider:setPassive(player.bb)
    Gamestate.switch(self.level,player.character)
    if self.toDoor ~= nil then
        local level = Gamestate.get(self.level)
        local coordinates = {x=level.doors[self.toDoor].x,
                             y=level.doors[self.toDoor].y,
                             }
        level.player.position = {x=coordinates.x+self.width/2-24, 
        y=coordinates.y+self.height-48} -- Copy, or player position corrupts entrance data
        
        if level.doors[self.toDoor].warpin then
            level.player:respawn()
        end
    end
end

function RaveSwitch:keypressed( button, player )
    if button == 'A' then
        self:switch(player)
    end
end

return RaveSwitch
