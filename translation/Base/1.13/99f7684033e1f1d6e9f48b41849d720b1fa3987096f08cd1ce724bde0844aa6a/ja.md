```julia
@allocations
```

式を評価し、その結果の値を破棄して、式の評価中に発生した割り当ての総数を返すマクロです。

関連項目: [`@allocated`](@ref)、[`@time`](@ref)、[`@timev`](@ref)、[`@timed`](@ref)、[`@elapsed`](@ref)。

```julia-repl
julia> @allocations rand(10^6)
2
```

!!! compat "Julia 1.9"
    このマクロは Julia 1.9 で追加されました。

