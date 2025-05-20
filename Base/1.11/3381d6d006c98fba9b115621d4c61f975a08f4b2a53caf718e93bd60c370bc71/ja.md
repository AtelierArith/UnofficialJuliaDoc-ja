```
reverse(s::AbstractString) -> AbstractString
```

文字列を逆にします。技術的には、この関数は文字列内のコードポイントを逆にし、その主な用途は逆順の文字列処理、特に逆順の正規表現検索にあります。`s`のインデックスを`reverse(s)`のインデックスに変換するための[`reverseind`](@ref)や、コードポイントではなくユーザーが目にする「文字」（グラフェム）に対して操作するための`Unicode`モジュールの`graphemes`も参照してください。また、コピーを作成せずに逆順の反復を行うための[`Iterators.reverse`](@ref)も参照してください。カスタム文字列型は自分自身で`reverse`関数を実装する必要があり、通常は同じ型とエンコーディングの文字列を返すべきです。異なるエンコーディングの文字列を返す場合、その文字列型に対して`reverseind`もオーバーライドし、`s[reverseind(s,i)] == reverse(s)[i]`を満たす必要があります。

# 例

```jldoctest
julia> reverse("JuliaLang")
"gnaLailuJ"
```

!!! note
    以下の例は、異なるシステムで異なる表示になる場合があります。コメントは、どのように表示されるべきかを示しています


結合文字は驚くべき結果をもたらすことがあります：

```jldoctest
julia> reverse("ax̂e") # 帽子は入力のxの上、出力のeの上にあります
"êxa"

julia> using Unicode

julia> join(reverse(collect(graphemes("ax̂e")))) # グラフェムを逆にします；帽子は両方の入力と出力のxの上にあります
"ex̂a"
```
