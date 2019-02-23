module test_h3_kring

using Test
using H3

ring_size = 1
array_len = H3.maxKringSize(ring_size)

krings = Array{UInt64}(undef, array_len)
origin = 0x085283473fffffff
H3.kRing(origin, ring_size, krings)

@test krings == [0x085283473fffffff, 0x085283447fffffff, 0x08528347bfffffff, 0x085283463fffffff, 0x085283477fffffff, 0x08528340ffffffff, 0x08528340bfffffff]

end # module test_h3_kring
