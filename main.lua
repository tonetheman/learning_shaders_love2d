
local W = nil
local H = nil

require("shaders")

function love.load()
    -- load the W and H at startup
    -- that way it is only defined
    -- in the conf.lua file
    W = love.graphics.getWidth()
    H = love.graphics.getHeight()
end

-- simple way to make a vector like
-- table in lua
-- not memory efficient
function v3(x,y,z)
    local self = {x=x,y=y,z=z}
    return self
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

function normalizeByRes2(fc)
    -- take in x and y
    -- return the values
    -- scaled by W and H respectively
    -- looks like
    -- vec2 uv = fragCoord.xy/iResolution.xy in videos
    -- returns 0.0 - 1.0
    return {x=(fc.x-0.5/W),y=(fc.y-0.5)/H}
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

function compute_stars(fc)
    local uv = normalizeByRes2(fc)
    local col = v3(0,0,0)
    local d = length(uv)
    local m = 0.2/d
    addInPlace(col,m)
    return {r=col.x,g=col.y,b=col.z}
end

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
