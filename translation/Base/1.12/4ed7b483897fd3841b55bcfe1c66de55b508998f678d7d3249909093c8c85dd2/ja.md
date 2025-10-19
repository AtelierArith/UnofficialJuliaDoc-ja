```julia
complex(r, [i])
```

実数または配列を複素数に変換します。`i`はデフォルトでゼロです。

# 例

```jldoctest
julia> complex(7)
7 + 0im

julia> complex([1, 2, 3])
3-element Vector{Complex{Int64}}:
 1 + 0im
 2 + 0im
 3 + 0im
```
