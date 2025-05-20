```
evalfile(path::AbstractString, args::Vector{String}=String[])
```

Load the file into an anonymous module using [`include`](@ref), evaluate all expressions, and return the value of the last expression. The optional `args` argument can be used to set the input arguments of the script (i.e. the global `ARGS` variable). Note that definitions (e.g. methods, globals) are evaluated in the anonymous module and do not affect the current module.

# Examples

```jldoctest
julia> write("testfile.jl", """
           @show ARGS
           1 + 1
       """);

julia> x = evalfile("testfile.jl", ["ARG1", "ARG2"]);
ARGS = ["ARG1", "ARG2"]

julia> x
2

julia> rm("testfile.jl")
```
