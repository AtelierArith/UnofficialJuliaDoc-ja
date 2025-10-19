```julia
ncodeunits(s::AbstractString) -> Int
```

文字列内のコードユニットの数を返します。この文字列にアクセスするためのインデックスは `1 ≤ i ≤ ncodeunits(s)` を満たす必要があります。すべてのインデックスが有効であるわけではなく、文字の開始位置でない場合もありますが、`codeunit(s,i)` を呼び出すとコードユニット値を返します。

# 例

```jldoctest
julia> ncodeunits("The Julia Language")
18

julia> ncodeunits("∫eˣ")
6

julia> ncodeunits('∫'), ncodeunits('e'), ncodeunits('ˣ')
(3, 1, 2)
```

関連項目としては [`codeunit`](@ref), [`checkbounds`](@ref), [`sizeof`](@ref), [`length`](@ref), [`lastindex`](@ref) があります。
