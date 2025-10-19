```julia
tanh(x)
```

`x`の双曲線正接を計算します。

関連項目としては [`tan`](@ref)、[`atanh`](@ref) があります。

# 例

```jldoctest
julia> tanh.(-3:3f0)  # ここで 3f0 は Float32 です
7-element Vector{Float32}:
 -0.9950548
 -0.9640276
 -0.7615942
  0.0
  0.7615942
  0.9640276
  0.9950548

julia> tan.(im .* (1:3))
3-element Vector{ComplexF64}:
 0.0 + 0.7615941559557649im
 0.0 + 0.9640275800758169im
 0.0 + 0.9950547536867306im
```
