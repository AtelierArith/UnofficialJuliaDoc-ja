```julia
insert!(a::Vector, index::Integer, item)
```

Insert an `item` into `a` at the given `index`. `index` is the index of `item` in the resulting `a`.

See also: [`push!`](@ref), [`replace`](@ref), [`popat!`](@ref), [`splice!`](@ref).

# Examples

```jldoctest
julia> insert!(Any[1:6;], 3, "here")
7-element Vector{Any}:
 1
 2
  "here"
 3
 4
 5
 6
```
