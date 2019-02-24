module test_h3_lib_indexing

using Test
using H3
using H3.Lib

Lib.geoToH3
Lib.h3ToGeo
Lib.h3ToGeoBoundary


location = Ref{Lib.GeoCoord}()
resolution = 10
@test Lib.geoToH3(location, resolution) == 0x08a754e64992ffff

center = Ref{Lib.GeoCoord}()
Lib.h3ToGeo(0x85283473fffffff, center)
@test center[] == H3.Lib.GeoCoord(0.6518070561696664, -2.128889370371519)

boundary = Ref{Lib.GeoBoundary}()
Lib.h3ToGeoBoundary(0x85283473fffffff, boundary)
@test boundary[].numVerts == 6
@test boundary[].verts[1:5] == (H3.Lib.GeoCoord(0.6505078765569766, -2.1278195595404963),
                                H3.Lib.GeoCoord(0.6519490051151717, -2.126897030193998),
                                H3.Lib.GeoCoord(0.6532477872571462, -2.1279673831553825),
                                H3.Lib.GeoCoord(0.6531044519454293, -2.1299602868027208),
                                H3.Lib.GeoCoord(0.6516632883200013, -2.130879969983952))

end # module test_h3_lib_indexing
