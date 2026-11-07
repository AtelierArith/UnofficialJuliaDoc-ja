```julia
UnitRange{T<:Real}
```

`start`と`stop`でパラメーター化された、型が`T`の範囲です。`start`から`stop`を超えるまで、`1`間隔で要素が並びます。`a`と`b`がどちらも`Integer`である場合、構文`a:b`は`UnitRange`を生成します。

# Examples

```jldoctest
julia> collect(UnitRange(2.3, 5.2))
3-element Vector{Float64}:
 2.3
 3.3
 4.3

julia> typeof(1:10)
UnitRange{Int64}
```
