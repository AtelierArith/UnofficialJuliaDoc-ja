```julia
normalize!(a::AbstractArray, p::Real=2)
```

配列 `a` をインプレースで正規化し、その `p` ノルムを 1 にします。つまり、`norm(a, p) == 1` です。[`normalize`](@ref) と [`norm`](@ref) も参照してください。
