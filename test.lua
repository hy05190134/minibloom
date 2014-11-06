--[[
local set = require'bitset'()
set[10] = true
set[10000] = true
set[15] = true
set[8] = false

--set.dump()

if set[10] then print "10 is in the set" end
if not set[10000] then print "10000 is not in the set" end
--]]

local bloom = require 'bloom'
local filter = bloom.init(5000, 40)

local strings = {
    'xxxxxxx',
    'http://aa.bb',
    'http://bb.cc',
    'http://cc.dd',
    'yxccsddasfsdafasfvsdvfvfvyy2',
    'yxccsddasfsdafasfvsdvfvfvyy3',
    'fdsfdsfdffffffffffffffffffff'
}

for _, s in ipairs(strings) do
  filter.add(s)
end


local serialized = filter.serialize()
print('serialized', serialized)
local filter2 = bloom.init(serialized)

print (filter2.test('http://aa.bb'))
print (filter2.test('yxccsdvsdvfvfvyy'))

