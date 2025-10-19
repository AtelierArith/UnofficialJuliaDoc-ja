```julia
summary(io::IO, x)
str = summary(x)
```

ストリーム `io` に出力するか、値の簡単な説明を与える文字列 `str` を返します。デフォルトでは `string(typeof(x))` を返します。例えば、[`Int64`](@ref) のように。

配列の場合、サイズと型情報の文字列を返します。例えば、`10-element Vector{Int64}` や `9×4×5 Array{Float64, 3}` のようになります。

# 例

```jldoctest
julia> summary(1)
"Int64"

julia> summary(zeros(2))
"2-element Vector{Float64}"
```
