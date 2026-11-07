```julia
getindex(type[, elements...])
```

指定した型の1次元配列を構築します。通常は、次の構文で呼び出します。`Type[]`。要素の値は、`Type[a,b,c,...]`を使って指定できます。

# Examples

```jldoctest
julia> Int8[1, 2, 3]
3-element Vector{Int8}:
 1
 2
 3

julia> getindex(Int8, 1, 2, 3)
3-element Vector{Int8}:
 1
 2
 3
```
