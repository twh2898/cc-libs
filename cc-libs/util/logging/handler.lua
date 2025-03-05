local json = require 'cc-libs.util.json'

---Get a string timestamp for the current time
---@return string
local function timestamp()
    ---@diagnostic disable-next-line: return-type-mismatch
    return os.date('%Y-%m-%dT%H:%M:%S')
end

---Get a string with filename and line of the calling code
---@return string traceback, table info name and debug info
local function traceback()
    local info = debug.getinfo(3, 'Slfn')
    for _, check in ipairs({ 'trace', 'debug', 'info', 'warn', 'warning', 'error', 'fatal' }) do
        if info.name == check then
            info = debug.getinfo(4, 'Slf')
            break
        end
    end
    local traceback_str = info.source .. ':' .. info.currentline
    return traceback_str, info
end

---@class Handler
---@field name string handler name
---@field level number|LogLevel message level filter
local Handler = {
}

---@param name string handler name
---@param level number|LogLevel handler log level
---@return Handler
function Handler:new(name, level)
    local o = {
        name = name,
        level = level,
    }
    setmetatable(o, self)
    self.__index = self
    return o
end

---Abstract method, overload with derived class
---@param logger Logger the logger object
---@param message string the message rendered as a string
---@param level number|LogLevel message level
---@param debug_info debuginfo debug info for traceback
function Handler:message(logger, message, level, debug_info) end

---@class ConsoleHandler
---@inherits Handler
local ConsoleHandler = {}

function ConsoleHandler:new(level)
    setmetatable(self, { __index = Handler })
    local o = Handler:new('Console', level)
    setmetatable(o, self)
    self.__index = self
    return o
end

---Log to the console using print
---@param logger Logger the logger object
---@param message string the message rendered as a string
---@param level number|LogLevel message level
---@param debug_info debuginfo debug info for traceback
function ConsoleHandler:message(logger, message, level, debug_info)
    local short_msg = '[' .. logger.subsystem .. '] ' .. message
    print(short_msg)
end

---@class FileHandler
---@inherits Handler
---@field filename string path to log file
local FileHandler = {}

function FileHandler:new(level, filename)
    assert(filename ~= nil, 'FileHandler missing filename')
    setmetatable(self, { __index = Handler })
    local o = Handler:new('Console', level)
    o.filename = filename
    setmetatable(o, self)
    self.__index = self
    return o
end

---Log to a file in human readable format
---@param logger Logger the logger object
---@param message string the message rendered as a string
---@param level number|LogLevel message level
---@param debug_info debuginfo debug info for traceback
function FileHandler:message(logger, message, level, debug_info)
    local long_msg = '['
        .. timestamp()
        .. '] ['
        .. logger.subsystem
        .. '] ['
        .. traceback()
        .. '] ['
        .. logger.level_name(level)
        .. '] '
        .. message
    -- TODO write to file
end

---@class MachineFileHandle
---@inherits Handler
---@field filename string path to log file
local MachineFileHandle = {}

function MachineFileHandle:new(level, filename)
    assert(filename ~= nil, 'MachineFileHandler missing filename')
    setmetatable(self, { __index = Handler })
    local o = Handler:new('Console', level)
    o.filename = filename
    setmetatable(o, self)
    self.__index = self
    return o
end

---Log to a file in machine readable format
---@param logger Logger the logger object
---@param message string the message rendered as a string
---@param level number|LogLevel message level
---@param debug_info debuginfo debug info for traceback
function MachineFileHandle:message(logger, message, level, debug_info)
    local _, info = traceback()
    local long_msg = json.encode({
        timestamp = timestamp(),
        subsystem = logger.subsystem,
        location = info.source .. ':' .. info.currentline,
        level = logger.level_name(level),
        msg = message,
    })
    -- TODO write to file
end

return {
    Handler = Handler,
    ConsoleHandler = ConsoleHandler,
    MachineFileHandle = MachineFileHandle,
}
