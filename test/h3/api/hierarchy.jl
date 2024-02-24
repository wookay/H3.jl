module test_h3_api_hierarchy

using Test
using H3.API # cellToParent h3ToChildren maxH3ToChildrenSize compact uncompact maxUncompactSize
using H3.Lib

res = 1
sf = LatLng(0.659966917655, 2pi - 2.1364398519396)
child = latLngToCell(sf, res)
@test child == 0x081283ffffffffff
@test getResolution(child) == res

parent = cellToParent(child, res)
@test parent == child

sfHex8 = latLngToCell(sf, 8)
sfHex9s = cellToChildren(sfHex8, 9)
center = cellToLatLng(sfHex8)
sfHex9_0 = latLngToCell(center, 9)
@test sfHex9s[1] == sfHex9_0

@test cellToChildrenSize(sfHex8, 9) == 7

hexCount = Lib.NUM_BASE_CELLS
res0Hexes = fill(0x0000_0000_0000_0001, hexCount)
compressed = compactCells(res0Hexes)
@test length(compressed) == hexCount

maxHexes = uncompactCellsSize(compressed, 0)
@test maxHexes == hexCount

decompressed = uncompactCells(compressed, 0)
@test length(decompressed) == 122

decompressed = uncompactCells(compressed, 1)
@test length(decompressed) == 854

end # module test_h3_api_hierarchy
