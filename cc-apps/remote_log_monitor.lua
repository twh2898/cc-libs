package.path = '../?.lua;../?/init.lua;' .. package.path

local json = require 'cc-libs.util.json'
local logging = require 'cc-libs.util.logging'

peripheral.find('modem', rednet.open)

local fmt = logging.ShortFormatter:new()
local stream = logging.ConsoleStream:new()

while true do
    local id, message = rednet.receive('remote_log')
    local success, data = pcall(json.decode, message)
    if not success then
        print('Failed to decode message from ' .. id)
    elseif logging.level_from_name(data['level']) >= logging.Level.WARNING then
        stream:send('[' .. data['host'] .. '] ' .. fmt:format_record(data))
    end
end
