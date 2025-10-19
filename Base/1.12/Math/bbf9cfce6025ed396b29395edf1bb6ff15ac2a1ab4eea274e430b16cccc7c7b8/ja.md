```julia
cbrt(x::Real)
```

`x`の立方根を返します。すなわち、$x^{1/3}$です。負の値も受け付けます（$x < 0$のときは負の実数の根を返します）。

接頭辞演算子`∛`は`cbrt`と同等です。

# 例

```jldoctest
julia> cbrt(big(27))
3.0

julia> cbrt(big(-27))
-3.0
```
