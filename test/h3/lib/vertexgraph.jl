module test_h3_lib_vertexgraph

using Test
using H3.Lib
using .Lib: VertexGraph

refgraph = Ref(VertexGraph(C_NULL, 0, 0, 0))
Lib.initVertexGraph(refgraph, 10, 9)
@test refgraph[].numBuckets == 10
@test refgraph[].size == 0
@test refgraph[].res == 9
Lib.destroyVertexGraph(refgraph)

end # module test_h3_lib_vertexgraph
