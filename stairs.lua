local logging = require 'cc-libs.logging'
logging.file = 'stairs.log'
local log = logging.Core

local MOVE_MAX_TRIES = 10

local args = { ... }
if #args < 1 then
    print('Usage: stairs <n> [place stairs]')
    print()
    print('Options:')
    print('    n: number of steps')
    print('    place stairs: true will place stairs from slot 1, limits n to the number of items in slot 1')
    return
end

local n = tonumber(args[1])
local place_stairs = args[2] == 'true' or args[2] == 'yes'

log:info('Starting with parameters n=', n)

log:info('Starting fuel level', turtle.getFuelLevel())
local fuel_need = n * 2 * 2
log:debug('Fuel needed is', fuel_need)
if turtle.getFuelLevel() < fuel_need then
    log:fatal('Not enough fuel! Need', fuel_need)
end

turtle.select(1)
if place_stairs and turtle.getItemCount(1) < n then
    log:fatal('Not enough stairs in slot 1, need', n)
end

local function try_forward()
    local did_move = false
    for _ = 1, MOVE_MAX_TRIES do
        if turtle.forward() then
            did_move = true
            break
        else
            log:debug('Could not move forward, trying to dig')
            turtle.dig()
        end
    end

    if not did_move then
        log:fatal('Failed to move forward after', MOVE_MAX_TRIES, 'attempts')
    end
end

local function try_down()
    local did_move = false
    for _ = 1, MOVE_MAX_TRIES do
        if turtle.down() then
            did_move = true
            break
        else
            log:debug('Could not move down, trying to dig down')
            turtle.digDown()
        end
    end

    if not did_move then
        log:fatal('Failed to move down after', MOVE_MAX_TRIES, 'attempts')
    end
end

local function try_up()
    local did_move = false
    for _ = 1, MOVE_MAX_TRIES do
        if turtle.up() then
            did_move = true
            break
        else
            log:debug('Could not move up, trying to dig down')
            turtle.digUp()
        end
    end

    if not did_move then
        log:fatal('Failed to move up after', MOVE_MAX_TRIES, 'attempts')
    end
end

local function dig_forward()
    if turtle.getFuelLevel() == 0 then
        log:fatal('Ran out of fuel!')
    end

    turtle.dig()
    try_forward()
    turtle.digUp()
    turtle.digDown()
    try_down()
    turtle.digDown()
end

for _ = 1, n do
    dig_forward()
end

-- Return

log:info('Returning to station')

turtle.turnRight()
turtle.turnRight()

for _ = 1, n do
    if place_stairs then
        turtle.placeDown()
    end
    try_up()
    try_forward()
end

turtle.turnRight()
turtle.turnRight()

log:info('Done!')