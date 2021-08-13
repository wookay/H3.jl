module Lib

using H3_jll
export H3_jll

using CEnum

const uint64_t = UInt64
const UINT64_C = UInt64


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

function geoToH3(g, res)
    ccall((:geoToH3, libh3), H3Index, (Ptr{GeoCoord}, Cint), g, res)
end

function h3ToGeo(h3, g)
    ccall((:h3ToGeo, libh3), Cvoid, (H3Index, Ptr{GeoCoord}), h3, g)
end

function h3ToGeoBoundary(h3, gp)
    ccall((:h3ToGeoBoundary, libh3), Cvoid, (H3Index, Ptr{GeoBoundary}), h3, gp)
end

function maxKringSize(k)
    ccall((:maxKringSize, libh3), Cint, (Cint,), k)
end

function hexRange(origin, k, out)
    ccall((:hexRange, libh3), Cint, (H3Index, Cint, Ptr{H3Index}), origin, k, out)
end

function hexRangeDistances(origin, k, out, distances)
    ccall((:hexRangeDistances, libh3), Cint, (H3Index, Cint, Ptr{H3Index}, Ptr{Cint}), origin, k, out, distances)
end

function hexRanges(h3Set, length, k, out)
    ccall((:hexRanges, libh3), Cint, (Ptr{H3Index}, Cint, Cint, Ptr{H3Index}), h3Set, length, k, out)
end

function kRing(origin, k, out)
    ccall((:kRing, libh3), Cvoid, (H3Index, Cint, Ptr{H3Index}), origin, k, out)
end

function kRingDistances(origin, k, out, distances)
    ccall((:kRingDistances, libh3), Cvoid, (H3Index, Cint, Ptr{H3Index}, Ptr{Cint}), origin, k, out, distances)
end

function hexRing(origin, k, out)
    ccall((:hexRing, libh3), Cint, (H3Index, Cint, Ptr{H3Index}), origin, k, out)
end

function maxPolyfillSize(geoPolygon, res)
    ccall((:maxPolyfillSize, libh3), Cint, (Ptr{GeoPolygon}, Cint), geoPolygon, res)
end

function polyfill(geoPolygon, res, out)
    ccall((:polyfill, libh3), Cvoid, (Ptr{GeoPolygon}, Cint, Ptr{H3Index}), geoPolygon, res, out)
end

function h3SetToLinkedGeo(h3Set, numHexes, out)
    ccall((:h3SetToLinkedGeo, libh3), Cvoid, (Ptr{H3Index}, Cint, Ptr{LinkedGeoPolygon}), h3Set, numHexes, out)
end

function destroyLinkedPolygon(polygon)
    ccall((:destroyLinkedPolygon, libh3), Cvoid, (Ptr{LinkedGeoPolygon},), polygon)
end

function degsToRads(degrees)
    ccall((:degsToRads, libh3), Cdouble, (Cdouble,), degrees)
end

function radsToDegs(radians)
    ccall((:radsToDegs, libh3), Cdouble, (Cdouble,), radians)
end

function pointDistRads(a, b)
    ccall((:pointDistRads, libh3), Cdouble, (Ptr{GeoCoord}, Ptr{GeoCoord}), a, b)
end

function pointDistKm(a, b)
    ccall((:pointDistKm, libh3), Cdouble, (Ptr{GeoCoord}, Ptr{GeoCoord}), a, b)
end

function pointDistM(a, b)
    ccall((:pointDistM, libh3), Cdouble, (Ptr{GeoCoord}, Ptr{GeoCoord}), a, b)
end

function hexAreaKm2(res)
    ccall((:hexAreaKm2, libh3), Cdouble, (Cint,), res)
end

function hexAreaM2(res)
    ccall((:hexAreaM2, libh3), Cdouble, (Cint,), res)
end

function cellAreaRads2(h)
    ccall((:cellAreaRads2, libh3), Cdouble, (H3Index,), h)
end

function cellAreaKm2(h)
    ccall((:cellAreaKm2, libh3), Cdouble, (H3Index,), h)
end

function cellAreaM2(h)
    ccall((:cellAreaM2, libh3), Cdouble, (H3Index,), h)
end

function edgeLengthKm(res)
    ccall((:edgeLengthKm, libh3), Cdouble, (Cint,), res)
end

function edgeLengthM(res)
    ccall((:edgeLengthM, libh3), Cdouble, (Cint,), res)
end

function exactEdgeLengthRads(edge)
    ccall((:exactEdgeLengthRads, libh3), Cdouble, (H3Index,), edge)
end

