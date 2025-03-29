module test_h3_api_misc
using Test
using H3.API 
# Exercise these functions on a random tile
@test cellAreaM2(0x83195dfffffffff) ≈ cellAreaKm2(0x83195dfffffffff) * 1e6

# issue 27
# https://h3geo.org/docs/api/misc#edgelengthkm
@test edgeLengthRads(0x115283473fffffff) == 0.0016158726232538025
@test edgeLengthKm(0x115283473fffffff) == 10.29473608619955
@test edgeLengthM(0x115283473fffffff) == 10294.73608619955

end
