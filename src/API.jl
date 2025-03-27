module API # module H3

# errors
export H3ErrorCode, describeH3Error

# types
export H3Index, LatLng, CoordIJ, Vec2d, Vec3d, CoordIJK, FaceIJK

# Indexing functions
export latLngToCell, cellToLatLng, cellToBoundary

# Index inspection functions
export getResolution, getBaseCellNumber, stringToH3, h3ToString, isValidCell, isResClassIII, isPentagon

# Grid traversal functions
export gridDisk, maxGridDiskSize, gridDiskDistances, gridDiskUnsafe, gridDiskDistancesUnsafe, gridDisksUnsafe, gridRingUnsafe, gridPathCells, gridPathCellsSize, gridDistance, cellToLocalIj, localIjToCell

# Hierarchical grid functions
export cellToParent, cellToChildren, cellToChildrenSize, compactCells, uncompactCells, uncompactCellsSize

# Unidirectional edge functions
export areNeighborCells, cellsToDirectedEdge, isValidDirectedEdge, getDirectedEdgeOrigin, getDirectedEdgeDestination, directedEdgeToCells, originToDirectedEdges, directedEdgeToBoundary

# Miscellaneous H3 functions
export hexAreaKm2, hexAreaM2, cellAreaRads2, cellAreaKm2, cellAreaM2, edgeLengthKm, edgeLengthM, getNumCells, getRes0Cells, res0CellCount

# Coordinate Systems
export ijToIjk, ijkToHex2d, ijkToIj, ijkDistance, ijkNormalize, cellToLocalIjk, h3ToFaceIjk, localIjkToCell, faceIjkToH3, hex2dToCoordIJK, geoToVec3d, geoToFaceIjk


using ..Lib
using .Lib: H3Index, LatLng, CellBoundary, CoordIJ
using .Lib: Vec2d, Vec3d, CoordIJK, FaceIJK
using .Lib: H3_NULL
using .Lib: H3Error

###
#
# * descriptions are taken from
#   - https://github.com/uber/h3/tree/master/docs/api
#   - https://github.com/uber/h3/blob/master/src/h3lib/include/h3api.h.in
#   - https://h3geo.org/docs/library/errors/
###

# Error handling
"""
    struct H3ErrorCode
        value::H3Error
    end

The type returned by most H3 functions is `H3Error`,
a 32 bit integer type with the following properties:

- `H3Error` will be an integer type of 32 bits, i.e. `uint32_t`.
- `H3Error` with value 0 indicates success (no error).
- No `H3Error` value will set the most significant bit.
- As a result of these properties, no `H3Error` value will set the bits that correspond with the Mode bit field in an `H3Index`.

Table of error codes
<https://h3geo.org/docs/library/errors/#table-of-error-codes>
"""
struct H3ErrorCode
    value::H3Error
end

"""
    describeH3Error(err::H3Error)::String
    describeH3Error(code::H3ErrorCode)::String
    describeH3Error(enum::Lib.H3ErrorCodes)::String

converts the provided H3Error value into a description string
"""
describeH3Error

function describeH3Error(err::H3Error)::String
    unsafe_string(Lib.describeH3Error(err))
end

function describeH3Error(code::H3ErrorCode)::String
    describeH3Error(code.value)
end

function describeH3Error(enum::Lib.H3ErrorCodes)::String
    describeH3Error(H3Error(enum))
end

function _check_h3error(ret::H3Error, x::T)::Union{H3ErrorCode, T} where T
    if Lib.E_SUCCESS == ret
        x
    else
        H3ErrorCode(ret)
    end
end


# Indexing functions

"""
    latLngToCell(g::LatLng, res::Int)::Union{H3ErrorCode, H3Index}

find the H3 index of the resolution res cell containing the lat/lng
"""
function latLngToCell(g::LatLng, res::Int)::Union{H3ErrorCode, H3Index}
    refout = Ref{H3Index}()
    ret::H3Error = Lib.latLngToCell(Ref(g), res, refout)
    _check_h3error(ret, refout[])
end

"""
    cellToLatLng(h::H3Index)::Union{H3ErrorCode, LatLng}

find the lat/lng center point g of the cell h3
"""
function cellToLatLng(h::H3Index)::Union{H3ErrorCode, LatLng}
    refcenter = Ref{LatLng}()
    ret::H3Error = Lib.cellToLatLng(h, refcenter)
    _check_h3error(ret, refcenter[])
end

