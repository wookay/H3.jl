module test_h3_api_indexing

using Test
using H3.API # latLngToCell cellToLatLng cellToBoundary LatLng GeoBoundary ≈

h = 0x85283473fffffff
@test getResolution(h) == 5

location = LatLng(0.6518070561696664, -2.128889370371519)
@test latLngToCell(location, 1) == 0x081283ffffffffff
@test latLngToCell(location, 5) == h
@test latLngToCell(location, 10) == 0x08a2834700007fff
@test cellToLatLng(h) ≈ location

verts = cellToBoundary(0x85283473fffffff)
@test length(verts) == 6
@test verts ≈ [LatLng(0.6505078765569766, -2.1278195595404963),
               LatLng(0.6519490051151717, -2.126897030193998),
               LatLng(0.6532477872571462, -2.1279673831553825),
               LatLng(0.6531044519454293, -2.1299602868027208),
               LatLng(0.6516632883200013, -2.130879969983952),
               LatLng(0.6503654944795706, -2.129809601095088)]

# https://github.com/uber/h3/blob/master/examples/index.c
location = LatLng(deg2rad(40.689167), deg2rad(-74.044444))
indexed = latLngToCell(location, 10)
verts = cellToBoundary(indexed)
@test map(vert -> rad2deg.((vert.lat, vert.lng)), verts) ≈ [(40.69005860095358, -74.04415176176158),
                                                               (40.68990769452519, -74.0450617923963),
                                                               (40.68927093604355, -74.04534141750702),
                                                               (40.68878509072403, -74.04471103053613),
                                                               (40.688935992642726, -74.04380102076254),
                                                               (40.689572744390524, -74.04352137709904)]
center = cellToLatLng(indexed)
@test rad2deg(center.lat) ≈ 40.68942184369929
@test rad2deg(center.lng) ≈ -74.04443139990863

@test latLngToCell(LatLng(0, 0), 0) == 0x08075fffffffffff
@test latLngToCell(LatLng(0, 0), 5) == 0x085754e67fffffff

# https://github.com/wookay/H3.jl/issues/2
@testset "Compact issue" begin
    hids = Array{UInt64, 1}()

    tmp_h3index_path = normpath(@__DIR__, "tmp.h3index")
    @test isfile(tmp_h3index_path)
    open(tmp_h3index_path, "r") do fp
        while !eof(fp)
            push!(hids, read(fp, H3Index))
        end
    end
    l = length([h for h in compactCells(hids) if isValidCell(h)])
    @test all(1:1000) do i
        length([h for h in compactCells(hids) if isValidCell(h)]) == l
    end
end

end # module test_h3_api_indexing
