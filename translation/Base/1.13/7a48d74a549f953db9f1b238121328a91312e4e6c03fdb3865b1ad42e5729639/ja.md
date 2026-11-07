```julia
hi, lo = splitprec(F::Type{<:AbstractFloat}, i::Integer)
```

整数 `i` を、次の条件を満たす浮動小数点数のペア `hi` と `lo`（型は `F`）として表します。

  * `widen(hi) + widen(lo) ≈ i`。`F` の仮数部のビット数の1.5倍が、`i` のビット数を上回る場合、正確です。
  * `hi` のすべてのビットが、`lo` のどのビットよりも上位にある。
  * `hi` は、`splitprec` の別の呼び出しにおける `hi` 成分と正確に乗算できる。

特に、Float64 の精度は53ビットしかないため `convert(Float64, i)` は誤差を伴う場合がありますが、`splitprec(Float64, i)` は任意の Int64/UInt64 に対して正確です。
