module test_h3_api_misc

using Test
using H3.API # hexAreaKm2 hexAreaM2 edgeLengthKm edgeLengthM numHexagons getRes0Indexes res0IndexCount

@test hexAreaKm2(1) == 607220.9782

@test hexAreaM2(1) == 6.07221e11

@test edgeLengthKm(0) == 1107.712591
@test edgeLengthKm(1) == 418.6760055

@test edgeLengthM(0) == 1107712.591
@test edgeLengthM(1) == 418676.0055

@test numHexagons(0) == 122
@test numHexagons(1) == 842
@test numHexagons(5) == 2_016_842
@test numHexagons(15) == 569_707_381_193_162

@test res0IndexCount() == 122

res0indexes = getRes0Indexes()
@test length(res0indexes) == 122 * 8 # 976

h = 0x08001fffffffffff
@test first(res0indexes) == h
@test iszero(h3GetResolution(h))
@test geoToH3(h3ToGeo(h), 0) == h

end # module test_h3_api_misc
