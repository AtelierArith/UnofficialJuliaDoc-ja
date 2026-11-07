```julia
IEEEFloatOptimization(next) isa Base.Sort.Algorithm
```

NaN値を末尾に移動し、符号で分割したうえで、残りを符号なし整数として再解釈します。

IEEE浮動小数点数（`Float64`、`Float32`、`Float16`）は、いくつかの例外を除き、ビット列を符号なし整数として比較した場合と同じ順序で比較されます。このパスは

このパスは、`sort([1.0, NaN, 3.0])`と`sortperm([1.0, NaN, 3.0])`の両方で実行されます。
