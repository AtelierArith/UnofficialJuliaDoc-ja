```julia
isperm(v)::Bool
```

`true` を返してください。`v` が有効な順列である場合に限ります。

# Examples

```jldoctest
julia> isperm([1; 2])
true

julia> isperm([1; 3])
false
```
