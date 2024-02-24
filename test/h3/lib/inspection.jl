module test_h3_lib_inspection

using Test
using H3.Lib

Lib.getResolution
Lib.getBaseCellNumber
Lib.stringToH3
Lib.h3ToString
Lib.isValidCell
Lib.isResClassIII
Lib.isPentagon


@test Lib.getResolution(0x085283473fffffff) == 5

@test Lib.getBaseCellNumber(0x085283473fffffff) == 20

out = Ref{Lib.H3Index}()
Lib.stringToH3("85283473fffffff", out)
@test out[] == 0x085283473fffffff

@test Lib.isValidCell(0x85283473fffffff) == 1
@test Lib.isValidCell(0x5004295803a8800) == 0

@test Lib.isResClassIII(0x085283473fffffff) == 1

@test Lib.isPentagon(0x085283473fffffff) == 0

end # module test_h3_lib_inspection
