```julia
ncodeunits(s::AbstractString)::Int
```

文字列内のコードユニット数を返します。この文字列にアクセスするために範囲内となるインデックスは、`1 ≤ i ≤ ncodeunits(s)`を満たす必要があります。ただし、範囲内のインデックスがすべて有効とは限りません。文字の先頭を指していない場合もありますが、`codeunit(s,i)`を呼び出すとコードユニット値が返されます。

# Examples

```jldoctest
julia> ncodeunits("The Julia Language")
18

julia> ncodeunits("∫eˣ")
6

julia> ncodeunits('∫'), ncodeunits('e'), ncodeunits('ˣ')
(3, 1, 2)
```

関連項目：[`codeunit`](@ref)、[`checkbounds`](@ref)、[`sizeof`](@ref)、[`length`](@ref)、[`lastindex`](@ref)。
