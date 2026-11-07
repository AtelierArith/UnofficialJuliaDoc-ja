```julia
manifest_format_for(julia_version)
```

`julia_version` が書き出すマニフェスト形式のうち、`nothing` に対応する最新の形式です。これより新しい Julia では、より新しい形式が書き出される可能性がありますが、この Pkg はその形式を認識できないため、この Pkg が対応する形式を取得します。
