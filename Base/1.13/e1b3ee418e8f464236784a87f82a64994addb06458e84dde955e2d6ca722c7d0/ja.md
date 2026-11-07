```julia
parse(type, str; base)
```

文字列を数値として解析します。`Integer` 型では基数を指定できます（既定値は 10 です）。浮動小数点型の場合、文字列は 10 進浮動小数点数として解析されます。`Complex` 型では、`"R±Iim"` 形式の 10 進文字列を、要求された型の `Complex(R,I)` として解析します。`"im"` の代わりに `"i"` または `"j"` を使用することもでき、`"R"` または `"Iim"` も使用できます。文字列に有効な数値が含まれていない場合は、エラーが発生します。

!!! compat "Julia 1.1"
    `parse(Bool, str)` を使用するには、Julia 1.1 以降が必要です。


# Examples

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
