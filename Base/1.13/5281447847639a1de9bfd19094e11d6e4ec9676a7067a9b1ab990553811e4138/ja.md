```julia
Base.Chars = Union{AbstractChar,Tuple{Vararg{AbstractChar}},AbstractVector{<:AbstractChar},AbstractSet{<:AbstractChar}}
```

単一の文字、または文字のタプル・ベクトル・集合のいずれかを表すエイリアス型です。[`startswith`](@ref)や[`strip`](@ref)など、複数の文字列マッチング関数の引数を記述するために使われます。

!!! compat "Julia 1.11"
    Julia 1.11 より前のバージョンでは、`Base.Chars`型に含まれていたのは`Set`のみで、`AbstractSet`は含まれていませんでした。

