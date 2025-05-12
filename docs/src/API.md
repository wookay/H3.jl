# H3.API

!!! note
    descriptions are taken from
    - [https://h3geo.org/docs/](https://h3geo.org/docs/)
    - [https://github.com/uber/h3/blob/master/src/h3lib/include/h3api.h.in](https://github.com/uber/h3/blob/master/src/h3lib/include/h3api.h.in)

# Error handling
```@docs
H3ErrorCode
describeH3Error
```

# Indexing functions
```@docs
latLngToCell
cellToLatLng
cellToBoundary
```

# Index inspection functions
```@docs
getResolution
getBaseCellNumber
stringToH3
h3ToString
isValidCell
isResClassIII
isPentagon
```

# Grid traversal functions
```@docs
gridDisk
maxGridDiskSize
gridDiskDistances
gridDiskUnsafe
gridDiskDistancesUnsafe
gridDisksUnsafe
gridRingUnsafe
gridPathCells
gridPathCellsSize
gridDistance
cellToLocalIj
localIjToCell
```

# Hierarchical grid functions
```@docs
cellToParent
cellToChildren
cellToChildrenSize
compactCells
uncompactCells
uncompactCellsSize
```

# Unidirectional edge functions
```@docs
areNeighborCells
cellsToDirectedEdge
isValidDirectedEdge
getDirectedEdgeOrigin
getDirectedEdgeDestination
directedEdgeToCells
originToDirectedEdges
directedEdgeToBoundary
```

# Vertex functions
```@docs
getNumVertexes
cellToVertex
cellToVertexes
vertexToLatLng
isValidVertex
```

# Miscellaneous H3 functions
```@docs
cellAreaRads2
cellAreaKm2
cellAreaM2
edgeLengthRads
edgeLengthKm
edgeLengthM
getNumCells
getRes0Cells
res0CellCount
```

# Coordinate Systems
```@docs
ijToIjk
ijkToHex2d
ijkToIj
ijkDistance
ijkNormalize
cellToLocalIjk
h3ToFaceIjk
localIjkToCell
faceIjkToH3
hex2dToCoordIJK
geoToVec3d
geoToFaceIjk
```
