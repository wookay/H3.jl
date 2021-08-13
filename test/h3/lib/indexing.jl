module test_h3_lib_indexing

using Test
using H3.Lib

Lib.geoToH3
Lib.h3ToGeo
Lib.h3ToGeoBoundary


using .Lib: GeoCoord, GeoBoundary

location = Ref(GeoCoord(0.6518070561696664, -2.128889370371519))
@test Lib.geoToH3(location, 1) == 0x081283ffffffffff
@test Lib.geoToH3(location, 10) == 0x08a2834700007fff

center = Ref{GeoCoord}()
Lib.h3ToGeo(0x85283473fffffff, center)
@test center[] == GeoCoord(0.6518070561696664, -2.128889370371519)

boundary = Ref{GeoBoundary}()
Lib.h3ToGeoBoundary(0x85283473fffffff, boundary)
@test boundary[].numVerts == 6
@test boundary[].verts[1:5] == (GeoCoord(0.6505078765569766, -2.1278195595404963),
                                GeoCoord(0.6519490051151717, -2.126897030193998),
                                GeoCoord(0.6532477872571462, -2.1279673831553825),
                                GeoCoord(0.6531044519454293, -2.1299602868027208),
                                GeoCoord(0.6516632883200013, -2.130879969983952))

@test Lib.H3_INIT == 0x00001fffffffffff
@test Lib.H3_MODE_OFFSET == 59
@test Lib.H3_MODE_MASK == 0x7800000000000000

using H3.API

bc = Lib.H3_INIT
@test API.h3GetResolution(bc) == 0
@test API.h3GetBaseCell(bc) == 0

refh = Ref{H3Index}()
Lib.setH3Index(refh, 5, 12, Lib.Direction(1))
@test refh[] == 0x085184927fffffff
@test API.h3GetResolution(refh[]) == 5
@test API.h3GetBaseCell(refh[]) == 12

Lib.setH3Index(refh, 0, 0, Lib.Direction(0))
@test refh[] == 0x08001fffffffffff
@test API.h3GetResolution(refh[]) == 0
@test API.h3GetBaseCell(refh[]) == 0

end # module test_h3_lib_indexing
