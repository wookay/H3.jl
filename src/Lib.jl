module Lib # module H3

include("../deps/deps.jl")
include("../gen/libh3_types.jl")
include("../gen/libh3_functions.jl")


###
#
# * the descriptions are taken from
#   - https://github.com/uber/h3/tree/master/docs/api
#   - https://github.com/uber/h3/blob/master/src/h3lib/include/h3api.h.in
#
###

### Types

"""
    const H3Index = UInt64

the H3Index fits within a 64-bit unsigned integer
"""
H3Index

"""
    struct GeoCoord
        lat::Cdouble
        lon::Cdouble
    end

latitude/longitude in radians
"""
GeoCoord

"""
    struct CoordIJ
        i::Cint
        j::Cint
    end

IJ hexagon coordinates
"""
CoordIJ

"""
    struct Vec2d
        x::Cdouble
        y::Cdouble
    end

2D floating-point vector
"""
struct Vec2d
    x::Cdouble
    y::Cdouble
end

"""
    struct Vec3d
        x::Cdouble
        y::Cdouble
        z::Cdouble
    end

3D floating point structure
"""
struct Vec3d
    x::Cdouble
    y::Cdouble
    z::Cdouble
end

"""
    struct CoordIJK
        i::Cint
        j::Cint
        k::Cint
    end

IJK hexagon coordinates
Each axis is spaced 120 degrees apart.
"""
struct CoordIJK
    i::Cint
    j::Cint
    k::Cint
end

"""
    struct FaceIJK
        face::Cint
        coord::CoordIJK
    end

Face number and ijk coordinates on that face-centered coordinate system
"""
struct FaceIJK
    face::Cint
    coord::CoordIJK
end

"""
    struct VertexNode
        from::GeoCoord
        to::GeoCoord
        next::Ptr{VertexNode}
    end

A single node in a vertex graph, part of a linked list
"""
struct VertexNode
    from::GeoCoord
    to::GeoCoord
    next::Ptr{VertexNode}
end

"""
    struct VertexGraph
        buckets::Ptr{Ptr{VertexNode}}
        numBuckets::Cint
        size::Cint
        res::Cint
    end

A data structure to store a graph of vertices
"""
struct VertexGraph
    buckets::Ptr{Ptr{VertexNode}}
    numBuckets::Cint
    size::Cint
    res::Cint
end


### Region functions

"""
    polyfill(refpolygon::Ref{GeoPolygon}, res::Int)::Vector{H3Index}

polyfill takes a given GeoJSON-like data structure and preallocated, zeroed memory, and fills it with the hexagons that are contained by the GeoJSON-like data structure.
"""
function polyfill(refpolygon::Ref{GeoPolygon}, res::Int)::Vector{H3Index}
    numHexagons = Lib.maxPolyfillSize(refpolygon, res)
    out = Vector{H3Index}(undef, numHexagons)
    Lib.polyfill(refpolygon, res, out)
    out
end

"""
    maxPolyfillSize(refpolygon::Ref{GeoPolygon}, res::Int)::Int

maxPolyfillSize returns the number of hexagons to allocate space for when performing a polyfill on the given GeoJSON-like data structure.
"""
maxPolyfillSize

"""
    h3SetToLinkedGeo(h3Set::Vector{H3Index})::Ref{LinkedGeoPolygon}

Create a LinkedGeoPolygon describing the outline(s) of a set of hexagons. Polygon outlines will follow GeoJSON MultiPolygon order: Each polygon will have one outer loop, which is first in the list, followed by any holes.
"""
function h3SetToLinkedGeo(h3Set::Vector{H3Index})::Ref{LinkedGeoPolygon}
    refpolygon = Ref{LinkedGeoPolygon}(LinkedGeoPolygon(C_NULL,C_NULL,C_NULL))
    Lib.h3SetToLinkedGeo(C_NULL, 0, refpolygon)
    refpolygon
end

"""
    destroyLinkedPolygon(refpolygon::Ref{LinkedGeoPolygon})

Free all allocated memory for a linked geo structure. The caller is responsible for freeing memory allocated to the input polygon struct.
"""
destroyLinkedPolygon


### Vertex Graph

"""
    initVertexGraph(refgraph::Ref{VertexGraph}, numBuckets::Int, res::Int)

Initialize a new VertexGraph
"""
function initVertexGraph(refgraph::Ref{VertexGraph}, numBuckets::Int, res::Int)
    ccall((:initVertexGraph, libh3), Cvoid, (Ptr{VertexGraph}, Cint, Cint), refgraph, numBuckets, res)
end

"""
    destroyVertexGraph(refgraph::Ref{VertexGraph})

Destroy a VertexGraph's sub-objects, freeing their memory. The caller is responsible for freeing memory allocated to the VertexGraph struct itself.
"""
function destroyVertexGraph(refgraph::Ref{VertexGraph})
    ccall((:destroyVertexGraph, libh3), Cvoid, (Ptr{VertexGraph},), refgraph)
end

end # module H3.Lib
