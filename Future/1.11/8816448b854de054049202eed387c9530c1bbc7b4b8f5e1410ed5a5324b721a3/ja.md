```
randjump(r::MersenneTwister, steps::Integer) -> MersenneTwister
```

初期化された `MersenneTwister` オブジェクトを作成し、その状態を `r` から `steps` ステップ前進させます（数値を生成せずに）。1つのステップは2つの `Float64` 数値の生成に対応します。異なる `steps` の値ごとに、大きな多項式が内部で生成される必要があります。`steps=big(10)^20` のために、1つはすでに事前計算されています。
