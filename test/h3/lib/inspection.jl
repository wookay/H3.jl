module test_h3_lib_inspection

using Test
using H3.Lib

Lib.h3GetResolution
Lib.h3GetBaseCell
Lib.stringToH3
Lib.h3ToString
Lib.h3IsValid
Lib.h3IsResClassIII
Lib.h3IsPentagon


@test Lib.h3GetResolution(0x085283473fffffff) == 5

@test Lib.h3GetBaseCell(0x085283473fffffff) == 20

@test Lib.stringToH3("85283473fffffff") == 0x085283473fffffff

@test Lib.h3IsValid(0x85283473fffffff) == 1
@test Lib.h3IsValid(0x5004295803a8800) == 0

@test Lib.h3IsResClassIII(0x085283473fffffff) == 1

@test Lib.h3IsPentagon(0x085283473fffffff) == 0

end # module test_h3_lib_inspection
