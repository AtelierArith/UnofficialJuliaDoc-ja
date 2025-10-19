```julia
map!(function, destination, collection...)
```

Like [`map`](@ref), but stores the result in `destination` rather than a new collection. `destination` must be at least as large as the smallest collection.

!!! warning
    Behavior can be unexpected when any mutated argument shares memory with any other argument.


See also: [`map`](@ref), [`foreach`](@ref), [`zip`](@ref), [`copyto!`](@ref).

# Examples

```jldoctest
julia> a = zeros(3);

julia> map!(x -> x * 2, a, [1, 2, 3]);

julia> a
3-element Vector{Float64}:
 2.0
 4.0
 6.0

julia> map!(+, zeros(Int, 5), 100:999, 1:3)
5-element Vector{Int64}:
 101
 103
 105
   0
   0
```
