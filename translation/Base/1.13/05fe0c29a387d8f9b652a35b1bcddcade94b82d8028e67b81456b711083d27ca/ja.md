```julia
digits([T<:Integer], n::Integer; base::T = 10, pad::Integer = 1)
```

指定した基数で表した `n` の各桁を、要素型 `T`（既定値は `Int`）の配列として返します。必要に応じて、指定したサイズになるようゼロでパディングできます。上位の桁ほどインデックスが大きくなり、`n == sum(digits[k]*base^(k-1) for k in 1:length(digits))` となります。

関連項目: [`ndigits`](@ref)、[`digits!`](@ref)。また、基数 2 の場合は [`bitstring`](@ref)、[`count_ones`](@ref)。

# Examples

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