"""
    cellToBoundary(h::H3Index)::Union{H3ErrorCode, Vector{LatLng}}

Determines the cell boundary in spherical coordinates for an H3 index.

@param h3 The H3 index.
@param cb The boundary of the H3 cell in spherical coordinates.
"""
function cellToBoundary(h::H3Index)::Union{H3ErrorCode, Vector{LatLng}}
    refboundary = Ref{CellBoundary}()
    ret::H3Error = Lib.cellToBoundary(h, refboundary)
    _check_h3error(ret, begin
        numVerts = refboundary[].numVerts
        verts = refboundary[].verts[1:numVerts]
        collect(verts)
    end)
end


# Index inspection functions

"""
    getResolution(h::H3Index)::Cint

returns the resolution of the provided H3 index
Works on both cells and directed edges.
"""
function getResolution(h::H3Index)::Cint
    Lib.getResolution(h)::Cint
end

"""
    getBaseCellNumber(h::H3Index)::Cint

returns the base cell "number" (0 to 121) of the provided H3 cell

Note: Technically works on H3 edges, but will return base cell of the
origin cell.
"""
function getBaseCellNumber(h::H3Index)::Cint
    Lib.getBaseCellNumber(h)::Cint
end

"""
    stringToH3(str::String)::Union{H3ErrorCode, H3Index}

Converts the string representation to H3Index (UInt64) representation.
"""
function stringToH3(str::String)::Union{H3ErrorCode, H3Index}
    refh = Ref{H3Index}()
    ret::H3Error = Lib.stringToH3(str, refh)
    _check_h3error(ret, refh[])
end

"""
    h3ToString(h::H3Index)::String

Converts the H3Index representation of the index to the string representation.
"""
function h3ToString(h::H3Index)::String
    string(h, base=16)
end

"""
    isValidCell(h::H3Index)::Bool

confirms if an H3Index is a valid cell (hexagon or pentagon)
In particular, returns 0 (False) for H3 directed edges or invalid data
"""
function isValidCell(h::H3Index)::Bool
    Bool(Lib.isValidCell(h))
end

"""
    isResClassIII(h::H3Index)::Bool

determines if a hexagon is Class III (or Class II)
"""
function isResClassIII(h::H3Index)::Bool
    Bool(Lib.isResClassIII(h))
end

"""
    isPentagon(h::H3Index)::Bool

determines if an H3 cell is a pentagon
"""
function isPentagon(h::H3Index)::Bool
    Bool(Lib.isPentagon(h))
end


# Grid traversal functions

"""
    gridDisk(origin::H3Index, k::Int)::Union{H3ErrorCode, Vector{H3Index}}

Produce cells within grid distance k of the origin cell.

k-ring 0 is defined as the origin cell, k-ring 1 is defined as k-ring 0 and
all neighboring cells, and so on.

Output is placed in the provided array in no particular order. Elements of
the output array may be left zero, as can happen when crossing a pentagon.

@param  origin   origin cell
@param  k        k >= 0
@param  out      zero-filled array which must be of size maxGridDiskSize(k)
"""
function gridDisk(origin::H3Index, k::Int)::Union{H3ErrorCode, Vector{H3Index}}
    array_len = maxGridDiskSize(k)
    krings = Vector{H3Index}(undef, array_len)
    ret::H3Error = Lib.gridDisk(origin, k, krings)
    _check_h3error(ret, krings)
end



"""
    maxGridDiskSize(k::Int)::Union{H3ErrorCode, Int64}

Maximum number of cells that result from the gridDisk algorithm with the
given k. Formula source and proof: https://oeis.org/A003215

@param   k   k value, k >= 0.
@param out   size in indexes
"""
function maxGridDiskSize(k::Int)::Union{H3ErrorCode, Int64}
    out = Ref{Int64}() 
    ret::H3Error = Lib.maxGridDiskSize(k, out)
    _check_h3error(ret, out[])
end

"""
    gridDiskDistances(origin::H3Index, k::Int)::Union{H3ErrorCode, NamedTuple{(:out, :distances)}}

k-rings produces indices within `k` distance of the origin index.
"""
function gridDiskDistances(origin::H3Index, k::Int)::Union{H3ErrorCode, NamedTuple{(:out, :distances)}}
    array_len = maxGridDiskSize(k)
    out = Vector{H3Index}(undef, array_len)
    distances = Vector{Cint}(undef, array_len)
    ret::H3Error = Lib.gridDiskDistances(origin, k, out, distances)
    _check_h3error(ret, (out = out, distances = distances))
