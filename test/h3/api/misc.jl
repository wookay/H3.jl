module test_h3_api_misc
using Test
using H3.API 
# Exercise these functions on a random tile
@test cellAreaM2(0x83195dfffffffff) ≈ cellAreaKm2(0x83195dfffffffff) * 1e6
end