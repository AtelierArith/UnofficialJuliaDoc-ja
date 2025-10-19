```julia
spzeros([type], I::AbstractVector, J::AbstractVector, [m, n])
```

構造的ゼロを持つ次元 `m x n` の疎行列 `S` を作成します。ゼロは `S[I[k], J[k]]` に配置されます。

このメソッドは行列の疎性パターンを構築するために使用でき、例えば `sparse(I, J, zeros(length(I)))` を使用するよりも効率的です。

追加のドキュメントと専門的なドライバーについては `SparseArrays.spzeros!` を参照してください。

!!! compat "Julia 1.10"
    このメソッドはJuliaバージョン1.10以降を必要とします。

