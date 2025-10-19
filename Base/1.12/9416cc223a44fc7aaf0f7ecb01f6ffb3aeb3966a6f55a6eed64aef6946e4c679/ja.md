```julia
step(r)
```

[`AbstractRange`](@ref) オブジェクトのステップサイズを取得します。

# 例

```jldoctest
julia> step(1:10)
1

julia> step(1:2:10)
2

julia> step(2.5:0.3:10.9)
0.3

julia> step(range(2.5, stop=10.9, length=85))
0.1
```
