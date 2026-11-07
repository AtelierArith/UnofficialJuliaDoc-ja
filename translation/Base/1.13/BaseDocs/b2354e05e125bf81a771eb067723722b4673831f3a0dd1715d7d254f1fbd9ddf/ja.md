```julia
Main
```

`Main`は最上位モジュールであり、Juliaは`Main`を現在のモジュールとして起動します。プロンプトで定義した変数は`Main`に格納され、`varinfo`は`Main`内の変数を一覧表示します。

```jldoctest
julia> @__MODULE__
Main
```
