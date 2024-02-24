module test_h3_lib_regions

using Test
using H3.Lib
using H3.API

Lib.polygonToCells
Lib.maxPolygonToCellsSize
Lib.cellsToLinkedMultiPolygon
Lib.destroyLinkedMultiPolygon


using .Lib: H3Index, LatLng, GeoLoop, GeoPolygon

# https://github.com/uber/h3/blob/v3.7.2/src/apps/testapps/testPolyfill.c

sfVerts = [LatLng(0.659966917655, -2.1364398519396),
           LatLng(0.6595011102219, -2.1359434279405),
           LatLng(0.6583348114025, -2.1354884206045),
           LatLng(0.6581220034068, -2.1382437718946),
           LatLng(0.6594479998527, -2.1384597563896),
           LatLng(0.6599990002976, -2.1376771158464)]
sfGeofence = GeoLoop(6, pointer(sfVerts))
sfGeoPolygon = GeoPolygon(sfGeofence, 0, C_NULL)
flags = UInt32(0)
out = Ref{Int64}()
Lib.maxPolygonToCellsSize(Ref(sfGeoPolygon), 9, flags, out)
@test out[] == 5613

holeVerts = [LatLng(0.6595072188743, -2.1371053983433),
             LatLng(0.6591482046471, -2.1373141048153),
             LatLng(0.6592295020837, -2.1365222838402)]
holeGeofence = GeoLoop(3, pointer(holeVerts))
holeGeoPolygon = GeoPolygon(sfGeofence, 1, pointer_from_objref(Ref(holeGeofence)))
out = Ref{Int64}()
Lib.maxPolygonToCellsSize(Ref(holeGeoPolygon), 9, flags, out)
@test out[] == 5613

emptyVerts = [LatLng(0.659966917655, -2.1364398519394),
              LatLng(0.659966917656, -2.1364398519395),
              LatLng(0.659966917657, -2.1364398519396)]
emptyGeofence = GeoLoop(3, pointer(emptyVerts))
emptyGeoPolygon = GeoPolygon(emptyGeofence, 0, C_NULL)
out = Ref{Int64}()
Lib.maxPolygonToCellsSize(Ref(emptyGeoPolygon), 9, flags, out)
@test out[] == 15


# https://h3geo.org/docs/api/regions

to_geocoord((lat, lon)) = LatLng(deg2rad(lat), deg2rad(lon))

sfVerts = map(to_geocoord, [
    [37.813318999983238, -122.4089866999972145],
    [37.7198061999978478, -122.3544736999993603],
    [37.8151571999998453, -122.4798767000009008]
])
res = 7

sfGeofence = GeoLoop(length(sfVerts), pointer(sfVerts))
sfGeoPolygon = GeoPolygon(sfGeofence, 0, C_NULL)
out = Ref{Int64}()
Lib.maxPolygonToCellsSize(Ref(sfGeoPolygon), res, flags, out)
@test out[] == 100

numHexagons = out[]
flags = UInt32(0)
p_hexagons = Libc.calloc(numHexagons, sizeof(H3Index))
Lib.polygonToCells(Ref(sfGeoPolygon), res, flags, p_hexagons)
p = Base.unsafe_convert(Ptr{H3Index}, p_hexagons)
w = unsafe_wrap(Vector{H3Index}, p, numHexagons)
@test filter(!iszero, w) == [0x087283082bffffff, 0x0872830870ffffff, 0x0872830820ffffff, 0x087283082effffff, 0x0872830828ffffff, 0x087283082affffff, 0x0872830876ffffff]
Libc.free(p_hexagons)

end # module test_h3_lib_regions