function exactEdgeLengthKm(edge)
    ccall((:exactEdgeLengthKm, libh3), Cdouble, (H3Index,), edge)
end

function exactEdgeLengthM(edge)
    ccall((:exactEdgeLengthM, libh3), Cdouble, (H3Index,), edge)
end

function numHexagons(res)
    ccall((:numHexagons, libh3), Int64, (Cint,), res)
end

# no prototype is found for this function at h3api.h:333:5, please use with caution
function res0IndexCount()
    ccall((:res0IndexCount, libh3), Cint, ())
end

function getRes0Indexes(out)
    ccall((:getRes0Indexes, libh3), Cvoid, (Ptr{H3Index},), out)
end

# no prototype is found for this function at h3api.h:344:5, please use with caution
function pentagonIndexCount()
    ccall((:pentagonIndexCount, libh3), Cint, ())
end

function getPentagonIndexes(res, out)
    ccall((:getPentagonIndexes, libh3), Cvoid, (Cint, Ptr{H3Index}), res, out)
end

function h3GetResolution(h)
    ccall((:h3GetResolution, libh3), Cint, (H3Index,), h)
end

function h3GetBaseCell(h)
    ccall((:h3GetBaseCell, libh3), Cint, (H3Index,), h)
end

function stringToH3(str)
    ccall((:stringToH3, libh3), H3Index, (Ptr{Cchar},), str)
end

function h3ToString(h, str, sz)
    ccall((:h3ToString, libh3), Cvoid, (H3Index, Ptr{Cchar}, Csize_t), h, str, sz)
end

function h3IsValid(h)
    ccall((:h3IsValid, libh3), Cint, (H3Index,), h)
end

function h3ToParent(h, parentRes)
    ccall((:h3ToParent, libh3), H3Index, (H3Index, Cint), h, parentRes)
end

function maxH3ToChildrenSize(h, childRes)
    ccall((:maxH3ToChildrenSize, libh3), Cint, (H3Index, Cint), h, childRes)
end

function h3ToChildren(h, childRes, children)
    ccall((:h3ToChildren, libh3), Cvoid, (H3Index, Cint, Ptr{H3Index}), h, childRes, children)
end

function h3ToCenterChild(h, childRes)
    ccall((:h3ToCenterChild, libh3), H3Index, (H3Index, Cint), h, childRes)
end

function compact(h3Set, compactedSet, numHexes)
    ccall((:compact, libh3), Cint, (Ptr{H3Index}, Ptr{H3Index}, Cint), h3Set, compactedSet, numHexes)
end

function maxUncompactSize(compactedSet, numHexes, res)
    ccall((:maxUncompactSize, libh3), Cint, (Ptr{H3Index}, Cint, Cint), compactedSet, numHexes, res)
end

function uncompact(compactedSet, numHexes, h3Set, maxHexes, res)
    ccall((:uncompact, libh3), Cint, (Ptr{H3Index}, Cint, Ptr{H3Index}, Cint, Cint), compactedSet, numHexes, h3Set, maxHexes, res)
end

function h3IsResClassIII(h)
    ccall((:h3IsResClassIII, libh3), Cint, (H3Index,), h)
end

function h3IsPentagon(h)
    ccall((:h3IsPentagon, libh3), Cint, (H3Index,), h)
end

function maxFaceCount(h3)
    ccall((:maxFaceCount, libh3), Cint, (H3Index,), h3)
end

function h3GetFaces(h3, out)
    ccall((:h3GetFaces, libh3), Cvoid, (H3Index, Ptr{Cint}), h3, out)
end

function h3IndexesAreNeighbors(origin, destination)
    ccall((:h3IndexesAreNeighbors, libh3), Cint, (H3Index, H3Index), origin, destination)
end

function getH3UnidirectionalEdge(origin, destination)
    ccall((:getH3UnidirectionalEdge, libh3), H3Index, (H3Index, H3Index), origin, destination)
end

function h3UnidirectionalEdgeIsValid(edge)
    ccall((:h3UnidirectionalEdgeIsValid, libh3), Cint, (H3Index,), edge)
end

function getOriginH3IndexFromUnidirectionalEdge(edge)
    ccall((:getOriginH3IndexFromUnidirectionalEdge, libh3), H3Index, (H3Index,), edge)
end

function getDestinationH3IndexFromUnidirectionalEdge(edge)
    ccall((:getDestinationH3IndexFromUnidirectionalEdge, libh3), H3Index, (H3Index,), edge)
end

function getH3IndexesFromUnidirectionalEdge(edge, originDestination)
    ccall((:getH3IndexesFromUnidirectionalEdge, libh3), Cvoid, (H3Index, Ptr{H3Index}), edge, originDestination)
