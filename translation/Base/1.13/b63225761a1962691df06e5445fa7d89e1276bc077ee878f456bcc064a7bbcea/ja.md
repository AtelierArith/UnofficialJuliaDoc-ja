```julia
isreal(x)::Bool
```

`x` またはそのすべての要素が、無限大や NaN を含む実数のいずれかと数値的に等しいかどうかを判定します。`isequal(x, real(x))` が true の場合、`isreal(x)` は true です。

# Examples

```jldoctest
julia> isreal(5.)
true

julia> isreal(1 - 3im)
false

julia> isreal(Inf + 0im)
true

julia> isreal([4.; complex(0,1)])
false
```
