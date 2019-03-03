# H3.jl ⬡

H3.jl provides a Julia version of H3, Hexagonal hierarchical geospatial indexing system. https://github.com/uber/h3

```julia
using H3.API

base = geoToH3(GeoCoord(0, 0), 5)
rings = kRing(base, 1)

x = Vector{Float64}()
y = Vector{Float64}()
for boundary in h3ToGeoBoundary.(rings), geo in boundary
    push!(x, geo.lon)
    push!(y, geo.lat)
end

using UnicodePlots
@info :plot scatterplot(x, y)
```
![plot.png](https://wookay.github.io/docs/H3.jl/assets/h3/plot.png)
