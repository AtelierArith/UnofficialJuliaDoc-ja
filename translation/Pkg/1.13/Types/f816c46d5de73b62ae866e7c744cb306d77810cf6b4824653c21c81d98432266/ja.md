```julia
manifest_format_for(julia_version)
```

Pkg が書き出すマニフェスト形式です。`julia_version` では、`nothing` 用の最新形式が使われます。これより新しい Julia では、さらに新しい形式が書き出される可能性がありますが、この Pkg はその形式を認識できないため、この Pkg が対応する形式が使われます。
