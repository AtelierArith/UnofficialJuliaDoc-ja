```julia
parse(type, str; base)
```

文字列を数値として解析します。`Integer` 型の場合、基数を指定できます（デフォルトは 10 です）。浮動小数点型の場合、文字列は10進浮動小数点数として解析されます。`Complex` 型は、形式 `"R±Iim"` の10進文字列から `Complex(R,I)` の要求された型として解析されます； `"i"` または `"j"` も `"im"` の代わりに使用でき、`"R"` または `"Iim"` も許可されています。文字列に有効な数値が含まれていない場合、エラーが発生します。

!!! compat "Julia 1.1"
    `parse(Bool, str)` は少なくとも Julia 1.1 が必要です。


# 例

```jldoctest
julia> parse(Int, "1234")
1234

julia> parse(Int, "1234", base = 5)
194

julia> parse(Int, "afc", base = 16)
2812

julia> parse(Float64, "1.2e-3")
0.0012

julia> parse(Complex{Float64}, "3.2e-1 + 4.5im")
0.32 + 4.5im
```
