module Lib

using H3_jll
export H3_jll

using CEnum

const uint64_t = UInt64
const UINT64_C = UInt64


const H3Index = UInt64

const H3Error = UInt32

@cenum H3ErrorCodes::UInt32 begin
    E_SUCCESS = 0
    E_FAILED = 1
    E_DOMAIN = 2
    E_LATLNG_DOMAIN = 3
    E_RES_DOMAIN = 4
    E_CELL_INVALID = 5
    E_DIR_EDGE_INVALID = 6
    E_UNDIR_EDGE_INVALID = 7
    E_VERTEX_INVALID = 8
    E_PENTAGON = 9
    E_DUPLICATE_INPUT = 10
    E_NOT_NEIGHBORS = 11
    E_RES_MISMATCH = 12
    E_MEMORY_ALLOC = 13
    E_MEMORY_BOUNDS = 14
    E_OPTION_INVALID = 15
end

struct LatLng
    lat::Cdouble
    lng::Cdouble
end

struct CellBoundary
    numVerts::Cint
    verts::NTuple{10, LatLng}
end

struct GeoLoop
    numVerts::Cint
    verts::Ptr{LatLng}
end

struct GeoPolygon
    geoloop::GeoLoop
    numHoles::Cint
    holes::Ptr{GeoLoop}
end

struct GeoMultiPolygon
    numPolygons::Cint
    polygons::Ptr{GeoPolygon}
end

struct LinkedLatLng
    vertex::LatLng
    next::Ptr{LinkedLatLng}
end

struct LinkedGeoLoop
    first::Ptr{LinkedLatLng}
    last::Ptr{LinkedLatLng}
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

function latLngToCell(g, res, out)
    ccall((:latLngToCell, libh3), H3Error, (Ptr{LatLng}, Cint, Ptr{H3Index}), g, res, out)
end

function cellToLatLng(h3, g)
    ccall((:cellToLatLng, libh3), H3Error, (H3Index, Ptr{LatLng}), h3, g)
end

function cellToBoundary(h3, gp)
    ccall((:cellToBoundary, libh3), H3Error, (H3Index, Ptr{CellBoundary}), h3, gp)
end

function maxGridDiskSize(k, out)
    ccall((:maxGridDiskSize, libh3), H3Error, (Cint, Ptr{Int64}), k, out)
end

function gridDiskUnsafe(origin, k, out)
    ccall((:gridDiskUnsafe, libh3), H3Error, (H3Index, Cint, Ptr{H3Index}), origin, k, out)
end

function gridDiskDistancesUnsafe(origin, k, out, distances)
    ccall((:gridDiskDistancesUnsafe, libh3), H3Error, (H3Index, Cint, Ptr{H3Index}, Ptr{Cint}), origin, k, out, distances)
end

function gridDiskDistancesSafe(origin, k, out, distances)
    ccall((:gridDiskDistancesSafe, libh3), H3Error, (H3Index, Cint, Ptr{H3Index}, Ptr{Cint}), origin, k, out, distances)
end

function gridDisksUnsafe(h3Set, length, k, out)
    ccall((:gridDisksUnsafe, libh3), H3Error, (Ptr{H3Index}, Cint, Cint, Ptr{H3Index}), h3Set, length, k, out)
end

function gridDisk(origin, k, out)
    ccall((:gridDisk, libh3), H3Error, (H3Index, Cint, Ptr{H3Index}), origin, k, out)
end

function gridDiskDistances(origin, k, out, distances)
    ccall((:gridDiskDistances, libh3), H3Error, (H3Index, Cint, Ptr{H3Index}, Ptr{Cint}), origin, k, out, distances)
end

function gridRingUnsafe(origin, k, out)
    ccall((:gridRingUnsafe, libh3), H3Error, (H3Index, Cint, Ptr{H3Index}), origin, k, out)
end

