# H3.jl ⬡

<https://github.com/wookay/H3.jl>

`H3.jl` provides a Julia version of H3, Hexagonal hierarchical geospatial indexing system. https://github.com/uber/h3

```julia
using H3.API

base = latLngToCell(LatLng(deg2rad(0), deg2rad(0)), 5)
rings = gridDisk(base, 1)

x = Vector{Float64}()
y = Vector{Float64}()
for boundary in cellToBoundary.(rings), geo in boundary
    push!(x, geo.lng)
    push!(y, geo.lat)
end

using UnicodePlots
@info :plot scatterplot(x, y)
```
![plot.png](https://wookay.github.io/docs/H3.jl/assets/h3/plot.png)
