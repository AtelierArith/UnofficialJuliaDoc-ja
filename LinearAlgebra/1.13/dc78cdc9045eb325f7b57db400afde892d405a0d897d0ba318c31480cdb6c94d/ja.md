```julia
HessenbergQ <: AbstractQ
```

[`Hessenberg`](@ref) 因子分解オブジェクト `F` に対して、`F.Q` は `HessenbergQ` オブジェクトを返します。これは、`F` で表されるヘッセンベルグ分解 `QHQ'` におけるユニタリ行列 `Q` の暗黙表現です。この `F.Q` オブジェクトは、行列やベクトルとの積を効率よく計算でき、`Matrix(F.Q)` を使って通常の行列型に変換できます。
