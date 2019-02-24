module API # module H3

# types
export GeoCoord, GeoBoundary, CoordIJ

# Indexing functions
export geoToH3, h3ToGeo, h3ToGeoBoundary

# Index inspection functions
export h3GetResolution, h3GetBaseCell, stringToH3, h3ToString, h3IsValid, h3IsResClassIII, h3IsPentagon

# Grid traversal functions
export kRing, maxKringSize, kRingDistances, hexRange, hexRangeDistances, hexRanges, hexRing, h3Line, h3LineSize, h3Distance, experimentalH3ToLocalIj, experimentalLocalIjToH3


using ..Lib

# types
using .Lib: H3Index, GeoCoord, GeoBoundary, CoordIJ


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

function kRing(origin::H3Index, k::Int)::Vector{H3Index}
    array_len = Lib.maxKringSize(k)
    krings = Vector{H3Index}(undef, array_len)
    Lib.kRing(origin, k, krings)
    krings
end

function maxKringSize(k::Int)::Int
    Lib.maxKringSize(k)
end

function kRingDistances(origin::H3Index, k::Int)::NamedTuple{(:out, :distances)}
    array_len = Lib.maxKringSize(k)
    out = Vector{H3Index}(undef, array_len)
    distances = Vector{Cint}(undef, array_len)
    Lib.kRingDistances(origin, k, out, distances)
    (out = out, distances = distances)
end

function hexRange(origin::H3Index, k::Int)::Vector{H3Index}
    array_len = Lib.maxKringSize(k)
    out = Vector{H3Index}(undef, array_len)
    Lib.hexRange(origin, k, out)
    out
end

function hexRangeDistances(origin::H3Index, k::Int)::NamedTuple{(:out, :distances)}
    array_len = Lib.maxKringSize(k)
    out = Vector{H3Index}(undef, array_len)
    distances = Vector{Cint}(undef, array_len)
    Lib.hexRangeDistances(origin, k, out, distances)
    (out = out, distances = distances)
end

function hexRanges(h3Set::Vector{H3Index}, k::Int)::Vector{H3Index}
    array_len = Lib.maxKringSize(k)
    out = Vector{H3Index}(undef, array_len)
    Lib.hexRanges(h3Set, length(h3Set), k, out)
    out
end

function hexRing(origin::H3Index, k::Int)::Vector{H3Index}
    out = Vector{H3Index}(undef, 6k)
    Lib.hexRing(origin, k, out)
    out
end

function h3Line(origin::H3Index, destination::H3Index)::Vector{H3Index}
    line_size = Lib.h3LineSize(origin, destination)
    out = Vector{H3Index}(undef, line_size)
    Lib.h3Line(origin, destination, out)
    out
end

function h3LineSize(origin::H3Index, destination::H3Index)::Int
    Lib.h3LineSize(origin, destination)
end

function h3Distance(origin::H3Index, h3::H3Index)::Int
    Lib.h3Distance(origin, h3)
end

function experimentalH3ToLocalIj(origin::H3Index, h3::H3Index)::CoordIJ
    refij = Ref{CoordIJ}()
    Lib.experimentalH3ToLocalIj(origin, h3, refij)
    refij[]
end

function experimentalLocalIjToH3(origin::H3Index, ij::CoordIJ)::H3Index
    refh3 = Ref{H3Index}()
    Lib.experimentalLocalIjToH3(origin, Ref(ij), refh3)
    refh3[]
end

end # module H3.API
