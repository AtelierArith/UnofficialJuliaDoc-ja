```julia
!==(x, y)
≢(x,y)
```

常に[`===`](@ref)とは反対の答えを返します。

# Examples

```jldoctest
julia> a = [1, 2]; b = [1, 2];

julia> a ≢ b
true

julia> a ≢ a
false
```
