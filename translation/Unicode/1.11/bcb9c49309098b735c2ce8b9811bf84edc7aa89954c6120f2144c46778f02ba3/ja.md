```julia
isequal_normalized(s1::AbstractString, s2::AbstractString; casefold=false, stripmark=false, chartransform=identity)
```

`s1` と `s2` が、Unicode において正準等価な文字列かどうかを返します。`casefold=true` の場合は大文字と小文字を区別せず（Unicode のケースフォールディングを実行）、`stripmark=true` の場合は発音区別符号などの結合文字を取り除きます。

[`Unicode.normalize`](@ref) と同様に、`chartransform` キーワード引数に任意の関数（`Integer` のコードポイントをコードポイントに対応付ける関数）を渡して、[`Unicode.julia_chartransform`](@ref) のような独自の正規化を行うこともできます。

!!! compat "Julia 1.8"
    `isequal_normalized` 関数は Julia 1.8 で追加されました。


# Examples

たとえば、文字列 `"noël"` は、Unicode では正準等価な 2 通りの方法で構成できます。`"ë"` が単一のコードポイント U+00EB で構成される場合と、ASCII 文字 `'e'` の後に U+0308 の結合分音記号が続く場合です。

```jldoctest
julia> s1 = "noël"
"noël"

julia> s2 = "noël"
"noël"

julia> s1 == s2
false

julia> isequal_normalized(s1, s2)
true

julia> isequal_normalized(s1, "noel", stripmark=true)
true

julia> isequal_normalized(s1, "NOËL", casefold=true)
true
```
