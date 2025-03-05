---@meta cc_logging_handler

---@class Handler
---@field name string handler name
---@field level number|LogLevel message level filter
local Handler = {
    Level = Level,
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
---@param debug_info debuginfo debug info for traceback
function Handler:message(logger, message, debug_info) end

---@class ConsoleHandler
---@inherits Handler
local ConsoleHandler = {}

function ConsoleHandler:new(level)
    setmetatable(self, {__index = Handler})
    local o = Handler:new('Console', level)
    setmetatable(o, self)
    self.__index = self
    return o
end

function ConsoleHandler:message(logger, message, debug_info)
end

return {
    Handler = Handler,
    ConsoleHandler = ConsoleHandler,
}
