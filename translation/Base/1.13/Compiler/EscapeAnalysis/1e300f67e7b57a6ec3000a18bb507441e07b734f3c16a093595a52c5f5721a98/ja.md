```julia
find_root!(s::IntDisjointSet{T}, x::T)
```

`x`を含む部分集合の根要素を見つけます。ここで経路圧縮が行われます。
