module test_h3_lib_traversal

using Test
using H3.Lib

Lib.kRing
Lib.maxKringSize
Lib.kRingDistances
Lib.hexRange
Lib.hexRangeDistances
Lib.hexRanges
Lib.hexRing
Lib.h3Line
Lib.h3LineSize
Lib.h3Distance
Lib.experimentalH3ToLocalIj
Lib.experimentalLocalIjToH3


ring_size = 1
array_len = Lib.maxKringSize(ring_size)
krings = Vector{Lib.H3Index}(undef, array_len)
origin = 0x085283473fffffff
Lib.kRing(origin, ring_size, krings)
@test krings == [0x085283473fffffff, 0x085283447fffffff, 0x08528347bfffffff, 0x085283463fffffff, 0x085283477fffffff, 0x08528340ffffffff, 0x08528340bfffffff]

end # module test_h3_lib_traversal
