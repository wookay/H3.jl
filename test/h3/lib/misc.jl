module test_h3_lib_miscellaneous

using Test
using H3.Lib

Lib.degsToRads
Lib.radsToDegs
Lib.getHexagonAreaAvgKm2
Lib.getHexagonAreaAvgM2
Lib.getHexagonEdgeLengthAvgKm
Lib.getHexagonEdgeLengthAvgM
Lib.getNumCells
Lib.getRes0Cells
Lib.res0CellCount

res = 0
out = Ref{Cdouble}()
Lib.getHexagonEdgeLengthAvgKm(res, out)
#           == 1107.712591   # h3 4.1.0 (Jan 19, 2023)
@test out[] == 1281.256011   # h3 4.2.0
# Update average edge lengths (Mar 24, 2023)
# https://github.com/uber/h3/commit/71e09dc002b211887c6db525609a449058233a71

# https://github.com/uber/h3/blob/master/src/h3lib/lib/latLng.c#L311
# https://h3geo.org/docs/core-library/restable/#edge-lengths

end # module test_h3_lib_miscellaneous
