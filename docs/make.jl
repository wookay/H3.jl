using H3.API
using H3.Lib
using Documenter

makedocs(
    build = joinpath(@__DIR__, "local" in ARGS ? "build_local" : "build"),
    modules = [API, Lib],
    clean = false,
    format = Documenter.HTML(prettyurls = !("local" in ARGS)),
    sitename = "H3.jl ⬡",
    authors = "WooKyoung Noh",
    pages = Any[
        "Home" => "index.md",
        "API" => "API.md",
        "Lib" => "Lib.md",
    ],
)
