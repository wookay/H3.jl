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
@test length(res0indexes) == 122

h = 0x08001fffffffffff
@test first(res0indexes) == h
@test h3GetResolution(h) == 0
@test geoToH3(h3ToGeo(h), 0) == h
faceijk = h3ToFaceIjk(h)
@test faceijk == FaceIJK(1, CoordIJK(1, 0, 0))
@test h3ToLocalIjk(h, h) == CoordIJK(0, 0, 0)
using H3.Lib
@test Lib.h3GetBaseCell(h) == 0

h = last(res0indexes)
@test h == 0x080f3fffffffffff
@test h3GetResolution(h) == 0
@test geoToH3(h3ToGeo(h), 0) == 0x080f3fffffffffff
faceijk = h3ToFaceIjk(h)
@test h3ToFaceIjk(h) == FaceIJK(18, CoordIJK(1, 0, 0))

@test h3ToFaceIjk.(res0indexes[1:10]) == [FaceIJK(1, CoordIJK(1, 0, 0)),
                                          FaceIJK(2, CoordIJK(1, 1, 0)),
                                          FaceIJK(1, CoordIJK(0, 0, 0)),
                                          FaceIJK(2, CoordIJK(1, 0, 0)),
                                          FaceIJK(0, CoordIJK(2, 0, 0)),
                                          FaceIJK(1, CoordIJK(1, 1, 0)),
                                          FaceIJK(1, CoordIJK(0, 0, 1)),
                                          FaceIJK(2, CoordIJK(0, 0, 0)),
                                          FaceIJK(0, CoordIJK(1, 0, 0)),
                                          FaceIJK(2, CoordIJK(0, 1, 0))]

@test h3ToFaceIjk.(res0indexes[end-10:end]) == [FaceIJK(18, CoordIJK(0, 0, 1)),
                                                FaceIJK(19, CoordIJK(0, 0, 1)),
                                                FaceIJK(17, CoordIJK(1, 0, 0)),
                                                FaceIJK(19, CoordIJK(0, 0, 0)),
                                                FaceIJK(18, CoordIJK(0, 1, 0)),
                                                FaceIJK(18, CoordIJK(1, 0, 1)),
                                                FaceIJK(19, CoordIJK(2, 0, 0)),
                                                FaceIJK(19, CoordIJK(1, 0, 0)),
                                                FaceIJK(18, CoordIJK(0, 0, 0)),
                                                FaceIJK(19, CoordIJK(1, 0, 1)),
                                                FaceIJK(18, CoordIJK(1, 0, 0))]

end # module test_h3_api_misc
