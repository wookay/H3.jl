using H3.API # LatLng latLngToCell gridDisk cellToBoundary

base = latLngToCell(LatLng(deg2rad(0), deg2rad(0)), 5)
rings = gridDisk(base, 1)

x = Vector{Float64}()
y = Vector{Float64}()
for boundary in cellToBoundary.(rings), geo in boundary
    push!(x, geo.lng) # 經度
    push!(y, geo.lat) # 緯度
end

using UnicodePlots # scatterplot
@info :plot scatterplot(x, y)
