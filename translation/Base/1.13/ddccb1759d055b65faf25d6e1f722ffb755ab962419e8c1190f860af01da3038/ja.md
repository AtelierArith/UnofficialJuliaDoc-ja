```julia
objectid(x)::UInt
```

オブジェクトの同一性に基づいて、`x` のハッシュ値を取得します。この値は一意ではなく、Julia のプロセスやバージョンが異なると安定しません。

`x === y` の場合は `objectid(x) == objectid(y)` となり、通常は `x !== y` の場合に `objectid(x) != objectid(y)` となります。

関連項目: [`hash`](@ref)、[`IdDict`](@ref)。
