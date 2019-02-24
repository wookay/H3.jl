module API # module H3

# types
export GeoCoord, GeoBoundary

# Indexing functions
export geoToH3, h3ToGeo, h3ToGeoBoundary

# Index inspection functions
export h3GetResolution, h3GetBaseCell, stringToH3, h3ToString, h3IsValid, h3IsResClassIII, h3IsPentagon

# Grid traversal functions
export kRing


using ..Lib

# types
using .Lib: H3Index, GeoCoord, GeoBoundary


# Indexing functions

function geoToH3(location::GeoCoord, resolution::Int)::H3Index
    Lib.geoToH3(Ref(location), resolution)
end

function h3ToGeo(h::H3Index)::GeoCoord
    refcenter = Ref{GeoCoord}()
    Lib.h3ToGeo(h, refcenter)
    refcenter[]
end

function h3ToGeoBoundary(h::H3Index)::GeoBoundary
    refboundary = Ref{GeoBoundary}()
    Lib.h3ToGeoBoundary(h, refboundary)
    numVerts = refboundary[].numVerts
    verts = refboundary[].verts[1:numVerts]
    GeoBoundary(numVerts, NTuple{10, GeoCoord}((verts..., ntuple(x->GeoCoord(0, 0), 10-numVerts)...)))
end


# Index inspection functions

function h3GetResolution(h::H3Index)::Int
    Lib.h3GetResolution(h)
end

function h3GetBaseCell(h::H3Index)::Int
    Lib.h3GetBaseCell(h)
end

function stringToH3(str::String)::H3Index
    Lib.stringToH3(str)
end

function h3ToString(h::H3Index)::String
    bufSz = 17 # 16 hexadecimal characters plus a null terminator
    buf = Base.unsafe_convert(Cstring, "")
    Lib.h3ToString(h, buf, bufSz)
    Base.unsafe_string(buf)
end

function h3IsValid(h::H3Index)::Bool
    Bool(Lib.h3IsValid(h))
end

function h3IsResClassIII(h::H3Index)::Bool
    Bool(Lib.h3IsResClassIII(h))
end

function h3IsPentagon(h::H3Index)::Bool
    Bool(Lib.h3IsPentagon(h))
end


# Grid traversal functions

function kRing(origin::H3Index, ring_size::Int)::Vector{H3Index}
    array_len = Lib.maxKringSize(ring_size)
    krings = Vector{H3Index}(undef, array_len)
    Lib.kRing(origin, ring_size, krings)
    krings
end

end # module H3.API
