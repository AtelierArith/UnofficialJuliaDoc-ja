```julia
annotations(str::Union{AnnotatedString, SubString{AnnotatedString}},
            [position::Union{Integer, UnitRange}]) ->
    Vector{@NamedTuple{region::UnitRange{Int64}, label::Symbol, value}}
```

`str`に適用されるすべての注釈を取得します。`position`が指定された場合は、`position`と重なる注釈のみが返されます。

注釈は、適用対象の領域とともに、領域と注釈のタプルからなるベクトルとして提供されます。

[`AnnotatedString`](@ref)に記載されているセマンティクスに従い、返される注釈の順序は、適用された順序と一致します。

関連項目: [`annotate!`](@ref)。
