```julia
spzeros([type], I::AbstractVector, J::AbstractVector, [m, n])
```

構造的ゼロを `S[I[k], J[k]]` に持つ、次元 `m x n` の疎行列 `S` を作成します。

このメソッドは行列の疎性パターンの構築に使用でき、たとえば `sparse(I, J, zeros(length(I)))` を使うより効率的です。

詳しいドキュメントとエキスパート向けドライバーについては、`SparseArrays.spzeros!` を参照してください。

!!! compat "Julia 1.10"
    このメソッドには Julia 1.10 以降が必要です。

