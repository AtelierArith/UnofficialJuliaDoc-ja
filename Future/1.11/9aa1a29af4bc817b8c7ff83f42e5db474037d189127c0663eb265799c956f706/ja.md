```julia
randjump(r::MersenneTwister, steps::Integer)::MersenneTwister
```

初期化済みの `MersenneTwister` オブジェクトを作成します。このオブジェクトの状態は、`r` から `steps` ステップ分、数値を生成せずに進められます。1ステップは、`Float64` の数値を2つ生成することに相当します。`steps` の値が異なるごとに、大きな多項式を内部で生成する必要があります。`steps=big(10)^20` 用の多項式は、すでに事前計算されています。
