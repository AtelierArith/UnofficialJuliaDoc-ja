```julia
in_same_set(s::IntDisjointSet{T}, x::T, y::T)
```

`x`と`y`が`s`内の同じ部分集合に属する場合は`true`を返し、そうでない場合は`false`を返します。
