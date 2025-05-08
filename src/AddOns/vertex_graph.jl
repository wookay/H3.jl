export check_for_common_resolution
export generate_vertex_graph

using ..H3.API

using Graphs, MetaGraphs

"""
Trivial function to check that all indexes have a common resolution.

Returns `true` or `false`.

"""
function check_for_common_resolution(h3_indexes::Vector{H3Index})::Bool
    resolutions = getResolution.(h3_indexes)
    unique_resolutions = unique(resolutions)
    num_unique_resolutions = length(unique_resolutions)
    if num_unique_resolutions == 1
        result = true
    else
        result = false
    end
    return result
end

"""
Generates and returns a graph with two level hierarchy of
Edges.

1. Trivial root node, pointing to all cell indexes.
2. M-to-N mapping from cell indexes to vertex indexes.

"""
function generate_vertex_graph(cell_indexes::Vector{H3Index};
                               generate_centroid_latlng::Bool=true,
                               generate_vertex_latlng::Bool=true)::MetaDiGraph

    # This function is intended to work on a set of `h3_indexes`
    # with the same resolution.
    @assert check_for_common_resolution(cell_indexes) == true
    resolution = getResolution(cell_indexes[1])

    # Gather vertex H3 indexes for each cell, one vector per cell.
    # This may contain duplicate vertex indexes across cells.
    all_cell_vertexes = cellToVertexes.(cell_indexes)

    # Get unique vertexes.
    all_vertexes = vcat(all_cell_vertexes...)
    unique_vertexes = unique(all_vertexes)

    # Start graph.
    vertex_graph = SimpleDiGraph()
    mvg = MetaDiGraph(vertex_graph)
    set_prop!(mvg,:graph_function,"cell-to-vertex tree")
    set_prop!(mvg,:resolution,resolution)

    # Add root node to graph.
    add_vertex!(mvg)
    root_node_num = nv(mvg)
    set_prop!(mvg,root_node_num,:node_function,"root")
    @assert root_node_num == 1

    # Add cell indexes to graph.
    first_cell_node_num = root_node_num + 1
    @assert first_cell_node_num == 2
    for i_cell in 1:length(cell_indexes)

        # Add cell vertex.
        add_vertex!(mvg)
        cell_node_num = nv(mvg)
        set_prop!(mvg,cell_node_num,:node_function,"cell")
        set_prop!(mvg,cell_node_num,:h3_index,cell_indexes[i_cell])

        # Add root-to-cell edge.
        add_edge!(mvg,Edge(root_node_num => cell_node_num))
        set_prop!(mvg,Edge(root_node_num => cell_node_num),:cell_index,cell_indexes[i_cell])

        # Generate cell centroid lat-lon.
        if generate_centroid_latlng == true
            centroid_latlng = cellToLatLng(cell_indexes[i_cell])
            set_prop!(mvg,cell_node_num,:lat_lng,centroid_latlng)
        end

    end
    last_cell_node_num = first_cell_node_num + length(cell_indexes) - 1

    # Add vertex indexes to graph.
    first_vertex_node_num = last_cell_node_num + 1
    @assert first_vertex_node_num == (1 + length(cell_indexes) + 1)
    for i_vertex in 1:length(unique_vertexes)
        add_vertex!(mvg)
        vertex_node_num = nv(mvg)
        set_prop!(mvg,vertex_node_num,:node_function,"vertex")
        set_prop!(mvg,vertex_node_num,:h3_index,unique_vertexes[i_vertex])

        # Generate vertex LatLng
        if generate_vertex_latlng == true
            vertex_latlng = vertexToLatLng(unique_vertexes[i_vertex])
            set_prop!(mvg,vertex_node_num,:lat_lng,vertex_latlng)
        end
    end
    last_vertex_node_num = first_vertex_node_num + length(unique_vertexes) - 1

    # Add cell-to-vertex edges.
    for i_cell in 1:length(cell_indexes)
        cell_node_num = first_cell_node_num + i_cell - 1
        cell_vertexes = all_cell_vertexes[i_cell]
        cell_vertex_unique_indexes = findall(x -> x ∈ cell_vertexes, unique_vertexes)
        for i_cell_vertex in 1:length(cell_vertex_unique_indexes)
            vertex_node_num = first_vertex_node_num + i_cell_vertex - 1
            add_edge!(mvg,Edge(cell_node_num => vertex_node_num))
            set_prop!(mvg,Edge(cell_node_num => vertex_node_num),:edge_function,"cell-to-vertex")
            set_prop!(mvg,Edge(cell_node_num => vertex_node_num),:cell_index,cell_indexes[i_cell])
            set_prop!(mvg,Edge(cell_node_num => vertex_node_num),:vertex_index,unique_vertexes[i_cell_vertex])
        end
    end

    return mvg

end
