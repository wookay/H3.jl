module Lib # module H3

include("../deps/deps.jl")
include("../gen/libh3_types.jl")
include("../gen/libh3_functions.jl")

using CEnum # @cenum

###
#
# * descriptions are taken from
#   - https://github.com/uber/h3/tree/master/docs/api
#   - https://github.com/uber/h3/blob/master/src/h3lib/include/h3api.h.in
#
###


### Constants

const H3_INIT               = UInt64(35184372088831)  # H3 index with mode 0, res 0, base cell 0, and 7 for all index digits.  0x00001fffffffffff
const H3_MODE_OFFSET        = 59  # The bit offset of the mode in an H3 index.
const H3_MODE_MASK          = UInt64(15) << H3_MODE_OFFSET  # 1's in the 4 mode bits, 0's everywhere else.  0x7800000000000000
const H3_MODE_MASK_NEGATIVE = ~H3_MODE_MASK
const MAX_H3_RES            = 15  # max H3 resolution; H3 version 1 has 16 resolutions, numbered 0 through 15
const H3_PER_DIGIT_OFFSET   = 3   # The number of bits in a single H3 resolution digit.
const H3_DIGIT_MASK         = UInt64(7)  # 1's in the 3 bits of res 15 digit bits, 0's everywhere else.
const H3_HEXAGON_MODE       = 1  # H3 index modes
const H3_UNIEDGE_MODE       = 2  # H3 index modes
const NUM_BASE_CELLS        = 122  # The number of H3 base cells


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

"""
    Direction

H3 digit representing ijk+ axes direction. Values will be within the lowest 3 bits of an integer.
"""
Direction

@cenum(Direction,
    CENTER_DIGIT  = 0,  # H3 digit in center
    K_AXES_DIGIT  = 1,  # H3 digit in k-axes direction
    J_AXES_DIGIT  = 2,  # H3 digit in j-axes direction
    JK_AXES_DIGIT = 3,  # H3 digit in j == k direction
    I_AXES_DIGIT  = 4,  # H3 digit in i-axes direction
    IK_AXES_DIGIT = 5,  # H3 digit in i == k direction
    IJ_AXES_DIGIT = 6,  # H3 digit in i == j direction
    INVALID_DIGIT = 7,  # H3 digit in the invalid direction
)


### H3Index functions

"""
    setH3Index(refh::Ref{H3Index}, res::Int, baseCell::Int, initDigit::Union{Int, Direction})

Initializes an H3 index.
"""
function setH3Index(refh::Ref{H3Index}, res::Int, baseCell::Int, initDigit::Union{Int, Direction})
    ccall((:setH3Index, libh3), Cvoid, (Ptr{H3Index}, Cint, Cint, Direction), refh, res, baseCell, initDigit)
end

"""
    h3GetIndexDigit(h::H3Index, res::Int)::Direction

Gets the resolution res integer digit (0-7) of h3.
`#define H3_GET_INDEX_DIGIT(h3, res)`
"""
function h3GetIndexDigit(h::H3Index, res::Int)::Direction
    Direction((h >> ((MAX_H3_RES - res) * H3_PER_DIGIT_OFFSET)) & H3_DIGIT_MASK)
end

"""
    h3GetMode(h::H3Index)::Int

Gets the integer mode of h3.
`#define H3_GET_MODE(h3)`
"""
function h3GetMode(h::H3Index)::Int
    Int((h & H3_MODE_MASK) >> H3_MODE_OFFSET)
end

"""
    h3SetMode(refh::Ref{H3Index}, v::Int)

Sets the integer mode of h3 to v.
`#define H3_SET_MODE(h3, v)`
"""
function h3SetMode(refh::Ref{H3Index}, v::Int)
    refh[] = (refh[] & H3_MODE_MASK_NEGATIVE) | (UInt64(v) << H3_MODE_OFFSET)
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
