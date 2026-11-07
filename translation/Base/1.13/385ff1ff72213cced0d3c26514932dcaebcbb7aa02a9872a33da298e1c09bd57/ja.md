```julia
unsafe_trunc(T, x)
```

`T`型で、絶対値が`x`の絶対値以下となる最も近い整数値を返します。値を`T`で表現できない場合、任意の値が返されます。[`trunc`](@ref)も参照してください。

# Examples

```jldoctest
julia> unsafe_trunc(Int, -2.2)
-2

julia> unsafe_trunc(Int, NaN) isa Int
true
```
