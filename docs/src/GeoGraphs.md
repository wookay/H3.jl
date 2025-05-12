# `H3.GeoGraphs`
`GeoGraphs` adds "graph" functionality where the need naturally arises.
The `Graphs.jl` and `MetaGraphs.jl` packages are used. This functionality
does not exist (at time of development) in the source H3 library.
Instead, the graphs functionality is implemented as a set of Julia-native
functions to generate graphs relating H3 elements.

## "Vertexes" and "Nodes" Terminology
The term "vertex" is used both in the context of H3 cell vertexes
and in graph vertexes. The term "node" will be used to represent
a graph vertex, allowing "vertex" to represent H3 cell vertexes.

## Cell-to-Vertex Graph
Cell boundaries are defined by five or six vertices. Each vertex is
shared by three cells, presenting a natural need for a graph
representation of the cell-to-vertex relationship.

### Graph Generation
`get_cell_to_vertex_graph()` can be used to construct a
cell-to-vertex graph, as shown in the example below.

```
julia> using H3.API, H3.GeoGraphs

julia> using Graphs, MetaGraphs

julia> res0cells = getRes0Cells()
122-element Vector{UInt64}:
 0x08001fffffffffff
 0x08003fffffffffff
 0x08005fffffffffff
                  ⋮
 0x080effffffffffff
 0x080f1fffffffffff
 0x080f3fffffffffff

julia>  r0_cell_to_vertex = get_cell_to_vertex_graph(res0cells)
{363, 842} directed UInt64 metagraph with Float64 weights defined by :weight (default weight 1.0)
```

### Graph, Cell, and Vertex Properties

Once the cell-to-vertex graph is generated, as above, properties of
nodes and edges can be inspected using the `MetaGraphs.props()`
function.

#### Root Node

```
julia> props(r0_cell_to_vertex)
Dict{Symbol, Any} with 2 entries:
  :graph_function => "cell-to-vertex tree"
  :resolution     => 0
```

#### Root-to-Cell Edge

```
julia> props(r0_cell_to_vertex,Edge(1=>2))
Dict{Symbol, Any} with 1 entry:
  :cell_index => 0x08001fffffffffff

```

#### Cell Node

```
julia> props(r0_cell_to_vertex,2)
Dict{Symbol, Any} with 3 entries:
  :h3_index      => 0x08001fffffffffff
  :lat_lng       => LatLng(1.38304, 0.663634)
  :node_function => "cell"
```

#### Cell-to-Vertex Edge

```
julia> props(r0_cell_to_vertex,Edge(2=>124))
Dict{Symbol, Any} with 3 entries:
  :vertex_index  => 0x20001fffffffffff
  :edge_function => "cell-to-vertex"
  :cell_index    => 0x08001fffffffffff
```

#### Vertex Node

```
julia> props(r0_cell_to_vertex,124)
Dict{Symbol, Any} with 3 entries:
  :h3_index      => 0x20001fffffffffff
  :lat_lng       => LatLng(1.20305, 0.555561)
  :node_function => "vertex"
```

### Adding Properties
Additional user-defined properties can be added with the 
`MetaGraphs.set_prop!()` function.

```
julia> set_prop!(r0_cell_to_vertex,2,:cell_area_km2,cellAreaKm2(0x08001fffffffffff))
true

julia> props(r0_cell_to_vertex,2)[:cell_area_km2]
4.1061663344639232e6
```
