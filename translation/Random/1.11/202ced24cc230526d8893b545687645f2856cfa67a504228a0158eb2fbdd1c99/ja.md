```julia
randexp([rng=default_rng()], [T=Float64], [dims...])
```

指数分布（スケール 1）に従う `T` 型の乱数を生成します。必要に応じて、そのような乱数の配列も生成できます。現在、`Base` モジュールは、[`Float16`](@ref)、[`Float32`](@ref)、および [`Float64`](@ref)（デフォルト）の各型に対する実装を提供しています。

# Examples

```jldoctest
julia> rng = Xoshiro(123);

julia> randexp(rng, Float32)
1.1757717f0

julia> randexp(rng, 3, 3)
3×3 Matrix{Float64}:
 1.37766  0.456653  0.236418
 3.40007  0.229917  0.0684921
 0.48096  0.577481  0.71835
```