function maxPolygonToCellsSize(geoPolygon, res, flags, out)
    ccall((:maxPolygonToCellsSize, libh3), H3Error, (Ptr{GeoPolygon}, Cint, UInt32, Ptr{Int64}), geoPolygon, res, flags, out)
end

function polygonToCells(geoPolygon, res, flags, out)
    ccall((:polygonToCells, libh3), H3Error, (Ptr{GeoPolygon}, Cint, UInt32, Ptr{H3Index}), geoPolygon, res, flags, out)
end

function cellsToLinkedMultiPolygon(h3Set, numHexes, out)
    ccall((:cellsToLinkedMultiPolygon, libh3), H3Error, (Ptr{H3Index}, Cint, Ptr{LinkedGeoPolygon}), h3Set, numHexes, out)
end

function destroyLinkedMultiPolygon(polygon)
    ccall((:destroyLinkedMultiPolygon, libh3), Cvoid, (Ptr{LinkedGeoPolygon},), polygon)
end

function degsToRads(degrees)
    ccall((:degsToRads, libh3), Cdouble, (Cdouble,), degrees)
end

function radsToDegs(radians)
    ccall((:radsToDegs, libh3), Cdouble, (Cdouble,), radians)
end

function greatCircleDistanceRads(a, b)
    ccall((:greatCircleDistanceRads, libh3), Cdouble, (Ptr{LatLng}, Ptr{LatLng}), a, b)
end

function greatCircleDistanceKm(a, b)
    ccall((:greatCircleDistanceKm, libh3), Cdouble, (Ptr{LatLng}, Ptr{LatLng}), a, b)
end

function greatCircleDistanceM(a, b)
    ccall((:greatCircleDistanceM, libh3), Cdouble, (Ptr{LatLng}, Ptr{LatLng}), a, b)
end

function getHexagonAreaAvgKm2(res, out)
    ccall((:getHexagonAreaAvgKm2, libh3), H3Error, (Cint, Ptr{Cdouble}), res, out)
end

function getHexagonAreaAvgM2(res, out)
    ccall((:getHexagonAreaAvgM2, libh3), H3Error, (Cint, Ptr{Cdouble}), res, out)
end

function cellAreaRads2(h, out)
    ccall((:cellAreaRads2, libh3), H3Error, (H3Index, Ptr{Cdouble}), h, out)
end

function cellAreaKm2(h, out)
    ccall((:cellAreaKm2, libh3), H3Error, (H3Index, Ptr{Cdouble}), h, out)
end

function cellAreaM2(h, out)
    ccall((:cellAreaM2, libh3), H3Error, (H3Index, Ptr{Cdouble}), h, out)
end

function getHexagonEdgeLengthAvgKm(res, out)
    ccall((:getHexagonEdgeLengthAvgKm, libh3), H3Error, (Cint, Ptr{Cdouble}), res, out)
end

function getHexagonEdgeLengthAvgM(res, out)
    ccall((:getHexagonEdgeLengthAvgM, libh3), H3Error, (Cint, Ptr{Cdouble}), res, out)
end

function edgeLengthRads(edge, length)
    ccall((:edgeLengthRads, libh3), H3Error, (H3Index, Ptr{Cdouble}), edge, length)
end

function edgeLengthKm(edge, length)
    ccall((:edgeLengthKm, libh3), H3Error, (H3Index, Ptr{Cdouble}), edge, length)
end

function edgeLengthM(edge, length)
    ccall((:edgeLengthM, libh3), H3Error, (H3Index, Ptr{Cdouble}), edge, length)
end

function getNumCells(res, out)
    ccall((:getNumCells, libh3), H3Error, (Cint, Ptr{Int64}), res, out)
end

# no prototype is found for this function at h3api.h:440:14, please use with caution
function res0CellCount()
    ccall((:res0CellCount, libh3), Cint, ())
end

function getRes0Cells(out)
    ccall((:getRes0Cells, libh3), H3Error, (Ptr{H3Index},), out)
end

# no prototype is found for this function at h3api.h:451:14, please use with caution
function pentagonCount()
    ccall((:pentagonCount, libh3), Cint, ())