end

"""
    gridDiskUnsafe(origin::H3Index, k::Int)::Union{H3ErrorCode, Vector{H3Index}}

gridDiskUnsafe produces indexes within k distance of the origin index.
Output behavior is undefined when one of the indexes returned by this
function is a pentagon or is in the pentagon distortion area.

k-ring 0 is defined as the origin index, k-ring 1 is defined as k-ring 0 and
all neighboring indexes, and so on.

Output is placed in the provided array in order of increasing distance from
the origin.

@param origin Origin location.
@param k k >= 0
@param out Array which must be of size maxGridDiskSize(k).
@return 0 if no pentagon or pentagonal distortion area was encountered.
"""
function gridDiskUnsafe(origin::H3Index, k::Int)::Union{H3ErrorCode, Vector{H3Index}}
    array_len = maxGridDiskSize(k)
    out = Vector{H3Index}(undef, array_len)
    ret::H3Error = Lib.gridDiskUnsafe(origin, k, out)
    _check_h3error(ret, out)
end

"""
    gridDiskDistancesUnsafe(origin::H3Index, k::Int)::Union{H3ErrorCode, NamedTuple{(:out, :distances)}}

`hexRange` produces indexes within `k` distance of the origin index.
"""
function gridDiskDistancesUnsafe(origin::H3Index, k::Int)::Union{H3ErrorCode, NamedTuple{(:out, :distances)}}
    array_len = maxGridDiskSize(k)
    out = Vector{H3Index}(undef, array_len)
    distances = Vector{Cint}(undef, array_len)
    ret::H3Error = Lib.gridDiskDistancesUnsafe(origin, k, out, distances)
    _check_h3error(ret, (out = out, distances = distances))
end

"""
    gridDisksUnsafe(h3Set::Vector{H3Index}, k::Int)::Union{H3ErrorCode, Vector{H3Index}}

gridDisksUnsafe takes an array of input hex IDs and a max k-ring and returns
an array of hexagon IDs sorted first by the original hex IDs and then by the
k-ring (0 to max), with no guaranteed sorting within each k-ring group.

@param h3Set A pointer to an array of H3Indexes
@param length The total number of H3Indexes in h3Set
@param k The number of rings to generate
@param out A pointer to the output memory to dump the new set of H3Indexes to
           The memory block should be equal to maxGridDiskSize(k) * length
@return 0 if no pentagon is encountered. Cannot trust output otherwise
"""
function gridDisksUnsafe(h3Set::Vector{H3Index}, k::Int)::Union{H3ErrorCode, Vector{H3Index}}
    array_len = maxGridDiskSize(k)
    out = Vector{H3Index}(undef, array_len)
    ret::H3Error = Lib.gridDisksUnsafe(h3Set, length(h3Set), k, out)
    _check_h3error(ret, out)
end

"""
    gridRingUnsafe(origin::H3Index, k::Int)::Vector{H3Index}


Returns the "hollow" ring of hexagons at exactly grid distance k from
the origin hexagon. In particular, k=0 returns just the origin hexagon.

A nonzero failure code may be returned in some cases, for example,
if a pentagon is encountered.
Failure cases may be fixed in future versions.

@param origin Origin location.
@param k k >= 0
@param out Array which must be of size 6 * k (or 1 if k == 0)
@return 0 if successful; nonzero otherwise.
"""
function gridRingUnsafe(origin::H3Index, k::Int)::Union{H3ErrorCode, Vector{H3Index}}
    out = Vector{H3Index}(undef, 6k)
    ret::H3Error = Lib.gridRingUnsafe(origin, k, out)
    _check_h3error(ret, out)
end

"""
    gridPathCells(origin::H3Index, destination::H3Index)::Union{H3ErrorCode, Vector{H3Index}}

Given two H3 indexes, return the line of indexes between them (inclusive).

This function may fail to find the line between two indexes, for
example if they are very far apart. It may also fail when finding
distances for indexes on opposite sides of a pentagon.

Notes:

 - The specific output of this function should not be considered stable
   across library versions. The only guarantees the library provides are
   that the line length will be `gridDistance(start, end) + 1` and that
   every index in the line will be a neighbor of the preceding index.
 - Lines are drawn in grid space, and may not correspond exactly to either
   Cartesian lines or great arcs.

@param start Start index of the line
@param end End index of the line
@param out Output array, which must be of size gridPathCellsSize(start, end)
@return 0 on success, or another value on failure.
"""
function gridPathCells(origin::H3Index, destination::H3Index)::Union{H3ErrorCode, Vector{H3Index}}
    line_size = gridPathCellsSize(origin, destination)
    out = Vector{H3Index}(undef, line_size)
    ret::H3Error = Lib.gridPathCells(origin, destination, out)
    _check_h3error(ret, out)
