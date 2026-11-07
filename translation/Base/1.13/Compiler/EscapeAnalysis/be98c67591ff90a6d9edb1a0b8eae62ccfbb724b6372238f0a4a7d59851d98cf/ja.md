```julia
irval(xidx::Int, estate::EscapeState) -> x::Union{Argument,SSAValue}
```

一意の識別番号 `xidx` を、`estate` のコンテキストで解析可能な元の IR 要素 `x::Union{Argument,SSAValue}` に変換します。

`iridx` は `irval` の逆関数（厳密な意味ではありません）、すなわち `iridx(irval(xidx, state), state) === xidx` です。
