# H3.jl ⬡

|  **Documentation**                        |  **Build Status**                                                |
|:-----------------------------------------:|:----------------------------------------------------------------:|
|  [![][docs-latest-img]][docs-latest-url]  |  [![][travis-img]][travis-url]  [![][codecov-img]][codecov-url]  |

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
<img src="https://wookay.github.io/docs/H3.jl/assets/h3/plot.png" width="300px" alt="plot.png" />


[docs-latest-img]: https://img.shields.io/badge/docs-latest-blue.svg
[docs-latest-url]: https://wookay.github.io/docs/H3.jl/

[travis-img]: https://api.travis-ci.org/wookay/H3.jl.svg?branch=master
[travis-url]: https://travis-ci.org/wookay/H3.jl

[codecov-img]: https://codecov.io/gh/wookay/H3.jl/branch/master/graph/badge.svg
[codecov-url]: https://codecov.io/gh/wookay/H3.jl/branch/master