end

"""
    gridPathCellsSize(origin::H3Index, destination::H3Index)::Union{H3ErrorCode, Int64}

Number of indexes in a line from the start index to the end index,
to be used for allocating memory. Returns a negative number if the
line cannot be computed.

@param start Start index of the line
@param end End index of the line
@param size Size of the line
@returns 0 on success, or another value on error
"""
function gridPathCellsSize(origin::H3Index, destination::H3Index)::Union{H3ErrorCode, Int64}
    refout = Ref{Int64}()
    ret::H3Error = Lib.gridPathCellsSize(origin, destination, refout)
    _check_h3error(ret, refout[])
end

"""
    gridDistance(origin::H3Index, h::H3Index)::Union{H3ErrorCode, Int64}

Produces the grid distance between the two indexes.

This function may fail to find the distance between two indexes, for
example if they are very far apart. It may also fail when finding
distances for indexes on opposite sides of a pentagon.

@param origin Index to find the distance from.
@param index Index to find the distance to.
@return The distance, or a H3ErrorCode if the library could not compute the distance.
"""
function gridDistance(origin::H3Index, h::H3Index)::Union{H3ErrorCode, Int64}
    refout = Ref{Int64}()
    ret::H3Error = Lib.gridDistance(origin, h, refout)
    _check_h3error(ret, refout[])
end

"""
    cellToLocalIj(origin::H3Index, h::H3Index)::Union{H3ErrorCode, CoordIJ}

Produces ij coordinates for an index anchored by an origin.

The coordinate space used by this function may have deleted
regions or warping due to pentagonal distortion.

Coordinates are only comparable if they come from the same
origin index.

Failure may occur if the index is too far away from the origin
or if the index is on the other side of a pentagon.

This function's output is not guaranteed
to be compatible across different versions of H3.

@param origin An anchoring index for the ij coordinate system.
@param index Index to find the coordinates of
@param mode Mode, must be 0
@param out ij coordinates of the index will be placed here on success
@return 0 on success, or another value on failure.
"""
function cellToLocalIj(origin::H3Index, h::H3Index)::Union{H3ErrorCode, CoordIJ}
    mode = UInt32(0)
    refij = Ref{CoordIJ}()
    ret::H3Error = Lib.cellToLocalIj(origin, h, mode, refij)
    _check_h3error(ret, refij[])
end

"""
    localIjToCell(origin::H3Index, ij::CoordIJ)::Union{H3ErrorCode, H3Index}

Produces an index for ij coordinates anchored by an origin.

The coordinate space used by this function may have deleted
regions or warping due to pentagonal distortion.

Failure may occur if the index is too far away from the origin
or if the index is on the other side of a pentagon.

This function's output is not guaranteed
to be compatible across different versions of H3.

@param origin An anchoring index for the ij coordinate system.
@param out ij coordinates to index.
@param mode Mode, must be 0
@param index Index will be placed here on success.
@return 0 on success, or another value on failure.
"""
function localIjToCell(origin::H3Index, ij::CoordIJ)::Union{H3ErrorCode, H3Index}
    mode = UInt32(0)
    refh = Ref{H3Index}()
    ret::H3Error = Lib.localIjToCell(origin, Ref(ij), mode, refh)
    _check_h3error(ret, refh[])
end


# Hierarchical grid functions

"""
    cellToParent(h::H3Index, parentRes::Int)::Union{H3ErrorCode, H3Index}

cellToParent produces the parent index for a given H3 index

@param h H3Index to find parent of
@param parentRes The resolution to switch to (parent, grandparent, etc)

@return H3Index of the parent, or H3_NULL if you actually asked for a child
"""
function cellToParent(h::H3Index, parentRes::Int)::Union{H3ErrorCode, H3Index}
    refh = Ref{H3Index}()
    ret::H3Error = Lib.cellToParent(h, parentRes, refh)
    _check_h3error(ret, refh[])
end

