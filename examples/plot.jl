using H3.API # GeoCoord geoToH3 kRing h3ToGeoBoundary

base = geoToH3(GeoCoord(deg2rad(0), deg2rad(0)), 5)
rings = kRing(base, 1)

x = Vector{Float64}()
y = Vector{Float64}()
for boundary in h3ToGeoBoundary.(rings), geo in boundary
    push!(x, geo.lon) # 經度
    push!(y, geo.lat) # 緯度
end

using UnicodePlots # scatterplot
@info :plot scatterplot(x, y)
