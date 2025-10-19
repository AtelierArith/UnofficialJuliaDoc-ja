```julia
eigvals!(A, B; sortby) -> values
```

[`eigvals`](@ref) と同様ですが、コピーを作成するのではなく、入力 `A`（および `B`）を上書きすることでスペースを節約します。

!!! note
    `eigvals!` が呼び出された後、入力行列 `A` と `B` はその固有値を含まなくなります。これらは作業スペースとして使用されます。


# 例

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
