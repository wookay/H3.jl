# H3.Lib

!!! note
    descriptions are taken from
    - [https://github.com/uber/h3/tree/master/docs/api](https://github.com/uber/h3/tree/master/docs/api)
    - [https://github.com/uber/h3/blob/master/src/h3lib/include/h3api.h.in](https://github.com/uber/h3/blob/master/src/h3lib/include/h3api.h.in)

# Types
```@docs
Lib.H3Index
Lib.GeoCoord
Lib.CoordIJ
Lib.Vec2d
Lib.Vec3d
Lib.CoordIJK
Lib.FaceIJK
Lib.VertexNode
Lib.VertexGraph
Lib.Direction
```

# H3Index functions
```@docs
Lib.setH3Index
Lib.h3GetIndexDigit
Lib.h3GetMode
Lib.h3SetMode
```

# Region functions
```@docs
Lib.polyfill
Lib.maxPolyfillSize
Lib.h3SetToLinkedGeo
Lib.destroyLinkedPolygon
```

# Vertex Graph
```@docs
Lib.initVertexGraph
Lib.destroyVertexGraph
```
