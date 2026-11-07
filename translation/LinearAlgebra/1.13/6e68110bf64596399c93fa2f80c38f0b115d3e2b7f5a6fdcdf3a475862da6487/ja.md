```julia
eigvals!(A; permute::Bool=true, scale::Bool=true, sortby) -> values
```

[`eigvals`](@ref)と同じですが、コピーを作成せず、入力の`A`を上書きすることで、メモリを節約します。`permute`、`scale`、`sortby`の各キーワードは、[`eigen`](@ref)の場合と同じです。

!!! note
    `eigvals!`を呼び出すと、入力行列`A`には固有値が残りません。ワークスペースとして`A`が使用されます。


# Examples

```jldoctest
julia> A = [1. 2.; 3. 4.]
2×2 Matrix{Float64}:
 1.0  2.0
 3.0  4.0

julia> eigvals!(A)
2-element Vector{Float64}:
 -0.3722813232690143
  5.372281323269014

julia> A
2×2 Matrix{Float64}:
 -0.372281  -1.0
  0.0        5.37228
```