end

function getH3UnidirectionalEdgesFromHexagon(origin, edges)
    ccall((:getH3UnidirectionalEdgesFromHexagon, libh3), Cvoid, (H3Index, Ptr{H3Index}), origin, edges)
end

function getH3UnidirectionalEdgeBoundary(edge, gb)
    ccall((:getH3UnidirectionalEdgeBoundary, libh3), Cvoid, (H3Index, Ptr{GeoBoundary}), edge, gb)
end

function h3Distance(origin, h3)
    ccall((:h3Distance, libh3), Cint, (H3Index, H3Index), origin, h3)
end

function h3LineSize(start, _end)
    ccall((:h3LineSize, libh3), Cint, (H3Index, H3Index), start, _end)
end

function h3Line(start, _end, out)
    ccall((:h3Line, libh3), Cint, (H3Index, H3Index, Ptr{H3Index}), start, _end, out)
end

function experimentalH3ToLocalIj(origin, h3, out)
    ccall((:experimentalH3ToLocalIj, libh3), Cint, (H3Index, H3Index, Ptr{CoordIJ}), origin, h3, out)
end

function experimentalLocalIjToH3(origin, ij, out)
    ccall((:experimentalLocalIjToH3, libh3), Cint, (H3Index, Ptr{CoordIJ}, Ptr{H3Index}), origin, ij, out)
end

@cenum Direction::UInt32 begin
    CENTER_DIGIT = 0
    K_AXES_DIGIT = 1
    J_AXES_DIGIT = 2
    JK_AXES_DIGIT = 3
    I_AXES_DIGIT = 4
    IK_AXES_DIGIT = 5
    IJ_AXES_DIGIT = 6
    INVALID_DIGIT = 7
    NUM_DIGITS = 7
end

function h3NeighborRotations(origin, dir, rotations)
    ccall((:h3NeighborRotations, libh3), H3Index, (H3Index, Direction, Ptr{Cint}), origin, dir, rotations)
end

function _kRingInternal(origin, k, out, distances, maxIdx, curK)
    ccall((:_kRingInternal, libh3), Cvoid, (H3Index, Cint, Ptr{H3Index}, Ptr{Cint}, Cint, Cint), origin, k, out, distances, maxIdx, curK)
end

struct VertexGraph
    buckets::Ptr{Ptr{Cvoid}} # buckets::Ptr{Ptr{VertexNode}}
    numBuckets::Cint
    size::Cint
    res::Cint
end

function Base.getproperty(x::VertexGraph, f::Symbol)
    f === :buckets && return Ptr{Ptr{VertexNode}}(getfield(x, f))
    return getfield(x, f)
end

function h3SetToVertexGraph(h3Set, numHexes, out)
    ccall((:h3SetToVertexGraph, libh3), Cvoid, (Ptr{H3Index}, Cint, Ptr{VertexGraph}), h3Set, numHexes, out)
end

function _vertexGraphToLinkedGeo(graph, out)
    ccall((:_vertexGraphToLinkedGeo, libh3), Cvoid, (Ptr{VertexGraph}, Ptr{LinkedGeoPolygon}), graph, out)
end

function _getEdgeHexagons(geofence, numHexagons_, res, numSearchHexes, search, found)
    ccall((:_getEdgeHexagons, libh3), Cint, (Ptr{Geofence}, Cint, Cint, Ptr{Cint}, Ptr{H3Index}, Ptr{H3Index}), geofence, numHexagons_, res, numSearchHexes, search, found)
end

function _polyfillInternal(geoPolygon, res, out)
    ccall((:_polyfillInternal, libh3), Cint, (Ptr{GeoPolygon}, Cint, Ptr{H3Index}), geoPolygon, res, out)
end

struct CoordIJK
    i::Cint
    j::Cint
    k::Cint
end

struct FaceIJK
    face::Cint
    coord::CoordIJK
end

struct BaseCellData
    homeFijk::FaceIJK
    isPentagon::Cint
    cwOffsetPent::NTuple{2, Cint}
end

function _isBaseCellPentagon(baseCell)
    ccall((:_isBaseCellPentagon, libh3), Cint, (Cint,), baseCell)
end

function _isBaseCellPolarPentagon(baseCell)
    ccall((:_isBaseCellPolarPentagon, libh3), Bool, (Cint,), baseCell)
end

function _faceIjkToBaseCell(h)
    ccall((:_faceIjkToBaseCell, libh3), Cint, (Ptr{FaceIJK},), h)
end

