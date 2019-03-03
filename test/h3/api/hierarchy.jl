module test_h3_api_hierarchy

using Test
using H3.API # h3ToParent h3ToChildren maxH3ToChildrenSize compact uncompact maxUncompactSize

res = 1
sf = GeoCoord(0.659966917655, 2pi - 2.1364398519396)
child = geoToH3(sf, res)
@test child == 0x081283ffffffffff
@test h3GetResolution(child) == res

parent = h3ToParent(child, res)
@test parent == child

sfHex8 = geoToH3(sf, 8)
sfHex9s = h3ToChildren(sfHex8, 9)
center = h3ToGeo(sfHex8)
sfHex9_0 = geoToH3(center, 9)
@test sfHex9s[1] == sfHex9_0

@test maxH3ToChildrenSize(sfHex8, 9) == 7

const NUM_BASE_CELLS = 122
hexCount = NUM_BASE_CELLS
res0Hexes = fill(0x0000_0000_0000_0001, hexCount)
compressed = compact(res0Hexes)
@test length(compressed) == NUM_BASE_CELLS

maxHexes = maxUncompactSize(compressed, 0)
@test maxHexes == NUM_BASE_CELLS

decompressed = uncompact(compressed, 0)
@test length(decompressed) == 122

decompressed = uncompact(compressed, 1)
@test length(decompressed) == 854

end # module test_h3_api_hierarchy
