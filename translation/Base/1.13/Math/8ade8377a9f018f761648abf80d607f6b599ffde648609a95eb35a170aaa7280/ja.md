```julia
cbrt(x::Real)
```

`x` の立方根を返します。つまり、``x^{1/3}`` です。負の値も受け付けます（``x < 0`` の場合は、負の実数の立方根を返します）。

前置演算子 `∛` は、`cbrt` と同等です。

# Examples

```jldoctest
julia> cbrt(big(27))
3.0

julia> cbrt(big(-27))
-3.0
```
