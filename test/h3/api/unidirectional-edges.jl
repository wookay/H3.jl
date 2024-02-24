module test_h3_api_unidirectional_edges

using Test
using H3.API # areNeighborCells cellsToDirectedEdge isValidDirectedEdge getDirectedEdgeOrigin getDestinationH3IndexFromUnidirectionalEdge getH3IndexesFromUnidirectionalEdge getH3UnidirectionalEdgesFromHexagon getH3UnidirectionalEdgeBoundary ≈

sfGeo = LatLng(0.659966917655, -2.1364398519396)
sf = latLngToCell(sfGeo, 9)
ring = gridRingUnsafe(sf, 1)
@test ring == [0x089283080ddbffff, 0x089283080c37ffff, 0x089283080c27ffff, 0x089283080d53ffff, 0x089283080dcfffff, 0x089283080dc3ffff]
@test !areNeighborCells(sf, sf)

sf2 = ring[1]
edge = cellsToDirectedEdge(sf, sf2)
@test edge == 0x149283080dcbffff

@test isValidDirectedEdge(edge)

@test sf == getDirectedEdgeOrigin(edge)

@test sf2 == getDirectedEdgeDestination(edge)

originDestination = directedEdgeToCells(edge)
@test originDestination == (0x089283080dcbffff, 0x089283080ddbffff)

edges = originToDirectedEdges(sf)
@test edges == [0x119283080dcbffff, 0x129283080dcbffff, 0x139283080dcbffff, 0x149283080dcbffff, 0x159283080dcbffff, 0x169283080dcbffff]

edgeBoundary = directedEdgeToBoundary(edges[1])
@test edgeBoundary ≈ [LatLng(0.6600077078134922, -2.1364818365456384), LatLng(0.6599783466210994, -2.136500544207272)]

end # module test_h3_api_unidirectional_edges
