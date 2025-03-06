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

---@class ConsoleHandler
---@field level number|LogLevel message level filter
local ConsoleHandler = {}

---@param level number|LogLevel
function ConsoleHandler:new(level)
    local o = {
        level = level,
    }
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
---@field level number|LogLevel message level filter
---@field filename string path to log file
---@field file? file* open file
local FileHandler = {}

---@param level number|LogLevel
---@param filename string
function FileHandler:new(level, filename)
    assert(filename ~= nil, 'FileHandler missing filename')
    local o = {
        level = level,
        filename = filename,
    }
    setmetatable(o, self)
    self.__index = self
    return o
end

---Open file for writing messages. If a file is open it will be closed first.
---@param path string path to the log file
function FileHandler:open_file(path)
    assert(path ~= nil)

    if self.file ~= nil then
        self.file:close()
        self.file = nil
    end

    local file, err = io.open(path)
    if file then
        self.file = file
    else
        print('Error opening log file: ' .. err)
    end
end

---Log to a file in human readable format
---@param logger Logger the logger object
---@param message string the message rendered as a string
---@param level number|LogLevel message level
---@param debug_info debuginfo debug info for traceback
function FileHandler:message(logger, message, level, debug_info)
    if self.file == nil then
        self:open_file(self.filename)
    end
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

---@class MachineFileHandler
---@field level number|LogLevel message level filter
---@field filename string path to log file
---@field file? file* open file
local MachineFileHandler = {}

function MachineFileHandler:new(level, filename)
    assert(filename ~= nil, 'MachineFileHandler missing filename')
    local o = {
        level = level,
        filename = filename,
    }
    setmetatable(o, self)
    self.__index = self
    return o
end

---Open file for writing messages. If a file is open it will be closed first.
---@param path string path to the log file
function MachineFileHandler:open_file(path)
    assert(path ~= nil)

    if self.file ~= nil then
        self.file:close()
        self.file = nil
    end

    local file, err = io.open(path)
    if file then
        self.file = file
    else
        print('Error opening log file: ' .. err)
    end
end

---Log to a file in machine readable format
---@param logger Logger the logger object
---@param message string the message rendered as a string
---@param level number|LogLevel message level
---@param debug_info debuginfo debug info for traceback
function MachineFileHandler:message(logger, message, level, debug_info)
    if self.file == nil then
        self:open_file(self.filename)
    end
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
    ConsoleHandler = ConsoleHandler,
    MachineFileHandler = MachineFileHandler,
}
