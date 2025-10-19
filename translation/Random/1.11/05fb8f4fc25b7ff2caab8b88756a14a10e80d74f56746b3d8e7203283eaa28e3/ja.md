```julia
randexp([rng=default_rng()], [T=Float64], [dims...])
```

スケール1の指数分布に従って、型`T`のランダムな数を生成します。オプションで、そのようなランダムな数の配列を生成します。`Base`モジュールは現在、[`Float16`](@ref)、[`Float32`](@ref)、および[`Float64`](@ref)（デフォルト）の型に対する実装を提供しています。

# 例

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