function _faceIjkToBaseCellCCWrot60(h)
    ccall((:_faceIjkToBaseCellCCWrot60, libh3), Cint, (Ptr{FaceIJK},), h)
end

function _baseCellToCCWrot60(baseCell, face)
    ccall((:_baseCellToCCWrot60, libh3), Cint, (Cint, Cint), baseCell, face)
end

function _baseCellToFaceIjk(baseCell, h)
    ccall((:_baseCellToFaceIjk, libh3), Cvoid, (Cint, Ptr{FaceIJK}), baseCell, h)
end

function _baseCellIsCwOffset(baseCell, testFace)
    ccall((:_baseCellIsCwOffset, libh3), Bool, (Cint, Cint), baseCell, testFace)
end

function _getBaseCellNeighbor(baseCell, dir)
    ccall((:_getBaseCellNeighbor, libh3), Cint, (Cint, Direction), baseCell, dir)
end

function _getBaseCellDirection(originBaseCell, destinationBaseCell)
    ccall((:_getBaseCellDirection, libh3), Direction, (Cint, Cint), originBaseCell, destinationBaseCell)
end

struct BBox
    north::Cdouble
    south::Cdouble
    east::Cdouble
    west::Cdouble
end

function bboxIsTransmeridian(bbox)
    ccall((:bboxIsTransmeridian, libh3), Bool, (Ptr{BBox},), bbox)
end

function bboxCenter(bbox, center)
    ccall((:bboxCenter, libh3), Cvoid, (Ptr{BBox}, Ptr{GeoCoord}), bbox, center)
end

function bboxContains(bbox, point)
    ccall((:bboxContains, libh3), Bool, (Ptr{BBox}, Ptr{GeoCoord}), bbox, point)
end

function bboxEquals(b1, b2)
    ccall((:bboxEquals, libh3), Bool, (Ptr{BBox}, Ptr{BBox}), b1, b2)
end

function bboxHexEstimate(bbox, res)
    ccall((:bboxHexEstimate, libh3), Cint, (Ptr{BBox}, Cint), bbox, res)
end

function lineHexEstimate(origin, destination, res)
    ccall((:lineHexEstimate, libh3), Cint, (Ptr{GeoCoord}, Ptr{GeoCoord}, Cint), origin, destination, res)
end

function _setIJK(ijk, i, j, k)
    ccall((:_setIJK, libh3), Cvoid, (Ptr{CoordIJK}, Cint, Cint, Cint), ijk, i, j, k)
end

struct Vec2d
    x::Cdouble
    y::Cdouble
end

function _hex2dToCoordIJK(v, h)
    ccall((:_hex2dToCoordIJK, libh3), Cvoid, (Ptr{Vec2d}, Ptr{CoordIJK}), v, h)
end

function _ijkToHex2d(h, v)
    ccall((:_ijkToHex2d, libh3), Cvoid, (Ptr{CoordIJK}, Ptr{Vec2d}), h, v)
end

function _ijkMatches(c1, c2)
    ccall((:_ijkMatches, libh3), Cint, (Ptr{CoordIJK}, Ptr{CoordIJK}), c1, c2)
end

function _ijkAdd(h1, h2, sum)
    ccall((:_ijkAdd, libh3), Cvoid, (Ptr{CoordIJK}, Ptr{CoordIJK}, Ptr{CoordIJK}), h1, h2, sum)
end

function _ijkSub(h1, h2, diff)
    ccall((:_ijkSub, libh3), Cvoid, (Ptr{CoordIJK}, Ptr{CoordIJK}, Ptr{CoordIJK}), h1, h2, diff)
end

function _ijkScale(c, factor)
    ccall((:_ijkScale, libh3), Cvoid, (Ptr{CoordIJK}, Cint), c, factor)
end

function _ijkNormalize(c)
    ccall((:_ijkNormalize, libh3), Cvoid, (Ptr{CoordIJK},), c)
end

function _unitIjkToDigit(ijk)
    ccall((:_unitIjkToDigit, libh3), Direction, (Ptr{CoordIJK},), ijk)
end

function _upAp7(ijk)
    ccall((:_upAp7, libh3), Cvoid, (Ptr{CoordIJK},), ijk)
end

function _upAp7r(ijk)
    ccall((:_upAp7r, libh3), Cvoid, (Ptr{CoordIJK},), ijk)
end

function _downAp7(ijk)
    ccall((:_downAp7, libh3), Cvoid, (Ptr{CoordIJK},), ijk)
end

function _downAp7r(ijk)
    ccall((:_downAp7r, libh3), Cvoid, (Ptr{CoordIJK},), ijk)
end

