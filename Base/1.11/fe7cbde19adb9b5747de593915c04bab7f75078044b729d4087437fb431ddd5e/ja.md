```
VecOrMat{T}
```

[`Vector{T}`](@ref) と [`Matrix{T}`](@ref) のユニオン型で、関数が行列またはベクトルのいずれかを受け入れることを可能にします。

# 例

```jldoctest
julia> Vector{Float64} <: VecOrMat{Float64}
true

julia> Matrix{Float64} <: VecOrMat{Float64}
true

julia> Array{Float64, 3} <: VecOrMat{Float64}
false
```
