```julia
eps(::Type{T}) where T<:AbstractFloat
eps()
```

浮動小数点型 `T` の *マシンイプシロン* を返します（デフォルトでは `T = Float64`）。これは、1 と `typeof(one(T))` で表現可能な次に大きい値との間のギャップとして定義され、`eps(one(T))` と同等です。（`eps(T)` は `T` の *相対誤差* の上限であるため、[`one`](@ref) のように「次元のない」量です。）

# 例

```jldoctest
julia> eps()
2.220446049250313e-16

julia> eps(Float32)
1.1920929f-7

julia> 1.0 + eps()
1.0000000000000002

julia> 1.0 + eps()/2
1.0
```
