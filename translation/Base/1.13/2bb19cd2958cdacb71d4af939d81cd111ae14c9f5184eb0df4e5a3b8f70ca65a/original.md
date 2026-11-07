```julia
@__FILE__ -> String
```

Expand to a string with the path to the file containing the macrocall, or an empty string if evaluated by `julia -e <expr>`. Return `nothing` if the macro was missing parser source information. Alternatively see [`PROGRAM_FILE`](@ref).
