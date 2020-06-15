
-- simple way to make a vector like
-- table in lua
-- not memory efficient
function v3(x,y,z)
    local self = {x=x,y=y,z=z}
    return self
end

-- take a source vector and make a copy
-- used for places that return new value
function v3copy(src)
    return v3(src.x,src.y,src.z)
end

-- take in x and y
-- return the values
-- scaled by W and H respectively
-- looks like
-- vec2 uv = fragCoord.xy/iResolution.xy in videos
-- returns 0.0 - 1.0
function normalizeByRes(fc)
    return {x=fc.x/W,y=fc.y/H}
end

function length(fc)
    -- dist of fc from origin
    local tx = fc.x-0.0
    local ty = fc.y-0.0
    return math.sqrt(tx*tx+ty*ty)
end

-- clamp a value
-- between lo and hi
function clamp(v,lo,hi)
    if v>hi then
        return hi
    end
    if v<lo then
        return lo
    end
    return v
end

--[[
    t1 is lower edge
    t2 is higher edge
    v is source value for interpolation
]]
function smoothstep(t1,t2,v)
    local t = clamp((v-t1)/(t2-t1),0,1)
    return t
end


function addInPlace(v,scalar)
    v.x = v.x + scalar
    v.y = v.y + scalar
    v.z = v.z + scalar
end

function multInPlace(v,scalar)
    v.x = v.x * scalar
    v.y = v.y * scalar
    -- v.z = v.z * scalar
end

function max(x,y)
    if y>x then
        return y
    end
    return x
end

function subtractNew(v1,v2)
    return v3(v1.x-v2.x,v1.y-v2.y,0)
end

function Rot(a)
    local tmp = {}
    local s = math.sin(a)
    local c = math.cos(a)
    tmp[1] = {c,-s}
    tmp[2] = {s,c}
    return tmp -- rotation matrix
end

--[[
    pass a vector
    pass a matrix
    overwrite the vector in place with result
]]
function matMultInPlace(dst,mat)
    local v1 = dst.x*mat[1][1] + dst.y*mat[1][2]
    local v2 = dst.x*mat[2][1] + dst.y*mat[2][2]
    dst.x = v1
    dst.y = v2
end

function fract(n)
    if n ~= nil then
        local a,b = math.modf(n)
        return b
    end
    return 0
end

function fract_v3(v)
    return {x = fract(v.x), y = fract(v.y), z = fract(v.z)}
end
