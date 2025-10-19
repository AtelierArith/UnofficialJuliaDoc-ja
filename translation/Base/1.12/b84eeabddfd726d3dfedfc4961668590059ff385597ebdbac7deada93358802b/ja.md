```julia
@allocations
```

式を評価し、結果の値を破棄し、代わりに式の評価中に行われた合計のアロケーション数を返すマクロです。

他にも [`@allocated`](@ref)、[`@time`](@ref)、[`@timev`](@ref)、[`@timed`](@ref)、および [`@elapsed`](@ref) を参照してください。

```julia-repl
julia> @allocations rand(10^6)
2
```

!!! compat "Julia 1.9"
    このマクロはJulia 1.9で追加されました。

