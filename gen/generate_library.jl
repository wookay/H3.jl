# code from https://github.com/Gnimuc/Nuklear.jl/blob/master/gen/generator.jl

using Clang

const h3_include_dir = normpath(@__DIR__, "..", "deps", "usr", "include", "h3")
((root, dirs, files),) = walkdir(h3_include_dir)
headers = normpath.(root, files)

# create a work context
ctx = DefaultContext()

# parse headers
parse_headers!(ctx, headers, includes=[LLVM_INCLUDE])

# settings
ctx.libname = "libh3"
ctx.options["is_function_strictly_typed"] = false
ctx.options["is_struct_mutable"] = false  # for nested struct

# write output
api_file = normpath(@__DIR__, "libh3_functions.jl")
api_stream = open(api_file, "w")
for trans_unit in ctx.trans_units
    root_cursor = getcursor(trans_unit)
    push!(ctx.cursor_stack, root_cursor)
    header = spelling(root_cursor)
    @info "wrapping header: $header ..."
    # loop over all of the child cursors and wrap them, if appropriate.
    ctx.children = children(root_cursor)
    for (i, child) in enumerate(ctx.children)
        child_name = name(child)
        child_header = filename(child)
        ctx.children_index = i
        # choose which cursor to wrap
        startswith(child_name, "__") && continue  # skip compiler definitions
        child_name in keys(ctx.common_buffer) && continue  # already wrapped
        child_header != header && continue  # skip if cursor filename is not in the headers to be wrapped

        wrap!(ctx, child)
    end
    @info "writing $(api_file)"
    println(api_stream, "# Julia wrapper for header: $header")
    println(api_stream, "# Automatically generated using Clang.jl")
    print_buffer(api_stream, ctx.api_buffer)
    println(api_stream)
    empty!(ctx.api_buffer)  # clean up api_buffer for the next header
end
close(api_stream)

common_file = normpath(@__DIR__, "libh3_types.jl")
expr_buffer = dump_to_buffer(ctx.common_buffer)
io = IOBuffer()
print_buffer(io, expr_buffer)
body = String(take!(io))
open(common_file, "w") do f
    println(f, """
# Automatically generated using Clang.jl

using CEnum
""")
    for line in split(body, '\n')
        !startswith(line, "#") && occursin("MASK_NEGATIVE", line) && print(f, "# ")
        println(f, line)
    end
end
