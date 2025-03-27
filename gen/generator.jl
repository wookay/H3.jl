# code from https://github.com/JuliaGraphics/FreeType.jl/tree/master/gen

using Clang.Generators
using H3_jll
using TOML

const h3api_dir = normpath(H3_jll.find_artifact_dir(), "include/h3")
const h3api_header = normpath(h3api_dir, "h3api.h")

const H3_VERSION = VersionNumber(TOML.parsefile(normpath(@__DIR__, "Project.toml"))["compat"]["H3_jll"])
const h3_ver = "h3-$H3_VERSION"
const h3_path = normpath(@__DIR__, h3_ver)
!isdir(h3_path) && throw("""
Not found h3, please git clone https://github.com/uber/h3 $h3_ver""")
const h3_include_dir = normpath(h3_path, "src/h3lib/include")
((root, dirs, files),) = walkdir(h3_include_dir)
const skips = ["constants.h", "polygonAlgos.h"]
const h3lib_headers = normpath.(root, filter(x -> endswith(x, ".h") && !in(x, skips), files))

const headers = vcat([h3api_header], h3lib_headers)
const args = vcat(get_default_args(), "-I$h3api_dir")
const options = load_options(joinpath(@__DIR__, "generator.toml"))

ctx = create_context(headers, args, options)

build!(ctx)
