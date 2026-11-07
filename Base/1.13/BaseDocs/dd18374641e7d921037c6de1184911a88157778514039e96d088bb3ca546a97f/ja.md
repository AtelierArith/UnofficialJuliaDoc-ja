```julia
UndefInitializer
```

配列の初期化に使われるシングルトン型。配列コンストラクターの呼び出し元が未初期化の配列を要求していることを示します。[`undef`](@ref)（`UndefInitializer()`の別名）も参照してください。

# Examples

```julia-repl
julia> Array{Float64, 1}(UndefInitializer(), 3)
3-element Vector{Float64}:
 2.2752528595e-314
 2.202942107e-314
 2.275252907e-314
```