function _downAp3(ijk)
    ccall((:_downAp3, libh3), Cvoid, (Ptr{CoordIJK},), ijk)
end

function _downAp3r(ijk)
    ccall((:_downAp3r, libh3), Cvoid, (Ptr{CoordIJK},), ijk)
end

function _neighbor(ijk, digit)
    ccall((:_neighbor, libh3), Cvoid, (Ptr{CoordIJK}, Direction), ijk, digit)
end

function _ijkRotate60ccw(ijk)
    ccall((:_ijkRotate60ccw, libh3), Cvoid, (Ptr{CoordIJK},), ijk)
end

function _ijkRotate60cw(ijk)
    ccall((:_ijkRotate60cw, libh3), Cvoid, (Ptr{CoordIJK},), ijk)
end

function _rotate60ccw(digit)
    ccall((:_rotate60ccw, libh3), Direction, (Direction,), digit)
end

function _rotate60cw(digit)
    ccall((:_rotate60cw, libh3), Direction, (Direction,), digit)
end

function ijkDistance(a, b)
    ccall((:ijkDistance, libh3), Cint, (Ptr{CoordIJK}, Ptr{CoordIJK}), a, b)
end

function ijkToIj(ijk, ij)
    ccall((:ijkToIj, libh3), Cvoid, (Ptr{CoordIJK}, Ptr{CoordIJ}), ijk, ij)
end

function ijToIjk(ij, ijk)
    ccall((:ijToIjk, libh3), Cvoid, (Ptr{CoordIJ}, Ptr{CoordIJK}), ij, ijk)
end

function ijkToCube(ijk)
    ccall((:ijkToCube, libh3), Cvoid, (Ptr{CoordIJK},), ijk)
end

function cubeToIjk(ijk)
    ccall((:cubeToIjk, libh3), Cvoid, (Ptr{CoordIJK},), ijk)
end

struct FaceOrientIJK
    face::Cint
    translate::CoordIJK
    ccwRot60::Cint
end

@cenum Overage::UInt32 begin
    NO_OVERAGE = 0
    FACE_EDGE = 1
    NEW_FACE = 2
end

function _geoToFaceIjk(g, res, h)
    ccall((:_geoToFaceIjk, libh3), Cvoid, (Ptr{GeoCoord}, Cint, Ptr{FaceIJK}), g, res, h)
end

function _geoToHex2d(g, res, face, v)
    ccall((:_geoToHex2d, libh3), Cvoid, (Ptr{GeoCoord}, Cint, Ptr{Cint}, Ptr{Vec2d}), g, res, face, v)
end

function _faceIjkToGeo(h, res, g)
    ccall((:_faceIjkToGeo, libh3), Cvoid, (Ptr{FaceIJK}, Cint, Ptr{GeoCoord}), h, res, g)
end

function _faceIjkToGeoBoundary(h, res, start, length, g)
    ccall((:_faceIjkToGeoBoundary, libh3), Cvoid, (Ptr{FaceIJK}, Cint, Cint, Cint, Ptr{GeoBoundary}), h, res, start, length, g)
end

function _faceIjkPentToGeoBoundary(h, res, start, length, g)
    ccall((:_faceIjkPentToGeoBoundary, libh3), Cvoid, (Ptr{FaceIJK}, Cint, Cint, Cint, Ptr{GeoBoundary}), h, res, start, length, g)
end

function _faceIjkToVerts(fijk, res, fijkVerts)
    ccall((:_faceIjkToVerts, libh3), Cvoid, (Ptr{FaceIJK}, Ptr{Cint}, Ptr{FaceIJK}), fijk, res, fijkVerts)
end

function _faceIjkPentToVerts(fijk, res, fijkVerts)
    ccall((:_faceIjkPentToVerts, libh3), Cvoid, (Ptr{FaceIJK}, Ptr{Cint}, Ptr{FaceIJK}), fijk, res, fijkVerts)
end

function _hex2dToGeo(v, face, res, substrate, g)
    ccall((:_hex2dToGeo, libh3), Cvoid, (Ptr{Vec2d}, Cint, Cint, Cint, Ptr{GeoCoord}), v, face, res, substrate, g)
end

function _adjustOverageClassII(fijk, res, pentLeading4, substrate)
    ccall((:_adjustOverageClassII, libh3), Overage, (Ptr{FaceIJK}, Cint, Cint, Cint), fijk, res, pentLeading4, substrate)
end

function _adjustPentVertOverage(fijk, res)
    ccall((:_adjustPentVertOverage, libh3), Overage, (Ptr{FaceIJK}, Cint), fijk, res)
end

