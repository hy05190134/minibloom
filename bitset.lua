local bitset_meta = {}

-- use masks to easily increase and decrease element
-- when read set[x] exec
function bitset_meta:__index(index)
    local s = self.set[index]
    return s == 1
end


-- when write set[x] = v exec
function bitset_meta:__newindex(index, v)
    local s = self.set[index]
    if v then
        if s == nil then
            self.set[index] = 1
        end
    end
end


return function(set)
    local b = { set = set or {} }
    return setmetatable(b, bitset_meta)
end
