```
isequal_normalized(s1::AbstractString, s2::AbstractString; casefold=false, stripmark=false, chartransform=identity)
```

`s1` と `s2` が正規化された等価な Unicode 文字列であるかどうかを返します。 `casefold=true` の場合、大文字と小文字を無視します（Unicode のケースフォールディングを実行します）。 `stripmark=true` の場合、発音記号やその他の結合文字を取り除きます。

[`Unicode.normalize`](@ref) と同様に、`chartransform` キーワードを介して任意の関数を渡すこともできます（`Integer` コードポイントをコードポイントにマッピング）カスタム正規化を実行するために、例えば [`Unicode.julia_chartransform`](@ref) のように。

!!! compat "Julia 1.8"
    `isequal_normalized` 関数は Julia 1.8 で追加されました。


# 例

例えば、文字列 `"noël"` は、Unicode で二つの正規化された等価な方法で構築できます。これは、`"ë"` が単一のコードポイント U+00EB から形成されるか、ASCII 文字 `'e'` の後に U+0308 結合ダイアレシス文字が続くかによります。

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
