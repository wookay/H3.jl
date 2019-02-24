# H3.API

!!! note
    most of the documents take from
    - [https://github.com/uber/h3/tree/master/docs/api](https://github.com/uber/h3/tree/master/docs/api)
    - [https://github.com/uber/h3/blob/master/src/h3lib/include/h3api.h.in](https://github.com/uber/h3/blob/master/src/h3lib/include/h3api.h.in)

### Types
```@docs
H3Index
GeoCoord
GeoBoundary
CoordIJ
```

### Indexing functions
```@docs
geoToH3
h3ToGeo
h3ToGeoBoundary
```

### Index inspection functions
```@docs
h3GetResolution
h3GetBaseCell
stringToH3
h3ToString
h3IsValid
h3IsResClassIII
h3IsPentagon
```

### Grid traversal functions
```@docs
kRing
maxKringSize
kRingDistances
hexRange
hexRangeDistances
hexRanges
hexRing
h3Line
h3LineSize
h3Distance
experimentalH3ToLocalIj
experimentalLocalIjToH3
```
