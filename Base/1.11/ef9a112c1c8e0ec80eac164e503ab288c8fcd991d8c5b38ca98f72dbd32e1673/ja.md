```
\(x, y)
```

左除算演算子：`x` の逆数による `y` の左側の乗算。整数引数に対して浮動小数点結果を返します。

# 例

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
