module test_h3_api_misc

using Test
using H3.API # degsToRads radsToDegs hexAreaKm2 hexAreaM2 edgeLengthKm edgeLengthM numHexagons getRes0Indexes res0IndexCount

@test degsToRads(180) == deg2rad(180)

@test radsToDegs(1) == rad2deg(1)

@test hexAreaKm2(1) ==  607220.9782

@test hexAreaM2(1) == 6.07221e11

@test edgeLengthKm(1) == 418.6760055

@test edgeLengthM(1) == 418676.0055

@test numHexagons(0) == 122
@test numHexagons(1) == 842

@test length(getRes0Indexes()) == 122 * 8

@test res0IndexCount() == 122

end # module test_h3_api_misc
