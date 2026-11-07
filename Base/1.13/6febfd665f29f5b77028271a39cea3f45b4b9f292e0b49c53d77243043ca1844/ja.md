```julia
checkbounds(Bool, A, I...)
```

指定されたインデックス `I` が配列 `A` の範囲内にある場合は、`true` を返します。独自の境界チェック動作を提供する必要がある場合は、`AbstractArray` のサブタイプでこのメソッドを特殊化してください。ただし、多くの場合は `A` のインデックスと [`checkindex`](@ref) を利用できます。

[`checkindex`](@ref) も参照してください。

# Examples

```jldoctest
julia> A = rand(3, 3);

julia> checkbounds(Bool, A, 2)
true

julia> checkbounds(Bool, A, 3, 4)
false

julia> checkbounds(Bool, A, 1:3)
true

julia> checkbounds(Bool, A, 1:3, 2:4)
false
```