function setGeoDegs(p, latDegs, lonDegs)
    ccall((:setGeoDegs, libh3), Cvoid, (Ptr{GeoCoord}, Cdouble, Cdouble), p, latDegs, lonDegs)
end

function constrainLat(lat)
    ccall((:constrainLat, libh3), Cdouble, (Cdouble,), lat)
end

function constrainLng(lng)
    ccall((:constrainLng, libh3), Cdouble, (Cdouble,), lng)
end

function geoAlmostEqual(p1, p2)
    ccall((:geoAlmostEqual, libh3), Bool, (Ptr{GeoCoord}, Ptr{GeoCoord}), p1, p2)
end

function geoAlmostEqualThreshold(p1, p2, threshold)
    ccall((:geoAlmostEqualThreshold, libh3), Bool, (Ptr{GeoCoord}, Ptr{GeoCoord}, Cdouble), p1, p2, threshold)
end

function _posAngleRads(rads)
    ccall((:_posAngleRads, libh3), Cdouble, (Cdouble,), rads)
end

function _setGeoRads(p, latRads, lonRads)
    ccall((:_setGeoRads, libh3), Cvoid, (Ptr{GeoCoord}, Cdouble, Cdouble), p, latRads, lonRads)
end

function _geoAzimuthRads(p1, p2)
    ccall((:_geoAzimuthRads, libh3), Cdouble, (Ptr{GeoCoord}, Ptr{GeoCoord}), p1, p2)
end

function _geoAzDistanceRads(p1, az, distance, p2)
    ccall((:_geoAzDistanceRads, libh3), Cvoid, (Ptr{GeoCoord}, Cdouble, Cdouble, Ptr{GeoCoord}), p1, az, distance, p2)
end

function setH3Index(h, res, baseCell, initDigit)
    ccall((:setH3Index, libh3), Cvoid, (Ptr{H3Index}, Cint, Cint, Direction), h, res, baseCell, initDigit)
end

function isResClassIII(res)
    ccall((:isResClassIII, libh3), Cint, (Cint,), res)
end

function _h3ToFaceIjkWithInitializedFijk(h, fijk)
    ccall((:_h3ToFaceIjkWithInitializedFijk, libh3), Cint, (H3Index, Ptr{FaceIJK}), h, fijk)
end

function _h3ToFaceIjk(h, fijk)
    ccall((:_h3ToFaceIjk, libh3), Cvoid, (H3Index, Ptr{FaceIJK}), h, fijk)
end

function _faceIjkToH3(fijk, res)
    ccall((:_faceIjkToH3, libh3), H3Index, (Ptr{FaceIJK}, Cint), fijk, res)
end

function _h3LeadingNonZeroDigit(h)
    ccall((:_h3LeadingNonZeroDigit, libh3), Direction, (H3Index,), h)
end

function _h3RotatePent60ccw(h)
    ccall((:_h3RotatePent60ccw, libh3), H3Index, (H3Index,), h)
end

function _h3RotatePent60cw(h)
    ccall((:_h3RotatePent60cw, libh3), H3Index, (H3Index,), h)
end

function _h3Rotate60ccw(h)
    ccall((:_h3Rotate60ccw, libh3), H3Index, (H3Index,), h)
end

function _h3Rotate60cw(h)
    ccall((:_h3Rotate60cw, libh3), H3Index, (H3Index,), h)
end

function normalizeMultiPolygon(root)
    ccall((:normalizeMultiPolygon, libh3), Cint, (Ptr{LinkedGeoPolygon},), root)
end

function addNewLinkedPolygon(polygon)
    ccall((:addNewLinkedPolygon, libh3), Ptr{LinkedGeoPolygon}, (Ptr{LinkedGeoPolygon},), polygon)
end

function addNewLinkedLoop(polygon)
    ccall((:addNewLinkedLoop, libh3), Ptr{LinkedGeoLoop}, (Ptr{LinkedGeoPolygon},), polygon)
end

function addLinkedLoop(polygon, loop)
    ccall((:addLinkedLoop, libh3), Ptr{LinkedGeoLoop}, (Ptr{LinkedGeoPolygon}, Ptr{LinkedGeoLoop}), polygon, loop)
end

function addLinkedCoord(loop, vertex)
    ccall((:addLinkedCoord, libh3), Ptr{LinkedGeoCoord}, (Ptr{LinkedGeoLoop}, Ptr{GeoCoord}), loop, vertex)
end

function countLinkedPolygons(polygon)
    ccall((:countLinkedPolygons, libh3), Cint, (Ptr{LinkedGeoPolygon},), polygon)
end