"""
    cellToChildren(h::H3Index, childRes::Int)::Union{H3ErrorCode, Vector{H3Index}}

provides the children (or grandchildren, etc) of the given cell
"""
function cellToChildren(h::H3Index, childRes::Int)::Union{H3ErrorCode, Vector{H3Index}}
    children_size = cellToChildrenSize(h, childRes)
    children = Vector{H3Index}(undef, children_size)
    ret::H3Error = Lib.cellToChildren(h, childRes, children)
    _check_h3error(ret, children)
end

"""
    cellToChildrenSize(h::H3Index, childRes::Int)::Union{H3ErrorCode, Int64}

determines the exact number of children (or grandchildren, etc)
that would be returned for the given cell
"""
function cellToChildrenSize(h::H3Index, childRes::Int)::Union{H3ErrorCode, Int64}
    refout = Ref{Int64}()
    ret::H3Error = Lib.cellToChildrenSize(h, childRes, refout)
    _check_h3error(ret, refout[])
end

"""
    compactCells(h3Set::Vector{H3Index})::Union{H3ErrorCode, Vector{H3Index}}

compacts the given set of hexagons as best as possible
"""
function compactCells(h3Set::Vector{H3Index})::Union{H3ErrorCode, Vector{H3Index}}
    numHexes = length(h3Set)
    compactedSet = fill(H3Index(H3_NULL), numHexes)
    ret::H3Error = Lib.compactCells(h3Set, compactedSet, numHexes)
    _check_h3error(ret, compactedSet)
end

"""
    uncompactCells(compactedSet::Vector{H3Index}, res::Int)::Union{H3ErrorCode, Vector{H3Index}}

uncompacts the compacted hexagon set
"""
function uncompactCells(compactedSet::Vector{H3Index}, res::Int)::Union{H3ErrorCode, Vector{H3Index}}
    numCompacted = length(compactedSet)
    numOut = uncompactCellsSize(compactedSet, res)
    outSet = Vector{H3Index}(undef, numOut)
    ret::H3Error = Lib.uncompactCells(compactedSet, numCompacted, outSet, numOut, res)
    _check_h3error(ret, outSet)
end

"""
    uncompactCellsSize(compactedSet::Vector{H3Index}, res::Int)::Union{H3ErrorCode, Int64}

determines the exact number of hexagons that will be uncompacted
from the compacted set
"""
function uncompactCellsSize(compactedSet::Vector{H3Index}, res::Int)::Union{H3ErrorCode, Int64}
    numCompacted = length(compactedSet)
    refout = Ref{Int64}()
    ret::H3Error = Lib.uncompactCellsSize(compactedSet, numCompacted, Cint(res), refout)
    _check_h3error(ret, refout[])
end


# Unidirectional edge functions

"""
    areNeighborCells(origin::H3Index, destination::H3Index)::Union{H3ErrorCode, Bool}

Returns whether or not the provided H3Indexes are neighbors.
@param origin The origin H3 index.
@param destination The destination H3 index.
@param out Set to 1 if the indexes are neighbors, 0 otherwise
@return Error code if the origin or destination are invalid or incomparable.
"""
function areNeighborCells(origin::H3Index, destination::H3Index)::Union{H3ErrorCode, Bool}
    refout = Ref{Cint}()
    ret::H3Error = Lib.areNeighborCells(origin, destination, refout)
    _check_h3error(ret, Bool(refout[]))
end

"""
    cellsToDirectedEdge(origin::H3Index, destination::H3Index)::Union{H3ErrorCode, H3Index}

Returns a directed edge H3 index based on the provided origin and
destination
@param origin The origin H3 hexagon index
@param destination The destination H3 hexagon index
@return The directed edge H3Index, or H3_NULL on failure.
"""
function cellsToDirectedEdge(origin::H3Index, destination::H3Index)::Union{H3ErrorCode, H3Index}
    refh = Ref{H3Index}()
    ret::H3Error = Lib.cellsToDirectedEdge(origin, destination, refh)
    _check_h3error(ret, refh[])
end

"""
    isValidDirectedEdge(edge::H3Index)::Bool

returns whether the H3Index is a valid directed edge
"""
function isValidDirectedEdge(edge::H3Index)::Bool
    Bool(Lib.isValidDirectedEdge(edge))
end

"""
    getDirectedEdgeOrigin(edge::H3Index)::Union{H3ErrorCode, H3Index}

Returns the origin hexagon from the directed edge H3Index
@param edge The edge H3 index
@return The origin H3 hexagon index, or H3_NULL on failure
"""
function getDirectedEdgeOrigin(edge::H3Index)::Union{H3ErrorCode, H3Index}
    refh = Ref{H3Index}()
    ret::H3Error = Lib.getDirectedEdgeOrigin(edge, refh)
    _check_h3error(ret, refh[])
