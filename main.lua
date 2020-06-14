
local W = nil
local H = nil
local iResolution = nil

require("shaders")
require("stars")

-- simple way to make a vector like
-- table in lua
-- not memory efficient
function v3(x,y,z)
    local self = {x=x,y=y,z=z}
    return self
end
function v3copy(src)
    return v3(src.x,src.y,src.z)
end

function love.load()
    -- load the W and H at startup
    -- that way it is only defined
    -- in the conf.lua file
    W = love.graphics.getWidth()
    H = love.graphics.getHeight()
    iResolution = v3(W,H,0)
end


function normalizeByRes(fc)
    -- take in x and y
    -- return the values
    -- scaled by W and H respectively
    -- looks like
    -- vec2 uv = fragCoord.xy/iResolution.xy in videos
    -- returns 0.0 - 1.0
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

function Star(uv,flare)
    --  float d = length(uv);
    local d = length(uv)

    -- float m = 0.05/d;
    local m = 0.05/d

    -- float rays = max(0.0, 1.0-abs(uv.x*uv.y*1000.0));
    local rays = max(0, 1.0-math.abs(uv.x*uv.y*1000.0))

    m = m + (rays*flare)

    -- uv *= Rot(3.14159/4) ???
    local tmp2 = Rot(3.14159/4)
    matMultInPlace(uv,tmp2)

    -- rays = max(0.0, 1.0-abs(uv.x*uv.y*1000.0));
    rays = max(0, 1.0-math.abs(uv.x*uv.y*1000.0))

    m = m + (0.3*rays)

    return m
end

-- make a single star
-- using a function
function compute_stars8(fc)
    -- after this statement
    -- vec2 uv = (fragCoord-0.5*iResolution.xy)/iResolution.y;
    -- compute .5*iResolution.xy
    local tmp = v3copy(iResolution)
    tmp.x = tmp.x * 0.5
    tmp.y = tmp.y * 0.5
    
    -- do the subtract
    local tmp1 = v3(fc.x-tmp.x,fc.y-tmp.y)

    -- divide by resolution H
    local uv = v3(tmp1.x/H,tmp1.y/H)

    -- after this statement
    -- uv*=3.0;
    uv.x = uv.x * 3.0
    uv.y = uv.y * 3.0

    -- vec3 col = vec3(0);
    local col = v3(0,0,0)

    local res = Star(uv,1.0)

    col.x = col.x + res
    col.y = col.y + res

    return {r=col.x,g=col.x,b=col.x}

end

local compute_stars = compute_stars8

function love.draw()
    for i=1,W do
        for j=1,H do

            -- fc is the fragCoord
            local fc = v3(i,j,0)

            -- compute the color like a shader
            local pt = compute_stars(fc)

            -- set the color returned from the shader
            -- ignore the alpha
            love.graphics.setColor(pt.r,pt.g,pt.b,1.0)
            
            -- set the point
            -- point is using the x,y value
            -- to emphasize the shader only
            -- changes the color and nothing else
            -- notice shaders use 0,0 in botton left corner
            -- to match we are flipping the Y value
            love.graphics.points(i,H-j)
        end
    end
end
