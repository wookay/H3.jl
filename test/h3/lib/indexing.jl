module test_h3_lib_indexing

using Test
using H3.Lib

Lib.latLngToCell
Lib.cellToLatLng
Lib.cellToBoundary


using .Lib: LatLng, CellBoundary, H3Index

location = Ref(LatLng(0.6518070561696664, -2.128889370371519))
out = Ref{H3Index}()
Lib.latLngToCell(location, 1, out)
@test out[] == 0x081283ffffffffff

Lib.latLngToCell(location, 10, out)
@test out[] == 0x08a2834700007fff

center = Ref{LatLng}()
Lib.cellToLatLng(0x85283473fffffff, center)
@test center[] ≈ LatLng(0.6518070561696664, -2.128889370371519)

boundary = Ref{CellBoundary}()
Lib.cellToBoundary(0x85283473fffffff, boundary)
@test boundary[].numVerts == 6
@test all(boundary[].verts[1:5] .≈ [LatLng(0.6505078765569766, -2.1278195595404963),
                                    LatLng(0.6519490051151717, -2.126897030193998),
                                    LatLng(0.6532477872571462, -2.1279673831553825),
                                    LatLng(0.6531044519454293, -2.1299602868027208),
                                    LatLng(0.6516632883200013, -2.130879969983952)])

@test Lib.H3_INIT == 0x00001fffffffffff
@test Lib.H3_MODE_OFFSET == 59
@test Lib.H3_MODE_MASK == 0x7800000000000000

using H3.API

bc = Lib.H3_INIT
@test API.getResolution(bc) == 0
@test API.getBaseCellNumber(bc) == 0

refh = Ref{H3Index}()
Lib.setH3Index(refh, 5, 12, Lib.Direction(1))
@test refh[] == 0x085184927fffffff
@test API.getResolution(refh[]) == 5
@test API.getBaseCellNumber(refh[]) == 12

Lib.setH3Index(refh, 0, 0, Lib.Direction(0))
@test refh[] == 0x08001fffffffffff
@test API.getResolution(refh[]) == 0
@test API.getBaseCellNumber(refh[]) == 0

end # module test_h3_lib_indexing
