# H3.API

!!! note
    the descriptions are taken from
    - [https://github.com/uber/h3/tree/master/docs/api](https://github.com/uber/h3/tree/master/docs/api)
    - [https://github.com/uber/h3/blob/master/src/h3lib/include/h3api.h.in](https://github.com/uber/h3/blob/master/src/h3lib/include/h3api.h.in)

# Indexing functions
```@docs
geoToH3
h3ToGeo
h3ToGeoBoundary
```

# Index inspection functions
```@docs
h3GetResolution
h3GetBaseCell
stringToH3
h3ToString
h3IsValid
h3IsResClassIII
h3IsPentagon
```

# Grid traversal functions
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

# Hierarchical grid functions
```@docs
h3ToParent
h3ToChildren
maxH3ToChildrenSize
compact
uncompact
maxUncompactSize
```

# Region functions
```@docs
polyfill
maxPolyfillSize
h3SetToLinkedGeo
destroyLinkedPolygon
```

# Unidirectional edge functions
```@docs
h3IndexesAreNeighbors
getH3UnidirectionalEdge
h3UnidirectionalEdgeIsValid
getOriginH3IndexFromUnidirectionalEdge
getDestinationH3IndexFromUnidirectionalEdge
getH3IndexesFromUnidirectionalEdge
getH3UnidirectionalEdgesFromHexagon
getH3UnidirectionalEdgeBoundary
```

# Miscellaneous H3 functions
```@docs
degsToRads
radsToDegs
hexAreaKm2
hexAreaM2
edgeLengthKm
edgeLengthM
numHexagons
getRes0Indexes
res0IndexCount
```

# Coordinate Systems
```@docs
ijToIjk
ijkToHex2d
ijkToIj
ijkDistance
ijkNormalize
h3ToLocalIjk
h3ToFaceIjk
localIjkToH3
faceIjkToH3
hex2dToCoordIJK
geoToVec3d
geoToFaceIjk
```
