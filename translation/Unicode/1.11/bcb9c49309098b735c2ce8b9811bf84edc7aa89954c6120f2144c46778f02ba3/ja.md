```julia
isequal_normalized(s1::AbstractString, s2::AbstractString; casefold=false, stripmark=false, chartransform=identity)
```

`s1`と`s2`が、Unicodeで正準等価な文字列かどうかを返します。`casefold=true`の場合は大文字と小文字を区別せず（Unicodeのケースフォールディングを実行し）、`stripmark=true`の場合は発音区別符号などの結合文字を取り除きます。

[`Unicode.normalize`](@ref)と同様に、`chartransform`キーワードに任意の関数（`Integer`のコードポイントをコードポイントに対応付ける関数）を渡して、[`Unicode.julia_chartransform`](@ref)などのカスタム正規化を行うこともできます。

!!! compat "Julia 1.8"
    `isequal_normalized`関数はJulia 1.8で追加されました。


# Examples

たとえば、文字列`"noël"`は、Unicodeでは正準等価な2通りの方法で構成できます。`"ë"`が単一のコードポイントU+00EBで構成される場合と、ASCII文字`'e'`の後にU+0308の結合分音記号が続く場合です。

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
