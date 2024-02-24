module test_h3_lib_traversal

using Test
using H3.Lib

Lib.gridDisk
Lib.maxGridDiskSize
Lib.gridDiskDistances
Lib.gridDiskUnsafe
Lib.gridDiskDistancesUnsafe
Lib.gridDisksUnsafe
Lib.gridRingUnsafe
Lib.gridPathCells
Lib.gridPathCellsSize
Lib.gridDistance
Lib.cellToLocalIj
Lib.localIjToCell


ring_size = 1
out = Ref{Int64}()
Lib.maxGridDiskSize(ring_size, out)
array_len = out[]
krings = Vector{Lib.H3Index}(undef, array_len)
origin = 0x085283473fffffff
Lib.gridDisk(origin, ring_size, krings)
@test krings == [0x085283473fffffff, 0x085283447fffffff, 0x08528347bfffffff, 0x085283463fffffff, 0x085283477fffffff, 0x08528340ffffffff, 0x08528340bfffffff]

end # module test_h3_lib_traversal
