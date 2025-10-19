```julia
summary(io::IO, x)
str = summary(x)
```

Print to a stream `io`, or return a string `str`, giving a brief description of a value. By default returns `string(typeof(x))`, e.g. [`Int64`](@ref).

For arrays, returns a string of size and type info, e.g. `10-element Vector{Int64}` or `9×4×5 Array{Float64, 3}`.

# Examples

```jldoctest
julia> summary(1)
"Int64"

julia> summary(zeros(2))
"2-element Vector{Float64}"
```