end

function getPentagons(res, out)
    ccall((:getPentagons, libh3), H3Error, (Cint, Ptr{H3Index}), res, out)
end

function getResolution(h)
    ccall((:getResolution, libh3), Cint, (H3Index,), h)
end

function getBaseCellNumber(h)
    ccall((:getBaseCellNumber, libh3), Cint, (H3Index,), h)
end

function stringToH3(str, out)
    ccall((:stringToH3, libh3), H3Error, (Ptr{Cchar}, Ptr{H3Index}), str, out)
end

function h3ToString(h, str, sz)
    ccall((:h3ToString, libh3), H3Error, (H3Index, Ptr{Cchar}, Csize_t), h, str, sz)
end

function isValidCell(h)
    ccall((:isValidCell, libh3), Cint, (H3Index,), h)
end

function cellToParent(h, parentRes, parent)
    ccall((:cellToParent, libh3), H3Error, (H3Index, Cint, Ptr{H3Index}), h, parentRes, parent)
end

function cellToChildrenSize(h, childRes, out)
    ccall((:cellToChildrenSize, libh3), H3Error, (H3Index, Cint, Ptr{Int64}), h, childRes, out)
end

function cellToChildren(h, childRes, children)
    ccall((:cellToChildren, libh3), H3Error, (H3Index, Cint, Ptr{H3Index}), h, childRes, children)
end

function cellToCenterChild(h, childRes, child)
    ccall((:cellToCenterChild, libh3), H3Error, (H3Index, Cint, Ptr{H3Index}), h, childRes, child)
end

function cellToChildPos(child, parentRes, out)
    ccall((:cellToChildPos, libh3), H3Error, (H3Index, Cint, Ptr{Int64}), child, parentRes, out)
end

function childPosToCell(childPos, parent, childRes, child)
    ccall((:childPosToCell, libh3), H3Error, (Int64, H3Index, Cint, Ptr{H3Index}), childPos, parent, childRes, child)
end

function compactCells(h3Set, compactedSet, numHexes)
    ccall((:compactCells, libh3), H3Error, (Ptr{H3Index}, Ptr{H3Index}, Int64), h3Set, compactedSet, numHexes)
end

function uncompactCellsSize(compactedSet, numCompacted, res, out)
    ccall((:uncompactCellsSize, libh3), H3Error, (Ptr{H3Index}, Int64, Cint, Ptr{Int64}), compactedSet, numCompacted, res, out)
end

function uncompactCells(compactedSet, numCompacted, outSet, numOut, res)
    ccall((:uncompactCells, libh3), H3Error, (Ptr{H3Index}, Int64, Ptr{H3Index}, Int64, Cint), compactedSet, numCompacted, outSet, numOut, res)
end

function isResClassIII(h)
    ccall((:isResClassIII, libh3), Cint, (H3Index,), h)
end

function isPentagon(h)
    ccall((:isPentagon, libh3), Cint, (H3Index,), h)
end

function maxFaceCount(h3, out)
    ccall((:maxFaceCount, libh3), H3Error, (H3Index, Ptr{Cint}), h3, out)
end

function getIcosahedronFaces(h3, out)
    ccall((:getIcosahedronFaces, libh3), H3Error, (H3Index, Ptr{Cint}), h3, out)
end

function areNeighborCells(origin, destination, out)
    ccall((:areNeighborCells, libh3), H3Error, (H3Index, H3Index, Ptr{Cint}), origin, destination, out)
end

function cellsToDirectedEdge(origin, destination, out)
    ccall((:cellsToDirectedEdge, libh3), H3Error, (H3Index, H3Index, Ptr{H3Index}), origin, destination, out)
end

function isValidDirectedEdge(edge)
    ccall((:isValidDirectedEdge, libh3), Cint, (H3Index,), edge)
end

function getDirectedEdgeOrigin(edge, out)
    ccall((:getDirectedEdgeOrigin, libh3), H3Error, (H3Index, Ptr{H3Index}), edge, out)
