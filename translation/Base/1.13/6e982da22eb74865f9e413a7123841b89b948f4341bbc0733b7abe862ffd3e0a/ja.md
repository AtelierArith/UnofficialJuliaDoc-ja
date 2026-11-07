```julia
iterate(s::AbstractString, i::Integer)::Union{Tuple{<:AbstractChar, Int}, Nothing}
```

`s` の `i` 番目の文字と、`s` における次の文字の開始位置をタプルで返します。これは、文字列を反復処理して文字の列を得るための重要なメソッドです。反復プロトコルの一部として、`iterate` 関数は、`i` が `s` 内の文字の開始位置であると仮定できます。

関連項目: [`getindex`](@ref)、[`checkbounds`](@ref)。
