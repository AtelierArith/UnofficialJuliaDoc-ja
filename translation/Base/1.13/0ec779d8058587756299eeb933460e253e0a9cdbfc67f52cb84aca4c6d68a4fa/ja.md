```julia
argmax(f, domain)
```

`domain`の中から、`f(x)`が最大となる値`x`を返します。最大値となる`f(x)`が複数ある場合は、最初に見つかったものを返します。

`domain`は空でない反復可能オブジェクトでなければなりません。

値は`isless`で比較されます。

!!! compat "Julia 1.7"
    このメソッドを使用するには、Julia 1.7以降が必要です。


関連項目: [`argmin`](@ref)、[`findmax`](@ref)。

# Examples

```jldoctest
julia> argmax(abs, -10:5)
-10

julia> argmax(cos, 0:π/2:2π)
0.0
```