end

function getDirectedEdgeDestination(edge, out)
    ccall((:getDirectedEdgeDestination, libh3), H3Error, (H3Index, Ptr{H3Index}), edge, out)
end

function directedEdgeToCells(edge, originDestination)
    ccall((:directedEdgeToCells, libh3), H3Error, (H3Index, Ptr{H3Index}), edge, originDestination)
end

function originToDirectedEdges(origin, edges)
    ccall((:originToDirectedEdges, libh3), H3Error, (H3Index, Ptr{H3Index}), origin, edges)
end

function directedEdgeToBoundary(edge, gb)
    ccall((:directedEdgeToBoundary, libh3), H3Error, (H3Index, Ptr{CellBoundary}), edge, gb)
end

function cellToVertex(origin, vertexNum, out)
    ccall((:cellToVertex, libh3), H3Error, (H3Index, Cint, Ptr{H3Index}), origin, vertexNum, out)
end

function cellToVertexes(origin, vertexes)
    ccall((:cellToVertexes, libh3), H3Error, (H3Index, Ptr{H3Index}), origin, vertexes)
end

function vertexToLatLng(vertex, point)
    ccall((:vertexToLatLng, libh3), H3Error, (H3Index, Ptr{LatLng}), vertex, point)
end

function isValidVertex(vertex)
    ccall((:isValidVertex, libh3), Cint, (H3Index,), vertex)
end

function gridDistance(origin, h3, distance)
    ccall((:gridDistance, libh3), H3Error, (H3Index, H3Index, Ptr{Int64}), origin, h3, distance)
end

function gridPathCellsSize(start, _end, size)
    ccall((:gridPathCellsSize, libh3), H3Error, (H3Index, H3Index, Ptr{Int64}), start, _end, size)
end

function gridPathCells(start, _end, out)
    ccall((:gridPathCells, libh3), H3Error, (H3Index, H3Index, Ptr{H3Index}), start, _end, out)
end

function cellToLocalIj(origin, h3, mode, out)
    ccall((:cellToLocalIj, libh3), H3Error, (H3Index, H3Index, UInt32, Ptr{CoordIJ}), origin, h3, mode, out)
end

function localIjToCell(origin, ij, mode, out)
    ccall((:localIjToCell, libh3), H3Error, (H3Index, Ptr{CoordIJ}, UInt32, Ptr{H3Index}), origin, ij, mode, out)
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
    PENTAGON_SKIPPED_DIGIT = 1
end

function h3NeighborRotations(origin, dir, rotations, out)
    ccall((:h3NeighborRotations, libh3), H3Error, (H3Index, Direction, Ptr{Cint}, Ptr{H3Index}), origin, dir, rotations, out)
end

function directionForNeighbor(origin, destination)
    ccall((:directionForNeighbor, libh3), Direction, (H3Index, H3Index), origin, destination)
end

function _kRingInternal(origin, k, out, distances, maxIdx, curK)
    ccall((:_kRingInternal, libh3), Cvoid, (H3Index, Cint, Ptr{H3Index}, Ptr{Cint}, Cint, Cint), origin, k, out, distances, maxIdx, curK)
end

struct VertexNode
    from::LatLng
    to::LatLng
    next::Ptr{VertexNode}
end

struct VertexGraph
    buckets::Ptr{Ptr{VertexNode}}
    numBuckets::Cint
    size::Cint
    res::Cint
end

function h3SetToVertexGraph(h3Set, numHexes, out)
    ccall((:h3SetToVertexGraph, libh3), H3Error, (Ptr{H3Index}, Cint, Ptr{VertexGraph}), h3Set, numHexes, out)
end

function _vertexGraphToLinkedGeo(graph, out)
    ccall((:_vertexGraphToLinkedGeo, libh3), Cvoid, (Ptr{VertexGraph}, Ptr{LinkedGeoPolygon}), graph, out)
