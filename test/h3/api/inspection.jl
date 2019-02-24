module test_h3_api_inspection

using Test
using H3.API # h3GetResolution h3GetBaseCell stringToH3 h3ToString h3IsValid h3IsResClassIII h3IsPentagon

@test h3GetResolution(0x085283473fffffff) == 5

@test h3GetBaseCell(0x085283473fffffff) == 20

@test stringToH3("85283473fffffff") == 0x085283473fffffff

@test h3ToString(0x085283473fffffff) == "85283473fffffff"

@test h3IsValid(0x85283473fffffff)
@test !h3IsValid(0x5004295803a8800)

@test h3IsResClassIII(0x085283473fffffff)

@test !h3IsPentagon(0x085283473fffffff)

end # module test_h3_api_inspection
