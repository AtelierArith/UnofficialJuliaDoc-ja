```julia
eigvals!(A, B; sortby) -> values
```

[`eigvals`](@ref)と同じですが、コピーを作成する代わりに入力の`A`（および`B`）を上書きすることで、必要なメモリを節約します。

!!! note
    `eigvals!`を呼び出した後、入力行列`A`および`B`には固有値が残りません。これらの行列は作業領域として使用されます。


# Examples

```jldoctest
julia> A = [1. 0.; 0. -1.]
2×2 Matrix{Float64}:
 1.0   0.0
 0.0  -1.0

julia> B = [0. 1.; 1. 0.]
2×2 Matrix{Float64}:
 0.0  1.0
 1.0  0.0

julia> eigvals!(A, B)
2-element Vector{ComplexF64}:
 0.0 - 1.0im
 0.0 + 1.0im

julia> A
2×2 Matrix{Float64}:
 -0.0  -1.0
  1.0  -0.0

julia> B
2×2 Matrix{Float64}:
 1.0  0.0
 0.0  1.0
```
