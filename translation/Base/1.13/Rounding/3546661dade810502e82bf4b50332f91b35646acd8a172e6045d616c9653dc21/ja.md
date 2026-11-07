```julia
RoundFromZero
```

ゼロから遠ざかる方向に丸めます。

!!! compat "Julia 1.9"
    `RoundFromZero` を使用するには、Julia 1.9 以降が必要です。それ以前のバージョンでは、`BigFloat` に対してのみ `RoundFromZero` がサポートされています。


# Examples

```jldoctest
julia> BigFloat("1.0000000000000001", 5, RoundFromZero)
1.06
```
