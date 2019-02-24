module test_h3_lib_kring

using Test
using H3.Lib

ring_size = 1
array_len = Lib.maxKringSize(ring_size)

krings = Array{UInt64}(undef, array_len)
origin = 0x085283473fffffff
Lib.kRing(origin, ring_size, krings)

@test krings == [0x085283473fffffff, 0x085283447fffffff, 0x08528347bfffffff, 0x085283463fffffff, 0x085283477fffffff, 0x08528340ffffffff, 0x08528340bfffffff]

end # module test_h3_lib_kring
