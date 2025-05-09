export check_for_common_resolution

using ..H3.API

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
