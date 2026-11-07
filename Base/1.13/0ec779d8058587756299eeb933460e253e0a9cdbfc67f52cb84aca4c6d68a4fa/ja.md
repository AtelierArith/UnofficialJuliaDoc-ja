```julia
argmax(f, domain)
```

`domain`の中から、`f(x)`が最大となる`x`を返します。`f(x)`が最大値を複数持つ場合は、最初の値が見つかります。

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
