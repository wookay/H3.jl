# H3.jl ⬡

|  **Documentation**                        |  **Build Status**                                                  |
|:-----------------------------------------:|:------------------------------------------------------------------:|
|  [![][docs-latest-img]][docs-latest-url]  |  [![][actions-img]][actions-url]  [![][codecov-img]][codecov-url]  |

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
<img src="https://wookay.github.io/docs/H3.jl/assets/h3/plot.png" width="300px" alt="plot.png" />


[docs-latest-img]: https://img.shields.io/badge/docs-latest-blue.svg
[docs-latest-url]: https://wookay.github.io/docs/H3.jl/

[actions-img]: https://github.com/wookay/H3.jl/workflows/CI/badge.svg
[actions-url]: https://github.com/wookay/H3.jl/actions

[codecov-img]: https://codecov.io/gh/wookay/H3.jl/branch/master/graph/badge.svg
[codecov-url]: https://codecov.io/gh/wookay/H3.jl/branch/master
