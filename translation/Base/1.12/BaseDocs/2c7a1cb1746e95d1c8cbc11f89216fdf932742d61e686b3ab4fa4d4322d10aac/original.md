```julia
applicable(f, args...) -> Bool
```

Determine whether the given generic function has a method applicable to the given arguments.

See also [`hasmethod`](@ref).

# Examples

```jldoctest
julia> function f(x, y)
           x + y
       end;

julia> applicable(f, 1)
false

julia> applicable(f, 1, 2)
true
```
