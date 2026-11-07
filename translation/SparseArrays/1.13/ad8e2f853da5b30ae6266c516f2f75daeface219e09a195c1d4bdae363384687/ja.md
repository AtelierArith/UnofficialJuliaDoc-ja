```julia
spzeros([type], I::AbstractVector, J::AbstractVector, [m, n])
```

`S` の疎行列を作成します。行列の次元は `m x n` で、構造的なゼロの位置は `S[I[k], J[k]]` です。

このメソッドは行列の疎性パターンの構築に使用でき、たとえば `sparse(I, J, zeros(length(I)))` を使うより効率的です。

詳しいドキュメントとエキスパートドライバーについては、`SparseArrays.spzeros!` を参照してください。

!!! compat "Julia 1.10"
    このメソッドには Julia 1.10 以降が必要です。

