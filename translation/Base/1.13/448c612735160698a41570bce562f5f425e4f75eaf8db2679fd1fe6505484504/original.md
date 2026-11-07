```julia
isopen(object)::Bool
```

Determine whether an object, such as an IO or timer, is still open and hence active.

See also: [`close`](@ref)

# Examples

```jldoctest
julia> io = open("my_file.txt", "w+");

julia> isopen(io)
true

julia> close(io)

julia> isopen(io)
false
```
