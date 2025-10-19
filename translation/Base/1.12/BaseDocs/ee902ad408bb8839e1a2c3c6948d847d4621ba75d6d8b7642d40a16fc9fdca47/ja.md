```julia
Vararg{T,N}
```

タプル型 [`Tuple`](@ref) の最後のパラメータは、任意の数の末尾要素を示す特別な値 `Vararg` であることができます。 `Vararg{T,N}` は、型 `T` の正確に `N` 個の要素に対応します。最後に、 `Vararg{T}` は、型 `T` のゼロ個以上の要素に対応します。 `Vararg` タプル型は、可変引数メソッドが受け入れる引数を表すために使用されます（マニュアルの [Varargs Functions](@ref) セクションを参照してください）。

また、 [`NTuple`](@ref) も参照してください。

# 例

```jldoctest
julia> mytupletype = Tuple{AbstractString, Vararg{Int}}
Tuple{AbstractString, Vararg{Int64}}

julia> isa(("1",), mytupletype)
true

julia> isa(("1",1), mytupletype)
true

julia> isa(("1",1,2), mytupletype)
true

julia> isa(("1",1,2,3.0), mytupletype)
false
```
