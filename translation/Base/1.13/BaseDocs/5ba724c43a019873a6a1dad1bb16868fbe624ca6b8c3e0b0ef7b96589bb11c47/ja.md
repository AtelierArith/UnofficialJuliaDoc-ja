```julia
undef
```

`UndefInitializer()`の別名です。これはシングルトン型[`UndefInitializer`](@ref)のインスタンスを構築します。配列の初期化時に、配列コンストラクターの呼び出し元が未初期化の配列を要求していることを示すために使用されます。

関連項目: [`missing`](@ref)、[`similar`](@ref)。

# Examples

```julia-repl
julia> Array{Float64, 1}(undef, 3)
3-element Vector{Float64}:
 2.2752528595e-314
 2.202942107e-314
 2.275252907e-314
```
