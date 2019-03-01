module test_h3_api_indexing

using Test
using H3.API # geoToH3 h3ToGeo h3ToGeoBoundary GeoCoord GeoBoundary ≈

location = GeoCoord(0.6518070561696664, -2.128889370371519)
@test geoToH3(location, 1) == 0x081283ffffffffff
@test geoToH3(location, 10) == 0x08a2834700007fff

@test h3ToGeo(0x85283473fffffff) == location

verts = h3ToGeoBoundary(0x85283473fffffff)
@test length(verts) == 6
@test verts ≈ [GeoCoord(0.6505078765569766, -2.1278195595404963),
               GeoCoord(0.6519490051151717, -2.126897030193998),
               GeoCoord(0.6532477872571462, -2.1279673831553825),
               GeoCoord(0.6531044519454293, -2.1299602868027208),
               GeoCoord(0.6516632883200013, -2.130879969983952),
               GeoCoord(0.6503654944795706, -2.129809601095088)]

# https://github.com/uber/h3/blob/master/examples/index.c
location = GeoCoord(degsToRads(40.689167), degsToRads(-74.044444))
indexed = geoToH3(location, 10)
verts = h3ToGeoBoundary(indexed)
@test map(vert -> radsToDegs.((vert.lat, vert.lon)), verts) ≈ [(40.69005860095358, -74.04415176176158),
                                                               (40.68990769452519, -74.0450617923963),
                                                               (40.68927093604355, -74.04534141750702),
                                                               (40.68878509072403, -74.04471103053613),
                                                               (40.688935992642726, -74.04380102076254),
                                                               (40.689572744390524, -74.04352137709904)]
center = h3ToGeo(indexed)
@test (radsToDegs(center.lat), radsToDegs(center.lon)) == (40.68942184369929, -74.04443139990863)

end # module test_h3_api_indexing
