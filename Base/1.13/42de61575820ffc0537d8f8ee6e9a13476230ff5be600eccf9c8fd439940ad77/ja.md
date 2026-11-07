```julia
checkbounds_indices(Bool, IA, I)
```

タプル `I` 内の「要求された」インデックスが、タプル `IA` で指定された「許可された」インデックスの範囲内にある場合、`true` を返します。この関数は、通常は1対1の対応で、これらのタプルの要素を再帰的に処理します。

```julia
checkbounds_indices(Bool, (IA1, IA...), (I1, I...)) = checkindex(Bool, IA1, I1) &
                                                      checkbounds_indices(Bool, IA, I)
```

配列の1つの次元に対する実際の境界チェックには、[`checkindex`](@ref) が使われていることに注意してください。

1対1の規則には、重要な例外が2つあります。線形インデックスと CartesianIndex{N} は、`IA` の要素を複数消費することがあります。

[`checkbounds`](@ref) も参照してください。
