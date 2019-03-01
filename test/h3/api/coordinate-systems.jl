module test_h3_api_coordinate_systems

using Test
using H3.API # Vec2d Vec3d CoordIJK FaceIJK ijToIjk ijkToHex2d ijkToIj ijkDistance ijkNormalize h3ToLocalIjk h3ToFaceIjk localIjkToH3 faceIjkToH3 hex2dToCoordIJK geoToVec3d geoToFaceIjk

@test ijkToHex2d(CoordIJK(0, 0, 0)) == Vec2d(0.0, 0.0)
@test ijkToHex2d(CoordIJK(0, 0, 1)) == Vec2d(-0.5, -0.8660254037844386)
@test ijkToHex2d(CoordIJK(0, 1, 0)) == Vec2d(-0.5, 0.8660254037844386)
@test ijkToHex2d(CoordIJK(0, 1, 1)) == Vec2d(-1.0, 0.0)
@test ijkToHex2d(CoordIJK(1, 0, 0)) == Vec2d(1.0, 0.0)
@test ijkToHex2d(CoordIJK(1, 0, 1)) == Vec2d(0.5, -0.8660254037844386)
@test ijkToHex2d(CoordIJK(1, 1, 0)) == Vec2d(0.5, 0.8660254037844386)

h = 0x85283473fffffff
ijk = CoordIJK(0, 37, 120)
@test ijkToHex2d(ijk) == Vec2d(-78.5, -71.88010851410841)
@test ijkToIj(ijk) == CoordIJ(-120, -83)
@test ijToIjk(CoordIJ(-120, -83)) == ijk
@test hex2dToCoordIJK(Vec2d(-78.5, -71.88010851410841)) == ijk
@test localIjkToH3(h, ijk) == 0x0851c29c7fffffff
@test h3ToLocalIjk(h, 0x0851c29c7fffffff) == ijk

faceijk = FaceIJK(7, ijk)
@test faceijk.face == 7
@test faceijk.coord == ijk
@test h3ToFaceIjk(h) == faceijk
@test faceIjkToH3(faceijk, 5) == h

geo = h3ToGeo(h)
@test geo == GeoCoord(0.6518070561696664, -2.128889370371519)
@test geoToH3(geo, 5) == h
@test geoToFaceIjk(geo, 5) == faceijk
@test geoToVec3d(geo) == Vec3d(-0.42100191417850585, -0.674362461213141, 0.6066239849895393)

ijk = CoordIJK(-1, 37, 120)
@test ijkDistance(ijk, CoordIJK(-1, 37, 120)) == 0
@test ijkDistance(ijk, CoordIJK(0, 37, 120))  == 1
@test ijkDistance(ijk, CoordIJK(1, 37, 120))  == 2
@test ijkNormalize(ijk) == CoordIJK(0, 38, 121)

end # module test_h3_api_coordinate_systems
