```julia
\(x, y)
```

左除算演算子：`y` の逆元を左から `x` に乗算します。整数の引数に対しては、浮動小数点数の結果を返します。

# Examples

```jldoctest
julia> 3 \ 6
2.0

julia> inv(3) * 6
2.0

julia> A = [4 3; 2 1]; x = [5, 6];

julia> A \ x
2-element Vector{Float64}:
  6.5
 -7.0

julia> inv(A) * x
2-element Vector{Float64}:
  6.5
 -7.0
```
