```julia
normalize!(a::AbstractArray, p::Real=2)
```

配列 `a` をインプレースで正規化し、その `p` ノルムが 1 になるようにします。つまり、`norm(a, p) == 1` です。[`normalize`](@ref) と [`norm`](@ref) も参照してください。
