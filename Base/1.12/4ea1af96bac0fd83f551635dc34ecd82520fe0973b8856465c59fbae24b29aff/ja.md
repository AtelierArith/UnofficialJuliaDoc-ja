```julia
isreal(x) -> Bool
```

`x` またはそのすべての要素が無限大やNaNを含む実数に数値的に等しいかどうかをテストします。 `isreal(x)` は `isequal(x, real(x))` が真である場合に真です。

# 例

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
