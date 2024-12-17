module test_h3_api_vertexes

using Test
using H3.API

@testset "test_h3_api_vertexes hexagon" begin
    location_hexagon = LatLng(deg2rad( 45.7089),
                              deg2rad(-121.5123))

    location_hexagon_r6 = latLngToCell(location_hexagon,6)
    location_hexagon_vertex_1 = cellToVertex(location_hexagon_r6,1)
    location_hexagon_vertex_6 = cellToVertex(location_hexagon_r6,6)
    location_hexagon_vertexes = cellToVertexes(location_hexagon_r6)
    location_hexagon_vertex_1_lat_lng = vertexToLatLng(location_hexagon_vertex_1)

    @test getNumVertexes(location_hexagon_r6) == 6
    @test isValidVertex(location_hexagon_r6) == false
    @test isValidVertex(location_hexagon_vertex_1) == true
    @test isValidVertex(location_hexagon_vertex_6) == true

    @test location_hexagon_vertexes[1] == location_hexagon_vertex_1
    @test location_hexagon_vertexes[6] == location_hexagon_vertex_6

    @test location_hexagon_vertex_1_lat_lng.lat ≈  0.7969812799981
    @test location_hexagon_vertex_1_lat_lng.lng ≈  -2.120868717657
end # "test_h3_api_vertexes hexagon"

@testset "test_h3_api_vertexes pentagon" begin

    location_pentagon    = H3Index(0x08009fffffffffff)
    location_pentagon_vertex_1 = cellToVertex(location_pentagon,1)
    location_pentagon_vertex_5 = cellToVertex(location_pentagon,5)
    location_pentagon_vertexes = cellToVertexes(location_pentagon)
    location_pentagon_vertex_1_lat_lng = vertexToLatLng(location_pentagon_vertex_1)

    @test getNumVertexes(location_pentagon) == 5
    @test isValidVertex(location_pentagon) == false
    @test isValidVertex(location_pentagon_vertex_1) == true
    @test isValidVertex(location_pentagon_vertex_5) == true

    @test location_pentagon_vertexes[1] == location_pentagon_vertex_1
    @test location_pentagon_vertexes[5] == location_pentagon_vertex_5

    @test location_pentagon_vertex_1_lat_lng.lat ≈  1.101216435376
    @test location_pentagon_vertex_1_lat_lng.lng ≈  -0.1822992484532553
end # "test_h3_api_vertexes pentagon"

end # module test_h3_api_vertexes
