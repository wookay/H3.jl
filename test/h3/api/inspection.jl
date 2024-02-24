module test_h3_api_inspection

using Test
using H3.API # getResolution getBaseCellNumber stringToH3 h3ToString isValidCell isResClassIII isPentagon

@test getResolution(0x085283473fffffff) == 5

@test getBaseCellNumber(0x085283473fffffff) == 20

@test stringToH3("85283473fffffff") == 0x085283473fffffff

@test h3ToString(0x085283473fffffff) == "85283473fffffff"

@test isValidCell(0x85283473fffffff)
@test !isValidCell(0x5004295803a8800)

@test isResClassIII(0x085283473fffffff)

@test !isPentagon(0x085283473fffffff)

end # module test_h3_api_inspection
