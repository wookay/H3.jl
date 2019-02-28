module test_h3_api_unidirectional_edges

using Test
using H3.API # h3IndexesAreNeighbors getH3UnidirectionalEdge h3UnidirectionalEdgeIsValid getOriginH3IndexFromUnidirectionalEdge getDestinationH3IndexFromUnidirectionalEdge getH3IndexesFromUnidirectionalEdge getH3UnidirectionalEdgesFromHexagon getH3UnidirectionalEdgeBoundary ≈

sfGeo = GeoCoord(0.659966917655, -2.1364398519396)
sf = geoToH3(sfGeo, 9)
ring = hexRing(sf, 1)
@test ring == [0x089283080ddbffff, 0x089283080c37ffff, 0x089283080c27ffff, 0x089283080d53ffff, 0x089283080dcfffff, 0x089283080dc3ffff]
@test !h3IndexesAreNeighbors(sf, sf)

sf2 = ring[1]
edge = getH3UnidirectionalEdge(sf, sf2)
@test edge == 0x149283080dcbffff

@test h3UnidirectionalEdgeIsValid(edge)

@test sf == getOriginH3IndexFromUnidirectionalEdge(edge)

@test sf2 == getDestinationH3IndexFromUnidirectionalEdge(edge)

originDestination = getH3IndexesFromUnidirectionalEdge(edge)
@test originDestination == (0x089283080dcbffff, 0x089283080ddbffff)

edges = getH3UnidirectionalEdgesFromHexagon(sf)
@test edges == [0x119283080dcbffff, 0x129283080dcbffff, 0x139283080dcbffff, 0x149283080dcbffff, 0x159283080dcbffff, 0x169283080dcbffff]

edgeBoundary = getH3UnidirectionalEdgeBoundary(edges[1])
@test edgeBoundary ≈ [GeoCoord(0.6600077078134922, -2.1364818365456384), GeoCoord(0.6599783466210994, -2.136500544207272)]

end # module test_h3_api_unidirectional_edges
