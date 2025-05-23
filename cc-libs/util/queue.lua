---@class queue
local queue = {}

---Create a new empty queue
---@return queue
function queue:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

---Push a single element to the back of the queue
---@param e any element
function queue:push(e)
    self[#self + 1] = e
end

---Remove and return a single element from the front of the queue
---@return any
function queue:pop()
    if #self > 0 then
        return table.remove(self, 1)
    else
        return nil
    end
end

---Return the front element of the queue or nil if the queue is empty
---@return any
function queue:peek()
    if #self > 0 then
        return self[1]
    else
        return nil
    end
end

return queue
