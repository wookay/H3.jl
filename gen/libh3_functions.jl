# Julia wrapper for header: /Users/wookyoung/.julia/dev/H3/deps/usr/include/h3/h3api.h
# Automatically generated using Clang.jl

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

function hexAreaKm2(res)
    ccall((:hexAreaKm2, libh3), Cdouble, (Cint,), res)
end

function hexAreaM2(res)
    ccall((:hexAreaM2, libh3), Cdouble, (Cint,), res)
end

function edgeLengthKm(res)
    ccall((:edgeLengthKm, libh3), Cdouble, (Cint,), res)
end

function edgeLengthM(res)
    ccall((:edgeLengthM, libh3), Cdouble, (Cint,), res)
end

function numHexagons(res)
    ccall((:numHexagons, libh3), Int64, (Cint,), res)
end

function res0IndexCount()
    ccall((:res0IndexCount, libh3), Cint, ())
end

function getRes0Indexes(out)
    ccall((:getRes0Indexes, libh3), Cvoid, (Ptr{H3Index},), out)
end

function h3GetResolution(h)
    ccall((:h3GetResolution, libh3), Cint, (H3Index,), h)
end

function h3GetBaseCell(h)
    ccall((:h3GetBaseCell, libh3), Cint, (H3Index,), h)
end

function stringToH3(str)
    ccall((:stringToH3, libh3), H3Index, (Cstring,), str)
end

function h3ToString(h, str, sz)
    ccall((:h3ToString, libh3), Cvoid, (H3Index, Cstring, Csize_t), h, str, sz)
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

