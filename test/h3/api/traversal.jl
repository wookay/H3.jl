module test_h3_api_traversal

using Test
using H3.API # kRing
#=
maxKringSize
kRingDistances
hexRange
hexRangeDistances
hexRanges
hexRing
h3Line
h3LineSize
h3Distance
experimentalH3ToLocalIj
experimentalLocalIjToH3
=#

krings = kRing(0x085283473fffffff, 1)
@test krings == [0x085283473fffffff, 0x085283447fffffff, 0x08528347bfffffff, 0x085283463fffffff, 0x085283477fffffff, 0x08528340ffffffff, 0x08528340bfffffff]

end # module test_h3_api_traversal