end

"""
    getDirectedEdgeDestination(edge::H3Index)::Union{H3ErrorCode, H3Index}

Returns the destination hexagon from the directed edge H3Index
@param edge The edge H3 index
@return The destination H3 hexagon index, or H3_NULL on failure
"""
function getDirectedEdgeDestination(edge::H3Index)::Union{H3ErrorCode, H3Index}
    refh = Ref{H3Index}()
    ret::H3Error = Lib.getDirectedEdgeDestination(edge, refh)
    _check_h3error(ret, refh[])
end

"""
    directedEdgeToCells(edge::H3Index)::Union{H3ErrorCode, Tuple{H3Index, H3Index}}

Returns the origin, destination pair of hexagon IDs for the given edge ID
@param edge The directed edge H3Index
@param originDestination Pointer to memory to store origin and destination
IDs
"""
function directedEdgeToCells(edge::H3Index)::Union{H3ErrorCode, Tuple{H3Index, H3Index}}
    originDestination = Vector{H3Index}(undef, 2)
    ret::H3Error = Lib.directedEdgeToCells(edge, originDestination)
    _check_h3error(ret, tuple(originDestination...))
end

"""
    originToDirectedEdges(origin::H3Index)::Union{H3ErrorCode, Vector{H3Index}}

Provides all of the directed edges from the current H3Index.
@param origin The origin hexagon H3Index to find edges for.
@param edges The memory to store all of the edges inside.
"""
function originToDirectedEdges(origin::H3Index)::Union{H3ErrorCode, Vector{H3Index}}
    edges = Vector{H3Index}(undef, 6)
    ret::H3Error = Lib.originToDirectedEdges(origin, edges)
    _check_h3error(ret, edges)
end

"""
    directedEdgeToBoundary(edge::H3Index)::Union{H3ErrorCode, Vector{LatLng}}

Provides the coordinates defining the directed edge.
@param edge The directed edge H3Index
@param cb The cellboundary object to store the edge coordinates.
"""
function directedEdgeToBoundary(edge::H3Index)::Union{H3ErrorCode, Vector{LatLng}}
    refboundary = Ref{CellBoundary}()
    ret::H3Error = Lib.directedEdgeToBoundary(edge, refboundary)
    _check_h3error(ret, begin
        numVerts = refboundary[].numVerts
        verts = refboundary[].verts[1:numVerts]
        collect(verts)
    end)
end


# Miscellaneous H3 functions
"""
    cellAreaRads2(cell::H3Index)::Union{H3ErrorCode, Cdouble}

Exact area of specific cell in square radiants.
"""
function cellAreaRads2(cell::H3Index)::Union{H3ErrorCode, Cdouble}
    out = Ref{Cdouble}()
    ret::H3Error = Lib.cellAreaRads2(cell, out)
    _check_h3error(ret, out[])
end

"""
    cellAreaKm2(cell::H3Index)::Union{H3ErrorCode, Cdouble}

Exact area of specific cell in square kilometers.
"""
function cellAreaKm2(cell::H3Index)::Union{H3ErrorCode, Cdouble}
    refout = Ref{Cdouble}()
    ret::H3Error = Lib.cellAreaKm2(cell, refout)
    _check_h3error(ret, refout[])
end

"""
    cellAreaM2(res::Int)::Union{H3ErrorCode, Cdouble}

Exact area of specific cell in square meters.
"""
function cellAreaM2(cell::H3Index)::Union{H3ErrorCode, Cdouble}
    refout = Ref{Cdouble}()
    ret::H3Error = Lib.cellAreaM2(cell, refout)
    _check_h3error(ret, refout[])
end

"""
    edgeLengthKm(res::Int)::Union{H3ErrorCode, Cdouble}

Average hexagon edge length in kilometers at the given resolution.
"""
function edgeLengthKm(res::Int)::Union{H3ErrorCode, Cdouble}
    refout = Ref{Cdouble}()
    ret::H3Error = Lib.edgeLengthKm(res, refout)
    _check_h3error(ret, refout[])
end

