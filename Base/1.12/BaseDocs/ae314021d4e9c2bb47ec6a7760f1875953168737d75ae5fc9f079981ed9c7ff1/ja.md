```julia
Main
```

`Main`は最上位のモジュールであり、Juliaは`Main`を現在のモジュールとして開始します。プロンプトで定義された変数は`Main`に入ります、そして`varinfo`は`Main`の変数をリストします。

```jldoctest
julia> @__MODULE__
Main
```
