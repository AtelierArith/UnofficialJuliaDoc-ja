```julia
annotations(str::Union{AnnotatedString, SubString{AnnotatedString}},
            [position::Union{Integer, UnitRange}]) ->
    Vector{@NamedTuple{region::UnitRange{Int64}, label::Symbol, value}}
```

`str` に適用されるすべての注釈を取得します。`position` が提供される場合、`position` と重なる注釈のみが返されます。

注釈は、それが適用される領域と共に、領域–注釈タプルのベクトルの形で提供されます。

[`AnnotatedString`](@ref) に文書化された意味論に従い、返される注釈の順序は、それらが適用された順序と一致します。

参照: [`annotate!`](@ref).
