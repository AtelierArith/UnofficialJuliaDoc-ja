```julia
float(A::AbstractArray)
```

配列 `A` の各要素に対応する浮動小数点数を含む配列を返します。

`float.(A)` と同等ですが、出力型 `T` に対する `convert(T, A)` の動作に応じて、戻り値が `A` の全体または一部とメモリを共有する場合があります。

# Examples

```jldoctest
julia> float(1:1000)
1.0:1.0:1000.0
```
