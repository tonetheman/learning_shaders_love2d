-- circle in the middle
function compute_stars1(fc)
    local uv = normalizeByRes(fc)

    -- scooch everything over
    uv.x = uv.x-0.5
    uv.y = uv.y-0.5
    
    multInPlace(uv,3.0)
    local col = v3(0,0,0)
    local d = length(uv)
    local m = 0.2/d
    addInPlace(col,m)
    return {r=col.x,g=col.y,b=col.z}
end

function compute_stars2(fc)
    local uv = normalizeByRes(fc)

    -- scooch everything over
    uv.x = uv.x-0.5
    uv.y = uv.y-0.5

    multInPlace(uv,3.0)
    local col = v3(0,0,0)
    local d = length(uv)
    local m = 0.2/d

    -- difference here
    m = math.abs(uv.x*uv.y)

    addInPlace(col,m)
    return {r=col.x,g=col.y,b=col.z}
end

-- flip to white
function compute_stars3(fc)
    local uv = normalizeByRes(fc)

    -- scooch everything over
    uv.x = uv.x-0.5
    uv.y = uv.y-0.5

    multInPlace(uv,3.0)
    local col = v3(0,0,0)
    local d = length(uv)
    local m = 0.2/d

    -- difference here
    m = 1-math.abs(uv.x*uv.y)

    addInPlace(col,m)
    return {r=col.x,g=col.y,b=col.z}
end

-- flip to white
function compute_stars4(fc)
    local uv = normalizeByRes(fc)

    -- scooch everything over
    uv.x = uv.x-0.5
    uv.y = uv.y-0.5

    multInPlace(uv,3.0)
    local col = v3(0,0,0)
    local d = length(uv)
    local m = 0.2/d

    -- difference here
    m = 1-math.abs(uv.x*uv.y*10)

    addInPlace(col,m)
    return {r=col.x,g=col.y,b=col.z}
end

-- not right
function compute_stars5(fc)
    local uv = normalizeByRes(fc)

    -- scooch everything over
    uv.x = uv.x-0.5
    uv.y = uv.y-0.5

    multInPlace(uv,3.0)
    local col = v3(0,0,0)
    local d = length(uv)
    local m = 0.05/d
    addInPlace(col,m)

    -- difference here
    local rays = max(0, 1-math.abs(uv.x*uv.y*1000))
    addInPlace(col,rays)
    
    return {r=col.x,g=col.y,b=col.z}
end

function compute_stars6(fc)
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

    --  float d = length(uv);
    local d = length(uv)
    
    -- float m = 0.05/d;
    local m = 0.05/d

    -- col += m;
    col.x = col.x + m
    col.y = col.y + m
    
    -- float rays = max(0.0, 1.0-abs(uv.x*uv.y*1000.0));
    local rays = max(0, 1.0-math.abs(uv.x*uv.y*1000.0))

    -- col += rays;
    col.x = col.x + rays
    col.y = col.y + rays
    
    return {r=col.x,g=col.x,b=col.x}
end

-- now has 2 sets of points
function compute_stars7(fc)
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

    --  float d = length(uv);
    local d = length(uv)
    
    -- float m = 0.05/d;
    local m = 0.05/d

    -- col += m;
    col.x = col.x + m
    col.y = col.y + m
    
    -- float rays = max(0.0, 1.0-abs(uv.x*uv.y*1000.0));
    local rays = max(0, 1.0-math.abs(uv.x*uv.y*1000.0))

    -- col += rays;
    col.x = col.x + rays
    col.y = col.y + rays
    
    -- uv *= Rot(3.14159/4) ???
    local tmp2 = Rot(3.14159/4)
    matMultInPlace(uv,tmp2)

    -- rays = max(0.0, 1.0-abs(uv.x*uv.y*1000.0));
    rays = max(0, 1.0-math.abs(uv.x*uv.y*1000.0))

    -- col += rays;
    col.x = col.x + 0.3*rays
    col.y = col.y + 0.3*rays

    return {r=col.x,g=col.x,b=col.x}
end
