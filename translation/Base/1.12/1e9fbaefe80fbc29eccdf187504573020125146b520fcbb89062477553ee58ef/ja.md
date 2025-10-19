```julia
clamp(x, lo, hi)
```

`lo <= x <= hi` の場合は `x` を返します。`x > hi` の場合は `hi` を返します。`x < lo` の場合は `lo` を返します。引数は共通の型に昇格されます。

他にも [`clamp!`](@ref), [`min`](@ref), [`max`](@ref) を参照してください。

!!! compat "Julia 1.3"
    最初の引数に `missing` を指定するには、少なくとも Julia 1.3 が必要です。


# 例

```jldoctest
julia> clamp.([pi, 1.0, big(10)], 2.0, 9.0)
3-element Vector{BigFloat}:
 3.141592653589793238462643383279502884197169399375105820974944592307816406286198
 2.0
 9.0

julia> clamp.([11, 8, 5], 10, 6)  # lo > hi の例
3-element Vector{Int64}:
  6
  6
 10
```
