# code from https://github.com/JuliaGraphics/FreeType.jl/tree/master/gen

using Clang.Generators
using H3_jll

const h3api_dir = normpath(H3_jll.find_artifact_dir(), "include/h3")
const h3api_header = normpath(h3api_dir, "h3api.h")

const H3_VERSION = v"4.1.0"
const h3_dir = normpath(@__DIR__, "h3-$H3_VERSION")
!isdir(h3_dir) && throw(string("need ", h3_dir))
const h3_include_dir = normpath(h3_dir, "src/h3lib/include")
((root, dirs, files),) = walkdir(h3_include_dir)
const skips = ["constants.h", "polygonAlgos.h"]
const h3lib_headers = normpath.(root, filter(x -> endswith(x, ".h") && !in(x, skips), files))

const headers = vcat([h3api_header], h3lib_headers)
const args = vcat(get_default_args(), "-I$h3api_dir")
const options = load_options(joinpath(@__DIR__, "generator.toml"))

ctx = create_context(headers, args, options)

build!(ctx)
