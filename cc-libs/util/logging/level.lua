---@enum LogLevel
local Level = {
    DISABLED = nil,
    TRACE = 0,
    DEBUG = 1,
    INFO = 2,
    WARNING = 3,
    ERROR = 4,
    FATAL = 5,
}

local level_name_map = {
    [Level.TRACE] = 'trace',
    [Level.DEBUG] = 'debug',
    [Level.INFO] = 'info',
    [Level.WARNING] = 'warning',
    [Level.ERROR] = 'error',
    [Level.FATAL] = 'fatal',
}

local M = {
    Level = Level,
}

---Get the string name of a level
---@param level number|LogLevel level or level number
---@return string
function M.level_name(level)
    return level_name_map[level]
end

---Get the level from it's string name
---@param name string name of the level
---@return LogLevel? level number
function M.name_from_name(name)
    name = name:lower()
    for lvl, lvl_name in pairs(level_name_map) do
        if lvl_name == name then
            return lvl
        end
    end
end

return M
