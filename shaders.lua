-- just red
function compute_color0(fc)
    -- normalize the 0-W,0-H to
    -- 0-1.0
    local uv = normalizeByRes(fc)
    return {r=1,g=0,b=0}
end

-- gradual red from left to right
function compute_color1(fc)
    -- normalize the 0-W,0-H to
    -- 0-1.0
    local uv = normalizeByRes(fc)
    return {r=uv.x,g=0,b=0}
end

-- gradual red from bottom to top
-- why bottom to top
-- shaders 0,0 is bottom left
function compute_color2(fc)
    -- normalize the 0-W,0-H to
    -- 0-1.0
    local uv = normalizeByRes(fc)
    return {r=uv.y,g=0,b=0}
end

-- first shader from the video
function compute_color3(fc)
    -- normalize the 0-W,0-H to
    -- 0-1.0
    local uv = normalizeByRes(fc)
    return {r=uv.x,g=uv.y,b=0}
end

-- start of a circle
-- uniform color kind of a circle in the bottom left
function compute_color4(fc)
    -- normalize the 0-W,0-H to
    -- 0-1.0
    local uv = normalizeByRes(fc)
    local d = length(uv)
    return {r=d,g=d,b=d}
end

-- move the circle to the middle
function compute_color5(fc)
    -- normalize the 0-W,0-H to
    -- 0-1.0
    local uv = normalizeByRes(fc)

    -- remap the range to -0.5 to 0.5
    uv.x = uv.x-0.5
    uv.y = uv.y-0.5
    
    local d = length(uv)
    return {r=d,g=d,b=d}
end

-- use a non continuous function
-- to show a sharp ellipse
function compute_color6(fc)
    -- normalize the 0-W,0-H to
    -- 0-1.0
    local uv = normalizeByRes(fc)

    -- remap the range to -0.5 to 0.5
    uv.x = uv.x-0.5
    uv.y = uv.y-0.5
    
    local d = length(uv)
    -- this will force d to be 0 or 1 only
    -- based on the radius of 0.3
    if d<0.3 then
        d=1
    else
        d=0
    end

    return {r=d,g=d,b=d}
end

-- make it a circle
-- by adjust the X value
-- by aspect ratio
function compute_color7(fc)
    -- normalize the 0-W,0-H to
    -- 0-1.0
    local uv = normalizeByRes(fc)

    -- remap the range to -0.5 to 0.5
    uv.x = uv.x-0.5
    uv.y = uv.y-0.5

    -- this will get rid of the distortion
    -- since it is wider than higher
    -- need to adjust x by the aspect ratio
    -- W/H
    uv.x = uv.x * (W/H)
    

    local d = length(uv)
    -- this will force d to be 0 or 1 only
    -- based on the radius of 0.3
    if d<0.3 then
        d=1
    else
        d=0
    end

    return {r=d,g=d,b=d}
end


-- now a smoother transition
-- on the edges using a smoothstep
-- at the edges of the circle
function compute_color8(fc)
    -- normalize the 0-W,0-H to
    -- 0-1.0
    local uv = normalizeByRes(fc)
        
    -- remap the range to -0.5 to 0.5
    uv.x = uv.x-0.5
    uv.y = uv.y-0.5

    -- this will get rid of the distortion
    -- since it is wider than higher
    -- need to adjust x by the aspect ratio
    -- W/H
    uv.x = uv.x * (W/H)

    local d = length(uv)

    -- radius of the circle (normalized)
    local r = 0.3

    -- smooth step the values
    -- trying to go from 1 to 0
    -- to get a smooth edge on the circle
    local c = smoothstep(r,r-0.01,d)

    return {r=c,g=c,b=c}
end
