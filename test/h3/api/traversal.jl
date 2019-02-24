module test_h3_api_traversal

using Test
using H3.API # kRing maxKringSize kRingDistances hexRange hexRanges h3Line h3LineSize h3Distance experimentalH3ToLocalIj CoordIJ experimentalLocalIjToH3

@test kRing(0x085283473fffffff, 0) == [0x085283473fffffff]
@test kRing(0x085283473fffffff, 1) == [0x085283473fffffff, 0x085283447fffffff, 0x08528347bfffffff, 0x085283463fffffff, 0x085283477fffffff, 0x08528340ffffffff, 0x08528340bfffffff]

@test maxKringSize(0) == 1
@test maxKringSize(1) == 7

@test kRingDistances(0x08928308280fffff, 0) == (out = [0x08928308280fffff], distances = [0])
@test kRingDistances(0x08928308280fffff, 1) == (out = [0x08928308280fffff, 0x08928308280bffff, 0x089283082873ffff, 0x089283082877ffff, 0x08928308283bffff, 0x089283082807ffff, 0x089283082803ffff], distances = [0, 1, 1, 1, 1, 1, 1])

@test hexRange(0x085283473fffffff, 0) == [0x085283473fffffff]
@test hexRange(0x085283473fffffff, 1) == [0x085283473fffffff, 0x085283447fffffff, 0x08528347bfffffff, 0x085283463fffffff, 0x085283477fffffff, 0x08528340ffffffff, 0x08528340bfffffff]

@test hexRangeDistances(0x08928308280fffff, 0) == (out = [0x08928308280fffff], distances = [0])
@test hexRangeDistances(0x08928308280fffff, 1) == (out = [0x08928308280fffff, 0x08928308280bffff, 0x089283082873ffff, 0x089283082877ffff, 0x08928308283bffff, 0x089283082807ffff, 0x089283082803ffff], distances = [0, 1, 1, 1, 1, 1, 1])

@test hexRanges([0x08928308280fffff], 0) == [0x08928308280fffff]
@test hexRanges([0x08928308280fffff], 1) == [0x08928308280fffff, 0x08928308280bffff, 0x089283082873ffff, 0x089283082877ffff, 0x08928308283bffff, 0x089283082807ffff, 0x089283082803ffff]

@test hexRing(0x08928308280fffff, 0) == []
@test hexRing(0x08928308280fffff, 1) == [0x089283082803ffff, 0x08928308280bffff, 0x089283082873ffff, 0x089283082877ffff, 0x08928308283bffff, 0x089283082807ffff]

@test h3Line(0x08928308280fffff, 0x08928308280fffff) == [0x08928308280fffff]
@test h3Line(0x08928308280fffff, 0x08928308283bffff) == [0x08928308280fffff, 0x08928308283bffff]

@test h3LineSize(0x08928308280fffff, 0x08928308280fffff) == 1
@test h3LineSize(0x08928308280fffff, 0x08928308283bffff) == 2

@test h3Distance(0x08928308280fffff, 0x08928308280fffff) == 0
@test h3Distance(0x08928308280fffff, 0x08928308283bffff) == 1

@test experimentalH3ToLocalIj(0x08828308281fffff, 0x0882830828dfffff) == CoordIJ(393, 337)
@test experimentalLocalIjToH3(0x08828308281fffff, CoordIJ(393, 337)) == 0x0882830828dfffff

end # module test_h3_api_traversal