"""
    edgeLengthM(res::Int)::Union{H3ErrorCode, Cdouble}

Average hexagon edge length in meters at the given resolution.
"""
function edgeLengthM(res::Int)::Union{H3ErrorCode, Cdouble}
    refout = Ref{Cdouble}()
    ret::H3Error = Lib.edgeLengthM(res, refout)
    _check_h3error(ret, refout[])
end

"""
    getNumCells(res::Int)::Union{H3ErrorCode, Int64}

number of cells (hexagons and pentagons) for a given resolution

It works out to be `2 + 120*7^r` for resolution `r`.

# Mathematical notes

Let h(n) be the number of children n levels below
a single *hexagon*.

Then h(n) = 7^n.

Let p(n) be the number of children n levels below
a single *pentagon*.

Then p(0) = 1, and p(1) = 6, since each pentagon
has 5 hexagonal immediate children and 1 pentagonal
immediate child.

In general, we have the recurrence relation

p(n) = 5*h(n-1) + p(n-1)
     = 5*7^(n-1) + p(n-1).

Working through the recurrence, we get that

p(n) = 1 + 5*\\sum_{k=1}^n 7^{k-1}
     = 1 + 5*(7^n - 1)/6,

using the closed form for a geometric series.

Using the closed forms for h(n) and p(n), we can
get a closed form for the total number of cells
at resolution r:

c(r) = 12*p(r) + 110*h(r)
     = 2 + 120*7^r.


@param   res  H3 cell resolution

@return       number of cells at resolution `res`
"""
function getNumCells(res::Int)::Union{H3ErrorCode, Int64}
    refout = Ref{Int64}()
    ret::H3Error = Lib.getNumCells(res, refout)
    _check_h3error(ret, refout[])
end

"""
    getRes0Cells()::Union{H3ErrorCode, Vector{H3Index}}

All the resolution 0 H3 indexes.
"""
function getRes0Cells()::Union{H3ErrorCode, Vector{H3Index}}
    out = Vector{H3Index}(undef, res0CellCount())
    ret::H3Error = Lib.getRes0Cells(out)
    _check_h3error(ret, out)
end

"""
    res0CellCount()::Cint

returns the number of resolution 0 cells (hexagons and pentagons)
"""
function res0CellCount()::Cint
    Lib.res0CellCount()::Cint
end


### Coordinate Systems

"""
    ijToIjk(c::CoordIJ)::Union{H3ErrorCode, CoordIJK}

Transforms coordinates from the IJ coordinate system to the IJK+ coordinate system.
"""
function ijToIjk(c::CoordIJ)::Union{H3ErrorCode, CoordIJK}
    refijk = Ref{CoordIJK}()
    ret::H3Error = Lib.ijToIjk(Ref(c), refijk)
    _check_h3error(ret, refijk[])
end

"""
    ijkToHex2d(c::CoordIJK)::Vec2d

Find the center point in 2D cartesian coordinates of a hex.
"""
function ijkToHex2d(c::CoordIJK)::Vec2d
    refv = Ref{Vec2d}()
    Lib._ijkToHex2d(Ref(c), refv)::Cvoid
    refv[]
end

"""
    ijkToIj(c::CoordIJK)::CoordIJ

Transforms coordinates from the IJK+ coordinate system to the IJ coordinate system.
"""
function ijkToIj(c::CoordIJK)::CoordIJ
    refij = Ref{CoordIJ}()
    Lib.ijkToIj(Ref(c), refij)::Cvoid
    refij[]
end

"""
    ijkDistance(c1::CoordIJK, c2::CoordIJK)::Int

Finds the distance between the two coordinates. Returns result.
"""
function ijkDistance(c1::CoordIJK, c2::CoordIJK)::Int
    Lib.ijkDistance(Ref(c1), Ref(c2))::Cint
end

"""
    ijkNormalize(c::CoordIJK)::CoordIJK

Normalizes ijk coordinates by setting the components to the smallest possible values. Works in place.
"""
function ijkNormalize(c::CoordIJK)::CoordIJK
    ref = Ref(c)
    Lib._ijkNormalize(ref)::Cvoid
    ref[]
end

"""
    cellToLocalIjk(origin::H3Index, h3::H3Index)::Union{H3ErrorCode, CoordIJK}

Produces ijk+ coordinates for an index anchored by an origin.

The coordinate space used by this function may have deleted
regions or warping due to pentagonal distortion.

Coordinates are only comparable if they come from the same
origin index.

Failure may occur if the index is too far away from the origin
or if the index is on the other side of a pentagon.

@param origin An anchoring index for the ijk+ coordinate system.
@param index Index to find the coordinates of
@param out ijk+ coordinates of the index will be placed here on success
@return 0 on success, or another value on failure.
"""
function cellToLocalIjk(origin::H3Index, h3::H3Index)::Union{H3ErrorCode, CoordIJK}
    refout = Ref{CoordIJK}()
    ret::H3Error = Lib.cellToLocalIjk(origin, h3, refout)
    _check_h3error(ret, refout[])
