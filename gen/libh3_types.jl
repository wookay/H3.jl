# Automatically generated using Clang.jl

using CEnum


# Skipping MacroDefinition: H3_EXPORT ( name ) name

const H3_VERSION_MAJOR = 3
const H3_VERSION_MINOR = 6
const H3_VERSION_PATCH = 3
const MAX_CELL_BNDRY_VERTS = 10
const H3Index = UInt64

struct GeoCoord
    lat::Cdouble
    lon::Cdouble
end

struct GeoBoundary
    numVerts::Cint
    verts::NTuple{10, GeoCoord}
end

struct Geofence
    numVerts::Cint
    verts::Ptr{GeoCoord}
end

struct GeoPolygon
    geofence::Geofence
    numHoles::Cint
    holes::Ptr{Geofence}
end

struct GeoMultiPolygon
    numPolygons::Cint
    polygons::Ptr{GeoPolygon}
end

struct LinkedGeoCoord
    vertex::GeoCoord
    next::Ptr{LinkedGeoCoord}
end

struct LinkedGeoLoop
    first::Ptr{LinkedGeoCoord}
    last::Ptr{LinkedGeoCoord}
    next::Ptr{LinkedGeoLoop}
end

struct LinkedGeoPolygon
    first::Ptr{LinkedGeoLoop}
    last::Ptr{LinkedGeoLoop}
    next::Ptr{LinkedGeoPolygon}
end

struct CoordIJ
    i::Cint
    j::Cint
end

