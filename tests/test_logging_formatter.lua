local json = require 'cc-libs.util.json'

local formatter = require 'cc-libs.util.logging.formatter'
local Record = formatter.Record
local Formatter = formatter.Formatter
local ShortFormatter = formatter.ShortFormatter
local LongFormatter = formatter.LongFormatter
local JsonFormatter = formatter.JsonFormatter

local test = {}

function test.record()
    local r = Record:new('ss', 1, 'lc', 'msg', 1234)
    expect_eq('ss', r.subsystem)
    expect_eq(1, r.level)
    expect_eq('lc', r.location)
    expect_eq('msg', r.message)
    expect_eq(1234, r.time)
end

function test.formatter()
    local f = Formatter:new()
    local r = Record:new('ss', 1, 'lc', 'msg', 1234)
    expect_eq('msg', f:format_record(r))
end

function test.short_formatter()
    local f = ShortFormatter:new()
    local r = Record:new('ss', 1, 'lc', 'msg', 1234)
    expect_eq('[ss] msg', f:format_record(r))
end

function test.long_formatter()
    local f = LongFormatter:new()
    local r = Record:new('ss', 1, 'lc', 'msg', 1741354307)
    local local_date = os.date('%Y-%m-%dT%H:%M:%S', 1741354307)
    expect_eq('[' .. local_date .. '] [ss] [lc] [debug] msg', f:format_record(r))
end

function test.json_formatter()
    local f = JsonFormatter:new()
    local r = Record:new('ss', 1, 'lc', 'msg', 1741354307)
    local local_date = os.date('%Y-%m-%dT%H:%M:%S', 1741354307)
    local text = f:format_record(r)
    local decoded = json.decode(text)
    expect_eq(local_date, decoded.timestamp)
    expect_eq('ss', decoded.subsystem)
    expect_eq('lc', decoded.location)
    expect_eq('debug', decoded.level)
    expect_eq('msg', decoded.message)
end

return test
