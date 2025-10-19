```julia
argmin(f, domain)
```

`f(x)` が最小化される `domain` からの値 `x` を返します。`f(x)` の最小値が複数ある場合は、最初のものが見つかります。

`domain` は空でない iterable でなければなりません。

`NaN` は `missing` を除くすべての値よりも小さいと見なされます。

!!! compat "Julia 1.7"
    このメソッドは Julia 1.7 以降が必要です。


関連情報として [`argmax`](@ref)、[`findmin`](@ref) を参照してください。

# 例

```jldoctest
julia> argmin(sign, -10:5)
-10

julia> argmin(x -> -x^3 + x^2 - 10, -5:5)
5

julia> argmin(acos, 0:0.1:1)
1.0
```
