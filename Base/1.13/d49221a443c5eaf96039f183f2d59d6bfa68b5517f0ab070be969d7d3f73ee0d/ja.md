```julia
reverse(s::AbstractString)::AbstractString
```

文字列を反転します。厳密には、この関数は文字列内のコードポイントを反転します。主な用途は、文字列を逆順に処理すること、特に正規表現による逆方向検索です。[`reverseind`](@ref)も参照してください。これは、`s`内のインデックスを`reverse(s)`内のインデックスに変換し、その逆も行います。また、コードポイントではなく、ユーザーに見える「文字」（書記素）を扱うには、モジュール`Unicode`の`graphemes`を参照してください。コピーを作成せずに逆順で反復するには、[`Iterators.reverse`](@ref)も参照してください。独自の文字列型では、`reverse`関数を実装する必要があります。通常は、同じ型とエンコーディングの文字列を返すようにしてください。異なるエンコーディングの文字列を返す場合は、`s[reverseind(s,i)] == reverse(s)[i]`を満たすため、その文字列型に対して`reverseind`もオーバーライドする必要があります。

# Examples

```jldoctest
julia> reverse("JuliaLang")
"gnaLailuJ"
```

!!! note
    以下の例は、システムによって表示が異なる場合があります。コメントは、想定される表示方法を示しています。


結合文字によって、予想外の結果になることがあります。

```jldoctest
julia> reverse("ax̂e") # hat is above x in the input, above e in the output
"êxa"

julia> using Unicode

julia> join(reverse(collect(graphemes("ax̂e")))) # reverses graphemes; hat is above x in both in- and output
"ex̂a"
```
