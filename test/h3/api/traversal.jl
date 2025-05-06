module test_h3_api_traversal

using Test
using H3.API # gridDisk maxGridDiskSize gridDiskDistances gridDiskUnsafe gridDisksUnsafe gridPathCells gridPathCellsSize gridDistance cellToLocalIj CoordIJ localIjToCell
using H3.Lib: E_FAILED

@test gridDisk(0x085283473fffffff, 0) == [0x085283473fffffff]
@test gridDisk(0x085283473fffffff, 1) == [0x085283473fffffff, 0x085283447fffffff, 0x08528347bfffffff, 0x085283463fffffff, 0x085283477fffffff, 0x08528340ffffffff, 0x08528340bfffffff]

@test maxGridDiskSize(0) == 1
@test maxGridDiskSize(1) == 7

@test gridDiskDistances(0x08928308280fffff, 0) == (out = [0x08928308280fffff], distances = [0])
@test gridDiskDistances(0x08928308280fffff, 1) == (out = [0x08928308280fffff, 0x08928308280bffff, 0x089283082873ffff, 0x089283082877ffff, 0x08928308283bffff, 0x089283082807ffff, 0x089283082803ffff], distances = [0, 1, 1, 1, 1, 1, 1])

@test gridDiskUnsafe(0x085283473fffffff, 0) == [0x085283473fffffff]
@test gridDiskUnsafe(0x085283473fffffff, 1) == [0x085283473fffffff, 0x085283447fffffff, 0x08528347bfffffff, 0x085283463fffffff, 0x085283477fffffff, 0x08528340ffffffff, 0x08528340bfffffff]

@test gridDiskDistancesUnsafe(0x08928308280fffff, 0) == (out = [0x08928308280fffff], distances = [0])
@test gridDiskDistancesUnsafe(0x08928308280fffff, 1) == (out = [0x08928308280fffff, 0x08928308280bffff, 0x089283082873ffff, 0x089283082877ffff, 0x08928308283bffff, 0x089283082807ffff, 0x089283082803ffff], distances = [0, 1, 1, 1, 1, 1, 1])

@test gridDisksUnsafe([0x08928308280fffff], 0) == [0x08928308280fffff]
@test gridDisksUnsafe([0x08928308280fffff], 1) == [0x08928308280fffff, 0x08928308280bffff, 0x089283082873ffff, 0x089283082877ffff, 0x08928308283bffff, 0x089283082807ffff, 0x089283082803ffff]

@test gridRingUnsafe(0x08928308280fffff, 0) == []
@test gridRingUnsafe(0x08928308280fffff, 1) == [0x089283082803ffff, 0x08928308280bffff, 0x089283082873ffff, 0x089283082877ffff, 0x08928308283bffff, 0x089283082807ffff]

@test gridPathCells(0x08928308280fffff, 0x08928308280fffff) == [0x08928308280fffff]
@test gridPathCells(0x08928308280fffff, 0x08928308283bffff) == [0x08928308280fffff, 0x08928308283bffff]

@test gridPathCellsSize(0x08928308280fffff, 0x08928308280fffff) == 1
@test gridPathCellsSize(0x08928308280fffff, 0x08928308283bffff) == 2

@test gridDistance(0x08928308280fffff, 0x08928308280fffff) == 0
@test gridDistance(0x08928308280fffff, 0x08928308283bffff) == 1
# issue #24
@test gridDistance(0x089012092d37ffff, 0x089012092d37ffff) == 0
@test gridDistance(0x089012092d37ffff, 0x0895536db06bffff) == H3ErrorCode(E_FAILED)

@test cellToLocalIj(0x08828308281fffff, 0x0882830828dfffff) == CoordIJ(393, 337)
@test localIjToCell(0x08828308281fffff, CoordIJ(393, 337)) == 0x0882830828dfffff

end # module test_h3_api_traversal
