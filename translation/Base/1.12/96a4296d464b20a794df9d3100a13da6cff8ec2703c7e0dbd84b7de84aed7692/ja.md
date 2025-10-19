```julia
digits([T<:Integer], n::Integer; base::T = 10, pad::Integer = 1)
```

指定された基数での `n` の桁を持つ要素型 `T`（デフォルトは `Int`）の配列を返します。オプションで、指定されたサイズにゼロでパディングすることができます。より重要な桁は高いインデックスにあり、`n == sum(digits[k]*base^(k-1) for k in 1:length(digits))` となります。

他にも [`ndigits`](@ref)、[`digits!`](@ref)、および基数 2 の場合は [`bitstring`](@ref)、[`count_ones`](@ref) も参照してください。

# 例

```jldoctest
julia> digits(10)
2-element Vector{Int64}:
 0
 1

julia> digits(10, base = 2)
4-element Vector{Int64}:
 0
 1
 0
 1

julia> digits(-256, base = 10, pad = 5)
5-element Vector{Int64}:
 -6
 -5
 -2
  0
  0

julia> n = rand(-999:999);

julia> n == evalpoly(13, digits(n, base = 13))
true
```