end

function _getEdgeHexagons(geoloop, numHexagons, res, numSearchHexes, search, found)
    ccall((:_getEdgeHexagons, libh3), H3Error, (Ptr{GeoLoop}, Int64, Cint, Ptr{Int64}, Ptr{H3Index}, Ptr{H3Index}), geoloop, numHexagons, res, numSearchHexes, search, found)
end

function _gridDiskDistancesInternal(origin, k, out, distances, maxIdx, curK)
    ccall((:_gridDiskDistancesInternal, libh3), H3Error, (H3Index, Cint, Ptr{H3Index}, Ptr{Cint}, Int64, Cint), origin, k, out, distances, maxIdx, curK)
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
    ccall((:bboxCenter, libh3), Cvoid, (Ptr{BBox}, Ptr{LatLng}), bbox, center)
end

function bboxContains(bbox, point)
    ccall((:bboxContains, libh3), Bool, (Ptr{BBox}, Ptr{LatLng}), bbox, point)
end

function bboxEquals(b1, b2)
    ccall((:bboxEquals, libh3), Bool, (Ptr{BBox}, Ptr{BBox}), b1, b2)
end

function bboxHexEstimate(bbox, res, out)
    ccall((:bboxHexEstimate, libh3), H3Error, (Ptr{BBox}, Cint, Ptr{Int64}), bbox, res, out)
end

function lineHexEstimate(origin, destination, res, out)
    ccall((:lineHexEstimate, libh3), H3Error, (Ptr{LatLng}, Ptr{LatLng}, Cint, Ptr{Int64}), origin, destination, res, out)
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

function _ijkNormalizeCouldOverflow(ijk)
    ccall((:_ijkNormalizeCouldOverflow, libh3), Bool, (Ptr{CoordIJK},), ijk)
end

function _ijkNormalize(c)
    ccall((:_ijkNormalize, libh3), Cvoid, (Ptr{CoordIJK},), c)
end

function _unitIjkToDigit(ijk)
    ccall((:_unitIjkToDigit, libh3), Direction, (Ptr{CoordIJK},), ijk)
end

function _upAp7Checked(ijk)
    ccall((:_upAp7Checked, libh3), H3Error, (Ptr{CoordIJK},), ijk)
end

function _upAp7rChecked(ijk)
    ccall((:_upAp7rChecked, libh3), H3Error, (Ptr{CoordIJK},), ijk)
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
    ccall((:ijToIjk, libh3), H3Error, (Ptr{CoordIJ}, Ptr{CoordIJK}), ij, ijk)
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
    ccall((:_geoToFaceIjk, libh3), Cvoid, (Ptr{LatLng}, Cint, Ptr{FaceIJK}), g, res, h)
end

function _geoToHex2d(g, res, face, v)
    ccall((:_geoToHex2d, libh3), Cvoid, (Ptr{LatLng}, Cint, Ptr{Cint}, Ptr{Vec2d}), g, res, face, v)
end

function _faceIjkToGeo(h, res, g)
    ccall((:_faceIjkToGeo, libh3), Cvoid, (Ptr{FaceIJK}, Cint, Ptr{LatLng}), h, res, g)
end

function _faceIjkToCellBoundary(h, res, start, length, g)
    ccall((:_faceIjkToCellBoundary, libh3), Cvoid, (Ptr{FaceIJK}, Cint, Cint, Cint, Ptr{CellBoundary}), h, res, start, length, g)
end

function _faceIjkPentToCellBoundary(h, res, start, length, g)
    ccall((:_faceIjkPentToCellBoundary, libh3), Cvoid, (Ptr{FaceIJK}, Cint, Cint, Cint, Ptr{CellBoundary}), h, res, start, length, g)
end

function _faceIjkToVerts(fijk, res, fijkVerts)
    ccall((:_faceIjkToVerts, libh3), Cvoid, (Ptr{FaceIJK}, Ptr{Cint}, Ptr{FaceIJK}), fijk, res, fijkVerts)
