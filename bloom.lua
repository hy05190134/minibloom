local bitset = require 'bitset'
local crc32 = require 'crc32'

local _M = {bits = 5000, hashes = 40}

local function _parse(s)
    local bits, hashes, str = s:match('^(%d+);(%d+);(.*)$')
    local set = {}

    local len = string.len(str)
    for i = 0, len-1 do
        local val = string.byte(str, i+1)
        for j = 7, 0, -1 do
            if val >= 2 ^ j then
                set[i*8+j] = 1
                val = val - 2^j
            end
        end
    end

    return {
        bits=bits,
        hashes=hashes,
        set=set,
    }
end


function _M.init(bits, hashes)
    local set

    if type(bits)=='string' then
        -- serialized filter pased as parameter, regenerate
        local from = _parse(bits)
        set = bitset(from.set)
        hashes = from.hashes
        bits = from.bits
    else
        set = bitset()
    end


    local filter = {
        add = function(v)
            for i = 1, hashes do
                local h = crc32(tostring(i)..v)
                --exec metatable __new_index
                set[h%bits] = true
            end
        end,
        test = function(v)
            for i = 1, hashes do
                local h = crc32(tostring(i)..v)
                --exec metatable __index
                if set[h%bits] == false then 
                    return false
                end
            end
            return true
        end,
        serialize = function()
            local s = ''
            s = s .. tostring(bits) .. ';' .. tostring(hashes) .. ';'
            local tmp = 0
            for i = 0, bits-1 do
                if set[i] then
                    tmp = tmp + 2^(i % 8)
                end
                if i % 8 == 7 then
                    s = s .. (string.char(tmp))
                    tmp = 0
                end
            end
            return s
        end,
    }
    return filter
end

return _M
