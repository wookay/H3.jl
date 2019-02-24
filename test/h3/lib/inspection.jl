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

# https://medium.com/stuart-engineering/ruby-bindings-and-extensions-91c794eb9acd
bufSz = 17 # 16 hexadecimal characters plus a null terminator
buf = Base.unsafe_convert(Cstring, "")
Lib.h3ToString(0x085283473fffffff, buf, bufSz)
@test Base.unsafe_string(buf) == "85283473fffffff"

@test Lib.h3IsValid(0x85283473fffffff) == 1
@test Lib.h3IsValid(0x5004295803a8800) == 0

@test Lib.h3IsResClassIII(0x085283473fffffff) == 1

@test Lib.h3IsPentagon(0x085283473fffffff) == 0

end # module test_h3_lib_inspection
