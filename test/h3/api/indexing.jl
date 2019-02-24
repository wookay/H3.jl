module test_h3_api_indexing

using Test
using H3.API # geoToH3 h3ToGeo h3ToGeoBoundary GeoCoord GeoBoundary

location = GeoCoord(0.6518070561696664, -2.128889370371519)
@test geoToH3(location, 1) == 0x081283ffffffffff
@test geoToH3(location, 10) == 0x08a2834700007fff

@test h3ToGeo(0x85283473fffffff) == GeoCoord(0.6518070561696664, -2.128889370371519)

boundary = h3ToGeoBoundary(0x85283473fffffff)
@test boundary.numVerts == 6
@test boundary.verts[1:5] == (GeoCoord(0.6505078765569766, -2.1278195595404963),
                              GeoCoord(0.6519490051151717, -2.126897030193998),
                              GeoCoord(0.6532477872571462, -2.1279673831553825),
                              GeoCoord(0.6531044519454293, -2.1299602868027208),
                              GeoCoord(0.6516632883200013, -2.130879969983952))

end # module test_h3_api_indexing