end

"""
    h3ToFaceIjk(h::H3Index)::Union{H3ErrorCode, FaceIJK}

Convert an H3Index to a FaceIJK address.
"""
function h3ToFaceIjk(h::H3Index)::Union{H3ErrorCode, FaceIJK}
    ref_fijk = Ref{FaceIJK}()
    ret::H3Error = Lib._h3ToFaceIjk(h, ref_fijk)
    _check_h3error(ret, ref_fijk[])
end

"""
    localIjkToCell(origin::H3Index, ijk::CoordIJK)::Union{H3ErrorCode, H3Index}

Produces an index for ijk+ coordinates anchored by an origin.

The coordinate space used by this function may have deleted
regions or warping due to pentagonal distortion.

Failure may occur if the coordinates are too far away from the origin
or if the index is on the other side of a pentagon.

@param origin An anchoring index for the ijk+ coordinate system.
@param ijk IJK+ Coordinates to find the index of
@param out The index will be placed here on success
@return 0 on success, or another value on failure.
"""
function localIjkToCell(origin::H3Index, ijk::CoordIJK)::Union{H3ErrorCode, H3Index}
    refh = Ref{H3Index}()
    ret::H3Error = Lib.localIjkToCell(origin, Ref(ijk), refh)
    _check_h3error(ret, refh[])
end

"""
    faceIjkToH3(faceijk::FaceIJK, res::Int)::H3Index

Convert an FaceIJK address to the corresponding H3Index.
"""
function faceIjkToH3(faceijk::FaceIJK, res::Int)::H3Index
    Lib._faceIjkToH3(Ref(faceijk), res)::H3Index
end

"""
    hex2dToCoordIJK(v::Vec2d)::CoordIJK

Determine the containing hex in ijk+ coordinates for a 2D cartesian coordinate vector (from DGGRID).
"""
function hex2dToCoordIJK(v::Vec2d)::CoordIJK
    ref = Ref{CoordIJK}()
    Lib._hex2dToCoordIJK(Ref(v), ref)::Cvoid
    ref[]
end

"""
    geoToVec3d(geo::LatLng)::Vec3d

Calculate the 3D coordinate on unit sphere from the latitude and longitude.
"""
function geoToVec3d(geo::LatLng)::Vec3d
    ref = Ref{Vec3d}()
    Lib._geoToVec3d(Ref(geo), ref)::Cvoid
    ref[]
end

"""
    geoToFaceIjk(geo::LatLng, res::Int)::FaceIJK

Encodes a coordinate on the sphere to the FaceIJK address of the containing cell at the specified resolution.
"""
function geoToFaceIjk(geo::LatLng, res::Int)::FaceIJK
    ref = Ref{FaceIJK}()
    Lib._geoToFaceIjk(Ref(geo), res, ref)::Cvoid
    ref[]
end


### ≈

function Base.isapprox(A::Vector{LatLng}, B::Vector{LatLng})
    A === B && return true
    axes(A) != axes(B) && return false
    for (a, b) in zip(A, B)
        if !(isapprox(a.lat, b.lat) && isapprox(a.lng, b.lng))
            return false
        end
    end
    return true
end

function Base.isapprox(A::Vector{Tuple{Float64, Float64}}, B::Vector{Tuple{Float64, Float64}})
    A === B && return true
    axes(A) != axes(B) && return false
    for (a, b) in zip(A, B)
        if !(isapprox(a[1], b[1]) && isapprox(a[2], b[2]))
            return false
        end
    end
    return true
end

function Base.isapprox(a::Vec2d, b::Vec2d)
    return isapprox(a.x, b.x) &&
           isapprox(a.y, b.y)
end

function Base.isapprox(a::Vec3d, b::Vec3d)
    return isapprox(a.x, b.x) &&
           isapprox(a.y, b.y) &&
           isapprox(a.z, b.z)
end

function Base.isapprox(a::LatLng, b::LatLng)
    return isapprox(a.lat, b.lat) &&
           isapprox(a.lng, b.lng)
end

end # module H3.API
