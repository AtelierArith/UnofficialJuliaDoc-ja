```julia
summary(io::IO, x)
str = summary(x)
```

値の簡単な説明をストリーム `io` に出力するか、文字列 `str` として返します。デフォルトでは `string(typeof(x))` を返します。例：[`Int64`](@ref)。

配列の場合は、サイズと型の情報を含む文字列を返します。例：`10-element Vector{Int64}` または `9×4×5 Array{Float64, 3}`。

# Examples

```jldoctest
julia> summary(1)
"Int64"

julia> summary(zeros(2))
"2-element Vector{Float64}"
```