end

function _faceIjkPentToVerts(fijk, res, fijkVerts)
    ccall((:_faceIjkPentToVerts, libh3), Cvoid, (Ptr{FaceIJK}, Ptr{Cint}, Ptr{FaceIJK}), fijk, res, fijkVerts)
end

function _hex2dToGeo(v, face, res, substrate, g)
    ccall((:_hex2dToGeo, libh3), Cvoid, (Ptr{Vec2d}, Cint, Cint, Cint, Ptr{LatLng}), v, face, res, substrate, g)
end

function _adjustOverageClassII(fijk, res, pentLeading4, substrate)
    ccall((:_adjustOverageClassII, libh3), Overage, (Ptr{FaceIJK}, Cint, Cint, Cint), fijk, res, pentLeading4, substrate)
end

function _adjustPentVertOverage(fijk, res)
    ccall((:_adjustPentVertOverage, libh3), Overage, (Ptr{FaceIJK}, Cint), fijk, res)
end

function _geoToClosestFace(g, face, sqd)
    ccall((:_geoToClosestFace, libh3), Cvoid, (Ptr{LatLng}, Ptr{Cint}, Ptr{Cdouble}), g, face, sqd)
end

function setH3Index(h, res, baseCell, initDigit)
    ccall((:setH3Index, libh3), Cvoid, (Ptr{H3Index}, Cint, Cint, Direction), h, res, baseCell, initDigit)
end

function isResolutionClassIII(r)
    ccall((:isResolutionClassIII, libh3), Cint, (Cint,), r)
end

function _h3ToFaceIjkWithInitializedFijk(h, fijk)
    ccall((:_h3ToFaceIjkWithInitializedFijk, libh3), Cint, (H3Index, Ptr{FaceIJK}), h, fijk)
end

function _h3ToFaceIjk(h, fijk)
    ccall((:_h3ToFaceIjk, libh3), H3Error, (H3Index, Ptr{FaceIJK}), h, fijk)
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

function _zeroIndexDigits(h, start, _end)
    ccall((:_zeroIndexDigits, libh3), H3Index, (H3Index, Cint, Cint), h, start, _end)
end

struct IterCellsChildren
    h::H3Index
    _parentRes::Cint
    _skipDigit::Cint
end

function iterInitParent(h, childRes)
    ccall((:iterInitParent, libh3), IterCellsChildren, (H3Index, Cint), h, childRes)
end

function iterInitBaseCellNum(baseCellNum, childRes)
    ccall((:iterInitBaseCellNum, libh3), IterCellsChildren, (Cint, Cint), baseCellNum, childRes)
end

function iterStepChild(iter)
    ccall((:iterStepChild, libh3), Cvoid, (Ptr{IterCellsChildren},), iter)
end

struct IterCellsResolution
    h::H3Index
    _baseCellNum::Cint
    _res::Cint
    _itC::IterCellsChildren
end

function iterInitRes(res)
    ccall((:iterInitRes, libh3), IterCellsResolution, (Cint,), res)
end

function iterStepRes(iter)
    ccall((:iterStepRes, libh3), Cvoid, (Ptr{IterCellsResolution},), iter)
end

function setGeoDegs(p, latDegs, lngDegs)
    ccall((:setGeoDegs, libh3), Cvoid, (Ptr{LatLng}, Cdouble, Cdouble), p, latDegs, lngDegs)
end

function constrainLat(lat)
    ccall((:constrainLat, libh3), Cdouble, (Cdouble,), lat)
end

function constrainLng(lng)
    ccall((:constrainLng, libh3), Cdouble, (Cdouble,), lng)
end

function geoAlmostEqual(p1, p2)
    ccall((:geoAlmostEqual, libh3), Bool, (Ptr{LatLng}, Ptr{LatLng}), p1, p2)
end

function geoAlmostEqualThreshold(p1, p2, threshold)
    ccall((:geoAlmostEqualThreshold, libh3), Bool, (Ptr{LatLng}, Ptr{LatLng}, Cdouble), p1, p2, threshold)
