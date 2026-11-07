```julia
objectid(x)::UInt
```

オブジェクトの同一性に基づいて、`x`のハッシュ値を取得します。この値は一意ではなく、Juliaのプロセスやバージョンが異なると安定しません。

`x === y`の場合は`objectid(x) == objectid(y)`となり、通常は`x !== y`の場合は`objectid(x) != objectid(y)`となります。

[`hash`](@ref)、[`IdDict`](@ref)も参照してください。
