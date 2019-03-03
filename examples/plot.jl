using H3.API # GeoCoord geoToH3 kRing h3ToGeoBoundary
using UnicodePlots # scatterplot

base = geoToH3(GeoCoord(0, 0), 5)
rings = kRing(base, 1)

x = Float64[]
y = Float64[]
for boundary in h3ToGeoBoundary.(rings), geo in boundary
    push!(x, geo.lon) # 經度
    push!(y, geo.lat) # 緯度
end
@info :plot scatterplot(x, y)
