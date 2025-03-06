local json = require 'cc-libs.util.json'

local level = require 'cc-libs.util.logging.level'
local Level = level.Level

local handler = require 'cc-libs.util.logging.handler'

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

---@class Logger
---@field subsystem string name of the subsystem
---@field level number|LogLevel minimum log level for terminal logging
---@field file_level number|LogLevel minimum log level for file logging
---@field machine_log boolean write log file in a machine readable format (json)
---@field file? string active log file path if _file is not nil
---@field _file? file*
---@field _subsystems { [string]: Logger }
---@field _handlers Handler[]
local M = {
    Level = Level,
    level_name = level.level_name,
    name_from_name = level.name_from_name,
    file = nil,
    _file = nil,
    _subsystems = {},
    _handlers = {},
}

---Create a new logger for the given subsystem with print and file log Level
---@param subsystem string the subsystem name
---@param level? number|LogLevel the print log level
---@param file_level? number|LogLevel the file log level
---@param machine_log? boolean change log file to machine readable format
---@return Logger
function M:new(subsystem, level, file_level, machine_log)
    local o = {
        subsystem = subsystem or 'undefined',
        level = level,
        file_level = file_level,
        machine_log = machine_log or false,
    }
    setmetatable(o, self)
    self.__index = self
    return o
end

---Get the logger object for the give subsystem name
---@param subsystem string name of the subsystem
---@return Logger
function M.get_logger(subsystem)
    local exists = M._subsystems[subsystem]
    if exists == nil then
        exists = M:new(subsystem)
        M._subsystems[subsystem] = exists
    end
    return exists
end

function M:add_handler(handler)
    table.insert(self._handlers, handler)
end

---Write a log message with level
---@param level number|LogLevel message level
---@param ... any message
function M:log(level, ...)
    assert(level ~= nil, 'level cannot be nil')
    local args = { ... }

    local msg = nil
    local function get_msg()
        if msg then return msg end
        msg = ''
        for i = 1, #args do
            if i == 1 then
                msg = tostring(args[1])
            else
                msg = msg .. ' ' .. tostring(args[i])
            end
        end
        return msg
    end

    local _, trace = traceback()

    for _, handler in ipairs(self._handlers) do
        handler:message(self, get_msg(), level, trace)
    end
end

---Write a log message with TRACE level
---@param ... any message
function M:trace(...)
    self:log(Level.TRACE, ...)
end

---Write a log message with DEBUG level
---@param ... any message
function M:debug(...)
    self:log(Level.DEBUG, ...)
end

---Write a log message with INFO level
---@param ... any message
function M:info(...)
    self:log(Level.INFO, ...)
end

---Write a log message with WARNING level
---@param ... any message
function M:warn(...)
    self:log(Level.WARNING, ...)
end

---Write a log message with WARNING level
---@param ... any message
function M:warning(...)
    self:log(Level.WARNING, ...)
end

---Write a log message with ERROR level
---@param ... any message
function M:error(...)
    self:log(Level.ERROR, ...)
end

---Write a log message with ERROR level and call error()
---@param ... any message
function M:fatal(...)
    self:log(Level.FATAL, ...)
    error(table.concat({ ... }, ''))
end

return M
