```julia
fieldnames(x::DataType)
```

`DataType`のフィールド名をタプルとして取得します。

各名前は`Symbol`です。ただし、`x <: Tuple`の場合、各名前（実際にはフィールドのインデックス）は`Int`です。

関連項目：[`propertynames`](@ref)、[`hasfield`](@ref)。

# Examples

```jldoctest
julia> fieldnames(Rational)
(:num, :den)

julia> fieldnames(typeof(1+im))
(:re, :im)

julia> fieldnames(Tuple{String,Int})
(1, 2)
```
