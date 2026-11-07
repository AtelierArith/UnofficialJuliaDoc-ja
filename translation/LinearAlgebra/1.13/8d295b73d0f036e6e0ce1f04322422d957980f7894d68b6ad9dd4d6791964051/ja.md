```julia
fzeropreserving(bc) -> Bool
```

構造化された引数の構造的ゼロに対して、ブロードキャストされた関数呼び出しの評価結果がゼロになる場合は true を返します。

`bc::Number` のような自明なブロードキャスト値の場合、これは `iszero(bc)` に帰着します。
