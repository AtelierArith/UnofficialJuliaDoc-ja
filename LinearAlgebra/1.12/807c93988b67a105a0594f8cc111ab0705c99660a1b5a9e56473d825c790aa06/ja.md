```julia
normalize!(a::AbstractArray, p::Real=2)
```

配列 `a` をインプレースで正規化し、その `p`-ノルムが1に等しくなるようにします。すなわち、`norm(a, p) == 1` です。詳細は [`normalize`](@ref) および [`norm`](@ref) を参照してください。