function countLinkedLoops(polygon)
    ccall((:countLinkedLoops, libh3), Cint, (Ptr{LinkedGeoPolygon},), polygon)
end

function countLinkedCoords(loop)
    ccall((:countLinkedCoords, libh3), Cint, (Ptr{LinkedGeoLoop},), loop)
end

function destroyLinkedGeoLoop(loop)
    ccall((:destroyLinkedGeoLoop, libh3), Cvoid, (Ptr{LinkedGeoLoop},), loop)
end

function bboxFromLinkedGeoLoop(loop, bbox)
    ccall((:bboxFromLinkedGeoLoop, libh3), Cvoid, (Ptr{LinkedGeoLoop}, Ptr{BBox}), loop, bbox)
end

function pointInsideLinkedGeoLoop(loop, bbox, coord)
    ccall((:pointInsideLinkedGeoLoop, libh3), Bool, (Ptr{LinkedGeoLoop}, Ptr{BBox}, Ptr{GeoCoord}), loop, bbox, coord)
end

function isClockwiseLinkedGeoLoop(loop)
    ccall((:isClockwiseLinkedGeoLoop, libh3), Bool, (Ptr{LinkedGeoLoop},), loop)
end

function h3ToLocalIjk(origin, h3, out)
    ccall((:h3ToLocalIjk, libh3), Cint, (H3Index, H3Index, Ptr{CoordIJK}), origin, h3, out)
end

function localIjkToH3(origin, ijk, out)
    ccall((:localIjkToH3, libh3), Cint, (H3Index, Ptr{CoordIJK}, Ptr{H3Index}), origin, ijk, out)
end

function _ipow(base, exp)
    ccall((:_ipow, libh3), Cint, (Cint, Cint), base, exp)
end

function bboxesFromGeoPolygon(polygon, bboxes)
    ccall((:bboxesFromGeoPolygon, libh3), Cvoid, (Ptr{GeoPolygon}, Ptr{BBox}), polygon, bboxes)
end

function pointInsidePolygon(geoPolygon, bboxes, coord)
    ccall((:pointInsidePolygon, libh3), Bool, (Ptr{GeoPolygon}, Ptr{BBox}, Ptr{GeoCoord}), geoPolygon, bboxes, coord)
end

function bboxFromGeofence(loop, bbox)
    ccall((:bboxFromGeofence, libh3), Cvoid, (Ptr{Geofence}, Ptr{BBox}), loop, bbox)
end

function pointInsideGeofence(loop, bbox, coord)
    ccall((:pointInsideGeofence, libh3), Bool, (Ptr{Geofence}, Ptr{BBox}, Ptr{GeoCoord}), loop, bbox, coord)
end

function isClockwiseGeofence(geofence)
    ccall((:isClockwiseGeofence, libh3), Bool, (Ptr{Geofence},), geofence)
end

function _v2dMag(v)
    ccall((:_v2dMag, libh3), Cdouble, (Ptr{Vec2d},), v)
end

function _v2dIntersect(p0, p1, p2, p3, inter)
    ccall((:_v2dIntersect, libh3), Cvoid, (Ptr{Vec2d}, Ptr{Vec2d}, Ptr{Vec2d}, Ptr{Vec2d}, Ptr{Vec2d}), p0, p1, p2, p3, inter)
end

function _v2dEquals(p0, p1)
    ccall((:_v2dEquals, libh3), Bool, (Ptr{Vec2d}, Ptr{Vec2d}), p0, p1)
end

struct Vec3d
    x::Cdouble
    y::Cdouble
    z::Cdouble
end

function _geoToVec3d(geo, point)
    ccall((:_geoToVec3d, libh3), Cvoid, (Ptr{GeoCoord}, Ptr{Vec3d}), geo, point)
end

function _pointSquareDist(p1, p2)
    ccall((:_pointSquareDist, libh3), Cdouble, (Ptr{Vec3d}, Ptr{Vec3d}), p1, p2)
end

struct PentagonDirectionFaces
    baseCell::Cint
    faces::NTuple{5, Cint}
end

function vertexRotations(cell)
    ccall((:vertexRotations, libh3), Cint, (H3Index,), cell)
end

function vertexNumForDirection(origin, direction)
    ccall((:vertexNumForDirection, libh3), Cint, (H3Index, Direction), origin, direction)
end

struct VertexNode
    from::GeoCoord
    to::GeoCoord
    next::Ptr{VertexNode}
end

function initVertexGraph(graph, numBuckets, res)
    ccall((:initVertexGraph, libh3), Cvoid, (Ptr{VertexGraph}, Cint, Cint), graph, numBuckets, res)
