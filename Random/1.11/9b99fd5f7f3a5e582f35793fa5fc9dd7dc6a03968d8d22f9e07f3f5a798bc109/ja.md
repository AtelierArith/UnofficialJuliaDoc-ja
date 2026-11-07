```julia
randperm!([rng=default_rng(),] A::AbstractArray{<:Integer})
```

`A`で、長さ`length(A)`のランダムな順列を生成します。省略可能な`rng`引数では、乱数生成器を指定します（[Random Numbers](@ref)を参照）。任意のベクトルをランダムに並べ替える方法については、[`shuffle`](@ref)または[`shuffle!`](@ref)を参照してください。

!!! compat "Julia 1.13"
    Julia v1.13より前では、`A isa Array`が必須でした。


# Examples

```jldoctest
julia> randperm!(Xoshiro(0), Vector{Int}(undef, 6))
6-element Vector{Int64}:
 5
 1
 2
 6
 3
 4
```
