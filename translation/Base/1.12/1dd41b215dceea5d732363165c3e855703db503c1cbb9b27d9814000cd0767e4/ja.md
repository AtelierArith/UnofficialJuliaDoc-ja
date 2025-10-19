```julia
fieldnames(x::DataType)
```

`DataType`のフィールドの名前を持つタプルを取得します。

各名前は`Symbol`ですが、`x <: Tuple`の場合は、各名前（実際にはフィールドのインデックス）は`Int`です。

[`propertynames`](@ref)や[`hasfield`](@ref)も参照してください。

# 例

```jldoctest
julia> fieldnames(Rational)
(:num, :den)

julia> fieldnames(typeof(1+im))
(:re, :im)

julia> fieldnames(Tuple{String,Int})
(1, 2)
```