end

function destroyVertexGraph(graph)
    ccall((:destroyVertexGraph, libh3), Cvoid, (Ptr{VertexGraph},), graph)
end

function addVertexNode(graph, fromVtx, toVtx)
    ccall((:addVertexNode, libh3), Ptr{VertexNode}, (Ptr{VertexGraph}, Ptr{GeoCoord}, Ptr{GeoCoord}), graph, fromVtx, toVtx)
end

function removeVertexNode(graph, node)
    ccall((:removeVertexNode, libh3), Cint, (Ptr{VertexGraph}, Ptr{VertexNode}), graph, node)
end

function findNodeForEdge(graph, fromVtx, toVtx)
    ccall((:findNodeForEdge, libh3), Ptr{VertexNode}, (Ptr{VertexGraph}, Ptr{GeoCoord}, Ptr{GeoCoord}), graph, fromVtx, toVtx)
end

function findNodeForVertex(graph, fromVtx)
    ccall((:findNodeForVertex, libh3), Ptr{VertexNode}, (Ptr{VertexGraph}, Ptr{GeoCoord}), graph, fromVtx)
end

function firstVertexNode(graph)
    ccall((:firstVertexNode, libh3), Ptr{VertexNode}, (Ptr{VertexGraph},), graph)
end

function _hashVertex(vertex, res, numBuckets)
    ccall((:_hashVertex, libh3), UInt32, (Ptr{GeoCoord}, Cint, Cint), vertex, res, numBuckets)
end

function _initVertexNode(node, fromVtx, toVtx)
    ccall((:_initVertexNode, libh3), Cvoid, (Ptr{VertexNode}, Ptr{GeoCoord}, Ptr{GeoCoord}), node, fromVtx, toVtx)
end

const H3_VERSION_MAJOR = 3

const H3_VERSION_MINOR = 7

const H3_VERSION_PATCH = 2

const MAX_CELL_BNDRY_VERTS = 10

const M_PI = 3.141592653589793

const M_PI_2 = 1.5707963267948966

const MAX_H3_RES = 15

const NUM_ICOSA_FACES = 20

const NUM_BASE_CELLS = 122

const NUM_HEX_VERTS = 6

const NUM_PENT_VERTS = 5

const NUM_PENTAGONS = 12

const H3_HEXAGON_MODE = 1

const H3_UNIEDGE_MODE = 2

const INVALID_BASE_CELL = 127

const MAX_FACE_COORD = 2

const INVALID_ROTATIONS = -1

const IJ = 1

const KI = 2

const JK = 3

const INVALID_FACE = -1

const EPSILON_DEG = 1.0e-9

const H3_NUM_BITS = 64

const H3_MAX_OFFSET = 63

const H3_MODE_OFFSET = 59

const H3_BC_OFFSET = 45

const H3_RES_OFFSET = 52

const H3_RESERVED_OFFSET = 56

const H3_PER_DIGIT_OFFSET = 3

const H3_HIGH_BIT_MASK = uint64_t(1) << H3_MAX_OFFSET

const H3_HIGH_BIT_MASK_NEGATIVE = ~H3_HIGH_BIT_MASK

const H3_MODE_MASK = uint64_t(15) << H3_MODE_OFFSET

const H3_MODE_MASK_NEGATIVE = ~H3_MODE_MASK

const H3_BC_MASK = uint64_t(127) << H3_BC_OFFSET

const H3_BC_MASK_NEGATIVE = ~H3_BC_MASK

const H3_RES_MASK = UINT64_C(15) << H3_RES_OFFSET

const H3_RES_MASK_NEGATIVE = ~H3_RES_MASK

const H3_RESERVED_MASK = uint64_t(7) << H3_RESERVED_OFFSET

const H3_RESERVED_MASK_NEGATIVE = ~H3_RESERVED_MASK

const H3_DIGIT_MASK = uint64_t(7)

const H3_DIGIT_MASK_NEGATIVE = ~H3_DIGIT_MASK

const H3_INIT = UINT64_C(35184372088831)

const H3_NULL = 0

const COMPACT_SUCCESS = 0

const COMPACT_LOOP_EXCEEDED = -1

const COMPACT_DUPLICATE = -2

const COMPACT_ALLOC_FAILED = -3

const NORMALIZATION_SUCCESS = 0

const NORMALIZATION_ERR_MULTIPLE_POLYGONS = 1

const NORMALIZATION_ERR_UNASSIGNED_HOLES = 2

const INVALID_VERTEX_NUM = -1

const MAX_BASE_CELL_FACES = 5

end # module
