```
@allocated
```

式を評価し、結果の値を破棄して、式の評価中に割り当てられた合計バイト数を返すマクロです。

他に [`@allocations`](@ref)、[`@time`](@ref)、[`@timev`](@ref)、[`@timed`](@ref)、および [`@elapsed`](@ref) も参照してください。

```julia-repl
julia> @allocated rand(10^6)
8000080
```