end

function _posAngleRads(rads)
    ccall((:_posAngleRads, libh3), Cdouble, (Cdouble,), rads)
end

function _setGeoRads(p, latRads, lngRads)
    ccall((:_setGeoRads, libh3), Cvoid, (Ptr{LatLng}, Cdouble, Cdouble), p, latRads, lngRads)
end

function _geoAzimuthRads(p1, p2)
    ccall((:_geoAzimuthRads, libh3), Cdouble, (Ptr{LatLng}, Ptr{LatLng}), p1, p2)
end

function _geoAzDistanceRads(p1, az, distance, p2)
    ccall((:_geoAzDistanceRads, libh3), Cvoid, (Ptr{LatLng}, Cdouble, Cdouble, Ptr{LatLng}), p1, az, distance, p2)
end

function normalizeMultiPolygon(root)
    ccall((:normalizeMultiPolygon, libh3), H3Error, (Ptr{LinkedGeoPolygon},), root)
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
    ccall((:addLinkedCoord, libh3), Ptr{LinkedLatLng}, (Ptr{LinkedGeoLoop}, Ptr{LatLng}), loop, vertex)
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
    ccall((:pointInsideLinkedGeoLoop, libh3), Bool, (Ptr{LinkedGeoLoop}, Ptr{BBox}, Ptr{LatLng}), loop, bbox, coord)
end

function isClockwiseLinkedGeoLoop(loop)
    ccall((:isClockwiseLinkedGeoLoop, libh3), Bool, (Ptr{LinkedGeoLoop},), loop)
end

function cellToLocalIjk(origin, h3, out)
    ccall((:cellToLocalIjk, libh3), H3Error, (H3Index, H3Index, Ptr{CoordIJK}), origin, h3, out)
end

function localIjkToCell(origin, ijk, out)
    ccall((:localIjkToCell, libh3), H3Error, (H3Index, Ptr{CoordIJK}, Ptr{H3Index}), origin, ijk, out)
end

function _ipow(base, exp)
    ccall((:_ipow, libh3), Int64, (Int64, Int64), base, exp)
end

function bboxesFromGeoPolygon(polygon, bboxes)
    ccall((:bboxesFromGeoPolygon, libh3), Cvoid, (Ptr{GeoPolygon}, Ptr{BBox}), polygon, bboxes)
end

function pointInsidePolygon(geoPolygon, bboxes, coord)
    ccall((:pointInsidePolygon, libh3), Bool, (Ptr{GeoPolygon}, Ptr{BBox}, Ptr{LatLng}), geoPolygon, bboxes, coord)
end

function bboxFromGeoLoop(loop, bbox)
    ccall((:bboxFromGeoLoop, libh3), Cvoid, (Ptr{GeoLoop}, Ptr{BBox}), loop, bbox)
end

function pointInsideGeoLoop(loop, bbox, coord)
    ccall((:pointInsideGeoLoop, libh3), Bool, (Ptr{GeoLoop}, Ptr{BBox}, Ptr{LatLng}), loop, bbox, coord)
end

function isClockwiseGeoLoop(geoloop)
    ccall((:isClockwiseGeoLoop, libh3), Bool, (Ptr{GeoLoop},), geoloop)
end

function _v2dMag(v)
    ccall((:_v2dMag, libh3), Cdouble, (Ptr{Vec2d},), v)
end

function _v2dIntersect(p0, p1, p2, p3, inter)
    ccall((:_v2dIntersect, libh3), Cvoid, (Ptr{Vec2d}, Ptr{Vec2d}, Ptr{Vec2d}, Ptr{Vec2d}, Ptr{Vec2d}), p0, p1, p2, p3, inter)
end

function _v2dAlmostEquals(p0, p1)
    ccall((:_v2dAlmostEquals, libh3), Bool, (Ptr{Vec2d}, Ptr{Vec2d}), p0, p1)
