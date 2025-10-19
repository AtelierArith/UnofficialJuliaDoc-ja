```julia
union!(s::IntDisjointSet{T}, x::T, y::T)
```

`x`を含む部分集合と`y`を含む部分集合を1つにマージし、新しい集合のルートを返します。
