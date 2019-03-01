module Lib # module H3

include("../deps/deps.jl")
include("../gen/libh3_types.jl")
include("../gen/libh3_functions.jl")


###
#
# * the documents taken from
#   - https://github.com/uber/h3/tree/master/docs/api
#   - https://github.com/uber/h3/blob/master/src/h3lib/include/h3api.h.in
#
###

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

end # module H3.Lib