end

struct Vec3d
    x::Cdouble
    y::Cdouble
    z::Cdouble
end

function _geoToVec3d(geo, point)
    ccall((:_geoToVec3d, libh3), Cvoid, (Ptr{LatLng}, Ptr{Vec3d}), geo, point)
end

function _pointSquareDist(p1, p2)
    ccall((:_pointSquareDist, libh3), Cdouble, (Ptr{Vec3d}, Ptr{Vec3d}), p1, p2)
end

struct PentagonDirectionFaces
    baseCell::Cint
    faces::NTuple{5, Cint}
end

function vertexNumForDirection(origin, direction)
    ccall((:vertexNumForDirection, libh3), Cint, (H3Index, Direction), origin, direction)
end

function directionForVertexNum(origin, vertexNum)
    ccall((:directionForVertexNum, libh3), Direction, (H3Index, Cint), origin, vertexNum)
end

function initVertexGraph(graph, numBuckets, res)
    ccall((:initVertexGraph, libh3), Cvoid, (Ptr{VertexGraph}, Cint, Cint), graph, numBuckets, res)
end

function destroyVertexGraph(graph)
    ccall((:destroyVertexGraph, libh3), Cvoid, (Ptr{VertexGraph},), graph)
end

function addVertexNode(graph, fromVtx, toVtx)
    ccall((:addVertexNode, libh3), Ptr{VertexNode}, (Ptr{VertexGraph}, Ptr{LatLng}, Ptr{LatLng}), graph, fromVtx, toVtx)
end

function removeVertexNode(graph, node)
    ccall((:removeVertexNode, libh3), Cint, (Ptr{VertexGraph}, Ptr{VertexNode}), graph, node)
end

function findNodeForEdge(graph, fromVtx, toVtx)
    ccall((:findNodeForEdge, libh3), Ptr{VertexNode}, (Ptr{VertexGraph}, Ptr{LatLng}, Ptr{LatLng}), graph, fromVtx, toVtx)
end

function findNodeForVertex(graph, fromVtx)
    ccall((:findNodeForVertex, libh3), Ptr{VertexNode}, (Ptr{VertexGraph}, Ptr{LatLng}), graph, fromVtx)
end

function firstVertexNode(graph)
    ccall((:firstVertexNode, libh3), Ptr{VertexNode}, (Ptr{VertexGraph},), graph)
end

function _hashVertex(vertex, res, numBuckets)
    ccall((:_hashVertex, libh3), UInt32, (Ptr{LatLng}, Cint, Cint), vertex, res, numBuckets)
end

function _initVertexNode(node, fromVtx, toVtx)
    ccall((:_initVertexNode, libh3), Cvoid, (Ptr{VertexNode}, Ptr{LatLng}, Ptr{LatLng}), node, fromVtx, toVtx)
end

const DECLSPEC = nothing

const H3_NULL = 0

const H3_VERSION_MAJOR = 4

const H3_VERSION_MINOR = 1

const H3_VERSION_PATCH = 0

const MAX_CELL_BNDRY_VERTS = 10

const M_PI = 3.141592653589793

const M_PI_2 = 1.5707963267948966

const MAX_H3_RES = 15

const NUM_ICOSA_FACES = 20

const NUM_BASE_CELLS = 122

const NUM_HEX_VERTS = 6

const NUM_PENT_VERTS = 5

const NUM_PENTAGONS = 12

const H3_CELL_MODE = 1

const H3_DIRECTEDEDGE_MODE = 2

const H3_EDGE_MODE = 3

const H3_VERTEX_MODE = 4

const INVALID_BASE_CELL = 127

const MAX_FACE_COORD = 2

const INVALID_ROTATIONS = -1

const IJ = 1

const KI = 2

const JK = 3

const INVALID_FACE = -1

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

const EPSILON_DEG = 1.0e-9

const INVALID_VERTEX_NUM = -1

const MAX_BASE_CELL_FACES = 5

end # module
